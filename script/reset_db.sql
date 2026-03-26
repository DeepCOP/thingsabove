do $$
declare
  keep_tables constant text[] := array[
    'profiles',
    'churches'
  ];
  tables_to_truncate text;
begin
  select string_agg(format('%I.%I', schemaname, tablename), ', ' order by tablename)
    into tables_to_truncate
  from pg_catalog.pg_tables
  where schemaname = 'public'
    and tablename <> all (keep_tables);

  if tables_to_truncate is null then
    raise notice 'No public tables to truncate.';
    return;
  end if;

  raise notice 'Truncating: %', tables_to_truncate;
  execute 'truncate table ' || tables_to_truncate || ' restart identity cascade';
end
$$;
