create table if not exists public.scripture_notes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  note_type text not null check (note_type in ('verse', 'section', 'chapter', 'book')),
  scope_key text not null,
  book text not null,
  chapter integer,
  verse_start integer,
  verse_end integer,
  content text not null check (length(trim(content)) > 0),
  parent_note_id uuid references public.scripture_notes(id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (verse_start is null or verse_start > 0),
  check (verse_end is null or verse_end > 0),
  check (verse_start is null or verse_end is null or verse_end >= verse_start)
);

create index if not exists idx_scripture_notes_parent
  on public.scripture_notes(parent_note_id);


alter table public.scripture_notes enable row level security;

create policy "scripture notes readable by everyone"
  on public.scripture_notes
  for select
  using (true);

create policy "logged in users can insert scripture notes"
  on public.scripture_notes
  for insert
  with check (auth.uid() = user_id);

create policy "scripture note owners can update"
  on public.scripture_notes
  for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "scripture note owners can delete"
  on public.scripture_notes
  for delete
  using (auth.uid() = user_id);

create index if not exists idx_scripture_notes_scope
  on public.scripture_notes(note_type, scope_key, created_at desc);

create index if not exists idx_scripture_notes_user
  on public.scripture_notes(user_id);

create table if not exists public.scripture_note_helpful_votes (
  note_id uuid not null references public.scripture_notes(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (note_id, user_id)
);

alter table public.scripture_note_helpful_votes enable row level security;

create policy "scripture note helpful votes readable by everyone"
  on public.scripture_note_helpful_votes
  for select
  using (true);

create policy "logged in users can insert scripture note helpful votes"
  on public.scripture_note_helpful_votes
  for insert
  with check (auth.uid() = user_id);

create policy "vote owners can delete helpful votes"
  on public.scripture_note_helpful_votes
  for delete
  using (auth.uid() = user_id);

create index if not exists idx_scripture_note_helpful_note
  on public.scripture_note_helpful_votes(note_id);

create index if not exists idx_scripture_note_helpful_user
  on public.scripture_note_helpful_votes(user_id);


create or replace function public.validate_scripture_note_parent()
returns trigger
language plpgsql
as $$
declare
  v_parent public.scripture_notes%rowtype;
begin
  if new.parent_note_id is null then
    return new;
  end if;

  if new.id is not null and new.parent_note_id = new.id then
    raise exception 'A note cannot reply to itself';
  end if;

  select *
  into v_parent
  from public.scripture_notes
  where id = new.parent_note_id;

  if not found then
    raise exception 'Parent note not found';
  end if;

  if v_parent.parent_note_id is not null then
    raise exception 'Only one level of replies is allowed';
  end if;

  if v_parent.note_type <> new.note_type or v_parent.scope_key <> new.scope_key then
    raise exception 'Reply must belong to the same note scope';
  end if;

  return new;
end;
$$;

create trigger trg_validate_scripture_note_parent
before insert or update of parent_note_id, note_type, scope_key
on public.scripture_notes
for each row
execute function public.validate_scripture_note_parent();


create or replace function public.add_scripture_note(
  p_note_type text,
  p_scope_key text,
  p_book text,
  p_chapter integer default null,
  p_verse_start integer default null,
  p_verse_end integer default null,
  p_content text default '',
  p_parent_note_id uuid default null
)
returns uuid
language plpgsql
security definer
as $$
declare
  v_note_id uuid;
  v_user_id uuid := auth.uid();
  v_parent public.scripture_notes%rowtype;
begin
  if v_user_id is null then
    raise exception 'You must be signed in to add notes';
  end if;

  if trim(coalesce(p_content, '')) = '' then
    raise exception 'Note content cannot be empty';
  end if;

  if p_parent_note_id is not null then
    select *
    into v_parent
    from public.scripture_notes
    where id = p_parent_note_id;

    if not found then
      raise exception 'Parent note not found';
    end if;

    if v_parent.parent_note_id is not null then
      raise exception 'Only one level of replies is allowed';
    end if;

    if v_parent.note_type <> p_note_type or v_parent.scope_key <> p_scope_key then
      raise exception 'Reply must belong to the same note scope';
    end if;
  end if;

  insert into public.scripture_notes (
    user_id,
    note_type,
    scope_key,
    book,
    chapter,
    verse_start,
    verse_end,
    content,
    parent_note_id
  )
  values (
    v_user_id,
    p_note_type,
    p_scope_key,
    p_book,
    p_chapter,
    p_verse_start,
    p_verse_end,
    trim(p_content),
    p_parent_note_id
  )
  returning id into v_note_id;

  return v_note_id;
end;
$$;

create or replace function public.get_scripture_notes(
  p_note_type text,
  p_scope_key text,
  p_limit integer default 100,
  p_offset integer default 0
)
returns table (
  id uuid,
  user_id uuid,
  note_type text,
  scope_key text,
  book text,
  chapter integer,
  verse_start integer,
  verse_end integer,
  parent_note_id uuid,
  content text,
  created_at timestamptz,
  updated_at timestamptz,
  first_name text,
  last_name text,
  avatar_url text,
  helpful_count integer,
  is_helpful boolean
)
language sql
stable
as $$
  with vote_counts as (
    select note_id, count(*)::integer as vote_count
    from public.scripture_note_helpful_votes
    group by note_id
  ),
  scoped_notes as (
    select
      n.id,
      n.user_id,
      n.note_type,
      n.scope_key,
      n.book,
      n.chapter,
      n.verse_start,
      n.verse_end,
      n.parent_note_id,
      n.content,
      n.created_at,
      n.updated_at,
      p.first_name,
      p.last_name,
      p.avatar_url,
      coalesce(v.vote_count, 0)::integer as helpful_count,
      exists (
        select 1
        from public.scripture_note_helpful_votes me
        where me.note_id = n.id
          and me.user_id = auth.uid()
      ) as is_helpful,
      coalesce(n.parent_note_id, n.id) as thread_id
    from public.scripture_notes n
    join public.profiles p on p.id = n.user_id
    left join vote_counts v on v.note_id = n.id
    where n.note_type = p_note_type
      and n.scope_key = p_scope_key
  ),
  thread_meta as (
    select
      s.id as thread_id,
      s.helpful_count as thread_helpful_count,
      s.created_at as thread_created_at
    from scoped_notes s
    where s.parent_note_id is null
  )
  select
    s.id,
    s.user_id,
    s.note_type,
    s.scope_key,
    s.book,
    s.chapter,
    s.verse_start,
    s.verse_end,
    s.parent_note_id,
    s.content,
    s.created_at,
    s.updated_at,
    s.first_name,
    s.last_name,
    s.avatar_url,
    s.helpful_count,
    s.is_helpful
  from scoped_notes s
  join thread_meta t on t.thread_id = s.thread_id
  order by
    t.thread_helpful_count desc,
    t.thread_created_at desc,
    case when s.parent_note_id is null then 0 else 1 end asc,
    case when s.parent_note_id is not null then s.created_at end asc,
    s.id asc
  limit greatest(coalesce(p_limit, 100), 1)
  offset greatest(coalesce(p_offset, 0), 0);
$$;


create or replace function public.toggle_scripture_note_helpful(
  p_note_id uuid
)
returns table (
  is_helpful boolean,
  helpful_count integer
)
language plpgsql
security definer
as $$
declare
  v_user_id uuid := auth.uid();
begin
  if v_user_id is null then
    raise exception 'You must be signed in to react';
  end if;

  if exists (
    select 1
    from public.scripture_note_helpful_votes
    where note_id = p_note_id
      and user_id = v_user_id
  ) then
    delete from public.scripture_note_helpful_votes
    where note_id = p_note_id
      and user_id = v_user_id;

    is_helpful := false;
  else
    insert into public.scripture_note_helpful_votes (note_id, user_id)
    values (p_note_id, v_user_id)
    on conflict (note_id, user_id) do nothing;

    is_helpful := true;
  end if;

  select count(*)::integer
  into helpful_count
  from public.scripture_note_helpful_votes
  where note_id = p_note_id;

  return next;
end;
$$;


alter publication supabase_realtime
add table public.scripture_notes;




