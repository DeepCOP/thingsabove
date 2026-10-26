-- Wave 22: Plan 298 — Edith and Her Ayah, and Other Stories (A. L. O. E.).
-- Seventeen source-grounded, original editorial readings rather than verbatim translations.
-- Colonial stereotypes, religious pressure, harsh child discipline and illness-as-punishment assumptions contextualized.
-- Keep the inherited plan and day IDs, numbering, and user reading progress unchanged.
-- Reviewed for devotional suitability and approved for publication.

begin;

-- Require the reviewed plan and the complete existing 17 day records before any updates.
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
  where id = '90000000-0000-0000-0000-000000000298'::uuid;
  if not found then raise exception 'Plan 298 is missing'; end if;
  if source_link is distinct from 'https://www.gutenberg.org/ebooks/60138'
     or reported_total is distinct from 17 then
    raise exception 'Plan 298 source URL or total_days differs from reviewed source';
  end if;
  select count(*), min(day_number), max(day_number), count(distinct day_number)
  into present_days, first_day, last_day, distinct_days
  from public.devotional_days
  where plan_id = '90000000-0000-0000-0000-000000000298'::uuid;
  if present_days <> 17 or first_day <> 1 or last_day <> 17 or distinct_days <> 17 then
    raise exception 'Plan 298 must have exactly 17 unique numbered days, found %', present_days;
  end if;
end
$$;


update public.devotional_plans as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "value": "Living with Mercy and Truth: 17 Readings from Edith and Her Ayah"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;


update public.devotional_plans as target
set description = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "value": "Seventeen Scripture-led devotional readings inspired by Edith and Her Ayah, and Other Stories (1872), by A. L. O. E. The reading sequence follows the inherited stories about Edith and Motee, care for creatures, confession and forgiveness, opportunities, human dignity, life’s storms, worship and rest, unseen burdens, honesty, discipleship, and mercy toward enemies. Each day is an original editorial adaptation with explicitly labeled historical context, Scripture anchors, reflection, practical action, and prayer; it is not a quotation or a verified modern-language translation of the source. Colonial-era portrayals of Indian faiths and servants, Victorian assumptions about poverty, discipline, suffering, and strict Sabbath observance are contextualized rather than endorsed. The final source day contains only the heading of a following tale, not its text. Source link retained for comparison and further editorial review."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;


update public.devotional_days as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 1,
    "value": "Let Your Kindness Speak"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 2,
    "value": "Presence in an Hour of Fear"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 3,
    "value": "Gentleness toward Creation"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 4,
    "value": "The Courage to Tell the Truth"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 5,
    "value": "Choose Words That Heal"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 6,
    "value": "Do Not Waste the Open Door"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 7,
    "value": "Every Person Is Precious"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 8,
    "value": "Christ with Us in the Storm"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 9,
    "value": "Rest Is a Gift, Not a Weapon"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 10,
    "value": "Mercy Matters More Than a Rule"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 11,
    "value": "What Makes Us Beautiful?"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 12,
    "value": "Notice the Burdens Beside You"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 13,
    "value": "Truth, Grace, and Belonging"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 14,
    "value": "Integrity When It Costs Something"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 15,
    "value": "Keep Looking to the True Pattern"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 16,
    "value": "Compassion Even Across Enemy Lines"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 17,
    "value": "Grace for Every Wounded Heart"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;


