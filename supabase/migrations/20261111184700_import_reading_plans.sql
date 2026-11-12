-- Consolidated reading-plan catalog: 30 plans and 1,173 daily assignments.
-- Preserves the five original batches, their source notes, UUIDs, and validations.
-- All batches run in one transaction; temporary tables are dropped at commit.
-- Apply before 20261112184500_add_reading_plan_cover_images.sql.

BEGIN;

-- Source batch: 20261111184700_import_historical_psalter_reading_plan.sql
-- Bible reading catalog data migration (partial verified batch).
-- Plan: 1662 Book of Common Prayer Psalter, 30-day cycle (complete Psalms).
-- Historical public-domain text source: https://merecatholicity.com/bcp1662.html
-- Historical edition: Book of Common Prayer, 1662; reuse basis: historical
-- public-domain schedule, independently republished as public-domain text.
-- NOTE: modern Church of England webpage states Crown rights in its edition.
-- This file imports only chapter/verse assignments of the historical schedule,
-- not its page text, formatting, annotations, prayers, or Bible passage text.
-- Assignment verification: https://www.churchofengland.org/liturgy/book-of-common-prayer/psalter-book-common-prayer
-- UK Crown/territorial rights not independently legally cleared; review for
-- deployment jurisdiction before distribution.
-- No live database access used; run in privileged Supabase migrations.
DO $reading_plan_seed$
DECLARE
  v_plan uuid := '19e91725-8110-538e-8e38-95c2e0fc6ace'::uuid;
  v_day uuid;
  v_day_num integer;
  v_ref text[];
  v_existing integer;
BEGIN
  -- Do not hijack a preexisting plan with this fixed UUID but different identity.
  IF EXISTS (SELECT 1 FROM public.devotional_plans WHERE id = v_plan
             AND title <> 'Psalms in 30 Days — 1662 Prayer Book Psalter') THEN
    RAISE EXCEPTION 'Reading plan UUID collision: %', v_plan;
  END IF;
  INSERT INTO public.devotional_plans
    (id,title,description,cover_image,completions,tags,status,total_days,author_id,visibility)
  VALUES
    (v_plan, 'Psalms in 30 Days — 1662 Prayer Book Psalter',
     'Read the complete Book of Psalms in the historic thirty-day morning-and-evening sequence from the 1662 Book of Common Prayer.',
     NULL, 0, ARRAY['reading']::text[], 'draft', 30, NULL, 'public')
  ON CONFLICT (id) DO UPDATE
    SET total_days = EXCLUDED.total_days,
        tags = CASE WHEN NOT ('reading' = ANY(COALESCE(public.devotional_plans.tags, '{}'::text[])))
                    THEN array_append(COALESCE(public.devotional_plans.tags, '{}'::text[]), 'reading')
                    ELSE public.devotional_plans.tags END;

  FOR v_day_num, v_ref IN
    SELECT day_no, passages FROM (VALUES
      (1, ARRAY['Psalms 1', 'Psalms 2', 'Psalms 3', 'Psalms 4', 'Psalms 5', 'Psalms 6', 'Psalms 7', 'Psalms 8']::text[]),
      (2, ARRAY['Psalms 9', 'Psalms 10', 'Psalms 11', 'Psalms 12', 'Psalms 13', 'Psalms 14']::text[]),
      (3, ARRAY['Psalms 15', 'Psalms 16', 'Psalms 17', 'Psalms 18']::text[]),
      (4, ARRAY['Psalms 19', 'Psalms 20', 'Psalms 21', 'Psalms 22', 'Psalms 23']::text[]),
      (5, ARRAY['Psalms 24', 'Psalms 25', 'Psalms 26', 'Psalms 27', 'Psalms 28', 'Psalms 29']::text[]),
      (6, ARRAY['Psalms 30', 'Psalms 31', 'Psalms 32', 'Psalms 33', 'Psalms 34']::text[]),
      (7, ARRAY['Psalms 35', 'Psalms 36', 'Psalms 37']::text[]),
      (8, ARRAY['Psalms 38', 'Psalms 39', 'Psalms 40', 'Psalms 41', 'Psalms 42', 'Psalms 43']::text[]),
      (9, ARRAY['Psalms 44', 'Psalms 45', 'Psalms 46', 'Psalms 47', 'Psalms 48', 'Psalms 49']::text[]),
      (10, ARRAY['Psalms 50', 'Psalms 51', 'Psalms 52', 'Psalms 53', 'Psalms 54', 'Psalms 55']::text[]),
      (11, ARRAY['Psalms 56', 'Psalms 57', 'Psalms 58', 'Psalms 59', 'Psalms 60', 'Psalms 61']::text[]),
      (12, ARRAY['Psalms 62', 'Psalms 63', 'Psalms 64', 'Psalms 65', 'Psalms 66', 'Psalms 67']::text[]),
      (13, ARRAY['Psalms 68', 'Psalms 69', 'Psalms 70']::text[]),
      (14, ARRAY['Psalms 71', 'Psalms 72', 'Psalms 73', 'Psalms 74']::text[]),
      (15, ARRAY['Psalms 75', 'Psalms 76', 'Psalms 77', 'Psalms 78']::text[]),
      (16, ARRAY['Psalms 79', 'Psalms 80', 'Psalms 81', 'Psalms 82', 'Psalms 83', 'Psalms 84', 'Psalms 85']::text[]),
      (17, ARRAY['Psalms 86', 'Psalms 87', 'Psalms 88', 'Psalms 89']::text[]),
      (18, ARRAY['Psalms 90', 'Psalms 91', 'Psalms 92', 'Psalms 93', 'Psalms 94']::text[]),
      (19, ARRAY['Psalms 95', 'Psalms 96', 'Psalms 97', 'Psalms 98', 'Psalms 99', 'Psalms 100', 'Psalms 101']::text[]),
      (20, ARRAY['Psalms 102', 'Psalms 103', 'Psalms 104']::text[]),
      (21, ARRAY['Psalms 105', 'Psalms 106']::text[]),
      (22, ARRAY['Psalms 107', 'Psalms 108', 'Psalms 109']::text[]),
      (23, ARRAY['Psalms 110', 'Psalms 111', 'Psalms 112', 'Psalms 113', 'Psalms 114', 'Psalms 115']::text[]),
      (24, ARRAY['Psalms 116', 'Psalms 117', 'Psalms 118', 'Psalms 119:1-32']::text[]),
      (25, ARRAY['Psalms 119:33-72', 'Psalms 119:73-104']::text[]),
      (26, ARRAY['Psalms 119:105-144', 'Psalms 119:145-176']::text[]),
      (27, ARRAY['Psalms 120', 'Psalms 121', 'Psalms 122', 'Psalms 123', 'Psalms 124', 'Psalms 125', 'Psalms 126', 'Psalms 127', 'Psalms 128', 'Psalms 129', 'Psalms 130', 'Psalms 131']::text[]),
      (28, ARRAY['Psalms 132', 'Psalms 133', 'Psalms 134', 'Psalms 135', 'Psalms 136', 'Psalms 137', 'Psalms 138']::text[]),
      (29, ARRAY['Psalms 139', 'Psalms 140', 'Psalms 141', 'Psalms 142', 'Psalms 143']::text[]),
      (30, ARRAY['Psalms 144', 'Psalms 145', 'Psalms 146', 'Psalms 147', 'Psalms 148', 'Psalms 149', 'Psalms 150']::text[])
    ) AS source_days(day_no,passages)
    ORDER BY day_no
  LOOP
    INSERT INTO public.devotional_days (id,plan_id,day_number,content,title)
    VALUES (gen_random_uuid(),v_plan,v_day_num,'',NULL)
    ON CONFLICT (plan_id,day_number)
    DO UPDATE SET content = '', title = NULL
    RETURNING id INTO v_day;

    -- The schema has no unique key on scripture_references.day_id.
    -- For an existing imported day, update the existing catalog reference row.
    UPDATE public.scripture_references
       SET reference = v_ref
     WHERE day_id = v_day AND user_id IS NULL;
    GET DIAGNOSTICS v_existing = ROW_COUNT;
    IF v_existing = 0 THEN
      INSERT INTO public.scripture_references (id,day_id,user_id,reference)
      VALUES (gen_random_uuid(),v_day,NULL,v_ref);
    ELSIF v_existing > 1 THEN
      RAISE EXCEPTION 'Duplicate catalog scripture reference rows on day %', v_day;
    END IF;
  END LOOP;

  -- Reject missing, extra, or nonsequential days before publication.
  IF (SELECT count(*) FROM public.devotional_days WHERE plan_id=v_plan) <> 30
     OR EXISTS (SELECT 1 FROM generate_series(1,30) n
          WHERE NOT EXISTS (SELECT 1 FROM public.devotional_days
                            WHERE plan_id=v_plan AND day_number=n)) THEN
    RAISE EXCEPTION 'Reading plan day-count/number validation failed';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.devotional_days d
    WHERE d.plan_id=v_plan AND (d.content <> '' OR NOT EXISTS (
       SELECT 1 FROM public.scripture_references s
       WHERE s.day_id=d.id AND s.user_id IS NULL
         AND cardinality(s.reference)>0))) THEN
    RAISE EXCEPTION 'Reading plan scripture/content validation failed';
  END IF;
  UPDATE public.devotional_plans SET status='published' WHERE id=v_plan;
END
$reading_plan_seed$;

-- Source batch: 20261111192500_import_open_word_bible_chapter_reading_plans.sql
-- Source: Open Word Bible, https://openwordbible.org/plans/
-- Rights: site displays 'CC0 Public domain: quote it, print it, build on it.'
-- https://openwordbible.org/about/ clarifies translation/notes CC0; schedule-specific
-- licensing is not separately specified. These one-chapter-a-day assignments
-- are factual schedules, transcribed from the publisher's daily lists.
-- No Bible text, notes, or devotional prose is imported.
-- Schema basis: supplied reading-plan-migration-schema.md (not a live schema export).
-- The historical Psalter is imported in the preceding section.
CREATE TEMP TABLE import_reading_plan_catalog (
  id uuid PRIMARY KEY, title text NOT NULL, description text NOT NULL,
  source_url text NOT NULL, expected_days integer NOT NULL
) ON COMMIT DROP;
INSERT INTO import_reading_plan_catalog VALUES
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 'Genesis in 50 Days', 'Read the complete book of Genesis, one chapter per day, in canonical chapter order.', 'https://openwordbible.org/plans/genesis/', 50),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 'Exodus in 40 Days', 'Read the complete book of Exodus, one chapter per day, in canonical chapter order.', 'https://openwordbible.org/plans/exodus/', 40),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 'Leviticus in 27 Days', 'Read the complete book of Leviticus, one chapter per day, in canonical chapter order.', 'https://openwordbible.org/plans/leviticus/', 27),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 'Isaiah in 66 Days', 'Read the complete book of Isaiah, one chapter per day, in canonical chapter order.', 'https://openwordbible.org/plans/isaiah/', 66),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 'Proverbs in 31 Days', 'Read the complete book of Proverbs, one chapter per day, in canonical chapter order.', 'https://openwordbible.org/plans/proverbs/', 31),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 'Matthew in 28 Days', 'Read the complete book of Matthew, one chapter per day, in canonical chapter order.', 'https://openwordbible.org/plans/matthew/', 28),
  ('6c0f799a-f7cc-5bd4-97b0-6167b080ca06'::uuid, 'Mark in 16 Days', 'Read the complete book of Mark, one chapter per day, in canonical chapter order.', 'https://openwordbible.org/plans/mark/', 16),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 'Luke in 24 Days', 'Read the complete book of Luke, one chapter per day, in canonical chapter order.', 'https://openwordbible.org/plans/luke/', 24),
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 'John in 21 Days', 'Read the complete book of John, one chapter per day, in canonical chapter order.', 'https://openwordbible.org/plans/john/', 21),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 'Acts in 28 Days', 'Read the complete book of Acts, one chapter per day, in canonical chapter order.', 'https://openwordbible.org/plans/acts/', 28),
  ('92b132bb-6ee3-564e-a95d-8274ac10bfc6'::uuid, 'Romans in 16 Days', 'Read the complete book of Romans, one chapter per day, in canonical chapter order.', 'https://openwordbible.org/plans/romans/', 16),
  ('ab8ee088-6823-5ef9-b1c2-34b767280496'::uuid, '1 Corinthians in 16 Days', 'Read the complete book of 1 Corinthians, one chapter per day, in canonical chapter order.', 'https://openwordbible.org/plans/1-corinthians/', 16),
  ('2cbb3b87-2511-5375-8ce1-a4294696f431'::uuid, 'Hebrews in 13 Days', 'Read the complete book of Hebrews, one chapter per day, in canonical chapter order.', 'https://openwordbible.org/plans/hebrews/', 13),
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 'Revelation in 22 Days', 'Read the complete book of Revelation, one chapter per day, in canonical chapter order.', 'https://openwordbible.org/plans/revelation/', 22),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 'The Four Gospels in 89 Days', 'Read every chapter of Matthew, Mark, Luke and John in order, one chapter each day.', 'https://openwordbible.org/plans/gospels/', 89),
  ('7400ac43-f0ea-5b0a-bb2a-06633a41746e'::uuid, 'James, Peter and Jude in 14 Days', 'Read James, both letters of Peter and Jude in canonical order, one chapter each day.', 'https://openwordbible.org/plans/james-peter-jude/', 14),
  ('46fc6363-6105-557d-be22-943ad6fb8d1c'::uuid, 'Galatians, Ephesians and Colossians in 16 Days', 'Read all chapters of Galatians, Ephesians and Colossians in order, one chapter each day.', 'https://openwordbible.org/plans/galatians-ephesians-colossians/', 16);

