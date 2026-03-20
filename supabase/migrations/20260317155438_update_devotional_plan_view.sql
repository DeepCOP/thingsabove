
-- Include ratings in plans view for list displays
create or replace view public.devotional_plans_view
with (security_invoker = true)
as
select
  p.id,
  p.title,
  p.total_days,
  p.description,
  p.cover_image,
  p.completions,
  p.tags,
  p.author_id,
  p.created_at,
  p.status,
  p.updated_at,
  (
    select count(*)
    from public.plan_reactions r
    where r.plan_id = p.id
      and r.reaction_type = 'helpful'
  ) as helpful_count,
  (
    select r.reaction_type
    from public.plan_reactions r
    where r.plan_id = p.id
      and r.user_id = auth.uid()
      and r.reaction_type = 'helpful'
    limit 1
  ) as user_reaction,
  (
    select coalesce(avg(pr.rating)::float, 0)
    from public.plan_ratings pr
    where pr.plan_id = p.id
  ) as rating_avg,
  (
    select count(*)
    from public.plan_ratings pr
    where pr.plan_id = p.id
  ) as rating_count
from public.devotional_plans p;
