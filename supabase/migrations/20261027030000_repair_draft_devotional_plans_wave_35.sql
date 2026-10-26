-- Wave 35: Plan 379 — James Patrick, Evangelists of Art: Picture-Sermons for Children.
-- One set of historical picture-sermons mechanically divided into 11 imported segments.
-- All 11 readings are newly authored and map to their respective source segments.
-- This migration does not reproduce or license any referenced artworks.
-- Preserve IDs, plan progress, user-owned Scripture rows, tags, cover, source URL, and day count.
-- Apply AFTER October 21 modernization migrations, especially part 13 (9 overlapping rows).
-- DRAFT ONLY; editorial, theological, and artwork/rights review required before publication.

begin;

do $$
declare
  current_source text;
  current_total integer;
  day_count integer;
  first_day integer;
  last_day integer;
  unique_days integer;
  duplicate_reference_days integer;
begin
  select source_url, total_days into current_source, current_total
  from public.devotional_plans where id = '90000000-0000-0000-0000-000000000379'::uuid;
  if not found then raise exception 'Plan 379 missing'; end if;
  if current_source is distinct from 'https://www.gutenberg.org/ebooks/30220' or current_total is distinct from 11 then
    raise exception 'Plan 379 source URL or day count does not match Wave 35 preflight';
  end if;
  select count(*), min(day_number), max(day_number), count(distinct day_number)
  into day_count, first_day, last_day, unique_days
  from public.devotional_days where plan_id = '90000000-0000-0000-0000-000000000379'::uuid;
  if day_count <> 11 or first_day <> 1 or last_day <> 11 or unique_days <> 11 then
    raise exception 'Plan 379 must have 11 uniquely numbered days, found %', day_count;
  end if;
  select count(*) into duplicate_reference_days from (
    select sr.day_id
    from public.scripture_references sr
    join public.devotional_days d on d.id = sr.day_id
    where d.plan_id = '90000000-0000-0000-0000-000000000379'::uuid and sr.user_id is null
    group by sr.day_id having count(*) > 1
  ) duplicates_per_day;
  if duplicate_reference_days > 0 then
    raise exception 'Plan 379 has % days with duplicate plan-level Scripture rows', duplicate_reference_days;
  end if;
end
$$;