-- Each assignment below is a separate explicit source day: no gaps or inferred days.
CREATE TEMP TABLE import_reading_assignments (
  plan_id uuid NOT NULL, day_number integer NOT NULL, reference text[] NOT NULL,
  PRIMARY KEY(plan_id,day_number)
) ON COMMIT DROP;
INSERT INTO import_reading_assignments (plan_id,day_number,reference) VALUES
-- Plan: Genesis in 50 Days; source: https://openwordbible.org/plans/genesis/; rights notice: https://openwordbible.org/plans/
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 1, ARRAY['Genesis 1']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 2, ARRAY['Genesis 2']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 3, ARRAY['Genesis 3']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 4, ARRAY['Genesis 4']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 5, ARRAY['Genesis 5']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 6, ARRAY['Genesis 6']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 7, ARRAY['Genesis 7']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 8, ARRAY['Genesis 8']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 9, ARRAY['Genesis 9']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 10, ARRAY['Genesis 10']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 11, ARRAY['Genesis 11']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 12, ARRAY['Genesis 12']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 13, ARRAY['Genesis 13']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 14, ARRAY['Genesis 14']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 15, ARRAY['Genesis 15']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 16, ARRAY['Genesis 16']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 17, ARRAY['Genesis 17']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 18, ARRAY['Genesis 18']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 19, ARRAY['Genesis 19']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 20, ARRAY['Genesis 20']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 21, ARRAY['Genesis 21']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 22, ARRAY['Genesis 22']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 23, ARRAY['Genesis 23']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 24, ARRAY['Genesis 24']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 25, ARRAY['Genesis 25']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 26, ARRAY['Genesis 26']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 27, ARRAY['Genesis 27']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 28, ARRAY['Genesis 28']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 29, ARRAY['Genesis 29']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 30, ARRAY['Genesis 30']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 31, ARRAY['Genesis 31']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 32, ARRAY['Genesis 32']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 33, ARRAY['Genesis 33']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 34, ARRAY['Genesis 34']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 35, ARRAY['Genesis 35']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 36, ARRAY['Genesis 36']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 37, ARRAY['Genesis 37']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 38, ARRAY['Genesis 38']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 39, ARRAY['Genesis 39']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 40, ARRAY['Genesis 40']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 41, ARRAY['Genesis 41']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 42, ARRAY['Genesis 42']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 43, ARRAY['Genesis 43']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 44, ARRAY['Genesis 44']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 45, ARRAY['Genesis 45']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 46, ARRAY['Genesis 46']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 47, ARRAY['Genesis 47']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 48, ARRAY['Genesis 48']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 49, ARRAY['Genesis 49']::text[]),
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 50, ARRAY['Genesis 50']::text[]),
-- Plan: Exodus in 40 Days; source: https://openwordbible.org/plans/exodus/; rights notice: https://openwordbible.org/plans/
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 1, ARRAY['Exodus 1']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 2, ARRAY['Exodus 2']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 3, ARRAY['Exodus 3']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 4, ARRAY['Exodus 4']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 5, ARRAY['Exodus 5']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 6, ARRAY['Exodus 6']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 7, ARRAY['Exodus 7']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 8, ARRAY['Exodus 8']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 9, ARRAY['Exodus 9']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 10, ARRAY['Exodus 10']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 11, ARRAY['Exodus 11']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 12, ARRAY['Exodus 12']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 13, ARRAY['Exodus 13']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 14, ARRAY['Exodus 14']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 15, ARRAY['Exodus 15']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 16, ARRAY['Exodus 16']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 17, ARRAY['Exodus 17']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 18, ARRAY['Exodus 18']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 19, ARRAY['Exodus 19']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 20, ARRAY['Exodus 20']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 21, ARRAY['Exodus 21']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 22, ARRAY['Exodus 22']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 23, ARRAY['Exodus 23']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 24, ARRAY['Exodus 24']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 25, ARRAY['Exodus 25']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 26, ARRAY['Exodus 26']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 27, ARRAY['Exodus 27']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 28, ARRAY['Exodus 28']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 29, ARRAY['Exodus 29']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 30, ARRAY['Exodus 30']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 31, ARRAY['Exodus 31']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 32, ARRAY['Exodus 32']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 33, ARRAY['Exodus 33']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 34, ARRAY['Exodus 34']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 35, ARRAY['Exodus 35']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 36, ARRAY['Exodus 36']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 37, ARRAY['Exodus 37']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 38, ARRAY['Exodus 38']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 39, ARRAY['Exodus 39']::text[]),
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 40, ARRAY['Exodus 40']::text[]),
-- Plan: Leviticus in 27 Days; source: https://openwordbible.org/plans/leviticus/; rights notice: https://openwordbible.org/plans/
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 1, ARRAY['Leviticus 1']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 2, ARRAY['Leviticus 2']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 3, ARRAY['Leviticus 3']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 4, ARRAY['Leviticus 4']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 5, ARRAY['Leviticus 5']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 6, ARRAY['Leviticus 6']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 7, ARRAY['Leviticus 7']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 8, ARRAY['Leviticus 8']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 9, ARRAY['Leviticus 9']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 10, ARRAY['Leviticus 10']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 11, ARRAY['Leviticus 11']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 12, ARRAY['Leviticus 12']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 13, ARRAY['Leviticus 13']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 14, ARRAY['Leviticus 14']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 15, ARRAY['Leviticus 15']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 16, ARRAY['Leviticus 16']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 17, ARRAY['Leviticus 17']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 18, ARRAY['Leviticus 18']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 19, ARRAY['Leviticus 19']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 20, ARRAY['Leviticus 20']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 21, ARRAY['Leviticus 21']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 22, ARRAY['Leviticus 22']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 23, ARRAY['Leviticus 23']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 24, ARRAY['Leviticus 24']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 25, ARRAY['Leviticus 25']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 26, ARRAY['Leviticus 26']::text[]),
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 27, ARRAY['Leviticus 27']::text[]),
-- Plan: Isaiah in 66 Days; source: https://openwordbible.org/plans/isaiah/; rights notice: https://openwordbible.org/plans/
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 1, ARRAY['Isaiah 1']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 2, ARRAY['Isaiah 2']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 3, ARRAY['Isaiah 3']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 4, ARRAY['Isaiah 4']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 5, ARRAY['Isaiah 5']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 6, ARRAY['Isaiah 6']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 7, ARRAY['Isaiah 7']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 8, ARRAY['Isaiah 8']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 9, ARRAY['Isaiah 9']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 10, ARRAY['Isaiah 10']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 11, ARRAY['Isaiah 11']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 12, ARRAY['Isaiah 12']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 13, ARRAY['Isaiah 13']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 14, ARRAY['Isaiah 14']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 15, ARRAY['Isaiah 15']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 16, ARRAY['Isaiah 16']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 17, ARRAY['Isaiah 17']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 18, ARRAY['Isaiah 18']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 19, ARRAY['Isaiah 19']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 20, ARRAY['Isaiah 20']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 21, ARRAY['Isaiah 21']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 22, ARRAY['Isaiah 22']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 23, ARRAY['Isaiah 23']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 24, ARRAY['Isaiah 24']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 25, ARRAY['Isaiah 25']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 26, ARRAY['Isaiah 26']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 27, ARRAY['Isaiah 27']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 28, ARRAY['Isaiah 28']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 29, ARRAY['Isaiah 29']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 30, ARRAY['Isaiah 30']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 31, ARRAY['Isaiah 31']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 32, ARRAY['Isaiah 32']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 33, ARRAY['Isaiah 33']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 34, ARRAY['Isaiah 34']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 35, ARRAY['Isaiah 35']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 36, ARRAY['Isaiah 36']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 37, ARRAY['Isaiah 37']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 38, ARRAY['Isaiah 38']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 39, ARRAY['Isaiah 39']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 40, ARRAY['Isaiah 40']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 41, ARRAY['Isaiah 41']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 42, ARRAY['Isaiah 42']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 43, ARRAY['Isaiah 43']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 44, ARRAY['Isaiah 44']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 45, ARRAY['Isaiah 45']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 46, ARRAY['Isaiah 46']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 47, ARRAY['Isaiah 47']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 48, ARRAY['Isaiah 48']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 49, ARRAY['Isaiah 49']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 50, ARRAY['Isaiah 50']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 51, ARRAY['Isaiah 51']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 52, ARRAY['Isaiah 52']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 53, ARRAY['Isaiah 53']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 54, ARRAY['Isaiah 54']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 55, ARRAY['Isaiah 55']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 56, ARRAY['Isaiah 56']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 57, ARRAY['Isaiah 57']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 58, ARRAY['Isaiah 58']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 59, ARRAY['Isaiah 59']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 60, ARRAY['Isaiah 60']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 61, ARRAY['Isaiah 61']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 62, ARRAY['Isaiah 62']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 63, ARRAY['Isaiah 63']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 64, ARRAY['Isaiah 64']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 65, ARRAY['Isaiah 65']::text[]),
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 66, ARRAY['Isaiah 66']::text[]),
-- Plan: Proverbs in 31 Days; source: https://openwordbible.org/plans/proverbs/; rights notice: https://openwordbible.org/plans/
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 1, ARRAY['Proverbs 1']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 2, ARRAY['Proverbs 2']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 3, ARRAY['Proverbs 3']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 4, ARRAY['Proverbs 4']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 5, ARRAY['Proverbs 5']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 6, ARRAY['Proverbs 6']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 7, ARRAY['Proverbs 7']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 8, ARRAY['Proverbs 8']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 9, ARRAY['Proverbs 9']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 10, ARRAY['Proverbs 10']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 11, ARRAY['Proverbs 11']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 12, ARRAY['Proverbs 12']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 13, ARRAY['Proverbs 13']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 14, ARRAY['Proverbs 14']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 15, ARRAY['Proverbs 15']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 16, ARRAY['Proverbs 16']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 17, ARRAY['Proverbs 17']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 18, ARRAY['Proverbs 18']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 19, ARRAY['Proverbs 19']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 20, ARRAY['Proverbs 20']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 21, ARRAY['Proverbs 21']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 22, ARRAY['Proverbs 22']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 23, ARRAY['Proverbs 23']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 24, ARRAY['Proverbs 24']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 25, ARRAY['Proverbs 25']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 26, ARRAY['Proverbs 26']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 27, ARRAY['Proverbs 27']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 28, ARRAY['Proverbs 28']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 29, ARRAY['Proverbs 29']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 30, ARRAY['Proverbs 30']::text[]),
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 31, ARRAY['Proverbs 31']::text[]),
-- Plan: Matthew in 28 Days; source: https://openwordbible.org/plans/matthew/; rights notice: https://openwordbible.org/plans/
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 1, ARRAY['Matthew 1']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 2, ARRAY['Matthew 2']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 3, ARRAY['Matthew 3']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 4, ARRAY['Matthew 4']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 5, ARRAY['Matthew 5']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 6, ARRAY['Matthew 6']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 7, ARRAY['Matthew 7']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 8, ARRAY['Matthew 8']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 9, ARRAY['Matthew 9']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 10, ARRAY['Matthew 10']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 11, ARRAY['Matthew 11']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 12, ARRAY['Matthew 12']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 13, ARRAY['Matthew 13']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 14, ARRAY['Matthew 14']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 15, ARRAY['Matthew 15']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 16, ARRAY['Matthew 16']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 17, ARRAY['Matthew 17']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 18, ARRAY['Matthew 18']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 19, ARRAY['Matthew 19']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 20, ARRAY['Matthew 20']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 21, ARRAY['Matthew 21']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 22, ARRAY['Matthew 22']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 23, ARRAY['Matthew 23']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 24, ARRAY['Matthew 24']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 25, ARRAY['Matthew 25']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 26, ARRAY['Matthew 26']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 27, ARRAY['Matthew 27']::text[]),
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 28, ARRAY['Matthew 28']::text[]),
-- Plan: Mark in 16 Days; source: https://openwordbible.org/plans/mark/; rights notice: https://openwordbible.org/plans/
  ('6c0f799a-f7cc-5bd4-97b0-6167b080ca06'::uuid, 1, ARRAY['Mark 1']::text[]),
  ('6c0f799a-f7cc-5bd4-97b0-6167b080ca06'::uuid, 2, ARRAY['Mark 2']::text[]),
  ('6c0f799a-f7cc-5bd4-97b0-6167b080ca06'::uuid, 3, ARRAY['Mark 3']::text[]),
  ('6c0f799a-f7cc-5bd4-97b0-6167b080ca06'::uuid, 4, ARRAY['Mark 4']::text[]),
  ('6c0f799a-f7cc-5bd4-97b0-6167b080ca06'::uuid, 5, ARRAY['Mark 5']::text[]),
  ('6c0f799a-f7cc-5bd4-97b0-6167b080ca06'::uuid, 6, ARRAY['Mark 6']::text[]),
  ('6c0f799a-f7cc-5bd4-97b0-6167b080ca06'::uuid, 7, ARRAY['Mark 7']::text[]),
  ('6c0f799a-f7cc-5bd4-97b0-6167b080ca06'::uuid, 8, ARRAY['Mark 8']::text[]),
  ('6c0f799a-f7cc-5bd4-97b0-6167b080ca06'::uuid, 9, ARRAY['Mark 9']::text[]),
  ('6c0f799a-f7cc-5bd4-97b0-6167b080ca06'::uuid, 10, ARRAY['Mark 10']::text[]),
  ('6c0f799a-f7cc-5bd4-97b0-6167b080ca06'::uuid, 11, ARRAY['Mark 11']::text[]),
  ('6c0f799a-f7cc-5bd4-97b0-6167b080ca06'::uuid, 12, ARRAY['Mark 12']::text[]),
  ('6c0f799a-f7cc-5bd4-97b0-6167b080ca06'::uuid, 13, ARRAY['Mark 13']::text[]),
  ('6c0f799a-f7cc-5bd4-97b0-6167b080ca06'::uuid, 14, ARRAY['Mark 14']::text[]),
  ('6c0f799a-f7cc-5bd4-97b0-6167b080ca06'::uuid, 15, ARRAY['Mark 15']::text[]),
  ('6c0f799a-f7cc-5bd4-97b0-6167b080ca06'::uuid, 16, ARRAY['Mark 16']::text[]),