update public.devotional_days as target
set content = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 1,
    "value": "<p><strong>Read:</strong> Matthew 5:14-16; 1 Peter 3:15-16</p><p><strong>Source and historical context:</strong> The opening story, Edith and Her Ayah, introduces a British family in colonial India and Motee, an Indian woman employed as Edith’s nurse. Edith prays for Motee, while her parents’ conduct makes an impression on her. The narrator portrays Indian religions through a dismissive missionary lens that should be recognized as part of the book’s period, not adopted as an accurate account of its neighbors.</p><p><strong>Devotional focus:</strong> Faith is not displayed only through the words we say. It also appears in the way we treat people who work alongside us or depend on us. Jesus calls his followers to let their light shine through goodness, while Peter joins witness to gentleness and respect. Prayer and conversation about belief must honor another person’s conscience, dignity, and freedom. We can begin by asking whether our daily conduct makes love credible.</p><p><strong>Reflect:</strong> How do people experience your faith through your treatment of those who have less power or fewer choices?</p><p><strong>Practice:</strong> Thank someone whose work supports your life, listen to their perspective, and offer practical kindness without attaching conditions.</p><p><strong>Prayer:</strong> Lord Jesus, make my faith visible in kindness and fairness. Teach me to speak with gentleness, respect each person, and love without seeking control. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 2,
    "value": "<p><strong>Read:</strong> Psalm 46:1-2; Galatians 6:2</p><p><strong>Source and historical context:</strong> Motee finds Edith after the child follows a fawn into the jungle. In the story, danger, rescue, and Edith’s later fever bring the nurse and family together in anxious care. Motee watches over the sick child, and the book interprets her prayer and Edith’s recovery as an answer to Christian faith, from its nineteenth-century missionary standpoint.</p><p><strong>Devotional focus:</strong> When someone is frightened or ill, faithful love stays close. The story’s strongest human action is the nurse’s protective care, not a claim that one faith makes people braver or that prayer guarantees recovery. Scripture encourages us to bring our fears to God and to help carry one another’s burdens. Our prayers can accompany responsible medical care, attentive listening, and practical support.</p><p><strong>Reflect:</strong> Who needs patient companionship rather than another explanation for their suffering?</p><p><strong>Practice:</strong> Contact someone managing fear, illness, or caregiving. Ask what practical support is welcome, and honor their wishes.</p><p><strong>Prayer:</strong> God our refuge, meet us in uncertain hours. Give us courage to seek help, patience to remain present, and compassion for everyone who is afraid. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 3,
    "value": "<p><strong>Read:</strong> Proverbs 12:10; 1 Corinthians 15:51-57</p><p><strong>Source and historical context:</strong> The closing sentence of Edith and Her Ayah gives way to The Butterfly. Boys injure a butterfly for amusement; Ella Claremont challenges their cruelty and draws an illustration about resurrection from the insect’s change. The tale combines concern for creatures with an imaginative Christian symbol. Its old numerical claims about insect anatomy are not presented here as verified science.</p><p><strong>Devotional focus:</strong> The first lesson is simple: a life need not be large to deserve care. Proverbs praises the righteous person’s concern for animals. The butterfly can also prompt wonder at change and hope, but Christian hope in resurrection rests on Christ, not on a biological comparison. In both themes, reverence calls us away from casual harm and toward humility before life we did not create.</p><p><strong>Reflect:</strong> Where might curiosity, convenience, or carelessness be making you overlook another living creature?</p><p><strong>Practice:</strong> Do one quiet act of care for the environment or a vulnerable animal, without disturbing its natural needs.</p><p><strong>Prayer:</strong> Creator of life, make my hands gentle and my attention generous. Let the beauty of your world deepen my gratitude and hope in Christ. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 4,
    "value": "<p><strong>Read:</strong> Proverbs 28:13; 1 John 1:9</p><p><strong>Source and historical context:</strong> After a brief conclusion to The Butterfly, the story The Penitent introduces Charley, who loses money entrusted to him after giving in to peer pressure. Frightened of his father’s reaction, he considers inventing a story. His brother George urges him to confess and offers his own savings to help repair the loss.</p><p><strong>Devotional focus:</strong> Fear can make a second wrong seem easier than admitting the first. George does more than lecture: he stands beside Charley as the truth is told. Scripture invites confession without pretending that accountability and mercy are opposites. Restoration may include acknowledging what happened, making amends, and receiving help. We should never demand disclosure to someone who is unsafe; truthfulness and protection belong together.</p><p><strong>Reflect:</strong> Is there a small falsehood, evasion, or unspoken apology you need to address responsibly?</p><p><strong>Practice:</strong> Where it is safe, tell the truth about one mistake and take a concrete step toward repairing its effects.</p><p><strong>Prayer:</strong> Merciful Father, give me humility to admit my wrong and courage to make things right. Help me offer others the patient mercy I need myself. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 5,
    "value": "<p><strong>Read:</strong> Luke 7:44-50; Ephesians 4:29</p><p><strong>Source and historical context:</strong> The day completes The Penitent with Jesus’ welcome to a repentant woman in Luke 7, then presents The Reproof: a mother and daughter respond to offensive language overheard on a train. The next story, The Vase and the Dart, begins with a young person struggling to keep good resolutions.</p><p><strong>Devotional focus:</strong> The contrast is useful. Jesus does not reduce the repentant woman to her past; he meets her with forgiveness and dignity. The train story invites care about speech, but correction itself should be considerate rather than humiliating. Ephesians asks for words that build others up according to their needs. We can speak truthfully about harm while leaving room for change, and we can receive correction without surrendering hope.</p><p><strong>Reflect:</strong> When you notice harmful speech, are you more interested in winning a confrontation or helping someone grow?</p><p><strong>Practice:</strong> Choose one conversation in which you can replace ridicule or gossip with a truthful, constructive word.</p><p><strong>Prayer:</strong> Lord, forgive my careless words. Give me speech that protects dignity, welcomes repentance, and helps others grow in grace. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 6,
    "value": "<p><strong>Read:</strong> Ephesians 5:15-16; James 1:5</p><p><strong>Source and historical context:</strong> In The Vase and the Dart, Willy Thorn recounts an allegory in which a boy passes personified Opportunities carrying gifts for prayer, learning, kindness, and Scripture. He discovers that a moment refused cannot simply be recalled. The story uses threatening imagery to urge action, before the collection introduces The Jewel.</p><p><strong>Devotional focus:</strong> Every day has its own small openings: a person to encourage, a truth to learn, an apology to offer, a quiet moment to pray. We cannot retrieve yesterday, but grace does not require us to live afraid of each missed chance. Paul’s call to use our time wisely invites attentiveness rather than panic, and James reminds us that wisdom can be asked of God. Begin with the opportunity actually before you.</p><p><strong>Reflect:</strong> What good action have you postponed because a more convenient time seemed certain to come?</p><p><strong>Practice:</strong> Choose one manageable action of prayer, study, kindness, or repair and complete it today.</p><p><strong>Prayer:</strong> God of fresh beginnings, open my eyes to today’s opportunities. Free me from regret that paralyzes, and guide me in the next faithful step. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 7,
    "value": "<p><strong>Read:</strong> Mark 8:36-37; Luke 12:6-7</p><p><strong>Source and historical context:</strong> The Jewel follows Ann, a poor girl who attempts to steal a small case in a London park. Mrs. Claremont uses a jewel hidden inside a plain container as an illustration of the worth of an unseen soul. She also offers clothing and help with schooling. The original dialogue reflects Victorian charity models and sometimes treats poverty as a spiritual lesson.</p><p><strong>Devotional focus:</strong> Jesus measures human worth differently from a society that judges appearances, income, or mistakes. Ann needs food, education, safety, and respect, not only a lecture. Christian concern for another person includes their spiritual questions and their practical needs, without using one as leverage for the other. We do not need to regard hardship as God’s chosen way of polishing a person in order to find them immeasurably valuable.</p><p><strong>Reflect:</strong> Who is too easily labeled by their poverty, work, past mistake, or outward appearance?</p><p><strong>Practice:</strong> Offer respectful assistance that responds to an expressed need, and resist making assumptions about someone’s story.</p><p><strong>Prayer:</strong> God who knows each person, cleanse my vision of contempt. Make me attentive to both dignity and need, and generous without conditions. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 8,
    "value": "<p><strong>Read:</strong> Mark 4:35-41; Psalm 34:17-18</p><p><strong>Source and historical context:</strong> The final lines of The Jewel lead into The Storm, which retells Jesus calming the Sea of Galilee. Its narrator compares the disciples’ danger with poverty, family trouble, temptation, and grief, and pictures hope as reaching a safe harbor.</p><p><strong>Devotional focus:</strong> The disciples wake Jesus because the storm is real and their fear is real. Their cry is not dismissed as unworthy of care. Following Christ does not mean trouble cannot happen, nor does faith guarantee that each difficulty will disappear immediately. It means we can bring our fear into his presence and seek help from others. Courage can look like asking for assistance, resting when exhausted, and taking the next wise step.</p><p><strong>Reflect:</strong> Which storm in your life needs prayer and also a practical form of support?</p><p><strong>Practice:</strong> Name one specific worry in prayer and one safe, concrete action you can take with someone you trust.</p><p><strong>Prayer:</strong> Jesus, meet me where the waves are high. Give me honest faith, wise companions, and enough peace for the next step. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 9,
    "value": "<p><strong>Read:</strong> Mark 2:27-28; Hebrews 4:9-11</p><p><strong>Source and historical context:</strong> The Storm closes with a vision of hope beyond suffering. The next story, The Sabbath-Tree, pictures Sabbath observance as fruit that gives weary people nourishment, strength, and healing. The narrator then depicts people damaging the tree for leisure or commerce, reflecting a strict Victorian understanding of Sunday behavior.</p><p><strong>Devotional focus:</strong> Jesus teaches that the Sabbath was made for human good. Worship, rest, and time with others can renew us when work and anxiety take up all our attention. Yet rest should never be used to shame people whose jobs, caregiving, disability, or circumstances differ from ours. Scripture invites us to create rhythms that honor God and sustain human life rather than to turn a gift into a test of superiority.</p><p><strong>Reflect:</strong> What kind of rest helps you become more present to God, other people, and your own limits?</p><p><strong>Practice:</strong> Plan one restorative pause this week and, if possible, make space for someone else to rest too.</p><p><strong>Prayer:</strong> Lord of the Sabbath, teach me to welcome rest as a gift. Let my habits bring renewal, kindness, and room for those who carry heavy burdens. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 10,
    "value": "<p><strong>Read:</strong> Isaiah 58:6-10; Luke 13:10-17</p><p><strong>Source and historical context:</strong> The day finishes The Sabbath-Tree with a warning that broken Sabbath customs lead to harm, and then opens The White Robe with Mrs. Claremont and Ella hurrying toward a child injured in the street. The narrative presents the suffering that follows some choices as moral consequence; it should not be read as proof that an accident reveals divine punishment.</p><p><strong>Devotional focus:</strong> God calls his people to worship, but worship that ignores an injured neighbor has missed its purpose. Isaiah joins devotion to freeing the oppressed and feeding the hungry; Jesus heals on the Sabbath. The Claremonts’ immediate response to a child in need captures the better emphasis: notice, stop, and help. Mercy is not an exception to the life of faith; it is one of its clearest expressions.</p><p><strong>Reflect:</strong> Do your routines help you notice people in need, or do they sometimes become reasons to look away?</p><p><strong>Practice:</strong> Choose one act of practical mercy this week, including appropriate professional or emergency help when needed.</p><p><strong>Prayer:</strong> Compassionate God, keep my devotion from becoming indifference. Give me eyes to see needs and hands ready to help wisely. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 11,
    "value": "<p><strong>Read:</strong> 1 Peter 3:3-4; 1 Samuel 16:7</p><p><strong>Source and historical context:</strong> In The White Robe, Sophy is distressed that her new dress has been torn during an accident. Mrs. Claremont contrasts fragile outward finery with inward qualities and warns against making status or appearance the center of life. The story’s presentation of a child’s emotional reaction is severe by modern standards.</p><p><strong>Devotional focus:</strong> A ruined possession can still feel painful; compassion need not scold a frightened child for caring about it. Yet Scripture gives us a wider measure of beauty. God looks at the heart and values a gentle spirit. Clothes and possessions can be enjoyed without becoming the foundation of identity. When disappointment comes, we can tend to the person first and remember that dignity survives every torn garment and every change in circumstance.</p><p><strong>Reflect:</strong> Which outward measure of approval has been carrying too much weight in your sense of worth?</p><p><strong>Practice:</strong> Encourage someone today for a quality of character—kindness, courage, patience—rather than appearance or status.</p><p><strong>Prayer:</strong> Lord, remind me that your love is deeper than appearances. Make my heart gentle, my priorities wise, and my response to others compassionate. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 12,
    "value": "<p><strong>Read:</strong> Galatians 6:2; Romans 12:15</p><p><strong>Source and historical context:</strong> In Crosses, Ella returns to her Sunday school grieving her brother’s death. The narrator describes different children living with hunger, family violence, illness, abandonment, and loneliness. The children’s situations vary, but all carry burdens others may not see.</p><p><strong>Devotional focus:</strong> Scripture invites the church to weep with those who weep and carry one another’s burdens. That does not mean calling mistreatment or neglect a cross a child must simply endure. When someone lacks food, safety, medical care, or trustworthy protection, compassion should seek those things. We are not asked to compare grief or reward silent suffering. We are asked to take pain seriously and stand beside people in ways that make life safer and less lonely.</p><p><strong>Reflect:</strong> Whose struggle might you miss because they appear cheerful, quiet, capable, or well dressed?</p><p><strong>Practice:</strong> Check on someone with care and without pressure. Where safety is at stake, prioritize appropriate protection and help.</p><p><strong>Prayer:</strong> God of the brokenhearted, teach us to listen without judgment, to provide help rather than blame, and to carry burdens together. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 13,
    "value": "<p><strong>Read:</strong> Ephesians 4:25; 1 John 1:8-9</p><p><strong>Source and historical context:</strong> Crosses continues with children whose unseen struggles include fear, sorrow, and regret. The day then introduces The Two Countries, an allegory that imagines truthful and deceptive speech as signs of belonging to different spiritual homelands. Its stark divisions reflect the book’s preaching style.</p><p><strong>Devotional focus:</strong> Words matter because other people depend upon them. Truthfulness builds trust, while deception may damage relationships and leave the speaker isolated. Yet a person who has lied is not beyond the reach of grace. First John invites us to bring sin into the light and receive forgiveness. The aim of honesty is not to label others as permanently lost but to build relationships where truth, repentance, accountability, and renewed trust are possible.</p><p><strong>Reflect:</strong> Where would greater honesty make a relationship safer or more trustworthy?</p><p><strong>Practice:</strong> Practice one truthful, kind conversation and, if needed, take responsibility for a mistake without blaming someone else.</p><p><strong>Prayer:</strong> God of truth and mercy, steady my words and soften my heart. Help me repair broken trust and welcome others who are learning to change. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 14,
    "value": "<p><strong>Read:</strong> Proverbs 12:22; Colossians 3:9-10</p><p><strong>Source and historical context:</strong> The Two Countries gives examples of lying out of folly, greed, malice, and fear. It then portrays Margaret Lacy, a worker who tells the truth about losing a former position even though her honesty may cost her another job. Her employer later learns to trust her account of an accidental breakage.</p><p><strong>Devotional focus:</strong> Truthfulness often has a cost before its benefit is visible. Margaret’s example invites us to value integrity more than immediate approval. It is also important to notice the worker’s vulnerability: employers and others with power must not exploit honesty or punish people unfairly for speaking up. God’s call to truth reaches both sides of every relationship. We can be candid, fair, and accountable without promising that every honest decision will quickly be rewarded.</p><p><strong>Reflect:</strong> Are you facing pressure to conceal, exaggerate, or misrepresent something because honesty feels costly?</p><p><strong>Practice:</strong> Take one responsible step toward an accurate account—correct an error, clarify a promise, or document an important fact.</p><p><strong>Prayer:</strong> God of faithfulness, give me courage to speak truth without cruelty and wisdom to use power fairly. Help integrity take root in me. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 15,
    "value": "<p><strong>Read:</strong> Hebrews 12:1-3; 2 Corinthians 3:18</p><p><strong>Source and historical context:</strong> The conclusion of Do You Love God? tells of a child’s question that leads an adult to reconsider his life. The day then gives The Imperfect Copy, in which Edwin draws a face from memory, resists correction, and becomes discouraged when he compares his work with the actual model. His brother urges him to keep studying the original and learn patiently.</p><p><strong>Devotional focus:</strong> The story offers a picture of discipleship. A drawing improves not by pretending it is flawless or tearing it up at the first mistake, but by looking again and patiently adjusting. Christians look to Jesus as the pattern of faithful love. Growth in character is not a demand to be perfect immediately; it is a repeated turning toward Christ, open to correction and sustained by grace. We can value progress without making our worth depend on performance.</p><p><strong>Reflect:</strong> When corrected, do you tend to defend yourself or give up before you can learn?</p><p><strong>Practice:</strong> Choose one action of Jesus in the Gospels to imitate in an ordinary encounter today.</p><p><strong>Prayer:</strong> Patient Lord, keep me teachable without despair. Turn my eyes toward Jesus and form in me his humility, mercy, and faithfulness. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 16,
    "value": "<p><strong>Read:</strong> Luke 6:27-36; Matthew 25:35-40</p><p><strong>Source and historical context:</strong> A Story of the Crimea describes the aftermath of the Battle of the Alma and portrays a British surgeon named Thomson remaining to care for wounded Russian soldiers after his own forces move on. The source uses this account to illustrate costly mercy before drawing a comparison with Jesus’ compassion. Its historical details have not been independently verified here.</p><p><strong>Devotional focus:</strong> War and conflict encourage people to divide the world into those who deserve help and those who do not. Jesus challenges that instinct by teaching love for enemies. Providing medical care to a wounded person is not an endorsement of the war or the person’s actions; it is a refusal to abandon human dignity. We can begin closer to home by treating opponents fairly, telling the truth without hatred, and caring for people whose needs do not fit our loyalties.</p><p><strong>Reflect:</strong> Whose suffering are you tempted to overlook because you disagree with them or identify them with an opposing group?</p><p><strong>Practice:</strong> Offer respectful help or a fair hearing to someone outside your usual circle, without compromising safety or justice.</p><p><strong>Prayer:</strong> Merciful Christ, enlarge my compassion beyond my loyalties. Help me protect the vulnerable, pursue peace, and see your image in every person. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 17,
    "value": "<p><strong>Read:</strong> 1 John 1:8-9; Ephesians 2:8-10</p><p><strong>Source and historical context:</strong> The final inherited entry completes A Story of the Crimea by inviting readers to admit wrongdoing, seek forgiveness in Jesus, and turn toward a different way of living. After that conclusion, the source contains only the heading of the next story, I Have a Home, a Happy Home, and the word FINIS. No narrative from that next story is present in this inherited day.</p><p><strong>Devotional focus:</strong> Honest reflection is not meant to trap us in shame. John writes that we can confess our sins and find God faithful to forgive; Paul says salvation is a gift of grace that leads into good work. The earlier battlefield story spoke of people needing care, and this closing lesson turns to the hurts we cause and carry within. None of us needs to pretend we are beyond help. We can receive grace, make amends where possible, and practice love anew.</p><p><strong>Reflect:</strong> What confession, apology, or next step might help you move from regret into restoration?</p><p><strong>Practice:</strong> Take a safe step toward repair: tell the truth, ask forgiveness without demanding it, or offer care to someone you have overlooked.</p><p><strong>Prayer:</strong> Gracious God, meet me with mercy where I have fallen short. Give me courage to repair harm, accept your grace, and walk in newness of life. Amen.</p>"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;


