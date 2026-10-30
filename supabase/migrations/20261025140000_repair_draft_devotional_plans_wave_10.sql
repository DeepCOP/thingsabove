-- Four nineteenth-century Christian tales reconstructed as thirteen daily devotions.
-- Story context is retained while moral simplification, child-safety risks, social
-- prejudice, speculation about the dead, and simplistic addiction framing are corrected.
-- Existing day IDs and day numbers are preserved.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-25 14:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Faith in Action: Thirteen Readings from Four Christian Tales"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-25 14:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Thirteen Scripture-led readings adapted from four public-domain Christian tales by Selina Bunbury: The Little Pavior, The Silver Knife, The Modern Dorcas, and The Tract Found by the Way-Side. Story summaries lead into reflection and prayer on practical care, truth, mercy, grief, repentance, encouragement, and patient change while identifying nineteenth-century assumptions and avoiding moral simplification, child-safety risks, social prejudice, speculation about the dead, and simplistic treatment of addiction or family harm."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-25 14:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Notice What Could Help",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Work Carefully and Safely",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Let Gratitude Become Blessing",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Refuse Hasty Suspicion",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Tell the Truth and Make Repair",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Use the Time You Have",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Faith Becomes Practical Care",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Grieve with Resurrection Hope",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Continue the Work of Love",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Let Scripture Interrupt Your Path",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Repentance Begins to Change Habits",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Encourage Change Without Control",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Trust God to Continue His Work",
    "day_number": 13
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-25 14:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> Proverbs 20:11; Philippians 2:4.</p><p><strong>Story and historical context:</strong> In Selina Bunbury's nineteenth-century tale The Little Pavior, Francis sees that his grandfather has slipped on a muddy path. The story presents a child whose careful attention leads him to imagine a practical repair.</p><p><strong>Devotional focus:</strong> Love pays attention. Age does not prevent a person from noticing danger, understanding another person's need, and offering a thoughtful response.</p><p><strong>Reflect:</strong> What repeated difficulty affects someone near you? Before acting, ask what would truly help and whether you need guidance, permission, or another person's skill.</p><p><strong>Prayer:</strong> God of wisdom, open my eyes to the needs around me. Give me compassion, good judgment, and readiness to help. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> Colossians 3:23-24; Proverbs 22:3.</p><p><strong>Story and historical context:</strong> Francis gathers sand and stones and builds a small raised pavement. The original story celebrates his independent effort; contemporary readers should also recognize that children need safe tasks, suitable tools, and adult supervision.</p><p><strong>Devotional focus:</strong> Faithful service joins diligence with wisdom. Good intentions do not remove the need to consider safety, learn from others, and complete work with care.</p><p><strong>Reflect:</strong> Is there a helpful task you have rushed or attempted without enough knowledge? Identify the next careful step and the person whose advice could make the work safer and better.</p><p><strong>Prayer:</strong> Lord, teach me to serve wholeheartedly and wisely. Protect those who work, and help me value care above praise or speed. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> 1 Thessalonians 5:11; Psalm 90:17.</p><p><strong>Story and historical context:</strong> Francis's grandfather discovers the repaired path and responds with gratitude and a prayer for the child's future. The tale ends by connecting practical love with encouragement and blessing.</p><p><strong>Devotional focus:</strong> When another person serves faithfully, gratitude can strengthen that person rather than merely reward an achievement. We recognize the good, thank God, and speak words that encourage continued growth.</p><p><strong>Reflect:</strong> Whose quiet effort has made your path easier? Thank the person specifically and ask God to establish the good work of their hands.</p><p><strong>Prayer:</strong> Gracious God, thank you for people whose care makes life safer and kinder. Teach me to notice their work and encourage them well. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> James 1:19; 1 Corinthians 13:7.</p><p><strong>Story and historical context:</strong> In The Silver Knife, a household searches for Mary's missing knife. Several characters quickly suspect a poor child, a servant, or even a bird before they have reliable evidence.</p><p><strong>Devotional focus:</strong> Love does not turn uncertainty into accusation. Christians listen carefully, resist prejudice, and seek truth without treating social status or a troubled expression as proof of guilt.</p><p><strong>Reflect:</strong> When have you filled a gap in your knowledge with a negative story about someone? Separate what you know from what you assume, and seek the truth with patience.</p><p><strong>Prayer:</strong> God of truth, slow my anger and guard my speech. Free me from prejudice and teach me to listen before I judge. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> Ephesians 4:25; Galatians 6:1.</p><p><strong>Story and historical context:</strong> The knife is found in a cheese, exposing a servant's false explanation and misuse of household food. Bunbury's tale ends with confession, correction, mercy, and the family's refusal to shame her through gossip.</p><p><strong>Devotional focus:</strong> Truth and mercy belong together. Wrongdoing should be named and repaired, while restoration should be gentle, accountable, and protected from humiliating spectacle.</p><p><strong>Reflect:</strong> Do you need to correct a false statement, return something, or repair trust? Take responsibility plainly, and if another person confesses, respond without cruelty or gossip.</p><p><strong>Prayer:</strong> Merciful God, give me courage to tell the truth and repair harm. Make me gentle and wise when another person needs restoration. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> John 9:4; Ephesians 5:15-16.</p><p><strong>Story and historical context:</strong> The Modern Dorcas is written as a young woman's letter after the death of her sixteen-year-old friend Amelia. The story uses an early death to urge readers toward immediate service, a common pattern in nineteenth-century religious literature.</p><p><strong>Devotional focus:</strong> Life's uncertainty invites faithful attention to today. We need not live in fear or prove our worth through constant activity; grace frees us to do the good God places within reach.</p><p><strong>Reflect:</strong> What loving action have you postponed for a more convenient season? Choose one realistic act you can complete today without neglecting rest or responsibility.</p><p><strong>Prayer:</strong> Eternal God, teach me to receive today as your gift. Lead me into the good work prepared for me, with freedom from fear and striving. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> Acts 9:36-39; James 2:15-17.</p><p><strong>Story and historical context:</strong> Neighbors remember Amelia teaching, sewing clothes, visiting sick people, and helping families find work. The tale compares her with Tabitha, also called Dorcas, whose loving deeds were remembered by her community.</p><p><strong>Devotional focus:</strong> Living faith addresses bodies, minds, relationships, and spiritual needs. Practical care may involve making, teaching, visiting, connecting, advocating, or sharing resources.</p><p><strong>Reflect:</strong> Which gift or ordinary skill could become care for someone else? Ask what is needed and offer that gift in a way that respects the person's choices and dignity.</p><p><strong>Prayer:</strong> Lord Jesus, make my faith active in love. Use my hands, knowledge, time, and relationships to serve people with dignity. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> John 11:33-36; 1 Thessalonians 4:13-14.</p><p><strong>Story and historical context:</strong> Amelia's neighbors speak at her grave about the help they received from her. The narrator expresses confidence about Amelia's final state in language typical of a memorial tale; this reading leaves final judgment with God.</p><p><strong>Devotional focus:</strong> Christian hope makes room for tears. We remember visible fruits with gratitude while entrusting the person who died to the just and merciful God revealed in the death and resurrection of Jesus.</p><p><strong>Reflect:</strong> Is there someone you need to remember with both honesty and gratitude? Name the loss, give thanks for specific good, and bring what you cannot know into God's care.</p><p><strong>Prayer:</strong> Risen Lord Jesus, comfort those who mourn. Receive our gratitude and questions, and anchor our hope in your resurrection. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> Hebrews 10:24; 2 Timothy 2:2.</p><p><strong>Story and historical context:</strong> After hearing how Amelia served, Anna and her brother record the names of people she had visited and begin helping them. Her example becomes an invitation to sustained community care rather than admiration alone.</p><p><strong>Devotional focus:</strong> A faithful example bears fruit when others learn, share responsibility, and continue good work. Christian service should grow through communities instead of depending on one admired person.</p><p><strong>Reflect:</strong> What valuable work is too dependent on one person? Consider how you can learn the task, support the worker, or help build a team that can continue serving faithfully.</p><p><strong>Prayer:</strong> God of steadfast love, turn admiration into participation. Help us share knowledge, responsibility, and encouragement as we serve together. Amen.</p>",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> Psalm 119:105; Hebrews 4:12.</p><p><strong>Story and historical context:</strong> In The Tract Found by the Way-Side, Mark finds a small religious pamphlet while planning to disobey his father. He begins reading out of boredom, but the story inside challenges the direction of his life.</p><p><strong>Devotional focus:</strong> God can use Scripture to interrupt settled habits and expose a better path. The power belongs to God's living word, not to a particular format or method of distribution.</p><p><strong>Reflect:</strong> When did a biblical truth last interrupt your plans or assumptions? Return to that passage and identify the response it asks of you now.</p><p><strong>Prayer:</strong> Speaking God, shine your light on my path. Give me humility to hear your word and courage to change direction. Amen.</p>",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> Acts 3:19; Titus 2:11-12.</p><p><strong>Story and historical context:</strong> Mark reconsiders his ridicule of faith, chooses not to attend a harmful gathering, works willingly, and speaks more kindly at home. The tale portrays change beginning through small, observable choices.</p><p><strong>Devotional focus:</strong> Repentance is more than feeling ashamed. God's grace turns us toward him and trains us to replace destructive habits with truthful, loving, and responsible action.</p><p><strong>Reflect:</strong> What small choice would show that your repentance is becoming practice? Make the action specific enough to complete and invite a trustworthy person to encourage you.</p><p><strong>Prayer:</strong> God of grace, turn me from sin and train me in a new way of life. Let changed habits bear witness to your patient work. Amen.</p>",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> 1 Thessalonians 5:11; 2 Timothy 2:24-25.</p><p><strong>Story and historical context:</strong> Mark's sister Josephine listens, answers his questions, and encourages his desire to change. Other family members begin examining their own conduct instead of treating Mark as the only problem.</p><p><strong>Devotional focus:</strong> Lasting change cannot be forced through ridicule or control. We speak truth gently, encourage the next faithful step, and remain willing to repent of the patterns we contribute to a family or community.</p><p><strong>Reflect:</strong> Are you trying to change someone through pressure, or supporting the person's own responsible choices? Adjust your words so they combine truth, patience, and respect.</p><p><strong>Prayer:</strong> Patient Lord, make my words truthful and gentle. Help me encourage growth without controlling others, and show me where I also need to change. Amen.</p>",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> Philippians 1:6; 2 Corinthians 5:17.</p><p><strong>Story and historical context:</strong> The tale ends as Mark's changing conduct influences the household and his father begins turning away from alcohol. Its rapid resolution reflects the moral-story form and should not imply that addiction or family harm always changes quickly.</p><p><strong>Devotional focus:</strong> New life in Christ may begin in a moment and usually grows through patient truth, support, accountability, and repeated choices. God remains faithful throughout the longer work of restoration.</p><p><strong>Reflect:</strong> Where do you need hope for a change that is still incomplete? Name the next faithful step and seek appropriate pastoral, medical, or community support where it is needed.</p><p><strong>Prayer:</strong> Faithful God, thank you for beginning new life in us. Sustain the long work of healing, guide us to wise support, and complete what reflects Christ. Amen.</p>",
    "day_number": 13
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
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 1,
    "references": [
      "Proverbs 20:11",
      "Philippians 2:4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 2,
    "references": [
      "Colossians 3:23-24",
      "Proverbs 22:3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 3,
    "references": [
      "1 Thessalonians 5:11",
      "Psalm 90:17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 4,
    "references": [
      "James 1:19",
      "1 Corinthians 13:7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 5,
    "references": [
      "Ephesians 4:25",
      "Galatians 6:1"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 6,
    "references": [
      "John 9:4",
      "Ephesians 5:15-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 7,
    "references": [
      "Acts 9:36-39",
      "James 2:15-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 8,
    "references": [
      "John 11:33-36",
      "1 Thessalonians 4:13-14"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 9,
    "references": [
      "Hebrews 10:24",
      "2 Timothy 2:2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 10,
    "references": [
      "Psalm 119:105",
      "Hebrews 4:12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 11,
    "references": [
      "Acts 3:19",
      "Titus 2:11-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 12,
    "references": [
      "1 Thessalonians 5:11",
      "2 Timothy 2:24-25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 13,
    "references": [
      "Philippians 1:6",
      "2 Corinthians 5:17"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-25 14:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-25 14:00:00+00', timestamptz '2026-10-25 14:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish the contextualized four-Christian-tales adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-25 14:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000331'::uuid
);