-- Plan: Luke in 24 Days; source: https://openwordbible.org/plans/luke/; rights notice: https://openwordbible.org/plans/
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 1, ARRAY['Luke 1']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 2, ARRAY['Luke 2']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 3, ARRAY['Luke 3']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 4, ARRAY['Luke 4']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 5, ARRAY['Luke 5']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 6, ARRAY['Luke 6']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 7, ARRAY['Luke 7']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 8, ARRAY['Luke 8']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 9, ARRAY['Luke 9']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 10, ARRAY['Luke 10']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 11, ARRAY['Luke 11']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 12, ARRAY['Luke 12']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 13, ARRAY['Luke 13']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 14, ARRAY['Luke 14']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 15, ARRAY['Luke 15']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 16, ARRAY['Luke 16']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 17, ARRAY['Luke 17']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 18, ARRAY['Luke 18']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 19, ARRAY['Luke 19']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 20, ARRAY['Luke 20']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 21, ARRAY['Luke 21']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 22, ARRAY['Luke 22']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 23, ARRAY['Luke 23']::text[]),
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 24, ARRAY['Luke 24']::text[]),
-- Plan: John in 21 Days; source: https://openwordbible.org/plans/john/; rights notice: https://openwordbible.org/plans/
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 1, ARRAY['John 1']::text[]),
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 2, ARRAY['John 2']::text[]),
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 3, ARRAY['John 3']::text[]),
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 4, ARRAY['John 4']::text[]),
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 5, ARRAY['John 5']::text[]),
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 6, ARRAY['John 6']::text[]),
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 7, ARRAY['John 7']::text[]),
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 8, ARRAY['John 8']::text[]),
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 9, ARRAY['John 9']::text[]),
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 10, ARRAY['John 10']::text[]),
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 11, ARRAY['John 11']::text[]),
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 12, ARRAY['John 12']::text[]),
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 13, ARRAY['John 13']::text[]),
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 14, ARRAY['John 14']::text[]),
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 15, ARRAY['John 15']::text[]),
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 16, ARRAY['John 16']::text[]),
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 17, ARRAY['John 17']::text[]),
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 18, ARRAY['John 18']::text[]),
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 19, ARRAY['John 19']::text[]),
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 20, ARRAY['John 20']::text[]),
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 21, ARRAY['John 21']::text[]),
-- Plan: Acts in 28 Days; source: https://openwordbible.org/plans/acts/; rights notice: https://openwordbible.org/plans/
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 1, ARRAY['Acts 1']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 2, ARRAY['Acts 2']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 3, ARRAY['Acts 3']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 4, ARRAY['Acts 4']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 5, ARRAY['Acts 5']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 6, ARRAY['Acts 6']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 7, ARRAY['Acts 7']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 8, ARRAY['Acts 8']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 9, ARRAY['Acts 9']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 10, ARRAY['Acts 10']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 11, ARRAY['Acts 11']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 12, ARRAY['Acts 12']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 13, ARRAY['Acts 13']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 14, ARRAY['Acts 14']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 15, ARRAY['Acts 15']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 16, ARRAY['Acts 16']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 17, ARRAY['Acts 17']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 18, ARRAY['Acts 18']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 19, ARRAY['Acts 19']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 20, ARRAY['Acts 20']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 21, ARRAY['Acts 21']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 22, ARRAY['Acts 22']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 23, ARRAY['Acts 23']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 24, ARRAY['Acts 24']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 25, ARRAY['Acts 25']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 26, ARRAY['Acts 26']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 27, ARRAY['Acts 27']::text[]),
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 28, ARRAY['Acts 28']::text[]),
-- Plan: Romans in 16 Days; source: https://openwordbible.org/plans/romans/; rights notice: https://openwordbible.org/plans/
  ('92b132bb-6ee3-564e-a95d-8274ac10bfc6'::uuid, 1, ARRAY['Romans 1']::text[]),
  ('92b132bb-6ee3-564e-a95d-8274ac10bfc6'::uuid, 2, ARRAY['Romans 2']::text[]),
  ('92b132bb-6ee3-564e-a95d-8274ac10bfc6'::uuid, 3, ARRAY['Romans 3']::text[]),
  ('92b132bb-6ee3-564e-a95d-8274ac10bfc6'::uuid, 4, ARRAY['Romans 4']::text[]),
  ('92b132bb-6ee3-564e-a95d-8274ac10bfc6'::uuid, 5, ARRAY['Romans 5']::text[]),
  ('92b132bb-6ee3-564e-a95d-8274ac10bfc6'::uuid, 6, ARRAY['Romans 6']::text[]),
  ('92b132bb-6ee3-564e-a95d-8274ac10bfc6'::uuid, 7, ARRAY['Romans 7']::text[]),
  ('92b132bb-6ee3-564e-a95d-8274ac10bfc6'::uuid, 8, ARRAY['Romans 8']::text[]),
  ('92b132bb-6ee3-564e-a95d-8274ac10bfc6'::uuid, 9, ARRAY['Romans 9']::text[]),
  ('92b132bb-6ee3-564e-a95d-8274ac10bfc6'::uuid, 10, ARRAY['Romans 10']::text[]),
  ('92b132bb-6ee3-564e-a95d-8274ac10bfc6'::uuid, 11, ARRAY['Romans 11']::text[]),
  ('92b132bb-6ee3-564e-a95d-8274ac10bfc6'::uuid, 12, ARRAY['Romans 12']::text[]),
  ('92b132bb-6ee3-564e-a95d-8274ac10bfc6'::uuid, 13, ARRAY['Romans 13']::text[]),
  ('92b132bb-6ee3-564e-a95d-8274ac10bfc6'::uuid, 14, ARRAY['Romans 14']::text[]),
  ('92b132bb-6ee3-564e-a95d-8274ac10bfc6'::uuid, 15, ARRAY['Romans 15']::text[]),
  ('92b132bb-6ee3-564e-a95d-8274ac10bfc6'::uuid, 16, ARRAY['Romans 16']::text[]),
-- Plan: 1 Corinthians in 16 Days; source: https://openwordbible.org/plans/1-corinthians/; rights notice: https://openwordbible.org/plans/
  ('ab8ee088-6823-5ef9-b1c2-34b767280496'::uuid, 1, ARRAY['1 Corinthians 1']::text[]),
  ('ab8ee088-6823-5ef9-b1c2-34b767280496'::uuid, 2, ARRAY['1 Corinthians 2']::text[]),
  ('ab8ee088-6823-5ef9-b1c2-34b767280496'::uuid, 3, ARRAY['1 Corinthians 3']::text[]),
  ('ab8ee088-6823-5ef9-b1c2-34b767280496'::uuid, 4, ARRAY['1 Corinthians 4']::text[]),
  ('ab8ee088-6823-5ef9-b1c2-34b767280496'::uuid, 5, ARRAY['1 Corinthians 5']::text[]),
  ('ab8ee088-6823-5ef9-b1c2-34b767280496'::uuid, 6, ARRAY['1 Corinthians 6']::text[]),
  ('ab8ee088-6823-5ef9-b1c2-34b767280496'::uuid, 7, ARRAY['1 Corinthians 7']::text[]),
  ('ab8ee088-6823-5ef9-b1c2-34b767280496'::uuid, 8, ARRAY['1 Corinthians 8']::text[]),
  ('ab8ee088-6823-5ef9-b1c2-34b767280496'::uuid, 9, ARRAY['1 Corinthians 9']::text[]),
  ('ab8ee088-6823-5ef9-b1c2-34b767280496'::uuid, 10, ARRAY['1 Corinthians 10']::text[]),
  ('ab8ee088-6823-5ef9-b1c2-34b767280496'::uuid, 11, ARRAY['1 Corinthians 11']::text[]),
  ('ab8ee088-6823-5ef9-b1c2-34b767280496'::uuid, 12, ARRAY['1 Corinthians 12']::text[]),
  ('ab8ee088-6823-5ef9-b1c2-34b767280496'::uuid, 13, ARRAY['1 Corinthians 13']::text[]),
  ('ab8ee088-6823-5ef9-b1c2-34b767280496'::uuid, 14, ARRAY['1 Corinthians 14']::text[]),
  ('ab8ee088-6823-5ef9-b1c2-34b767280496'::uuid, 15, ARRAY['1 Corinthians 15']::text[]),
  ('ab8ee088-6823-5ef9-b1c2-34b767280496'::uuid, 16, ARRAY['1 Corinthians 16']::text[]),
-- Plan: Hebrews in 13 Days; source: https://openwordbible.org/plans/hebrews/; rights notice: https://openwordbible.org/plans/
  ('2cbb3b87-2511-5375-8ce1-a4294696f431'::uuid, 1, ARRAY['Hebrews 1']::text[]),
  ('2cbb3b87-2511-5375-8ce1-a4294696f431'::uuid, 2, ARRAY['Hebrews 2']::text[]),
  ('2cbb3b87-2511-5375-8ce1-a4294696f431'::uuid, 3, ARRAY['Hebrews 3']::text[]),
  ('2cbb3b87-2511-5375-8ce1-a4294696f431'::uuid, 4, ARRAY['Hebrews 4']::text[]),
  ('2cbb3b87-2511-5375-8ce1-a4294696f431'::uuid, 5, ARRAY['Hebrews 5']::text[]),
  ('2cbb3b87-2511-5375-8ce1-a4294696f431'::uuid, 6, ARRAY['Hebrews 6']::text[]),
  ('2cbb3b87-2511-5375-8ce1-a4294696f431'::uuid, 7, ARRAY['Hebrews 7']::text[]),
  ('2cbb3b87-2511-5375-8ce1-a4294696f431'::uuid, 8, ARRAY['Hebrews 8']::text[]),
  ('2cbb3b87-2511-5375-8ce1-a4294696f431'::uuid, 9, ARRAY['Hebrews 9']::text[]),
  ('2cbb3b87-2511-5375-8ce1-a4294696f431'::uuid, 10, ARRAY['Hebrews 10']::text[]),
  ('2cbb3b87-2511-5375-8ce1-a4294696f431'::uuid, 11, ARRAY['Hebrews 11']::text[]),
  ('2cbb3b87-2511-5375-8ce1-a4294696f431'::uuid, 12, ARRAY['Hebrews 12']::text[]),
  ('2cbb3b87-2511-5375-8ce1-a4294696f431'::uuid, 13, ARRAY['Hebrews 13']::text[]),
-- Plan: Revelation in 22 Days; source: https://openwordbible.org/plans/revelation/; rights notice: https://openwordbible.org/plans/
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 1, ARRAY['Revelation 1']::text[]),
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 2, ARRAY['Revelation 2']::text[]),
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 3, ARRAY['Revelation 3']::text[]),
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 4, ARRAY['Revelation 4']::text[]),
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 5, ARRAY['Revelation 5']::text[]),
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 6, ARRAY['Revelation 6']::text[]),
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 7, ARRAY['Revelation 7']::text[]),
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 8, ARRAY['Revelation 8']::text[]),
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 9, ARRAY['Revelation 9']::text[]),
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 10, ARRAY['Revelation 10']::text[]),
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 11, ARRAY['Revelation 11']::text[]),
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 12, ARRAY['Revelation 12']::text[]),
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 13, ARRAY['Revelation 13']::text[]),
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 14, ARRAY['Revelation 14']::text[]),
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 15, ARRAY['Revelation 15']::text[]),
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 16, ARRAY['Revelation 16']::text[]),
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 17, ARRAY['Revelation 17']::text[]),
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 18, ARRAY['Revelation 18']::text[]),
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 19, ARRAY['Revelation 19']::text[]),
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 20, ARRAY['Revelation 20']::text[]),
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 21, ARRAY['Revelation 21']::text[]),
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 22, ARRAY['Revelation 22']::text[]),
-- Plan: The Four Gospels in 89 Days; source: https://openwordbible.org/plans/gospels/; rights notice: https://openwordbible.org/plans/
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 1, ARRAY['Matthew 1']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 2, ARRAY['Matthew 2']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 3, ARRAY['Matthew 3']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 4, ARRAY['Matthew 4']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 5, ARRAY['Matthew 5']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 6, ARRAY['Matthew 6']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 7, ARRAY['Matthew 7']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 8, ARRAY['Matthew 8']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 9, ARRAY['Matthew 9']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 10, ARRAY['Matthew 10']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 11, ARRAY['Matthew 11']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 12, ARRAY['Matthew 12']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 13, ARRAY['Matthew 13']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 14, ARRAY['Matthew 14']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 15, ARRAY['Matthew 15']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 16, ARRAY['Matthew 16']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 17, ARRAY['Matthew 17']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 18, ARRAY['Matthew 18']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 19, ARRAY['Matthew 19']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 20, ARRAY['Matthew 20']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 21, ARRAY['Matthew 21']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 22, ARRAY['Matthew 22']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 23, ARRAY['Matthew 23']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 24, ARRAY['Matthew 24']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 25, ARRAY['Matthew 25']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 26, ARRAY['Matthew 26']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 27, ARRAY['Matthew 27']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 28, ARRAY['Matthew 28']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 29, ARRAY['Mark 1']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 30, ARRAY['Mark 2']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 31, ARRAY['Mark 3']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 32, ARRAY['Mark 4']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 33, ARRAY['Mark 5']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 34, ARRAY['Mark 6']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 35, ARRAY['Mark 7']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 36, ARRAY['Mark 8']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 37, ARRAY['Mark 9']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 38, ARRAY['Mark 10']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 39, ARRAY['Mark 11']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 40, ARRAY['Mark 12']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 41, ARRAY['Mark 13']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 42, ARRAY['Mark 14']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 43, ARRAY['Mark 15']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 44, ARRAY['Mark 16']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 45, ARRAY['Luke 1']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 46, ARRAY['Luke 2']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 47, ARRAY['Luke 3']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 48, ARRAY['Luke 4']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 49, ARRAY['Luke 5']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 50, ARRAY['Luke 6']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 51, ARRAY['Luke 7']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 52, ARRAY['Luke 8']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 53, ARRAY['Luke 9']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 54, ARRAY['Luke 10']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 55, ARRAY['Luke 11']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 56, ARRAY['Luke 12']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 57, ARRAY['Luke 13']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 58, ARRAY['Luke 14']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 59, ARRAY['Luke 15']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 60, ARRAY['Luke 16']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 61, ARRAY['Luke 17']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 62, ARRAY['Luke 18']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 63, ARRAY['Luke 19']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 64, ARRAY['Luke 20']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 65, ARRAY['Luke 21']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 66, ARRAY['Luke 22']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 67, ARRAY['Luke 23']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 68, ARRAY['Luke 24']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 69, ARRAY['John 1']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 70, ARRAY['John 2']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 71, ARRAY['John 3']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 72, ARRAY['John 4']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 73, ARRAY['John 5']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 74, ARRAY['John 6']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 75, ARRAY['John 7']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 76, ARRAY['John 8']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 77, ARRAY['John 9']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 78, ARRAY['John 10']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 79, ARRAY['John 11']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 80, ARRAY['John 12']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 81, ARRAY['John 13']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 82, ARRAY['John 14']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 83, ARRAY['John 15']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 84, ARRAY['John 16']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 85, ARRAY['John 17']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 86, ARRAY['John 18']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 87, ARRAY['John 19']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 88, ARRAY['John 20']::text[]),
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 89, ARRAY['John 21']::text[]),
-- Plan: James, Peter and Jude in 14 Days; source: https://openwordbible.org/plans/james-peter-jude/; rights notice: https://openwordbible.org/plans/
  ('7400ac43-f0ea-5b0a-bb2a-06633a41746e'::uuid, 1, ARRAY['James 1']::text[]),
  ('7400ac43-f0ea-5b0a-bb2a-06633a41746e'::uuid, 2, ARRAY['James 2']::text[]),
  ('7400ac43-f0ea-5b0a-bb2a-06633a41746e'::uuid, 3, ARRAY['James 3']::text[]),
  ('7400ac43-f0ea-5b0a-bb2a-06633a41746e'::uuid, 4, ARRAY['James 4']::text[]),
  ('7400ac43-f0ea-5b0a-bb2a-06633a41746e'::uuid, 5, ARRAY['James 5']::text[]),
  ('7400ac43-f0ea-5b0a-bb2a-06633a41746e'::uuid, 6, ARRAY['1 Peter 1']::text[]),
  ('7400ac43-f0ea-5b0a-bb2a-06633a41746e'::uuid, 7, ARRAY['1 Peter 2']::text[]),
  ('7400ac43-f0ea-5b0a-bb2a-06633a41746e'::uuid, 8, ARRAY['1 Peter 3']::text[]),
  ('7400ac43-f0ea-5b0a-bb2a-06633a41746e'::uuid, 9, ARRAY['1 Peter 4']::text[]),
  ('7400ac43-f0ea-5b0a-bb2a-06633a41746e'::uuid, 10, ARRAY['1 Peter 5']::text[]),
  ('7400ac43-f0ea-5b0a-bb2a-06633a41746e'::uuid, 11, ARRAY['2 Peter 1']::text[]),
  ('7400ac43-f0ea-5b0a-bb2a-06633a41746e'::uuid, 12, ARRAY['2 Peter 2']::text[]),
  ('7400ac43-f0ea-5b0a-bb2a-06633a41746e'::uuid, 13, ARRAY['2 Peter 3']::text[]),
  ('7400ac43-f0ea-5b0a-bb2a-06633a41746e'::uuid, 14, ARRAY['Jude 1']::text[]),
