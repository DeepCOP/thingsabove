create or replace function public.stop_plan_progress(p_progress_id uuid)
returns void
language plpgsql
security invoker
set search_path = pg_catalog, public
as $$
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  delete from public.day_items_progress
  where progress_id = p_progress_id
    and user_id = auth.uid();

  delete from public.plan_progress
  where id = p_progress_id
    and user_id = auth.uid();

  if not found then
    raise exception 'Plan progress not found for current user';
  end if;
end;
$$;


drop policy if exists "users can delete their own progress" on public.plan_progress;

create policy "users can delete their own progress"
  on public.plan_progress
  for delete
  using (auth.uid() = user_id);
