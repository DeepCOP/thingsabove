do $$
begin
  if to_regprocedure('public.start_plan_progress(uuid, uuid, uuid, timestamp with time zone)') is not null then
    if to_regprocedure('public.start_private_plan_progess(uuid, uuid, uuid, timestamp with time zone)') is not null then
      execute 'drop function public.start_plan_progress(uuid, uuid, uuid, timestamptz)';
    else
      execute 'alter function public.start_plan_progress(uuid, uuid, uuid, timestamptz) rename to start_private_plan_progess';
    end if;
  end if;
end;
$$;