-- Plan: Galatians, Ephesians and Colossians in 16 Days; source: https://openwordbible.org/plans/galatians-ephesians-colossians/; rights notice: https://openwordbible.org/plans/
  ('46fc6363-6105-557d-be22-943ad6fb8d1c'::uuid, 1, ARRAY['Galatians 1']::text[]),
  ('46fc6363-6105-557d-be22-943ad6fb8d1c'::uuid, 2, ARRAY['Galatians 2']::text[]),
  ('46fc6363-6105-557d-be22-943ad6fb8d1c'::uuid, 3, ARRAY['Galatians 3']::text[]),
  ('46fc6363-6105-557d-be22-943ad6fb8d1c'::uuid, 4, ARRAY['Galatians 4']::text[]),
  ('46fc6363-6105-557d-be22-943ad6fb8d1c'::uuid, 5, ARRAY['Galatians 5']::text[]),
  ('46fc6363-6105-557d-be22-943ad6fb8d1c'::uuid, 6, ARRAY['Galatians 6']::text[]),
  ('46fc6363-6105-557d-be22-943ad6fb8d1c'::uuid, 7, ARRAY['Ephesians 1']::text[]),
  ('46fc6363-6105-557d-be22-943ad6fb8d1c'::uuid, 8, ARRAY['Ephesians 2']::text[]),
  ('46fc6363-6105-557d-be22-943ad6fb8d1c'::uuid, 9, ARRAY['Ephesians 3']::text[]),
  ('46fc6363-6105-557d-be22-943ad6fb8d1c'::uuid, 10, ARRAY['Ephesians 4']::text[]),
  ('46fc6363-6105-557d-be22-943ad6fb8d1c'::uuid, 11, ARRAY['Ephesians 5']::text[]),
  ('46fc6363-6105-557d-be22-943ad6fb8d1c'::uuid, 12, ARRAY['Ephesians 6']::text[]),
  ('46fc6363-6105-557d-be22-943ad6fb8d1c'::uuid, 13, ARRAY['Colossians 1']::text[]),
  ('46fc6363-6105-557d-be22-943ad6fb8d1c'::uuid, 14, ARRAY['Colossians 2']::text[]),
  ('46fc6363-6105-557d-be22-943ad6fb8d1c'::uuid, 15, ARRAY['Colossians 3']::text[]),
  ('46fc6363-6105-557d-be22-943ad6fb8d1c'::uuid, 16, ARRAY['Colossians 4']::text[]);

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM import_reading_plan_catalog s JOIN public.devotional_plans p
      ON lower(btrim(p.title)) = lower(btrim(s.title)) AND p.id <> s.id
  ) THEN
    RAISE EXCEPTION 'Import title collision with an existing different plan UUID; review duplicates before running';
  END IF;
  IF EXISTS (
    SELECT 1 FROM import_reading_plan_catalog p LEFT JOIN (
      SELECT plan_id, count(*) AS n, min(day_number) AS lo, max(day_number) AS hi
      FROM import_reading_assignments GROUP BY plan_id
    ) a ON p.id = a.plan_id
    WHERE a.n IS DISTINCT FROM p.expected_days OR a.lo <> 1 OR a.hi <> p.expected_days
  ) THEN RAISE EXCEPTION 'Invalid source plan day numbering'; END IF;
  IF EXISTS (SELECT 1 FROM import_reading_assignments WHERE cardinality(reference) = 0
     OR array_position(reference, '') IS NOT NULL OR array_position(reference, NULL) IS NOT NULL)
  THEN RAISE EXCEPTION 'Empty Scripture reference'; END IF;
END $$;

INSERT INTO public.devotional_plans (id,title,description,cover_image,completions,tags,status,total_days,author_id,visibility)
SELECT id,title,description,NULL,0,ARRAY['reading']::text[],'draft',expected_days,NULL,'public'
FROM import_reading_plan_catalog
ON CONFLICT (id) DO UPDATE SET
  title=EXCLUDED.title, description=EXCLUDED.description,
  tags=(SELECT ARRAY(SELECT DISTINCT t FROM unnest(coalesce(public.devotional_plans.tags,'{}'::text[]) || ARRAY['reading']::text[]) AS t ORDER BY t)),
  total_days=EXCLUDED.total_days;

-- Conflict resolution retains existing day UUIDs and unrelated progress links.
INSERT INTO public.devotional_days (id,plan_id,day_number,content,title)
SELECT gen_random_uuid(),a.plan_id,a.day_number,'',NULL
FROM import_reading_assignments a
ON CONFLICT (plan_id,day_number) DO UPDATE SET content='',title=NULL;

-- One reference row per imported day. Preserve existing reference-row IDs.
-- If a day already has reference rows, require them to match rather than overwriting user data.
DO $$
BEGIN
  IF EXISTS (
     SELECT 1 FROM import_reading_assignments a
     JOIN public.devotional_days d ON d.plan_id=a.plan_id AND d.day_number=a.day_number
     JOIN public.scripture_references r ON r.day_id=d.id
     GROUP BY a.plan_id,a.day_number,a.reference
     HAVING count(*) <> 1 OR bool_or(r.reference IS DISTINCT FROM a.reference)
  ) THEN RAISE EXCEPTION 'Existing Scripture assignment differs for an imported day'; END IF;
END $$;

INSERT INTO public.scripture_references (id,user_id,day_id,reference)
SELECT gen_random_uuid(),NULL,d.id,a.reference
FROM import_reading_assignments a
JOIN public.devotional_days d ON d.plan_id=a.plan_id AND d.day_number=a.day_number
WHERE NOT EXISTS (SELECT 1 FROM public.scripture_references r WHERE r.day_id=d.id);

-- Validate all imported plans before publication.
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM import_reading_plan_catalog p
    LEFT JOIN public.devotional_days d ON d.plan_id=p.id
    GROUP BY p.id,p.expected_days
    HAVING count(d.id) <> p.expected_days
       OR min(d.day_number) <> 1 OR max(d.day_number) <> p.expected_days
       OR bool_or(d.content <> '')
  ) THEN RAISE EXCEPTION 'Day count or content mismatch'; END IF;
  IF EXISTS (
    SELECT 1 FROM import_reading_assignments a
    JOIN public.devotional_days d ON d.plan_id=a.plan_id AND d.day_number=a.day_number
    LEFT JOIN public.scripture_references r ON r.day_id=d.id
    GROUP BY a.plan_id,a.day_number
    HAVING count(r.id) <> 1 OR NOT bool_and(cardinality(r.reference)>0)
  ) THEN RAISE EXCEPTION 'Reference count invalid'; END IF;
END $$;
UPDATE public.devotional_plans p SET status='published'
FROM import_reading_plan_catalog s WHERE p.id=s.id AND p.status IS DISTINCT FROM 'published';

-- Source batch: 20261112153000_import_additional_open_word_reading_plans.sql
-- Reading-plan data migration — additional verified Open Word Bible schedules.
-- Source listings: https://openwordbible.org/plans/
-- Source-specific daily schedules and URLs are documented separately below.
-- Reuse assessment: source site carries a CC0 footer; however, formal terms
-- https://openwordbible.org/about/terms-of-use/ explicitly dedicate its
-- translation/notes/reasoning/alignments to CC0, NOT schedules separately.
-- These imports use only bare public-domain biblical passage identifiers and
-- factual daily assignment sequences, with original descriptions; no protected
-- prose or Bible text is reproduced. Confirm publisher's schedule-specific rights
-- if your release process requires affirmative permission for each schedule.
-- Existing earlier plan imports are not modified. Source dates: 2026-11-12.
-- Complete-book coverage: NONE of these three: Psalms 1-50 and 51-100 are
-- separate PARTIAL Psalms plans; Genesis 1-11 is a PARTIAL Genesis plan.
CREATE TEMP TABLE _additional_reading_plans (
 id uuid PRIMARY KEY, title text NOT NULL, description text NOT NULL,
 source_url text NOT NULL, expected_days integer NOT NULL
) ON COMMIT DROP;
INSERT INTO _additional_reading_plans(id,title,description,source_url,expected_days) VALUES
  ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,'Psalms 1–50: A Psalm a Day','Read Psalms 1 through 50, one complete psalm each day, following the published 50-day schedule.','https://openwordbible.org/plans/psalms-1-50/',50),
  ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,'Psalms 51–100: A Psalm a Day','Read Psalms 51 through 100, one complete psalm each day, following the published 50-day schedule.','https://openwordbible.org/plans/psalms-51-100/',50),
  ('4ec02fef-458c-5148-a88d-ed594f8e2526'::uuid,'Genesis 1–11 in 11 Days','Read the opening eleven chapters of Genesis, one chapter per day. This is a selected section, not the complete book.','https://openwordbible.org/plans/genesis-1-11/',11);

CREATE TEMP TABLE _additional_reading_days (
 plan_id uuid NOT NULL, day_number integer NOT NULL, reference text[] NOT NULL,
 PRIMARY KEY(plan_id, day_number)
) ON COMMIT DROP;
INSERT INTO _additional_reading_days(plan_id,day_number,reference) VALUES
-- Published source: https://openwordbible.org/plans/psalms-1-50/; Day 1 = Psalm 1, Day 50 = Psalm 50.
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,1,ARRAY['Psalm 1']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,2,ARRAY['Psalm 2']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,3,ARRAY['Psalm 3']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,4,ARRAY['Psalm 4']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,5,ARRAY['Psalm 5']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,6,ARRAY['Psalm 6']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,7,ARRAY['Psalm 7']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,8,ARRAY['Psalm 8']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,9,ARRAY['Psalm 9']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,10,ARRAY['Psalm 10']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,11,ARRAY['Psalm 11']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,12,ARRAY['Psalm 12']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,13,ARRAY['Psalm 13']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,14,ARRAY['Psalm 14']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,15,ARRAY['Psalm 15']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,16,ARRAY['Psalm 16']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,17,ARRAY['Psalm 17']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,18,ARRAY['Psalm 18']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,19,ARRAY['Psalm 19']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,20,ARRAY['Psalm 20']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,21,ARRAY['Psalm 21']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,22,ARRAY['Psalm 22']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,23,ARRAY['Psalm 23']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,24,ARRAY['Psalm 24']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,25,ARRAY['Psalm 25']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,26,ARRAY['Psalm 26']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,27,ARRAY['Psalm 27']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,28,ARRAY['Psalm 28']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,29,ARRAY['Psalm 29']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,30,ARRAY['Psalm 30']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,31,ARRAY['Psalm 31']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,32,ARRAY['Psalm 32']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,33,ARRAY['Psalm 33']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,34,ARRAY['Psalm 34']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,35,ARRAY['Psalm 35']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,36,ARRAY['Psalm 36']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,37,ARRAY['Psalm 37']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,38,ARRAY['Psalm 38']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,39,ARRAY['Psalm 39']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,40,ARRAY['Psalm 40']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,41,ARRAY['Psalm 41']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,42,ARRAY['Psalm 42']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,43,ARRAY['Psalm 43']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,44,ARRAY['Psalm 44']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,45,ARRAY['Psalm 45']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,46,ARRAY['Psalm 46']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,47,ARRAY['Psalm 47']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,48,ARRAY['Psalm 48']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,49,ARRAY['Psalm 49']::text[]),
 ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,50,ARRAY['Psalm 50']::text[]),
-- Published source: https://openwordbible.org/plans/psalms-51-100/; Day 1 = Psalm 51, Day 50 = Psalm 100.
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,1,ARRAY['Psalm 51']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,2,ARRAY['Psalm 52']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,3,ARRAY['Psalm 53']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,4,ARRAY['Psalm 54']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,5,ARRAY['Psalm 55']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,6,ARRAY['Psalm 56']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,7,ARRAY['Psalm 57']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,8,ARRAY['Psalm 58']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,9,ARRAY['Psalm 59']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,10,ARRAY['Psalm 60']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,11,ARRAY['Psalm 61']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,12,ARRAY['Psalm 62']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,13,ARRAY['Psalm 63']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,14,ARRAY['Psalm 64']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,15,ARRAY['Psalm 65']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,16,ARRAY['Psalm 66']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,17,ARRAY['Psalm 67']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,18,ARRAY['Psalm 68']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,19,ARRAY['Psalm 69']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,20,ARRAY['Psalm 70']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,21,ARRAY['Psalm 71']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,22,ARRAY['Psalm 72']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,23,ARRAY['Psalm 73']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,24,ARRAY['Psalm 74']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,25,ARRAY['Psalm 75']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,26,ARRAY['Psalm 76']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,27,ARRAY['Psalm 77']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,28,ARRAY['Psalm 78']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,29,ARRAY['Psalm 79']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,30,ARRAY['Psalm 80']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,31,ARRAY['Psalm 81']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,32,ARRAY['Psalm 82']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,33,ARRAY['Psalm 83']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,34,ARRAY['Psalm 84']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,35,ARRAY['Psalm 85']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,36,ARRAY['Psalm 86']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,37,ARRAY['Psalm 87']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,38,ARRAY['Psalm 88']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,39,ARRAY['Psalm 89']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,40,ARRAY['Psalm 90']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,41,ARRAY['Psalm 91']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,42,ARRAY['Psalm 92']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,43,ARRAY['Psalm 93']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,44,ARRAY['Psalm 94']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,45,ARRAY['Psalm 95']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,46,ARRAY['Psalm 96']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,47,ARRAY['Psalm 97']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,48,ARRAY['Psalm 98']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,49,ARRAY['Psalm 99']::text[]),
 ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,50,ARRAY['Psalm 100']::text[]),
