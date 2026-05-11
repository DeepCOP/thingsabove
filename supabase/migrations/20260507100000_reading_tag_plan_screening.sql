create or replace function public.plan_tags()
returns text[]
language sql
immutable
set search_path = pg_catalog, public
as $$
  select array[
    'Prayer',
    'Faith',
    'Hope',
    'Healing',
    'Gratitude',
    'Peace',
    'Wisdom',
    'Discipleship',
    'Family',
    'Leadership',
    'Knowledge',
    'Reading',
    'Virtue',
    'Fellowship'
  ]::text[];
$$;

create or replace function public.tags_include_reading(tags text[])
returns boolean
language sql
immutable
set search_path = pg_catalog, public
as $$
  select exists (
    select 1
    from unnest(coalesce(tags, '{}'::text[])) as tag(value)
    where lower(btrim(tag.value)) = 'reading'
  );
$$;

drop function if exists public.submit_devotional_plan_for_screening(uuid);
drop function if exists public.submit_devotional_plan_for_screening(uuid, text);

create or replace function public.submit_devotional_plan_for_screening(
  p_plan_id uuid,
  p_visibility text default null
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
  v_requested_visibility text := nullif(lower(btrim(coalesce(p_visibility, ''))), '');
  v_submitted_visibility text;
  v_is_reading_plan boolean;
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

  v_submitted_visibility := coalesce(
    v_requested_visibility,
    nullif(lower(btrim(coalesce(v_plan.visibility, ''))), ''),
    'public'
  );

  if v_submitted_visibility not in ('public', 'private') then
    raise exception 'Invalid plan visibility';
  end if;

  v_is_reading_plan := public.tags_include_reading(v_plan.tags);
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
        'content', coalesce(d.content, ''),
        'scriptures', coalesce(
          (
            select to_jsonb(array_agg(btrim(refs.ref)))
            from unnest(coalesce(sr.reference, '{}'::text[])) as refs(ref)
            where btrim(refs.ref) <> ''
          ),
          '[]'::jsonb
        )
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
      and (
        (
          v_is_reading_plan
          and exists (
            select 1
            from unnest(coalesce(sr.reference, '{}'::text[])) as refs(ref)
            where btrim(refs.ref) <> ''
          )
        )
        or (
          not v_is_reading_plan
          and btrim(coalesce(d.content, '')) <> ''
        )
      )
  ) as draft_days;

  if v_submitted_total_days = 0 then
    select
      coalesce(
        jsonb_agg(published_days.day_snapshot order by published_days.day_number),
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
          'content', coalesce(d.content, ''),
          'scriptures', coalesce(
            (
              select to_jsonb(array_agg(btrim(refs.ref)))
              from unnest(coalesce(sr.reference, '{}'::text[])) as refs(ref)
              where btrim(refs.ref) <> ''
            ),
            '[]'::jsonb
          )
        ) as day_snapshot
      from public.devotional_days d
      left join lateral (
        select s.reference
        from public.scripture_references s
        where s.day_id = d.id
        order by s.created_at desc nulls last, s.id desc
        limit 1
      ) sr on true
      where d.plan_id = p_plan_id
        and (
          (
            v_is_reading_plan
            and exists (
              select 1
              from unnest(coalesce(sr.reference, '{}'::text[])) as refs(ref)
              where btrim(refs.ref) <> ''
            )
          )
          or (
            not v_is_reading_plan
            and btrim(coalesce(d.content, '')) <> ''
          )
        )
    ) as published_days;
  end if;

  if v_submitted_total_days = 0 then
    if v_is_reading_plan then
      raise exception 'Add at least one day with scripture references before submitting a reading plan';
    end if;

    raise exception 'Add at least one completed day before submitting';
  end if;

  v_submitted_payload := jsonb_build_object(
    'plan', jsonb_build_object(
      'title', v_title,
      'description', v_description,
      'cover_image', v_plan.cover_image,
      'tags', coalesce(to_jsonb(v_plan.tags), '[]'::jsonb),
      'total_days', v_submitted_total_days,
      'visibility', v_submitted_visibility,
      'is_reading_plan', v_is_reading_plan
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
    submitted_visibility,
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
    v_submitted_visibility,
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

drop function if exists public.publish_submitted_devotional_plan(uuid);

create or replace function public.publish_submitted_devotional_plan(
  p_submission_id uuid
)
returns void
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_submission public.plan_submissions%rowtype;
  v_days_payload jsonb;
  v_is_service_role boolean := coalesce(auth.jwt() ->> 'role', '') = 'service_role';
  v_is_reading_plan boolean;
  day_item jsonb;
  upserted_day_id uuid;
  published_days_count int;
begin
  select *
    into v_submission
  from public.plan_submissions
  where id = p_submission_id
  for update;

  if not found then
    raise exception 'Submission not found';
  end if;

  if not v_is_service_role then
    if auth.uid() is null or auth.uid() <> v_submission.author_id then
      raise exception 'Not authorized';
    end if;

    if v_submission.status <> 'approved' then
      raise exception 'Submission is not approved for publishing';
    end if;
  elsif v_submission.status not in ('screening', 'approved') then
    raise exception 'Submission is not ready to publish';
  end if;

  if v_submission.screening_decision <> 'pass' then
    raise exception 'Submission did not pass screening';
  end if;

  v_days_payload := coalesce(v_submission.submitted_payload -> 'days', '[]'::jsonb);

  if jsonb_typeof(v_days_payload) <> 'array' then
    raise exception 'Submission payload is invalid';
  end if;

  v_is_reading_plan := public.tags_include_reading(v_submission.submitted_tags);

  select count(*)
    into published_days_count
  from jsonb_array_elements(v_days_payload) as day_value
  where case
    when v_is_reading_plan then
      case
        when jsonb_typeof(coalesce(day_value -> 'scriptures', '[]'::jsonb)) = 'array'
          then exists (
            select 1
            from jsonb_array_elements_text(coalesce(day_value -> 'scriptures', '[]'::jsonb)) as refs(ref)
            where btrim(refs.ref) <> ''
          )
        else false
      end
    else
      btrim(coalesce(day_value ->> 'content', '')) <> ''
    end;

  if published_days_count = 0 then
    if v_is_reading_plan then
      raise exception 'Submission has no publishable reading days';
    end if;

    raise exception 'Submission has no publishable days';
  end if;

  delete from public.devotional_days
  where plan_id = v_submission.plan_id
    and day_number not in (
      select (day_value ->> 'day_number')::int
      from jsonb_array_elements(v_days_payload) as day_value
      where case
        when v_is_reading_plan then
          case
            when jsonb_typeof(coalesce(day_value -> 'scriptures', '[]'::jsonb)) = 'array'
              then exists (
                select 1
                from jsonb_array_elements_text(coalesce(day_value -> 'scriptures', '[]'::jsonb)) as refs(ref)
                where btrim(refs.ref) <> ''
              )
            else false
          end
        else
          btrim(coalesce(day_value ->> 'content', '')) <> ''
        end
    );

  for day_item in
    select day_value
    from jsonb_array_elements(v_days_payload) as day_value
    where case
      when v_is_reading_plan then
        case
          when jsonb_typeof(coalesce(day_value -> 'scriptures', '[]'::jsonb)) = 'array'
            then exists (
              select 1
              from jsonb_array_elements_text(coalesce(day_value -> 'scriptures', '[]'::jsonb)) as refs(ref)
              where btrim(refs.ref) <> ''
            )
          else false
        end
      else
        btrim(coalesce(day_value ->> 'content', '')) <> ''
      end
    order by (day_value ->> 'day_number')::int
  loop
    insert into public.devotional_days (
      plan_id,
      day_number,
      content,
      title
    )
    values (
      v_submission.plan_id,
      (day_item ->> 'day_number')::int,
      coalesce(day_item ->> 'content', ''),
      nullif(day_item ->> 'title', '')
    )
    on conflict (plan_id, day_number)
    do update set
      content = excluded.content,
      title = excluded.title,
      updated_at = now()
    returning id into upserted_day_id;

    delete from public.scripture_references
    where day_id = upserted_day_id;

    if jsonb_typeof(coalesce(day_item -> 'scriptures', '[]'::jsonb)) = 'array' then
      insert into public.scripture_references (day_id, reference)
      select
        upserted_day_id,
        array_agg(btrim(value))
      from jsonb_array_elements_text(coalesce(day_item -> 'scriptures', '[]'::jsonb))
      where btrim(value) <> ''
      having count(*) > 0;
    end if;
  end loop;

  update public.devotional_plans
  set
    title = v_submission.submitted_title,
    description = v_submission.submitted_description,
    cover_image = v_submission.submitted_cover_image,
    tags = v_submission.submitted_tags,
    status = 'published',
    total_days = published_days_count,
    visibility = coalesce(nullif(v_submission.submitted_visibility, ''), 'public'),
    updated_at = now()
  where id = v_submission.plan_id;

  update public.plan_submissions
  set
    status = 'published',
    published_at = coalesce(published_at, now())
  where id = p_submission_id;
end;
$$;

create or replace function public.get_day_item_templates(
  p_plan_id uuid,
  p_day_id uuid,
  p_group_id uuid default null
)
returns table (
  item_type text,
  item_key text,
  devotional_content text,
  day_number int,
  title text
)
language sql
stable
as $$
  with day_base as (
    select
      dd.content as devotional_content,
      dd.day_number,
      dd.title
    from public.devotional_days dd
    where dd.id = p_day_id
      and dd.plan_id = p_plan_id
  ),
  scripture_items as (
    select distinct trim(refs.ref) as item_key
    from public.scripture_references sr
    cross join lateral unnest(coalesce(sr.reference, '{}'::text[])) as refs(ref)
    where sr.day_id = p_day_id
      and nullif(trim(refs.ref), '') is not null
  )
  select
    'devotional'::text as item_type,
    'main'::text as item_key,
    db.devotional_content,
    db.day_number,
    db.title
  from day_base db
  where btrim(coalesce(db.devotional_content, '')) <> ''

  union all

  select
    'scripture'::text as item_type,
    si.item_key,
    null::text as devotional_content,
    db.day_number,
    db.title
  from day_base db
  join scripture_items si on true

  union all

  select
    'comment'::text as item_type,
    'comment'::text as item_key,
    null::text as devotional_content,
    db.day_number,
    db.title
  from day_base db
  where p_group_id is not null;
$$;
