create table if not exists public.plan_submissions (
  id uuid primary key default gen_random_uuid(),
  plan_id uuid not null references public.devotional_plans(id) on delete cascade,
  author_id uuid not null references public.profiles(id) on delete cascade,
  submission_number int not null check (submission_number > 0),
  status text not null check (status in ('submitted', 'screening', 'published', 'rejected', 'failed')),
  submitted_payload jsonb not null,
  submitted_title text not null check (char_length(btrim(submitted_title)) > 0),
  submitted_description text not null check (char_length(btrim(submitted_description)) > 0),
  submitted_cover_image text,
  submitted_tags text[] not null default '{}'::text[],
  submitted_total_days int not null check (submitted_total_days > 0),
  screening_decision text check (screening_decision in ('pass', 'reject', 'error')),
  screening_summary text,
  screening_reason_codes text[] not null default '{}'::text[],
  screening_confidence numeric(5,4),
  content_hash text not null,
  submitted_at timestamptz not null default now(),
  screening_started_at timestamptz,
  screening_completed_at timestamptz,
  published_at timestamptz,
  rejected_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint plan_submissions_screening_confidence_range check (
    screening_confidence is null
    or (screening_confidence >= 0 and screening_confidence <= 1)
  )
);

create table if not exists public.plan_screening_runs (
  id uuid primary key default gen_random_uuid(),
  submission_id uuid not null references public.plan_submissions(id) on delete cascade,
  provider text not null,
  model text not null,
  prompt_version text not null,
  decision text not null check (decision in ('pass', 'reject', 'error')),
  confidence numeric(5,4),
  summary text,
  reason_codes text[] not null default '{}'::text[],
  scores jsonb not null default '{}'::jsonb,
  raw_response jsonb,
  created_at timestamptz not null default now(),
  completed_at timestamptz,
  constraint plan_screening_runs_confidence_range check (
    confidence is null
    or (confidence >= 0 and confidence <= 1)
  )
);

create unique index if not exists idx_plan_submissions_plan_submission_number
  on public.plan_submissions(plan_id, submission_number);

create unique index if not exists idx_plan_submissions_active_plan
  on public.plan_submissions(plan_id)
  where status in ('submitted', 'screening');

create index if not exists idx_plan_submissions_author_submitted_at
  on public.plan_submissions(author_id, submitted_at desc);

create index if not exists idx_plan_submissions_status_submitted_at
  on public.plan_submissions(status, submitted_at asc);

create index if not exists idx_plan_screening_runs_submission_created_at
  on public.plan_screening_runs(submission_id, created_at desc);

alter table public.plan_submissions enable row level security;
alter table public.plan_screening_runs enable row level security;

drop policy if exists "Plan submissions: authors view own" on public.plan_submissions;
create policy "Plan submissions: authors view own"
  on public.plan_submissions
  for select
  using (auth.uid() = author_id);

drop trigger if exists set_plan_submissions_updated_at on public.plan_submissions;
create trigger set_plan_submissions_updated_at
  before update on public.plan_submissions
  for each row
  execute procedure public.set_updated_at();

drop function if exists public.submit_devotional_plan_for_screening(uuid);
create or replace function public.submit_devotional_plan_for_screening(
  p_plan_id uuid
)
returns table (
  submission_id uuid,
  plan_id uuid,
  submission_number int,
  status text,
  submitted_at timestamptz
)
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_user_id uuid := auth.uid();
  v_plan public.devotional_plans%rowtype;
  v_title text;
  v_description text;
  v_days_payload jsonb;
  v_submitted_payload jsonb;
  v_submitted_total_days int;
  v_content_hash text;
  v_submission_id uuid;
  v_submission_number int;
  v_submitted_at timestamptz;
begin
  if v_user_id is null then
    raise exception 'Authentication required';
  end if;

  select *
    into v_plan
  from public.devotional_plans
  where id = p_plan_id
    and author_id = v_user_id
  for update;

  if not found then
    raise exception 'Plan not found';
  end if;

  v_title := btrim(coalesce(v_plan.title, ''));
  v_description := btrim(coalesce(v_plan.description, ''));

  if v_title = '' then
    raise exception 'Plan title is required';
  end if;

  if v_description = '' then
    raise exception 'Plan description is required';
  end if;

  if exists (
    select 1
    from public.plan_submissions ps
    where ps.plan_id = p_plan_id
      and ps.status in ('submitted', 'screening')
  ) then
    raise exception 'This plan already has an active submission';
  end if;

  select
    coalesce(
      jsonb_agg(draft_days.day_snapshot order by draft_days.day_number),
      '[]'::jsonb
    ),
    count(*)
    into v_days_payload, v_submitted_total_days
  from (
    select
      d.day_number,
      jsonb_build_object(
        'day_id', d.id,
        'day_number', d.day_number,
        'title', d.title,
        'content', d.content,
        'scriptures', coalesce(to_jsonb(sr.reference), '[]'::jsonb)
      ) as day_snapshot
    from public.devotional_days_draft d
    left join lateral (
      select s.reference
      from public.scripture_references_draft s
      where s.day_id = d.id
      order by s.created_at desc nulls last, s.id desc
      limit 1
    ) sr on true
    where d.plan_id = p_plan_id
      and btrim(coalesce(d.content, '')) <> ''
  ) as draft_days;

  if v_submitted_total_days = 0 then
    raise exception 'Add at least one completed day before submitting';
  end if;

  v_submitted_payload := jsonb_build_object(
    'plan', jsonb_build_object(
      'title', v_title,
      'description', v_description,
      'cover_image', v_plan.cover_image,
      'tags', coalesce(to_jsonb(v_plan.tags), '[]'::jsonb),
      'total_days', v_submitted_total_days
    ),
    'days', v_days_payload
  );

  v_content_hash := md5(v_submitted_payload::text);

  select coalesce(max(ps.submission_number), 0) + 1
    into v_submission_number
  from public.plan_submissions ps
  where ps.plan_id = p_plan_id;

  insert into public.plan_submissions (
    plan_id,
    author_id,
    submission_number,
    status,
    submitted_payload,
    submitted_title,
    submitted_description,
    submitted_cover_image,
    submitted_tags,
    submitted_total_days,
    content_hash
  )
  values (
    p_plan_id,
    v_user_id,
    v_submission_number,
    'submitted',
    v_submitted_payload,
    v_title,
    v_description,
    v_plan.cover_image,
    coalesce(v_plan.tags, '{}'::text[]),
    v_submitted_total_days,
    v_content_hash
  )
  returning id, plan_submissions.submitted_at
    into v_submission_id, v_submitted_at;

  return query
  select
    v_submission_id,
    p_plan_id,
    v_submission_number,
    'submitted'::text,
    v_submitted_at;
end;
$$;