-- Published source: https://openwordbible.org/plans/genesis-1-11/; Day 1 = Genesis 1, Day 11 = Genesis 11.
 ('4ec02fef-458c-5148-a88d-ed594f8e2526'::uuid,1,ARRAY['Genesis 1']::text[]),
 ('4ec02fef-458c-5148-a88d-ed594f8e2526'::uuid,2,ARRAY['Genesis 2']::text[]),
 ('4ec02fef-458c-5148-a88d-ed594f8e2526'::uuid,3,ARRAY['Genesis 3']::text[]),
 ('4ec02fef-458c-5148-a88d-ed594f8e2526'::uuid,4,ARRAY['Genesis 4']::text[]),
 ('4ec02fef-458c-5148-a88d-ed594f8e2526'::uuid,5,ARRAY['Genesis 5']::text[]),
 ('4ec02fef-458c-5148-a88d-ed594f8e2526'::uuid,6,ARRAY['Genesis 6']::text[]),
 ('4ec02fef-458c-5148-a88d-ed594f8e2526'::uuid,7,ARRAY['Genesis 7']::text[]),
 ('4ec02fef-458c-5148-a88d-ed594f8e2526'::uuid,8,ARRAY['Genesis 8']::text[]),
 ('4ec02fef-458c-5148-a88d-ed594f8e2526'::uuid,9,ARRAY['Genesis 9']::text[]),
 ('4ec02fef-458c-5148-a88d-ed594f8e2526'::uuid,10,ARRAY['Genesis 10']::text[]),
 ('4ec02fef-458c-5148-a88d-ed594f8e2526'::uuid,11,ARRAY['Genesis 11']::text[]);

-- Validate the incoming source schedule before any persistent write.
DO $validation$
BEGIN
 IF (SELECT count(*) FROM _additional_reading_plans) <> 3
    OR (SELECT count(*) FROM _additional_reading_days) <> 111 THEN
   RAISE EXCEPTION 'Unexpected source plan/day count';
 END IF;
 IF EXISTS (
   SELECT 1 FROM _additional_reading_plans p LEFT JOIN (
    SELECT plan_id,count(*) AS n,min(day_number) AS first_day,max(day_number) AS last_day
    FROM _additional_reading_days GROUP BY plan_id
   ) d ON p.id=d.plan_id
   WHERE d.n IS DISTINCT FROM p.expected_days OR d.first_day <> 1 OR d.last_day <> p.expected_days
 ) THEN RAISE EXCEPTION 'Source day numbering invalid'; END IF;
 IF EXISTS (
   SELECT 1 FROM _additional_reading_days
   WHERE cardinality(reference) <> 1 OR reference[1] IS NULL OR btrim(reference[1]) = ''
     OR reference[1] !~ '^(Psalm|Genesis) [1-9][0-9]*$'
 ) THEN RAISE EXCEPTION 'Unexpected Scripture reference format'; END IF;
 IF EXISTS (
   SELECT 1 FROM _additional_reading_plans s JOIN public.devotional_plans p
   ON lower(btrim(p.title)) = lower(btrim(s.title)) AND p.id <> s.id
 ) THEN RAISE EXCEPTION 'Another plan already uses a new import title'; END IF;
 IF EXISTS (
   SELECT 1 FROM _additional_reading_plans s JOIN public.devotional_plans p ON p.id=s.id
   WHERE p.title IS DISTINCT FROM s.title
     OR p.total_days IS DISTINCT FROM s.expected_days
 ) THEN RAISE EXCEPTION 'An imported UUID already belongs to another plan definition'; END IF;
END $validation$;

-- Do not overwrite an existing plan or its cover, completions, author or visibility.
INSERT INTO public.devotional_plans
 (id,title,description,cover_image,completions,tags,status,total_days,author_id,visibility)
SELECT id,title,description,NULL,0,ARRAY['reading']::text[],'draft',expected_days,NULL,'public'
FROM _additional_reading_plans
ON CONFLICT(id) DO NOTHING;

-- Preserve existing day IDs and contents on reapplication. Any inconsistent
-- existing state is rejected below rather than silently rewritten.
INSERT INTO public.devotional_days(id,plan_id,day_number,content,title)
SELECT gen_random_uuid(),plan_id,day_number,'',NULL
FROM _additional_reading_days
ON CONFLICT(plan_id,day_number) DO NOTHING;

DO $existing_days$
BEGIN
 IF EXISTS (
   SELECT 1 FROM _additional_reading_days a
   JOIN public.devotional_days d ON d.plan_id=a.plan_id AND d.day_number=a.day_number
   LEFT JOIN public.scripture_references r ON r.day_id=d.id
   GROUP BY a.plan_id,a.day_number,a.reference,d.id,d.content
   HAVING d.content IS DISTINCT FROM ''
      OR count(r.id)>1
      OR (count(r.id)=1 AND bool_or(r.reference IS DISTINCT FROM a.reference))
 ) THEN RAISE EXCEPTION 'Existing day content or reference assignments differ'; END IF;
END $existing_days$;

INSERT INTO public.scripture_references(id,user_id,day_id,reference)
SELECT gen_random_uuid(),NULL,d.id,a.reference
FROM _additional_reading_days a JOIN public.devotional_days d
ON d.plan_id=a.plan_id AND d.day_number=a.day_number
WHERE NOT EXISTS (SELECT 1 FROM public.scripture_references r WHERE r.day_id=d.id);

DO $integrity$
BEGIN
 IF EXISTS (
 SELECT 1 FROM _additional_reading_plans p
 JOIN public.devotional_plans v ON v.id=p.id
 LEFT JOIN public.devotional_days d ON d.plan_id=p.id
 GROUP BY p.id,p.expected_days,v.tags,v.status
 HAVING count(d.id) <> p.expected_days OR min(d.day_number) <> 1
    OR max(d.day_number) <> p.expected_days
    OR bool_or(d.content IS DISTINCT FROM '')
    OR NOT ('reading'=ANY(coalesce(v.tags,'{}'::text[])))
 ) THEN RAISE EXCEPTION 'Imported plan metadata/days mismatch'; END IF;
 IF EXISTS (
 SELECT 1 FROM _additional_reading_days a
 JOIN public.devotional_days d ON d.plan_id=a.plan_id AND d.day_number=a.day_number
 LEFT JOIN public.scripture_references r ON r.day_id=d.id
 GROUP BY a.plan_id,a.day_number,a.reference
 HAVING count(r.id) <> 1 OR NOT bool_and(r.reference IS NOT DISTINCT FROM a.reference)
 ) THEN RAISE EXCEPTION 'Imported reference mismatch'; END IF;
END $integrity$;

-- The existing deferred publication constraint verifies every published day has Scripture.
UPDATE public.devotional_plans p SET status='published'
FROM _additional_reading_plans s
WHERE p.id=s.id AND p.status IS DISTINCT FROM 'published';

