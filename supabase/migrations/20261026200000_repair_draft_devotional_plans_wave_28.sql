-- Wave 28: Plan 338 — Thoughts and Counsels of the Saints for Every Day of the Year.
-- Eleven newly written Scripture-led readings from 11 mechanically split calendar segments.
-- Preserves existing identifiers and user reading progress; retains Catholic source context.
-- Apply AFTER October 21 modernization migrations (including part 10).
-- Reviewed editorial adaptation; not a Bible translation reproduction or full 365-day edition.

begin;

do $$
declare
  current_source text;
  current_total integer;
  day_count integer;
  first_day integer;
  last_day integer;
  unique_days integer;
begin
  select source_url, total_days into current_source, current_total
  from public.devotional_plans
  where id = '90000000-0000-0000-0000-000000000338'::uuid;
  if not found then raise exception 'Plan 338 missing'; end if;
  if current_source is distinct from 'https://www.gutenberg.org/ebooks/33649' or current_total is distinct from 11 then
    raise exception 'Plan 338 metadata differs from source reviewed for Wave 28';
  end if;
  select count(*), min(day_number), max(day_number), count(distinct day_number)
  into day_count, first_day, last_day, unique_days
  from public.devotional_days where plan_id = '90000000-0000-0000-0000-000000000338'::uuid;
  if day_count <> 11 or first_day <> 1 or last_day <> 11 or unique_days <> 11 then
    raise exception 'Plan 338 must contain 11 distinct numbered days; found %', day_count;
  end if;
end
$$;

