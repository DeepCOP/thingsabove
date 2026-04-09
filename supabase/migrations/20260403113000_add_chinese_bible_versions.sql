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
