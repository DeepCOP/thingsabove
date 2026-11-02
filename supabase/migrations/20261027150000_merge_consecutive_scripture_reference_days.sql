-- Merge adjacent seeded devotional days when their non-empty Scripture-reference arrays match.
-- Retains the first day UUID, preserves all reading text, and remaps progress/comments.

BEGIN;
DO $preflight$
DECLARE
  plan_count integer;
  day_count integer;
  duplicate_reference_days integer;
  malformed_plans integer;
BEGIN
  SELECT count(*) INTO plan_count
  FROM public.devotional_plans
  WHERE id::text LIKE '90000000-0000-0000-0000-%';
  SELECT count(*) INTO day_count
  FROM public.devotional_days AS day
  JOIN public.devotional_plans AS plan ON plan.id = day.plan_id
  WHERE plan.id::text LIKE '90000000-0000-0000-0000-%';
  SELECT count(*) INTO duplicate_reference_days
  FROM (
    SELECT scripture.day_id
    FROM public.scripture_references AS scripture
    JOIN public.devotional_days AS day ON day.id = scripture.day_id
    JOIN public.devotional_plans AS plan ON plan.id = day.plan_id
    WHERE plan.id::text LIKE '90000000-0000-0000-0000-%'
      AND scripture.user_id IS NULL
    GROUP BY scripture.day_id
    HAVING count(*) > 1
  ) AS duplicates;
  SELECT count(*) INTO malformed_plans
  FROM public.devotional_plans AS plan
  WHERE plan.id::text LIKE '90000000-0000-0000-0000-%'
    AND (
      plan.total_days <> (
        SELECT count(*) FROM public.devotional_days AS day WHERE day.plan_id = plan.id
      )
      OR 1 <> (
        SELECT min(day.day_number) FROM public.devotional_days AS day WHERE day.plan_id = plan.id
      )
      OR plan.total_days <> (
        SELECT max(day.day_number) FROM public.devotional_days AS day WHERE day.plan_id = plan.id
      )
    );
  IF plan_count <> 155 OR day_count <> 4394
     OR duplicate_reference_days <> 0 OR malformed_plans <> 0 THEN
    RAISE EXCEPTION
      'Consecutive-reference merge preflight failed: plans %, days %, duplicate reference rows %, malformed plans %',
      plan_count, day_count, duplicate_reference_days, malformed_plans;
  END IF;
END
$preflight$;

CREATE TEMP TABLE consecutive_reference_candidates ON COMMIT DROP AS
WITH source_days AS (
  SELECT
    plan.id AS plan_id,
    day.id AS day_id,
    day.day_number,
    day.title,
    day.content,
    scripture.reference,
    lag(day.day_number) OVER plan_days AS previous_day_number,
    lag(scripture.reference) OVER plan_days AS previous_reference
  FROM public.devotional_plans AS plan
  JOIN public.devotional_days AS day ON day.plan_id = plan.id
  LEFT JOIN public.scripture_references AS scripture
    ON scripture.day_id = day.id AND scripture.user_id IS NULL
  WHERE plan.id::text LIKE '90000000-0000-0000-0000-%'
  WINDOW plan_days AS (PARTITION BY plan.id ORDER BY day.day_number)
), boundaries AS (
  SELECT *,
    CASE
      WHEN coalesce(cardinality(reference), 0) > 0
       AND day_number = previous_day_number + 1
       AND reference IS NOT DISTINCT FROM previous_reference
      THEN 0 ELSE 1
    END AS starts_group
  FROM source_days
)
SELECT *,
  sum(starts_group) OVER (
    PARTITION BY plan_id ORDER BY day_number ROWS UNBOUNDED PRECEDING
  )::integer AS group_number
FROM boundaries;

