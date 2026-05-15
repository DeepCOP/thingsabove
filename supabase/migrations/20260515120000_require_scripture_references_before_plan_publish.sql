create or replace function public.jsonb_has_nonempty_text_array(p_value jsonb)
returns boolean
language sql
immutable
set search_path = pg_catalog, public
as $$
  select case
    when jsonb_typeof(coalesce(p_value, '[]'::jsonb)) <> 'array' then false
    else exists (
      select 1
      from jsonb_array_elements_text(coalesce(p_value, '[]'::jsonb)) as values(value)
      where btrim(values.value) <> ''
    )
  end;
$$;

create or replace function public.plan_submission_days_have_scripture_references(p_payload jsonb)
returns boolean
language plpgsql
immutable
set search_path = pg_catalog, public
as $$
declare
  v_days jsonb := p_payload -> 'days';
begin
  if jsonb_typeof(v_days) is distinct from 'array' then
    return false;
  end if;

  if jsonb_array_length(v_days) = 0 then
    return false;
  end if;

  return not exists (
    select 1
    from jsonb_array_elements(v_days) as day_value
    where not public.jsonb_has_nonempty_text_array(day_value -> 'scriptures')
  );
end;
$$;

create or replace function public.published_plan_days_have_scripture_references(p_plan_id uuid)
returns boolean
language sql
stable
set search_path = pg_catalog, public
as $$
  select
    exists (
      select 1
      from public.devotional_days as day
      where day.plan_id = p_plan_id
    )
    and not exists (
      select 1
      from public.devotional_days as day
      where day.plan_id = p_plan_id
        and not exists (
          select 1
          from public.scripture_references as scripture
          where scripture.day_id = day.id
            and public.jsonb_has_nonempty_text_array(to_jsonb(scripture.reference))
        )
    );
$$;

create or replace function public.enforce_plan_submission_scripture_references()
returns trigger
language plpgsql
set search_path = pg_catalog, public
as $$
begin
  if not public.plan_submission_days_have_scripture_references(new.submitted_payload) then
    raise exception
      'Every submitted plan day must include at least one scripture reference before publishing.'
      using errcode = '23514';
  end if;

  return new;
end;
$$;

drop trigger if exists plan_submissions_require_scripture_references
on public.plan_submissions;

create trigger plan_submissions_require_scripture_references
before insert or update of submitted_payload on public.plan_submissions
for each row
execute function public.enforce_plan_submission_scripture_references();

create or replace function public.enforce_published_plan_scripture_references()
returns trigger
language plpgsql
set search_path = pg_catalog, public
as $$
begin
  if not public.published_plan_days_have_scripture_references(new.id) then
    raise exception
      'Every published plan day must include at least one scripture reference.'
      using errcode = '23514';
  end if;

  return new;
end;
$$;

drop trigger if exists devotional_plans_require_scripture_references_when_published
on public.devotional_plans;

create constraint trigger devotional_plans_require_scripture_references_when_published
after insert or update of status on public.devotional_plans
deferrable initially deferred
for each row
when (new.status = 'published')
execute function public.enforce_published_plan_scripture_references();
