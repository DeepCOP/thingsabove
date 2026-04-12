create or replace function public.save_devotional_draft(
  _plan_id uuid,
  _days jsonb
)
returns void
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
begin
  -- Remove existing scripture refs for this plan's draft days.
  delete from public.scripture_references_draft
  where day_id in (
    select id
    from public.devotional_days_draft
    where plan_id = _plan_id
  );

  -- Replace the draft wholesale for this plan.
  delete from public.devotional_days_draft
  where plan_id = _plan_id;

  insert into public.devotional_days_draft (plan_id, day_number, content, title)
  select
    _plan_id,
    (d->>'day_number')::int,
    d->>'content',
    d->>'title'
  from jsonb_array_elements(_days) d;

  insert into public.scripture_references_draft (day_id, reference)
  select
    dd.id,
    array(
      select jsonb_array_elements_text(coalesce(d->'scriptures', '[]'::jsonb))
    )
  from jsonb_array_elements(_days) d
  join public.devotional_days_draft dd
    on dd.plan_id = _plan_id
   and dd.day_number = (d->>'day_number')::int;
end;
$$;
