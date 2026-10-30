-- Convert Scripture/section Roman numerals to Arabic digits and modernize
-- verified archaic wording in the published public-domain plans.
-- Historical personal names keep their conventional Roman ordinals.
-- Plan and day IDs are unchanged; content updates preserve progress.
-- Part 2 of 13: plan_description, 3 rows.

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-21 12:00:00+00'
from jsonb_to_recordset($language_edits$
[
  {
    "id": "90000000-0000-0000-0000-000000000259",
    "value": "The public-domain text of Separation and Service; or, Thoughts on Numbers 6, 7. by James Hudson Taylor, preserved across 6 original sections with extracted Scripture references."
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "value": "The public-domain text of A Coal From The Altar, To Kindle The Holy Fire of Zeal by Samuel Ward, preserved across 1 original section with extracted Scripture references."
  },
  {
    "id": "90000000-0000-0000-0000-000000000382",
    "value": "The public-domain text of The Scriptures able to make us wise for salvation : or the Bible a sufficient creed by F. H. Berrick, preserved across 1 original section with extracted Scripture references."
  }
]
$language_edits$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;
