-- Twenty-seven devotional readings newly authored from themes in A. W. Tozer's The Pursuit of God.
-- The source-based editorial paraphrases are attributed and are not verbatim quotations.
-- Existing day IDs, day numbers, total_days, and source URL remain unchanged.
-- Publication is authorized after source, editorial, and distribution review.

begin;

-- Check the existing 27-day sequence before changing any records.
do $$
declare
  present_days integer;
  first_day integer;
  last_day integer;
  source_link text;
  reported_total integer;
begin
  select source_url, total_days into source_link, reported_total
  from public.devotional_plans where id = '90000000-0000-0000-0000-000000000248'::uuid;
  if not found then
    raise exception 'Plan 248 is missing';
  end if;
  if source_link is distinct from 'https://www.gutenberg.org/ebooks/25141' or reported_total <> 27 then
    raise exception 'Plan 248 source URL or total_days differs from the reviewed seed';
  end if;
  select count(*), min(day_number), max(day_number)
  into present_days, first_day, last_day
  from public.devotional_days where plan_id = '90000000-0000-0000-0000-000000000248'::uuid;
  if present_days <> 27 or first_day <> 1 or last_day <> 27 then
    raise exception 'Plan 248 must have exactly 27 numbered days (found %)', present_days;
  end if;
end
$$;

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-25 19:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Seeking God: 27 Devotional Readings Inspired by A. W. Tozer"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-25 19:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Twenty-seven contemporary devotional reflections inspired by themes in A. W. Tozer’s The Pursuit of God (1948). Each reading includes a Scripture focus, a labeled source-based editorial paraphrase, an original reflection, and an original prayer. These are newly written adaptations, not quotations from Tozer. The linked book remains available for reading in full."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-25 19:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "A Heart That Seeks God",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "God Takes the First Step",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Blessed Are the Poor in Spirit",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "The Cross and the Clinging Self",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Trust When the Future Is Unclear",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Receiving Without Possessing",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Created for Communion",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Welcome into God’s Presence",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "An Undivided Heart",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Lay Aside What Separates",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Faith Beyond What We See",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Attend to the Unseen",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "God Is Present Here",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Drawing Near in Relationship",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Recovering the Practice of Listening",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "The God Who Speaks",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Listen with Discernment",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Look to Christ and Live",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Faith Fixes Its Gaze",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Knowing God, Not Only Knowing About Him",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "A Godward Life",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Choosing Whose Approval Matters",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "The Freedom of Meekness",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Rest for the Burdened",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "The Courage to Be Genuine",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Everyday Work as Worship",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "All of Life Before God",
    "day_number": 27
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-25 19:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Hosea 6:3. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer begins with the conviction that knowing correct ideas about God is not the same as enjoying communion with God. He invites spiritually hungry people to seek God himself.</p><p><strong>Reflect:</strong> Knowledge matters, but information is not the destination of faith. Think about the difference between describing a friendship and actually spending time with a friend. Give God your honest attention today, even if your prayer feels ordinary.</p><p><strong>Prayer:</strong> Lord, awaken a sincere desire to know you. Let what I learn become trust, worship, and love. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Psalm 63:8. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer describes the human longing for God as a response to grace already at work. The soul follows because God has first drawn near.</p><p><strong>Reflect:</strong> Seeking God is not a contest in which we earn his interest. Grace frees us to approach him without pretending that our efforts are impressive. Where have you noticed invitations to return to prayer, Scripture, or love?</p><p><strong>Prayer:</strong> Gracious God, thank you for seeking me before I knew how to seek you. Help me respond with trust and attention. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Matthew 5:3. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Reflecting on Jesus’ beatitude, Tozer argues that a possessive heart can cling to things so tightly that it struggles to receive the kingdom freely.</p><p><strong>Reflect:</strong> Spiritual poverty is not a command to neglect real needs or romanticize material hardship. It is a posture that refuses to make possessions, status, or self-sufficiency the foundation of identity. Name one attachment you can hold more lightly.</p><p><strong>Prayer:</strong> Father, free my heart from the need to own or control everything. Teach me to receive your gifts with gratitude. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Luke 9:23. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer turns from the desire for God to the struggle with self-centeredness. He connects the surrender of self-rule to Jesus’ call to take up the cross.</p><p><strong>Reflect:</strong> Following Jesus can require costly honesty about motives, pride, and control. It does not mean accepting abuse or losing the dignity God gives you. Today, consider one choice where love can take priority over the urge to be right.</p><p><strong>Prayer:</strong> Jesus, expose selfish patterns without crushing my hope. Give me courage to choose your way of humble love. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Genesis 22:1–14. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer uses Abraham and Isaac to consider the painful distinction between receiving a beloved gift and trying to possess it absolutely.</p><p><strong>Reflect:</strong> This difficult biblical narrative must not be used to justify harm to children or obedience to dangerous demands. The Christian lesson here is to bring fear and attachment before God while remembering that God provides. Entrust a worry to him without abandoning responsible care.</p><p><strong>Prayer:</strong> God of mercy, help me trust you while protecting those entrusted to my care. Guide my choices with wisdom and compassion. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read James 1:17. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: After reflecting on Abraham, Tozer emphasizes that surrendered trust does not make ordinary good gifts worthless. It changes how they are held.</p><p><strong>Reflect:</strong> You can cherish family, work, and resources without letting them define your worth. Gratitude notices their goodness; trust remembers that none can carry the weight of being God. Thank him for one gift and consider how to steward it well.</p><p><strong>Prayer:</strong> Generous Father, keep me grateful without becoming possessive. Help me use your gifts for love and service. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Psalm 42:1–2. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer describes humanity as made for God and restless when religious knowledge is separated from fellowship with him.</p><p><strong>Reflect:</strong> The longing for meaning may become especially vivid in success, loneliness, or disappointment. You do not need to manufacture an intense emotion to pray. Begin by naming your actual desire, however faint, and bringing it before God.</p><p><strong>Prayer:</strong> Living God, meet me in my restlessness. Turn my questions and longings toward your faithful presence. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Hebrews 10:19–22. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer moves from the image of the temple veil to the promise of access to God through Jesus Christ. He draws on historic Christian confession in describing the triune God.</p><p><strong>Reflect:</strong> Christian confidence in prayer is grounded in Christ, not in achieving a particular spiritual feeling. Approach God with reverence and freedom. The invitation is to draw near with a sincere heart, not to measure yourself against someone else’s experience.</p><p><strong>Prayer:</strong> Lord Jesus, thank you for opening the way to the Father. Teach me to come near in faith and humility. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Psalm 34:8. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer reflects on worship that engages the whole person and on the difference between merely discussing God and actually responding to him.</p><p><strong>Reflect:</strong> Worship may include joy, silence, grief, or awe. No single emotional expression proves stronger faith. Set aside a few moments to praise God for a concrete kindness you have received or witnessed.</p><p><strong>Prayer:</strong> Holy Spirit, draw my thoughts and affections toward the goodness of God. Make my worship sincere. Amen.</p>",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Hebrews 12:1–2. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Using the image of a veil within the human heart, Tozer identifies habits of self-protection and pride that obstruct attention to God.</p><p><strong>Reflect:</strong> Growth often means releasing resentment, performance, or an insistence on control. This is not a call to erase healthy boundaries; it is an invitation to let God examine what keeps us from loving well. Ask what you need to confess, repair, or release.</p><p><strong>Prayer:</strong> Merciful God, show me what hinders love. Give me courage to repent and receive your forgiveness. Amen.</p>",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read John 14:21–23. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer argues that faith involves living awareness of God, not only agreement with statements about him. He connects this awareness with love and obedience.</p><p><strong>Reflect:</strong> Feelings of closeness can fluctuate, but faithfulness is not measured by constant spiritual sensation. Love of Christ becomes visible in everyday obedience: truthfulness, patience, justice, and mercy. Choose one small act that reflects his teaching.</p><p><strong>Prayer:</strong> Christ, form in me a faithful love that continues even when my feelings change. Amen.</p>",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read 2 Corinthians 4:18. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer contrasts the force of what the senses constantly report with the reality of God, whom faith learns to trust.</p><p><strong>Reflect:</strong> The visible world is real and good; faith does not require denying evidence or daily responsibilities. Instead, Scripture invites us to see more than what appears immediately urgent. Take a moment to assess a worry in the light of God’s enduring promises.</p><p><strong>Prayer:</strong> God of truth, teach me to face the world clearly and to trust what you have promised beyond my sight. Amen.</p>",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Psalm 139:7–10. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer presents divine presence as more than a doctrine about the universe: God is not absent from the places in which his creatures live and act.</p><p><strong>Reflect:</strong> God’s nearness is not limited to sanctuaries or emotionally powerful moments. Even routine work can become a place of gratitude, conscience, and prayer. Pause during one ordinary task today to remember that you are not beyond God’s care.</p><p><strong>Prayer:</strong> Ever-present Lord, help me recognize your care in ordinary places and respond with reverent love. Amen.</p>",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read James 4:8. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer explains that spiritual distance is not measured in miles. Scripture’s language of nearness points to attention, trust, repentance, and relationship.</p><p><strong>Reflect:</strong> Two people can share a room while remaining emotionally distant; relationships require honest engagement. In prayer, you need not hide doubts or failures. Draw near to God with sincerity, and take a concrete step toward reconciliation where it is appropriate and safe.</p><p><strong>Prayer:</strong> Father, teach me to seek you with an open heart. Lead me into truth, repentance, and renewed trust. Amen.</p>",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read John 1:1–5. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer criticizes religious busyness that neglects attentive worship and introduces the theme of God’s living Word.</p><p><strong>Reflect:</strong> Activity can serve God, but activity alone cannot replace listening. Before beginning the next task, read a few verses slowly and ask what they reveal about Christ. Resist treating quiet as a test you must pass.</p><p><strong>Prayer:</strong> Living Word, interrupt my distracted habits. Help me listen carefully and act on what is true. Amen.</p>",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Hebrews 1:1–2. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer emphasizes that God is not a distant author who delivered a message and withdrew. God’s revelation calls for an ongoing response from those who hear it.</p><p><strong>Reflect:</strong> Christians discern God’s guidance through Scripture, prayer, wisdom, and accountable community. Not every spontaneous thought is God’s voice. Receive Scripture with humility, and test your conclusions rather than mistaking certainty for faith.</p><p><strong>Prayer:</strong> God who has spoken through your Son, shape my judgment by your truth and lead me in wisdom. Amen.</p>",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read John 10:27. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer reflects on a divine call that can be overlooked amid noise and preoccupation, and turns toward the discipline of faith.</p><p><strong>Reflect:</strong> Cultivate attention without assuming every beautiful impulse is a divine message. Read Jesus’ words in context, ask wise questions, and notice where love and truth lead. Silence can create space for discernment, but it is not an achievement in itself.</p><p><strong>Prayer:</strong> Good Shepherd, help me recognize what accords with your teaching and follow faithfully. Amen.</p>",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read John 3:14–15. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer links the lifted serpent in Numbers with Jesus’ explanation that the Son of Man would be lifted up. The biblical image becomes an invitation to trust Christ.</p><p><strong>Reflect:</strong> Saving faith is not sustained by obsessively measuring your spiritual progress. Its center is Jesus Christ, crucified and risen. When anxiety turns your attention inward, return to the promises of the gospel and ask for help to trust them.</p><p><strong>Prayer:</strong> Jesus, turn my anxious gaze from myself toward your mercy and saving love. Amen.</p>",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Hebrews 12:2. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer develops the biblical image of looking as a way to describe steady reliance on Christ rather than constant self-inspection.</p><p><strong>Reflect:</strong> Attention shapes what we love. Looking to Jesus means remembering his character and following his teaching, not ignoring circumstances or practical responsibilities. Let one Gospel scene guide your response to a challenge today.</p><p><strong>Prayer:</strong> Lord Jesus, steady my attention on you. Form my actions by your compassion and truth. Amen.</p>",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read John 17:3. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer describes eternal life as knowing God and Jesus Christ, while challenging a faith reduced to ideas or institutional habit.</p><p><strong>Reflect:</strong> Sound teaching and lived communion belong together. Personal experience needs Scripture and the church’s wisdom, while doctrine should lead toward worship and love. Consider one belief you can embody in a concrete act of kindness.</p><p><strong>Prayer:</strong> Father, deepen my knowledge of you through your Son. Let truth become love in action. Amen.</p>",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Psalm 57:5. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer considers what happens when attention to God becomes a settled habit rather than an occasional religious exercise.</p><p><strong>Reflect:</strong> Habits grow through repetition more than dramatic resolutions. Brief prayer before work, gratitude at meals, and examination at day’s end can help orient the heart. Begin with one sustainable practice rather than promising a perfect routine.</p><p><strong>Prayer:</strong> Triune God, become the center of my ordinary days. Help me return to you whenever my attention wanders. Amen.</p>",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Galatians 1:10. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer questions the social pressure to prize public admiration above faithfulness to God.</p><p><strong>Reflect:</strong> Approval is not always wrong: wise correction and community support matter. The danger comes when praise controls our conscience. Before making a decision, ask whether it is truthful and loving even if nobody applauds.</p><p><strong>Prayer:</strong> Lord, free me from living for applause. Make me teachable, courageous, and faithful when choices are difficult. Amen.</p>",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Matthew 5:5. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer turns to Jesus’ blessing on the meek and treats humility as liberation from the constant need to defend one’s importance.</p><p><strong>Reflect:</strong> Meekness is not weakness or permission for others to mistreat you. It is strength that does not need to dominate. Practice responding to disagreement with clarity and calm, while keeping healthy boundaries.</p><p><strong>Prayer:</strong> Gentle Savior, teach me the strength of humility. Make me firm in truth and generous toward others. Amen.</p>",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Matthew 11:28–30. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer connects Christ’s invitation to rest with the exhausting burdens of pride, comparison, and self-importance.</p><p><strong>Reflect:</strong> Jesus does not ask us to deny real pain or avoid necessary work. His invitation gives weary people a different way to carry life’s responsibilities. Name one burden, share it in prayer, and seek trustworthy practical help where needed.</p><p><strong>Prayer:</strong> Jesus, receive what has become too heavy for me. Teach me to walk in your gentleness and find rest. Amen.</p>",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Matthew 6:1–6. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer describes the burden of artificiality: the exhausting attempt to appear spiritually impressive to others.</p><p><strong>Reflect:</strong> We do not have to curate a flawless religious image. Integrity brings private life and public life into closer agreement. Instead of performing holiness, practice one unnoticed act of faithfulness today.</p><p><strong>Prayer:</strong> Father who sees in secret, replace pretence with honesty. Teach me to serve without needing attention. Amen.</p>",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read 1 Corinthians 10:31. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer argues that the distinction between supposedly sacred activities and everyday work can obscure the possibility of honoring God in ordinary duties.</p><p><strong>Reflect:</strong> Preparing food, writing code, repairing a tool, studying, or caring for someone can express love and integrity. Not every task is automatically good; the way we do it matters. Ask whom your work serves and how to do it conscientiously.</p><p><strong>Prayer:</strong> Lord, receive the work of my hands today. Help me act with skill, honesty, and care for others. Amen.</p>",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Colossians 3:17. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer closes by challenging the idea that only certain places, jobs, or moments belong to God. He invites the believer to live every part of life in conscious dedication to him.</p><p><strong>Reflect:</strong> Places of worship have a special communal purpose, but God is not confined to them. Carry prayer into rest, relationships, service, and responsible decision-making. End this plan by naming one practice you will continue after day twenty-seven.</p><p><strong>Prayer:</strong> God of all life, teach me to honor you in every place. May my worship become patience, gratitude, justice, and love. Through Jesus Christ, amen.</p>",
    "day_number": 27
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
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 1,
    "references": [
      "Hosea 6:3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 2,
    "references": [
      "Psalm 63:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 3,
    "references": [
      "Matthew 5:3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 4,
    "references": [
      "Luke 9:23"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 5,
    "references": [
      "Genesis 22:1–14"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 6,
    "references": [
      "James 1:17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 7,
    "references": [
      "Psalm 42:1–2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 8,
    "references": [
      "Hebrews 10:19–22"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 9,
    "references": [
      "Psalm 34:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 10,
    "references": [
      "Hebrews 12:1–2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 11,
    "references": [
      "John 14:21–23"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 12,
    "references": [
      "2 Corinthians 4:18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 13,
    "references": [
      "Psalm 139:7–10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 14,
    "references": [
      "James 4:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 15,
    "references": [
      "John 1:1–5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 16,
    "references": [
      "Hebrews 1:1–2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 17,
    "references": [
      "John 10:27"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 18,
    "references": [
      "John 3:14–15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 19,
    "references": [
      "Hebrews 12:2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 20,
    "references": [
      "John 17:3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 21,
    "references": [
      "Psalm 57:5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 22,
    "references": [
      "Galatians 1:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 23,
    "references": [
      "Matthew 5:5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 24,
    "references": [
      "Matthew 11:28–30"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 25,
    "references": [
      "Matthew 6:1–6"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 26,
    "references": [
      "1 Corinthians 10:31"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 27,
    "references": [
      "Colossians 3:17"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-25 19:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-25 19:00:00+00', timestamptz '2026-10-25 19:00:00+00');
    end if;
  end loop;
end
$$;

-- Publish the reviewed Tozer-theme adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-25 19:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000248'::uuid
);

commit;
