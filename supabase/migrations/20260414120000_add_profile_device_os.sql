alter table public.profiles
  add column if not exists device_os text,
  add column if not exists device_os_version text,
  add column if not exists app_version text;
