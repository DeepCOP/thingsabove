-- Consolidated cover-image assignments for all 30 imported reading plans.
-- Apply after 20261111184700_import_reading_plans.sql.
-- All plan imports must exist before any cover batch is validated.
-- Preserves source notes and fills only missing or blank cover images.
-- All three batches run in one transaction.

BEGIN;

-- Source batch: 20261112140000_add_nicene_aligned_reading_plan_covers.sql
-- Data-only migration: curated public-domain / CC0 cover art for 18 imported reading plans.
-- The consolidated reading-plan import must run before this migration.
-- Every Commons file title below was individually located on its Wikimedia Commons description page.
-- Artwork has been selected for biblical subject matter compatible with Nicene Christianity.
-- This is an editorial selection, NOT a theological endorsement of every depiction or tradition.
-- URLs use the Wikimedia Commons Special:FilePath redirect to the original image.
-- Direct image redirects are third-party dependencies; production apps should consider
-- hosting legally reviewed copies in Supabase Storage and swapping the cover URLs.
-- Rights: public domain / public-domain photographic reproduction unless marked CC0.
-- Reuse varies by jurisdiction for photographs of PD paintings; review in deployment territories.
-- Does not touch any existing nonempty cover, devotional days, reference arrays or progress.
CREATE TEMP TABLE import_reading_cover_art (
  plan_id uuid PRIMARY KEY,
  expected_title text NOT NULL,
  image_url text NOT NULL,
  image_file_page text NOT NULL,
  subject_note text NOT NULL
) ON COMMIT DROP;
INSERT INTO import_reading_cover_art (plan_id,expected_title,image_url,image_file_page,subject_note) VALUES
  -- Genesis in 50 Days | Commons: https://commons.wikimedia.org/wiki/File:Abraham_and_the_Three_Angels.jpg | Rights: Commons file page (PD/CC0)
  ('ac1c2397-25b2-5ed0-8f27-c4fbc6f87d80'::uuid, 'Genesis in 50 Days', 'https://commons.wikimedia.org/wiki/Special:FilePath/Abraham%20and%20the%20Three%20Angels.jpg', 'https://commons.wikimedia.org/wiki/File:Abraham_and_the_Three_Angels.jpg', 'Abraham welcomes three visitors, Genesis 18; Wikimedia uploader released photograph into public domain'),
  -- Exodus in 40 Days | Commons: https://commons.wikimedia.org/wiki/File:Moses_crossing_the_Red_Sea._Majma%27_al-tawarikh_%281425%29.jpg | Rights: Commons file page (PD/CC0)
  ('eb9490a5-332e-5134-9c00-3c011ef96c11'::uuid, 'Exodus in 40 Days', 'https://commons.wikimedia.org/wiki/Special:FilePath/Moses%20crossing%20the%20Red%20Sea.%20Majma%27%20al-tawarikh%20%281425%29.jpg', 'https://commons.wikimedia.org/wiki/File:Moses_crossing_the_Red_Sea._Majma%27_al-tawarikh_%281425%29.jpg', 'Moses and the Red Sea'),
  -- Leviticus in 27 Days | Commons: https://commons.wikimedia.org/wiki/File:The_tabernacle_in_the_wilderness_LCCN2004670677.jpg | Rights: Commons file page (PD/CC0)
  ('81aeaff6-55df-59bb-99e4-da44cf74ffbd'::uuid, 'Leviticus in 27 Days', 'https://commons.wikimedia.org/wiki/Special:FilePath/The%20tabernacle%20in%20the%20wilderness%20LCCN2004670677.jpg', 'https://commons.wikimedia.org/wiki/File:The_tabernacle_in_the_wilderness_LCCN2004670677.jpg', 'The wilderness tabernacle'),
  -- Isaiah in 66 Days | Commons: https://commons.wikimedia.org/wiki/File:Prophet_Isaiah.jpg | Rights: Commons file page (PD/CC0)
  ('6ad26411-74d5-5631-8ea2-3c9841293293'::uuid, 'Isaiah in 66 Days', 'https://commons.wikimedia.org/wiki/Special:FilePath/Prophet%20Isaiah.jpg', 'https://commons.wikimedia.org/wiki/File:Prophet_Isaiah.jpg', 'Prophet Isaiah'),
  -- Proverbs in 31 Days | Commons: https://commons.wikimedia.org/wiki/File:Dore_Solomon_Proverbs.png | Rights: Commons file page (PD/CC0)
  ('f54fbb97-5e2b-541a-8efc-7f69110d7803'::uuid, 'Proverbs in 31 Days', 'https://commons.wikimedia.org/wiki/Special:FilePath/Dore%20Solomon%20Proverbs.png', 'https://commons.wikimedia.org/wiki/File:Dore_Solomon_Proverbs.png', 'Solomon and Proverbs'),
  -- Matthew in 28 Days | Commons: https://commons.wikimedia.org/wiki/File:Evangelist-St.-Matthew-And-The-Angel.jpg | Rights: Commons file page (PD/CC0)
  ('db795fdc-3edb-5d23-8154-ab7be9ba8956'::uuid, 'Matthew in 28 Days', 'https://commons.wikimedia.org/wiki/Special:FilePath/Evangelist-St.-Matthew-And-The-Angel.jpg', 'https://commons.wikimedia.org/wiki/File:Evangelist-St.-Matthew-And-The-Angel.jpg', 'Matthew the Evangelist'),
  -- Mark in 16 Days | Commons: https://commons.wikimedia.org/wiki/File:Mark_Evangelist.jpg | Rights: Commons file page (PD/CC0)
  ('6c0f799a-f7cc-5bd4-97b0-6167b080ca06'::uuid, 'Mark in 16 Days', 'https://commons.wikimedia.org/wiki/Special:FilePath/Mark%20Evangelist.jpg', 'https://commons.wikimedia.org/wiki/File:Mark_Evangelist.jpg', 'Mark the Evangelist'),
  -- Luke in 24 Days | Commons: https://commons.wikimedia.org/wiki/File:St_Luke_the_Evangelist.jpg | Rights: Commons file page (PD/CC0)
  ('82b72caf-4a3a-5f30-9e0b-53b7cb61c38b'::uuid, 'Luke in 24 Days', 'https://commons.wikimedia.org/wiki/Special:FilePath/St%20Luke%20the%20Evangelist.jpg', 'https://commons.wikimedia.org/wiki/File:St_Luke_the_Evangelist.jpg', 'Luke the Evangelist'),
  -- John in 21 Days | Commons: https://commons.wikimedia.org/wiki/File:Saint_John_the_Evangelist_by_Ottavio_Vannini.jpg | Rights: Commons file page (PD/CC0)
  ('ec99a2b1-ab0f-5738-8ef5-d22b8f60e971'::uuid, 'John in 21 Days', 'https://commons.wikimedia.org/wiki/Special:FilePath/Saint%20John%20the%20Evangelist%20by%20Ottavio%20Vannini.jpg', 'https://commons.wikimedia.org/wiki/File:Saint_John_the_Evangelist_by_Ottavio_Vannini.jpg', 'John the Evangelist'),
  -- Acts in 28 Days | Commons: https://commons.wikimedia.org/wiki/File:The_Pentecost.jpg | Rights: Commons file page (PD/CC0)
  ('dd0c19a0-e480-58bd-906c-a5588512f551'::uuid, 'Acts in 28 Days', 'https://commons.wikimedia.org/wiki/Special:FilePath/The%20Pentecost.jpg', 'https://commons.wikimedia.org/wiki/File:The_Pentecost.jpg', 'Pentecost; historical painting, public domain'),
  -- Romans in 16 Days | Commons: https://commons.wikimedia.org/wiki/File:Saint_Paul.jpg | Rights: Commons file page (PD/CC0)
  ('92b132bb-6ee3-564e-a95d-8274ac10bfc6'::uuid, 'Romans in 16 Days', 'https://commons.wikimedia.org/wiki/Special:FilePath/Saint%20Paul.jpg', 'https://commons.wikimedia.org/wiki/File:Saint_Paul.jpg', 'Paul the Apostle'),
  -- 1 Corinthians in 16 Days | Commons: https://commons.wikimedia.org/wiki/File:Saint_Paul_%29.jpg | Rights: Commons file page (PD/CC0)
  ('ab8ee088-6823-5ef9-b1c2-34b767280496'::uuid, '1 Corinthians in 16 Days', 'https://commons.wikimedia.org/wiki/Special:FilePath/Saint%20Paul%20%29.jpg', 'https://commons.wikimedia.org/wiki/File:Saint_Paul_%29.jpg', 'Paul the Apostle'),
  -- Hebrews in 13 Days | Commons: https://commons.wikimedia.org/wiki/File:The_tabernacle_in_the_wilderness_LCCN2004670677.jpg | Rights: Commons file page (PD/CC0)
  ('2cbb3b87-2511-5375-8ce1-a4294696f431'::uuid, 'Hebrews in 13 Days', 'https://commons.wikimedia.org/wiki/Special:FilePath/The%20tabernacle%20in%20the%20wilderness%20LCCN2004670677.jpg', 'https://commons.wikimedia.org/wiki/File:The_tabernacle_in_the_wilderness_LCCN2004670677.jpg', 'Tabernacle as fulfillment typology; avoids disputed Hebrews authorship'),
  -- Revelation in 22 Days | Commons: https://commons.wikimedia.org/wiki/File:The_Vision_of_Saint_John_MET_DT1052.jpg | Rights: Commons file page (PD/CC0)
  ('abd9c6d6-8218-5a4f-b00e-e644b3613c46'::uuid, 'Revelation in 22 Days', 'https://commons.wikimedia.org/wiki/Special:FilePath/The%20Vision%20of%20Saint%20John%20MET%20DT1052.jpg', 'https://commons.wikimedia.org/wiki/File:The_Vision_of_Saint_John_MET_DT1052.jpg', 'The vision of Saint John; Met CC0'),
  -- The Four Gospels in 89 Days | Commons: https://commons.wikimedia.org/wiki/File:The_Four_Evangelists.jpg | Rights: Commons file page (PD/CC0)
  ('6f385ddc-5b84-58b2-a237-400b4b9ba904'::uuid, 'The Four Gospels in 89 Days', 'https://commons.wikimedia.org/wiki/Special:FilePath/The%20Four%20Evangelists.jpg', 'https://commons.wikimedia.org/wiki/File:The_Four_Evangelists.jpg', 'The four Evangelists'),
  -- James, Peter and Jude in 14 Days | Commons: https://commons.wikimedia.org/wiki/File:The_Pentecost.jpg | Rights: Commons file page (PD/CC0)
  ('7400ac43-f0ea-5b0a-bb2a-06633a41746e'::uuid, 'James, Peter and Jude in 14 Days', 'https://commons.wikimedia.org/wiki/Special:FilePath/The%20Pentecost.jpg', 'https://commons.wikimedia.org/wiki/File:The_Pentecost.jpg', 'Apostolic Church, Pentecost; CC0'),
  -- Galatians, Ephesians and Colossians in 16 Days | Commons: https://commons.wikimedia.org/wiki/File:Saint_Paul.jpg | Rights: Commons file page (PD/CC0)
  ('46fc6363-6105-557d-be22-943ad6fb8d1c'::uuid, 'Galatians, Ephesians and Colossians in 16 Days', 'https://commons.wikimedia.org/wiki/Special:FilePath/Saint%20Paul.jpg', 'https://commons.wikimedia.org/wiki/File:Saint_Paul.jpg', 'Paul the Apostle'),
  -- Psalms in 30 Days — 1662 Prayer Book Psalter | Commons: https://commons.wikimedia.org/wiki/File:King_David_playing_the_Harp.png | Rights: Commons file page (PD/CC0)
  ('19e91725-8110-538e-8e38-95c2e0fc6ace'::uuid, 'Psalms in 30 Days — 1662 Prayer Book Psalter', 'https://commons.wikimedia.org/wiki/Special:FilePath/King%20David%20playing%20the%20Harp.png', 'https://commons.wikimedia.org/wiki/File:King_David_playing_the_Harp.png', 'King David with harp');

