-- Use Postgres to create a bucket.

-- insert into storage.buckets
--   (id, name, public)
-- values
--   ('avatars', 'avatars', true);

create policy "avatars are publicly accessible"
on storage.objects
for select using (bucket_id = 'avatars');


create policy "users can upload their own avatar"
on storage.objects
for insert
with check (
  bucket_id = 'avatars'
  and auth.uid()::text = (storage.foldername(name))[1]
);


create policy "users can update their own avatar"
on storage.objects
for update
using (
  auth.uid() = owner
)
with check  (
  bucket_id = 'avatars'
  and auth.uid()::text = (storage.foldername(name))[1]
);

create policy "users can delete their own avatar"
on storage.objects
for delete
using (
  auth.uid() = owner
  and bucket_id = 'avatars'
)

