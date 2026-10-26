-- Wave 25: Plan 325 — Experiments of Spiritual Life & Health (Roger Williams).
-- Original, Scripture-led editorial adaptation of all 22 supplied source segments.
-- Preserve existing plan/day IDs and all progress; publish after review.
-- Deploy AFTER the earlier 2026-10-21 modernization migrations, including part 09.
-- No copyrighted modern Bible translation is reproduced.

begin;

do $$
declare
  current_source text;
  current_total integer;
  row_count integer;
  first_day integer;
  last_day integer;
  unique_days integer;
begin
  select source_url, total_days into current_source, current_total
  from public.devotional_plans
  where id = '90000000-0000-0000-0000-000000000325'::uuid;
  if not found then raise exception 'Plan 325 is missing'; end if;
  if current_source is distinct from 'https://www.gutenberg.org/ebooks/62944' or current_total is distinct from 22 then
    raise exception 'Plan 325 source URL or total_days differs from reviewed source';
  end if;
  select count(*), min(day_number), max(day_number), count(distinct day_number)
  into row_count, first_day, last_day, unique_days
  from public.devotional_days where plan_id = '90000000-0000-0000-0000-000000000325'::uuid;
  if row_count <> 22 or first_day <> 1 or last_day <> 22 or unique_days <> 22 then
    raise exception 'Plan 325 must have 22 unique numbered days; found %', row_count;
  end if;
end
$$;

