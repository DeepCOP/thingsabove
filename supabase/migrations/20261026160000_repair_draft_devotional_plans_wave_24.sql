-- Wave 24: Plan 317 — Letters to a Daughter and A Little Sermon to School-Girls (Helen Ekin Starrett).
-- 20 original, source-grounded daily devotional adaptations, not a word-for-word modernization.
-- Gender/class/health prejudices are historically contextualized rather than endorsed.
-- Reviewed for devotional suitability and approved for publication.
-- The migration does not delete or recreate day records, protecting existing progress.
-- IMPORTANT: apply AFTER prior 2026-10-21 modernization migrations to avoid overwrites.

begin;

do $$
declare
  expected_source text;
  expected_total integer;
  present_days integer;
  first_day integer;
  last_day integer;
  distinct_days integer;
begin
  select source_url, total_days into expected_source, expected_total
  from public.devotional_plans
  where id = '90000000-0000-0000-0000-000000000317'::uuid;
  if not found then raise exception 'Plan 317 is missing'; end if;
  if expected_source is distinct from 'https://www.gutenberg.org/ebooks/15419' or expected_total is distinct from 20 then
    raise exception 'Plan 317 source URL or total_days differs from reviewed source';
  end if;
  select count(*), min(day_number), max(day_number), count(distinct day_number)
  into present_days, first_day, last_day, distinct_days
  from public.devotional_days where plan_id = '90000000-0000-0000-0000-000000000317'::uuid;
  if present_days <> 20 or first_day <> 1 or last_day <> 20 or distinct_days <> 20 then
    raise exception 'Plan 317 must have exactly 20 unique numbered days; found %', present_days;
  end if;
end
$$;

