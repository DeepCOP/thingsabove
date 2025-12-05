-- insert into storage.buckets
--   (id, name, public)
-- values
--   ('plan_covers', 'plan_covers', true);

create policy "plan covers publicly accessible"
on storage.objects
for select
using (bucket_id = 'plan_covers');

create policy "authors upload cover images"
on storage.objects
for insert
with check (
  bucket_id = 'plan_covers'
  and exists (
    select 1
    from public.devotional_plans p
    where p.id::text = (storage.foldername(name))[1]
    and p.author_id = auth.uid()
  )
);


create policy "authors delete cover images"
on storage.objects
for delete
using (
  bucket_id = 'plan_covers'
  and exists (
    select 1
    from public.devotional_plans p
    where p.id::text = (storage.foldername(name))[1]
    and p.author_id = auth.uid()
  )
);

create policy "authors update cover images"
on storage.objects
for update
using (
  bucket_id = 'plan_covers'
  and exists (
    select 1
    from public.devotional_plans p
    where p.id::text = (storage.foldername(name))[1]
    and p.author_id = auth.uid()
  )
);
