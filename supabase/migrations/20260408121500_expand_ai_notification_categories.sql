alter table public.ai_triggers
  drop constraint if exists ai_triggers_planner_category_check;

alter table public.ai_triggers
  add constraint ai_triggers_planner_category_check check (
    planner_category is null
    or planner_category in (
      'invite_friends',
      'church_attendance',
      'serve_at_church',
      'daily_devotion',
      'spiritual_support',
      'encouragement',
      'good_deed',
      'prayer_for_someone',
      'share_gospel',
      'cheering_up_with_humor'
    )
  );
