-- Wave 23: Plan 311 — A Coal From The Altar, To Kindle The Holy Fire of Zeale (Samuel Ward).
-- Fifteen source-grounded newly written devotional readings, NOT a transcription.
-- Historical anti-Catholic polemic and coercive religious statecraft contextualized, not endorsed.
-- Preserve the existing plan UUID, original day UUIDs, day numbers and reading progress.
-- Reviewed for devotional suitability and approved for publication.

begin;

-- Fail safely if the existing seeded plan differs from the reviewed record.
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
  where id = '90000000-0000-0000-0000-000000000311'::uuid;
  if not found then raise exception 'Plan 311 is missing'; end if;
  if source_link is distinct from 'https://www.gutenberg.org/ebooks/16423'
     or reported_total is distinct from 15 then
    raise exception 'Plan 311 source URL or total_days differs from reviewed source';
  end if;
  select count(*), min(day_number), max(day_number), count(distinct day_number)
  into present_days, first_day, last_day, distinct_days
  from public.devotional_days
  where plan_id = '90000000-0000-0000-0000-000000000311'::uuid;
  if present_days <> 15 or first_day <> 1 or last_day <> 15 or distinct_days <> 15 then
    raise exception 'Plan 311 must have exactly 15 unique numbered days, found %', present_days;
  end if;
end
$$;


update public.devotional_plans as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "value": "Zeal Tempered by Love: Fifteen Readings from Samuel Ward"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;


update public.devotional_plans as target
set description = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "value": "Fifteen original Scripture-led devotional readings inspired by Samuel Ward’s A Coal From The Altar, To Kindle The Holy Fire of Zeale. The series follows his sermon on the call to zeal, the Spirit’s work in our affections, the dangers of hypocrisy and blind or bitter zeal, courageous service, prayer and fellowship, sustainable discipleship, integrity in ministry, just leadership, and renewed fellowship with Christ. Each reading is a newly authored editorial adaptation with historical context, reflection, practical action, and prayer, not a verbatim modernization of Ward’s prose. Early modern Protestant polemics, anti-Catholic stereotypes, and calls for religious coercion are identified as historical claims rather than endorsed. The original source URL is retained for comparison."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;


update public.devotional_days as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 1,
    "value": "Awaken Your Heart to Christ"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 2,
    "value": "Let Every Affection Serve Love"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 3,
    "value": "Recognize the Counterfeit Fire"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 4,
    "value": "Keep Your Motives in the Light"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 5,
    "value": "Conviction Guided by Wisdom"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 6,
    "value": "Offer God Your Best Energy"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 7,
    "value": "Courage with a Gentle Heart"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 8,
    "value": "Stay Steady Under Criticism"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 9,
    "value": "Feed the Flame with Daily Practices"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 10,
    "value": "Protect Your Heart without Neglecting Rest"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 11,
    "value": "Let Zeal Become Visible in Service"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 12,
    "value": "Lead by Faithful Example"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 13,
    "value": "Speak with Substance and Integrity"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 14,
    "value": "Justice without Favoritism"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 15,
    "value": "Open the Door to Renewal"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;


