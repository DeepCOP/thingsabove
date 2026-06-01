create index if not exists idx_devotional_plans_tags_gin
  on public.devotional_plans
  using gin (tags);

drop function if exists public.get_my_devotional_plans();

create or replace function public.get_my_devotional_plans()
returns table (
  id uuid,
  title text,
  status text,
  visibility text,
  tags text[],
  description text,
  total_days int,
  cover_image text,
  created_at timestamptz,
  helpful_count int
)
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
begin
  return query
  select
    p.id,
    p.title,
    p.status,
    p.visibility,
    p.tags,
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

drop function if exists public.get_discover_plans(int, timestamptz, uuid);

create or replace function public.get_discover_plans(
  p_limit_count int default 10,
  p_cursor_created_at timestamptz default null,
  p_cursor_id uuid default null,
  p_tags text[] default null
)
returns table (
  id uuid,
  title text,
  total_days int,
  description text,
  cover_image text,
  completions int,
  tags text[],
  author_id uuid,
  created_at timestamptz,
  status text,
  updated_at timestamptz,
  visibility text,
  helpful_count bigint,
  user_reaction text,
  rating_avg double precision,
  rating_count bigint
)
language sql
stable
security invoker
set search_path = pg_catalog, public
as $$
  select
    dpv.id,
    dpv.title,
    dpv.total_days,
    dpv.description,
    dpv.cover_image,
    dpv.completions,
    dpv.tags,
    dpv.author_id,
    dpv.created_at,
    dpv.status,
    dpv.updated_at,
    dpv.visibility,
    dpv.helpful_count,
    dpv.user_reaction,
    dpv.rating_avg,
    dpv.rating_count
  from public.devotional_plans_view dpv
  where dpv.status = 'published'
    and dpv.visibility = 'public'
    and (
      coalesce(array_length(p_tags, 1), 0) = 0
      or coalesce(dpv.tags, '{}'::text[]) && p_tags
    )
    and (
      p_cursor_created_at is null
      or (
        dpv.created_at < p_cursor_created_at
        or (dpv.created_at = p_cursor_created_at and dpv.id < p_cursor_id)
      )
    )
  order by
    dpv.created_at desc,
    dpv.id desc
  limit greatest(coalesce(p_limit_count, 10), 1);
$$;
