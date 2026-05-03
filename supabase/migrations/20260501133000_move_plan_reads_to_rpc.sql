create or replace function public.get_related_public_plans(
  p_current_plan_id uuid,
  p_tags text[],
  p_limit_count int default 10
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
  where dpv.id <> p_current_plan_id
    and dpv.status = 'published'
    and dpv.visibility = 'public'
    and coalesce(dpv.tags, '{}'::text[]) && coalesce(p_tags, '{}'::text[])
  order by
    dpv.created_at desc,
    dpv.id desc
  limit greatest(coalesce(p_limit_count, 10), 1);
$$;

create or replace function public.get_discover_plans(
  p_limit_count int default 10,
  p_cursor_created_at timestamptz default null,
  p_cursor_id uuid default null
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

create or replace function public.get_published_plan_by_id(p_plan_id uuid)
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
  where dpv.id = p_plan_id
    and dpv.status = 'published'
  limit 1;
$$;

create or replace function public.get_published_plans_by_ids(p_plan_ids uuid[])
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
    and dpv.id = any(coalesce(p_plan_ids, '{}'::uuid[]))
  order by
    dpv.created_at desc,
    dpv.id desc;
$$;
