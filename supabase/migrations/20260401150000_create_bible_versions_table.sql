create table if not exists public.bible_versions (
  id text primary key,
  short_label text not null,
  label text not null,
  language text,
  description text not null default '',
  size_bytes bigint not null check (size_bytes >= 0),
  local_filename text not null unique,
  storage_path text unique,
  public_url text,
  is_bundled boolean not null default false,
  is_enabled boolean not null default true,
  sort_order integer not null default 0,
  checksum text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists bible_versions_enabled_sort_order_idx
on public.bible_versions (is_enabled, sort_order, label);

alter table public.bible_versions enable row level security;

create policy "bible versions readable by everyone"
on public.bible_versions
for select
using (is_enabled = true);

create policy "admins can insert bible versions rows"
on public.bible_versions
for insert
with check (auth.jwt() ->> 'role' = 'admin');

create policy "admins can update bible versions rows"
on public.bible_versions
for update
using (auth.jwt() ->> 'role' = 'admin')
with check (auth.jwt() ->> 'role' = 'admin');

create policy "admins can delete bible versions rows"
on public.bible_versions
for delete
using (auth.jwt() ->> 'role' = 'admin');

drop trigger if exists set_bible_versions_updated_at on public.bible_versions;
create trigger set_bible_versions_updated_at
  before update on public.bible_versions
  for each row
  execute procedure public.set_updated_at();

insert into public.bible_versions (
  id,
  short_label,
  label,
  language,
  description,
  size_bytes,
  local_filename,
  storage_path,
  public_url,
  is_bundled,
  is_enabled,
  sort_order,
  checksum
)
values
  (
    'ASV',
    'ASV',
    'American Standard Version',
    'English',
    'English translation. Download for offline reading.',
    6884893,
    'asv.json',
    'ASV.json',
    'https://ujdyhgasuwikfvldhxnb.supabase.co/storage/v1/object/public/bible_versions/ASV.json',
    false,
    true,
    10,
    null
  ),
  (  
    'AMHNASV',
    'NASV',
    'Amharic NASV',
    'Amharic',
    'Amharic NASV (አዲሱ መደበኛ ትርጒም)',
    6833665,
    'amh_nasv.json',
    'AMH_NASV.json',
    'https://ujdyhgasuwikfvldhxnb.supabase.co/storage/v1/object/public/bible_versions/AMH_NASV.json',
    false,
    true,
    32,
    null
  ),
  (
    'HABH',
    'HABH',
    'Oromo Contemporary Version',
    'Afaan Oromoo',
    'Afaan Oromoo (West Central Oromo). Source: Biblica via eBible.org. Copyright 2022 Biblica, Inc. CC BY-SA 4.0.',
    5106018,
    'habh.json',
    'HABH.json',
    'https://ujdyhgasuwikfvldhxnb.supabase.co/storage/v1/object/public/bible_versions/HABH.json',
    false,
    true,
    20,
    null
  ),
  (
    'AMH',
    'AMH',
    'Amharic Bible',
    'Amharic',
    'Amharic translation. Download for offline reading.',
    6249608,
    'amh.json',
    'AMH.json',
    'https://ujdyhgasuwikfvldhxnb.supabase.co/storage/v1/object/public/bible_versions/AMH.json',
    false,
    true,
    30,
    null
  ),
  (
  'CUVS',
  'CUVs',
  'Chinese Union Version (Simplified)',
  'Chinese (Simplified)',
  'Public domain Chinese Union Version in simplified script, converted from eBible.org VPL source.',
  3932640,
  'cuvs.json',
  'CUVS.json',
  'https://ujdyhgasuwikfvldhxnb.supabase.co/storage/v1/object/public/bible_versions/CUVS.json',
  false,
  true,
  40,
  null
),
(
  'CUVT',
  'CUVt',
  'Chinese Union Version (Traditional)',
  'Chinese (Traditional)',
  'Public domain Chinese Union Version in traditional script, converted from eBible.org VPL source.',
  3934593,
  'cuvt.json',
  'CUVT.json',
  'https://ujdyhgasuwikfvldhxnb.supabase.co/storage/v1/object/public/bible_versions/CUVT.json',
  false,
  true,
  41,
  null
)
on conflict (id) do update
set
  short_label = excluded.short_label,
  label = excluded.label,
  language = excluded.language,
  description = excluded.description,
  size_bytes = excluded.size_bytes,
  local_filename = excluded.local_filename,
  storage_path = excluded.storage_path,
  public_url = excluded.public_url,
  is_bundled = excluded.is_bundled,
  is_enabled = excluded.is_enabled,
  sort_order = excluded.sort_order,
  checksum = excluded.checksum;
