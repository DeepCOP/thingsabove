drop function if exists public.invite_users_to_church(uuid, uuid[]);
drop function if exists public.decline_church_invite(uuid);

create or replace function public.accept_church_invite(
  p_church_id uuid
)
returns void
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;

  if not exists (
    select 1
    from public.churches
    where id = p_church_id
  ) then
    raise exception 'Church not found';
  end if;

  update public.profiles
  set
    church_id = p_church_id,
    updated_at = now()
  where id = auth.uid();

  if not found then
    raise exception 'Profile not found';
  end if;
end;
$$;

drop table if exists public.church_invitations;