-- Source batch: 20261112170000_import_additional_public_domain_chapter_plans.sql
-- Additional Bible reading schedules (catalog-only data migration).
-- Source catalog: https://abrahamiclibrary.com/plans.php
-- Rights statement: https://abrahamiclibrary.com/about.php
-- The publisher states its texts and editions are public domain, free to copy and sell,
-- but its website software is not. Reading-plan schedule licensing is not separately
-- itemized; confirm scope of the edition statement before commercial deployment.
-- SOURCE VERIFICATION LIMITATION (2026-11-12): The four individual plan pages
-- returned HTTP 502 during verification. The catalog explicitly gives the included
-- book order, number of days, and a ONE-CHAPTER-PER-DAY rule. Thus every day below
-- is mechanically expanded from those published rules; daily HTML was NOT independently
-- fetched. Do not describe this migration as verbatim day-list transcription.
-- These are complete-book or complete-collection plans with no passage text or prose.
-- Existing plans/days are not deleted; existing day IDs, cover images and counts remain.
-- Requires devotional_plans, devotional_days, scripture_references per supplied schema.
CREATE TEMP TABLE _reading_more_catalog (
  id uuid PRIMARY KEY, title text NOT NULL, description text NOT NULL,
  source_url text NOT NULL, expected_days integer NOT NULL
) ON COMMIT DROP;
INSERT INTO _reading_more_catalog(id,title,description,source_url,expected_days) VALUES
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'The Torah in 187 Days','Read Genesis, Exodus, Leviticus, Numbers and Deuteronomy in canonical order, one full chapter each day.','https://abrahamiclibrary.com/plan.php?id=torah',187),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'The Twelve Minor Prophets in 67 Days','Read all twelve Minor Prophets, Hosea through Malachi, one full chapter each day.','https://abrahamiclibrary.com/plan.php?id=twelve',67),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Ezra and Nehemiah in 23 Days','Read Ezra and Nehemiah in canonical order, one full chapter each day.','https://abrahamiclibrary.com/plan.php?id=ezra-nehemiah',23),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'Hebrews and General Epistles in 34 Days','Read Hebrews, James, both letters of Peter, all three letters of John and Jude, one chapter per day.','https://abrahamiclibrary.com/plan.php?id=catholic-epistles',34);
CREATE TEMP TABLE _reading_more_assignments (
  plan_id uuid NOT NULL, day_number integer NOT NULL, reference text[] NOT NULL,
  PRIMARY KEY(plan_id,day_number)
) ON COMMIT DROP;
INSERT INTO _reading_more_assignments(plan_id,day_number,reference) VALUES
-- The Torah in 187 Days; source: https://abrahamiclibrary.com/plan.php?id=torah; catalog: https://abrahamiclibrary.com/plans.php
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,1,ARRAY['Genesis 1']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,2,ARRAY['Genesis 2']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,3,ARRAY['Genesis 3']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,4,ARRAY['Genesis 4']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,5,ARRAY['Genesis 5']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,6,ARRAY['Genesis 6']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,7,ARRAY['Genesis 7']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,8,ARRAY['Genesis 8']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,9,ARRAY['Genesis 9']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,10,ARRAY['Genesis 10']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,11,ARRAY['Genesis 11']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,12,ARRAY['Genesis 12']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,13,ARRAY['Genesis 13']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,14,ARRAY['Genesis 14']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,15,ARRAY['Genesis 15']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,16,ARRAY['Genesis 16']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,17,ARRAY['Genesis 17']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,18,ARRAY['Genesis 18']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,19,ARRAY['Genesis 19']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,20,ARRAY['Genesis 20']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,21,ARRAY['Genesis 21']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,22,ARRAY['Genesis 22']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,23,ARRAY['Genesis 23']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,24,ARRAY['Genesis 24']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,25,ARRAY['Genesis 25']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,26,ARRAY['Genesis 26']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,27,ARRAY['Genesis 27']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,28,ARRAY['Genesis 28']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,29,ARRAY['Genesis 29']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,30,ARRAY['Genesis 30']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,31,ARRAY['Genesis 31']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,32,ARRAY['Genesis 32']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,33,ARRAY['Genesis 33']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,34,ARRAY['Genesis 34']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,35,ARRAY['Genesis 35']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,36,ARRAY['Genesis 36']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,37,ARRAY['Genesis 37']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,38,ARRAY['Genesis 38']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,39,ARRAY['Genesis 39']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,40,ARRAY['Genesis 40']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,41,ARRAY['Genesis 41']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,42,ARRAY['Genesis 42']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,43,ARRAY['Genesis 43']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,44,ARRAY['Genesis 44']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,45,ARRAY['Genesis 45']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,46,ARRAY['Genesis 46']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,47,ARRAY['Genesis 47']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,48,ARRAY['Genesis 48']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,49,ARRAY['Genesis 49']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,50,ARRAY['Genesis 50']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,51,ARRAY['Exodus 1']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,52,ARRAY['Exodus 2']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,53,ARRAY['Exodus 3']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,54,ARRAY['Exodus 4']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,55,ARRAY['Exodus 5']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,56,ARRAY['Exodus 6']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,57,ARRAY['Exodus 7']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,58,ARRAY['Exodus 8']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,59,ARRAY['Exodus 9']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,60,ARRAY['Exodus 10']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,61,ARRAY['Exodus 11']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,62,ARRAY['Exodus 12']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,63,ARRAY['Exodus 13']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,64,ARRAY['Exodus 14']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,65,ARRAY['Exodus 15']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,66,ARRAY['Exodus 16']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,67,ARRAY['Exodus 17']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,68,ARRAY['Exodus 18']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,69,ARRAY['Exodus 19']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,70,ARRAY['Exodus 20']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,71,ARRAY['Exodus 21']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,72,ARRAY['Exodus 22']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,73,ARRAY['Exodus 23']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,74,ARRAY['Exodus 24']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,75,ARRAY['Exodus 25']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,76,ARRAY['Exodus 26']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,77,ARRAY['Exodus 27']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,78,ARRAY['Exodus 28']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,79,ARRAY['Exodus 29']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,80,ARRAY['Exodus 30']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,81,ARRAY['Exodus 31']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,82,ARRAY['Exodus 32']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,83,ARRAY['Exodus 33']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,84,ARRAY['Exodus 34']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,85,ARRAY['Exodus 35']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,86,ARRAY['Exodus 36']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,87,ARRAY['Exodus 37']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,88,ARRAY['Exodus 38']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,89,ARRAY['Exodus 39']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,90,ARRAY['Exodus 40']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,91,ARRAY['Leviticus 1']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,92,ARRAY['Leviticus 2']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,93,ARRAY['Leviticus 3']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,94,ARRAY['Leviticus 4']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,95,ARRAY['Leviticus 5']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,96,ARRAY['Leviticus 6']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,97,ARRAY['Leviticus 7']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,98,ARRAY['Leviticus 8']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,99,ARRAY['Leviticus 9']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,100,ARRAY['Leviticus 10']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,101,ARRAY['Leviticus 11']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,102,ARRAY['Leviticus 12']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,103,ARRAY['Leviticus 13']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,104,ARRAY['Leviticus 14']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,105,ARRAY['Leviticus 15']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,106,ARRAY['Leviticus 16']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,107,ARRAY['Leviticus 17']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,108,ARRAY['Leviticus 18']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,109,ARRAY['Leviticus 19']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,110,ARRAY['Leviticus 20']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,111,ARRAY['Leviticus 21']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,112,ARRAY['Leviticus 22']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,113,ARRAY['Leviticus 23']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,114,ARRAY['Leviticus 24']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,115,ARRAY['Leviticus 25']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,116,ARRAY['Leviticus 26']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,117,ARRAY['Leviticus 27']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,118,ARRAY['Numbers 1']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,119,ARRAY['Numbers 2']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,120,ARRAY['Numbers 3']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,121,ARRAY['Numbers 4']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,122,ARRAY['Numbers 5']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,123,ARRAY['Numbers 6']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,124,ARRAY['Numbers 7']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,125,ARRAY['Numbers 8']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,126,ARRAY['Numbers 9']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,127,ARRAY['Numbers 10']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,128,ARRAY['Numbers 11']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,129,ARRAY['Numbers 12']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,130,ARRAY['Numbers 13']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,131,ARRAY['Numbers 14']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,132,ARRAY['Numbers 15']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,133,ARRAY['Numbers 16']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,134,ARRAY['Numbers 17']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,135,ARRAY['Numbers 18']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,136,ARRAY['Numbers 19']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,137,ARRAY['Numbers 20']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,138,ARRAY['Numbers 21']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,139,ARRAY['Numbers 22']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,140,ARRAY['Numbers 23']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,141,ARRAY['Numbers 24']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,142,ARRAY['Numbers 25']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,143,ARRAY['Numbers 26']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,144,ARRAY['Numbers 27']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,145,ARRAY['Numbers 28']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,146,ARRAY['Numbers 29']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,147,ARRAY['Numbers 30']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,148,ARRAY['Numbers 31']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,149,ARRAY['Numbers 32']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,150,ARRAY['Numbers 33']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,151,ARRAY['Numbers 34']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,152,ARRAY['Numbers 35']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,153,ARRAY['Numbers 36']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,154,ARRAY['Deuteronomy 1']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,155,ARRAY['Deuteronomy 2']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,156,ARRAY['Deuteronomy 3']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,157,ARRAY['Deuteronomy 4']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,158,ARRAY['Deuteronomy 5']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,159,ARRAY['Deuteronomy 6']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,160,ARRAY['Deuteronomy 7']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,161,ARRAY['Deuteronomy 8']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,162,ARRAY['Deuteronomy 9']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,163,ARRAY['Deuteronomy 10']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,164,ARRAY['Deuteronomy 11']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,165,ARRAY['Deuteronomy 12']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,166,ARRAY['Deuteronomy 13']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,167,ARRAY['Deuteronomy 14']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,168,ARRAY['Deuteronomy 15']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,169,ARRAY['Deuteronomy 16']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,170,ARRAY['Deuteronomy 17']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,171,ARRAY['Deuteronomy 18']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,172,ARRAY['Deuteronomy 19']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,173,ARRAY['Deuteronomy 20']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,174,ARRAY['Deuteronomy 21']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,175,ARRAY['Deuteronomy 22']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,176,ARRAY['Deuteronomy 23']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,177,ARRAY['Deuteronomy 24']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,178,ARRAY['Deuteronomy 25']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,179,ARRAY['Deuteronomy 26']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,180,ARRAY['Deuteronomy 27']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,181,ARRAY['Deuteronomy 28']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,182,ARRAY['Deuteronomy 29']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,183,ARRAY['Deuteronomy 30']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,184,ARRAY['Deuteronomy 31']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,185,ARRAY['Deuteronomy 32']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,186,ARRAY['Deuteronomy 33']::text[]),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,187,ARRAY['Deuteronomy 34']::text[]),
-- The Twelve Minor Prophets in 67 Days; source: https://abrahamiclibrary.com/plan.php?id=twelve; catalog: https://abrahamiclibrary.com/plans.php
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,1,ARRAY['Hosea 1']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,2,ARRAY['Hosea 2']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,3,ARRAY['Hosea 3']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,4,ARRAY['Hosea 4']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,5,ARRAY['Hosea 5']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,6,ARRAY['Hosea 6']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,7,ARRAY['Hosea 7']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,8,ARRAY['Hosea 8']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,9,ARRAY['Hosea 9']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,10,ARRAY['Hosea 10']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,11,ARRAY['Hosea 11']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,12,ARRAY['Hosea 12']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,13,ARRAY['Hosea 13']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,14,ARRAY['Hosea 14']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,15,ARRAY['Joel 1']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,16,ARRAY['Joel 2']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,17,ARRAY['Joel 3']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,18,ARRAY['Amos 1']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,19,ARRAY['Amos 2']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,20,ARRAY['Amos 3']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,21,ARRAY['Amos 4']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,22,ARRAY['Amos 5']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,23,ARRAY['Amos 6']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,24,ARRAY['Amos 7']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,25,ARRAY['Amos 8']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,26,ARRAY['Amos 9']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,27,ARRAY['Obadiah 1']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,28,ARRAY['Jonah 1']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,29,ARRAY['Jonah 2']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,30,ARRAY['Jonah 3']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,31,ARRAY['Jonah 4']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,32,ARRAY['Micah 1']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,33,ARRAY['Micah 2']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,34,ARRAY['Micah 3']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,35,ARRAY['Micah 4']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,36,ARRAY['Micah 5']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,37,ARRAY['Micah 6']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,38,ARRAY['Micah 7']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,39,ARRAY['Nahum 1']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,40,ARRAY['Nahum 2']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,41,ARRAY['Nahum 3']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,42,ARRAY['Habakkuk 1']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,43,ARRAY['Habakkuk 2']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,44,ARRAY['Habakkuk 3']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,45,ARRAY['Zephaniah 1']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,46,ARRAY['Zephaniah 2']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,47,ARRAY['Zephaniah 3']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,48,ARRAY['Haggai 1']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,49,ARRAY['Haggai 2']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,50,ARRAY['Zechariah 1']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,51,ARRAY['Zechariah 2']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,52,ARRAY['Zechariah 3']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,53,ARRAY['Zechariah 4']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,54,ARRAY['Zechariah 5']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,55,ARRAY['Zechariah 6']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,56,ARRAY['Zechariah 7']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,57,ARRAY['Zechariah 8']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,58,ARRAY['Zechariah 9']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,59,ARRAY['Zechariah 10']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,60,ARRAY['Zechariah 11']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,61,ARRAY['Zechariah 12']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,62,ARRAY['Zechariah 13']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,63,ARRAY['Zechariah 14']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,64,ARRAY['Malachi 1']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,65,ARRAY['Malachi 2']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,66,ARRAY['Malachi 3']::text[]),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,67,ARRAY['Malachi 4']::text[]),
-- Ezra and Nehemiah in 23 Days; source: https://abrahamiclibrary.com/plan.php?id=ezra-nehemiah; catalog: https://abrahamiclibrary.com/plans.php
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,1,ARRAY['Ezra 1']::text[]),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,2,ARRAY['Ezra 2']::text[]),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,3,ARRAY['Ezra 3']::text[]),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,4,ARRAY['Ezra 4']::text[]),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,5,ARRAY['Ezra 5']::text[]),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,6,ARRAY['Ezra 6']::text[]),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,7,ARRAY['Ezra 7']::text[]),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,8,ARRAY['Ezra 8']::text[]),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,9,ARRAY['Ezra 9']::text[]),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,10,ARRAY['Ezra 10']::text[]),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,11,ARRAY['Nehemiah 1']::text[]),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,12,ARRAY['Nehemiah 2']::text[]),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,13,ARRAY['Nehemiah 3']::text[]),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,14,ARRAY['Nehemiah 4']::text[]),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,15,ARRAY['Nehemiah 5']::text[]),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,16,ARRAY['Nehemiah 6']::text[]),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,17,ARRAY['Nehemiah 7']::text[]),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,18,ARRAY['Nehemiah 8']::text[]),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,19,ARRAY['Nehemiah 9']::text[]),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,20,ARRAY['Nehemiah 10']::text[]),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,21,ARRAY['Nehemiah 11']::text[]),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,22,ARRAY['Nehemiah 12']::text[]),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,23,ARRAY['Nehemiah 13']::text[]),
-- Hebrews and General Epistles in 34 Days; source: https://abrahamiclibrary.com/plan.php?id=catholic-epistles; catalog: https://abrahamiclibrary.com/plans.php
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,1,ARRAY['Hebrews 1']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,2,ARRAY['Hebrews 2']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,3,ARRAY['Hebrews 3']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,4,ARRAY['Hebrews 4']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,5,ARRAY['Hebrews 5']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,6,ARRAY['Hebrews 6']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,7,ARRAY['Hebrews 7']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,8,ARRAY['Hebrews 8']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,9,ARRAY['Hebrews 9']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,10,ARRAY['Hebrews 10']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,11,ARRAY['Hebrews 11']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,12,ARRAY['Hebrews 12']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,13,ARRAY['Hebrews 13']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,14,ARRAY['James 1']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,15,ARRAY['James 2']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,16,ARRAY['James 3']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,17,ARRAY['James 4']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,18,ARRAY['James 5']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,19,ARRAY['1 Peter 1']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,20,ARRAY['1 Peter 2']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,21,ARRAY['1 Peter 3']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,22,ARRAY['1 Peter 4']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,23,ARRAY['1 Peter 5']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,24,ARRAY['2 Peter 1']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,25,ARRAY['2 Peter 2']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,26,ARRAY['2 Peter 3']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,27,ARRAY['1 John 1']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,28,ARRAY['1 John 2']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,29,ARRAY['1 John 3']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,30,ARRAY['1 John 4']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,31,ARRAY['1 John 5']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,32,ARRAY['2 John 1']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,33,ARRAY['3 John 1']::text[]),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,34,ARRAY['Jude 1']::text[]);

-- Exact chapter universe for coverage validation; ensures nothing missing/duplicated.
CREATE TEMP TABLE _reading_more_expected_chapters (
  plan_id uuid NOT NULL, reference text NOT NULL, PRIMARY KEY(plan_id,reference)
) ON COMMIT DROP;
INSERT INTO _reading_more_expected_chapters(plan_id,reference) VALUES
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 1'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 2'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 3'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 4'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 5'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 6'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 7'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 8'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 9'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 10'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 11'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 12'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 13'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 14'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 15'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 16'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 17'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 18'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 19'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 20'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 21'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 22'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 23'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 24'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 25'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 26'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 27'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 28'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 29'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 30'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 31'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 32'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 33'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 34'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 35'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 36'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 37'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 38'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 39'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 40'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 41'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 42'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 43'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 44'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 45'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 46'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 47'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 48'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 49'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Genesis 50'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 1'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 2'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 3'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 4'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 5'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 6'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 7'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 8'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 9'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 10'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 11'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 12'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 13'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 14'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 15'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 16'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 17'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 18'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 19'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 20'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 21'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 22'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 23'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 24'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 25'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 26'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 27'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 28'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 29'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 30'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 31'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 32'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 33'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 34'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 35'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 36'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 37'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 38'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 39'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Exodus 40'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 1'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 2'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 3'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 4'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 5'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 6'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 7'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 8'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 9'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 10'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 11'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 12'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 13'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 14'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 15'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 16'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 17'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 18'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 19'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 20'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 21'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 22'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 23'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 24'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 25'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 26'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Leviticus 27'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 1'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 2'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 3'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 4'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 5'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 6'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 7'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 8'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 9'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 10'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 11'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 12'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 13'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 14'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 15'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 16'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 17'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 18'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 19'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 20'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 21'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 22'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 23'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 24'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 25'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 26'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 27'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 28'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 29'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 30'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 31'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 32'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 33'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 34'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 35'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Numbers 36'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 1'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 2'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 3'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 4'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 5'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 6'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 7'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 8'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 9'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 10'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 11'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 12'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 13'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 14'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 15'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 16'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 17'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 18'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 19'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 20'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 21'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 22'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 23'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 24'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 25'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 26'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 27'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 28'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 29'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 30'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 31'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 32'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 33'),
 ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,'Deuteronomy 34'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Hosea 1'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Hosea 2'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Hosea 3'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Hosea 4'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Hosea 5'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Hosea 6'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Hosea 7'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Hosea 8'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Hosea 9'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Hosea 10'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Hosea 11'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Hosea 12'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Hosea 13'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Hosea 14'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Joel 1'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Joel 2'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Joel 3'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Amos 1'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Amos 2'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Amos 3'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Amos 4'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Amos 5'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Amos 6'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Amos 7'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Amos 8'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Amos 9'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Obadiah 1'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Jonah 1'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Jonah 2'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Jonah 3'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Jonah 4'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Micah 1'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Micah 2'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Micah 3'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Micah 4'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Micah 5'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Micah 6'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Micah 7'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Nahum 1'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Nahum 2'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Nahum 3'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Habakkuk 1'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Habakkuk 2'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Habakkuk 3'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Zephaniah 1'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Zephaniah 2'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Zephaniah 3'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Haggai 1'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Haggai 2'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Zechariah 1'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Zechariah 2'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Zechariah 3'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Zechariah 4'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Zechariah 5'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Zechariah 6'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Zechariah 7'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Zechariah 8'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Zechariah 9'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Zechariah 10'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Zechariah 11'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Zechariah 12'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Zechariah 13'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Zechariah 14'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Malachi 1'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Malachi 2'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Malachi 3'),
 ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,'Malachi 4'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Ezra 1'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Ezra 2'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Ezra 3'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Ezra 4'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Ezra 5'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Ezra 6'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Ezra 7'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Ezra 8'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Ezra 9'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Ezra 10'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Nehemiah 1'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Nehemiah 2'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Nehemiah 3'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Nehemiah 4'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Nehemiah 5'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Nehemiah 6'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Nehemiah 7'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Nehemiah 8'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Nehemiah 9'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Nehemiah 10'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Nehemiah 11'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Nehemiah 12'),
 ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,'Nehemiah 13'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'Hebrews 1'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'Hebrews 2'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'Hebrews 3'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'Hebrews 4'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'Hebrews 5'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'Hebrews 6'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'Hebrews 7'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'Hebrews 8'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'Hebrews 9'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'Hebrews 10'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'Hebrews 11'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'Hebrews 12'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'Hebrews 13'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'James 1'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'James 2'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'James 3'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'James 4'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'James 5'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'1 Peter 1'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'1 Peter 2'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'1 Peter 3'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'1 Peter 4'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'1 Peter 5'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'2 Peter 1'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'2 Peter 2'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'2 Peter 3'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'1 John 1'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'1 John 2'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'1 John 3'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'1 John 4'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'1 John 5'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'2 John 1'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'3 John 1'),
 ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,'Jude 1');