update public.devotional_plans as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "value": "Daily Wisdom of the Saints: Eleven Scripture-Led Reflections"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "value": "Eleven original, Scripture-led readings inspired by Rev. Bonaventure Hammer’s collection of Catholic saints’ counsels across the calendar year. Each reading draws from its corresponding source segment and offers historical context, thoughtful reflection, practical action, and prayer. Distinctively Catholic devotions are named as such rather than treated as direct Bible quotations. This is a new eleven-day thematic adaptation, not a complete 365/366-day quotation calendar or a sentence-by-sentence modernization."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 1,
    "value": "Begin with Humility and Prayer"
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 2,
    "value": "Let Love Become a Practice"
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 3,
    "value": "A Faith That Refuses Hatred"
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 4,
    "value": "Learn Humility from Mary’s Song"
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 5,
    "value": "Love of God, Love of Neighbor"
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 6,
    "value": "Give Thanks with an Honest Heart"
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 7,
    "value": "Correct with Gentleness"
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 8,
    "value": "Teach Faith by Example"
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 9,
    "value": "Share One Another’s Joy and Sorrow"
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 10,
    "value": "Seek the Good of Others"
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 11,
    "value": "Receive This Day as a Gift"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 1,
    "value": "<p><strong>Read:</strong> Psalm 145:1-3; James 4:6-10</p><p><strong>Source and historical context:</strong> The collection opens with a call to bless God daily. In the January sayings, Catherine of Siena describes prayer as a place where virtues are nourished; Teresa of Ávila and Vincent de Paul also place humility before self-congratulation. Bonaventure Hammer gathered these words as daily Catholic spiritual counsel, not as a continuous sermon.</p><p><strong>Devotional focus:</strong> The first step in a faithful life is not proving that we are already strong. It is returning to the God who loves us and learning to listen. Prayer can make room for honesty, gratitude, repentance, and wise action. Humility does not require despising ourselves or refusing care. It means knowing that wisdom is a gift, not a trophy, and using what we receive for others.</p><p><strong>Reflect:</strong> Where am I tempted to appear spiritually accomplished rather than honestly present before God?</p><p><strong>Practice:</strong> Begin with a quiet prayer and identify one small act of kindness that can grow from it today.</p><p><strong>Prayer:</strong> God of wisdom, teach me to pray with a humble heart and to put love into practice. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 2,
    "value": "<p><strong>Read:</strong> 1 John 3:16-18; Luke 10:33-37</p><p><strong>Source and historical context:</strong> This portion continues February’s short sayings. Ignatius stresses that love is shown in actions rather than merely spoken, Vincent de Paul commends practical resolutions, and Louis of Granada urges a person who falls to begin again. The closing lines enter March, where the collection asks readers to consider their intentions carefully.</p><p><strong>Devotional focus:</strong> Beautiful intentions matter, but neighbors experience love through patient choices. A visit, a truthful apology, a fair decision, or a meal may carry more weight than impressive declarations. When we fail, honest repentance opens a way forward; it need not become endless self-accusation. The saints’ vigorous language about discipline is best heard as an invitation to grow in compassion, not a license to punish ourselves.</p><p><strong>Reflect:</strong> Which person needs a concrete act of care from me more than another promise?</p><p><strong>Practice:</strong> Choose one manageable loving action, carry it out, and if you have hurt someone, begin a sincere repair.</p><p><strong>Prayer:</strong> Lord Jesus, move my concern from words to deeds and strengthen me to begin again when I fail. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 3,
    "value": "<p><strong>Read:</strong> 1 John 4:19-21; Matthew 5:23-24</p><p><strong>Source and historical context:</strong> The March section begins with Louis de Blois warning that even fasting, giving, and regular prayer lose their meaning when a person holds hatred toward a brother. Other sayings in this span discuss restraint of speech, mercy, courage, and humble service. In the Catholic collection these stand beside devotions to St. Joseph and the saints.</p><p><strong>Devotional focus:</strong> Religious habits cannot substitute for the way we treat people. Worship should soften our response to those with whom we disagree, especially when an argument has made us defensive. Reconciliation is not the same as accepting mistreatment; it can include truthful boundaries, justice, and the need for safety. Love asks us to resist contempt while taking harm seriously.</p><p><strong>Reflect:</strong> Has any resentment begun to shape the way I speak about another person?</p><p><strong>Practice:</strong> Pray for a heart free of contempt, then take one safe, honest step toward peace or a healthier boundary.</p><p><strong>Prayer:</strong> God of mercy, keep devotion from becoming a mask for bitterness. Teach me truth, courage, and love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 4,
    "value": "<p><strong>Read:</strong> Luke 1:39-55; John 2:1-11</p><p><strong>Source and historical context:</strong> This segment moves from April counsel about prayer and reflection into May, where Marian devotion dominates. On May 1, a saying attributed to Alphonsus praises Mary’s union with God’s will; later quotations present Catholic beliefs about Mary’s intercession and the saints. These devotional claims belong to the tradition of the source and are not direct quotations from Scripture.</p><p><strong>Devotional focus:</strong> In Luke’s account, Mary responds to God with trust and sings about mercy, the lifting up of the lowly, and the humbling of the proud. Christians differ about the place of Marian intercession in prayer, yet the biblical scene invites all readers to notice courage, humility, and concern for the overlooked. Let Mary’s song turn our attention not toward status or self-importance, but toward the God whose mercy upends them.</p><p><strong>Reflect:</strong> How might Mary’s song reshape the way I see people who are overlooked?</p><p><strong>Practice:</strong> Read the Magnificat slowly. Name one practical way to honor someone whose dignity is often ignored.</p><p><strong>Prayer:</strong> God of mercy, give me a willing heart and eyes that recognize your care for the lowly. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 5,
    "value": "<p><strong>Read:</strong> Mark 12:28-34; James 2:14-17</p><p><strong>Source and historical context:</strong> The remainder of May continues the collection’s explicitly Marian prayers and images. In June, the subject expands to the heart of Jesus, generosity, repentance, and everyday work. Gregory the Great describes love of God and love of neighbor as forces that sustain each other.</p><p><strong>Devotional focus:</strong> Devotion is not a competition between loving God and loving people. Jesus joins those commands, and James insists that compassion should reach people’s real needs. Some sayings here speak of penance or suffering in severe terms; faithful love does not require neglecting health or denying legitimate joy. Giving care, telling the truth, and honoring another’s dignity are meaningful ways to keep faith visible.</p><p><strong>Reflect:</strong> Does my spiritual routine make me more attentive to the needs around me?</p><p><strong>Practice:</strong> Offer help with a specific need today, listening first to what the person actually wants.</p><p><strong>Prayer:</strong> Jesus, deepen love for you until it becomes generous and respectful care for my neighbor. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 6,
    "value": "<p><strong>Read:</strong> Colossians 3:15-17; James 1:17</p><p><strong>Source and historical context:</strong> In the July quotations, Vincent de Paul commends gratitude for graces already received, while other counsels discuss careful speech, conscience, mercy, and the integrity of good work. This portion also includes Catholic claims about the pope and Mary, which reflect the collection’s confessional setting. The final lines reach the first days of August.</p><p><strong>Devotional focus:</strong> Gratitude does not pretend that every circumstance is good or that pain is easy. It notices what has been received while making room for what is still hard. Remembering a gift can lead to giving one: encouragement, integrity at work, or an apology that restores trust. Rather than measuring our worth against another person’s achievements, we can receive this day as a chance to respond faithfully.</p><p><strong>Reflect:</strong> What gift have I overlooked because I am focused on what is missing?</p><p><strong>Practice:</strong> Write down three specific things for which you are grateful and let one of them prompt a generous response.</p><p><strong>Prayer:</strong> Generous God, train my memory toward gratitude and my hands toward faithful service. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 7,
    "value": "<p><strong>Read:</strong> Galatians 6:1-2; Ephesians 4:29-32</p><p><strong>Source and historical context:</strong> The August counsels return to prayer, discipline, conscience, patience, and the way people speak to one another. A saying attributed to Louis of Granada urges that correction be offered calmly, with discernment, and not in an outburst of anger. September then begins with counsels on perseverance and humble self-examination.</p><p><strong>Devotional focus:</strong> There is a difference between helping a person see a problem and trying to win a confrontation. Scripture calls for restoration in a gentle spirit, with awareness of our own vulnerability. Calmness does not mean silence about wrongdoing. It means choosing words and timing that protect dignity and create room for genuine change. Boundaries and accountability still matter, especially when a person has been hurt.</p><p><strong>Reflect:</strong> When I offer correction, am I hoping to restore someone or simply to prove I am right?</p><p><strong>Practice:</strong> If a hard conversation is needed, plan one truthful sentence and a question that invites listening before speaking.</p><p><strong>Prayer:</strong> Holy Spirit, guard my tongue. Give me courage to tell the truth and tenderness to speak it for healing. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 8,
    "value": "<p><strong>Read:</strong> Matthew 5:13-16; James 1:22-25</p><p><strong>Source and historical context:</strong> The September and early October sayings reflect on patience, prayer, avoiding harsh judgments, and the difference between words and actions. On October 1, Henry Suso is credited with a concise encouragement to teach virtue through both word and deed because example has particular influence.</p><p><strong>Devotional focus:</strong> A life is not made credible by perfect presentation. Faith becomes visible when people see honesty at work, patience under pressure, and fair treatment of those who cannot repay us. We can learn from others’ examples without assuming that every painful event was arranged as a lesson. If our words and behavior contradict each other, grace offers an opportunity to acknowledge the gap and change course.</p><p><strong>Reflect:</strong> What are my ordinary actions teaching the people who spend time with me?</p><p><strong>Practice:</strong> Choose one habit—truthful speech, punctual care, or kindness under stress—and practice it consistently today.</p><p><strong>Prayer:</strong> God, unite what I say with how I live. Let my example point toward your goodness, not my image. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 9,
    "value": "<p><strong>Read:</strong> Romans 12:9-16; 1 Corinthians 12:25-27</p><p><strong>Source and historical context:</strong> Late October includes a saying from Louis of Granada about believers sharing one another’s joys and sorrows because they are members of Christ’s body. The opening of November turns to saints, remembrance of the dead, and Catholic teaching about purgatory. Such teaching is part of this anthology’s distinct tradition and should be distinguished from the passages offered for today’s reading.</p><p><strong>Devotional focus:</strong> Community means more than belonging to the same group. When one person celebrates, love can resist envy. When another grieves, love can remain present without demanding quick answers. Christians hold differing convictions about prayer for the dead, but all can take seriously Paul’s call to compassion within the living community. The point is not to solve every mystery of suffering; it is to refuse to leave a neighbor alone in it.</p><p><strong>Reflect:</strong> Whose good news have I not celebrated—or whose grief have I been avoiding?</p><p><strong>Practice:</strong> Congratulate someone sincerely or reach out to a grieving person with a simple, practical offer of company.</p><p><strong>Prayer:</strong> God of comfort, make me faithful in another person’s joy and gentle in another person’s sorrow. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 10,
    "value": "<p><strong>Read:</strong> Philippians 2:1-5; Matthew 25:34-40</p><p><strong>Source and historical context:</strong> The late-November and December counsels include Teresa of Ávila’s warning against Christians harming one another, along with Vincent de Paul’s encouragement to consider another person’s interests as carefully as our own. The same section also includes Catholic statements about the Church, sacraments, and the obedience due to its leadership.</p><p><strong>Devotional focus:</strong> Paul’s invitation to look to another’s interests does not ask us to surrender conscience, tolerate abuse, or erase all personal needs. It calls us to abandon the habit of making our own advantage the only measure. In homes, workplaces, and churches, service becomes trustworthy when it respects people’s voices and remembers the vulnerable. Giving something of ourselves matters most when it is freely and wisely offered.</p><p><strong>Reflect:</strong> Who may be carrying an unfair burden because the rest of us are looking away?</p><p><strong>Practice:</strong> Share a task, offer needed resources, or make space for another person’s perspective in a decision.</p><p><strong>Prayer:</strong> Lord, free me from self-importance and teach me to seek my neighbor’s good with wisdom. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 11,
    "value": "<p><strong>Read:</strong> Luke 2:1-20; Colossians 3:12-17</p><p><strong>Source and historical context:</strong> The collection closes with Christmas counsel attributed to Alphonsus, who reflects on Christ’s humble birth, followed by reminders about kindness, constancy, and making use of the present. The final December 31 saying directs attention away from reliving yesterday or controlling tomorrow and toward the good that can be done now.</p><p><strong>Devotional focus:</strong> The manger does not proclaim that suffering is desirable; it tells of a Savior welcomed in ordinary, vulnerable circumstances. As one year ends, we may carry gratitude and grief together. We cannot rewrite the past or secure every outcome ahead. But today offers room to forgive, make peace, learn, rest, and love. A small act done faithfully can be a fitting answer to God’s gift of presence.</p><p><strong>Reflect:</strong> What faithful good is possible today without pretending I control the next year?</p><p><strong>Practice:</strong> Choose one achievable act of mercy and one moment of rest; offer both to God without demanding a perfect day.</p><p><strong>Prayer:</strong> Jesus, born among us, teach me to live this present day in hope, gratitude, and practical love. Amen.</p>"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