update public.devotional_plans as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "value": "A Life of Wisdom and Kindness: 20 Readings Inspired by Helen Ekin Starrett"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "value": "Twenty original Scripture-led devotional readings inspired by Helen Ekin Starrett’s Letters to a Daughter and A Little Sermon to School-Girls (1886). Following the book’s original sequence, the readings explore character at home, respectful speech, self-control, learning, purposeful work, healthy limits, stewardship, mindful conversation, friendship, wise boundaries, tact, hospitality, compassion in grief, Scripture, and dignity across social differences. The readings are newly authored editorial adaptations, not quotations or sentence-by-sentence modernizations of Starrett. Gender prescriptions, class expectations, appearance-based judgments, and assumptions about disability, health, fatigue, and blame are identified as historical limitations and are not endorsed. Original attribution and Project Gutenberg source link are retained for comparison."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 1,
    "value": "Character Begins Close to Home"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 2,
    "value": "Respect with an Honest Voice"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 3,
    "value": "The Freedom of Self-Control"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 4,
    "value": "Learn Deeply, Choose Freely"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 5,
    "value": "Skills and Health are Gifts, Not Measures of Worth"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 6,
    "value": "Make Space for What Matters"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 7,
    "value": "Be Present and Keep Your Commitments"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 8,
    "value": "Let Curiosity Replace Performance"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 9,
    "value": "Listen Well and Choose Friends Wisely"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 10,
    "value": "Boundaries without Contempt"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 11,
    "value": "Friendship Should Make Room for Others"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 12,
    "value": "Tact is Empathy in Action"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 13,
    "value": "Respect Is More than a Social Label"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 14,
    "value": "Let Learning Transform Character"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 15,
    "value": "Faith that Comforts, Not Frightens"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 16,
    "value": "Let the Word Form a Loving Heart"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 17,
    "value": "Offer Kindness without Humiliation"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 18,
    "value": "The Golden Rule Needs Imagination"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 19,
    "value": "Grace Goes Beyond the Rulebook"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 20,
    "value": "Quiet Character Makes a Lasting Difference"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 1,
    "value": "<p><strong>Read:</strong> Colossians 3:12-14; Romans 12:9-13</p><p><strong>Source and historical context:</strong> In her opening letter, Helen Ekin Starrett tells a daughter that attractive social manners are rooted in daily character. She recalls a capable student whose skill and charm at school did not carry into her treatment of family members. Her nineteenth-century expectations about how girls should appear in public are part of the historical setting, not a universal measure of faith.</p><p><strong>Devotional focus:</strong> Paul describes the character of Christian community as compassion, kindness, humility, patience, forgiveness, and love. These qualities matter most when no audience is watching. We may find it easy to be courteous to visitors while withholding patience from people at home. Faithful love invites us to close that gap, without assuming that every home is safe or that respect requires accepting mistreatment.</p><p><strong>Reflect:</strong> Who experiences my ordinary behavior when I am tired, distracted, or frustrated—and what would genuine kindness look like for them?</p><p><strong>Practice:</strong> Offer one practical act of care to someone you live or work with. If you have spoken sharply, acknowledge it without making excuses.</p><p><strong>Prayer:</strong> Lord, grow honest kindness in me. Let the care I show in public be present also in my closest relationships. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 2,
    "value": "<p><strong>Read:</strong> James 1:19-20; 1 Peter 3:8-9</p><p><strong>Source and historical context:</strong> Starrett continues her discussion of manners with gentleness, measured speech, and respect for elders. She objects to interruption and exaggeration, but also treats conspicuous speech by young women as particularly improper. The enduring lesson is thoughtful communication, not the demand that girls or anyone else become invisible.</p><p><strong>Devotional focus:</strong> James calls believers to listen readily, speak thoughtfully, and resist anger that harms others. Respect does not mean never disagreeing with a parent, teacher, leader, or older person. A humble voice can also be clear and courageous. Good listening makes space for others; truthful speaking makes space for conscience. Both matter in relationships shaped by mutual dignity.</p><p><strong>Reflect:</strong> When do I interrupt or dismiss others, and when do I stay silent even though a respectful truth needs to be said?</p><p><strong>Practice:</strong> In one conversation today, let the other person finish before responding. Then say what you mean clearly and kindly.</p><p><strong>Prayer:</strong> God of wisdom, give me patient ears and an honest voice. Teach me to honor people without surrendering truth. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 3,
    "value": "<p><strong>Read:</strong> Galatians 5:22-23; James 3:2-10</p><p><strong>Source and historical context:</strong> In her second letter, Starrett presents self-control as the foundation of study, reliable work, and careful speech. She especially warns that temper and gossip can hurt relationships. Her confidence that determination overcomes almost every obstacle needs qualification: fatigue, disability, economic demands, and illness cannot simply be willed away.</p><p><strong>Devotional focus:</strong> Self-control is named among the fruit of the Spirit. It is not a demand to suppress every feeling or work beyond our limits; it is freedom to choose what serves love. A pause before speaking can stop a wound. A modest daily routine can make learning possible. And when we fail, confession and repair matter more than pretending we never struggle.</p><p><strong>Reflect:</strong> What recurring moment makes it hardest for me to choose a patient response?</p><p><strong>Practice:</strong> Choose a short pause before replying when frustrated today. If possible, plan one manageable period for work or study and one for needed rest.</p><p><strong>Prayer:</strong> Holy Spirit, strengthen my choices without hardening my heart. Help me use words that heal and habits that sustain good work. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 4,
    "value": "<p><strong>Read:</strong> Proverbs 4:5-7; Philippians 4:8-9</p><p><strong>Source and historical context:</strong> Starrett urges disciplined reading and invokes divine help in forming habits. Midway through this source segment she turns to the prospects of marriage and home management, presenting them as the central aims of a young woman. This advice reflects her age; readers today may be called to many different forms of family life, work, friendship, and service.</p><p><strong>Devotional focus:</strong> Scripture values wisdom and invites the mind to dwell on what is true, honorable, just, and worthy of praise. Deep learning is not a contest of fashionable books. Nor is a meaningful future limited to one domestic or professional pattern. We can cultivate discernment, develop abilities, and approach relationships with honesty and consent while remaining open to the paths God may unfold.</p><p><strong>Reflect:</strong> Which choice about learning or my future comes mainly from social pressure rather than thoughtful conviction?</p><p><strong>Practice:</strong> Spend twenty focused minutes learning something worthwhile. Write one sentence naming a hope you hold freely, not merely because it is expected.</p><p><strong>Prayer:</strong> Father, guide my mind and my decisions. Give me courage to learn, wisdom in relationships, and freedom to serve where I am called. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 5,
    "value": "<p><strong>Read:</strong> Colossians 3:23-24; Mark 6:30-32</p><p><strong>Source and historical context:</strong> Starrett encourages young women to earn useful skills and financial independence, even as she ranks marriage and homemaking above other callings. She also recommends protecting physical health, but sometimes describes illness or untidiness as evidence of character defects. Those judgments should not be imposed on people with chronic illness, disabilities, or limited resources.</p><p><strong>Devotional focus:</strong> Work can be a place to practice service, creativity, and stewardship. Jesus also invites exhausted disciples to rest. A person is not more precious because they can earn more, look healthy, or perform every task without help. We honor God by using what we have responsibly and honoring the limits of our bodies. Receiving assistance can be as faithful as offering it.</p><p><strong>Reflect:</strong> Do I treat my work, appearance, or stamina as proof of my value?</p><p><strong>Practice:</strong> Practice one skill that serves others. Also make one reasonable choice to care for your wellbeing, without comparing yourself to someone else.</p><p><strong>Prayer:</strong> God, receive my work and my limitations. Teach me to care for my body and honor the dignity of every person, whatever their capacity. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 6,
    "value": "<p><strong>Read:</strong> Luke 10:38-42; 1 Corinthians 14:40</p><p><strong>Source and historical context:</strong> Starrett describes a simply furnished room kept with care, contrasting it with clutter and needless ornament. She uses the room, clothing, and personal grooming as signals of a woman’s refinement. These details reflect Victorian norms and available resources; neatness is a useful practice but not a reliable test of someone’s goodness.</p><p><strong>Devotional focus:</strong> Martha’s concern with household tasks was real, yet Jesus gently reminded her that love and attention matter more than anxious activity. Some order can free time and attention, while perfectionism can consume them. We do not have to earn belonging through spotless surroundings. The purpose of caring for our space is to make everyday life more hospitable, practical, and peaceful.</p><p><strong>Reflect:</strong> Is there one part of my environment I can care for without allowing the task to become a judgment on myself or others?</p><p><strong>Practice:</strong> Clear or organize one small area for ten minutes. Use the time or calm it creates to be present with someone or in prayer.</p><p><strong>Prayer:</strong> Jesus, help me value people over appearances. Let the spaces I tend support welcome, rest, and generous attention. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 7,
    "value": "<p><strong>Read:</strong> Ephesians 5:15-17; Romans 12:10-11</p><p><strong>Source and historical context:</strong> Starrett recalls a turning point when she began arriving promptly at family meals and noticed that this allowed her to assist her mother. The segment then opens a letter about society, conversation, and the broad knowledge that helps people exchange ideas. Her account reflects a household where much labor fell to women.</p><p><strong>Devotional focus:</strong> Using time wisely is not just about punctuality for its own sake. Arriving as promised, sharing practical work fairly, and preparing to participate in conversation communicate respect. Yet loving people also requires flexibility when illness, caregiving, transit, or other constraints disrupt plans. Reliability grows from honest communication, not from shaming those who struggle.</p><p><strong>Reflect:</strong> Which small commitment could I keep more attentively because it affects someone else’s day?</p><p><strong>Practice:</strong> Follow through on one promise promptly, or communicate early if you cannot. Ask whose invisible work you could help share.</p><p><strong>Prayer:</strong> Lord, make me faithful in ordinary commitments and considerate when plans change. Let my time become a gift of love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 8,
    "value": "<p><strong>Read:</strong> Proverbs 18:13; James 1:19</p><p><strong>Source and historical context:</strong> Starrett quotes a social scene in which a young woman tries to sound well-read and is embarrassed by gaps in her knowledge. She then criticizes self-centered speech, loud laughter, and sarcasm. Some of her objections concern status and femininity rather than morality; the more lasting concern is whether conversation makes room for truth and for others.</p><p><strong>Devotional focus:</strong> We do not need to pretend to know everything in order to contribute. Proverbs cautions against answering before listening, and James commends slow, attentive speech. A genuine question can open a richer exchange than rehearsed cleverness. Humor can be a gift when shared kindly, but sarcasm that humiliates others poisons trust. Humility is both the courage to admit uncertainty and the willingness to learn.</p><p><strong>Reflect:</strong> When do I try to impress people rather than connect with them?</p><p><strong>Practice:</strong> Ask someone a sincere question about a subject they know. If you do not understand, say so without apology or pretence.</p><p><strong>Prayer:</strong> God of truth, free me from the need to appear impressive. Give me curiosity, attentive listening, and speech that builds connection. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 9,
    "value": "<p><strong>Read:</strong> Philippians 2:3-4; Proverbs 13:20</p><p><strong>Source and historical context:</strong> At the end of her conversation advice, Starrett urges readers to listen without interrupting. She then turns to friendships and the influence of companions. Her period’s tendency to judge people through reputation, respectability, and family background should not determine who deserves warmth or dignity.</p><p><strong>Devotional focus:</strong> Listening is a practice of considering another person’s interests, not merely waiting for a turn to speak. Friendship also shapes us: shared habits can encourage truthfulness, learning, and compassion, or make cruelty feel normal. Wisdom asks us to attend to patterns of behavior while remembering that people can grow and that every person deserves courtesy. Our close confidants need not be identical to us; they should help us become more truthful and loving.</p><p><strong>Reflect:</strong> Do my closest conversations create room for other people’s thoughts, and do my friendships encourage growth?</p><p><strong>Practice:</strong> Give a friend uninterrupted attention. Thank someone whose character has helped you learn or act kindly.</p><p><strong>Prayer:</strong> Lord, teach me to listen well and choose relationships shaped by integrity. Make me a friend who strengthens rather than diminishes others. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 10,
    "value": "<p><strong>Read:</strong> 1 Thessalonians 5:14-15; Proverbs 4:23</p><p><strong>Source and historical context:</strong> Starrett lists traits she regards as dangers in companions: dishonesty, gossip, idleness, disrespect, showiness, and tolerance of undue familiarity. Some examples unfairly blame young women for others’ disrespectful behavior, and she interprets tiredness as a failure of discipline. Those claims are not carried into this reading.</p><p><strong>Devotional focus:</strong> It is wise to protect trust, personal boundaries, and the people for whom we are responsible. Paul also asks believers to encourage the fainthearted, help the weak, and be patient with everyone. The call is neither to overlook harmful patterns nor to despise people who struggle. Healthy friendship allows an honest no, consent, accountability, and compassion. A person who violates your boundaries is responsible for that conduct.</p><p><strong>Reflect:</strong> Where do I need a clearer boundary, and where do I need more patience?</p><p><strong>Practice:</strong> State one boundary kindly and firmly when needed. Offer support to someone facing difficulty rather than assuming their struggle is laziness.</p><p><strong>Prayer:</strong> God of mercy and truth, give me wise boundaries without bitterness and compassion without denial. Help me act with courage and care. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 11,
    "value": "<p><strong>Read:</strong> Proverbs 17:17; Hebrews 10:24-25</p><p><strong>Source and historical context:</strong> Starrett recommends friendships that encourage high aims, warns against intense attachments that become exclusive, and describes how a considerate guest follows household rhythms. Her observations are set in a formal domestic culture, but the insight about sharing attention and responsibilities extends far beyond that setting.</p><p><strong>Devotional focus:</strong> A loyal friend is present in difficulty and notices the needs of people beyond the immediate friendship. Companionship can become possessive if it demands that others abandon work, family, or rest to prove affection. Hebrews calls believers to encourage one another toward love and good deeds. Mutuality means respecting a person’s time, supporting their commitments, and welcoming people who might otherwise be left out.</p><p><strong>Reflect:</strong> Does one of my relationships ask for more attention than either person can freely and wisely give?</p><p><strong>Practice:</strong> Check in with a friend about what would support them this week. When visiting or gathering, notice a task or person who needs consideration.</p><p><strong>Prayer:</strong> Lord, make my friendships steady, generous, and free. Teach me to honor others’ responsibilities and widen the circle of care. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 12,
    "value": "<p><strong>Read:</strong> Ephesians 4:29; Romans 12:18</p><p><strong>Source and historical context:</strong> Starrett ends her discussion of visits and begins a letter on tact. She describes a guest whose blunt criticism of a meal embarrassed the hosts, then suggests that tact grows from understanding how comments affect others. Her polished rules of etiquette are historically specific; kindness and consideration are the deeper concern.</p><p><strong>Devotional focus:</strong> Paul urges speech that meets the need of the moment and builds up the listener. Tact is not dishonest flattery or silence in the face of injustice; it is choosing a fitting moment, tone, and way to express truth. We can decline a meal without insulting its cook, disagree without belittling a person, and offer correction privately when public embarrassment would serve no good purpose.</p><p><strong>Reflect:</strong> When has being factually correct tempted me to overlook how my words landed?</p><p><strong>Practice:</strong> Before one difficult comment, ask: Is it true? Is it needed? Is it kind in its manner? Adjust your words without hiding the truth.</p><p><strong>Prayer:</strong> Jesus, make me both truthful and gentle. Let my words protect dignity and bring clarity rather than needless pain. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 13,
    "value": "<p><strong>Read:</strong> James 2:1-4; 1 Corinthians 13:4-7</p><p><strong>Source and historical context:</strong> Starrett moves from unobtrusive manners to asking who deserves to be called cultivated. She contrasts outward polish and wealth with inner consideration, though she still assumes particular upper-class norms of speech and behavior. These customs may reveal social training, but they are not trustworthy measures of intelligence, holiness, or worth.</p><p><strong>Devotional focus:</strong> James explicitly warns against giving the well-dressed or wealthy a favored place in the community. Love, according to Paul, is patient and kind, not boastful or self-seeking. Christian hospitality notices the person who lacks status and creates a place for them. Real refinement is less about knowing fashionable codes than about respecting the dignity of people whose accents, clothes, habits, or circumstances differ from ours.</p><p><strong>Reflect:</strong> Whose contribution might I overlook because they do not fit the image of someone impressive or accomplished?</p><p><strong>Practice:</strong> Include a person who is regularly ignored in a discussion or gathering. Hear their perspective without trying to correct their style.</p><p><strong>Prayer:</strong> God who shows no favoritism, expose my hidden rankings. Teach me to welcome people for who they are, not for the status they carry. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 14,
    "value": "<p><strong>Read:</strong> Micah 6:8; 2 Timothy 3:14-17</p><p><strong>Source and historical context:</strong> Starrett cites Emerson to argue that a genuinely cultivated spirit rests on moral concern. She notes that possessions, artistic accomplishments, and expensive surroundings can be acquired without kindness. Near the end of the segment she turns to religious education, remembering the strict devotional customs of earlier generations.</p><p><strong>Devotional focus:</strong> Knowledge and skill are valuable, but learning reaches deeper when it forms our conduct. Micah joins justice, mercy, and humility; Scripture teaches and equips people for good work. Neither aesthetic taste nor religious routine automatically produces those qualities. We can appreciate education while asking how it helps us respond to suffering, use power fairly, and practice integrity. Spiritual teaching should form love rather than fear or superiority.</p><p><strong>Reflect:</strong> What have I learned recently that ought to change how I treat someone?</p><p><strong>Practice:</strong> Choose one idea from your reading or worship and turn it into a small act of justice, kindness, or responsibility today.</p><p><strong>Prayer:</strong> Lord, do not let my knowledge outrun my love. Form in me a character that seeks justice, loves mercy, and walks humbly with you. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 15,
    "value": "<p><strong>Read:</strong> Psalm 34:17-18; Matthew 11:28-30</p><p><strong>Source and historical context:</strong> Starrett reflects on older family worship practices that sometimes relied on severe threats and fear. She then worries that religious instruction has weakened, while also recognizing how loss, disappointment, and grief awaken questions about God. Her sweeping claim that only one response can sustain every sufferer is stronger than the experiences of all people warrant.</p><p><strong>Devotional focus:</strong> The psalmist tells us that God is near the brokenhearted. Jesus invites the weary to come to him for rest. Faith need not be produced through terror, and grief does not mean a person has failed to trust. Prayer, Scripture, trustworthy relationships, and practical help may accompany one another in suffering. We can offer consolation without insisting that someone interpret their pain as a lesson or hurry toward cheerfulness.</p><p><strong>Reflect:</strong> When have I used pressure where an invitation to hope would be more fitting?</p><p><strong>Practice:</strong> Offer a listening presence to someone bearing a burden, or tell God honestly about your own sorrow without editing your feelings.</p><p><strong>Prayer:</strong> Compassionate Lord, meet us in grief and weariness. Teach me to offer the comfort I have received without judgment or pressure. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 16,
    "value": "<p><strong>Read:</strong> Psalm 119:105; Romans 12:10-12</p><p><strong>Source and historical context:</strong> In the close of her letters, Starrett urges personal choice, Bible reading, and turning to God for comfort. The text then introduces her Little Sermon to School-Girls, opening with Romans 12:10 and 1 Peter 3:4 and asking what makes someone genuinely lovable. It is a transition between two distinct works bound into one book.</p><p><strong>Devotional focus:</strong> The Bible does more than supply rules for appearances; it teaches us to walk in the light of God’s love. Romans calls Christians to honor one another and remain patient in trouble, steadfast in prayer. Becoming loving is not the same as making everyone like us. We can act with grace while still setting boundaries or facing rejection. God invites a free, growing response rather than compulsory conformity.</p><p><strong>Reflect:</strong> Where would Scripture help me exchange anxiety about approval for faithful love?</p><p><strong>Practice:</strong> Read Romans 12:9–18 slowly. Choose one phrase to guide a conversation or decision today.</p><p><strong>Prayer:</strong> God, let your word give light to my choices. Root my identity in your love and teach me to honor others sincerely. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 17,
    "value": "<p><strong>Read:</strong> James 2:1-5; Mark 10:13-16</p><p><strong>Source and historical context:</strong> Starrett’s school sermon contrasts a professor who corrects a student without humiliating him with a pupil who publicly mocks a newer student for an unfamiliar custom. She also notices that attractive or entertaining classmates can receive more attention than quieter students. Her descriptions of appearance are dated, but her concern about ridicule and exclusion remains important.</p><p><strong>Devotional focus:</strong> James warns believers against ranking people by outward appearance, and Jesus welcomes those whom others overlook. Teaching can be firm without cruelty. We need not deny a boundary to be kind: a simple explanation can protect health or property while preserving another person’s dignity. Communities flourish when newcomers can ask questions, make mistakes, and grow without becoming the subject of jokes.</p><p><strong>Reflect:</strong> Who may feel embarrassed or invisible in the group I belong to?</p><p><strong>Practice:</strong> Welcome someone new or overlooked. If a correction is necessary, give it respectfully and, when appropriate, in private.</p><p><strong>Prayer:</strong> Lord Jesus, guard my words from scorn. Give me the courage to welcome, the patience to explain, and the grace to protect another’s dignity. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 18,
    "value": "<p><strong>Read:</strong> Matthew 7:12; Ephesians 4:31-32</p><p><strong>Source and historical context:</strong> Starrett returns to Jesus’ Golden Rule and asks readers to imagine the experience of a person who feels awkward or uninformed. She argues that inner character becomes visible through restraint and thoughtfulness toward parents, teachers, and peers. Her examples rely on conventional etiquette, but the heart of her argument is attentiveness to other people’s feelings and needs.</p><p><strong>Devotional focus:</strong> Kindness grows when we recognize that another person’s situation may be different from ours. The Golden Rule is not a command to assume everyone wants the same treatment; it invites us to extend the care we would hope to receive. Sometimes that means asking what would help rather than guessing. Forgiveness, patience, and listening are practical forms of spiritual maturity that no class or age exclusively possesses.</p><p><strong>Reflect:</strong> Is there someone whose experience I have judged without first trying to understand it?</p><p><strong>Practice:</strong> Ask a person what support or respect looks like to them. Act on their answer where possible, instead of relying on assumptions.</p><p><strong>Prayer:</strong> Father, open my eyes to other people’s burdens and hopes. Make my kindness thoughtful, humble, and responsive. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 19,
    "value": "<p><strong>Read:</strong> Colossians 3:12-17; Galatians 5:22-23</p><p><strong>Source and historical context:</strong> Near the end of the school sermon, Starrett questions endless lists of social rules and commends common sense, healthy habits, and sincere cultivation of mind and heart. She still presents admittance to refined society as a reward for good conduct and sometimes judges people by health or outward presentation. Such social acceptance is not the Christian measure of a life.</p><p><strong>Devotional focus:</strong> The fruit of the Spirit cannot be purchased through finishing school, polished clothes, or the right vocabulary. Compassion and patience are learned in actual relationships. Good practical habits matter when they serve life, not when they become tests by which we exclude others. We can keep reasonable social customs while remembering that Christ calls us first to love and gratitude, not to impress a gatekeeping audience.</p><p><strong>Reflect:</strong> Which rule or expectation am I treating as a measure of someone’s value?</p><p><strong>Practice:</strong> Let go of one unnecessary judgment today. Replace it with a concrete act of hospitality or encouragement.</p><p><strong>Prayer:</strong> Holy Spirit, cultivate your fruit in me. Help me practice thoughtful habits without confusing social approval with goodness. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 20,
    "value": "<p><strong>Read:</strong> 1 Samuel 16:7; Luke 14:12-14</p><p><strong>Source and historical context:</strong> Starrett closes with two university-educated women seeking recognition in an influential literary circle. One is richly supported but portrayed as self-centered; the other works through hardship and gains respect through careful scholarship and kindness. Her conclusion favors deep character over conspicuous wealth, though it still assumes elite acceptance is a sign of success.</p><p><strong>Devotional focus:</strong> God looks at the heart rather than outward appearance. Jesus also challenges our habit of extending welcome chiefly to people who can repay us with status or invitations. Meaningful life is not a competition to enter prestigious circles. Excellence matters, but so do humility, solidarity, and care for those with no influence. The quiet worker and the visible leader alike can use their gifts to open doors for others.</p><p><strong>Reflect:</strong> What would I pursue if the reward were making life better for others rather than winning recognition?</p><p><strong>Practice:</strong> Use one skill to encourage someone who has fewer opportunities. Give credit generously and invite a voice that is too often excluded.</p><p><strong>Prayer:</strong> Lord, teach me to value the heart above display. May my gifts create room for others, and may my life seek your good rather than applause. Amen.</p>"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

