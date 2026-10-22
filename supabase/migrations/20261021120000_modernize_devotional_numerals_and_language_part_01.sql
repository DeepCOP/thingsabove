-- Convert Scripture/section Roman numerals to Arabic digits and modernize
-- verified archaic wording in the published public-domain plans.
-- Historical personal names keep their conventional Roman ordinals.
-- Plan and day IDs are unchanged; content updates preserve progress.
-- Part 1 of 13: plan_title, 5 rows.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-21 12:00:00+00'
from jsonb_to_recordset($language_edits$
[
  {
    "id": "90000000-0000-0000-0000-000000000259",
    "value": "Separation and Service; or, Thoughts on Numbers 6, 7."
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "value": "A Coal From The Altar, To Kindle The Holy Fire of Zeal"
  },
  {
    "id": "90000000-0000-0000-0000-000000000382",
    "value": "The Scriptures able to make us wise for salvation : or the Bible a sufficient creed"
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "value": "A sermon preached before the Right Honourable the Lord-Mayor : the aldermen and citizens of London"
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "A Funeral Sermon Preached on the Decease of the Right Honourable the Lady Elizabeth Cutts"
  }
]
$language_edits$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;