update public.devotional_plans as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "value": "Signs of Life: 22 Readings on Grace, Growth, and Spiritual Care"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "value": "Twenty-two newly written Scripture-led readings inspired by Roger Williams’s Experiments of Spiritual Life & Health, and Their Preservatives (1652). Explore assurance for fragile faith, spiritual renewal, humility, prayer, compassionate correction, and persevering hope. Historical language and judgments are placed in context. For editorial review, not a transcription of the source."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 1,
    "value": "Grace for the Weakest Heart"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 2,
    "value": "Test What Leads Toward Love"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 3,
    "value": "A Little Faith Is Still Faith"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 4,
    "value": "Renewed on the Inside"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 5,
    "value": "Learning to Call God Father"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 6,
    "value": "Help My Unbelief"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 7,
    "value": "Return to the One Who Welcomes"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 8,
    "value": "Admire Grace, Keep Growing"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 9,
    "value": "Wonder, Worship, and Quiet Prayer"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 10,
    "value": "Prayer without Performance"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 11,
    "value": "Humility That Makes Room for Obedience"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 12,
    "value": "Confession That Leads to Restoration"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 13,
    "value": "Seek Christ Beyond the Appearance"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 14,
    "value": "Contentment without Indifference"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 15,
    "value": "Let Your Words and Work Bless Others"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 16,
    "value": "Compassion Is Stronger Than Contempt"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 17,
    "value": "Correction with Gentleness and Courage"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 18,
    "value": "A Faith That Examines and Renews"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 19,
    "value": "Guard the Flame with Gentle Rhythms"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 20,
    "value": "Repentance Held in Mercy"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 21,
    "value": "Justice and Mercy in a Wounded World"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 22,
    "value": "Live Today in the Light of Hope"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 1,
    "value": "<p><strong>Read:</strong> Isaiah 42:3; Matthew 11:28-30</p><p><strong>Source and historical context:</strong> Roger Williams first wrote these reflections as a private encouragement to his wife after a dangerous illness; friends later circulated them, and an 1862 editor reintroduced the seventeenth-century work. Williams promises that even an unsure believer may find signs of spiritual life. His language of spiritual sickness is a metaphor, not a diagnosis of anyone’s medical condition.</p><p><strong>Devotional focus:</strong> Jesus does not crush a bruised reed. He invites weary people to come to him, not only the confident and accomplished. Faith can be genuine while a person is frightened, exhausted, uncertain, or still learning. A fragile beginning is not nothing. We can meet ourselves and others with the same gentleness we receive from Christ, refusing to make strength or visible achievement a condition of welcome.</p><p><strong>Reflect:</strong> Where have I treated weakness as proof that God has given up on me or someone else?</p><p><strong>Practice:</strong> Write down one small sign of hope, love, or desire for God that you have overlooked. Offer a gentle word to someone going through a difficult season.</p><p><strong>Prayer:</strong> Jesus, meet me with mercy in my frailty. Help me see your care in small beginnings and extend that care to others. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 2,
    "value": "<p><strong>Read:</strong> 1 John 4:1-3; James 3:17-18</p><p><strong>Source and historical context:</strong> In his dedication and address to readers, Williams asks people to examine spiritual claims rather than trust outward appearances. He also uses contemptuous descriptions of Indigenous communities and Muhammad, reflecting the religious hostility of his era. Those descriptions are historical prejudices and are not adopted in this devotional.</p><p><strong>Devotional focus:</strong> Christian discernment does not mean believing every confident religious voice, nor does it require suspicion or contempt toward people of other faiths. James describes heavenly wisdom as peaceable, gentle, reasonable, merciful, and sincere. These qualities help us ask whether a message encourages truth, responsibility, and love. We can test teachings with Scripture, wise counsel, and attention to their effects on vulnerable people.</p><p><strong>Reflect:</strong> What makes a spiritual claim persuasive to me: confidence, status, fear, or its consistency with Christlike love?</p><p><strong>Practice:</strong> When you encounter a powerful religious claim, pause to examine its context and consequences before repeating it. Seek a thoughtful second perspective.</p><p><strong>Prayer:</strong> God of truth, give me discernment without arrogance. Lead me toward wisdom that is sincere, gentle, and full of good fruit. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 3,
    "value": "<p><strong>Read:</strong> Matthew 5:3-6; Philippians 1:6</p><p><strong>Source and historical context:</strong> Williams reassures readers who feel their faith is small and urges more experienced believers to keep growing. The segment includes the personal letter that followed his wife’s recovery, where he offers his words as a small bouquet for her and their children. His affection is set within an intense awareness of human mortality.</p><p><strong>Devotional focus:</strong> Jesus blesses the poor in spirit, not merely those who appear spiritually strong. A longing for mercy, however faint, can be brought honestly into prayer. The same God who begins a work of grace can continue it patiently. Recovery from physical illness is not evidence of superior faith, and ongoing illness is not evidence of inferior faith. The invitation is to receive companionship and hope in whatever condition we face.</p><p><strong>Reflect:</strong> What small desire for God might I dismiss because it does not feel impressive?</p><p><strong>Practice:</strong> Pray a single honest sentence today. If someone you love is unwell, offer practical care without asking them to prove their faith.</p><p><strong>Prayer:</strong> Father, thank you that you know my heart without exaggeration. Grow what is good in me, one faithful day at a time. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 4,
    "value": "<p><strong>Read:</strong> 2 Corinthians 4:16-18; Romans 8:38-39</p><p><strong>Source and historical context:</strong> Continuing the letter to his wife, Williams distinguishes bodily frailty from the renewal of the inner person. He also differentiates weakness, spiritual struggle, and outright loss of faith. His seventeenth-century imagery describes spiritual life as health and illness; it should not be used to blame, diagnose, or shame people experiencing actual sickness.</p><p><strong>Devotional focus:</strong> Paul writes that the inner person can be renewed day by day even while the outward person is worn by hardship. This promise does not erase pain or require constant cheerfulness. It says that suffering and decline do not have the final word about our relationship with God. Growth may look like asking for help, choosing one truthful response, or returning after a difficult day. God’s love is not canceled by our limitations.</p><p><strong>Reflect:</strong> How might I recognize renewal without demanding immediate relief, perfect emotions, or constant productivity?</p><p><strong>Practice:</strong> Take five minutes to acknowledge a burden and a source of support. Reach out for practical assistance if your body or mind needs it.</p><p><strong>Prayer:</strong> Lord, renew me where I am weary. Teach me to honor my limits while remaining open to your sustaining presence. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 5,
    "value": "<p><strong>Read:</strong> Galatians 4:6-7; 1 Peter 2:2-3</p><p><strong>Source and historical context:</strong> Williams begins his signs of spiritual life with the believer’s relationship to God as Father. He then describes the desire to learn and the hunger for Scripture and faithful instruction. Though he contrasts authentic believers with hypocrites in severe terms, his starting point is the tenderness of a child reaching toward a trusted parent.</p><p><strong>Devotional focus:</strong> A new believer does not need to master every question to begin trusting God. In Galatians, the Spirit enables God’s children to cry out as sons and daughters. That cry may be as simple as a request for help. Like infants who need nourishment to grow, disciples learn through repeated attention, questions, community, and Scripture. Curiosity is not disloyalty; honest learning can be an expression of love.</p><p><strong>Reflect:</strong> What question about God have I avoided because I feared it would make my faith look weak?</p><p><strong>Practice:</strong> Read the Scripture passage slowly and write one honest question. Share it with a trustworthy mentor or explore its context.</p><p><strong>Prayer:</strong> Abba, Father, receive my questions and my need. Give me patience to learn and courage to keep drawing near. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 6,
    "value": "<p><strong>Read:</strong> Mark 9:23-24; Galatians 5:16-17</p><p><strong>Source and historical context:</strong> Williams names a desire to do God’s will despite repeated failure, resistance to known wrongdoing, and a willingness to seek God rather than use religion for personal gain. He recalls the father who asked Jesus to help his unbelief. This source section is concerned with inner conflict rather than the claim that mature Christians never struggle.</p><p><strong>Devotional focus:</strong> Belief and doubt can share the same prayer. The father in Mark did not hide his need from Jesus, and Jesus received his plea. The Spirit calls us away from harmful choices while also giving grace to begin again. Spiritual progress is not measured by how mercilessly we judge ourselves. It is seen in truthful confession, repair of harm, renewed dependence, and choices that become more loving over time.</p><p><strong>Reflect:</strong> Where do I need to confess both a sincere desire to follow Jesus and a real struggle?</p><p><strong>Practice:</strong> Name one behavior you want to change. Take one safe, realistic action toward repair or accountability, and ask for help where needed.</p><p><strong>Prayer:</strong> Jesus, I believe; help my unbelief. Strengthen my honesty and teach me to turn from harm toward your life-giving way. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 7,
    "value": "<p><strong>Read:</strong> Psalm 103:8-14; Hebrews 10:24-25</p><p><strong>Source and historical context:</strong> Williams continues his account of frail faith by describing acceptance of hardship, longing for worship with other believers, and distress when one’s actions rupture communion with God. His strict contrast between true children and pretenders should not make sufferers assume that every illness, loss, or anxious thought is God’s punishment.</p><p><strong>Devotional focus:</strong> Psalm 103 describes the Lord as compassionate and mindful of human frailty. Community and worship can support us, even if participation is difficult during illness, grief, disability, or isolation. When conscience reveals that we have hurt someone, we can seek forgiveness and make amends. But an anxious or painful feeling by itself is not proof of wrongdoing. Christ calls us toward reconciliation, not perpetual self-accusation.</p><p><strong>Reflect:</strong> Is there a broken relationship I can begin to repair, or a burden of guilt I need to release?</p><p><strong>Practice:</strong> If you owe someone an apology, offer it sincerely. Otherwise reach out to a safe community connection or ask someone to pray with you.</p><p><strong>Prayer:</strong> Merciful Father, lead me from fear toward truth and peace. Restore what I can repair and hold me in your compassion. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 8,
    "value": "<p><strong>Read:</strong> Hebrews 12:1-2; 2 Peter 3:18</p><p><strong>Source and historical context:</strong> Williams’s final sign of fragile spiritual life is the ability to notice and value God’s grace in other people, even when we feel unable to imitate their courage. He then turns from signs of life to signs of mature spiritual strength. He explicitly cautions readers not to confuse his coming examples of maturity with requirements for the very existence of faith.</p><p><strong>Devotional focus:</strong> We can admire another person’s faithfulness without turning their life into a weapon against ourselves. Hebrews invites believers to learn from a cloud of witnesses while fixing their eyes on Jesus. Growth happens at different speeds and in different circumstances. The strength to celebrate someone else’s good work may itself be a small grace. Gratitude gives us a path forward that comparison cannot.</p><p><strong>Reflect:</strong> Whose faithfulness inspires me, and how can I learn from it without resenting or copying their circumstances?</p><p><strong>Practice:</strong> Thank someone for a concrete act of courage or kindness. Choose one modest way to practice the same virtue in your own situation.</p><p><strong>Prayer:</strong> Lord, open my eyes to grace in others. Free me from competition and help me grow with patience and joy. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 9,
    "value": "<p><strong>Read:</strong> Psalm 8:1-9; Matthew 6:5-6</p><p><strong>Source and historical context:</strong> At the start of his second part, Williams groups maturity under holiness, righteousness, and sobriety. He begins with reverence before God, a desire to honor God in ordinary responsibilities, sincerity when unobserved, and prayer woven through daily life.</p><p><strong>Devotional focus:</strong> The heavens invite the psalmist into wonder, not self-display. Reverence can make the ordinary world astonishing again and remind us that our work is more than the pursuit of applause. Jesus encourages prayer that is sincere even when no one sees. A quiet moment of awe, a private act of honesty, or an unadvertised prayer can be a meaningful expression of love. Mature worship directs attention toward God and neighbor, not toward our religious reputation.</p><p><strong>Reflect:</strong> What small part of ordinary life invites awe, gratitude, or honest prayer today?</p><p><strong>Practice:</strong> Notice a detail of creation and give thanks. Do one good deed without announcing it to anyone.</p><p><strong>Prayer:</strong> Creator God, deepen my wonder and make my faith sincere in hidden places. Let your goodness shape my daily work. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 10,
    "value": "<p><strong>Read:</strong> Luke 11:1-13; Romans 8:26-27</p><p><strong>Source and historical context:</strong> Williams considers prayer as heartfelt communion rather than a religious performance. He observes that believers may leave prayer feeling just as heavy as when they began, while urging perseverance and honest dependence. Some of his rhetoric about hypocrites is harsh and should not be used to judge other people’s motives.</p><p><strong>Devotional focus:</strong> Jesus teaches his disciples to pray simply, and Paul says the Spirit helps us when words fail. The purpose of prayer is not to impress an audience or guarantee a particular feeling. We may pray with gratitude, confusion, grief, doubt, or silence. Persistence is not a competition over length or emotional intensity; it is the freedom to return. If we are too tired to form many words, even a brief cry for mercy is welcome.</p><p><strong>Reflect:</strong> Do I measure my prayers by how eloquent, long, or emotionally rewarding they seem?</p><p><strong>Practice:</strong> Offer a two-minute prayer with no need to perform: name one gratitude, one worry, and one person in need. Sit quietly afterward.</p><p><strong>Prayer:</strong> Holy Spirit, meet me where language ends. Teach me to pray with honesty and trust rather than striving to impress. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 11,
    "value": "<p><strong>Read:</strong> Micah 6:8; John 14:15-17</p><p><strong>Source and historical context:</strong> Williams associates spiritual maturity with humility, heartfelt desire for God, joyful obedience, and an honest response to hardships. He contrasts these with outward religious formality, and sometimes uses severe language about human unworthiness. The positive thread is a heart becoming available to God’s direction.</p><p><strong>Devotional focus:</strong> Humility is neither pretending we have no gifts nor rehearsing self-hatred. Micah describes the good life as justice, mercy, and humble walking with God. Obedience grows from love and is made visible in how we treat others. We can ask whether our routines form compassion rather than whether they make us look impressive. Even when duties feel hard, we can seek help without mistaking fatigue or grief for rebellion.</p><p><strong>Reflect:</strong> Which practice of justice or mercy would make my faith more truthful this week?</p><p><strong>Practice:</strong> Choose one responsibility that affects someone else and carry it out carefully. Make room to rest instead of treating exhaustion as a badge of holiness.</p><p><strong>Prayer:</strong> God, keep me humble and steady. Let love, mercy, and justice give shape to the choices I make. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 12,
    "value": "<p><strong>Read:</strong> 1 John 1:8-9; Psalm 51:10-12</p><p><strong>Source and historical context:</strong> Williams describes the honest confession of sin, restoration after a failure, and a longing for worship centered on Christ. His discussion reflects debates over true forms of church life in seventeenth-century Christianity. Those ecclesiastical disagreements should not be recast as tests of whether someone belongs to God.</p><p><strong>Devotional focus:</strong> Confession becomes life-giving when it names a wrong without disguising it and opens a path toward forgiveness and change. John reminds believers that God is faithful to forgive. Repair may also require listening to the person harmed, accepting consequences, or making restitution. Christian worship can nurture this honesty, though people may practice their faith in different traditions. The center is Christ’s mercy, not our success at appearing flawless.</p><p><strong>Reflect:</strong> Is there something I need to name plainly instead of excusing—or a forgiven wrong I keep using to condemn myself?</p><p><strong>Practice:</strong> Confess one concrete fault to God and, when appropriate and safe, take a respectful step to repair its effect on another person.</p><p><strong>Prayer:</strong> God of mercy, give me a clean heart and a willing spirit. Let forgiveness move me toward truthful and loving action. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 13,
    "value": "<p><strong>Read:</strong> John 4:23-24; Psalm 139:23-24</p><p><strong>Source and historical context:</strong> Williams warns against mistaking outward religious practices for communion with Christ. He also describes readiness to follow God into difficult duties and the need to recognize our own failings. His seventeenth-century judgments about other churches belong to a historical controversy and are not reproduced as verdicts on other Christians.</p><p><strong>Devotional focus:</strong> Jesus says true worship is offered in spirit and truth. Buildings, schedules, traditions, and words can be meaningful gifts, but they are not replacements for love of God and neighbor. When we examine ourselves, the goal is not to intensify shame until we despair. The psalmist invites God to search the heart and lead it toward an everlasting way. A receptive heart can learn, repent, and remain open to unfamiliar forms of service.</p><p><strong>Reflect:</strong> Which visible religious habit helps me love more deeply, and which has become an end in itself?</p><p><strong>Practice:</strong> During your next act of worship, name the purpose behind it. Afterwards, put that purpose into action through kindness or honesty.</p><p><strong>Prayer:</strong> Jesus, draw me beyond appearances into truthful worship. Search my heart gently and lead me in your way. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 14,
    "value": "<p><strong>Read:</strong> Philippians 4:11-13; Hebrews 13:5-6</p><p><strong>Source and historical context:</strong> In this section Williams describes inner struggle, self-denial, contentment, endurance, and freedom from the hold of worldly possessions. He answers many objections about whether a person’s inward disposition is genuine. The passage can sound like a demand to embrace deprivation; that is not how these reflections apply it.</p><p><strong>Devotional focus:</strong> Paul learned contentment in seasons of plenty and need, drawing strength from Christ. Contentment does not mean accepting abuse, refusing needed help, or telling people in poverty to be satisfied with injustice. It means our worth and hope are not owned by possessions or status. We may enjoy good gifts gratefully, share them generously, and still work to address unmet needs. The discipline is to hold created things without making them our final security.</p><p><strong>Reflect:</strong> What possession, achievement, or public opinion has become too powerful over my sense of peace?</p><p><strong>Practice:</strong> Practice gratitude for one ordinary gift. Share a resource where you can, or seek needed support without shame.</p><p><strong>Prayer:</strong> Lord, teach me to receive enough with gratitude and pursue justice with courage. Free my heart from fear of losing status. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 15,
    "value": "<p><strong>Read:</strong> Ephesians 4:29-32; Galatians 6:9-10</p><p><strong>Source and historical context:</strong> Williams moves from self-discipline and guarding speech to the mature believer’s responsibility to seek the good of others. He recalls Christ and the apostles caring for people, including those in bodily distress. Miraculous healings appear in the historical argument; they are not a promise that faith or prayer will replace healthcare.</p><p><strong>Devotional focus:</strong> Words can build up or tear down. Paul calls believers to speech that gives grace and to patient perseverance in doing good. A life shaped by Christ looks outward: it listens, protects confidence, shares practical help, and notices neglected needs. Service should honor a person’s dignity, consent, and limits. We do not need extraordinary abilities to offer useful kindness, and we should not judge someone’s faith by whether a physical healing occurs.</p><p><strong>Reflect:</strong> Who would be genuinely helped by my time, attention, words, or practical skills this week?</p><p><strong>Practice:</strong> Offer one specific, manageable act of help. Ask what the person wants rather than assuming you know their needs.</p><p><strong>Prayer:</strong> Christ, make my words and work useful to others. Give me compassion that respects people and perseverance that does not seek applause. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 16,
    "value": "<p><strong>Read:</strong> John 13:34-35; Romans 12:15-18</p><p><strong>Source and historical context:</strong> Williams emphasizes affection for fellow believers while also urging mercy toward all people, including enemies. He acknowledges that Christians can wound one another and that grief over suffering may overwhelm even a well-intentioned person. The source sometimes frames forceful correction as love; this reading centers safety and compassion instead.</p><p><strong>Devotional focus:</strong> Jesus marks discipleship by love for one another. Love protects rather than humiliates, and it does not erase the dignity of people outside our own community. Paul invites us to rejoice with those who rejoice, weep with those who weep, and pursue peace where possible. Compassion is not weakness. It may require naming harm, supporting a person’s boundaries, or staying with someone through a grief that cannot be quickly solved.</p><p><strong>Reflect:</strong> Who have I judged from a distance when I could have listened more carefully?</p><p><strong>Practice:</strong> Listen to someone without rushing to advise them. If a situation involves harm, offer safe, practical support rather than pressuring quick reconciliation.</p><p><strong>Prayer:</strong> Jesus, widen my compassion. Teach me to care for those who suffer and to resist contempt, even during disagreement. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 17,
    "value": "<p><strong>Read:</strong> Galatians 6:1-2; Proverbs 15:1; James 1:19</p><p><strong>Source and historical context:</strong> Williams connects bearing others’ burdens with correcting wrongdoing, resisting temptations, and accepting correction ourselves. He also discusses separation from unrepentant behavior within Christian communities. Some of the source’s language is severe, so its call for accountability needs to be understood without endorsing threats or religious coercion.</p><p><strong>Devotional focus:</strong> Paul calls the spiritually mature to restore someone gently, mindful of their own vulnerability. Truth should not be replaced with flattery, but loving correction considers timing, relationship, evidence, and the listener’s dignity. We also need humility to receive feedback and change. Firm boundaries may be necessary where harm continues; they are not proof that another person deserves cruelty. Courage and gentleness belong together.</p><p><strong>Reflect:</strong> When I confront a problem, do I aim to help repair it or to win the argument?</p><p><strong>Practice:</strong> Before giving feedback, ask permission where appropriate and name the issue specifically. Invite one trusted person to tell you how you can improve.</p><p><strong>Prayer:</strong> God of wisdom, make my words truthful and kind. Help me welcome correction and defend others without becoming harsh. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 18,
    "value": "<p><strong>Read:</strong> Lamentations 3:40-41; 1 Corinthians 11:28; Matthew 6:16-18</p><p><strong>Source and historical context:</strong> Williams completes his signs of spiritual maturity and begins a final section on preserving spiritual wellbeing. He recommends examining one’s life, seeking Christ in worship, and periods of fasting and prayer. Fasting is a historical spiritual practice, but it is not required for everyone and can be unsuitable for medical or other personal reasons.</p><p><strong>Devotional focus:</strong> Lamentations invites us to examine our ways and return to the Lord. Reflection can be healthy when it leads to gratitude, confession, and a next step rather than endless fear. Jesus also assumes fasting may have a place in a disciple’s life, while warning against public display. We can cultivate attentive prayer and renewal through many safe practices: silence, Scripture, generosity, rest, and thoughtful conversation. No single discipline proves someone’s worth.</p><p><strong>Reflect:</strong> What recurring habit helps me notice my life honestly and return to God with hope?</p><p><strong>Practice:</strong> Spend ten minutes reflecting on one gratitude, one regret, and one next step. Choose a sustainable practice, without fasting if it would be unsafe.</p><p><strong>Prayer:</strong> Lord, teach me to examine my heart with honesty and hope. Guide me into practices that nourish love instead of fear. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 19,
    "value": "<p><strong>Read:</strong> Colossians 3:15-17; 1 Timothy 4:7-8</p><p><strong>Source and historical context:</strong> Williams recommends guarding against spiritual dullness, undue attachment to comforts, and discouragement, while remembering future hope. He uses seventeenth-century medical images of colds, excess, and bitter treatments as analogies for spiritual life. They are not medical advice or evidence that illness results from sin.</p><p><strong>Devotional focus:</strong> Paul encourages believers to let the peace of Christ rule and to fill their lives with teaching, gratitude, and song. Faithfulness is often strengthened by ordinary rhythms rather than dramatic pressure: time for Scripture, a trusted companion, honest prayer, wise limits, and enough rest. We can enjoy family, food, work, and other gifts without making any of them our sole source of identity. When a practice is wearing us down, it may need to change, not become more severe.</p><p><strong>Reflect:</strong> Which rhythm genuinely nourishes me, and which expectation has become burdensome?</p><p><strong>Practice:</strong> Choose one brief, sustainable spiritual practice for the coming week. Include time for sleep, meals, and needed physical care.</p><p><strong>Prayer:</strong> God of peace, renew my attention through simple faithful rhythms. Give me gratitude for your gifts and freedom from needless pressure. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 20,
    "value": "<p><strong>Read:</strong> Psalm 51:1-12; 1 John 4:16-19</p><p><strong>Source and historical context:</strong> Williams recommends remembering wrongdoing and contemplating divine judgment so that believers remain alert to the seriousness of sin. He uses threatening images and historical calamities to intensify reverence. Such claims need pastoral caution: they are not grounds for telling a specific suffering person that God caused their pain as punishment.</p><p><strong>Devotional focus:</strong> Repentance begins with honesty, but it need not end in terror. Psalm 51 joins confession with a plea for renewal, and John says that mature love drives out fear associated with punishment. We do not honor God by replaying shame without hope. A wise conscience can name wrongs, receive mercy, make repairs, and learn to act differently. God’s holiness and compassion invite reverence grounded in love.</p><p><strong>Reflect:</strong> Have I confused taking sin seriously with refusing to receive forgiveness?</p><p><strong>Practice:</strong> Bring one regret to God in clear words. Then write one constructive act of repair or a commitment to turn toward what is good.</p><p><strong>Prayer:</strong> Merciful God, create in me a clean heart. Let your love free me from despair and move me toward faithful change. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 21,
    "value": "<p><strong>Read:</strong> Micah 6:8; Romans 12:15; Luke 13:1-5</p><p><strong>Source and historical context:</strong> Williams looks at biblical judgments, wars, famine, pestilence, and religious conflict, interpreting disasters of his era through divine punishment. He also uses hostile language toward Islam and Catholicism and draws sweeping conclusions about peoples and cultures. These are historically situated assertions, not verified explanations for human catastrophes.</p><p><strong>Devotional focus:</strong> Jesus rejects the easy assumption that victims of tragedy must be worse sinners than others. Paul commands us to grieve with those who grieve, and Micah calls us toward justice and mercy. When we see suffering, a faithful first response is solidarity and practical aid, not speculation about whose guilt caused it. We can reject religious hatred and work for peace while taking seriously our shared responsibility to resist injustice.</p><p><strong>Reflect:</strong> When hearing about a tragedy, am I more inclined to assign blame or offer compassion?</p><p><strong>Practice:</strong> Learn about one community experiencing hardship from a credible source. Offer support, prayer, or a concrete act of solidarity within your ability.</p><p><strong>Prayer:</strong> God of justice, keep me from easy blame and indifference. Teach me to mourn with the hurting and seek peace with courage. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 22,
    "value": "<p><strong>Read:</strong> Psalm 90:12-17; John 11:25-26; Galatians 6:9-10</p><p><strong>Source and historical context:</strong> Williams ends with vivid meditation on mortality, the brevity of life, and the need to use our remaining days wisely. His imagery includes graves, judgment, eternity, gratitude for necessities, refusal of revenge, and service to others. Its severe descriptions of the dead and the afterlife are elements of a seventeenth-century devotional style, not instructions to cultivate panic or disgust.</p><p><strong>Devotional focus:</strong> The psalmist asks God to teach us to number our days so we may gain wisdom of heart. Jesus offers hope beyond death. Remembering life’s limits can make us more attentive to people rather than fearful of the future. Today is an opportunity to give thanks, reconcile where possible, protect the vulnerable, and do good. Hope does not deny grief or uncertainty. It offers a reason to live generously in the time we have.</p><p><strong>Reflect:</strong> If I treated today as a precious gift, what relationship or act of love would deserve more attention?</p><p><strong>Practice:</strong> Express gratitude to someone while you can. Take one small step toward an unfinished responsibility that matters more than status or possessions.</p><p><strong>Prayer:</strong> Living Christ, teach me to number my days with wisdom and hope. Let my remaining time be marked by gratitude, reconciliation, and love. Amen.</p>"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

