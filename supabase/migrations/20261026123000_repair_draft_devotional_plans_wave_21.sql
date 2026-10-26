-- Wave 21: Plan 285 — Jonathan Swift, Three Prayers and Sermons.
-- Twelve source-grounded editorial devotional readings, not verbatim or certified translations.
-- Historic illness, hierarchy, rhetorical mockery, and descriptions of non-Christian philosophy are contextualized.
-- Updates existing plan and day records in place; preserve day IDs and user progress.
-- Draft pending review for theology, historical claims, and distribution rights.

begin;

-- Guard the target plan and all 12 inherited day slots before changing any content.
do $$
declare
  present_days integer;
  first_day integer;
  last_day integer;
  distinct_days integer;
  source_link text;
  reported_total integer;
begin
  select source_url, total_days into source_link, reported_total
  from public.devotional_plans
  where id = '90000000-0000-0000-0000-000000000285'::uuid;
  if not found then raise exception 'Plan 285 is missing'; end if;
  if source_link is distinct from 'https://www.gutenberg.org/ebooks/4738'
     or reported_total is distinct from 12 then
    raise exception 'Plan 285 source URL or total_days differs from reviewed source';
  end if;
  select count(*), min(day_number), max(day_number), count(distinct day_number)
  into present_days, first_day, last_day, distinct_days
  from public.devotional_days
  where plan_id = '90000000-0000-0000-0000-000000000285'::uuid;
  if present_days <> 12 or first_day <> 1 or last_day <> 12 or distinct_days <> 12 then
    raise exception 'Plan 285 must have exactly 12 unique numbered days, found %', present_days;
  end if;
end
$$;


update public.devotional_plans as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "value": "Prayer, Humility, and Wise Living: 12 Readings from Jonathan Swift"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;


update public.devotional_plans as target
set description = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "value": "Twelve Scripture-led devotional readings inspired by Jonathan Swift’s Three Prayers and Sermons, including his 1727 prayers for his ill friend Stella, On Mutual Subjection, On Sleeping in Church, and On the Wisdom of This World. The readings follow the inherited source order while replacing arbitrary anthology fragments with clearly labeled historical context, newly selected Scripture references, original devotional reflection, reflection question, practice, and prayer. These are original editorial adaptations rather than quotations or verified modern translations of Swift’s text. Eighteenth-century assumptions about illness, social hierarchy, worship, and ancient philosophy are presented as historical context rather than universal teachings. The source is linked for comparison."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;


update public.devotional_days as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 1,
    "value": "Praying Beside Someone Who Is Ill"
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 2,
    "value": "Carry Grief Together"
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 3,
    "value": "We Need One Another"
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 4,
    "value": "Turn Influence into Service"
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 5,
    "value": "Blessed to Give"
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 6,
    "value": "Make Room to Hear"
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 7,
    "value": "Look Beyond the Speaker"
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 8,
    "value": "Listening That Changes Our Lives"
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 9,
    "value": "Knowledge Is Not the Whole of Wisdom"
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 10,
    "value": "What Makes a Life Good?"
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 11,
    "value": "Wisdom That Is Gentle and Merciful"
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 12,
    "value": "Let Faith Become Good Fruit"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;


