alter table public.profiles
  add column if not exists device_language_tag text,
  add column if not exists device_language_code text;