-- Only update plan Scripture references (user_id is null); leave user-authored records untouched.
do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 1,
    "references": [
      "Matthew 5:14-16",
      "1 Peter 3:15-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 2,
    "references": [
      "Psalm 46:1-2",
      "Galatians 6:2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 3,
    "references": [
      "Proverbs 12:10",
      "1 Corinthians 15:51-57"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 4,
    "references": [
      "Proverbs 28:13",
      "1 John 1:9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 5,
    "references": [
      "Luke 7:44-50",
      "Ephesians 4:29"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 6,
    "references": [
      "Ephesians 5:15-16",
      "James 1:5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 7,
    "references": [
      "Mark 8:36-37",
      "Luke 12:6-7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 8,
    "references": [
      "Mark 4:35-41",
      "Psalm 34:17-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 9,
    "references": [
      "Mark 2:27-28",
      "Hebrews 4:9-11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 10,
    "references": [
      "Isaiah 58:6-10",
      "Luke 13:10-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 11,
    "references": [
      "1 Peter 3:3-4",
      "1 Samuel 16:7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 12,
    "references": [
      "Galatians 6:2",
      "Romans 12:15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 13,
    "references": [
      "Ephesians 4:25",
      "1 John 1:8-9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 14,
    "references": [
      "Proverbs 12:22",
      "Colossians 3:9-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 15,
    "references": [
      "Hebrews 12:1-3",
      "2 Corinthians 3:18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 16,
    "references": [
      "Luke 6:27-36",
      "Matthew 25:35-40"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000298",
    "day_number": 17,
    "references": [
      "1 John 1:8-9",
      "Ephesians 2:8-10"
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

-- Keep the adaptation off published feeds until editorial approval.
update public.devotional_plans
set status = 'published', updated_at = now()
where id = '90000000-0000-0000-0000-000000000298'::uuid;

commit;
