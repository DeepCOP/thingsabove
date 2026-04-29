create or replace function public.resolve_ai_trigger_schedule(
  p_timezone text,
  p_day_offset integer,
  p_local_hour integer
)
returns timestamptz
language sql
stable
set search_path = pg_catalog, public
as $$
  with normalized as (
    select
      coalesce(nullif(trim(p_timezone), ''), 'UTC') as tz,
      greatest(least(coalesce(p_day_offset, 0), 1), 0) as day_offset,
      greatest(least(coalesce(p_local_hour, 9), 20), 8) as local_hour
  ),
  local_target as (
    select
      tz,
      (
        date_trunc('day', timezone(tz, now()))
        + make_interval(days => day_offset)
        + make_interval(hours => local_hour)
      ) as local_timestamp
    from normalized
  ),
  resolved as (
    select
      case
        when (local_timestamp at time zone tz) <= now() + interval '5 minutes'
          then ((local_timestamp + interval '1 day') at time zone tz)
        else (local_timestamp at time zone tz)
      end as scheduled_at
    from local_target
  )
  select least(scheduled_at, now() + interval '36 hours')
  from resolved;
$$;