DO $validate_input$
BEGIN
 IF (SELECT count(*) FROM _reading_more_catalog) <> 4 OR (SELECT count(*) FROM _reading_more_assignments) <> 311 THEN
  RAISE EXCEPTION 'Unexpected plan/day count'; END IF;
 IF EXISTS (SELECT 1 FROM _reading_more_catalog p LEFT JOIN
   (SELECT plan_id,count(*) AS n,min(day_number) AS lo,max(day_number) AS hi FROM _reading_more_assignments GROUP BY plan_id) x ON x.plan_id=p.id
   WHERE x.n IS DISTINCT FROM p.expected_days OR x.lo <> 1 OR x.hi <> p.expected_days) THEN RAISE EXCEPTION 'Day numbering incomplete'; END IF;
 IF EXISTS (SELECT 1 FROM _reading_more_assignments a
   WHERE cardinality(a.reference) <> 1 OR a.reference[1] IS NULL OR a.reference[1] !~ '^(?:[1-3] )?[A-Za-z]+(?: [A-Za-z]+)* [1-9][0-9]*$') THEN
   RAISE EXCEPTION 'Invalid Scripture reference'; END IF;
 IF EXISTS ((SELECT plan_id,reference[1] FROM _reading_more_assignments EXCEPT SELECT plan_id,reference FROM _reading_more_expected_chapters)
     UNION ALL (SELECT plan_id,reference FROM _reading_more_expected_chapters EXCEPT SELECT plan_id,reference[1] FROM _reading_more_assignments)) THEN
   RAISE EXCEPTION 'Chapter coverage mismatch'; END IF;
 IF EXISTS (SELECT 1 FROM _reading_more_catalog s JOIN public.devotional_plans p
   ON lower(btrim(p.title))=lower(btrim(s.title)) AND p.id <> s.id) THEN
   RAISE EXCEPTION 'Title collision with another existing plan'; END IF;
 IF EXISTS (SELECT 1 FROM _reading_more_catalog s JOIN public.devotional_plans p ON p.id=s.id
   WHERE p.title IS DISTINCT FROM s.title OR p.total_days IS DISTINCT FROM s.expected_days
   OR NOT ('reading'=ANY(coalesce(p.tags,'{}'::text[])))) THEN
   RAISE EXCEPTION 'Existing imported ID does not match expected plan'; END IF;
END $validate_input$;

-- Insert drafts first; the existing deferred publication trigger checks all days.
INSERT INTO public.devotional_plans
 (id,title,description,cover_image,completions,tags,status,total_days,author_id,visibility)
SELECT id,title,description,NULL,0,ARRAY['reading']::text[],'draft',expected_days,NULL,'public'
FROM _reading_more_catalog ON CONFLICT(id) DO NOTHING;
INSERT INTO public.devotional_days (id,plan_id,day_number,content,title)
SELECT gen_random_uuid(),plan_id,day_number,'',NULL FROM _reading_more_assignments
ON CONFLICT(plan_id,day_number) DO NOTHING;
DO $check_existing$
BEGIN
 IF EXISTS (SELECT 1 FROM _reading_more_assignments a
  JOIN public.devotional_days d ON d.plan_id=a.plan_id AND d.day_number=a.day_number
  LEFT JOIN public.scripture_references r ON r.day_id=d.id
  GROUP BY a.plan_id,a.day_number,a.reference,d.id,d.content
  HAVING d.content IS DISTINCT FROM '' OR count(r.id)>1
     OR (count(r.id)=1 AND bool_or(r.reference IS DISTINCT FROM a.reference))) THEN
     RAISE EXCEPTION 'Existing reading-day data differs; no changes committed'; END IF;
END $check_existing$;
INSERT INTO public.scripture_references(id,user_id,day_id,reference)
SELECT gen_random_uuid(),NULL,d.id,a.reference FROM _reading_more_assignments a
 JOIN public.devotional_days d ON d.plan_id=a.plan_id AND d.day_number=a.day_number
WHERE NOT EXISTS (SELECT 1 FROM public.scripture_references r WHERE r.day_id=d.id);
DO $validate_persisted$
BEGIN
 IF EXISTS (SELECT 1 FROM _reading_more_catalog s JOIN public.devotional_plans p ON p.id=s.id
   LEFT JOIN public.devotional_days d ON d.plan_id=p.id
   GROUP BY s.id,s.expected_days,p.id,p.tags
   HAVING count(d.id) <> s.expected_days OR min(d.day_number) <> 1 OR max(d.day_number) <> s.expected_days
      OR bool_or(d.content IS DISTINCT FROM '') OR NOT ('reading'=ANY(coalesce(p.tags,'{}'::text[])))) THEN
    RAISE EXCEPTION 'Persisted day/plan metadata invalid'; END IF;
 IF EXISTS (SELECT 1 FROM _reading_more_assignments a
   JOIN public.devotional_days d ON d.plan_id=a.plan_id AND d.day_number=a.day_number
   LEFT JOIN public.scripture_references r ON r.day_id=d.id
   GROUP BY a.plan_id,a.day_number,a.reference
   HAVING count(r.id) <> 1 OR NOT bool_and(r.reference IS NOT DISTINCT FROM a.reference)) THEN
   RAISE EXCEPTION 'Persisted scripture references invalid'; END IF;
END $validate_persisted$;
UPDATE public.devotional_plans p SET status = 'published'
FROM _reading_more_catalog s WHERE p.id=s.id AND p.status IS DISTINCT FROM 'published';

-- Source batch: 20261112183000_import_historical_books_prophets_and_paul_reading_plans.sql
-- Additional Bible reading plans: five book/collection schedules from The Abrahamic Library.
-- Catalog: https://abrahamiclibrary.com/plans.php
-- Source reuse statement: https://abrahamiclibrary.com/about.php
-- Reuse limits: historical Bible chapter identifiers are factual; publisher states its
-- texts and editions are public domain, but does not expressly license the scheduling
-- arrangement separately. Confirm schedule-specific permission for production use.
-- IMPORTANT VERIFICATION LIMITATION (2026-11-12): per-plan day pages returned HTTP 502.
-- Every day below is EXPANDED from the catalog's explicit canonical book order,
-- chapter-per-day pace (two, final day sometimes one), and duration. Therefore this
-- is a RECONSTRUCTION of declared rules, not a verbatim extraction of day pages.
-- Do not call these independently day-by-day publisher-verified schedules.
-- Only Protestant-canon books and normal chapter references; NO Bible text or prose.
-- The additional chapter plans are imported in the preceding section.
-- Existing progress/day IDs, unrelated plans, and any nonblank covers are preserved.
CREATE TEMP TABLE _batch_reading_catalog (
  id uuid PRIMARY KEY, title text NOT NULL, description text NOT NULL,
  source_url text NOT NULL, expected_days integer NOT NULL
) ON COMMIT DROP;
INSERT INTO _batch_reading_catalog(id,title,description,source_url,expected_days) VALUES
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,'The Former Prophets in 74 Days','Read Joshua, Judges, 1–2 Samuel and 1–2 Kings in canonical order, two complete chapters per day except the final single chapter.','https://abrahamiclibrary.com/plan.php?id=former-prophets',74),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,'Chronicles in 33 Days','Read 1 and 2 Chronicles in canonical order, two complete chapters each day except the final chapter.','https://abrahamiclibrary.com/plan.php?id=chronicles',33),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,'Jeremiah and Lamentations in 29 Days','Read all of Jeremiah and Lamentations in canonical order, two complete chapters each day except the final chapter.','https://abrahamiclibrary.com/plan.php?id=jeremiah',29),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,'Ezekiel in 24 Days','Read all forty-eight chapters of Ezekiel, two complete chapters each day.','https://abrahamiclibrary.com/plan.php?id=ezekiel',24),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,'The Letters of Paul in 44 Days','Read Romans through Philemon in canonical order, two complete chapters per day except the final chapter.','https://abrahamiclibrary.com/plan.php?id=paul',44);

CREATE TEMP TABLE _batch_reading_days (
  plan_id uuid NOT NULL, day_number integer NOT NULL, reference text[] NOT NULL,
  PRIMARY KEY(plan_id,day_number)
) ON COMMIT DROP;
INSERT INTO _batch_reading_days(plan_id,day_number,reference) VALUES
-- The Former Prophets in 74 Days; https://abrahamiclibrary.com/plan.php?id=former-prophets
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,1,ARRAY['Joshua 1', 'Joshua 2']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,2,ARRAY['Joshua 3', 'Joshua 4']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,3,ARRAY['Joshua 5', 'Joshua 6']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,4,ARRAY['Joshua 7', 'Joshua 8']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,5,ARRAY['Joshua 9', 'Joshua 10']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,6,ARRAY['Joshua 11', 'Joshua 12']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,7,ARRAY['Joshua 13', 'Joshua 14']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,8,ARRAY['Joshua 15', 'Joshua 16']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,9,ARRAY['Joshua 17', 'Joshua 18']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,10,ARRAY['Joshua 19', 'Joshua 20']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,11,ARRAY['Joshua 21', 'Joshua 22']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,12,ARRAY['Joshua 23', 'Joshua 24']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,13,ARRAY['Judges 1', 'Judges 2']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,14,ARRAY['Judges 3', 'Judges 4']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,15,ARRAY['Judges 5', 'Judges 6']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,16,ARRAY['Judges 7', 'Judges 8']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,17,ARRAY['Judges 9', 'Judges 10']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,18,ARRAY['Judges 11', 'Judges 12']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,19,ARRAY['Judges 13', 'Judges 14']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,20,ARRAY['Judges 15', 'Judges 16']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,21,ARRAY['Judges 17', 'Judges 18']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,22,ARRAY['Judges 19', 'Judges 20']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,23,ARRAY['Judges 21', '1 Samuel 1']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,24,ARRAY['1 Samuel 2', '1 Samuel 3']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,25,ARRAY['1 Samuel 4', '1 Samuel 5']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,26,ARRAY['1 Samuel 6', '1 Samuel 7']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,27,ARRAY['1 Samuel 8', '1 Samuel 9']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,28,ARRAY['1 Samuel 10', '1 Samuel 11']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,29,ARRAY['1 Samuel 12', '1 Samuel 13']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,30,ARRAY['1 Samuel 14', '1 Samuel 15']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,31,ARRAY['1 Samuel 16', '1 Samuel 17']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,32,ARRAY['1 Samuel 18', '1 Samuel 19']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,33,ARRAY['1 Samuel 20', '1 Samuel 21']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,34,ARRAY['1 Samuel 22', '1 Samuel 23']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,35,ARRAY['1 Samuel 24', '1 Samuel 25']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,36,ARRAY['1 Samuel 26', '1 Samuel 27']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,37,ARRAY['1 Samuel 28', '1 Samuel 29']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,38,ARRAY['1 Samuel 30', '1 Samuel 31']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,39,ARRAY['2 Samuel 1', '2 Samuel 2']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,40,ARRAY['2 Samuel 3', '2 Samuel 4']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,41,ARRAY['2 Samuel 5', '2 Samuel 6']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,42,ARRAY['2 Samuel 7', '2 Samuel 8']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,43,ARRAY['2 Samuel 9', '2 Samuel 10']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,44,ARRAY['2 Samuel 11', '2 Samuel 12']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,45,ARRAY['2 Samuel 13', '2 Samuel 14']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,46,ARRAY['2 Samuel 15', '2 Samuel 16']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,47,ARRAY['2 Samuel 17', '2 Samuel 18']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,48,ARRAY['2 Samuel 19', '2 Samuel 20']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,49,ARRAY['2 Samuel 21', '2 Samuel 22']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,50,ARRAY['2 Samuel 23', '2 Samuel 24']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,51,ARRAY['1 Kings 1', '1 Kings 2']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,52,ARRAY['1 Kings 3', '1 Kings 4']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,53,ARRAY['1 Kings 5', '1 Kings 6']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,54,ARRAY['1 Kings 7', '1 Kings 8']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,55,ARRAY['1 Kings 9', '1 Kings 10']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,56,ARRAY['1 Kings 11', '1 Kings 12']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,57,ARRAY['1 Kings 13', '1 Kings 14']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,58,ARRAY['1 Kings 15', '1 Kings 16']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,59,ARRAY['1 Kings 17', '1 Kings 18']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,60,ARRAY['1 Kings 19', '1 Kings 20']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,61,ARRAY['1 Kings 21', '1 Kings 22']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,62,ARRAY['2 Kings 1', '2 Kings 2']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,63,ARRAY['2 Kings 3', '2 Kings 4']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,64,ARRAY['2 Kings 5', '2 Kings 6']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,65,ARRAY['2 Kings 7', '2 Kings 8']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,66,ARRAY['2 Kings 9', '2 Kings 10']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,67,ARRAY['2 Kings 11', '2 Kings 12']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,68,ARRAY['2 Kings 13', '2 Kings 14']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,69,ARRAY['2 Kings 15', '2 Kings 16']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,70,ARRAY['2 Kings 17', '2 Kings 18']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,71,ARRAY['2 Kings 19', '2 Kings 20']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,72,ARRAY['2 Kings 21', '2 Kings 22']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,73,ARRAY['2 Kings 23', '2 Kings 24']::text[]),
 ('4973797b-c683-5404-8241-b6674061fa39'::uuid,74,ARRAY['2 Kings 25']::text[]),