-- Stop if imported IDs have been claimed by a different title, or required plan seeds are missing.
DO $cover_art_validation$
BEGIN
 IF EXISTS (
   SELECT 1 FROM import_reading_cover_art c
   LEFT JOIN public.devotional_plans p ON p.id=c.plan_id
   WHERE p.id IS NULL OR p.title IS DISTINCT FROM c.expected_title
 ) THEN
  RAISE EXCEPTION 'Cover art import requires all 18 expected reading plans with matching UUIDs and titles';
 END IF;
 IF (SELECT count(*) FROM import_reading_cover_art) <> 18 THEN
  RAISE EXCEPTION 'Expected 18 cover-image assignments';
 END IF;
END
$cover_art_validation$;

-- Preserve previously curated images; add new images only if unset or blank.
UPDATE public.devotional_plans p
SET cover_image=c.image_url,
    updated_at=now()
FROM import_reading_cover_art c
WHERE p.id=c.plan_id
  AND (p.cover_image IS NULL OR btrim(p.cover_image)='');

-- Source batch: 20261112151000_add_cover_images_for_remaining_reading_plans.sql
-- Data-only migration: add cover art for the 7 reading plans that remained uncovered
-- after the initial 18 cover assignments in the preceding section.
-- Does not modify titles, descriptions, tags, days, scripture references, completions,
-- author_id, visibility, or any existing nonempty cover image.
--
-- Source policy:
-- - Artwork is selected from Wikimedia Commons file pages with public-domain / PDM /
--   otherwise clearly reusable status as recorded on the linked file page.
-- - URLs use Wikimedia Commons Special:FilePath redirects to the image asset.
-- - Some files are photographic reproductions of public-domain works; reuse of such
--   reproductions can vary by jurisdiction. Review before production deployment.
-- - Subjects were chosen to be biblically appropriate and broadly compatible with
--   Nicene Christianity. This is an editorial curation, not a theological endorsement
--   of every artistic tradition represented.

