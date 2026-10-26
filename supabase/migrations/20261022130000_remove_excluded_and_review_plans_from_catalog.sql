-- Remove plans marked Exclude or Review doctrine by the devotional audit
-- from the published catalog. Keep their records and user progress intact.
update public.devotional_plans
set status = 'draft', updated_at = timestamptz '2026-10-22 13:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000241'::uuid, -- The Ministry of the Spirit (Review doctrine)
  '90000000-0000-0000-0000-000000000314'::uuid, -- The Double Search (Review doctrine)
  '90000000-0000-0000-0000-000000000353'::uuid, -- Food and Morals (Exclude)
  '90000000-0000-0000-0000-000000000356'::uuid, -- Life of David W. Patten (Exclude)
  '90000000-0000-0000-0000-000000000360'::uuid, -- Fugitive Slave Law (Exclude)
  '90000000-0000-0000-0000-000000000361'::uuid, -- Rays of Living Light (Exclude)
  '90000000-0000-0000-0000-000000000363'::uuid, -- The Kingdom of God, Part 1 (Exclude)
  '90000000-0000-0000-0000-000000000372'::uuid, -- Salvation Universal (Exclude)
  '90000000-0000-0000-0000-000000000382'::uuid, -- The Scriptures able to make us wise unto salvation (Exclude)
  '90000000-0000-0000-0000-000000000385'::uuid, -- Welsh Nationality (Exclude)
  '90000000-0000-0000-0000-000000000389'::uuid  -- A Sermon preached at Christ Church, Kensington (Exclude)
);