-- Update only plan-level Scripture references; never modify user-owned reference rows.
do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 1,
    "references": [
      "Psalm 145:1-3",
      "James 4:6-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 2,
    "references": [
      "1 John 3:16-18",
      "Luke 10:33-37"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 3,
    "references": [
      "1 John 4:19-21",
      "Matthew 5:23-24"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 4,
    "references": [
      "Luke 1:39-55",
      "John 2:1-11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 5,
    "references": [
      "Mark 12:28-34",
      "James 2:14-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 6,
    "references": [
      "Colossians 3:15-17",
      "James 1:17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 7,
    "references": [
      "Galatians 6:1-2",
      "Ephesians 4:29-32"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 8,
    "references": [
      "Matthew 5:13-16",
      "James 1:22-25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 9,
    "references": [
      "Romans 12:9-16",
      "1 Corinthians 12:25-27"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 10,
    "references": [
      "Philippians 2:1-5",
      "Matthew 25:34-40"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000338",
    "day_number": 11,
    "references": [
      "Luke 2:1-20",
      "Colossians 3:12-17"
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
      values
        (null, target_day_id,
         array(select jsonb_array_elements_text(item -> 'references')), now(), now());
    end if;
  end loop;
end
$$;

update public.devotional_plans
set status = 'published', updated_at = now()
where id = '90000000-0000-0000-0000-000000000338'::uuid;

commit;
