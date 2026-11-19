alter table public.profiles
  add column preferred_bible_version_id text
  check (preferred_bible_version_id is null or
    (length(preferred_bible_version_id) between 1 and 200 and
     preferred_bible_version_id = btrim(preferred_bible_version_id)));

-- IDs can refer to the offline catalog or an online provider's catalog.
create table public.user_bible_versions (
  user_id uuid not null references public.profiles(id) on delete cascade,
  version_id text not null check (length(version_id) between 1 and 200 and version_id = btrim(version_id)),
  created_at timestamptz not null default now(),
  primary key (user_id, version_id)
);
alter table public.user_bible_versions enable row level security;
create policy "Users manage their own Bible library" on public.user_bible_versions
  for all to authenticated using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));
grant select, insert, update, delete on public.user_bible_versions to authenticated;

-- Apply only changed fields, not a replacement library, so another device's
-- unrelated additions survive. An empty change set simply reads the preferences.
create function public.sync_bible_preferences(
  p_user_id uuid,
  p_preferred_version_id text default null,
  p_added_version_ids text[] default '{}',
  p_removed_version_ids text[] default '{}'
) returns jsonb
language plpgsql security definer set search_path = ''
as $$
declare
  preferred text;
  saved jsonb;
begin
  -- Bind queued requests to the original account even if auth changes in flight.
  if auth.uid() is null or auth.uid() <> p_user_id then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  perform 1 from public.profiles where id = p_user_id for update;
  if not found then raise exception 'Profile not found'; end if;

  if p_preferred_version_id is not null then
    update public.profiles set preferred_bible_version_id = p_preferred_version_id
      where id = p_user_id;
  end if;
  delete from public.user_bible_versions
    where user_id = p_user_id and version_id = any(p_removed_version_ids);
  insert into public.user_bible_versions (user_id, version_id)
    select p_user_id, id from unnest(p_added_version_ids) as ids(id)
    on conflict (user_id, version_id) do nothing;

  select preferred_bible_version_id into preferred from public.profiles where id = p_user_id;
  select coalesce(jsonb_agg(version_id order by version_id), '[]'::jsonb) into saved
    from public.user_bible_versions where user_id = p_user_id;
  return jsonb_build_object('preferredVersionId', preferred, 'savedVersionIds', saved);
end;
$$;
revoke all on function public.sync_bible_preferences(uuid, text, text[], text[]) from public, anon;
grant execute on function public.sync_bible_preferences(uuid, text, text[], text[]) to authenticated;
