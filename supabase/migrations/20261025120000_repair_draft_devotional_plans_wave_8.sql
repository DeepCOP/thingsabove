-- One 1626 funeral sermon reconstructed as fifteen Scripture-led daily devotions.
-- The historical setting remains explicit; degrading gender claims, restrictive social
-- assumptions, and claims about an individual's final state are omitted or corrected.
-- Existing day IDs and day numbers are preserved.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-25 12:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Reverence, Grace, and Faithful Living: Fifteen Readings from a 1626 Funeral Sermon"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-25 12:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Fifteen Scripture-led readings adapted from Hannibal Gamon's 1626 funeral sermon for Lady Frances Roberts. The sequence retains themes of reverence, equal dignity in Christ, practical love, perseverance, repentance, grief, and new life through Jesus while identifying the historical setting and setting aside degrading gender claims, restrictive social assumptions, and speculation about any person's final state."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-25 12:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "God Brings Hearts to Light",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Character Outlasts Appearance",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "One in Christ and One in Need of Grace",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Love Takes Responsibility",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Reverence Rooted in Adoption",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Grace Holds Us as We Persevere",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Reverence Without Anxiety",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Repentance Opens a New Way",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Praise the Grace of God",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Grieve and Remember Truthfully",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Leave Final Praise to God",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Treasures in Ordinary Vessels",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "United with Christ Against Sin",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Repentance Repairs Relationships",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Hear the Word and Practice It",
    "day_number": 15
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-25 12:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> 1 Corinthians 4:5; Psalm 139:23-24.</p><p><strong>Historical context:</strong> Hannibal Gamon preached this sermon at the 1626 funeral of Lady Frances Roberts in Cornwall. He opened by warning that final judgment belongs to God, even as he prepared to commend her life.</p><p><strong>Source theme, in contemporary language:</strong> Human praise cannot reveal every motive, and a funeral should not pretend to know what only God knows. We can remember visible faithfulness while entrusting hidden hearts and final judgment to the Lord.</p><p><strong>Reflect:</strong> Where are you tempted either to idealize someone or to judge a motive you cannot see? Name what you truly know, release what you do not know, and invite God to search your own heart.</p><p><strong>Prayer:</strong> God of truth, guard me from flattery and harsh judgment. Bring my heart into your light and form integrity within me. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> Proverbs 31:30; 1 Samuel 16:7.</p><p><strong>Historical context:</strong> The sermon contrasts beauty, wealth, rank, and intelligence with a life oriented toward God. Its praise of Lady Frances is tied to seventeenth-century social expectations that this adaptation does not repeat.</p><p><strong>Source theme, in contemporary language:</strong> Appearance and status are temporary measures of worth. God looks at the heart, and reverence for him becomes visible through humble, truthful, and loving character.</p><p><strong>Reflect:</strong> Which outward measure most influences how you value yourself or another person? Choose one way to notice and encourage Christlike character instead.</p><p><strong>Prayer:</strong> Lord, free me from judging by appearance, wealth, influence, or rank. Shape in me the inner beauty of humility and love. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> Galatians 3:27-28; Romans 3:22-24.</p><p><strong>Historical context:</strong> Gamon says women and men alike stand under sin and can receive grace, yet he also repeats old claims about female weakness. This reading retains the equality he acknowledges and rejects those degrading assumptions.</p><p><strong>Source theme, in contemporary language:</strong> Every person bears equal dignity before God, every person needs mercy, and all who belong to Christ share one baptismal identity. No sex, class, or social rank creates spiritual superiority.</p><p><strong>Reflect:</strong> Where might a stereotype be shaping your expectations of another believer? Listen to the person's gifts and experience, and practice the equal honor given in Christ.</p><p><strong>Prayer:</strong> Father, thank you that we are one in Christ Jesus. Forgive my prejudice and teach me to honor the dignity and gifts of every person. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> Romans 12:9-13; Galatians 6:10.</p><p><strong>Historical context:</strong> The sermon describes care for children, relatives, household workers, neighbors, and people in need through the duties assigned to a woman of rank in 1626. This devotion applies the call to every Christian.</p><p><strong>Source theme, in contemporary language:</strong> Reverence for God produces practical love: providing what is needed, teaching by example, honoring others, sharing resources, welcoming people, and refusing contempt.</p><p><strong>Reflect:</strong> Which relationship or responsibility have you treated as beneath your attention? Choose one concrete act of honor, provision, hospitality, or help.</p><p><strong>Prayer:</strong> God of steadfast love, make my care practical and sincere. Help me notice needs, share generously, and honor others without pride. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> Romans 8:15-16; Deuteronomy 10:12-13.</p><p><strong>Historical context:</strong> Gamon distinguishes loving reverence for God from fear based only on punishment. He connects faithful obedience with God's mercy and the Spirit of adoption.</p><p><strong>Source theme, in contemporary language:</strong> The fear of the Lord is not servile terror. God's children approach their holy Father with awe, love, trust, and a desire to walk in ways that give life.</p><p><strong>Reflect:</strong> Does your view of God lead mainly to hiding, or to honest reverence and trust? Bring one failure into the light and receive the Spirit's assurance that calls you back to faithful living.</p><p><strong>Prayer:</strong> Holy Father, free me from fear that drives me away from you. By your Spirit, deepen my trust, reverence, and willing obedience. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> 1 Peter 1:3-5; Hebrews 7:25.</p><p><strong>Historical context:</strong> The sermon gathers many biblical texts about perseverance, Christ's intercession, and God's keeping power. Dense Latin notes and disputed applications obscure that devotional center in the original day.</p><p><strong>Source theme, in contemporary language:</strong> Believers persevere because God's mercy gives new birth, Jesus intercedes, and God's power guards hope. Faith responds through steady trust rather than confidence in personal strength.</p><p><strong>Reflect:</strong> Where are you tired of continuing in faithfulness? Ask for the next measure of grace, and let a trusted believer know where you need prayer and encouragement.</p><p><strong>Prayer:</strong> Faithful God, keep me through weariness and temptation. Thank you that Jesus intercedes for us; strengthen me to continue in hope. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> 1 John 4:18; 2 Timothy 1:7.</p><p><strong>Historical context:</strong> Gamon compares healthy reverence with distorted fear, but his extended argument can blur the difference between devotion and anxiety. This reading states that distinction directly.</p><p><strong>Source theme, in contemporary language:</strong> Godly reverence draws us toward truth, love, and obedience. Fear that traps us in panic, imagined threats, or submission to human control does not reflect the Spirit of power, love, and self-control.</p><p><strong>Reflect:</strong> Which fear is guiding a decision: reverence for God, fear of another person's reaction, or anxious imagination? Seek wise counsel and choose the path shaped by truth and love.</p><p><strong>Prayer:</strong> God of peace, steady my mind and free me from controlling fear. Give me power, love, self-control, and reverence for you. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> Proverbs 14:27; Acts 3:19.</p><p><strong>Historical context:</strong> The sermon calls reverence for God a fountain of life because it turns people from sins already committed and strengthens resistance to temptation. Its older threats are reframed through the biblical invitation to repent.</p><p><strong>Source theme, in contemporary language:</strong> Repentance is a grace-filled turn toward God. It names sin honestly, receives mercy, changes direction, and learns practices that protect new life.</p><p><strong>Reflect:</strong> What pattern needs more than regret? Name the turn you need to make, the repair you owe, and the boundary or practice that could support a changed direction.</p><p><strong>Prayer:</strong> Merciful God, lead me to honest repentance. Blot out my sins, refresh my life in Christ, and strengthen me to resist what draws me away from you. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> 1 Corinthians 15:10; Philippians 2:13.</p><p><strong>Historical context:</strong> Gamon argues that praising a faithful person should ultimately acknowledge God's grace at work. His funeral praise is best read as testimony rather than proof of Lady Frances's final standing before God.</p><p><strong>Source theme, in contemporary language:</strong> We may give thanks for another person's faithful example without turning that person into a hero beyond criticism. Every good fruit depends on grace, and all glory returns to God.</p><p><strong>Reflect:</strong> Think of someone whose example helped you. What specific fruit can you thank God for, and how can you imitate it without idealizing the person?</p><p><strong>Prayer:</strong> God of grace, thank you for faithful examples. Keep my gratitude truthful, and produce in me the good work that honors you. Amen.</p>",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> John 11:33-36; 1 Thessalonians 4:13-14.</p><p><strong>Historical context:</strong> The funeral sermon defends public mourning and remembrance, then lists family roles through the assumptions of its period. This devotion keeps grief and gratitude together without defining a woman's worth by those roles.</p><p><strong>Source theme, in contemporary language:</strong> Jesus made room for tears, and Christian hope does not erase grief. We can remember a whole person with gratitude, sorrow, honesty, and hope grounded in Jesus' death and resurrection.</p><p><strong>Reflect:</strong> Is there a loss you have rushed past or a memory you have simplified? Make room for both gratitude and sorrow, and entrust the person to God's just and merciful care.</p><p><strong>Prayer:</strong> Lord Jesus, receive our tears and memories. Comfort those who mourn and keep our hope anchored in your resurrection. Amen.</p>",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> 1 Corinthians 4:5; Hebrews 10:35-36.</p><p><strong>Historical context:</strong> Gamon cautions against demanding praise too soon and returns to the promise that God will disclose hearts at Christ's coming. The sermon surrounds this point with classical and medieval examples.</p><p><strong>Source theme, in contemporary language:</strong> Faithfulness does not require immediate recognition. God sees work hidden from public praise, and believers can endure without controlling their reputation or issuing final verdicts about others.</p><p><strong>Reflect:</strong> Where has lack of recognition made you bitter or tempted you to advertise yourself? Offer the work to God again and seek the patience to continue doing what is right.</p><p><strong>Prayer:</strong> God who sees in secret, free me from hunger for applause. Give me endurance, honest motives, and peace in leaving final judgment to you. Amen.</p>",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> 2 Corinthians 4:7; Galatians 3:28.</p><p><strong>Historical context:</strong> Before recounting Lady Frances's actions, the sermon says God's grace can be displayed through women as fully as through men. It still speaks through assumptions of rank and gender that this adaptation sets aside.</p><p><strong>Source theme, in contemporary language:</strong> The treasure of the gospel belongs in ordinary and diverse human lives. God's power is not limited by sex, status, weakness, or social expectation, and no believer should be treated as spiritually secondary.</p><p><strong>Reflect:</strong> Whose contribution have you overlooked because of status, gender, weakness, or an unimpressive role? Make space to receive that person's gift and voice.</p><p><strong>Prayer:</strong> Lord, place the light of Christ in us and teach us to honor your treasure in every believer. Let your power be seen through our weakness. Amen.</p>",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> Romans 6:4-6; 2 Corinthians 12:9.</p><p><strong>Historical context:</strong> Gamon remembers Lady Frances struggling against a recurring sin and finding hope in Christ's death and resurrection and the sanctifying work of the Holy Spirit. The personal details remain his testimony, not an independent verdict.</p><p><strong>Source theme, in contemporary language:</strong> Union with the crucified and risen Christ brings pardon and power for change. The Holy Spirit meets weakness with grace and teaches believers to resist sin, rise after failure, and walk in new life.</p><p><strong>Reflect:</strong> Which recurring sin have you begun to treat as permanent? Bring it to Christ, identify its usual trigger, and choose one Spirit-led action that interrupts the pattern.</p><p><strong>Prayer:</strong> Crucified and risen Lord Jesus, unite me to your new life. By the Holy Spirit, meet my weakness with grace and free me from sin's rule. Amen.</p>",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> Ephesians 4:26-27; 2 Corinthians 7:10-11.</p><p><strong>Historical context:</strong> The sermon recalls Lady Frances becoming grieved by her anger and seeking change before describing her painful death. This reading keeps the call to repentance without using suffering as proof of another person's spiritual state.</p><p><strong>Source theme, in contemporary language:</strong> Godly sorrow produces a changed response. Repentance for anger includes ending retaliation, speaking truthfully, repairing harm, and refusing to let resentment settle into the heart.</p><p><strong>Reflect:</strong> Is anger still directing your words or silence toward someone? Name the harm, seek forgiveness where appropriate, and take one safe step toward truth and peace.</p><p><strong>Prayer:</strong> God of reconciliation, turn my sorrow into real change. Restrain harmful anger, help me repair what I have damaged, and lead me in peace. Amen.</p>",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> James 1:22-25; 2 Corinthians 5:10.</p><p><strong>Historical context:</strong> Gamon closes by urging listeners not to let a long funeral sermon vanish without practice. His conclusion includes severe rhetoric and speculation about judgment that are omitted here.</p><p><strong>Source theme, in contemporary language:</strong> The purpose of hearing Scripture is faithful response. Christ will judge with perfect knowledge, so believers can act now through repentance, mercy, justice, perseverance, and trust in him.</p><p><strong>Reflect:</strong> Which truth in this sequence needs to become action rather than another note? Write one specific practice, person, place, and time for your response.</p><p><strong>Prayer:</strong> Lord Jesus, make me a doer of your word. Lead me in repentance, mercy, justice, and perseverance as I await your righteous judgment. Amen.</p>",
    "day_number": 15
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
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 1,
    "references": [
      "1 Corinthians 4:5",
      "Psalm 139:23-24"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 2,
    "references": [
      "Proverbs 31:30",
      "1 Samuel 16:7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 3,
    "references": [
      "Galatians 3:27-28",
      "Romans 3:22-24"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 4,
    "references": [
      "Romans 12:9-13",
      "Galatians 6:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 5,
    "references": [
      "Romans 8:15-16",
      "Deuteronomy 10:12-13"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 6,
    "references": [
      "1 Peter 1:3-5",
      "Hebrews 7:25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 7,
    "references": [
      "1 John 4:18",
      "2 Timothy 1:7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 8,
    "references": [
      "Proverbs 14:27",
      "Acts 3:19"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 9,
    "references": [
      "1 Corinthians 15:10",
      "Philippians 2:13"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 10,
    "references": [
      "John 11:33-36",
      "1 Thessalonians 4:13-14"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 11,
    "references": [
      "1 Corinthians 4:5",
      "Hebrews 10:35-36"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 12,
    "references": [
      "2 Corinthians 4:7",
      "Galatians 3:28"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 13,
    "references": [
      "Romans 6:4-6",
      "2 Corinthians 12:9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 14,
    "references": [
      "Ephesians 4:26-27",
      "2 Corinthians 7:10-11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 15,
    "references": [
      "James 1:22-25",
      "2 Corinthians 5:10"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-25 12:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-25 12:00:00+00', timestamptz '2026-10-25 12:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish the contextualized 1626 funeral-sermon adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-25 12:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000326'::uuid
);
