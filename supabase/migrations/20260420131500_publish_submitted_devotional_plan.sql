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
  day_item jsonb;
  upserted_day_id uuid;
  published_days_count int;
begin
  if coalesce(auth.jwt() ->> 'role', '') <> 'service_role' then
    raise exception 'Not authorized';
  end if;

  select *
    into v_submission
  from public.plan_submissions
  where id = p_submission_id
  for update;

  if not found then
    raise exception 'Submission not found';
  end if;

  if v_submission.status not in ('submitted', 'screening') then
    raise exception 'Submission is not ready to publish';
  end if;

  if v_submission.screening_decision <> 'pass' then
    raise exception 'Submission did not pass screening';
  end if;

  v_days_payload := coalesce(v_submission.submitted_payload -> 'days', '[]'::jsonb);

  if jsonb_typeof(v_days_payload) <> 'array' then
    raise exception 'Submission payload is invalid';
  end if;

  select count(*)
    into published_days_count
  from jsonb_array_elements(v_days_payload) as day_value
  where btrim(coalesce(day_value ->> 'content', '')) <> '';

  if published_days_count = 0 then
    raise exception 'Submission has no publishable days';
  end if;

  delete from public.devotional_days
  where plan_id = v_submission.plan_id
    and day_number not in (
      select (day_value ->> 'day_number')::int
      from jsonb_array_elements(v_days_payload) as day_value
      where btrim(coalesce(day_value ->> 'content', '')) <> ''
    );

  for day_item in
    select day_value
    from jsonb_array_elements(v_days_payload) as day_value
    where btrim(coalesce(day_value ->> 'content', '')) <> ''
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
      day_item ->> 'content',
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

    if jsonb_array_length(coalesce(day_item -> 'scriptures', '[]'::jsonb)) > 0 then
      insert into public.scripture_references (day_id, reference)
      select
        upserted_day_id,
        array_agg(value)
      from jsonb_array_elements_text(coalesce(day_item -> 'scriptures', '[]'::jsonb));
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
    updated_at = now()
  where id = v_submission.plan_id;

  update public.plan_submissions
  set
    status = 'published',
    published_at = coalesce(published_at, now())
  where id = p_submission_id;
end;
$$;