CREATE TEMP TABLE consecutive_reference_groups ON COMMIT DROP AS
WITH grouped AS (
  SELECT
    plan_id,
    group_number,
    min(day_number) AS first_old_day,
    max(day_number) AS last_old_day,
    count(*)::integer AS group_size,
    (array_agg(day_id ORDER BY day_number))[1] AS keeper_day_id,
    array_agg(day_id ORDER BY day_number) AS old_day_ids,
    array_agg(day_number ORDER BY day_number) AS old_day_numbers
  FROM consecutive_reference_candidates
  GROUP BY plan_id, group_number
), detailed AS (
  SELECT
    grouped.*,
    row_number() OVER (
      PARTITION BY grouped.plan_id ORDER BY grouped.first_old_day
    )::integer AS new_day_number,
    first_day.reference,
    CASE
      WHEN grouped.group_size = 1 THEN first_day.title
      WHEN first_day.title IS NOT DISTINCT FROM last_day.title THEN first_day.title
      ELSE coalesce(first_day.title, 'Day ' || grouped.first_old_day::text)
           || ' — ' || coalesce(last_day.title, 'Day ' || grouped.last_old_day::text)
    END AS merged_title,
    CASE
      WHEN grouped.group_size = 1 THEN first_day.content
      ELSE (
        SELECT string_agg(
          '<p><strong>'
          || replace(replace(replace(replace(replace(
               coalesce(candidate.title, 'Day ' || candidate.day_number::text),
               '&', '&amp;'), '<', '&lt;'), '>', '&gt;'), '"', '&quot;'), '''', '&#x27;')
          || '</strong></p>' || candidate.content,
          '' ORDER BY candidate.day_number
        )
        FROM consecutive_reference_candidates AS candidate
        WHERE candidate.plan_id = grouped.plan_id
          AND candidate.group_number = grouped.group_number
      )
    END AS merged_content
  FROM grouped
  JOIN consecutive_reference_candidates AS first_day
    ON first_day.day_id = grouped.keeper_day_id
  JOIN consecutive_reference_candidates AS last_day
    ON last_day.plan_id = grouped.plan_id
   AND last_day.group_number = grouped.group_number
   AND last_day.day_number = grouped.last_old_day
)
SELECT * FROM detailed;

CREATE TEMP TABLE consecutive_reference_affected_plans ON COMMIT DROP AS
SELECT
  plan_id,
  count(*)::integer AS new_total_days,
  sum(group_size - 1)::integer AS removed_days,
  count(*) FILTER (WHERE group_size > 1)::integer AS merged_runs
FROM consecutive_reference_groups
GROUP BY plan_id
HAVING bool_or(group_size > 1);

DELETE FROM consecutive_reference_groups AS groups
WHERE NOT EXISTS (
  SELECT 1 FROM consecutive_reference_affected_plans AS affected
  WHERE affected.plan_id = groups.plan_id
);
DELETE FROM consecutive_reference_candidates AS candidate
WHERE NOT EXISTS (
  SELECT 1 FROM consecutive_reference_affected_plans AS affected
  WHERE affected.plan_id = candidate.plan_id
);

DO $counts$
DECLARE affected integer; runs integer; removed integer;
BEGIN
  SELECT count(*), sum(merged_runs), sum(removed_days)
  INTO affected, runs, removed
  FROM consecutive_reference_affected_plans;
  IF affected <> 89 OR runs <> 337 OR removed <> 1235 THEN
    RAISE EXCEPTION
      'Consecutive-reference merge inventory changed: affected %, runs %, removed %',
      affected, runs, removed;
  END IF;
END
$counts$;

-- Re-map numeric progress before day numbers change. A merged day is recorded as
-- completed only when every original day in that merged run was completed.
UPDATE public.plan_progress AS progress
SET current_day = coalesce(
      (
        SELECT groups.new_day_number
        FROM consecutive_reference_groups AS groups
        WHERE groups.plan_id = progress.plan_id
          AND progress.current_day = ANY(groups.old_day_numbers)
      ),
      least(greatest(progress.current_day, 1), affected.new_total_days)
    ),
    completed_days = coalesce(
      (
        SELECT array_agg(groups.new_day_number ORDER BY groups.new_day_number)
        FROM consecutive_reference_groups AS groups
        WHERE groups.plan_id = progress.plan_id
          AND NOT EXISTS (
            SELECT 1
            FROM unnest(groups.old_day_numbers) AS old_day(day_number)
            WHERE NOT old_day.day_number = ANY(coalesce(progress.completed_days, '{}'::integer[]))
          )
      ),
      '{}'::integer[]
    ),
    updated_at = now()
FROM consecutive_reference_affected_plans AS affected
WHERE affected.plan_id = progress.plan_id;

-- Snapshot item progress at the retained day. Devotional completion requires
-- completion of every original day; identical Scripture items use logical OR.
CREATE TEMP TABLE consecutive_reference_progress_rows ON COMMIT DROP AS
SELECT
  (array_agg(item.id ORDER BY (item.day_id = groups.keeper_day_id) DESC,
                              item.created_at, item.id))[1] AS id,
  (array_agg(item.user_id ORDER BY item.created_at, item.id))[1] AS user_id,
  groups.plan_id,
  item.progress_id,
  groups.keeper_day_id AS day_id,
  item.item_type,
  item.item_key,
  CASE WHEN item.item_type = 'devotional' THEN groups.merged_content
       ELSE (array_agg(item.devotional_content ORDER BY item.created_at, item.id))[1]
  END AS devotional_content,
  groups.new_day_number AS day_number,
  groups.merged_title AS title,
  (array_agg(item.group_id ORDER BY item.created_at, item.id))[1] AS group_id,
  CASE
    WHEN item.item_type = 'devotional'
      THEN count(DISTINCT item.day_id) = groups.group_size AND bool_and(item.completed)
    ELSE bool_or(item.completed)
  END AS completed,
  min(item.created_at) AS created_at,
  now() AS updated_at
FROM public.day_items_progress AS item
JOIN consecutive_reference_candidates AS candidate ON candidate.day_id = item.day_id
JOIN consecutive_reference_groups AS groups
  ON groups.plan_id = candidate.plan_id
 AND groups.group_number = candidate.group_number
GROUP BY groups.plan_id, item.progress_id, groups.keeper_day_id,
         item.item_type, item.item_key, groups.merged_content,
         groups.new_day_number, groups.merged_title, groups.group_size;

DELETE FROM public.day_items_progress AS item
USING consecutive_reference_candidates AS candidate
WHERE item.day_id = candidate.day_id;

INSERT INTO public.day_items_progress (
  id, user_id, plan_id, progress_id, day_id, item_type, item_key,
  devotional_content, day_number, title, group_id, completed, created_at, updated_at
)
SELECT
  id, user_id, plan_id, progress_id, day_id, item_type, item_key,
  devotional_content, day_number, title, group_id, completed, created_at, updated_at
FROM consecutive_reference_progress_rows;

-- Preserve comments and any user-owned reference rows on the retained day.
UPDATE public.comments AS comment
SET day_id = groups.keeper_day_id,
    updated_at = now()
FROM consecutive_reference_candidates AS candidate
JOIN consecutive_reference_groups AS groups
  ON groups.plan_id = candidate.plan_id
 AND groups.group_number = candidate.group_number
WHERE comment.day_id = candidate.day_id
  AND candidate.day_id <> groups.keeper_day_id;

UPDATE public.scripture_references AS scripture
SET day_id = groups.keeper_day_id,
    updated_at = now()
FROM consecutive_reference_candidates AS candidate
JOIN consecutive_reference_groups AS groups
  ON groups.plan_id = candidate.plan_id
 AND groups.group_number = candidate.group_number
WHERE scripture.day_id = candidate.day_id
  AND scripture.user_id IS NOT NULL
  AND candidate.day_id <> groups.keeper_day_id;

-- Move retained day numbers out of the positive range, delete merged-away rows,
-- then install the merged text and final contiguous numbering.
UPDATE public.devotional_days AS day
SET day_number = -groups.first_old_day,
    updated_at = now()
FROM consecutive_reference_groups AS groups
WHERE day.id = groups.keeper_day_id;

DELETE FROM public.devotional_days AS day
USING consecutive_reference_candidates AS candidate,
      consecutive_reference_groups AS groups
WHERE day.id = candidate.day_id
  AND groups.plan_id = candidate.plan_id
  AND groups.group_number = candidate.group_number
  AND candidate.day_id <> groups.keeper_day_id;

UPDATE public.devotional_days AS day
SET day_number = groups.new_day_number,
    title = groups.merged_title,
    content = groups.merged_content,
    updated_at = now()
FROM consecutive_reference_groups AS groups
WHERE day.id = groups.keeper_day_id;

UPDATE public.scripture_references AS scripture
SET reference = groups.reference,
    updated_at = now()
FROM consecutive_reference_groups AS groups
WHERE scripture.day_id = groups.keeper_day_id
  AND scripture.user_id IS NULL;

UPDATE public.devotional_plans AS plan
SET total_days = affected.new_total_days,
    updated_at = now()
FROM consecutive_reference_affected_plans AS affected
WHERE plan.id = affected.plan_id;

UPDATE public.devotional_plans
SET description = replace(
      replace(description, '346 quiet-hour selections', '344 quiet-hour readings'),
      'day 313', 'day 311'
    ),
    updated_at = now()
WHERE id = '90000000-0000-0000-0000-000000000242'::uuid;

UPDATE public.devotional_plans
SET description = replace(description, '16 original sections', '2 merged readings'),
    updated_at = now()
WHERE id = '90000000-0000-0000-0000-000000000291'::uuid;

DO $postflight$
DECLARE plan_count integer; day_count integer; repeated integer; malformed integer;
BEGIN
  SELECT count(*) INTO plan_count
  FROM public.devotional_plans
  WHERE id::text LIKE '90000000-0000-0000-0000-%';
  SELECT count(*) INTO day_count
  FROM public.devotional_days AS day
  JOIN public.devotional_plans AS plan ON plan.id = day.plan_id
  WHERE plan.id::text LIKE '90000000-0000-0000-0000-%';

  WITH ordered AS (
    SELECT day.plan_id, day.day_number, scripture.reference,
           lag(day.day_number) OVER plan_days AS previous_day,
           lag(scripture.reference) OVER plan_days AS previous_reference
    FROM public.devotional_days AS day
    JOIN public.devotional_plans AS plan ON plan.id = day.plan_id
    LEFT JOIN public.scripture_references AS scripture
      ON scripture.day_id = day.id AND scripture.user_id IS NULL
    WHERE plan.id::text LIKE '90000000-0000-0000-0000-%'
    WINDOW plan_days AS (PARTITION BY day.plan_id ORDER BY day.day_number)
  )
  SELECT count(*) INTO repeated
  FROM ordered
  WHERE coalesce(cardinality(reference), 0) > 0
    AND day_number = previous_day + 1
    AND reference IS NOT DISTINCT FROM previous_reference;

  SELECT count(*) INTO malformed
  FROM public.devotional_plans AS plan
  WHERE plan.id::text LIKE '90000000-0000-0000-0000-%'
    AND (
      plan.total_days <> (
        SELECT count(*) FROM public.devotional_days AS day WHERE day.plan_id = plan.id
      )
      OR 1 <> (
        SELECT min(day.day_number) FROM public.devotional_days AS day WHERE day.plan_id = plan.id
      )
      OR plan.total_days <> (
        SELECT max(day.day_number) FROM public.devotional_days AS day WHERE day.plan_id = plan.id
      )
    );

  IF plan_count <> 155 OR day_count <> 3159 OR repeated <> 0 OR malformed <> 0 THEN
    RAISE EXCEPTION
      'Consecutive-reference merge postflight failed: plans %, days %, repeated %, malformed %',
      plan_count, day_count, repeated, malformed;
  END IF;
END
$postflight$;
COMMIT;
