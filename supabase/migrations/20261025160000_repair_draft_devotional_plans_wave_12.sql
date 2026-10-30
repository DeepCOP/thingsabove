-- One 1872 children's story reconstructed as eight Scripture-led daily devotions.
-- Disability and class prejudice, romanticized hardship, illness blame, coerced
-- forgiveness, and a dream treated as authority are rejected or corrected.
-- Existing day IDs and day numbers are preserved.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-25 16:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "Compassion, Repair, and Hope: Eight Readings from The One Moss-Rose"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-25 16:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "Eight Scripture-led readings adapted from Philip Bennett Power's 1872 Christian children's story The One Moss-Rose. The sequence retains themes of dignity, contentment, respect, forgiveness, repentance, restitution, and resurrection hope while rejecting outdated disability and class language, romanticized hardship, blame surrounding illness, pressure to forgive without accountability, and the use of a fever dream as doctrinal authority."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-25 16:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "Every Person Bears God's Image",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "Contentment Without Denying Hardship",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "Honor What Another Person Values",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "Name Harm Without Inventing Blame",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "Forgiveness and Accountability Belong Together",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "Let Guilt Lead to Repentance",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "Make Repair Practical",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "Anchor Hope in the Risen Christ",
    "day_number": 8
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-25 16:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "<p><strong>Read:</strong> Genesis 1:27; 1 Corinthians 12:22-26.</p><p><strong>Story and historical context:</strong> Philip Bennett Power's 1872 children's story introduces Jacob Dobbin, a disabled boy in a laborer's family, and James Courtenay, the son of a wealthy landowner. The source uses outdated disability and class language that this adaptation does not repeat.</p><p><strong>Devotional focus:</strong> Human dignity does not depend on health, wealth, productivity, or social rank. Every person bears God's image, and Christ's body honors members whom society may overlook.</p><p><strong>Reflect:</strong> Which person or group is often described mainly by a limitation or social position? Practice speaking about the whole person, listening to their experience, and honoring their gifts.</p><p><strong>Prayer:</strong> Creator God, teach me to recognize your image in every person. Remove condescension and prejudice, and form in me sincere honor and care. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "<p><strong>Read:</strong> Philippians 4:11-13; Romans 12:15.</p><p><strong>Story and historical context:</strong> Jacob treasures a single moss-rose while James has many possessions and remains dissatisfied. The contrast supports the story's lesson about contentment, but poverty, pain, and disability should not be romanticized.</p><p><strong>Devotional focus:</strong> Contentment grows through Christ's strength and grateful attention to God's gifts. It can coexist with grief, advocacy, treatment, and honest efforts to change unjust or painful circumstances.</p><p><strong>Reflect:</strong> What gift can you receive gratefully today, and what hardship still needs truthful lament or practical support? Make room for both without comparing your suffering with someone else's.</p><p><strong>Prayer:</strong> Lord Jesus, teach me contentment rooted in you. Help me give thanks without minimizing pain and stand beside those who need comfort or change. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "<p><strong>Read:</strong> Philippians 2:3-4; Luke 6:31.</p><p><strong>Story and historical context:</strong> James enters the cottage garden and cuts Jacob's only rose despite being asked to stop. The flower is small in monetary value but carries deep meaning for the person who cared for it.</p><p><strong>Devotional focus:</strong> Love does not measure another person's treasure only by our own preferences. Respect listens to a clear boundary and considers the history, labor, memory, or joy attached to what belongs to someone else.</p><p><strong>Reflect:</strong> Have you dismissed something important to another person because it seemed trivial to you? Listen without defending yourself, acknowledge its meaning, and respect the boundary involved.</p><p><strong>Prayer:</strong> God of love, free me from selfish entitlement. Teach me to listen, honor boundaries, and care about what matters to my neighbor. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "<p><strong>Read:</strong> Psalm 34:18; James 3:5-10.</p><p><strong>Story and historical context:</strong> After the rose is taken, Jacob becomes gravely ill and later dies. The moral tale presents a direct dramatic link between the loss and his death; readers should not use that plot device to blame distressed or medically vulnerable people for what happens to their bodies.</p><p><strong>Devotional focus:</strong> Careless actions and words can cause real harm, and suffering people deserve compassion. We can take wrongdoing seriously while speaking responsibly about illness, trauma, and causes we do not fully know.</p><p><strong>Reflect:</strong> Where are you tempted either to minimize harm or to claim more certainty than the facts allow? Name what is known, seek appropriate help, and avoid placing blame on the person who suffered.</p><p><strong>Prayer:</strong> God who is near to the brokenhearted, make my words careful and compassionate. Help me face harm honestly and protect people from false blame. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "<p><strong>Read:</strong> Colossians 3:12-13; Luke 19:8.</p><p><strong>Story and historical context:</strong> Jacob releases resentment toward James, while the adults begin to reckon with what James has done. The story values forgiveness, but forgiveness does not erase consequences or require immediate restored trust.</p><p><strong>Devotional focus:</strong> Christ calls believers away from revenge and toward forgiveness. Repentance still names the wrong, accepts accountability, makes repair where possible, and gives the harmed person freedom to establish safe boundaries.</p><p><strong>Reflect:</strong> Do you need to release revenge, make restitution, or respect a boundary? Identify which responsibility belongs to you instead of demanding that another person resolve the whole situation.</p><p><strong>Prayer:</strong> Merciful Jesus, free me from revenge and lead me in truth. Give me courage to accept consequences, repair harm, and respect wise boundaries. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "<p><strong>Read:</strong> 2 Corinthians 7:10-11; 1 John 1:9.</p><p><strong>Story and historical context:</strong> James becomes physically ill under the weight of fear and guilt. A vivid dream about Jacob contributes to his change, reflecting the devotional storytelling of the period; this adaptation grounds repentance in God's revealed mercy rather than in dreams.</p><p><strong>Devotional focus:</strong> Condemnation traps us in ourselves, while godly sorrow turns toward confession, responsibility, and changed conduct. God is faithful to forgive and cleanse those who come into the light.</p><p><strong>Reflect:</strong> Is guilt leading you to hide, punish yourself, or seek real change? Confess specifically to God, tell the truth to an appropriate person, and choose the next act of repair.</p><p><strong>Prayer:</strong> Faithful God, bring my sin into your light. Forgive me through Christ, free me from self-punishment, and produce earnest repentance in my life. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "<p><strong>Read:</strong> Ephesians 4:28; James 2:14-17.</p><p><strong>Story and historical context:</strong> As James recovers, the story portrays his changed attitude through kindness toward Jacob's father and concern for people whose needs he had ignored. The social hierarchy remains intact in the source, so this reading emphasizes partnership rather than patronage.</p><p><strong>Devotional focus:</strong> Repentance bears practical fruit. Repair may require returning what was taken, replacing a loss, changing how power is used, listening to the harmed person, and supporting what restores dignity.</p><p><strong>Reflect:</strong> What would make your apology concrete? Ask what repair is wanted and possible, then follow through without using generosity to control the other person or purchase quick forgiveness.</p><p><strong>Prayer:</strong> God of justice and mercy, make my repentance visible in faithful action. Teach me to repair harm with humility and without control. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "<p><strong>Read:</strong> John 11:25-26; 1 Peter 1:3-4.</p><p><strong>Story and historical context:</strong> The story closes with images of unfading flowers and confidence about Jacob's life after death. Its dream scene is literary imagination, not a source of Christian doctrine or certainty about an individual's final state.</p><p><strong>Devotional focus:</strong> Christian hope rests on Jesus Christ, crucified and risen, who promises resurrection life. We may remember a person with love while entrusting final judgment to God's justice and mercy.</p><p><strong>Reflect:</strong> What image or memory helps you express hope? Receive its comfort, then return to the gospel foundation: Jesus has risen, and our living hope is held in him.</p><p><strong>Prayer:</strong> Risen Lord Jesus, anchor my hope in your victory over death. Comfort those who grieve and keep our trust in your faithful promise. Amen.</p>",
    "day_number": 8
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
    "id": "90000000-0000-0000-0000-000000000305",
    "day_number": 1,
    "references": [
      "Genesis 1:27",
      "1 Corinthians 12:22-26"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "day_number": 2,
    "references": [
      "Philippians 4:11-13",
      "Romans 12:15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "day_number": 3,
    "references": [
      "Philippians 2:3-4",
      "Luke 6:31"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "day_number": 4,
    "references": [
      "Psalm 34:18",
      "James 3:5-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "day_number": 5,
    "references": [
      "Colossians 3:12-13",
      "Luke 19:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "day_number": 6,
    "references": [
      "2 Corinthians 7:10-11",
      "1 John 1:9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "day_number": 7,
    "references": [
      "Ephesians 4:28",
      "James 2:14-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "day_number": 8,
    "references": [
      "John 11:25-26",
      "1 Peter 1:3-4"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-25 16:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-25 16:00:00+00', timestamptz '2026-10-25 16:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish the contextualized Moss-Rose story adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-25 16:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000305'::uuid
);
