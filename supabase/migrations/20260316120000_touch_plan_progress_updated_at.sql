create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_plan_progress_updated_at on public.plan_progress;
create trigger set_plan_progress_updated_at
  before update on public.plan_progress
  for each row
  execute procedure public.set_updated_at();


create or replace function public.touch_plan_progress_from_day_item()
returns trigger
language plpgsql
as $$
declare
  v_progress_id uuid := coalesce(new.progress_id, old.progress_id);
begin
  if v_progress_id is not null then
    update public.plan_progress
    set updated_at = now()
    where id = v_progress_id;
  end if;

  return coalesce(new, old);
end;
$$;

drop trigger if exists touch_plan_progress_on_day_item on public.day_items_progress;
create trigger touch_plan_progress_on_day_item
  after insert or update or delete on public.day_items_progress
  for each row
  execute procedure public.touch_plan_progress_from_day_item();
