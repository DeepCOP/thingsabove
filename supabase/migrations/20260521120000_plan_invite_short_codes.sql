alter table public.plan_groups
  add column if not exists invite_code text;

create or replace function public.generate_plan_invite_code(p_length integer default 8)
returns text
language plpgsql
set search_path = pg_catalog, public, extensions
as $$
declare
  v_alphabet constant text := '23456789abcdefghijkmnopqrstuvwxyz';
  v_alphabet_length integer := length(v_alphabet);
  v_bytes bytea;
  v_code text := '';
  v_index integer;
begin
  if p_length < 6 or p_length > 32 then
    raise exception 'Invite code length must be between 6 and 32 characters';
  end if;

  v_bytes := gen_random_bytes(p_length);

  for v_index in 0..(p_length - 1) loop
    v_code := v_code || substr(
      v_alphabet,
      (get_byte(v_bytes, v_index) % v_alphabet_length) + 1,
      1
    );
  end loop;

  return v_code;
end;
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

    return new;
  end if;

  for v_attempt in 1..12 loop
    new.invite_code := public.generate_plan_invite_code();

    exit when not exists (
      select 1
      from public.plan_groups pg
      where pg.invite_code = new.invite_code
        and pg.id is distinct from new.id
    );
  end loop;

  if exists (
    select 1
    from public.plan_groups pg
    where pg.invite_code = new.invite_code
      and pg.id is distinct from new.id
  ) then
    raise exception 'Unable to generate a unique invite code';
  end if;

  return new;
end;
$$;

drop trigger if exists set_plan_group_invite_code on public.plan_groups;
create trigger set_plan_group_invite_code
before insert or update of invite_code on public.plan_groups
for each row
execute function public.set_plan_group_invite_code();

create unique index if not exists plan_groups_invite_code_idx
  on public.plan_groups (invite_code);

update public.plan_groups
set invite_code = null
where invite_code is null;

alter table public.plan_groups
  alter column invite_code set not null;

alter table public.plan_groups
  add constraint plan_groups_invite_code_format
  check (invite_code ~ '^[a-z0-9]{6,32}$')
  not valid;

alter table public.plan_groups
  validate constraint plan_groups_invite_code_format;

create or replace function public.get_plan_group_invite_code(p_group_id uuid)
returns text
language sql
security definer
set search_path = pg_catalog, public
as $$
  select pg.invite_code
  from public.plan_groups pg
  join public.devotional_plans dp
    on dp.id = pg.plan_id
  where pg.id = p_group_id
    and dp.status = 'published'
    and (
      pg.created_by = auth.uid()
      or public.is_group_member(pg.id)
      or dp.author_id = auth.uid()
    )
  limit 1;
$$;

create or replace function public.resolve_plan_group_invite_code(p_invite_code text)
returns table(
  invite_code text,
  group_id uuid,
  plan_id uuid,
  invited_by uuid
)
language sql
security definer
set search_path = pg_catalog, public
as $$
  select
    pg.invite_code,
    pg.id as group_id,
    pg.plan_id,
    pg.created_by as invited_by
  from public.plan_groups pg
  join public.devotional_plans dp
    on dp.id = pg.plan_id
  where pg.invite_code = lower(btrim(p_invite_code))
    and dp.status = 'published';
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
