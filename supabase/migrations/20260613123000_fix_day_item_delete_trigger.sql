create or replace function public.touch_plan_progress_from_day_item()
returns trigger
language plpgsql
as $$
declare
  v_progress_id uuid;
begin
  if tg_op = 'DELETE' then
    return old;
  end if;

  v_progress_id := new.progress_id;

  if v_progress_id is not null then
    update public.plan_progress
    set updated_at = now()
    where id = v_progress_id;
  end if;

  return new;
end;
$$;
