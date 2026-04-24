create or replace function public.stop_plan_progress(p_progress_id uuid)
returns void
language plpgsql
security invoker
set search_path = pg_catalog, public
as $$
declare
  v_group_id uuid;
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  select group_id
    into v_group_id
  from public.plan_progress
  where id = p_progress_id
    and user_id = auth.uid();

  if not found then
    raise exception 'Plan progress not found for current user';
  end if;

  delete from public.day_items_progress
  where progress_id = p_progress_id
    and user_id = auth.uid();

  delete from public.plan_progress
  where id = p_progress_id
    and user_id = auth.uid();

  if not found then
    raise exception 'Unable to delete plan progress for current user';
  end if;

  if v_group_id is not null then
    delete from public.plan_group_members
    where group_id = v_group_id
      and user_id = auth.uid();
  end if;
end;
$$;


drop policy if exists "users can delete their own progress" on public.plan_progress;

create policy "users can delete their own progress"
  on public.plan_progress
  for delete
  using (auth.uid() = user_id);
