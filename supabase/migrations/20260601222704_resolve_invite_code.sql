create or replace function public.resolve_invite_code(p_invite_code text)
returns table(
  invite_type text,
  invite_code text,
  group_id uuid,
  plan_id uuid,
  church_id uuid,
  invited_by uuid
)
language sql
security definer
set search_path = pg_catalog, public
as $$
  select
    resolved.invite_type,
    resolved.invite_code,
    resolved.group_id,
    resolved.plan_id,
    resolved.church_id,
    resolved.invited_by
  from (
    select
      1 as sort_order,
      'plan_group'::text as invite_type,
      pg.invite_code,
      pg.id as group_id,
      pg.plan_id,
      null::uuid as church_id,
      pg.created_by as invited_by
    from public.plan_groups pg
    join public.devotional_plans dp
      on dp.id = pg.plan_id
    where pg.invite_code = lower(btrim(p_invite_code))
      and dp.status = 'published'

    union all

    select
      2 as sort_order,
      'church'::text as invite_type,
      cil.invite_code,
      null::uuid as group_id,
      null::uuid as plan_id,
      cil.church_id,
      cil.invited_by
    from public.church_invite_links cil
    join public.churches c
      on c.id = cil.church_id
    join public.profiles p
      on p.id = cil.invited_by
     and p.church_id = cil.church_id
    where cil.invite_code = lower(btrim(p_invite_code))
  ) resolved
  order by resolved.sort_order
  limit 1;
$$;
