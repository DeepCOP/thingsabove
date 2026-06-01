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