update public.devotional_days as target
set content = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 1,
    "value": "<p><strong>Read:</strong> James 5:13-16; Psalm 34:18</p><p><strong>Source and historical context:</strong> In the first two prayers written for Esther Johnson, known as Stella, during her final illness in 1727, Jonathan Swift asks for relief, recovery if possible, and peace of mind. He also remembers her generosity toward people living in poverty and the grief of friends afraid of losing her.</p><p><strong>Devotional focus:</strong> Prayer does not need to hide fear or grief. We can ask for healing while also asking for compassionate care, trustworthy decisions, and peace amid uncertainty. Swift speaks as a friend who loves deeply; his hope invites companionship, not a claim that sickness is punishment or that recovery can be guaranteed.</p><p><strong>Reflect:</strong> Who is carrying illness or caregiving responsibilities and needs both prayer and practical support?</p><p><strong>Practice:</strong> Contact someone who is ill or caring for another person. Ask what kind of help would actually be useful, and respect the answer.</p><p><strong>Prayer:</strong> Merciful God, draw near to those in pain and to those who love them. Guide the hands that care for them, relieve suffering where possible, and give us steadfast compassion. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 2,
    "value": "<p><strong>Read:</strong> Romans 12:15; Galatians 6:2</p><p><strong>Source and historical context:</strong> Swift’s third prayer for Stella asks for strength in pain and for friends who are grieving the possibility of her death. The inherited section then opens his sermon On Mutual Subjection, based on 1 Peter 5:5, which calls people to bear responsibilities toward one another.</p><p><strong>Devotional focus:</strong> The movements from prayer to mutual service belong together. When loss threatens a community, no one should have to shoulder every burden alone. To humble ourselves before one another is to listen, show up, and help rather than demand that the suffering person or grieving family meet our expectations.</p><p><strong>Reflect:</strong> When someone is distressed, are you more inclined to offer ready-made explanations or to share the burden?</p><p><strong>Practice:</strong> Offer one specific form of help without pressing for details or requiring a grateful response.</p><p><strong>Prayer:</strong> God of comfort, receive the prayers we cannot fully express. Teach us to carry one another’s burdens with patience, tenderness, and humility. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 3,
    "value": "<p><strong>Read:</strong> 1 Corinthians 12:21-26; Philippians 2:3-4</p><p><strong>Source and historical context:</strong> In On Mutual Subjection, Swift compares human society with the parts of one body. He argues that people who hold authority, wealth, knowledge, or other advantages depend on the contributions of those with less public standing. He speaks from an eighteenth-century society ordered by class and hierarchy.</p><p><strong>Devotional focus:</strong> The Christian picture of one body gives dignity to each member and responsibility to the whole. No person’s value is determined by job title, resources, or rank. Mutual dependence is a reason to listen across differences and make sure the work of overlooked people receives recognition and fair treatment.</p><p><strong>Reflect:</strong> Whose labor sustains your day but seldom receives your thanks or attention?</p><p><strong>Practice:</strong> Name a contribution you usually overlook, thank the person involved, and look for a fair way to support them.</p><p><strong>Prayer:</strong> Creator of every person, forgive my assumptions about status. Help me honor the gifts of others and carry my responsibilities with care. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 4,
    "value": "<p><strong>Read:</strong> John 13:12-15; Luke 12:48</p><p><strong>Source and historical context:</strong> Swift continues his sermon by pointing to Jesus washing his disciples’ feet. He argues that talents, education, wealth, and authority are entrusted to people for the benefit of others rather than as grounds for pride. He also warns about the misuse of power and the temptation to envy.</p><p><strong>Devotional focus:</strong> Jesus does not cease to be Lord when he washes feet; he shows what his authority is for. Our own influence becomes fruitful when it creates safety and opportunity for others. Humility is more than good manners: it asks what our resources can do for people whose needs or voices are easily dismissed.</p><p><strong>Reflect:</strong> Which advantage in your life could become a practical act of service this week?</p><p><strong>Practice:</strong> Use time, knowledge, money, or influence to solve one problem for someone who has less access than you do.</p><p><strong>Prayer:</strong> Lord Jesus, you stooped to serve. Free me from pride and teach me to use what I have been given for the good of my neighbors. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 5,
    "value": "<p><strong>Read:</strong> Acts 20:35; 1 Peter 4:10</p><p><strong>Source and historical context:</strong> Swift concludes On Mutual Subjection by explaining that wealth, wisdom, and authority are blessings when used for generosity, counsel, protection, and justice. The inherited reading then begins his sermon On Sleeping in Church, which uses the story of Eutychus as a pointed introduction.</p><p><strong>Devotional focus:</strong> Possessions and ability are not proof of divine favoritism; they are opportunities for stewardship. Giving does not need to be dramatic. Listening carefully, sharing expertise, meeting a real need, and protecting another person’s dignity all show generosity. The new sermon also asks whether we make room to receive wisdom ourselves.</p><p><strong>Reflect:</strong> Are you more practiced at keeping track of what you own than noticing what you can share?</p><p><strong>Practice:</strong> Choose one gift you can use generously today, and make room for a few attentive minutes with Scripture.</p><p><strong>Prayer:</strong> Generous Father, make me a faithful steward rather than a collector of status. Open my hands to give and my heart to learn. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 6,
    "value": "<p><strong>Read:</strong> Luke 8:4-15; James 1:19-22</p><p><strong>Source and historical context:</strong> In On Sleeping in Church, Swift criticizes people who skip worship or attend without paying attention. He describes distracted listeners, habitual ridicule, and complaints about preachers. His satire is sharp and assumes the church attendance patterns of his own time.</p><p><strong>Devotional focus:</strong> The parable of the sower asks what becomes of a word after we hear it. Distraction is part of being human; fatigue, illness, disability, or difficult circumstances should never be mistaken for spiritual failure. Still, we can ask what practices help us listen with an open heart and follow through on what we learn.</p><p><strong>Reflect:</strong> What regularly crowds out thoughtful attention when you want to pray, listen, or learn?</p><p><strong>Practice:</strong> Remove one avoidable distraction during a short reading, then write down one action suggested by the passage.</p><p><strong>Prayer:</strong> Patient God, meet me in my distraction. Give me the freedom to rest when needed and the willingness to hear and practice what is good. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 7,
    "value": "<p><strong>Read:</strong> 1 Corinthians 2:1-5; 1 Thessalonians 5:20-21</p><p><strong>Source and historical context:</strong> Swift answers objections to preaching by noting that speakers have different abilities and not every sermon will be eloquent. He contrasts plain truthful communication with impressive rhetoric that can manipulate emotions. He then returns to the danger of treating serious teaching only as entertainment.</p><p><strong>Devotional focus:</strong> We need both discernment and humility. An imperfect speaker can still say something worth considering, while polished language cannot make a false claim true. Christian listening neither despises a message because its delivery is ordinary nor accepts every assertion without testing it against Scripture and wise counsel.</p><p><strong>Reflect:</strong> Do you judge a message mainly by how captivating it sounds or by what is true and life-giving in it?</p><p><strong>Practice:</strong> Revisit one teaching you heard recently. Identify its central claim and examine it carefully rather than relying on style alone.</p><p><strong>Prayer:</strong> God of truth, guard me from cynicism and gullibility. Help me listen graciously, reason carefully, and respond faithfully. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 8,
    "value": "<p><strong>Read:</strong> James 1:22-25; Mark 4:23-24</p><p><strong>Source and historical context:</strong> Swift closes On Sleeping in Church by asking people to approach sermons as occasions for self-examination instead of performances to rate or mock. The section then introduces his next sermon, On the Wisdom of This World, drawn from 1 Corinthians 3:19.</p><p><strong>Devotional focus:</strong> Listening becomes fruitful when it changes how we live. We do not need to remember every line or enjoy every style of teaching; we can carry away one truth, one question, or one act of repentance. Swift’s pointed humor should not become permission to shame people for ordinary tiredness. His lasting invitation is to attend to what matters.</p><p><strong>Reflect:</strong> What did you last hear that you agreed with but have not yet put into practice?</p><p><strong>Practice:</strong> Choose one small action from a recent Scripture reading or sermon. Complete it before the day ends, if practical.</p><p><strong>Prayer:</strong> Living Word, help me move beyond judging others’ performances and toward honest change in my own life. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 9,
    "value": "<p><strong>Read:</strong> 1 Corinthians 3:18-20; James 3:13</p><p><strong>Source and historical context:</strong> Beginning On the Wisdom of This World, Swift questions the tendency to praise ancient Greek and Roman philosophers uncritically. He argues that Christian revelation offers knowledge of God and human purpose that human debate alone cannot settle. His broad descriptions of other traditions reflect the assumptions of his era.</p><p><strong>Devotional focus:</strong> Learning is valuable, but information and prestige do not automatically make a person wise. Scripture asks how understanding appears in humility and conduct. We can read thinkers of many traditions accurately and respectfully while asking, as followers of Jesus, whether our knowledge is making us more truthful, loving, and teachable.</p><p><strong>Reflect:</strong> Where have you confused being informed with being wise?</p><p><strong>Practice:</strong> In a conversation today, ask one sincere question before offering your opinion. Practice learning without competing.</p><p><strong>Prayer:</strong> God of wisdom, protect me from pride in what I know. Teach me to seek truth with humility and to use knowledge for good. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 10,
    "value": "<p><strong>Read:</strong> Matthew 6:19-21; Philippians 4:11-13</p><p><strong>Source and historical context:</strong> Swift’s argument about worldly wisdom continues with different ancient accounts of happiness: pleasure, reputation, virtue, wealth, and good fortune. He challenges the idea that changeable circumstances can give a lasting foundation for hope. Several of his claims about philosophers are polemical summaries, not neutral historical scholarship.</p><p><strong>Devotional focus:</strong> Health, friendship, financial stability, and achievement are genuine goods; their value is not that they can guarantee a life without loss. Jesus directs the heart toward a treasure that does not depend entirely on changing conditions. The question is not whether earthly needs matter, but whether they have become our only measure of a good life.</p><p><strong>Reflect:</strong> Which good thing are you asking to provide a security it cannot finally guarantee?</p><p><strong>Practice:</strong> Write down three important gifts in your life and one way to receive or use each without making it your identity.</p><p><strong>Prayer:</strong> Steady God, teach me gratitude for today’s gifts and trust when circumstances change. Shape my desires around what lasts. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 11,
    "value": "<p><strong>Read:</strong> James 3:13-18; Matthew 5:7-9</p><p><strong>Source and historical context:</strong> Swift surveys well-known philosophers and criticizes what he sees as the limits of their moral teachings. He then turns to James’s description of wisdom from above: pure, peace-loving, considerate, merciful, impartial, and sincere. His comparisons are historically contested, but his central biblical standard is clear.</p><p><strong>Devotional focus:</strong> Wisdom is not proved by winning a debate or humiliating an opponent. James measures it in our relationships: are we peacemakers, willing to listen, slow to show favoritism, and active in mercy? That standard also governs how we discuss people and ideas with whom we disagree.</p><p><strong>Reflect:</strong> Which quality in James’s description of wisdom do you most need in a strained relationship?</p><p><strong>Practice:</strong> Choose one peacemaking act: apologize, listen without interrupting, correct unfair speech, or offer undeserved kindness.</p><p><strong>Prayer:</strong> God of peace, make my words gentle and my actions sincere. Let mercy and fairness reveal the wisdom I seek. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 12,
    "value": "<p><strong>Read:</strong> James 3:17-18; John 13:34-35</p><p><strong>Source and historical context:</strong> Swift closes On the Wisdom of This World by praising the courage of early Christians and warning that intellectual rivalry can pull believers away from their calling. He contrasts sectarian quarrels with James’s picture of wisdom bearing peace and good works. His claims about ancient philosophy are part of an eighteenth-century Christian argument.</p><p><strong>Devotional focus:</strong> A life of faith is not measured by how forcefully we dismiss other people’s ideas. Jesus points to love as the identifying sign of his disciples. Learning, doctrinal conviction, and careful disagreement can serve faith when joined to humility, honesty, and deeds that bring hope to neighbors.</p><p><strong>Reflect:</strong> If someone watched your actions rather than listened to your arguments, what would they learn about your faith?</p><p><strong>Practice:</strong> Put one belief into practice through a concrete act of reconciliation, hospitality, or service, without seeking recognition.</p><p><strong>Prayer:</strong> Lord Jesus, make my faith visible through love. Keep me truthful without contempt, courageous without cruelty, and faithful in daily service. Amen.</p>"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;


