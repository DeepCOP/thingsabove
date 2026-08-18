create index if not exists idx_comments_user_created_at
  on public.comments (user_id, created_at desc nulls last);

create index if not exists idx_prayer_request_encouragements_user_created_at
  on public.prayer_request_encouragements (user_id, created_at desc);

create index if not exists idx_scripture_note_comments_user_created_at
  on public.scripture_notes (user_id, created_at desc)
  where parent_note_id is not null;