CREATE TEMP TABLE import_remaining_reading_cover_art (
  plan_id uuid PRIMARY KEY,
  expected_title text NOT NULL,
  image_url text NOT NULL,
  image_file_page text NOT NULL,
  subject_note text NOT NULL
) ON COMMIT DROP;

INSERT INTO import_remaining_reading_cover_art (
  plan_id, expected_title, image_url, image_file_page, subject_note
) VALUES
  -- Psalms 1–50: A Psalm a Day
  -- Commons file page: https://commons.wikimedia.org/wiki/File:King_David_playing_the_Harp.png
  -- Rights: public-domain artwork / public-domain photographic reproduction per Commons file page.
  ('26e317cd-cc49-50b8-a7e8-2980909533da'::uuid,
   'Psalms 1–50: A Psalm a Day',
   'https://commons.wikimedia.org/wiki/Special:FilePath/King%20David%20playing%20the%20Harp.png',
   'https://commons.wikimedia.org/wiki/File:King_David_playing_the_Harp.png',
   'King David playing the harp; suitable for the opening half of Psalms'),

  -- Psalms 51–100: A Psalm a Day
  -- Commons file page: https://commons.wikimedia.org/wiki/File:King_David,_the_King_of_Israel.jpg
  -- Rights: public-domain artwork / public-domain photographic reproduction per Commons file page.
  ('7caf611d-5303-5e33-9dbe-81b530cb05ff'::uuid,
   'Psalms 51–100: A Psalm a Day',
   'https://commons.wikimedia.org/wiki/Special:FilePath/King%20David%2C%20the%20King%20of%20Israel.jpg',
   'https://commons.wikimedia.org/wiki/File:King_David,_the_King_of_Israel.jpg',
   'King David with harp; suitable for the second half of Psalms'),

  -- Genesis 1–11 in 11 Days
  -- Commons file page: https://commons.wikimedia.org/wiki/File:Noahs_Ark.jpg
  -- Rights: public-domain artwork per Commons file page.
  ('4ec02fef-458c-5148-a88d-ed594f8e2526'::uuid,
   'Genesis 1–11 in 11 Days',
   'https://commons.wikimedia.org/wiki/Special:FilePath/Noahs%20Ark.jpg',
   'https://commons.wikimedia.org/wiki/File:Noahs_Ark.jpg',
   'Noah''s Ark; a representative early-Genesis scene within chapters 1–11'),

  -- The Torah in 187 Days
  -- Commons file page: https://commons.wikimedia.org/wiki/File:Raphael_Moses_Receiving_the_Tablets_of_the_Law.jpg
  -- Rights: public-domain artwork / public-domain photographic reproduction per Commons file page.
  ('739dadf9-c48c-56bd-b79d-869b2f526037'::uuid,
   'The Torah in 187 Days',
   'https://commons.wikimedia.org/wiki/Special:FilePath/Raphael%20Moses%20Receiving%20the%20Tablets%20of%20the%20Law.jpg',
   'https://commons.wikimedia.org/wiki/File:Raphael_Moses_Receiving_the_Tablets_of_the_Law.jpg',
   'Moses receiving the tablets of the law; representative of the Pentateuch'),

  -- The Twelve Minor Prophets in 67 Days
  -- Commons file page: https://commons.wikimedia.org/wiki/File:Malachi.jpg
  -- Rights: public-domain icon per Commons file page.
  ('32113956-5ba6-5dbc-b6c6-fe2e8760647a'::uuid,
   'The Twelve Minor Prophets in 67 Days',
   'https://commons.wikimedia.org/wiki/Special:FilePath/Malachi.jpg',
   'https://commons.wikimedia.org/wiki/File:Malachi.jpg',
   'Prophet Malachi with scroll; representative of the Minor Prophets'),

  -- Ezra and Nehemiah in 23 Days
  -- Commons file page: https://commons.wikimedia.org/wiki/File:Ezra_reading_the_Law.jpg
  -- Rights: public-domain file page indicates public domain.
  ('69f0b2b7-147f-5ee8-8d51-8c740708387a'::uuid,
   'Ezra and Nehemiah in 23 Days',
   'https://commons.wikimedia.org/wiki/Special:FilePath/Ezra%20reading%20the%20Law.jpg',
   'https://commons.wikimedia.org/wiki/File:Ezra_reading_the_Law.jpg',
   'Ezra reading the Law to the people; directly aligned with Ezra–Nehemiah themes'),

  -- Hebrews and General Epistles in 34 Days
  -- Commons file page: https://commons.wikimedia.org/wiki/File:Saints_Peter_and_John_Healing_the_Lame_Man_MET_DP340180.jpg
  -- Rights: public-domain artwork / MET open-access image as shown on Commons file page.
  ('c6ff1b6a-d6e2-577e-8fb4-2f9459a056c2'::uuid,
   'Hebrews and General Epistles in 34 Days',
   'https://commons.wikimedia.org/wiki/Special:FilePath/Saints%20Peter%20and%20John%20Healing%20the%20Lame%20Man%20MET%20DP340180.jpg',
   'https://commons.wikimedia.org/wiki/File:Saints_Peter_and_John_Healing_the_Lame_Man_MET_DP340180.jpg',
   'Saints Peter and John healing the lame man; representative of the apostolic witness reflected in the general epistles');

