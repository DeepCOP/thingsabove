drop function if exists public.search_plans(text, integer, timestamp with time zone, uuid);

drop view if exists public.devotional_plans_view;
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
  ) as user_reaction
from public.devotional_plans p;

create or replace function public.search_plans(
  search_query text,
  limit_count int default 20,
  cursor_created_at timestamptz default null,
  cursor_id uuid default null
)
returns setof devotional_plans_view
language sql
as $$
  select *
  from devotional_plans_view
  where
    (
      cursor_created_at is null
      or (
        created_at < cursor_created_at
        or (created_at = cursor_created_at and id < cursor_id)
      )
    )
    and (
      lower(title) like lower(search_query) || '%'
      or lower(description) like lower(search_query) || '%'
      or lower(public.tags_to_text(tags)) like '%' || lower(search_query) || '%'
      or similarity(lower(title), lower(search_query)) > 0.2
      or similarity(lower(description), lower(search_query)) > 0.2
      or similarity(lower(public.tags_to_text(tags)), lower(search_query)) > 0.2
    )
  order by
    created_at desc,
    id desc
  limit limit_count;
$$;
