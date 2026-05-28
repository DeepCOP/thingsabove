create table if not exists public.church_invite_links (
  id uuid primary key default gen_random_uuid(),
  church_id uuid not null references public.churches(id) on delete cascade,
  invited_by uuid not null references public.profiles(id) on delete cascade,
  invite_code text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (church_id, invited_by),
  unique (invite_code),
  constraint church_invite_links_invite_code_format
    check (invite_code ~ '^[a-z0-9]{6,32}$')
);

alter table public.church_invite_links enable row level security;

drop trigger if exists set_church_invite_links_updated_at on public.church_invite_links;
create trigger set_church_invite_links_updated_at
before update on public.church_invite_links
for each row
execute function public.set_updated_at();

create or replace function public.invite_code_exists(p_invite_code text)
returns boolean
language sql
security definer
set search_path = pg_catalog, public
as $$
  select exists (
    select 1
    from public.plan_groups pg
    where pg.invite_code = lower(btrim(p_invite_code))
  )
  or exists (
    select 1
    from public.church_invite_links cil
    where cil.invite_code = lower(btrim(p_invite_code))
  );
$$;

create or replace function public.set_plan_group_invite_code()
returns trigger
language plpgsql
set search_path = pg_catalog, public
as $$
declare
  v_attempt integer;
begin
  if new.invite_code is not null and btrim(new.invite_code) <> '' then
    new.invite_code := lower(btrim(new.invite_code));

    if new.invite_code !~ '^[a-z0-9]{6,32}$' then
      raise exception 'Invite code must be 6-32 lowercase letters or numbers';
    end if;

    if exists (
      select 1
      from public.church_invite_links cil
      where cil.invite_code = new.invite_code
    ) then
      raise exception 'Invite code already exists';
    end if;

    return new;
  end if;

  for v_attempt in 1..12 loop
    new.invite_code := public.generate_plan_invite_code();

    exit when not exists (
      select 1
      from public.plan_groups pg
      where pg.invite_code = new.invite_code
        and pg.id is distinct from new.id
    )
    and not exists (
      select 1
      from public.church_invite_links cil
      where cil.invite_code = new.invite_code
    );
  end loop;

  if exists (
    select 1
    from public.plan_groups pg
    where pg.invite_code = new.invite_code
      and pg.id is distinct from new.id
  )
  or exists (
    select 1
    from public.church_invite_links cil
    where cil.invite_code = new.invite_code
  ) then
    raise exception 'Unable to generate a unique invite code';
  end if;

  return new;
end;
$$;

create or replace function public.get_or_create_church_invite_code(p_church_id uuid)
returns text
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_code text;
  v_existing_code text;
  v_attempt integer;
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  if not exists (
    select 1
    from public.profiles p
    where p.id = auth.uid()
      and p.church_id = p_church_id
  ) then
    raise exception 'Only church members can create church invite links';
  end if;

  select cil.invite_code
  into v_existing_code
  from public.church_invite_links cil
  where cil.church_id = p_church_id
    and cil.invited_by = auth.uid();

  if v_existing_code is not null then
    return v_existing_code;
  end if;

  for v_attempt in 1..12 loop
    v_code := public.generate_plan_invite_code();

    continue when public.invite_code_exists(v_code);

    begin
      insert into public.church_invite_links (
        church_id,
        invited_by,
        invite_code
      )
      values (
        p_church_id,
        auth.uid(),
        v_code
      )
      returning invite_code into v_existing_code;

      return v_existing_code;
    exception
      when unique_violation then
        select cil.invite_code
        into v_existing_code
        from public.church_invite_links cil
        where cil.church_id = p_church_id
          and cil.invited_by = auth.uid();

        if v_existing_code is not null then
          return v_existing_code;
        end if;

        v_existing_code := null;
    end;
  end loop;

  raise exception 'Unable to generate a unique invite code';
end;
$$;

create or replace function public.resolve_church_invite_code(p_invite_code text)
returns table(
  invite_code text,
  church_id uuid,
  invited_by uuid
)
language sql
security definer
set search_path = pg_catalog, public
as $$
  select
    cil.invite_code,
    cil.church_id,
    cil.invited_by
  from public.church_invite_links cil
  join public.churches c
    on c.id = cil.church_id
  join public.profiles p
    on p.id = cil.invited_by
   and p.church_id = cil.church_id
  where cil.invite_code = lower(btrim(p_invite_code));
$$;

create or replace function public.create_plan_group(
  p_user_id uuid,
  p_plan_id uuid,
  p_start_date date,
  p_friends_ids uuid[]
)
returns public.plan_progress
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_plan public.devotional_plans%rowtype;
  v_group_id uuid;
  v_invite_code text;
  v_progress_id uuid;
  v_progress public.plan_progress;
  v_attempt integer;
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  if auth.uid() <> p_user_id then
    raise exception 'You can only create plan groups for yourself';
  end if;

  select *
  into v_plan
  from public.devotional_plans
  where id = p_plan_id;

  if not found or v_plan.status <> 'published' then
    raise exception 'Plan not found';
  end if;

  if coalesce(v_plan.visibility, 'public') = 'private'
     and v_plan.author_id is distinct from auth.uid() then
    raise exception 'Only the plan author can create a private group';
  end if;

  for v_attempt in 1..12 loop
    v_invite_code := public.generate_plan_invite_code();

    continue when public.invite_code_exists(v_invite_code);

    begin
      insert into public.plan_groups (
        plan_id,
        created_by,
        start_date,
        invite_code
      )
      values (
        p_plan_id,
        p_user_id,
        p_start_date,
        v_invite_code
      )
      returning id into v_group_id;

      exit;
    exception
      when unique_violation then
        v_group_id := null;
    end;
  end loop;

  if v_group_id is null then
    raise exception 'Unable to generate a unique invite code';
  end if;

  insert into public.plan_group_members (
    group_id,
    user_id,
    status,
    joined_at
  )
  values (
    v_group_id,
    p_user_id,
    'accepted',
    now()
  );

  insert into public.plan_progress (
    user_id,
    plan_id,
    group_id,
    current_day,
    completed_days,
    start_date
  )
  values (
    p_user_id,
    p_plan_id,
    v_group_id,
    1,
    '{}',
    p_start_date
  )
  on conflict (user_id, plan_id, group_id) do nothing;

  select id into v_progress_id
  from public.plan_progress
  where user_id = p_user_id
    and plan_id = p_plan_id
    and group_id = v_group_id;

  insert into public.plan_group_members (group_id, user_id, status)
  select v_group_id, unnest(p_friends_ids), 'pending'
  on conflict (group_id, user_id) do nothing;

  perform public.create_notification(
    p_friends_ids,
    'plan_invite',
    'Plan Invitation',
    'You were invited to read a plan with friends',
    jsonb_build_object(
      'plan_id', p_plan_id,
      'group_id', v_group_id,
      'invited_by', auth.uid()
    )
  );

  select *
  into v_progress
  from public.plan_progress
  where id = v_progress_id;

  return v_progress;
end;
$$;