update public.devotional_days as target
set content = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 1,
    "value": "<p><strong>Read:</strong> Revelation 3:14-22; Romans 12:11</p><p><strong>Source and historical context:</strong> Samuel Ward begins his sermon with Christ’s call to the church at Laodicea: be zealous and repent. He worries that religious habit and outward comfort may dull love for God. His opening also addresses the church and ministers in his own England; his attempt to apply Revelation to his national moment is a historical interpretation, not a timetable for our age.</p><p><strong>Devotional focus:</strong> The risen Christ does not merely expose indifference; he invites his people to turn back toward fellowship with him. Zeal is not being constantly loud, busy, or emotionally intense. It begins when we allow Jesus to tell the truth about our hearts and renew our willingness to love him and our neighbors. We can ask whether faith still shapes what we do when no one is watching.</p><p><strong>Reflect:</strong> Where has my discipleship become more a familiar routine than a living response to Christ?</p><p><strong>Practice:</strong> Make room for an unhurried reading of Revelation 3:14–22. Name one neglected act of love and take a first step toward it.</p><p><strong>Prayer:</strong> Lord Jesus, where my heart is distracted or complacent, call me back with patience and truth. Kindle a love that becomes steady obedience and generous care. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 2,
    "value": "<p><strong>Read:</strong> Galatians 5:22-25; Ephesians 5:18-20</p><p><strong>Source and historical context:</strong> Ward asks what zeal really means. He disputes definitions that reduce it to love alone or a mixture of love and anger. His images of warmth, wings, sails, and Pentecost describe the whole life of feeling drawn into devotion. He speaks in the forceful rhetoric of his century, sometimes borrowing hostility as a metaphor for opposing sin.</p><p><strong>Devotional focus:</strong> Strong feeling by itself does not prove spiritual maturity. The Spirit produces love, joy, peace, patience, kindness, goodness, faithfulness, gentleness, and self-control. These fruits help us judge whether our intensity is leading us toward Christ or away from him. Our grief at injustice, joy in mercy, and hope for renewal can all become energy for faithful service without being turned into contempt for other people.</p><p><strong>Reflect:</strong> When my convictions grow intense, which fruit of the Spirit is most likely to become difficult for me?</p><p><strong>Practice:</strong> Before a difficult conversation, name the good you are seeking and choose a patient, gentle way to seek it.</p><p><strong>Prayer:</strong> Holy Spirit, shape all my feelings by the character of Jesus. Keep my convictions strong and my conduct humble, peaceful, and kind. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 3,
    "value": "<p><strong>Read:</strong> Matthew 23:23-28; 1 John 3:17-18</p><p><strong>Source and historical context:</strong> Ward turns from genuine zeal to its imitations. He criticizes public displays of holiness that ignore generosity, outward drama that conceals inward disorder, and severe attention to minor rules while greater duties go undone. He also warns against cruelty and the desire to scrutinize others while avoiding the truth about oneself.</p><p><strong>Devotional focus:</strong> Jesus rebukes religious show when justice, mercy, and faithfulness are missing. A person may speak convincingly about moral principles and still withhold practical help. Likewise, a quiet person may love God deeply without attracting attention. The test is not the volume of our words but the consistency of our conduct, especially toward those who need protection, patience, and care.</p><p><strong>Reflect:</strong> Am I more attentive to how my faith appears than to the needs of people near me?</p><p><strong>Practice:</strong> Choose one concrete, private act of mercy today, with no need to announce or document it.</p><p><strong>Prayer:</strong> God of truth, expose the distance between my appearance and my actions. Make my love practical, my correction humble, and my compassion sincere. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 4,
    "value": "<p><strong>Read:</strong> Matthew 6:1-4; Philippians 2:3-4</p><p><strong>Source and historical context:</strong> Ward classifies false zeal as counterfeit, blind, or turbulent. In this portion he concentrates on counterfeit zeal: using religious language to gain status, money, influence, or advantage over others. He recalls examples of people who invoked holy causes while pursuing private benefit.</p><p><strong>Devotional focus:</strong> Jesus teaches generosity that is not performed for applause. Paul urges believers to reject selfish ambition and attend to the interests of others. The question is not whether good work brings any recognition but whether recognition has become its controlling purpose. Honest motives are often mixed, so we need patient self-examination and trusted people who can ask difficult questions.</p><p><strong>Reflect:</strong> If no one praised or rewarded this good action, would I still want to do it?</p><p><strong>Practice:</strong> Review one commitment and identify any self-serving incentive. Quietly redirect some time, attention, or money toward another person’s genuine need.</p><p><strong>Prayer:</strong> Father, free me from using your name to advance myself. Give me integrity in public and in private, and joy in doing good without applause. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 5,
    "value": "<p><strong>Read:</strong> Romans 10:1-4; James 3:13-18</p><p><strong>Source and historical context:</strong> Ward distinguishes zeal without knowledge from zeal overwhelmed by bitterness. He directs sharp confessional criticism at Catholics, separatists, and other groups of his time, while also arguing that needless quarrels can injure the church. Those polemical descriptions reflect early modern Protestant conflicts and should not be adopted as characterizations of present-day communities.</p><p><strong>Devotional focus:</strong> Paul can recognize sincere religious passion while urging a deeper understanding of God’s righteousness. James says wisdom from above is peaceable, gentle, open to reason, and full of mercy. We can hold convictions without declaring entire groups ignorant or dangerous. Seeking truth requires listening, checking our understanding, naming injustice carefully, and refusing intimidation or coercion.</p><p><strong>Reflect:</strong> When I disagree with someone about faith, do I look for understanding or mainly for a way to defeat them?</p><p><strong>Practice:</strong> Speak with someone whose view differs from yours. Ask a sincere question, listen fully, and describe your own position without insult.</p><p><strong>Prayer:</strong> God of wisdom, rescue my convictions from pride and hostility. Give me understanding, courage, and the peaceable spirit that grows good fruit. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 6,
    "value": "<p><strong>Read:</strong> Galatians 4:18; Mark 12:29-31</p><p><strong>Source and historical context:</strong> Ward begins his praise of true zeal by asking why people can be enthusiastic about work, possessions, or recreation yet offer God only reluctant attention. He praises earnest prayer, repentance, cheerful generosity, and service. His comparisons can overstate the importance of visible intensity as a measure of faith.</p><p><strong>Devotional focus:</strong> Jesus names wholehearted love of God and love of neighbor as the great commandments. The point of giving God our best is not to sustain maximum effort without rest or to compare our emotional temperature with someone else’s. It is to let love order our priorities. For one person that may mean time in prayer; for another, patient caregiving, integrity at work, or a difficult act of forgiveness.</p><p><strong>Reflect:</strong> Which ordinary commitment would look different if love of God and neighbor guided it more clearly?</p><p><strong>Practice:</strong> Bring your full attention to one neglected responsibility, and do it as an act of love rather than a performance.</p><p><strong>Prayer:</strong> Lord, receive my time, skills, and attention. Teach me to love you wholeheartedly and use my energy faithfully without pride or exhaustion. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 7,
    "value": "<p><strong>Read:</strong> Acts 20:22-24; 2 Timothy 1:7</p><p><strong>Source and historical context:</strong> Ward pictures the zealous believer as courageous in the face of obstacles, recalling Paul, Nehemiah, and others who persisted in costly callings. He also addresses accusations that fervent Christians are unreasonable. Some of his imagery is combative, shaped by the persecution and conflict he understood.</p><p><strong>Devotional focus:</strong> Paul’s courage was the willingness to fulfill a ministry of grace despite uncertainty, not a license to injure an opponent. The Spirit gives power together with love and self-control. Faithful courage may involve naming wrongdoing, resisting pressure, defending a vulnerable neighbor, or remaining honest at personal cost. We should distinguish that from aggression, reckless risk, or the need to appear fearless.</p><p><strong>Reflect:</strong> Where do I need courage to do good without becoming harsh or careless of consequences?</p><p><strong>Practice:</strong> Take one prudent step toward a good but difficult duty: speak truth respectfully, request accountability, or stand beside someone treated unfairly.</p><p><strong>Prayer:</strong> God of courage, strengthen me to do what is right. Let your love guard my words and your wisdom guide my actions when I am afraid. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 8,
    "value": "<p><strong>Read:</strong> 1 Peter 4:12-16; Luke 11:9-13</p><p><strong>Source and historical context:</strong> Ward addresses the ridicule and social pressure that can meet religious conviction. He warns readers not to confuse fear of appearing unusual with genuine wisdom. Near the end of this segment, he moves into practical advice for sustaining zeal, beginning with prayer.</p><p><strong>Devotional focus:</strong> Criticism is not always persecution; it may reveal a blind spot that deserves attention. Yet faithful actions can also be misunderstood. Peter urges believers to examine why they suffer and to do good without shame. Jesus invites his followers to ask, seek, and knock. Prayer can help us respond to resistance without either abandoning a good purpose or hardening our hearts toward correction.</p><p><strong>Reflect:</strong> Which criticism should I consider carefully, and which fear of disapproval is keeping me from a loving action?</p><p><strong>Practice:</strong> Bring one concern to prayer. Seek wise feedback, then continue a good action if it remains truthful, safe, and loving.</p><p><strong>Prayer:</strong> Faithful God, give me a teachable spirit and a steady heart. Help me accept correction, resist empty pressure, and pray with trust. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 9,
    "value": "<p><strong>Read:</strong> Colossians 3:16-17; Hebrews 10:23-25</p><p><strong>Source and historical context:</strong> Ward advises prayer, Scripture, songs, reflection, examples of faithful people, and fellowship to nurture spiritual zeal. He compares these practices to fuel that keeps a fire alive and warns against isolation and sporadic devotion.</p><p><strong>Devotional focus:</strong> Spiritual growth usually takes shape through ordinary rhythms rather than a single dramatic moment. Scripture, prayer, worship, and honest companionship remind us who God is and how we are to love. These practices are gifts, not instruments for proving superiority. Their purpose is to help us persevere, encourage one another, and make room for grace in a crowded week.</p><p><strong>Reflect:</strong> What simple practice genuinely helps me remember Christ and care for others, and what repeatedly displaces it?</p><p><strong>Practice:</strong> Choose a sustainable rhythm for the next seven days: a short Scripture reading, an honest prayer, or a conversation with a trusted believer.</p><p><strong>Prayer:</strong> Lord, let your word dwell richly in me. Give me companions who encourage love and good works, and help me return to you each day. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 10,
    "value": "<p><strong>Read:</strong> John 15:4-5; 1 John 2:15-17</p><p><strong>Source and historical context:</strong> Ward acknowledges that excessive study, prayer, and effort can produce weariness, even as he stresses that zeal can fade through neglect, habitual wrongdoing, or an absorbing pursuit of wealth and status. His strong contrasts require balance: physical limits, illness, and the need for rest are not signs of spiritual failure.</p><p><strong>Devotional focus:</strong> Jesus describes fruitfulness as remaining in him, like a branch connected to the vine. Remaining does not mean forcing ourselves into constant activity. We can care for our bodies, ask for help, confess wrongdoing, and refuse to let possessions define us. The goal is a sustainable life of love in which work, rest, honesty, and dependence on Christ belong together.</p><p><strong>Reflect:</strong> What is draining my spiritual attention: distraction, unaddressed wrong, isolation, or trying to do too much?</p><p><strong>Practice:</strong> Choose one restorative boundary. Set aside an unhealthy distraction, make an honest apology, or schedule needed rest.</p><p><strong>Prayer:</strong> Jesus, keep me close to you. Help me release what competes with your love, care for my limits, and grow in steady faithfulness. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 11,
    "value": "<p><strong>Read:</strong> James 2:14-17; Ephesians 5:15-16</p><p><strong>Source and historical context:</strong> Ward tests the excuses people give for neglecting prayer, generosity, worship, and service: lack of time, lack of ability, fear of trouble, or the claim that inward devotion needs no outward expression. His words are blunt and sometimes assume capacities or resources that are not equal for everyone.</p><p><strong>Devotional focus:</strong> James asks what good faith means if we notice material need and never respond. Genuine love seeks expression, though its form depends on each person’s health, circumstances, gifts, and responsibilities. Someone unable to give money may listen, pray, share knowledge, or ask for assistance on another’s behalf. Faithfulness is not a contest of output; it is using what we actually have to love wisely.</p><p><strong>Reflect:</strong> What specific kind of service is possible within my real responsibilities and limits?</p><p><strong>Practice:</strong> Offer one practical gift you can afford today: a helpful message, shared information, a meal, time, or another act of care.</p><p><strong>Prayer:</strong> Lord, show me what love asks of me today. Free me from excuses and from unfair comparison, and teach me to serve with what I have. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 12,
    "value": "<p><strong>Read:</strong> 1 Timothy 4:12-16; 2 Timothy 4:1-5</p><p><strong>Source and historical context:</strong> In the sixth part Ward turns directly to ministers, urging prayer, careful teaching, and a consistent public and private life. He also praises the monarch of his time in language associated with sharp anti-Catholic conflict and violent biblical imagery. Those appeals to political or religious force are historical features, not guidance for modern discipleship.</p><p><strong>Devotional focus:</strong> Paul calls Timothy to attend to teaching and to set an example in speech, conduct, love, faith, and purity. Leadership is not proved by aggression or by claiming divine authority for coercion. It is shown in patient truthfulness, protecting people from harm, answering questions responsibly, and living what we teach. Everyone who influences another person can practice these habits.</p><p><strong>Reflect:</strong> Do my actions make it easier or harder for people to trust the good words I speak?</p><p><strong>Practice:</strong> Ask a trusted colleague or friend for feedback on one place where your example and your stated values may differ.</p><p><strong>Prayer:</strong> God of truth, help every leader be humble, accountable, and compassionate. Let my conduct support my words and make room for others to flourish. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 13,
    "value": "<p><strong>Read:</strong> 1 Peter 5:2-4; 1 Corinthians 13:1-3</p><p><strong>Source and historical context:</strong> Ward challenges ministers who rely on showy wordplay or occasional preaching without pastoral care. He values messages that help people know Christ and notes the contradiction of powerful speeches paired with selfish or harmful behavior.</p><p><strong>Devotional focus:</strong> Paul writes that eloquent speech without love is empty noise. Peter tells spiritual shepherds to serve willingly, not for dishonest gain or by domineering over others. Communication matters, but volume and flair cannot substitute for truth, preparation, care, or integrity. Whether we teach Scripture, mentor a coworker, or guide a family, the most persuasive message is one matched by a trustworthy life.</p><p><strong>Reflect:</strong> Where am I tempted to sound impressive instead of being clear, helpful, and accountable?</p><p><strong>Practice:</strong> Simplify one message or piece of advice so that it serves the listener’s needs; then follow through on something you have promised.</p><p><strong>Prayer:</strong> Christ our Shepherd, give me speech rooted in love and actions that match it. Keep me from using influence for applause or control. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 14,
    "value": "<p><strong>Read:</strong> Micah 6:8; Proverbs 29:4</p><p><strong>Source and historical context:</strong> Ward turns from preachers to civil magistrates. He condemns bribery, self-interest, and cowardice, but also advocates harsh enforcement of religious conformity and attacks Catholics and other religious groups. Such demands reflect the coercive church-state politics of his period and should be clearly separated from the call for integrity in public office.</p><p><strong>Devotional focus:</strong> The prophets connect faithful leadership with justice, mercy, and humility. Officials and other people in authority should protect those with less power, reject corruption, apply rules impartially, and respect freedom of conscience. Courage is valuable when it restrains abuse, not when it imposes faith by force. These principles matter in government, workplaces, churches, and homes alike.</p><p><strong>Reflect:</strong> How do I use the authority or influence I have, especially when someone cannot easily challenge my decision?</p><p><strong>Practice:</strong> Examine one decision for favoritism or self-interest. Where possible, make a fairer choice and invite appropriate accountability.</p><p><strong>Prayer:</strong> Just and merciful God, guide those entrusted with power. Make us courageous against corruption, humble in judgment, and protective of every person’s dignity. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 15,
    "value": "<p><strong>Read:</strong> Revelation 3:19-20; Joshua 24:15</p><p><strong>Source and historical context:</strong> Ward closes by returning to the Laodicean call. He urges the people of his congregation to open their hearts to Christ, recommit themselves to worship and service, and ask God for understanding joined with zeal. The ending is a pastoral invitation expressed in vivid, sometimes threatening language typical of the sermon.</p><p><strong>Devotional focus:</strong> Christ stands at the door and knocks. Renewal is not a command to manufacture intense emotion but an invitation to respond to his presence with repentance, trust, and love. Joshua’s household declaration reminds us that faith shapes everyday choices. We can finish this series by choosing one relationship to mend, one habit to cultivate, and one way to serve, trusting grace to sustain the beginning.</p><p><strong>Reflect:</strong> What would opening the door to Christ look like in my ordinary life over the coming week?</p><p><strong>Practice:</strong> Write down one realistic next step in prayer, reconciliation, or service. Share it with a trusted person if that would help you follow through.</p><p><strong>Prayer:</strong> Lord Jesus, thank you for seeking fellowship with us. Renew my heart, steady my commitments, and let my faith become patient love in action. Amen.</p>"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;


