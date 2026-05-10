alter table public.notification_preferences
add column if not exists group_day_completed boolean default true;

update public.notification_preferences
set group_day_completed = true
where group_day_completed is null;

create or replace function public.notify_group_plan_day_completed()
returns trigger
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_day_number int;
  v_day_id uuid;
  v_actor_name text;
  v_plan_title text;
begin
  if new.group_id is null or new.user_id is null or new.plan_id is null then
    return new;
  end if;

  if not exists (
    select 1
    from public.plan_group_members pgm
    where pgm.group_id = new.group_id
      and pgm.user_id = new.user_id
      and pgm.status = 'accepted'
  ) then
    return new;
  end if;

  select nullif(btrim(coalesce(p.first_name, '') || ' ' || coalesce(p.last_name, '')), '')
  into v_actor_name
  from public.profiles p
  where p.id = new.user_id;

  select dp.title
  into v_plan_title
  from public.devotional_plans dp
  where dp.id = new.plan_id;

  v_actor_name := coalesce(v_actor_name, 'A group member');
  v_plan_title := coalesce(v_plan_title, 'your plan');

  for v_day_number in
    select distinct next_day.day_number
    from unnest(coalesce(new.completed_days, '{}'::int[])) as next_day(day_number)
    where not (next_day.day_number = any(coalesce(old.completed_days, '{}'::int[])))
  loop
    select dd.id
    into v_day_id
    from public.devotional_days dd
    where dd.plan_id = new.plan_id
      and dd.day_number = v_day_number
    limit 1;

    insert into public.notifications (user_id, type, title, body, data)
    select
      pgm.user_id,
      'group_day_completed',
      v_actor_name || ' completed Day ' || v_day_number::text,
      'They finished a day in ' || v_plan_title || '.',
      jsonb_build_object(
        'plan_id', new.plan_id,
        'group_id', new.group_id,
        'progress_id', recipient_progress.id,
        'day_id', v_day_id,
        'day_number', v_day_number,
        'completed_by', new.user_id,
        'completed_by_name', v_actor_name
      )
    from public.plan_group_members pgm
    join public.plan_progress recipient_progress
      on recipient_progress.user_id = pgm.user_id
     and recipient_progress.plan_id = new.plan_id
     and recipient_progress.group_id = new.group_id
    join public.profiles recipient_profile
      on recipient_profile.id = pgm.user_id
    where pgm.group_id = new.group_id
      and pgm.status = 'accepted'
      and pgm.user_id <> new.user_id
      and (
        select count(*)
        from public.notifications existing_notification
        where existing_notification.user_id = pgm.user_id
          and existing_notification.type = 'group_day_completed'
          and existing_notification.data ->> 'group_id' = new.group_id::text
          and existing_notification.created_at >= (
            date_trunc(
              'day',
              now() at time zone coalesce(recipient_profile.timezone, 'UTC')
            ) at time zone coalesce(recipient_profile.timezone, 'UTC')
          )
      ) < 5;
  end loop;

  return new;
end;
$$;
