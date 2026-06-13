alter table public.profiles
  drop constraint if exists profiles_id_fkey;

alter table public.profiles
  add constraint profiles_id_fkey
    foreign key (id)
    references auth.users(id)
    on delete cascade;

alter table public.devotional_plans
  drop constraint if exists devotional_plans_author_id_fkey;

alter table public.devotional_plans
  add constraint devotional_plans_author_id_fkey
    foreign key (author_id)
    references auth.users(id)
    on delete set null;

alter table public.scripture_references
  drop constraint if exists scripture_references_user_id_fkey;

alter table public.scripture_references
  add constraint scripture_references_user_id_fkey
    foreign key (user_id)
    references auth.users(id)
    on delete set null;

alter table public.scripture_references_draft
  drop constraint if exists scripture_references_draft_user_id_fkey;

alter table public.scripture_references_draft
  add constraint scripture_references_draft_user_id_fkey
    foreign key (user_id)
    references auth.users(id)
    on delete set null;

alter table public.reports
  drop constraint if exists reports_user_id_fkey;

alter table public.reports
  add constraint reports_user_id_fkey
    foreign key (user_id)
    references auth.users(id)
    on delete set null;

alter table public.plan_reactions
  drop constraint if exists plan_reactions_user_id_fkey;

alter table public.plan_reactions
  add constraint plan_reactions_user_id_fkey
    foreign key (user_id)
    references auth.users(id)
    on delete cascade;

alter table public.plan_ratings
  drop constraint if exists plan_ratings_user_id_fkey;

alter table public.plan_ratings
  add constraint plan_ratings_user_id_fkey
    foreign key (user_id)
    references auth.users(id)
    on delete cascade;

alter table public.saved_plans
  drop constraint if exists saved_plans_user_id_fkey;

alter table public.saved_plans
  add constraint saved_plans_user_id_fkey
    foreign key (user_id)
    references auth.users(id)
    on delete cascade;

alter table public.plan_progress
  drop constraint if exists plan_progress_user_id_fkey;

alter table public.plan_progress
  add constraint plan_progress_user_id_fkey
    foreign key (user_id)
    references auth.users(id)
    on delete cascade;

alter table public.day_items_progress
  drop constraint if exists day_items_progress_user_id_fkey;

alter table public.day_items_progress
  add constraint day_items_progress_user_id_fkey
    foreign key (user_id)
    references auth.users(id)
    on delete cascade;

alter table public.comments
  drop constraint if exists comments_user_id_fkey;

alter table public.comments
  add constraint comments_user_id_fkey
    foreign key (user_id)
    references auth.users(id)
    on delete set null;

alter table public.notifications
  drop constraint if exists notifications_user_id_fkey;

alter table public.notifications
  add constraint notifications_user_id_fkey
    foreign key (user_id)
    references public.profiles(id)
    on delete cascade;


alter table public.notification_preferences
  drop constraint if exists notification_preferences_user_id_fkey;

alter table public.notification_preferences
  add constraint notification_preferences_user_id_fkey
    foreign key (user_id)
    references public.profiles(id)
    on delete cascade;

alter table public.ai_triggers
  drop constraint if exists ai_triggers_user_id_fkey;

alter table public.ai_triggers
  add constraint ai_triggers_user_id_fkey
    foreign key (user_id)
    references public.profiles(id)
    on delete cascade;

alter table public.scripture_notes
  drop constraint if exists scripture_notes_user_id_fkey;

alter table public.scripture_notes
  add constraint scripture_notes_user_id_fkey
    foreign key (user_id)
    references public.profiles(id)
    on delete cascade;

alter table public.scripture_note_helpful_votes
  drop constraint if exists scripture_note_helpful_votes_user_id_fkey;

alter table public.scripture_note_helpful_votes
  add constraint scripture_note_helpful_votes_user_id_fkey
    foreign key (user_id)
    references public.profiles(id)
    on delete cascade;

alter table public.prayer_requests
  drop constraint if exists prayer_requests_user_id_fkey;

alter table public.prayer_requests
  add constraint prayer_requests_user_id_fkey
    foreign key (user_id)
    references public.profiles(id)
    on delete cascade;

alter table public.prayer_request_prayers
  drop constraint if exists prayer_request_prayers_user_id_fkey;

alter table public.prayer_request_prayers
  add constraint prayer_request_prayers_user_id_fkey
    foreign key (user_id)
    references public.profiles(id)
    on delete cascade;

alter table public.prayer_request_encouragements
  drop constraint if exists prayer_request_encouragements_user_id_fkey;

alter table public.prayer_request_encouragements
  add constraint prayer_request_encouragements_user_id_fkey
    foreign key (user_id)
    references public.profiles(id)
    on delete cascade;

alter table public.plan_submissions
  drop constraint if exists plan_submissions_author_id_fkey;

alter table public.plan_submissions
  add constraint plan_submissions_author_id_fkey
    foreign key (author_id)
    references public.profiles(id)
    on delete cascade;

alter table public.church_invite_links
  drop constraint if exists church_invite_links_invited_by_fkey;

alter table public.church_invite_links
  add constraint church_invite_links_invited_by_fkey
    foreign key (invited_by)
    references public.profiles(id)
    on delete cascade;