-- Only change plan-level Scripture references (user_id IS NULL).
-- Preserve any reader-generated Scripture reference records.
do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 1,
    "references": [
      "James 5:13-16",
      "Psalm 34:18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 2,
    "references": [
      "Romans 12:15",
      "Galatians 6:2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 3,
    "references": [
      "1 Corinthians 12:21-26",
      "Philippians 2:3-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 4,
    "references": [
      "John 13:12-15",
      "Luke 12:48"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 5,
    "references": [
      "Acts 20:35",
      "1 Peter 4:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 6,
    "references": [
      "Luke 8:4-15",
      "James 1:19-22"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 7,
    "references": [
      "1 Corinthians 2:1-5",
      "1 Thessalonians 5:20-21"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 8,
    "references": [
      "James 1:22-25",
      "Mark 4:23-24"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 9,
    "references": [
      "1 Corinthians 3:18-20",
      "James 3:13"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 10,
    "references": [
      "Matthew 6:19-21",
      "Philippians 4:11-13"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 11,
    "references": [
      "James 3:13-18",
      "Matthew 5:7-9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000285",
    "day_number": 12,
    "references": [
      "James 3:17-18",
      "John 13:34-35"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;

    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = now()
    where day_id = target_day_id and user_id is null;

    if not found then
      insert into public.scripture_references
        (user_id, day_id, reference, created_at, updated_at)
      values
        (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
         now(), now());
    end if;
  end loop;
end
$$;

-- Keep adapted text out of published feeds pending qualified review.
update public.devotional_plans
set status = 'published', updated_at = now()
where id = '90000000-0000-0000-0000-000000000285'::uuid;

commit;