-- Only update plan-level global reference rows. User-owned Scripture notes remain unchanged.
do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 1,
    "references": [
      "Isaiah 42:3",
      "Matthew 11:28-30"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 2,
    "references": [
      "1 John 4:1-3",
      "James 3:17-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 3,
    "references": [
      "Matthew 5:3-6",
      "Philippians 1:6"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 4,
    "references": [
      "2 Corinthians 4:16-18",
      "Romans 8:38-39"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 5,
    "references": [
      "Galatians 4:6-7",
      "1 Peter 2:2-3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 6,
    "references": [
      "Mark 9:23-24",
      "Galatians 5:16-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 7,
    "references": [
      "Psalm 103:8-14",
      "Hebrews 10:24-25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 8,
    "references": [
      "Hebrews 12:1-2",
      "2 Peter 3:18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 9,
    "references": [
      "Psalm 8:1-9",
      "Matthew 6:5-6"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 10,
    "references": [
      "Luke 11:1-13",
      "Romans 8:26-27"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 11,
    "references": [
      "Micah 6:8",
      "John 14:15-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 12,
    "references": [
      "1 John 1:8-9",
      "Psalm 51:10-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 13,
    "references": [
      "John 4:23-24",
      "Psalm 139:23-24"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 14,
    "references": [
      "Philippians 4:11-13",
      "Hebrews 13:5-6"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 15,
    "references": [
      "Ephesians 4:29-32",
      "Galatians 6:9-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 16,
    "references": [
      "John 13:34-35",
      "Romans 12:15-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 17,
    "references": [
      "Galatians 6:1-2",
      "Proverbs 15:1",
      "James 1:19"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 18,
    "references": [
      "Lamentations 3:40-41",
      "1 Corinthians 11:28",
      "Matthew 6:16-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 19,
    "references": [
      "Colossians 3:15-17",
      "1 Timothy 4:7-8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 20,
    "references": [
      "Psalm 51:1-12",
      "1 John 4:16-19"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 21,
    "references": [
      "Micah 6:8",
      "Romans 12:15",
      "Luke 13:1-5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000325",
    "day_number": 22,
    "references": [
      "Psalm 90:12-17",
      "John 11:25-26",
      "Galatians 6:9-10"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id
    from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;

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
where id = '90000000-0000-0000-0000-000000000325'::uuid;

commit;