-- Only modify plan-owned global Scripture reference rows; preserve user-created notes/references.
do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 1,
    "references": [
      "Colossians 3:12-14",
      "Romans 12:9-13"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 2,
    "references": [
      "James 1:19-20",
      "1 Peter 3:8-9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 3,
    "references": [
      "Galatians 5:22-23",
      "James 3:2-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 4,
    "references": [
      "Proverbs 4:5-7",
      "Philippians 4:8-9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 5,
    "references": [
      "Colossians 3:23-24",
      "Mark 6:30-32"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 6,
    "references": [
      "Luke 10:38-42",
      "1 Corinthians 14:40"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 7,
    "references": [
      "Ephesians 5:15-17",
      "Romans 12:10-11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 8,
    "references": [
      "Proverbs 18:13",
      "James 1:19"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 9,
    "references": [
      "Philippians 2:3-4",
      "Proverbs 13:20"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 10,
    "references": [
      "1 Thessalonians 5:14-15",
      "Proverbs 4:23"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 11,
    "references": [
      "Proverbs 17:17",
      "Hebrews 10:24-25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 12,
    "references": [
      "Ephesians 4:29",
      "Romans 12:18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 13,
    "references": [
      "James 2:1-4",
      "1 Corinthians 13:4-7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 14,
    "references": [
      "Micah 6:8",
      "2 Timothy 3:14-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 15,
    "references": [
      "Psalm 34:17-18",
      "Matthew 11:28-30"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 16,
    "references": [
      "Psalm 119:105",
      "Romans 12:10-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 17,
    "references": [
      "James 2:1-5",
      "Mark 10:13-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 18,
    "references": [
      "Matthew 7:12",
      "Ephesians 4:31-32"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 19,
    "references": [
      "Colossians 3:12-17",
      "Galatians 5:22-23"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000317",
    "day_number": 20,
    "references": [
      "1 Samuel 16:7",
      "Luke 14:12-14"
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
        (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
         now(), now());
    end if;
  end loop;
end
$$;

update public.devotional_plans
set status = 'published', updated_at = now()
where id = '90000000-0000-0000-0000-000000000317'::uuid;

commit;
