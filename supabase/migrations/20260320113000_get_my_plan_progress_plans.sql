create or replace function public.get_my_plan_progress_plans()
returns table (
  plan_id uuid,
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
  helpful_count bigint,
  user_reaction text,
  rating_avg numeric,
  rating_count int,
  progress_id uuid,
  started_at timestamptz,
  group_id uuid,
  completed_days int,
  completed_once boolean
)
language sql
security invoker
stable
as $$
  select
    dpv.id as plan_id,
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
    dpv.helpful_count,
    dpv.user_reaction,
    dpv.rating_avg,
    dpv.rating_count,
    pp.id as progress_id,
    coalesce(pp.created_at, pp.start_date) as started_at,
    pp.group_id,
    coalesce(array_length(pp.completed_days, 1), 0) as completed_days,
    coalesce(pp.completed_once, false) as completed_once
  from public.plan_progress pp
  join public.devotional_plans_view dpv
    on dpv.id = pp.plan_id
  where pp.user_id = auth.uid()
    and dpv.status <> 'draft'
  order by
    coalesce(pp.created_at, pp.start_date) desc,
    pp.id desc;
$$;