-- Replace only plan-owned global Scripture references; preserve user-created note links.
do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 1,
    "references": [
      "Revelation 3:14-22",
      "Romans 12:11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 2,
    "references": [
      "Galatians 5:22-25",
      "Ephesians 5:18-20"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 3,
    "references": [
      "Matthew 23:23-28",
      "1 John 3:17-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 4,
    "references": [
      "Matthew 6:1-4",
      "Philippians 2:3-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 5,
    "references": [
      "Romans 10:1-4",
      "James 3:13-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 6,
    "references": [
      "Galatians 4:18",
      "Mark 12:29-31"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 7,
    "references": [
      "Acts 20:22-24",
      "2 Timothy 1:7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 8,
    "references": [
      "1 Peter 4:12-16",
      "Luke 11:9-13"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 9,
    "references": [
      "Colossians 3:16-17",
      "Hebrews 10:23-25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 10,
    "references": [
      "John 15:4-5",
      "1 John 2:15-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 11,
    "references": [
      "James 2:14-17",
      "Ephesians 5:15-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 12,
    "references": [
      "1 Timothy 4:12-16",
      "2 Timothy 4:1-5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 13,
    "references": [
      "1 Peter 5:2-4",
      "1 Corinthians 13:1-3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 14,
    "references": [
      "Micah 6:8",
      "Proverbs 29:4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "day_number": 15,
    "references": [
      "Revelation 3:19-20",
      "Joshua 24:15"
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

update public.devotional_plans
set status = 'published', updated_at = now()
where id = '90000000-0000-0000-0000-000000000311'::uuid;

commit;
