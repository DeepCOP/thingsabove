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
  where id = auth.uid();

  if v_viewer_church_id is distinct from p_church_id then
    raise exception 'You do not have access to this church analytics';
  end if;

  return (
    with church_members as (
      select
        p.id,
        p.created_at
      from public.profiles p
      where p.church_id = p_church_id
    ),
    progress_base as (
      select
        pp.user_id,
        pp.plan_id,
        coalesce(pp.completed_once, false) as completed_once,
        coalesce(pp.updated_at, pp.created_at) as activity_at
      from public.plan_progress pp
      join church_members cm
        on cm.id = pp.user_id
      where pp.plan_id is not null
    ),
    top_plans as (
      select
        dpv.id,
        dpv.title,
        dpv.cover_image,
        count(*)::int as starters,
        count(*) filter (where pb.completed_once)::int as completions
      from progress_base pb
      join public.devotional_plans_view dpv
        on dpv.id = pb.plan_id
      group by dpv.id, dpv.title, dpv.cover_image
    ),
    stats as (
      select
        (select count(*)::int from church_members) as member_count,
        (
          select count(distinct pb.plan_id)::int
          from progress_base pb
          where not pb.completed_once
        ) as active_plans_count,
        (
          select count(*)::int
          from progress_base pb
          where pb.completed_once
        ) as completed_plans_count,
        (
          select count(distinct pb.user_id)::int
          from progress_base pb
          where pb.activity_at >= now() - interval '7 days'
        ) as active_members_this_week,
        (
          select count(*)::int
          from church_members cm
          where cm.created_at >= date_trunc('month', now())
        ) as joined_this_month
    )
    select jsonb_build_object(
      'stats',
      jsonb_build_object(
        'memberCount', stats.member_count,
        'activePlansCount', stats.active_plans_count,
        'completedPlansCount', stats.completed_plans_count,
        'topPlan',
          (
            select
              case
                when tp.id is null then null
                else jsonb_build_object(
                  'id', tp.id,
                  'title', tp.title,
                  'starters', tp.starters
                )
              end
            from top_plans tp
            order by tp.starters desc, tp.completions desc, tp.title asc
            limit 1
          ),
        'activeMembersThisWeek', stats.active_members_this_week,
        'joinedThisMonth', stats.joined_this_month
      ),
      'topPlans',
      coalesce(
        (
          select jsonb_agg(
            jsonb_build_object(
              'id', tp.id,
              'title', tp.title,
              'cover_image', tp.cover_image,
              'starters', tp.starters,
              'completions', tp.completions
            )
            order by tp.starters desc, tp.completions desc, tp.title asc
          )
          from (
            select *
            from top_plans
            order by starters desc, completions desc, title asc
            limit 5
          ) tp
        ),
        '[]'::jsonb
      )
    )
    from stats
  );
end;
$$;