update public.devotional_plans as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "value": "Seeing Faith Through Art: Eleven Scripture-Led Readings for Families"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "value": "Eleven Scripture-led devotional reflections inspired by James Patrick’s Evangelists of Art: Picture-Sermons for Children, a historical collection of Christian art sermons. Move from Holman Hunt’s image of Jesus in the Temple and Paton’s depiction of Luther reading Scripture through classical stories about death, portraits of Scottish Reformation history, a visionary horseman, and Bunyan’s man with the muck-rake. Each reading offers Bible passages, context about the original artwork or story, a devotional reflection, a question, a practical response, and prayer. Artwork descriptions are historical literary material; images are not included or licensed by this adaptation."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 1,
    "value": "Jesus, Listening in the Temple"
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 2,
    "value": "Seeking Wisdom While Honoring Family"
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 3,
    "value": "A Bible Open to the Morning Light"
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 4,
    "value": "Love That Faces Death"
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 5,
    "value": "Hope Without Denying Grief"
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 6,
    "value": "Peace and Courage Under Pressure"
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 7,
    "value": "A Shared Table Before Suffering"
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 8,
    "value": "Faithfulness Without Glorifying Violence"
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 9,
    "value": "The Cost Behind the Glory of Conquest"
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 10,
    "value": "The Rake and the Offered Crown"
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 11,
    "value": "Choose the Life That Gives"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 1,
    "value": "<p><strong>Read:</strong> Luke 2:41-50; Proverbs 2:1-6</p><p><strong>Source and historical context:</strong> James Patrick begins with William Holman Hunt’s painting of the twelve-year-old Jesus among teachers in the Jerusalem Temple. He describes a crowded, richly detailed scene: rabbis with scrolls, musicians, Joseph and Mary, and a boy intent on what he is hearing. The painted details are an artist’s reconstruction, not eyewitness evidence about the Temple.</p><p><strong>Devotional focus:</strong> Luke shows Jesus both listening and asking questions. Wisdom begins not with knowing everything but with giving serious attention to God’s word and to people who can teach us. Even when our questions are large, we can approach them without boasting or treating those who think differently as enemies. The painting’s many figures invite us to see learning as an encounter among generations.</p><p><strong>Reflect:</strong> What question about God or faith am I willing to ask with genuine curiosity rather than a desire to win?</p><p><strong>Practice:</strong> Read Luke 2 slowly with a family member or friend. Ask each other one question and listen fully before offering an answer.</p><p><strong>Prayer:</strong> Father, awaken curiosity in us. Help us listen humbly, ask honestly, and love the truth. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 2,
    "value": "<p><strong>Read:</strong> Luke 2:46-52; Ephesians 6:1-4</p><p><strong>Source and historical context:</strong> The source draws two lessons from Hunt’s Temple painting: Jesus’ love of heavenly wisdom and his return with Mary and Joseph to Nazareth. The imported segment then opens a different picture-sermon, Sir Noël Paton’s Dawn, portraying Martin Luther with a Bible at the Erfurt monastery. These are separate works joined by the importer’s page break.</p><p><strong>Devotional focus:</strong> Luke does not portray faithfulness as indifference to family. Jesus’ questions in the Temple belong beside the care and shared life of Nazareth. Honoring parents and caregivers, however, is not the same as accepting harmful demands; Ephesians also charges parents not to provoke their children. The opening glimpse of Luther reminds us that a thirst for Scripture can shape a life at any age.</p><p><strong>Reflect:</strong> How could I show respect for someone who cares for me while still speaking truthfully about what I believe?</p><p><strong>Practice:</strong> Tell a parent, caregiver, or trusted mentor something you value about their guidance. If a relationship is unsafe, seek help from a trustworthy person instead.</p><p><strong>Prayer:</strong> Jesus, teach our homes patience, mutual care, and a love of wisdom that grows together. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 3,
    "value": "<p><strong>Read:</strong> Psalm 119:97-105; Romans 3:21-26</p><p><strong>Source and historical context:</strong> Sir Noël Paton’s Dawn shows Luther bending over an open Bible as morning light enters the room. Patrick sees an image of gospel hope replacing anxious attempts to earn forgiveness. Later in this same source segment, he introduces Lord Leighton’s painting of Hercules wrestling Death for Alcestis: a Greek tale about costly love and hoped-for deliverance.</p><p><strong>Devotional focus:</strong> Scripture is more than an object to display; it is a place to attend to God’s mercy and learn how to walk. Luther’s struggle, as narrated by Patrick, warns against using harsh self-punishment as a path to grace. Romans points us toward God’s gift in Christ instead. The Greek story at the segment’s end prepares another question: what kind of love can face death without surrendering hope?</p><p><strong>Reflect:</strong> When does my desire to be spiritually good slip into trying to punish myself or prove that I deserve love?</p><p><strong>Practice:</strong> Read a short passage from Romans with care. Write down one sentence about grace that invites gratitude rather than fear.</p><p><strong>Prayer:</strong> God of mercy, open your word to us and free us from the burden of trying to purchase your love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 4,
    "value": "<p><strong>Read:</strong> Hebrews 2:14-15; John 15:12-13</p><p><strong>Source and historical context:</strong> Patrick describes Lord Leighton’s painting of Hercules wrestling Death beside the body of Alcestis. In the ancient Greek story, Alcestis gives her life for her husband and Hercules struggles to restore her. The author expressly treats this as myth and uses its longings as a comparison with Christ. The segment closes by introducing G. F. Watts’s painting of Orpheus and Eurydice, another story of love and loss.</p><p><strong>Devotional focus:</strong> The Greek myth expresses a human desire: that costly love could overcome the finality of death. Hebrews tells a distinct Christian story—Jesus shares human vulnerability and faces death to free people from its tyranny. We need not pretend the myth is a Bible event or that every earthly bereavement ends with a miracle. The cross and resurrection give Christians grounds to hope while still taking grief seriously.</p><p><strong>Reflect:</strong> How have stories, music, or art helped me name a longing that ordinary explanations cannot resolve?</p><p><strong>Practice:</strong> Reach out to someone who is grieving with a simple offer of presence. Do not rush them toward cheerful conclusions.</p><p><strong>Prayer:</strong> Lord Jesus, remain near to those who mourn and teach us love that is brave, gentle, and faithful. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 5,
    "value": "<p><strong>Read:</strong> John 11:21-27; 1 Thessalonians 4:13-14</p><p><strong>Source and historical context:</strong> In Watts’s Orpheus and Eurydice, the musician turns toward his wife too soon and loses her again to the underworld. Patrick contrasts that sorrowful myth with the Gospel’s accounts of Jesus and death. Near the end of this imported segment, a new sermon begins with E. M. Ward’s painting The Last Sleep of Argyll, a scene from seventeenth-century Scotland.</p><p><strong>Devotional focus:</strong> At Lazarus’s grave, Jesus does not rebuke Mary and Martha for grieving; he meets them in their loss. Christian hope is not a command to stop crying or a denial that death wounds human relationships. Paul likewise speaks of grief joined to hope, not grief erased. The transition to Argyll asks another question: what might it mean to face uncertainty with peace without dismissing the reality of suffering?</p><p><strong>Reflect:</strong> What would it look like for me to let lament and hope share the same prayer?</p><p><strong>Practice:</strong> Read John 11 and notice who speaks, who weeps, and who listens. Offer a patient conversation to someone living with loss.</p><p><strong>Prayer:</strong> God of life, receive our sorrow and hold us in the hope of Christ even when we have few words. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 6,
    "value": "<p><strong>Read:</strong> Isaiah 26:3-4; Philippians 4:6-9</p><p><strong>Source and historical context:</strong> Patrick recounts the ninth Earl of Argyll’s imprisonment and execution in 1685, then describes E. M. Ward’s painting of the earl sleeping peacefully in his cell. The author contrasts the prisoner’s composure with an unsettled official who sees him. The next picture-sermon introduces George Wishart sharing Communion before his execution. These historical accounts are presented through Patrick’s Protestant perspective.</p><p><strong>Devotional focus:</strong> Isaiah speaks of a mind held in trust, while Philippians calls believers to bring their fears to God and act with gentleness. Peace is not proof that a person has no anxiety, nor does calmness settle every historical or political controversy. But trust can make space for courage and care even when we cannot control events. The picture invites us to ask how faith can steady our conduct toward others.</p><p><strong>Reflect:</strong> When pressure rises, what usually happens to my attention, words, and treatment of people around me?</p><p><strong>Practice:</strong> Pause for a minute of slow, attentive prayer before responding to one stressful situation. Then take the next responsible action.</p><p><strong>Prayer:</strong> God of peace, steady us in difficult hours and make our courage compassionate. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 7,
    "value": "<p><strong>Read:</strong> Luke 22:14-20; 1 Corinthians 11:23-26</p><p><strong>Source and historical context:</strong> William Quiller Orchardson’s picture shows George Wishart sharing a final Communion with a small gathering in St Andrews Castle in 1546. Patrick narrates the setting, Wishart’s preaching and imprisonment, a discussion with John Winram, and the simple meal that preceded his death. The picture-sermon interprets these events through a Scottish Reformation lens; its precise historical details warrant verification.</p><p><strong>Devotional focus:</strong> Jesus shares bread and the cup with disciples who will soon face fear and separation. Paul remembers that this meal proclaims the Lord’s death until he comes. Churches understand the sacrament and who may administer it in different ways, but the Gospel focus is clear: Christ gathers people into remembrance, gratitude, and love. Small gatherings and ordinary tables can become places of deep attentiveness and mutual care.</p><p><strong>Reflect:</strong> How can the way I participate in worship make someone else feel welcomed rather than overlooked?</p><p><strong>Practice:</strong> If you take Communion, prepare with gratitude and reconciliation according to your church’s practice. Otherwise, share an ordinary meal with deliberate hospitality.</p><p><strong>Prayer:</strong> Jesus, make us thankful for your self-giving love and attentive to the people who gather with us. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 8,
    "value": "<p><strong>Read:</strong> Matthew 5:9-12; Revelation 6:1-4</p><p><strong>Source and historical context:</strong> This segment continues Patrick’s account of George Wishart’s execution and the lessons he draws from the painted Communion scene. He then introduces Watts’s The Rider on the White Horse, based on Revelation 6, and describes the horse and rider. The first narrative remembers religious violence; the second presents symbolic imagery open to competing interpretations.</p><p><strong>Devotional focus:</strong> Jesus blesses peacemakers and those who suffer for righteousness, but he does not bless cruelty. Stories of martyrs should move us to protect freedom of conscience rather than romanticize torture or treat violence as a proof of truth. Revelation’s striking horsemen remind us to read troubling visions carefully, without pretending every artistic representation yields one uncontested interpretation.</p><p><strong>Reflect:</strong> Whose dignity or freedom of conscience needs defending, especially when their beliefs differ from mine?</p><p><strong>Practice:</strong> Learn about one person or community facing religious pressure today; respond with a peaceful, practical act of solidarity.</p><p><strong>Prayer:</strong> Prince of Peace, keep us faithful without hatred and courageous without delight in another’s pain. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 9,
    "value": "<p><strong>Read:</strong> Revelation 6:1-8; Zechariah 9:9-10</p><p><strong>Source and historical context:</strong> Patrick continues describing Watts’s formidable white horse and rider, placing the figure among Revelation’s four riders and reading the image as worldly conquest with suffering in its wake. He contrasts that spectacle with Zechariah’s humble king, whose rule is associated with peace rather than domination. The source then introduces Bunyan’s man with the muck-rake and Noël Paton’s illustration.</p><p><strong>Devotional focus:</strong> An impressive leader can look victorious while leaving frightened and wounded people behind. Zechariah offers a different image of kingship: humility and the ending of war. Christians have disagreed about the identity of Revelation’s first horseman, so Patrick’s reading should be named as interpretation, not as an undisputed fact. The clear ethical question is whether our idea of strength resembles coercion or peace.</p><p><strong>Reflect:</strong> When am I dazzled by power without asking who pays its price?</p><p><strong>Practice:</strong> Read the two passages side by side. Name one place where you can choose de-escalation, fairness, or peacemaking.</p><p><strong>Prayer:</strong> Jesus, shape our understanding of victory by your humility and concern for the vulnerable. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 10,
    "value": "<p><strong>Read:</strong> Colossians 3:1-5; Matthew 6:19-24</p><p><strong>Source and historical context:</strong> Sir Noël Paton’s painting The Man with the Muck-Rake draws on a scene from John Bunyan’s Pilgrim’s Progress. Patrick describes a bent figure intent on gathering scraps while Christ offers him a radiant crown. He reads the image as a warning against making earthly gain the sole purpose of life. The original painting also uses striking figures and symbols to portray greed and missed opportunity.</p><p><strong>Devotional focus:</strong> Jesus does not call money, ordinary work, or material needs evil; he warns that treasures can become masters. Colossians asks us to set our attention on what grows from life with Christ. The problem is not that the rake touches the ground, but that its owner no longer looks up. We can labor responsibly and still hold possessions loosely enough to notice people, generosity, beauty, and God.</p><p><strong>Reflect:</strong> What has absorbed my attention so completely that I have missed someone or something truly valuable?</p><p><strong>Practice:</strong> Give away something useful or time you would normally spend pursuing status or possessions. Notice whom it blesses.</p><p><strong>Prayer:</strong> Lord, give us freedom from grasping and eyes open to the gifts that do not decay. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 11,
    "value": "<p><strong>Read:</strong> Acts 20:32-35; Philippians 2:3-11</p><p><strong>Source and historical context:</strong> Patrick completes his meditation on Bunyan’s muck-rake and Paton’s painting. He warns that chasing possessions and honor can become a prison; then he contrasts that pattern with Christ’s invitation to a life of giving, sacrifice, and lasting hope. His description moves from the image’s damaged earthly crown to the offered crown and a renewed vision of Christlike living.</p><p><strong>Devotional focus:</strong> Paul remembers Jesus’ teaching that giving is blessed; Philippians portrays Christ’s humility as the pattern for a community’s life. This does not demand neglecting one’s health or basic needs, and service should never become a tool for exploitation. It means choosing love over the endless need to acquire, impress, and control. A generous life can begin with a modest decision to notice and meet a real need.</p><p><strong>Reflect:</strong> Which habit of grasping could I loosen so that my life has more room for love?</p><p><strong>Practice:</strong> Choose one concrete gift today—time, attention, encouragement, or resources—without expecting repayment or praise.</p><p><strong>Prayer:</strong> Jesus, turn our eyes from restless wanting toward love that gives freely and wisely. Amen.</p>"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

