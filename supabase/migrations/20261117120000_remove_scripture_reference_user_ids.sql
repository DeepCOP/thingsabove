begin;

-- Scripture references belong to a day; ownership is resolved through its plan.
-- Dropping these columns also removes their user foreign keys and indexes.
-- Keep historical imports before this migration so fresh databases replay normally.
alter table public.scripture_references
  drop column if exists user_id;

alter table public.scripture_references_draft
  drop column if exists user_id;

commit;
