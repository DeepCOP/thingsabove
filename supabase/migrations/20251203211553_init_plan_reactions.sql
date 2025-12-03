-- Reactions: like / dislike
create table if not exists public.plan_reactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  plan_id uuid references public.devotional_plans(id) on delete cascade,
  reaction_type text check (reaction_type in ('like', 'dislike')),
  created_at timestamptz default now(),
  unique (user_id, plan_id, reaction_type)
);




create or replace function public.toggle_reaction(
  p_plan_id uuid,
  p_user_id uuid,
  p_reaction_type text
)
returns text
language plpgsql
as $$
declare
  existing_like uuid;
  existing_dislike uuid;
begin
  if p_reaction_type not in ('like', 'dislike') then
    return 'invalid reaction type';
  end if;

  -- Check existing reactions
  select id into existing_like
  from public.plan_reactions
  where plan_id = p_plan_id
    and user_id = p_user_id
    and reaction_type = 'like'
  limit 1;

  select id into existing_dislike
  from public.plan_reactions
  where plan_id = p_plan_id
    and user_id = p_user_id
    and reaction_type = 'dislike'
  limit 1;

  -- CASE 1: Toggle off (remove)
  if (p_reaction_type = 'like' and existing_like is not null) or
     (p_reaction_type = 'dislike' and existing_dislike is not null)
  then
    delete from public.plan_reactions where id = coalesce(existing_like, existing_dislike);
    return 'removed';
  end if;

  -- CASE 2: Switch from like -> dislike OR dislike -> like
  if existing_like is not null and p_reaction_type = 'dislike' then
    delete from public.plan_reactions where id = existing_like;
  elsif existing_dislike is not null and p_reaction_type = 'like' then
    delete from public.plan_reactions where id = existing_dislike;
  end if;

  -- CASE 3: Insert new reaction
  insert into public.plan_reactions (plan_id, user_id, reaction_type)
  values (p_plan_id, p_user_id, p_reaction_type);

  return 'added';
end;
$$;


alter table public.plan_reactions enable row level security;



create policy "users can view reactions"
  on public.plan_reactions
  for select
  using (true);

create policy "users can insert reactions"
  on public.plan_reactions
  for insert
  with check (auth.uid() = user_id);

create policy "users can update own reactions"
  on public.plan_reactions
  for update
  using (auth.uid() = user_id);

create policy "users can delete own reactions"
  on public.plan_reactions
  for delete
  using (auth.uid() = user_id);

create index if not exists idx_reactions_plan on public.plan_reactions(plan_id);
create index if not exists idx_reactions_user on public.plan_reactions(user_id);
create index if not exists idx_reactions_plan_user on public.plan_reactions(plan_id, user_id);
