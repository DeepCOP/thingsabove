
create or replace function public.report_plan(
  p_plan_id uuid,
  p_reason text
)
returns void
language plpgsql
security definer
as $$
begin
  insert into reports (user_id, plan_id, reason)
  values (auth.uid(), p_plan_id, p_reason);
end;
$$;


create or replace function public.get_plan_reaction_summary(
  p_plan_id uuid
)
returns table (
  likes int,
  dislikes int,
  user_reaction text
)
language plpgsql
security definer
as $$
begin
  return query
  select
    count(*) filter (where reaction_type = 'like')::int as likes,
    count(*) filter (where reaction_type = 'dislike')::int as dislikes,
    (
      select reaction_type
      from plan_reactions
      where plan_id = p_plan_id
        and user_id = auth.uid()
      limit 1
    ) as user_reaction
  from plan_reactions
  where plan_id = p_plan_id;
end;
$$;
