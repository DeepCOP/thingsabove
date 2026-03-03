-- Convert plan reactions from like/dislike to helpful-only semantics.
DROP FUNCTION IF EXISTS public.get_plan_reaction_summary(uuid);
drop function if exists public.get_my_devotional_plans();
drop function if exists public.search_plans(text, integer, timestamp with time zone, uuid);
DROP VIEW IF EXISTS public.devotional_plans_view;

alter table if exists public.plan_reactions
  drop constraint if exists plan_reactions_reaction_type_check;

delete from public.plan_reactions
where reaction_type = 'dislike';

update public.plan_reactions
set reaction_type = 'helpful'
where reaction_type = 'like';

alter table if exists public.plan_reactions
  add constraint plan_reactions_reaction_type_check
  check (reaction_type in ('helpful'));

create or replace function public.get_plan_reaction_summary(
  p_plan_id uuid
)
returns table (
  helpful_count int,
  user_reaction text
)
language plpgsql
security definer
as $$
begin
  return query
  select
    count(*) filter (where reaction_type = 'helpful')::int as helpful_count,
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

create or replace function public.toggle_reaction(
  p_plan_id uuid,
  p_reaction_type text
)
returns text
language plpgsql
as $$
declare
  existing_reaction uuid;
begin
  if p_reaction_type <> 'helpful' then
    return 'invalid reaction type';
  end if;

  select id into existing_reaction
  from public.plan_reactions
  where plan_id = p_plan_id
    and user_id = auth.uid()
    and reaction_type = 'helpful'
  limit 1;

  if existing_reaction is not null then
    delete from public.plan_reactions where id = existing_reaction;
    return 'removed';
  end if;

  insert into public.plan_reactions (plan_id, user_id, reaction_type)
  values (p_plan_id, auth.uid(), 'helpful');

  return 'added';
end;
$$;

create or replace function get_my_devotional_plans()
returns table (
  id uuid,
  title text,
  status text,
  description text,
  total_days int,
  cover_image text,
  created_at timestamptz,
  helpful_count int
)
language plpgsql
security definer
as $$
begin
  return query
  select
    p.id,
    p.title,
    p.status,
    p.description,
    p.total_days,
    p.cover_image,
    p.created_at,
    count(*) filter (where r.reaction_type = 'helpful')::int as helpful_count
  from public.devotional_plans p
  left join public.plan_reactions r
    on r.plan_id = p.id
  where p.author_id = auth.uid()
  group by p.id
  order by p.created_at desc;
end;
$$;

create or replace view public.devotional_plans_view
with(security_invoker = true)
as select
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
  ) as helpful_count
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