DO $validate_cover_targets$
BEGIN
  IF (SELECT count(*) FROM import_remaining_reading_cover_art) <> 7 THEN
    RAISE EXCEPTION 'Expected 7 remaining cover-image assignments';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM import_remaining_reading_cover_art c
    LEFT JOIN public.devotional_plans p ON p.id = c.plan_id
    WHERE p.id IS NULL OR p.title IS DISTINCT FROM c.expected_title
  ) THEN
    RAISE EXCEPTION 'Remaining cover-image migration requires all 7 expected plans with matching UUIDs and titles';
  END IF;
END
$validate_cover_targets$;

-- Preserve previously curated or manually added covers; only fill missing / blank covers.
UPDATE public.devotional_plans p
SET cover_image = c.image_url,
    updated_at = now()
FROM import_remaining_reading_cover_art c
WHERE p.id = c.plan_id
  AND (p.cover_image IS NULL OR btrim(p.cover_image) = '');

-- Source batch: 20261112184500_add_cover_images_for_five_new_reading_plans.sql
-- Data-only migration: cover art for the five historical-books, prophets,
-- and Pauline-letter plans included in the consolidated reading-plan import.
--
-- Safety:
-- - Does not modify titles, descriptions, schedules, references, tags, completions,
--   visibility, authorship, or existing nonempty cover_image values.
-- - Fails fast if the expected plan UUIDs/titles are not present.
--
-- Source policy:
-- - Artwork is drawn from Wikimedia Commons file pages showing public-domain,
--   Public Domain Mark, or otherwise clearly reusable status.
-- - URLs use Wikimedia Commons Special:FilePath redirects.
-- - Some files are photographs/digital reproductions of public-domain artworks;
--   review reuse requirements in deployment jurisdictions before production use.
-- - Artwork has been chosen for biblical subject matter broadly compatible with
--   Nicene Christianity.

