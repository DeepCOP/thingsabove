drop index if exists public.bible_versions_enabled_sort_order_idx;

alter table public.bible_versions
drop column if exists sort_order;

create index if not exists bible_versions_enabled_id_idx
on public.bible_versions (is_enabled, id);
