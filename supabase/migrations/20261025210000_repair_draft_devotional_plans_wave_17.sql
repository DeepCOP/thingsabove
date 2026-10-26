-- Adapt sixteen source-checked, Scripture-led readings from J. Manning Potts's
-- Prayers of the Early Church, published as an anthology in 1953.
-- Printed historical attributions are reported as editorial credits, not verified authorship.
-- Replaces long mechanically segmented text with a selected complete-prayer theme per day.
-- Newly written paraphrases, reflections and prayers are clearly distinguished from sources.
-- Existing plan ID, day IDs, day numbers, total_days, source URL and reading progress persist.
-- Publication is authorized after source, editorial, and distribution review.

begin;

-- Fail safely if the target structure differs from the reviewed seeded 16-day plan.
do $$
declare
  present_days integer;
  first_day integer;
  last_day integer;
  source_link text;
  reported_total integer;
begin
  select source_url, total_days into source_link, reported_total
  from public.devotional_plans where id = '90000000-0000-0000-0000-000000000264'::uuid;
  if not found then
    raise exception 'Plan 264 is missing';
  end if;
  if source_link is distinct from 'https://www.gutenberg.org/ebooks/48247' or reported_total <> 16 then
    raise exception 'Plan 264 source URL or total_days differs from the reviewed source';
  end if;
  select count(*), min(day_number), max(day_number) into present_days, first_day, last_day
  from public.devotional_days where plan_id = '90000000-0000-0000-0000-000000000264'::uuid;
  if present_days <> 16 or first_day <> 1 or last_day <> 16 then
    raise exception 'Plan 264 must have exactly 16 numbered days, found %', present_days;
  end if;
