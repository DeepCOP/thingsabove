-- The Francis Storr memorial collection reconstructed as eleven Scripture-led devotions.
-- The 1888 memorial setting remains explicit; denominational polemic, claims about an
-- individual's final state, and an invented death scene are omitted or corrected.
-- Existing day IDs and day numbers are preserved.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-23 16:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "Faithful Service and Hope in Christ: Eleven Readings from the Francis Storr Memorials"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-23 16:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "Eleven Scripture-led readings adapted from 1888 memorial notices and sermons for Francis Storr, including notes from his final sermon on John the Baptist. The sequence draws out quiet service, grace in weakness, prayer, the gospel, grief, witness, repentance, and costly faithfulness while identifying the local memorial setting and removing sectarian or speculative claims."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-23 16:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "Quiet Acts of Love",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "Grace in Changed Circumstances",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "Answer the Call Before You",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "Presence, Prayer, and Patient Care",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "The Grace of God in Christ",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "Christ Remains",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "Encourage One Another in Grief",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "A Witness That Points to Jesus",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "Roots Grown in Secret",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "Repentance Bears Practical Fruit",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "Faithful Through Doubt and Cost",
    "day_number": 11
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-23 16:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "<p><strong>Read:</strong> 1 John 3:18; Matthew 6:3-4.</p><p><strong>Historical context:</strong> The 1888 memorial notices describe Francis Storr's long ministry in Brenchley and the practical help he offered neighbors in need. The details belong to one Victorian parish, while the call to active love reaches beyond it.</p><p><strong>Source theme, in contemporary language:</strong> Love becomes visible through ordinary service: welcoming people, making work possible, easing another person's burden, and giving without seeking attention. Quiet kindness can reveal the generosity of Christ.</p><p><strong>Reflect:</strong> Who near you needs practical care rather than a general promise of concern? Choose one useful act you can complete without expecting recognition.</p><p><strong>Prayer:</strong> Generous God, make my love truthful and active. Show me the needs I can meet, and teach me to serve quietly in the name of Jesus. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "<p><strong>Read:</strong> 2 Corinthians 12:9; Psalm 119:11.</p><p><strong>Historical context:</strong> Storr gradually lost his sight during the final decade of his life. The memorial writers admired his continued ministry, his reliance on other people, and his deep memory of Scripture.</p><p><strong>Source theme, in contemporary language:</strong> Loss changes what a person can do, but it does not remove dignity, calling, or the grace of God. Receiving help and storing Scripture in the heart can sustain faithful service through changed circumstances.</p><p><strong>Reflect:</strong> What limitation or change are you resisting? Ask what faithful life can look like now, including the help you may need to receive from others.</p><p><strong>Prayer:</strong> God of sufficient grace, meet me in weakness and change. Plant your word deeply in me, and help me receive and offer care with humility. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "<p><strong>Read:</strong> Ephesians 2:10; Colossians 3:23-24.</p><p><strong>Historical context:</strong> The memorial traces Storr's moves between several parishes and recalls spiritual, charitable, and public-health work during those years. It presents vocation through the choices of a nineteenth-century pastor.</p><p><strong>Source theme, in contemporary language:</strong> God can use faithful work in changing places and roles. Calling is expressed through attention to the people before us, responsible labor, and willingness to enter a new task when love requires it.</p><p><strong>Reflect:</strong> Which responsibility in your present place deserves fuller attention? Consider whether faithfulness means staying, changing course, asking for help, or beginning a neglected task.</p><p><strong>Prayer:</strong> Lord, guide my work and my decisions. Help me recognize the good you have prepared and serve wholeheartedly wherever you place me. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "<p><strong>Read:</strong> Romans 12:12-13; James 5:16.</p><p><strong>Historical context:</strong> Canon Edward Hoare's funeral sermon remembers Storr visiting homes, teaching young people, supporting mission work, praying with others, and preaching in Brenchley. These are local memories rather than a model restricted to clergy.</p><p><strong>Source theme, in contemporary language:</strong> Christian care joins presence with prayer. Listening, visiting, teaching, sharing resources, and bringing needs before God are ways the whole church can strengthen people over time.</p><p><strong>Reflect:</strong> Who would be helped by your steady presence? Choose a person to contact, a need to pray for, and one practical way to remain available.</p><p><strong>Prayer:</strong> God of compassion, make me present to people who need care. Deepen my prayer, patience, and willingness to share. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "<p><strong>Read:</strong> Romans 1:16; Titus 3:4-7.</p><p><strong>Historical context:</strong> Hoare identifies the gospel of grace in Jesus Christ as the center of Storr's preaching. The sermon uses nineteenth-century Evangelical formulas; this reading restates its central confession in shared Christian language.</p><p><strong>Source theme, in contemporary language:</strong> Salvation begins in God's mercy, is accomplished through Jesus Christ, and brings new life through the Holy Spirit. Grace frees believers from boasting and forms them for faithful living and hope.</p><p><strong>Reflect:</strong> Are you treating God's acceptance as something you must earn, or grace as permission to remain unchanged? Receive mercy and ask where renewed life should become visible.</p><p><strong>Prayer:</strong> Father, thank you for saving mercy given through Jesus Christ and renewed in us by the Holy Spirit. Keep me humble, grateful, and ready for good work. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "<p><strong>Read:</strong> Philippians 2:12-13; Hebrews 13:8.</p><p><strong>Historical context:</strong> After Storr's death, Hoare asked how the congregation should continue without its longtime pastor. He directed them beyond the absent leader to the continuing presence and work of Jesus.</p><p><strong>Source theme, in contemporary language:</strong> Trusted leaders may leave, retire, or die, but Jesus Christ remains. Christian maturity receives help from teachers while depending on God, who continues to work within his people.</p><p><strong>Reflect:</strong> Has a change in leadership unsettled your faith or community? Name what you have lost, then identify one practice that keeps your attention on Christ and strengthens others.</p><p><strong>Prayer:</strong> Unchanging Lord Jesus, hold your people through every transition. Work in us, keep us close to you, and help us serve one another faithfully. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "<p><strong>Read:</strong> 1 Thessalonians 4:13-14; Hebrews 10:24-25.</p><p><strong>Historical context:</strong> W. May's memorial sermon speaks to a congregation grieving a pastor who had served it for thirty-four years. Its strongest reusable counsel is to encourage one another and continue bearing witness to Christ.</p><p><strong>Source theme, in contemporary language:</strong> Christian grief is real, yet the death and resurrection of Jesus give hope. A grieving community can make room for tears while gathering, encouraging one another, and continuing works of love.</p><p><strong>Reflect:</strong> Who is carrying grief that others may have stopped noticing? Offer presence without forcing an explanation, and remind the person through patient care that they are not alone.</p><p><strong>Prayer:</strong> Risen Lord Jesus, comfort those who mourn. Make us patient companions and strengthen our shared hope in your resurrection. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "<p><strong>Read:</strong> John 10:41-42; 2 Corinthians 4:5.</p><p><strong>Historical context:</strong> May connected Storr's ministry with the Gospel's description of John the Baptist: John performed no sign, yet his testimony about Jesus proved true. The memorial's claims about Storr are treated here as local testimony.</p><p><strong>Source theme, in contemporary language:</strong> Christian witness does not need spectacle or personal greatness. Its task is to speak truthfully about Jesus and help people trust him, while admitting the witness's own limits and faults.</p><p><strong>Reflect:</strong> Do your words about faith direct attention toward Jesus or toward your own image? Choose one simple and honest way to testify to Christ through speech or service.</p><p><strong>Prayer:</strong> Lord Jesus, keep my witness honest and centered on you. Use ordinary words and actions to help others see your truth and mercy. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "<p><strong>Read:</strong> Matthew 6:6; Psalm 1:1-3.</p><p><strong>Historical context:</strong> The notes from Storr's final sermon turn from the memorial to John the Baptist. They describe hidden preparation through prayer, self-examination, Scripture, and communion with God before public ministry.</p><p><strong>Source theme, in contemporary language:</strong> Visible faithfulness grows from hidden roots. Private prayer and sustained attention to Scripture prepare believers for public responsibility without making spiritual discipline a performance.</p><p><strong>Reflect:</strong> Which hidden practice would deepen your roots: unhurried prayer, Scripture meditation, confession, or silence? Set a realistic time and place to begin.</p><p><strong>Prayer:</strong> Father, meet me in the quiet place. Root me in your word and form a life that bears good fruit in its season. Amen.</p>",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "<p><strong>Read:</strong> Luke 3:10-14; John 1:29.</p><p><strong>Historical context:</strong> Storr's sermon presents John the Baptist as a direct and practical witness. John called different hearers to repent through generosity, honesty, restraint, and justice, and he directed them to Jesus, the Lamb of God.</p><p><strong>Source theme, in contemporary language:</strong> Repentance is more than regret. It changes how people use possessions, power, speech, and work, while forgiveness and new life remain centered on Jesus rather than moral achievement.</p><p><strong>Reflect:</strong> What fruit would make your repentance concrete? Choose one repair, act of generosity, honest decision, or restraint that matches what you are asking God to change.</p><p><strong>Prayer:</strong> Lamb of God, have mercy on me and lead me into a changed life. Make my repentance honest and its fruit useful to others. Amen.</p>",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "<p><strong>Read:</strong> Matthew 11:2-6; Mark 6:27-29.</p><p><strong>Historical context:</strong> The surviving notes end with an imaginative scene about John the Baptist's execution that Scripture does not record. This reading returns to the biblical accounts of John's questions, Jesus' answer, and John's death.</p><p><strong>Source theme, in contemporary language:</strong> A faithful servant may still face questions, confinement, and loss. Jesus receives honest questions and points to the signs of God's kingdom; faithfulness rests in him rather than in invented certainty about a person's final moments.</p><p><strong>Reflect:</strong> What question or cost makes faithfulness difficult today? Bring the question directly to Jesus, attend to his words and works, and ask for courage for the next step.</p><p><strong>Prayer:</strong> Lord Jesus, receive my questions and keep me faithful when obedience is costly. Anchor my hope in your death and resurrection. Amen.</p>",
    "day_number": 11
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
    "id": "90000000-0000-0000-0000-000000000359",
    "day_number": 1,
    "references": [
      "1 John 3:18",
      "Matthew 6:3-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "day_number": 2,
    "references": [
      "2 Corinthians 12:9",
      "Psalm 119:11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "day_number": 3,
    "references": [
      "Ephesians 2:10",
      "Colossians 3:23-24"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "day_number": 4,
    "references": [
      "Romans 12:12-13",
      "James 5:16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "day_number": 5,
    "references": [
      "Romans 1:16",
      "Titus 3:4-7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "day_number": 6,
    "references": [
      "Philippians 2:12-13",
      "Hebrews 13:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "day_number": 7,
    "references": [
      "1 Thessalonians 4:13-14",
      "Hebrews 10:24-25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "day_number": 8,
    "references": [
      "John 10:41-42",
      "2 Corinthians 4:5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "day_number": 9,
    "references": [
      "Matthew 6:6",
      "Psalm 1:1-3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "day_number": 10,
    "references": [
      "Luke 3:10-14",
      "John 1:29"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "day_number": 11,
    "references": [
      "Matthew 11:2-6",
      "Mark 6:27-29"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-23 16:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-23 16:00:00+00', timestamptz '2026-10-23 16:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish the contextualized Francis Storr memorial adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-23 16:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000359'::uuid
);
