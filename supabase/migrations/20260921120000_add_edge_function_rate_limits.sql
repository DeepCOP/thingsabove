create schema if not exists private;

revoke all on schema private from public, anon, authenticated;

create table private.edge_function_rate_limits (
  key_hash text not null,
  window_seconds integer not null,
  window_started_at timestamptz not null,
  request_count integer not null,
  primary key (key_hash, window_seconds),
  constraint edge_function_rate_limits_key_hash_check
    check (key_hash ~ '^[0-9a-f]{64}$'),
  constraint edge_function_rate_limits_window_seconds_check
    check (window_seconds between 1 and 86400),
  constraint edge_function_rate_limits_request_count_check
    check (request_count > 0)
);

create index edge_function_rate_limits_window_started_at_idx
  on private.edge_function_rate_limits (window_started_at);

alter table private.edge_function_rate_limits enable row level security;

revoke all on table private.edge_function_rate_limits from public, anon, authenticated;

create or replace function public.check_edge_function_rate_limit(
  p_key text,
  p_limit integer,
  p_window_seconds integer
)
returns boolean
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_now timestamptz := clock_timestamp();
  v_count integer;
begin
  if p_key is null or p_key !~ '^[0-9a-f]{64}$' then
    raise exception 'invalid rate-limit key' using errcode = '22023';
  end if;
  if p_limit is null or p_limit < 1 then
    raise exception 'invalid rate-limit limit' using errcode = '22023';
  end if;
  if p_window_seconds is null or p_window_seconds not between 1 and 86400 then
    raise exception 'invalid rate-limit window' using errcode = '22023';
  end if;

  insert into private.edge_function_rate_limits as limits (
    key_hash,
    window_seconds,
    window_started_at,
    request_count
  )
  values (p_key, p_window_seconds, v_now, 1)
  on conflict (key_hash, window_seconds) do update
  set
    window_started_at = case
      when limits.window_started_at <= v_now - make_interval(secs => p_window_seconds)
        then v_now
      else limits.window_started_at
    end,
    request_count = case
      when limits.window_started_at <= v_now - make_interval(secs => p_window_seconds)
        then 1
      else limits.request_count + 1
    end
  returning request_count into v_count;

  return v_count <= p_limit;
end;
$$;

revoke all on function public.check_edge_function_rate_limit(text, integer, integer)
  from public, anon, authenticated;
grant execute on function public.check_edge_function_rate_limit(text, integer, integer)
  to service_role;

select cron.schedule(
  'prune-edge-function-rate-limits',
  '17 * * * *',
  $$
    delete from private.edge_function_rate_limits
    where window_started_at < now() - interval '1 day';
  $$
);
