alter table public.comments
  alter column group_id drop not null;

drop policy if exists "accepted group members can read comments" on public.comments;
drop policy if exists "accepted group members can insert comments" on public.comments;
drop policy if exists "comment owners can update while in the group" on public.comments;
drop policy if exists "comment owners can delete while in the group" on public.comments;

create policy "group members and note owners can read comments"
  on public.comments
  for select
  using (
    (
      group_id is not null
      and public.is_accepted_group_member(group_id)
    )
    or (
      group_id is null
      and auth.uid() = user_id
    )
  );

create policy "group members and solo plan owners can insert comments"
  on public.comments
  for insert
  with check (
    auth.uid() = user_id
    and (
      (
        group_id is not null
        and public.is_accepted_group_member(group_id)
      )
      or (
        group_id is null
        and exists (
          select 1
          from public.plan_progress pp
          where pp.plan_id = comments.plan_id
            and pp.user_id = auth.uid()
            and pp.group_id is null
        )
      )
    )
  );

create policy "comment owners can update shared comments and solo notes"
  on public.comments
  for update
  using (
    auth.uid() = user_id
    and (
      (
        group_id is not null
        and public.is_accepted_group_member(group_id)
      )
      or group_id is null
    )
  )
  with check (
    auth.uid() = user_id
    and (
      (
        group_id is not null
        and public.is_accepted_group_member(group_id)
      )
      or group_id is null
    )
  );

create policy "comment owners can delete shared comments and solo notes"
  on public.comments
  for delete
  using (
    auth.uid() = user_id
    and (
      (
        group_id is not null
        and public.is_accepted_group_member(group_id)
      )
      or group_id is null
    )
  );

create or replace function public.add_plan_day_comment(
  p_plan_id uuid,
  p_day_id uuid,
  p_content text,
  p_group_id uuid default null
)
returns void
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  if not exists (
    select 1
    from public.devotional_days d
    where d.id = p_day_id
      and d.plan_id = p_plan_id
  ) then
    raise exception 'Plan day not found';
  end if;

  if p_group_id is not null then
    if not public.is_accepted_group_member(p_group_id) then
      raise exception 'Only accepted group members can comment';
    end if;

    if not exists (
      select 1
      from public.plan_groups pg
      where pg.id = p_group_id
        and pg.plan_id = p_plan_id
    ) then
      raise exception 'Plan group not found';
    end if;
  else
    if not exists (
      select 1
      from public.plan_progress pp
      where pp.plan_id = p_plan_id
        and pp.user_id = auth.uid()
        and pp.group_id is null
    ) then
      raise exception 'Solo notes require an active solo plan';
    end if;
  end if;

  insert into public.comments (
    plan_id,
    day_id,
    user_id,
    group_id,
    content
  )
  values (
    p_plan_id,
    p_day_id,
    auth.uid(),
    p_group_id,
    trim(p_content)
  );
end;
$$;

create or replace function public.get_plan_day_comments(
  p_plan_id uuid,
  p_day_id uuid,
  p_group_id uuid default null
)
returns table (
  id uuid,
  user_id uuid,
  group_id uuid,
  content text,
  created_at timestamptz,
  first_name text,
  last_name text,
  avatar_url text
)
language sql
stable
security definer
set search_path = pg_catalog, public
as $$
  select
    c.id,
    c.user_id,
    c.group_id,
    c.content,
    c.created_at,
    p.first_name,
    p.last_name,
    p.avatar_url
  from public.comments c
  join public.profiles p on p.id = c.user_id
  where c.plan_id = p_plan_id
    and c.day_id = p_day_id
    and (
      (
        p_group_id is not null
        and c.group_id = p_group_id
        and public.is_accepted_group_member(p_group_id)
      )
      or (
        p_group_id is null
        and c.group_id is null
        and c.user_id = auth.uid()
      )
    )
  order by c.created_at asc;
$$;
