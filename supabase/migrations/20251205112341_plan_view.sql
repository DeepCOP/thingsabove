create view public.plan_meta 
with(security_invoker = true)
as select 
  p.id as plan_id,
  -- comments count
  (select count(*) from public.comments c 
   where c.entity_type = 'plan' and c.entity_id = p.id) as comments_count,

  -- like count
  (select count(*) from public.plan_reactions r 
   where r.plan_id = p.id and r.reaction_type = 'like') as likes_count,

  -- dislike count
  (select count(*) from public.plan_reactions r 
   where r.plan_id = p.id and r.reaction_type = 'dislike') as dislikes_count
from public.devotional_plans p;
