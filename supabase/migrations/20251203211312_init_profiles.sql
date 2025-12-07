create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  first_name text not null,
  last_name text not null,
  email text unique not null,
  avatar_url text,
  bio text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);


create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
as $$
begin
  insert into public.profiles (id, first_name,last_name, email)
  values (new.id, new.raw_user_meta_data->>'first_name',new.raw_user_meta_data->>'last_name', new.email);
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();



alter table public.profiles enable row level security;


create policy "profiles are viewable by everyone"
  on public.profiles
  for select
  using (true);

create policy "users can insert their own profile"
  on public.profiles
  for insert
  with check (auth.uid() = id);

create policy "users can update their own profile"
  on public.profiles
  for update
  using (auth.uid() = id)
  with check (auth.uid() = id);


create index if not exists idx_profiles_email on public.profiles(email);
