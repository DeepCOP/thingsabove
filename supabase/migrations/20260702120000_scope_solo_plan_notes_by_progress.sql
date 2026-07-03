alter table public.comments
  add column if not exists progress_id uuid;

alter table public.comments
  drop constraint if exists comments_progress_id_fkey;

alter table public.comments
  add constraint comments_progress_id_fkey
    foreign key (progress_id)
    references public.plan_progress(id)
    on delete cascade;


with resolved_solo_notes as (
  select
    c.id as comment_id,
    (
      select pp.id
      from public.plan_progress pp
      where pp.user_id = c.user_id
        and pp.plan_id = c.plan_id
        and pp.group_id is null
      order by
        case when pp.created_at <= c.created_at then 0 else 1 end,
        case when pp.created_at <= c.created_at then pp.created_at end desc,
        pp.created_at asc,
        pp.id
      limit 1
    ) as progress_id
  from public.comments c
  where c.group_id is null
    and c.progress_id is null
)
update public.comments c
set progress_id = resolved.progress_id
from resolved_solo_notes resolved
where c.id = resolved.comment_id
  and resolved.progress_id is not null;

create index if not exists idx_plan_day_comments_progress_day
  on public.comments (progress_id, day_id)
  where progress_id is not null;

drop policy if exists "group members and note owners can read comments" on public.comments;
drop policy if exists "group members and solo plan owners can insert comments" on public.comments;
drop policy if exists "comment owners can update shared comments and solo notes" on public.comments;
drop policy if exists "comment owners can delete shared comments and solo notes" on public.comments;

create policy "group members and note owners can read comments"
  on public.comments
  for select
  using (
    (
      group_id is not null
      and progress_id is null
      and public.is_accepted_group_member(group_id)
    )
    or (
      group_id is null
      and progress_id is not null
      and auth.uid() = user_id
      and exists (
        select 1
        from public.plan_progress pp
        where pp.id = comments.progress_id
          and pp.user_id = auth.uid()
          and pp.plan_id = comments.plan_id
          and pp.group_id is null
      )
    )
  );

create policy "group members and solo plan owners can insert comments"
  on public.comments
  for insert
  with check (
    auth.uid() = user_id
    and exists (
      select 1
      from public.devotional_days d
      where d.id = comments.day_id
        and d.plan_id = comments.plan_id
    )
    and (
      (
        group_id is not null
        and progress_id is null
        and public.is_accepted_group_member(group_id)
        and exists (
          select 1
          from public.plan_groups pg
          where pg.id = comments.group_id
            and pg.plan_id = comments.plan_id
        )
      )
      or (
        group_id is null
        and progress_id is not null
        and exists (
          select 1
          from public.plan_progress pp
          where pp.id = comments.progress_id
            and pp.user_id = auth.uid()
            and pp.plan_id = comments.plan_id
            and pp.group_id is null
        )
      )
    )
  );

create policy "comment owners can update shared comments and solo notes"
  on public.comments
  for update
  using (auth.uid() = user_id)
  with check (
    auth.uid() = user_id
    and (
      (
        group_id is not null
        and progress_id is null
        and public.is_accepted_group_member(group_id)
      )
      or (
        group_id is null
        and progress_id is not null
        and exists (
          select 1
          from public.plan_progress pp
          where pp.id = comments.progress_id
            and pp.user_id = auth.uid()
            and pp.plan_id = comments.plan_id
            and pp.group_id is null
        )
      )
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
      or (
        group_id is null
        and progress_id is not null
        and exists (
          select 1
          from public.plan_progress pp
          where pp.id = comments.progress_id
            and pp.user_id = auth.uid()
            and pp.plan_id = comments.plan_id
            and pp.group_id is null
        )
      )
    )
  );

drop function if exists public.add_plan_day_comment(uuid, uuid, text, uuid);

create or replace function public.add_plan_day_comment(
  p_plan_id uuid,
  p_day_id uuid,
  p_content text,
  p_group_id uuid default null,
  p_progress_id uuid default null
)
returns void
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_progress_id uuid := p_progress_id;
  v_progress_count integer;
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  if length(trim(p_content)) = 0 then
    raise exception 'Comment content cannot be empty';
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

    v_progress_id := null;
  else
    -- Compatibility for clients released before progress-scoped solo notes.
    if v_progress_id is null then
      select count(*)
      into v_progress_count
      from public.plan_progress pp
      where pp.plan_id = p_plan_id
        and pp.user_id = auth.uid()
        and pp.group_id is null;

      if v_progress_count = 1 then
        select pp.id
        into v_progress_id
        from public.plan_progress pp
        where pp.plan_id = p_plan_id
          and pp.user_id = auth.uid()
          and pp.group_id is null;
      else
        raise exception 'Plan progress is required for solo notes';
      end if;
    end if;

    if not exists (
      select 1
      from public.plan_progress pp
      where pp.id = v_progress_id
        and pp.plan_id = p_plan_id
        and pp.user_id = auth.uid()
        and pp.group_id is null
    ) then
      raise exception 'Solo plan progress not found';
    end if;
  end if;

  insert into public.comments (
    plan_id,
    day_id,
    user_id,
    group_id,
    progress_id,
    content
  )
  values (
    p_plan_id,
    p_day_id,
    auth.uid(),
    p_group_id,
    v_progress_id,
    trim(p_content)
  );
end;
$$;

drop function if exists public.get_plan_day_comments(uuid, uuid, uuid);

create or replace function public.get_plan_day_comments(
  p_plan_id uuid,
  p_day_id uuid,
  p_group_id uuid default null,
  p_progress_id uuid default null
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
language plpgsql
stable
security definer
set search_path = pg_catalog, public
as $$
declare
  v_progress_id uuid := p_progress_id;
  v_progress_count integer;
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  if p_group_id is not null then
    if not public.is_accepted_group_member(p_group_id) then
      raise exception 'Only accepted group members can view comments';
    end if;
  else
    -- Compatibility for clients released before progress-scoped solo notes.
    if v_progress_id is null then
      select count(*)
      into v_progress_count
      from public.plan_progress pp
      where pp.plan_id = p_plan_id
        and pp.user_id = auth.uid()
        and pp.group_id is null;

      if v_progress_count = 1 then
        select pp.id
        into v_progress_id
        from public.plan_progress pp
        where pp.plan_id = p_plan_id
          and pp.user_id = auth.uid()
          and pp.group_id is null;
      else
        raise exception 'Plan progress is required for solo notes';
      end if;
    end if;

    if not exists (
      select 1
      from public.plan_progress pp
      where pp.id = v_progress_id
        and pp.plan_id = p_plan_id
        and pp.user_id = auth.uid()
        and pp.group_id is null
    ) then
      raise exception 'Solo plan progress not found';
    end if;
  end if;

  return query
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
      )
      or (
        p_group_id is null
        and c.group_id is null
        and c.progress_id = v_progress_id
        and c.user_id = auth.uid()
      )
    )
  order by c.created_at asc;
end;
$$;