-- Update the plan-level Scripture row per day, leaving user-owned references untouched.
do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 1,
    "references": [
      "Luke 2:41-50",
      "Proverbs 2:1-6"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 2,
    "references": [
      "Luke 2:46-52",
      "Ephesians 6:1-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 3,
    "references": [
      "Psalm 119:97-105",
      "Romans 3:21-26"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 4,
    "references": [
      "Hebrews 2:14-15",
      "John 15:12-13"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 5,
    "references": [
      "John 11:21-27",
      "1 Thessalonians 4:13-14"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 6,
    "references": [
      "Isaiah 26:3-4",
      "Philippians 4:6-9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 7,
    "references": [
      "Luke 22:14-20",
      "1 Corinthians 11:23-26"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 8,
    "references": [
      "Matthew 5:9-12",
      "Revelation 6:1-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 9,
    "references": [
      "Revelation 6:1-8",
      "Zechariah 9:9-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 10,
    "references": [
      "Colossians 3:1-5",
      "Matthew 6:19-24"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000379",
    "day_number": 11,
    "references": [
      "Acts 20:32-35",
      "Philippians 2:3-11"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id
    from public.devotional_days
    where plan_id = (item ->> 'id')::uuid
      and day_number = (item ->> 'day_number')::integer;

    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = now()
    where day_id = target_day_id and user_id is null;

    if not found then
      insert into public.scripture_references
        (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id,
        array(select jsonb_array_elements_text(item -> 'references')), now(), now());
    end if;
  end loop;
end
$$;

update public.devotional_plans
set status = 'published', updated_at = now()
where id = '90000000-0000-0000-0000-000000000379'::uuid;

commit;
