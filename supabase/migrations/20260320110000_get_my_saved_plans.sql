create or replace function public.get_my_saved_plans()
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
  helpful_count bigint,
  user_reaction text,
  saved_at timestamptz
)
language sql
security invoker
stable
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
    dpv.helpful_count,
    dpv.user_reaction,
    sp.created_at as saved_at
  from public.saved_plans sp
  join public.devotional_plans_view dpv
    on dpv.id = sp.plan_id
  where sp.user_id = auth.uid()
    and dpv.status <> 'draft'
  order by sp.created_at desc;
$$;
