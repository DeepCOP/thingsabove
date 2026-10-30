-- One 1814 pastoral tract reconstructed as two Scripture-led daily devotions.
-- Daily prayer and access to Scripture are retained; a Pentecost error, sectarian
-- polemic, denominational gatekeeping, and wartime nationalism are omitted.
-- Existing day IDs and day numbers are preserved.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-25 15:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "value": "Prayer and Shared Scripture: Two Readings from an 1814 Pastoral Tract"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-25 15:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "value": "Two Scripture-led readings adapted from Joseph Phillimore's 1814 Anglican pastoral tract. The readings retain its encouragement of daily prayer and access to Scripture while identifying the parish setting and omitting its confusion between Jesus' baptism and Pentecost, anti-dissenter polemic, denominational gatekeeping, and wartime nationalism."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-25 15:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "value": "Begin and End the Day with God",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "value": "Share Scripture Without Favoritism",
    "day_number": 2
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-25 15:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "value": "<p><strong>Read:</strong> Matthew 6:9-13; Philippians 4:6-7.</p><p><strong>Historical context:</strong> Joseph Phillimore addressed two English parishes in an 1814 pastoral tract. He urged households to pray morning and evening, although the complete tract also contains a factual confusion between Jesus' baptism and Pentecost and several claims this adaptation does not repeat.</p><p><strong>Source theme, in contemporary language:</strong> Regular prayer makes room to worship the Father, receive daily provision with gratitude, seek forgiveness, resist temptation, and bring both prosperity and adversity into God's presence through Jesus Christ.</p><p><strong>Reflect:</strong> Which edge of your day most needs an intentional pause with God? Choose a realistic time and place, and let the Lord's Prayer guide both your trust and your responsibilities.</p><p><strong>Prayer:</strong> Our Father, give us daily bread, forgive our sins, and lead us away from temptation. Guard our hearts and minds in Christ Jesus throughout this day. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "value": "<p><strong>Read:</strong> James 2:1-5; 2 Timothy 3:14-17.</p><p><strong>Historical context:</strong> Phillimore asked wealthier parishioners to help place Christian books in homes that could not afford them. His proposal assumed Anglican worship, disparaged dissenting Christians, and appealed to British wartime victory; those sectarian and national claims are omitted here.</p><p><strong>Source theme, in contemporary language:</strong> Money and social position should not block a person from learning Scripture or participating in Christian community. Sharing Bibles, teaching, accessible formats, and patient companionship can help neighbors hear and practice God's word.</p><p><strong>Reflect:</strong> What barrier makes Scripture or Christian learning harder for someone near you—cost, language, literacy, disability, technology, or lack of welcome? Ask what would help and support access without controlling the person's conscience.</p><p><strong>Prayer:</strong> Lord Jesus, remove favoritism from your people. Help us share Scripture generously, teach with humility, welcome every neighbor, and honor the conscience of others. Amen.</p>",
    "day_number": 2
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "day_number": 2,
    "references": [
      "James 2:1-5",
      "2 Timothy 3:14-17"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-25 15:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-25 15:00:00+00', timestamptz '2026-10-25 15:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish the contextualized 1814 pastoral-tract adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-25 15:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000218'::uuid
);