-- Chronicles in 33 Days; https://abrahamiclibrary.com/plan.php?id=chronicles
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,1,ARRAY['1 Chronicles 1', '1 Chronicles 2']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,2,ARRAY['1 Chronicles 3', '1 Chronicles 4']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,3,ARRAY['1 Chronicles 5', '1 Chronicles 6']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,4,ARRAY['1 Chronicles 7', '1 Chronicles 8']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,5,ARRAY['1 Chronicles 9', '1 Chronicles 10']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,6,ARRAY['1 Chronicles 11', '1 Chronicles 12']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,7,ARRAY['1 Chronicles 13', '1 Chronicles 14']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,8,ARRAY['1 Chronicles 15', '1 Chronicles 16']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,9,ARRAY['1 Chronicles 17', '1 Chronicles 18']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,10,ARRAY['1 Chronicles 19', '1 Chronicles 20']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,11,ARRAY['1 Chronicles 21', '1 Chronicles 22']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,12,ARRAY['1 Chronicles 23', '1 Chronicles 24']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,13,ARRAY['1 Chronicles 25', '1 Chronicles 26']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,14,ARRAY['1 Chronicles 27', '1 Chronicles 28']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,15,ARRAY['1 Chronicles 29', '2 Chronicles 1']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,16,ARRAY['2 Chronicles 2', '2 Chronicles 3']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,17,ARRAY['2 Chronicles 4', '2 Chronicles 5']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,18,ARRAY['2 Chronicles 6', '2 Chronicles 7']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,19,ARRAY['2 Chronicles 8', '2 Chronicles 9']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,20,ARRAY['2 Chronicles 10', '2 Chronicles 11']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,21,ARRAY['2 Chronicles 12', '2 Chronicles 13']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,22,ARRAY['2 Chronicles 14', '2 Chronicles 15']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,23,ARRAY['2 Chronicles 16', '2 Chronicles 17']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,24,ARRAY['2 Chronicles 18', '2 Chronicles 19']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,25,ARRAY['2 Chronicles 20', '2 Chronicles 21']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,26,ARRAY['2 Chronicles 22', '2 Chronicles 23']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,27,ARRAY['2 Chronicles 24', '2 Chronicles 25']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,28,ARRAY['2 Chronicles 26', '2 Chronicles 27']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,29,ARRAY['2 Chronicles 28', '2 Chronicles 29']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,30,ARRAY['2 Chronicles 30', '2 Chronicles 31']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,31,ARRAY['2 Chronicles 32', '2 Chronicles 33']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,32,ARRAY['2 Chronicles 34', '2 Chronicles 35']::text[]),
 ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,33,ARRAY['2 Chronicles 36']::text[]),
-- Jeremiah and Lamentations in 29 Days; https://abrahamiclibrary.com/plan.php?id=jeremiah
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,1,ARRAY['Jeremiah 1', 'Jeremiah 2']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,2,ARRAY['Jeremiah 3', 'Jeremiah 4']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,3,ARRAY['Jeremiah 5', 'Jeremiah 6']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,4,ARRAY['Jeremiah 7', 'Jeremiah 8']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,5,ARRAY['Jeremiah 9', 'Jeremiah 10']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,6,ARRAY['Jeremiah 11', 'Jeremiah 12']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,7,ARRAY['Jeremiah 13', 'Jeremiah 14']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,8,ARRAY['Jeremiah 15', 'Jeremiah 16']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,9,ARRAY['Jeremiah 17', 'Jeremiah 18']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,10,ARRAY['Jeremiah 19', 'Jeremiah 20']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,11,ARRAY['Jeremiah 21', 'Jeremiah 22']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,12,ARRAY['Jeremiah 23', 'Jeremiah 24']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,13,ARRAY['Jeremiah 25', 'Jeremiah 26']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,14,ARRAY['Jeremiah 27', 'Jeremiah 28']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,15,ARRAY['Jeremiah 29', 'Jeremiah 30']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,16,ARRAY['Jeremiah 31', 'Jeremiah 32']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,17,ARRAY['Jeremiah 33', 'Jeremiah 34']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,18,ARRAY['Jeremiah 35', 'Jeremiah 36']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,19,ARRAY['Jeremiah 37', 'Jeremiah 38']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,20,ARRAY['Jeremiah 39', 'Jeremiah 40']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,21,ARRAY['Jeremiah 41', 'Jeremiah 42']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,22,ARRAY['Jeremiah 43', 'Jeremiah 44']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,23,ARRAY['Jeremiah 45', 'Jeremiah 46']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,24,ARRAY['Jeremiah 47', 'Jeremiah 48']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,25,ARRAY['Jeremiah 49', 'Jeremiah 50']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,26,ARRAY['Jeremiah 51', 'Jeremiah 52']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,27,ARRAY['Lamentations 1', 'Lamentations 2']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,28,ARRAY['Lamentations 3', 'Lamentations 4']::text[]),
 ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,29,ARRAY['Lamentations 5']::text[]),
-- Ezekiel in 24 Days; https://abrahamiclibrary.com/plan.php?id=ezekiel
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,1,ARRAY['Ezekiel 1', 'Ezekiel 2']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,2,ARRAY['Ezekiel 3', 'Ezekiel 4']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,3,ARRAY['Ezekiel 5', 'Ezekiel 6']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,4,ARRAY['Ezekiel 7', 'Ezekiel 8']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,5,ARRAY['Ezekiel 9', 'Ezekiel 10']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,6,ARRAY['Ezekiel 11', 'Ezekiel 12']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,7,ARRAY['Ezekiel 13', 'Ezekiel 14']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,8,ARRAY['Ezekiel 15', 'Ezekiel 16']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,9,ARRAY['Ezekiel 17', 'Ezekiel 18']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,10,ARRAY['Ezekiel 19', 'Ezekiel 20']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,11,ARRAY['Ezekiel 21', 'Ezekiel 22']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,12,ARRAY['Ezekiel 23', 'Ezekiel 24']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,13,ARRAY['Ezekiel 25', 'Ezekiel 26']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,14,ARRAY['Ezekiel 27', 'Ezekiel 28']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,15,ARRAY['Ezekiel 29', 'Ezekiel 30']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,16,ARRAY['Ezekiel 31', 'Ezekiel 32']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,17,ARRAY['Ezekiel 33', 'Ezekiel 34']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,18,ARRAY['Ezekiel 35', 'Ezekiel 36']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,19,ARRAY['Ezekiel 37', 'Ezekiel 38']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,20,ARRAY['Ezekiel 39', 'Ezekiel 40']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,21,ARRAY['Ezekiel 41', 'Ezekiel 42']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,22,ARRAY['Ezekiel 43', 'Ezekiel 44']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,23,ARRAY['Ezekiel 45', 'Ezekiel 46']::text[]),
 ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,24,ARRAY['Ezekiel 47', 'Ezekiel 48']::text[]),
-- The Letters of Paul in 44 Days; https://abrahamiclibrary.com/plan.php?id=paul
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,1,ARRAY['Romans 1', 'Romans 2']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,2,ARRAY['Romans 3', 'Romans 4']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,3,ARRAY['Romans 5', 'Romans 6']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,4,ARRAY['Romans 7', 'Romans 8']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,5,ARRAY['Romans 9', 'Romans 10']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,6,ARRAY['Romans 11', 'Romans 12']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,7,ARRAY['Romans 13', 'Romans 14']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,8,ARRAY['Romans 15', 'Romans 16']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,9,ARRAY['1 Corinthians 1', '1 Corinthians 2']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,10,ARRAY['1 Corinthians 3', '1 Corinthians 4']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,11,ARRAY['1 Corinthians 5', '1 Corinthians 6']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,12,ARRAY['1 Corinthians 7', '1 Corinthians 8']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,13,ARRAY['1 Corinthians 9', '1 Corinthians 10']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,14,ARRAY['1 Corinthians 11', '1 Corinthians 12']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,15,ARRAY['1 Corinthians 13', '1 Corinthians 14']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,16,ARRAY['1 Corinthians 15', '1 Corinthians 16']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,17,ARRAY['2 Corinthians 1', '2 Corinthians 2']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,18,ARRAY['2 Corinthians 3', '2 Corinthians 4']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,19,ARRAY['2 Corinthians 5', '2 Corinthians 6']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,20,ARRAY['2 Corinthians 7', '2 Corinthians 8']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,21,ARRAY['2 Corinthians 9', '2 Corinthians 10']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,22,ARRAY['2 Corinthians 11', '2 Corinthians 12']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,23,ARRAY['2 Corinthians 13', 'Galatians 1']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,24,ARRAY['Galatians 2', 'Galatians 3']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,25,ARRAY['Galatians 4', 'Galatians 5']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,26,ARRAY['Galatians 6', 'Ephesians 1']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,27,ARRAY['Ephesians 2', 'Ephesians 3']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,28,ARRAY['Ephesians 4', 'Ephesians 5']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,29,ARRAY['Ephesians 6', 'Philippians 1']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,30,ARRAY['Philippians 2', 'Philippians 3']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,31,ARRAY['Philippians 4', 'Colossians 1']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,32,ARRAY['Colossians 2', 'Colossians 3']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,33,ARRAY['Colossians 4', '1 Thessalonians 1']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,34,ARRAY['1 Thessalonians 2', '1 Thessalonians 3']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,35,ARRAY['1 Thessalonians 4', '1 Thessalonians 5']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,36,ARRAY['2 Thessalonians 1', '2 Thessalonians 2']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,37,ARRAY['2 Thessalonians 3', '1 Timothy 1']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,38,ARRAY['1 Timothy 2', '1 Timothy 3']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,39,ARRAY['1 Timothy 4', '1 Timothy 5']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,40,ARRAY['1 Timothy 6', '2 Timothy 1']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,41,ARRAY['2 Timothy 2', '2 Timothy 3']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,42,ARRAY['2 Timothy 4', 'Titus 1']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,43,ARRAY['Titus 2', 'Titus 3']::text[]),
 ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,44,ARRAY['Philemon 1']::text[]);

-- Fail before persistent writes if a plan title or fixed UUID belongs to other content.
DO $batch_precheck$
BEGIN
  IF (SELECT count(*) FROM _batch_reading_catalog) <> 5
    OR (SELECT count(*) FROM _batch_reading_days) <> 204 THEN
    RAISE EXCEPTION 'Incorrect incoming plan/day counts';
  END IF;
  IF EXISTS (
    SELECT 1 FROM _batch_reading_catalog c
    LEFT JOIN (
      SELECT plan_id,count(*) n,min(day_number) lo,max(day_number) hi
      FROM _batch_reading_days GROUP BY plan_id
    ) x ON x.plan_id=c.id
    WHERE x.n IS DISTINCT FROM c.expected_days OR x.lo IS DISTINCT FROM 1
      OR x.hi IS DISTINCT FROM c.expected_days
  ) THEN
    RAISE EXCEPTION 'Invalid incoming day numbering';
  END IF;
  IF EXISTS (
    SELECT 1 FROM _batch_reading_days d
    WHERE cardinality(d.reference) < 1
      OR EXISTS (SELECT 1 FROM unnest(d.reference) r WHERE r IS NULL OR r !~ '^[1-3]? ?[A-Za-z]+( [A-Za-z]+)* [1-9][0-9]*$')
  ) THEN
    RAISE EXCEPTION 'Incoming scripture reference format invalid';
  END IF;
  IF EXISTS (
    SELECT 1 FROM _batch_reading_catalog c
    JOIN public.devotional_plans p ON lower(btrim(c.title))=lower(btrim(p.title))
    WHERE p.id<>c.id
  ) THEN
    RAISE EXCEPTION 'Conflicting existing plan title';
  END IF;
  IF EXISTS (
    SELECT 1 FROM _batch_reading_catalog c
    JOIN public.devotional_plans p ON p.id=c.id
    WHERE p.title IS DISTINCT FROM c.title
       OR p.total_days IS DISTINCT FROM c.expected_days
  ) THEN
    RAISE EXCEPTION 'Conflicting existing plan UUID or day count';
  END IF;
END
$batch_precheck$;

-- Catalog insert is create-only, retaining covers, completions and author metadata on reruns.
INSERT INTO public.devotional_plans
  (id,title,description,cover_image,completions,tags,status,total_days,author_id,visibility)
SELECT id,title,description,NULL,0,ARRAY['reading']::text[],'draft',expected_days,NULL,'public'
FROM _batch_reading_catalog
ON CONFLICT(id) DO NOTHING;

-- Existing daily IDs and nonempty content must not be overwritten.
INSERT INTO public.devotional_days(id,plan_id,day_number,content,title)
SELECT gen_random_uuid(),d.plan_id,d.day_number,'',NULL
FROM _batch_reading_days d
ON CONFLICT(plan_id,day_number) DO NOTHING;

DO $batch_existing_check$
BEGIN
  IF EXISTS (
    SELECT 1 FROM _batch_reading_days a
    JOIN public.devotional_days d ON d.plan_id=a.plan_id AND d.day_number=a.day_number
    LEFT JOIN public.scripture_references s ON s.day_id=d.id
    GROUP BY a.plan_id,a.day_number,a.reference,d.id,d.content
    HAVING d.content IS DISTINCT FROM '' OR count(s.id)>1
      OR (count(s.id)=1 AND bool_or(s.reference IS DISTINCT FROM a.reference))
  ) THEN
    RAISE EXCEPTION 'Existing reading-day content/references differ';
  END IF;
END
$batch_existing_check$;

INSERT INTO public.scripture_references(id,user_id,day_id,reference)
SELECT gen_random_uuid(),NULL,d.id,a.reference
FROM _batch_reading_days a
JOIN public.devotional_days d ON d.plan_id=a.plan_id AND d.day_number=a.day_number
WHERE NOT EXISTS (SELECT 1 FROM public.scripture_references s WHERE s.day_id=d.id);

DO $batch_integrity$
BEGIN
  IF EXISTS (
    SELECT 1 FROM _batch_reading_catalog c
    JOIN public.devotional_plans p ON p.id=c.id
    LEFT JOIN public.devotional_days d ON d.plan_id=c.id
    GROUP BY c.id,c.expected_days,p.total_days,p.tags,p.visibility,p.status
    HAVING count(d.id) <> c.expected_days
      OR min(d.day_number) <> 1 OR max(d.day_number) <> c.expected_days
      OR p.total_days <> c.expected_days
      OR bool_or(d.content IS DISTINCT FROM '')
      OR NOT ('reading'=ANY(coalesce(p.tags,'{}'::text[])))
  ) THEN
    RAISE EXCEPTION 'Final plan/day metadata invalid';
  END IF;
  IF EXISTS (
    SELECT 1 FROM _batch_reading_days a
    JOIN public.devotional_days d ON d.plan_id=a.plan_id AND d.day_number=a.day_number
    LEFT JOIN public.scripture_references s ON s.day_id=d.id
    GROUP BY d.id,a.reference
    HAVING count(s.id)<>1 OR bool_or(s.reference IS DISTINCT FROM a.reference)
  ) THEN
    RAISE EXCEPTION 'Final scripture assignment mismatch';
  END IF;
END
$batch_integrity$;

-- Deferred publication trigger validates that every day has a nonempty reference.
UPDATE public.devotional_plans p
SET status='published', updated_at=now()
FROM _batch_reading_catalog c
WHERE p.id=c.id AND p.status IS DISTINCT FROM 'published';

COMMIT;
