-- Two funeral-sermon plans reconstructed as Scripture-led daily devotions.
-- The local memorial settings remain explicit; sectarian polemic and claims about
-- individual final states are omitted or framed as historical testimony.
-- Existing day IDs and day numbers are preserved.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-23 14:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "Faith, Love, and Christian Witness: Eight Readings from the Nonington Sermons"
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "Life, Death, and Resurrection Hope: Seven Readings from a 1697 Funeral Sermon"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-23 14:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "Eight Scripture-led readings adapted from two sermons preached after John Pemberton Plumptre's funeral in 1864. The sequence draws out themes of grace, faith, prayer, humility, active love, redemption, and truthful witness while identifying the local memorial setting and omitting sectarian polemic."
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "Seven Scripture-led readings adapted from William Wigan's 1697 sermon after the death of Lady Elizabeth Cutts. The sequence places its reflections on mortality, faithful living, grief, and bodily resurrection in clear historical context and contemporary language."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-23 14:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "Every Believer Can Strengthen Others",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "Faith Rests on Christ",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "Prayer Nourishes Faith",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "Humility and Love Take Action",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "Let Your Life Bear Good Fruit",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "Follow the Lamb",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "Redeemed by Christ",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "Grace Produces Honest Witness",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "Number Our Days",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "Practice the Life You Desire",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "Hope Has a Name",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "Comfort Rooted in God's Love",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "Raised with Christ",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "Faithfulness Is Not Measured by Age",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "Grieve with Hope",
    "day_number": 7
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-23 14:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "<p><strong>Read:</strong> Hebrews 13:7; 1 Peter 4:10.</p><p><strong>Historical context:</strong> Herbert James preached after the 1864 funeral of John Pemberton Plumptre. He used one local Christian life as an example, while directing praise to God's grace rather than to the deceased.</p><p><strong>Source theme, in contemporary language:</strong> God gives gifts to the church for the good of others. A believer may serve through words, example, hospitality, work, or quiet faithfulness; no act of service is too small to matter.</p><p><strong>Reflect:</strong> Think of one gift, skill, or opportunity God has entrusted to you. Who could be strengthened if you used it with humility today?</p><p><strong>Prayer:</strong> God of grace, help me use what you have given me for the good of others and the honor of Jesus Christ. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "<p><strong>Read:</strong> Ephesians 2:8-9; 1 Corinthians 15:3-4.</p><p><strong>Historical context:</strong> James described Plumptre's confidence at the end of life. The sermon presents that confidence as trust in God's mercy through Christ, not as praise for human achievement.</p><p><strong>Source theme, in contemporary language:</strong> Christian hope rests on Jesus Christ, who died for our sins and was raised. Grace gives no room for boasting, yet it gives a firm foundation for trust.</p><p><strong>Reflect:</strong> When you measure your standing with God, do you lean on your record or on Christ's grace? Name one failure or fear that you need to place in his mercy.</p><p><strong>Prayer:</strong> Lord Jesus, keep my confidence in your death and resurrection. Free me from pride and from despair, and teach me to receive your grace with gratitude. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "<p><strong>Read:</strong> Philippians 4:6-7; Hebrews 11:6.</p><p><strong>Historical context:</strong> The first sermon connects sustained faith with private prayer and regular attention to Scripture. Its local memories support a wider invitation to seek God faithfully.</p><p><strong>Source theme, in contemporary language:</strong> Faith needs nourishment. Scripture directs the mind toward God's promises, and prayer brings duties, disappointments, cares, and fears into God's presence.</p><p><strong>Reflect:</strong> Which concern keeps circling in your thoughts? Turn it into a specific prayer, and choose a short passage of Scripture to revisit during the day.</p><p><strong>Prayer:</strong> Faithful God, meet me in Scripture and prayer. Guard my heart with your peace and strengthen me to trust you in what I cannot control. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "<p><strong>Read:</strong> Philippians 2:3-5; 1 John 3:18.</p><p><strong>Historical context:</strong> James remembered humility and practical love as prominent features of Plumptre's life. The sermon says these qualities came from the grace of Christ rather than personal importance.</p><p><strong>Source theme, in contemporary language:</strong> Humility makes room for Christ to be seen, and love becomes real through action. Christian care attends to both bodily needs and spiritual encouragement.</p><p><strong>Reflect:</strong> Whose needs are easy for you to overlook? Choose one concrete act of care that protects the person's dignity and expects no recognition.</p><p><strong>Prayer:</strong> Jesus, form your humility in me. Let my love move beyond kind intentions into patient and practical service. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "<p><strong>Read:</strong> Matthew 5:16; Philippians 2:15-16.</p><p><strong>Historical context:</strong> At the close of the first sermon, James urged his hearers to live faithfully in the places where God had set them. The appeal is separated here from the details of the funeral.</p><p><strong>Source theme, in contemporary language:</strong> A faithful life can leave neighbors stronger, comforted, and more attentive to Christ. Good works do not earn salvation; they bear witness to the grace already received.</p><p><strong>Reflect:</strong> If someone observed your ordinary week, where might they see the light of Christ? What habit of selfishness, delay, or indifference needs to change?</p><p><strong>Prayer:</strong> Father, make my ordinary work fruitful. Help me hold firmly to your word and serve in a way that directs gratitude to you. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "<p><strong>Read:</strong> Revelation 14:4-5; John 10:27.</p><p><strong>Historical context:</strong> Edward Hoare's second sermon begins with the symbolic vision in Revelation 14. He applies it to faithful discipleship; this reading avoids the sermon's nineteenth-century sectarian controversy.</p><p><strong>Source theme, in contemporary language:</strong> Those who belong to Jesus listen for his voice and follow him. Faithfulness includes truthfulness, wholehearted devotion, and refusal to join what draws the heart away from Christ.</p><p><strong>Reflect:</strong> Where are you tempted to follow approval, habit, or fear instead of Jesus? Identify one step of truthful obedience you can take today.</p><p><strong>Prayer:</strong> Lamb of God, keep me near your voice. Give me an undivided heart and make my words truthful and gracious. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "<p><strong>Read:</strong> 1 Peter 1:18-19; Revelation 5:9.</p><p><strong>Historical context:</strong> Hoare emphasizes redemption through Jesus while interpreting the funeral text. This devotion retains the Christ-centered confession without repeating the sermon's polemical comparisons.</p><p><strong>Source theme, in contemporary language:</strong> Jesus gave himself to redeem people for God. His saving work calls believers away from empty ways of life and into grateful worship, holiness, and love.</p><p><strong>Reflect:</strong> What pattern feels empty but familiar? Bring it honestly to Christ, and ask how gratitude for his saving love could reshape your next choice.</p><p><strong>Prayer:</strong> Lord Jesus, thank you for giving yourself for us. Turn me from empty habits and form in me a life of worship, holiness, and love. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "<p><strong>Read:</strong> Ephesians 2:8-10; Colossians 3:9-10.</p><p><strong>Historical context:</strong> The second sermon closes by joining grace, truthful character, and service. Its claims about the deceased are treated as local testimony rather than a guarantee about any person's final state.</p><p><strong>Source theme, in contemporary language:</strong> Salvation is God's gift, and the new life it creates is marked by truth and good work. Honest Christian witness neither hides sin nor pretends that moral effort replaces grace.</p><p><strong>Reflect:</strong> Is there a place where your words and actions do not agree? Ask God for courage to tell the truth, repair harm, and practice the good work prepared for you.</p><p><strong>Prayer:</strong> God of truth and grace, renew me in Christ. Make my speech honest, my repentance sincere, and my service useful to others. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "<p><strong>Read:</strong> Psalm 90:12; Numbers 23:10.</p><p><strong>Historical context:</strong> William Wigan preached in 1697 after the death of Lady Elizabeth Cutts. His opening uses the funeral occasion to remind the living that youth, status, health, and plans cannot make life secure.</p><p><strong>Source theme, in contemporary language:</strong> Awareness of mortality can teach wisdom. Preparing to die is not gloomy speculation; it means learning to live before God with faith, repentance, love, and readiness.</p><p><strong>Reflect:</strong> If you received today as a limited gift, what would deserve more attention? What resentment, neglected duty, or delayed kindness should you address?</p><p><strong>Prayer:</strong> Eternal God, teach me to number my days. Make me ready to meet you by helping me live faithfully and lovingly today. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "<p><strong>Read:</strong> Micah 6:8; James 1:22.</p><p><strong>Historical context:</strong> Wigan reflects on Balaam's wish to share the end of the righteous while warning that a good wish without a changed path is insufficient.</p><p><strong>Source theme, in contemporary language:</strong> A faithful end cannot be separated from a life that hears and obeys God. Hope should take shape in justice, mercy, humility, and steady practice.</p><p><strong>Reflect:</strong> Which Christian conviction do you admire but rarely practice? Choose one action that makes your desire visible today.</p><p><strong>Prayer:</strong> Lord, keep my faith from remaining only a wish. Teach me to do justice, love mercy, and walk humbly with you. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "<p><strong>Read:</strong> John 11:25-26; 2 Corinthians 5:1.</p><p><strong>Historical context:</strong> The sermon surveys human arguments about death, then turns to the Christian hope announced in Scripture. This adaptation centers that hope directly on Jesus.</p><p><strong>Source theme, in contemporary language:</strong> Christian hope is more than a general belief that the soul continues. Jesus is the resurrection and the life, and believers entrust both life and death to him.</p><p><strong>Reflect:</strong> What fear rises when you think about death or loss? Speak that fear plainly to Christ, and answer it with his promise of resurrection life.</p><p><strong>Prayer:</strong> Jesus Christ, resurrection and life, hold me when I am afraid. Keep my hope in you and comfort all who grieve. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "<p><strong>Read:</strong> Romans 8:38-39; Psalm 23:4.</p><p><strong>Historical context:</strong> Wigan contrasts fragile worldly comforts with the promises of Scripture. His sermon addresses a particular congregation, while its call to seek lasting comfort remains useful.</p><p><strong>Source theme, in contemporary language:</strong> Possessions, reputation, and even beloved companions cannot pass through death with us. God's presence and love in Christ remain trustworthy in the darkest valley.</p><p><strong>Reflect:</strong> Which temporary support are you asking to carry more weight than it can bear? Receive it gratefully, but place your deepest confidence in God's lasting love.</p><p><strong>Prayer:</strong> God of all comfort, walk with me through every dark valley. Root my heart in the love from which nothing can separate us. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "<p><strong>Read:</strong> 1 Corinthians 15:20-23; Philippians 3:20-21.</p><p><strong>Historical context:</strong> The sermon speaks of the body resting in hope and points to Jesus as the firstfruits of the resurrection. Its older language is restated here as a clear Christian confession.</p><p><strong>Source theme, in contemporary language:</strong> Because Jesus truly rose from the dead, Christian hope includes the resurrection of the body. Death is an enemy, but it will not have the final word over those who belong to Christ.</p><p><strong>Reflect:</strong> How does bodily resurrection change the way you regard aging, sickness, burial, or care for another person's body? Let hope lead to tenderness rather than denial.</p><p><strong>Prayer:</strong> Risen Lord Jesus, thank you that death will not have the final word. Sustain the sick, comfort the grieving, and keep us faithful in hope. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "<p><strong>Read:</strong> Ecclesiastes 12:1; 1 Timothy 4:12.</p><p><strong>Historical context:</strong> Lady Cutts died at about eighteen, and Wigan remembered the faith and service shown in her short life. This devotion keeps the lesson while avoiding idealized claims about her rank or gender.</p><p><strong>Source theme, in contemporary language:</strong> A life need not be long to bear faithful fruit. Young believers can serve through speech, conduct, love, faith, and purity, while every generation can learn from their example.</p><p><strong>Reflect:</strong> Do you dismiss your own contribution because of age, inexperience, or limited time? What faithful action is possible with the life and opportunity you have now?</p><p><strong>Prayer:</strong> Creator, receive every season of my life. Help me serve without waiting for a more impressive age, role, or opportunity. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "<p><strong>Read:</strong> 1 Thessalonians 4:13-14; Romans 14:8.</p><p><strong>Historical context:</strong> The sermon closes by addressing Lady Cutts's family and congregation. It honors real sorrow while grounding Christian hope in the death and resurrection of Jesus.</p><p><strong>Source theme, in contemporary language:</strong> Christian grief is still grief, yet it is not without hope. Whether we live or die, we belong to the Lord, and those who die in Christ await the resurrection.</p><p><strong>Reflect:</strong> Make room for grief without forcing quick explanations. What memory, loss, or person do you need to entrust to the Lord with both sorrow and hope?</p><p><strong>Prayer:</strong> Lord of the living and the dead, receive our tears. Keep us in Christ, comfort those who mourn, and strengthen our hope in the resurrection. Amen.</p>",
    "day_number": 7
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
    "id": "90000000-0000-0000-0000-000000000387",
    "day_number": 1,
    "references": [
      "Hebrews 13:7",
      "1 Peter 4:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "day_number": 2,
    "references": [
      "Ephesians 2:8-9",
      "1 Corinthians 15:3-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "day_number": 3,
    "references": [
      "Philippians 4:6-7",
      "Hebrews 11:6"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "day_number": 4,
    "references": [
      "Philippians 2:3-5",
      "1 John 3:18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "day_number": 5,
    "references": [
      "Matthew 5:16",
      "Philippians 2:15-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "day_number": 6,
    "references": [
      "Revelation 14:4-5",
      "John 10:27"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "day_number": 7,
    "references": [
      "1 Peter 1:18-19",
      "Revelation 5:9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "day_number": 8,
    "references": [
      "Ephesians 2:8-10",
      "Colossians 3:9-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "day_number": 1,
    "references": [
      "Psalm 90:12",
      "Numbers 23:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "day_number": 2,
    "references": [
      "Micah 6:8",
      "James 1:22"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "day_number": 3,
    "references": [
      "John 11:25-26",
      "2 Corinthians 5:1"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "day_number": 4,
    "references": [
      "Romans 8:38-39",
      "Psalm 23:4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "day_number": 5,
    "references": [
      "1 Corinthians 15:20-23",
      "Philippians 3:20-21"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "day_number": 6,
    "references": [
      "Ecclesiastes 12:1",
      "1 Timothy 4:12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "day_number": 7,
    "references": [
      "1 Thessalonians 4:13-14",
      "Romans 14:8"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-23 14:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-23 14:00:00+00', timestamptz '2026-10-23 14:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish two contextualized funeral-sermon adaptations.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-23 14:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000387'::uuid,
  '90000000-0000-0000-0000-000000000395'::uuid
);