CREATE TEMP TABLE import_five_new_reading_plan_covers (
  plan_id uuid PRIMARY KEY,
  expected_title text NOT NULL,
  image_url text NOT NULL,
  image_file_page text NOT NULL,
  subject_note text NOT NULL
) ON COMMIT DROP;

INSERT INTO import_five_new_reading_plan_covers (
  plan_id, expected_title, image_url, image_file_page, subject_note
) VALUES
  -- The Former Prophets in 74 Days
  -- Commons file page: https://commons.wikimedia.org/wiki/File:Samuel_anointing_David.jpg
  ('4973797b-c683-5404-8241-b6674061fa39'::uuid,
   'The Former Prophets in 74 Days',
   'https://commons.wikimedia.org/wiki/Special:FilePath/Samuel%20anointing%20David.jpg',
   'https://commons.wikimedia.org/wiki/File:Samuel_anointing_David.jpg',
   'Samuel anointing David; representative of Israel''s historical books and monarchy'),

  -- Chronicles in 33 Days
  -- Commons file page: https://commons.wikimedia.org/wiki/File:Solomon_dedicating_the_temple.jpg
  ('34dd5071-c354-5818-9476-38319ecf52a3'::uuid,
   'Chronicles in 33 Days',
   'https://commons.wikimedia.org/wiki/Special:FilePath/Solomon%20dedicating%20the%20temple.jpg',
   'https://commons.wikimedia.org/wiki/File:Solomon_dedicating_the_temple.jpg',
   'Solomon dedicating the temple; fitting for the Davidic and temple emphasis of Chronicles'),

  -- Jeremiah and Lamentations in 29 Days
  -- Commons file page: https://commons.wikimedia.org/wiki/File:Rembrandt_-_Jeremiah_lamenting.jpg
  ('a0a2346d-bf16-5a17-89d1-3198d2e057ec'::uuid,
   'Jeremiah and Lamentations in 29 Days',
   'https://commons.wikimedia.org/wiki/Special:FilePath/Rembrandt%20-%20Jeremiah%20lamenting.jpg',
   'https://commons.wikimedia.org/wiki/File:Rembrandt_-_Jeremiah_lamenting.jpg',
   'Jeremiah lamenting the destruction of Jerusalem; closely aligned with Jeremiah and Lamentations'),

  -- Ezekiel in 24 Days
  -- Commons file page: https://commons.wikimedia.org/wiki/File:Raffael-vision-ezechiel.jpg
  ('1cfa988d-32b2-5beb-8381-3ac334bc0920'::uuid,
   'Ezekiel in 24 Days',
   'https://commons.wikimedia.org/wiki/Special:FilePath/Raffael-vision-ezechiel.jpg',
   'https://commons.wikimedia.org/wiki/File:Raffael-vision-ezechiel.jpg',
   'Ezekiel''s vision; suitable for the prophetic imagery of Ezekiel'),

  -- The Letters of Paul in 44 Days
  -- Commons file page: https://commons.wikimedia.org/wiki/File:Saint_Paul.jpg
  ('6f30c4ea-d024-5c98-bc09-5d0e11f10c1c'::uuid,
   'The Letters of Paul in 44 Days',
   'https://commons.wikimedia.org/wiki/Special:FilePath/Saint%20Paul.jpg',
   'https://commons.wikimedia.org/wiki/File:Saint_Paul.jpg',
   'Saint Paul the Apostle; representative of the Pauline epistles');

DO $validate_expected_plans$
BEGIN
  IF (SELECT count(*) FROM import_five_new_reading_plan_covers) <> 5 THEN
    RAISE EXCEPTION 'Expected 5 cover-image assignments for newest reading plans';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM import_five_new_reading_plan_covers c
    LEFT JOIN public.devotional_plans p ON p.id = c.plan_id
    WHERE p.id IS NULL OR p.title IS DISTINCT FROM c.expected_title
  ) THEN
    RAISE EXCEPTION 'Newest cover-image migration requires the 5 expected reading plans with matching UUIDs and titles';
  END IF;
END
$validate_expected_plans$;

UPDATE public.devotional_plans p
SET cover_image = c.image_url,
    updated_at = now()
FROM import_five_new_reading_plan_covers c
WHERE p.id = c.plan_id
  AND (p.cover_image IS NULL OR btrim(p.cover_image) = '');

COMMIT;