end
$$;

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-25 21:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Praying with the Early Church: Sixteen Scripture-Led Readings"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-25 21:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Sixteen Scripture-led devotions drawn from selected prayers in J. Manning Potts's 1953 anthology Prayers of the Early Church. The readings follow the existing seed's order, beginning with Simeon's biblical prayer and continuing through ancient intercessions, liturgical prayers, Augustine, and later collects. Every source-based paraphrase is editorial rather than a quotation and is followed by an original reflection and prayer. Historical attributions are those printed in Potts's anthology and have not all been independently established. The full source remains linked."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-25 21:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Seeing God's Salvation",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Praying for Just Leaders",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Mercy That Leads to Peace",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "A Heart Made Ready",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Grace for Every Stage",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Beginning the Day with Thanks",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Love Without Keeping Score",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Remember Every Neighbor",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Steadfast in God's Love",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Learning to Love and Obey",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "A Peace Deeper Than Circumstances",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Entrusting the Evening to God",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "The Holy Spirit's Guidance",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Doing What Is Right",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "God's Presence in Sorrow",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Never Beyond God's Care",
    "day_number": 16
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-25 21:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> Luke 2:25-32.</p><p><strong>Source and attribution:</strong> Potts begins his selection of first-century prayers with Simeon's words from Luke's Gospel. This is a biblical prayer, not a quotation authored by the anthology's editor.</p><p><strong>Source-based editorial paraphrase:</strong> Simeon receives the child Jesus with gratitude. His hope rests in God's promise, and he recognizes salvation as light for the nations and glory for Israel.</p><p><strong>Reflect:</strong> Faith can learn to recognize Christ even in an unremarkable moment. Where do you need patient hope while waiting for God's goodness? Give thanks for one sign of grace today.</p><p><strong>Prayer:</strong> Faithful Father, teach me the patient hope of Simeon. Open my eyes to Jesus Christ, your promised salvation, and help me welcome your light with gratitude. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> 1 Timothy 2:1-4.</p><p><strong>Source and attribution:</strong> The anthology attributes this petition for rulers to Clement of Rome. It asks for peace, sound judgment, and gentle exercise of public authority; its historical form reflects an ancient social order.</p><p><strong>Source-based editorial paraphrase:</strong> The prayer seeks rulers whose decisions support stability, peace, and the common good. It brings political power before God instead of treating it as beyond moral judgment.</p><p><strong>Reflect:</strong> Praying for public officials need not mean excusing injustice. Name one decision affecting vulnerable neighbors and consider a peaceful, truthful way to advocate for their welfare.</p><p><strong>Prayer:</strong> God of justice, give leaders wisdom, integrity, and humility. Protect people harmed by abuses of power, and make us willing to seek peace and fairness in our communities. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> Psalm 51:10-12; 1 John 1:9.</p><p><strong>Source and attribution:</strong> Potts prints a prayer titled 'For Forgiveness' under Clement of Rome. It praises the Creator, confesses human wrongs, asks for purification, and seeks peace among people.</p><p><strong>Source-based editorial paraphrase:</strong> The ancient petition does not stop with relief from guilt. It asks God to direct our steps toward a clean heart, just conduct, and relationships marked by peace.</p><p><strong>Reflect:</strong> Confession should lead toward repair where possible. What wrong needs to be acknowledged, and what truthful, safe step could help restore trust?</p><p><strong>Prayer:</strong> Merciful Creator, forgive what I have done wrong and renew my heart. Teach me to accept responsibility, make amends where I can, and walk in your peace. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> James 1:22-25.</p><p><strong>Source and attribution:</strong> The anthology credits the complete prayer 'For a Pure Heart' to the Liturgy of St. James. Its language asks God to examine the conscience and turn people away from envy, anger, and pride.</p><p><strong>Source-based editorial paraphrase:</strong> Purity in this prayer concerns not appearances but the direction of one's inner life. It asks God to shape thoughts, motives, and speech for truthful worship.</p><p><strong>Reflect:</strong> Where is resentment affecting your words or decisions? Pray about its root, then choose one action that combines honesty with gentleness.</p><p><strong>Prayer:</strong> Holy Father, search my heart and free me from envy, arrogance, and needless anger. Make my words sincere and my actions consistent with your love. Through Jesus Christ, amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> Philippians 1:6-11.</p><p><strong>Source and attribution:</strong> The anthology prints a brief prayer 'For Growth in Grace' with the combined attribution 'Irenaeus, Old Gallican Sacramentary.' That credit is reproduced as the editor's attribution, not an authenticated statement of authorship.</p><p><strong>Source-based editorial paraphrase:</strong> The petition remembers people at different stages: beginners, learners, the weary, and those nearing the end of their course. Each needs God's sustaining grace.</p><p><strong>Reflect:</strong> Spiritual growth is not a competition. Who around you needs encouragement rather than comparison? Offer help suited to their situation, and accept help with your own.</p><p><strong>Prayer:</strong> Patient God, strengthen new believers, teach those still learning, restore the discouraged, and keep us faithful through every season of life. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> Lamentations 3:22-23.</p><p><strong>Source and attribution:</strong> Potts labels this morning thanksgiving as a prayer from the Liturgy of St. Mark. It remembers guidance and mercy already received and asks for an honest and faithful day ahead.</p><p><strong>Source-based editorial paraphrase:</strong> Morning prayer can begin with thanks rather than anxiety. The ancient words acknowledge past help while asking for protection from envy, fear, and harmful choices.</p><p><strong>Reflect:</strong> Before checking the day's demands, remember one kindness you have received. Which conversation or decision would benefit from a calmer, more grateful spirit?</p><p><strong>Prayer:</strong> Lord of mercy, thank you for bringing me into this day. Guide my thoughts, guard my speech, forgive my failings, and help me act with peace and integrity. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> John 13:34-35.</p><p><strong>Source and attribution:</strong> The anthology attributes the prayer 'For Charity' to the Coptic Liturgy of St. Cyril. It appeals to Jesus' command to love one another and asks for sincerity instead of lingering hostility.</p><p><strong>Source-based editorial paraphrase:</strong> Christian love is not the denial of harm; it refuses to let bitterness rule the heart. The source asks God to renew conscience and enable love that reflects Christ.</p><p><strong>Reflect:</strong> Is there a resentment you need to surrender, or a boundary you need to keep wisely? Seek love without pretending that injustice did not happen.</p><p><strong>Prayer:</strong> Lord Jesus, you loved us first. Give me a sincere heart, courage to speak truth, and grace to act with kindness without neglecting justice. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> Hebrews 13:1-3.</p><p><strong>Source and attribution:</strong> Potts attributes 'For All People' to Chrysostom. It names cities and countries, travelers, people experiencing illness or bondage, and those who serve the poor.</p><p><strong>Source-based editorial paraphrase:</strong> The prayer widens a congregation's concern beyond its own walls. It calls attention to people far away as well as neighbors who are vulnerable or easily forgotten.</p><p><strong>Reflect:</strong> Who falls outside your usual circle of concern? Pray for that person or community, then consider one concrete form of support or solidarity.</p><p><strong>Prayer:</strong> God of compassion, remember those who travel, suffer illness, face oppression, or lack daily necessities. Help your church respond with generous and practical love. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> Psalm 139:23-24.</p><p><strong>Source and attribution:</strong> The anthology credits this prayer of perseverance to Augustine. It pictures the soul as a house needing God's repair and asks for cleansing from hidden faults.</p><p><strong>Source-based editorial paraphrase:</strong> Steadfastness begins with dependence on grace. The prayer acknowledges imperfection while seeking a heart more open to the life and love of God.</p><p><strong>Reflect:</strong> What habit or motive have you avoided examining? Invite God's light into it, and choose a small, responsible step toward change.</p><p><strong>Prayer:</strong> God of steadfast love, search my motives and repair what is wounded in me. Cleanse my hidden faults and teach me to remain near you through change and difficulty. Amen.</p>",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> John 14:15-21.</p><p><strong>Source and attribution:</strong> Potts credits the prayer 'For Obedience and Love' to Augustine. It turns asking, seeking, and knocking into a request for a life directed toward God.</p><p><strong>Source-based editorial paraphrase:</strong> The ancient petition joins love and obedience. Its aim is not outward performance for approval but a willing life changed by relationship with the Lord.</p><p><strong>Reflect:</strong> What choice today would make love visible in practice? Name one response involving patience, honesty, generosity, or a needed apology.</p><p><strong>Prayer:</strong> Lord Jesus, draw my heart toward you. Shape my desires and guide my actions so that my profession of love becomes faithful care for others. Amen.</p>",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> John 14:27.</p><p><strong>Source and attribution:</strong> The anthology includes Augustine's brief petition for peace and enduring rest. His language looks beyond today's interruptions toward the rest promised in God.</p><p><strong>Source-based editorial paraphrase:</strong> Christian peace is more than the absence of noise or trouble. The prayer turns the soul toward God's enduring presence without claiming that hardship disappears now.</p><p><strong>Reflect:</strong> Where are you treating rest as something you must earn? Make space for a short pause, prayer, and any practical help you need.</p><p><strong>Prayer:</strong> Lord Jesus Christ, giver of peace, quiet my restless heart. Sustain me in what I cannot control and teach me to rest in your faithful love. Amen.</p>",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> Psalm 4:8.</p><p><strong>Source and attribution:</strong> The anthology places this short communal evening petition in the Apostolic Constitutions. It asks for peace, mercy, and a faithful life as the day draws to a close.</p><p><strong>Source-based editorial paraphrase:</strong> Evening prayer can hold gratitude and unresolved burdens together. The historical petition entrusts the night and the whole course of life to the living God through Christ.</p><p><strong>Reflect:</strong> Review one moment of gratitude and one unfinished concern from today. Give thanks for the first and release the second into God's care without neglecting tomorrow's responsibilities.</p><p><strong>Prayer:</strong> Living God, receive my gratitude and forgive my failures today. Grant restful peace, protect those in need, and prepare me to serve you faithfully tomorrow. Through Christ, amen.</p>",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> John 14:25-26.</p><p><strong>Source and attribution:</strong> The anthology attributes the prayer 'For The Holy Spirit' to the Apostolic Constitutions. It asks for an attentive mind, a faithful heart, and understanding of the truth through Christ.</p><p><strong>Source-based editorial paraphrase:</strong> The Spirit guides the church toward truth and holiness, not self-importance. The ancient request joins understanding with a life ready to be corrected and renewed.</p><p><strong>Reflect:</strong> Where do you need to listen more carefully before deciding? Read the passage again and ask for humility as well as clarity.</p><p><strong>Prayer:</strong> Holy Spirit, enlighten my understanding and correct my pride. Form in me a watchful heart, honest discernment, and deeper faith in Jesus Christ. Amen.</p>",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> Micah 6:8.</p><p><strong>Source and attribution:</strong> Potts prints 'For Right Living' as a prayer from the Leonine Sacramentary among his fifth-century selections. It asks for grace to think and act in ways pleasing to God.</p><p><strong>Source-based editorial paraphrase:</strong> Right intention and right action belong together. The prayer recognizes our need for divine help while inviting concrete habits of justice, mercy, and humility.</p><p><strong>Reflect:</strong> What good intention has remained unfinished? Turn it into a manageable step that can benefit another person today.</p><p><strong>Prayer:</strong> Gracious God, guide my thinking and strengthen my actions. Teach me to do justice, love mercy, and walk humbly with you through Jesus Christ. Amen.</p>",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> 2 Corinthians 1:3-5.</p><p><strong>Source and attribution:</strong> The anthology credits 'For the Sorrowing' to the Gelasian Sacramentary. It addresses God as the comfort of the sad and strength of those suffering adversity.</p><p><strong>Source-based editorial paraphrase:</strong> This collect does not demand that suffering people hide their grief. It asks that they may discover God's mercy in affliction, even while difficulty remains real.</p><p><strong>Reflect:</strong> Who is carrying sorrow that needs companionship rather than advice? Offer a listening ear, a visit, or a practical act of help.</p><p><strong>Prayer:</strong> Father of compassion, draw near to those who grieve or suffer. Give them comfort, trustworthy support, and the freedom to speak honestly of their pain. Amen.</p>",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> Psalm 121:7-8; Matthew 28:20.</p><p><strong>Source and attribution:</strong> Potts attributes this prayer for distant servants and travelers to the Gelasian Sacramentary. It petitions God for guidance and companionship throughout their journeys.</p><p><strong>Source-based editorial paraphrase:</strong> The source reminds worshipers that distance cannot place a person outside God's concern. This is a prayer for care and guidance, not a promise that followers of Christ will never face danger.</p><p><strong>Reflect:</strong> Who is far from your immediate reach today? Pray for their needs, check on them if appropriate, and offer real help within your means.</p><p><strong>Prayer:</strong> Lord Jesus, be near your people wherever they travel or serve. Give them wisdom, companions, and practical protection; keep us united in your love. Amen.</p>",
    "day_number": 16
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

-- Scripture-reference records are updated in place; unrelated user notes are untouched.
do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 1,
    "references": [
      "Luke 2:25-32"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 2,
    "references": [
      "1 Timothy 2:1-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 3,
    "references": [
      "Psalm 51:10-12",
      "1 John 1:9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 4,
    "references": [
      "James 1:22-25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 5,
    "references": [
      "Philippians 1:6-11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 6,
    "references": [
      "Lamentations 3:22-23"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 7,
    "references": [
      "John 13:34-35"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 8,
    "references": [
      "Hebrews 13:1-3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 9,
    "references": [
      "Psalm 139:23-24"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 10,
    "references": [
      "John 14:15-21"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 11,
    "references": [
      "John 14:27"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 12,
    "references": [
      "Psalm 4:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 13,
    "references": [
      "John 14:25-26"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 14,
    "references": [
      "Micah 6:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 15,
    "references": [
      "2 Corinthians 1:3-5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 16,
    "references": [
      "Psalm 121:7-8",
      "Matthew 28:20"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-25 21:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-25 21:00:00+00', timestamptz '2026-10-25 21:00:00+00');
    end if;
  end loop;
end
$$;

-- Publish the reviewed early-church prayer adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-25 21:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000264'::uuid
);

commit;
