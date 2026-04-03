alter table public.profiles
  add column if not exists church_joined_at timestamptz;

create index if not exists idx_profiles_church_joined_at
  on public.profiles(church_joined_at)
  where church_id is not null;

create or replace function public.sync_profile_church_joined_at()
returns trigger
language plpgsql
set search_path = pg_catalog, public
as $$
begin
  if tg_op = 'INSERT' then
    if new.church_id is null then
      new.church_joined_at := null;
    elsif new.church_joined_at is null then
      new.church_joined_at := now();
    end if;

    return new;
  end if;

  if new.church_id is distinct from old.church_id then
    if new.church_id is null then
      new.church_joined_at := null;
    else
      new.church_joined_at := now();
    end if;
  elsif new.church_id is null then
    new.church_joined_at := null;
  elsif new.church_joined_at is null then
    new.church_joined_at := old.church_joined_at;
  end if;

  return new;
end;
$$;

drop trigger if exists set_profile_church_joined_at on public.profiles;

create trigger set_profile_church_joined_at
before insert or update on public.profiles
for each row
execute function public.sync_profile_church_joined_at();

DROP FUNCTION IF EXISTS public.get_church_members(uuid, integer, integer, text);

create or replace function public.get_church_members(
  p_church_id uuid,
  p_limit integer default 20,
  p_offset integer default 0,
  p_search text default null
)
returns table (
  id uuid,
  first_name text,
  last_name text,
  avatar_url text,
  church_joined_at timestamptz
)
language plpgsql
security definer
set search_path = pg_catalog, public
stable
as $$
declare
  v_limit integer := greatest(coalesce(p_limit, 20), 1);
  v_offset integer := greatest(coalesce(p_offset, 0), 0);
  v_search text := nullif(trim(coalesce(p_search, '')), '');
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  return query
    with church_members as (
      select
        p.id,
        p.first_name,
        p.last_name,
        p.avatar_url,
        p.church_joined_at
      from public.profiles p
      where p.church_id = p_church_id
        and (
          v_search is null
          or concat_ws(' ', coalesce(p.first_name, ''), coalesce(p.last_name, '')) ilike '%' || v_search || '%'
          or coalesce(p.first_name, '') ilike '%' || v_search || '%'
          or coalesce(p.last_name, '') ilike '%' || v_search || '%'
          or coalesce(p.email, '') ilike '%' || v_search || '%'
        )
    )
    select
      cm.id,
      cm.first_name,
      cm.last_name,
      cm.avatar_url,
      cm.church_joined_at
    from church_members cm
    order by
      lower(coalesce(cm.first_name, '')) asc,
      lower(coalesce(cm.last_name, '')) asc,
      cm.id asc
    limit v_limit
    offset v_offset;
end;
$$;

create or replace function public.get_church_analytics(p_church_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = pg_catalog, public
stable
as $$
declare
  v_viewer_church_id uuid;
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  select church_id
    into v_viewer_church_id
  from public.profiles
  where profiles.id = auth.uid();

  return (
    with church_members as (
      select
        p.id,
        p.last_seen,
        p.church_joined_at
      from public.profiles p
      where p.church_id = p_church_id
    ),
    progress as (
      select
        pp.user_id,
        pp.plan_id,
        coalesce(pp.completed_once, false) as completed_once
      from public.plan_progress pp
      join church_members cm
        on cm.id = pp.user_id
      where pp.plan_id is not null
    ),
    top_plan as (
      select
        dpv.id,
        dpv.title,
        count(distinct progress.user_id)::int as starters
      from progress
      join public.devotional_plans_view dpv
        on dpv.id = progress.plan_id
      group by
        dpv.id,
        dpv.title
      order by
        starters desc,
        dpv.title asc
      limit 1
    ),
    top_plans_ranked as (
      select
        dpv.id,
        dpv.title,
        dpv.cover_image,
        count(distinct progress.user_id)::int as starters,
        count(*) filter (where progress.completed_once)::int as completions
      from progress
      join public.devotional_plans_view dpv
        on dpv.id = progress.plan_id
      group by
        dpv.id,
        dpv.title,
        dpv.cover_image
      order by
        starters desc,
        dpv.title asc
      limit 5
    )
    select jsonb_build_object(
      'stats',
      jsonb_build_object(
        'memberCount', coalesce((select count(*)::int from church_members), 0),
        'activePlansCount', coalesce((select count(distinct plan_id)::int from progress where not completed_once), 0),
        'completedPlansCount', coalesce((select count(*)::int from progress where completed_once), 0),
        'topPlan',
        (
          select jsonb_build_object(
            'id', tp.id,
            'title', tp.title,
            'starters', tp.starters
          )
          from top_plan tp
        ),
        'activeMembersThisWeek',
        coalesce(
          (
            select count(*)::int
            from church_members cm
            where cm.last_seen is not null
              and cm.last_seen >= now() - interval '7 days'
          ),
          0
        ),
        'joinedThisMonth',
        coalesce(
          (
            select count(*)::int
            from church_members cm
            where cm.church_joined_at is not null
              and cm.church_joined_at >= date_trunc('month', now())
          ),
          0
        )
      ),
      'topPlans',
      coalesce(
        (
          select jsonb_agg(
            jsonb_build_object(
              'id', tpr.id,
              'title', tpr.title,
              'cover_image', tpr.cover_image,
              'starters', tpr.starters,
              'completions', tpr.completions
            )
            order by tpr.starters desc, tpr.title asc
          )
          from top_plans_ranked tpr
        ),
        '[]'::jsonb
      )
    )
  );
end;
$$;
