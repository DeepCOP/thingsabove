insert into storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
)
values (
  'bible_versions',
  'bible_versions',
  true,
  20971520,
  array['application/json']
)
on conflict (id) do update
set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;


create policy "bible versions publicly accessible"
on storage.objects
for select
using (bucket_id = 'bible_versions');


create policy "admins can upload bible versions"
on storage.objects
for insert
with check (
  bucket_id = 'bible_versions'
  and auth.jwt() ->> 'role' = 'admin'
);


create policy "admins can update bible versions"
on storage.objects
for update
using (
  bucket_id = 'bible_versions'
  and auth.jwt() ->> 'role' = 'admin'
)
with check (
  bucket_id = 'bible_versions'
  and auth.jwt() ->> 'role' = 'admin'
);


create policy "admins can delete bible versions"
on storage.objects
for delete
using (
  bucket_id = 'bible_versions'
  and auth.jwt() ->> 'role' = 'admin'
);
