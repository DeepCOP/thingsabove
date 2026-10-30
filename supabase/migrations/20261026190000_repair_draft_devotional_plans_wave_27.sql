-- Wave 27: Plan 329 — Catherine Booth — a Sketch, by Mildred Duff.
-- Twenty-seven newly written, Scripture-led readings, mapped to original source segments.
-- Update records in place to preserve IDs, day numbers and existing user progress.
-- Apply AFTER all 2026-10-21 modernization migrations (including parts 03 and 09).
-- This is an editorial adaptation, not a modern Bible translation reproduction.

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
  where id = '90000000-0000-0000-0000-000000000329'::uuid;
  if not found then raise exception 'Plan 329 missing'; end if;
  if current_source is distinct from 'https://www.gutenberg.org/ebooks/7125' or current_total is distinct from 27 then
    raise exception 'Plan 329 metadata differs from source reviewed for Wave 27';
  end if;
  select count(*), min(day_number), max(day_number), count(distinct day_number)
  into day_count, first_day, last_day, unique_days
  from public.devotional_days where plan_id = '90000000-0000-0000-0000-000000000329'::uuid;
  if day_count <> 27 or first_day <> 1 or last_day <> 27 or unique_days <> 27 then
    raise exception 'Plan 329 must contain 27 distinct numbered days; found %', day_count;
  end if;
end
$$;

update public.devotional_plans as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Courage, Compassion, and Calling: 27 Readings from Catherine Booth’s Life"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Twenty-seven original, Scripture-led devotional readings inspired by Mildred Duff’s historical sketch of Catherine Booth: her childhood compassion, vocational courage, partnership, preaching, family life, service, faith in adversity, and enduring legacy. Each reading connects with a corresponding source section and includes historical context, reflection, practical action, and prayer. This is a new devotional adaptation rather than a full-text modernization or an independently verified biography."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 1,
    "value": "Compassion Begins Close to Home"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 2,
    "value": "Strength in an Unchosen Season"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 3,
    "value": "Faith That Can Ask Honest Questions"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 4,
    "value": "Courage in Small Beginnings"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 5,
    "value": "A Partnership of Shared Conviction"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 6,
    "value": "Love Makes Room for Growth"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 7,
    "value": "A Home with an Open Purpose"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 8,
    "value": "Making Hard Choices Together"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 9,
    "value": "Faith in an Unsettled Journey"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 10,
    "value": "The Legacy of a Shared Life"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 11,
    "value": "Finding a Voice to Serve"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 12,
    "value": "Speak with Preparation and Love"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 13,
    "value": "One Message, Every Person Matters"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 14,
    "value": "Teach Children with Love and Respect"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 15,
    "value": "Words That Build, Words That Wound"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 16,
    "value": "Encourage a Calling, Honor a Choice"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 17,
    "value": "Wise Boundaries and Lasting Care"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 18,
    "value": "Faithful Work, Visible Kindness"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 19,
    "value": "Truthfulness Joined with Mercy"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 20,
    "value": "Resting in Grace, Learning to Trust"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 21,
    "value": "Love That Notices People"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 22,
    "value": "Care That Outlasts a Conversation"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 23,
    "value": "Courage That Challenges Unjust Limits"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 24,
    "value": "Faith Through Darkness, with Support"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 25,
    "value": "When Strength Changes, Love Remains"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 26,
    "value": "Grieving Together in Hope"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 27,
    "value": "A Legacy Measured in Love"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 1,
    "value": "<p><strong>Read:</strong> Colossians 3:12-14; Proverbs 12:10</p><p><strong>Source and historical context:</strong> Mildred Duff recalls Catherine Mumford’s early Bible study, honest confession, distress when sheep were mistreated, concern for other pupils, and years of childhood illness. The sketch is an admiring Salvation Army portrait, not an independent account of every event.</p><p><strong>Devotional focus:</strong> Compassion is more than feeling deeply. The child who grieved for injured animals also tried to help classmates who struggled. Scripture calls us to clothe ourselves with kindness, patience, and love in the ordinary places where we live. We can value truth without shaming a child for making a mistake, and care for suffering creatures without judging those who respond differently.</p><p><strong>Reflect:</strong> Who near me needs patient attention rather than an impressive speech?</p><p><strong>Practice:</strong> Offer a practical kindness to someone overlooked, and respond gently if a child or friend admits a mistake.</p><p><strong>Prayer:</strong> Lord, give me truthful words and a tender heart that notices those who suffer. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 2,
    "value": "<p><strong>Read:</strong> 2 Corinthians 4:16-18; Psalm 119:105</p><p><strong>Source and historical context:</strong> During a prolonged spinal illness, young Catherine read Scripture and other works, wrote summaries, and sewed when her strength permitted. Duff later interprets the enforced solitude as preparation for public ministry; that is the biographer’s retrospective understanding.</p><p><strong>Devotional focus:</strong> Illness is not evidence of spiritual failure, nor must suffering be justified by later achievements. Yet a constrained season can still contain gifts: learning, gentle companionship, prayer, and creative work at a sustainable pace. God’s light is available not only when we accomplish much, but also when our bodies require rest. The worth of a person does not depend on productivity.</p><p><strong>Reflect:</strong> How might I receive today’s limits without treating them as a judgment on my worth?</p><p><strong>Practice:</strong> Choose a small, life-giving activity within your capacity; allow yourself or someone else to rest without guilt.</p><p><strong>Prayer:</strong> God of comfort, meet me in limitation and teach me to value people beyond what they can produce. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 3,
    "value": "<p><strong>Read:</strong> 2 Corinthians 6:14; Romans 8:15-16</p><p><strong>Source and historical context:</strong> The biography describes Catherine ending a youthful courtship because she believed their commitments conflicted, followed by weeks of spiritual anxiety before finding assurance through a familiar hymn. The relationship decision is described in terms of her convictions and historical church expectations.</p><p><strong>Devotional focus:</strong> Shared values matter in close relationships, but respect does not require contempt for people who believe differently. Catherine’s longing for assurance also reminds us that faith can involve uncertainty before it involves joy. God’s invitation is not to perform certainty for others; it is to bring our whole heart, fears included, into the light of grace.</p><p><strong>Reflect:</strong> Am I seeking clarity because it leads toward love, or only because I fear being judged?</p><p><strong>Practice:</strong> Name one honest question in prayer. In a close relationship, discuss values respectfully without pressuring another person.</p><p><strong>Prayer:</strong> Father, guide my commitments and hold me when confidence comes slowly. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 4,
    "value": "<p><strong>Read:</strong> 2 Timothy 1:7; Philippians 1:6</p><p><strong>Source and historical context:</strong> Catherine struggles to pray aloud, records one small victory in her diary, studies Scripture with renewed discipline, and grieves over her father’s estrangement from faith. Duff later reports the father’s return to church.</p><p><strong>Devotional focus:</strong> Courage is not the absence of a racing heart. Sometimes it is offering a few imperfect words, receiving support, or beginning again tomorrow. Private practices of prayer and reading can nurture a lifelong vocation, but they should not become a burden that ignores bodily needs. We cannot control another person’s faith, even when we deeply love them.</p><p><strong>Reflect:</strong> What modest act of courage is possible without demanding perfection from myself?</p><p><strong>Practice:</strong> Make a manageable plan for prayer or Scripture this week. Encourage a shy person rather than forcing them to perform.</p><p><strong>Prayer:</strong> Spirit of God, give me patience for gradual growth and love for those whose journeys differ from mine. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 5,
    "value": "<p><strong>Read:</strong> Amos 3:3; Ephesians 4:15-16</p><p><strong>Source and historical context:</strong> Catherine meets William Booth, discovers their common concern for evangelism and alcohol-related harm, and exchanges letters about their future. She repeatedly insists that William must make his own conscientious decisions.</p><p><strong>Devotional focus:</strong> A strong partnership is not built by one person disappearing into the other’s mission. Shared purpose flourishes when each person can think, disagree, pray, and choose freely. The letters show a woman whose counsel mattered and whose respect made room for another person’s conscience. Love tells the truth while guarding the other’s dignity.</p><p><strong>Reflect:</strong> Do the people I love have room to make a decision that I would not choose?</p><p><strong>Practice:</strong> Ask a partner or friend what matters most to them, and listen without trying to engineer their answer.</p><p><strong>Prayer:</strong> God of wisdom, teach us to support one another in truth and freedom. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 6,
    "value": "<p><strong>Read:</strong> Proverbs 27:17; 1 Corinthians 13:4-7</p><p><strong>Source and historical context:</strong> Their engagement letters show Catherine urging William to pray, study, resist ambition, and prepare his sermons. William values the outlines she sends. The section leads toward their wedding on June 15, 1855.</p><p><strong>Devotional focus:</strong> Encouragement is more useful than flattery. Catherine treated William’s capacities as gifts worth developing, not as a reason to pursue applause. Wise companions sharpen one another while respecting limits, fatigue, and personal agency. Marriage, friendship, and ministry are healthiest when growth is mutual and correction is gracious, never controlling.</p><p><strong>Reflect:</strong> How do my words help someone grow without making them feel managed?</p><p><strong>Practice:</strong> Offer a specific word of encouragement, then invite honest feedback about how you can be more supportive.</p><p><strong>Prayer:</strong> Lord, keep our affection humble and make our partnerships places of mutual growth. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 7,
    "value": "<p><strong>Read:</strong> Matthew 5:14-16; Joshua 24:15</p><p><strong>Source and historical context:</strong> The brief closing segment of the engagement chapter quotes Catherine’s longing to see William and her shared intention that their home make Christ known. It looks ahead to their married work without narrating new events.</p><p><strong>Devotional focus:</strong> A home can be a place of real tenderness and a place of welcome to others. Service does not erase the need for intimacy, privacy, and rest. The desire to make Christ known begins in how people within the household are treated: with honesty, kindness, listening, and room to flourish.</p><p><strong>Reflect:</strong> Does my idea of serving others also include caring well for those closest to me?</p><p><strong>Practice:</strong> Plan one unhurried moment of connection at home, and one simple act of hospitality that fits your circumstances.</p><p><strong>Prayer:</strong> Jesus, let our closest relationships shine with the peace and kindness we hope to share. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 8,
    "value": "<p><strong>Read:</strong> Luke 14:28-30; James 1:5</p><p><strong>Source and historical context:</strong> Early married life brings constant travel and little stability. The Booths face pressure to accept settled ministry instead of itinerant evangelism, weighing income, children, and health against their sense of calling.</p><p><strong>Devotional focus:</strong> Faith does not mean refusing to count the cost. It means bringing the cost into honest prayer and wise conversation. The Booths’ choice was their choice; it is not a universal rule that families should abandon financial security. Courageous discernment takes account of dependents, consent, resources, and the different ways people may serve God faithfully.</p><p><strong>Reflect:</strong> When facing a decision, have I named both my hopes and the needs of people affected?</p><p><strong>Practice:</strong> List the practical costs, people affected, and available support before making one difficult commitment.</p><p><strong>Prayer:</strong> God, give us wisdom to serve faithfully without neglecting those entrusted to our care. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 9,
    "value": "<p><strong>Read:</strong> Philippians 4:11-13; Micah 6:8</p><p><strong>Source and historical context:</strong> After leaving a secure post, the Booths travel with four children. Catherine admits the exhaustion of frequent separation and lodging. Later William proposes serving poor communities in London’s East End, and she consents despite financial uncertainty.</p><p><strong>Devotional focus:</strong> Calling may require change, but a holy purpose does not cancel ordinary exhaustion or the need for stability. Catherine spoke plainly about how difficult the travel felt. Her openness is instructive: we can love the mission and still acknowledge the strain. The East End also reminds us that good news is inseparable from recognizing the dignity and real needs of neighbors experiencing poverty.</p><p><strong>Reflect:</strong> Where have I mistaken honest weariness for a lack of faith?</p><p><strong>Practice:</strong> Check in on a caregiver or community worker, offering a concrete form of practical support rather than only praise.</p><p><strong>Prayer:</strong> Lord, sustain people who carry heavy responsibilities and help us serve our neighbors with dignity. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 10,
    "value": "<p><strong>Read:</strong> 1 Thessalonians 4:13-14; Romans 12:15</p><p><strong>Source and historical context:</strong> The concluding pages of “A Life of Sacrifice” look forward to William Booth’s grief at Catherine’s graveside. He describes her as friend, counselor, and helper, and laments the loss of their shared life.</p><p><strong>Devotional focus:</strong> The depth of grief often reflects the depth of companionship. Christian hope does not demand that mourners suppress their tears. We honor those we love by remembering the particular ways they cared, advised, corrected, and accompanied us. Faith can sit beside loss without explaining it away.</p><p><strong>Reflect:</strong> Whose quiet care has shaped my life, and have I made room to express gratitude?</p><p><strong>Practice:</strong> Write down one treasured act of care from someone living or deceased. If that person is living, thank them.</p><p><strong>Prayer:</strong> God of comfort, be near to those who grieve and help us remember love with gratitude. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 11,
    "value": "<p><strong>Read:</strong> Acts 2:17-18; 1 Peter 4:10-11</p><p><strong>Source and historical context:</strong> The chapter “The Speaker” recalls a time when public preaching by women was contested. Catherine rises to speak in a service despite her former fear, and the biography describes subsequent invitations and her growing public voice.</p><p><strong>Devotional focus:</strong> A gift should not be dismissed because its bearer does not fit an expectation. The early church describes sons and daughters speaking as God’s Spirit enables them. Catherine’s first step was not a performance of confidence but an act of conviction. We can make communities safer for people whose voices have been overlooked and ensure opportunities are shared rather than guarded.</p><p><strong>Reflect:</strong> Whose voice am I quick to underestimate, and what might I learn by listening?</p><p><strong>Practice:</strong> Invite someone who is rarely heard to contribute, without forcing them to speak before they are ready.</p><p><strong>Prayer:</strong> Spirit of truth, open doors for gifts that have been overlooked and give us ears that listen. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 12,
    "value": "<p><strong>Read:</strong> Colossians 4:5-6; 2 Timothy 2:15</p><p><strong>Source and historical context:</strong> Catherine describes intense preparation, prayer, vulnerability before large meetings, and her concern that the message reach real people. Duff gives examples from campaigns where listeners responded to her preaching.</p><p><strong>Devotional focus:</strong> Good communication is neither a polished performance nor a demand for a dramatic response. It requires careful thought, truthful speech, humility, and attention to the people listening. Preparation is a form of respect; prayer helps keep the speaker from treating people as an audience to conquer. Our words should be understandable, gracious, and open to honest questions.</p><p><strong>Reflect:</strong> Am I more concerned with sounding impressive than with helping someone understand?</p><p><strong>Practice:</strong> Before an important conversation, identify your main point and one question that invites the other person’s perspective.</p><p><strong>Prayer:</strong> Lord, make my speech clear, humble, and worthy of the trust others place in me. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 13,
    "value": "<p><strong>Read:</strong> James 2:1-4; 2 Corinthians 5:18-20</p><p><strong>Source and historical context:</strong> The final section on preaching includes reported responses from sisters in a publican’s family, large meetings, and Catherine’s resolve to speak consistently to both wealthy and poor listeners. The numbers are claims of the historical narrative.</p><p><strong>Devotional focus:</strong> The gospel cannot become one message for the influential and another for the disregarded. James warns against giving special honor to wealth. If we speak of reconciliation, our relationships should show it: patient listening, equal dignity, no manipulation, and an invitation rather than pressure. The worth of a life is greater than any attendance total or public result.</p><p><strong>Reflect:</strong> Am I treating someone’s social position as a measure of their importance?</p><p><strong>Practice:</strong> Practice equal attention today: greet, listen to, and assist someone who receives little recognition.</p><p><strong>Prayer:</strong> God, free me from favoritism and make my message and conduct consistent. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 14,
    "value": "<p><strong>Read:</strong> Deuteronomy 6:6-7; Mark 10:13-16</p><p><strong>Source and historical context:</strong> Duff portrays Catherine as an attentive mother who taught faith at home, prayed for her children, involved them in acts of giving, and maintained a simple household. The text also reports physical punishment and pressure around conversion.</p><p><strong>Devotional focus:</strong> Children need nurture, safety, and room to grow. Their questions and consciences deserve care, not fear or coercion. Catherine’s encouragement of generosity can inspire us, while harsh discipline and compelled religious responses should not be copied. Jesus welcomed children and took their dignity seriously. Spiritual formation grows best through trustworthy examples, conversation, and patient love.</p><p><strong>Reflect:</strong> Do the children in my care experience faith as welcome, or as pressure to please adults?</p><p><strong>Practice:</strong> Listen to a child’s question without correcting it immediately. Offer age-appropriate opportunities to help someone by choice.</p><p><strong>Prayer:</strong> Jesus, teach us to safeguard children and to guide them with gentleness and joy. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 15,
    "value": "<p><strong>Read:</strong> Ephesians 4:29-32; James 3:5-10</p><p><strong>Source and historical context:</strong> Catherine’s letters advise her children on diligence, care for others, speaking naturally in public, and guarding against harmful joking or idle talk. She also grapples with whether a daughter is ready for street preaching.</p><p><strong>Devotional focus:</strong> A parent’s words can become a source of courage or a burden someone carries for years. James reminds us how powerful the tongue can be. Good guidance calls out gifts without crushing the learner and addresses harmful speech without humiliating anyone. Children and young adults need permission to grow at their own pace and to exercise sound judgment about public safety.</p><p><strong>Reflect:</strong> When I offer advice, does the other person leave more capable or merely more afraid?</p><p><strong>Practice:</strong> Replace one harsh correction with a specific, encouraging suggestion. Check that a young person feels safe before a public responsibility.</p><p><strong>Prayer:</strong> God, guard my tongue and help me use words that restore and strengthen. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 16,
    "value": "<p><strong>Read:</strong> Romans 12:4-8; Isaiah 41:10</p><p><strong>Source and historical context:</strong> Letters in this segment urge Catherine’s sons and daughters toward public mission, while she also comforts a discouraged child and tells another not to worry. Her religious aspirations for her children are explicit and strong.</p><p><strong>Devotional focus:</strong> Parents and mentors may recognize remarkable potential, yet a gift becomes fruitful when the person can freely discern how to use it. Encouragement should not make love conditional on choosing the same career or ministry. Catherine’s counsel not to panic after doing what one can is a healthier model: act with faith, accept limits, and trust that worth is not measured by achievements.</p><p><strong>Reflect:</strong> Am I encouraging someone’s gifts or trying to choose their future for them?</p><p><strong>Practice:</strong> Affirm a loved one’s strength while making it clear that your care does not depend on their following your plan.</p><p><strong>Prayer:</strong> Father, guide the next generation in freedom, courage, and wise discernment. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 17,
    "value": "<p><strong>Read:</strong> Proverbs 4:23; 1 Corinthians 13:4-7</p><p><strong>Source and historical context:</strong> The last pages on motherhood offer stern advice on courtship and suitable partners. They also describe Catherine’s painful separation from adult children serving abroad and the affection of the wider Salvation Army who called her “Army Mother.”</p><p><strong>Devotional focus:</strong> Healthy love pays attention to character, shared commitments, and safety, but it never reduces people to a single prescribed life path. Wise boundaries are compatible with tenderness and with respect for another adult’s decision. Catherine’s care for a much wider family invites us to nurture people beyond our household without claiming ownership over their choices.</p><p><strong>Reflect:</strong> What boundary would protect love, and where do I need to loosen my grip?</p><p><strong>Practice:</strong> Consider one relationship in which you can express concern clearly and then honor the other person’s agency.</p><p><strong>Prayer:</strong> God of love, help me protect what is good without confusing care with control. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 18,
    "value": "<p><strong>Read:</strong> Colossians 3:23-24; Galatians 6:9-10</p><p><strong>Source and historical context:</strong> In “The Worker,” Duff describes Catherine’s careful household labor, repaired children’s clothing shared with another family, patient teaching of domestic skills, and a pair of slippers embroidered during her last illness.</p><p><strong>Devotional focus:</strong> Some of our most meaningful service looks ordinary: mending what is worn, sharing what we have, or patiently teaching a skill. Work does not need an audience to matter. At the same time, diligence should never become a demand to work through pain or exhaustion. The gift of these stories is the love carried within small actions, not an impossible standard of tirelessness.</p><p><strong>Reflect:</strong> What unnoticed task could become an act of practical love today?</p><p><strong>Practice:</strong> Share a useful item, teach a skill kindly, or thank someone whose labor is normally taken for granted.</p><p><strong>Prayer:</strong> Lord, bless the quiet work of caring and show us when it is time to serve and when it is time to rest. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 19,
    "value": "<p><strong>Read:</strong> Micah 6:8; John 8:31-32</p><p><strong>Source and historical context:</strong> The “Goodness” chapter remembers Catherine’s frugality, insistence on plain speaking, and pursuit of holiness. It also includes severe judgments about people considered idle and an account of her intense prayer for a clean heart.</p><p><strong>Devotional focus:</strong> Integrity includes truth, but truth is not a license for contempt. We cannot infer a person’s character from unemployment, fatigue, or unfamiliar circumstances. The good life is marked by justice, mercy, and humility together. Catherine’s desire for holiness can become an invitation to examine our own motives rather than an excuse to rank others by how hard they work.</p><p><strong>Reflect:</strong> When have I mistaken bluntness for courage or efficiency for goodness?</p><p><strong>Practice:</strong> Speak a needed truth today with gentleness, and ask whether you understand the circumstances of someone you are tempted to judge.</p><p><strong>Prayer:</strong> Holy God, let truth grow together with humility and mercy in me. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 20,
    "value": "<p><strong>Read:</strong> Matthew 11:28-30; Hebrews 4:9-11</p><p><strong>Source and historical context:</strong> Catherine describes an experience of spiritual peace after sustained prayer and speaks about financial uncertainties during itinerant ministry. Duff presents her trust as hard-won rather than effortless.</p><p><strong>Devotional focus:</strong> Rest in Christ is not a reward for having prayed with perfect intensity. Grace welcomes weary people before they have solved every problem. Anxiety about provision calls for wise practical planning and support as well as prayer. Catherine’s account can encourage hope, but no testimony requires others to feel peace on a fixed schedule or deny real financial risks.</p><p><strong>Reflect:</strong> Which worry can I name before God while also taking one responsible practical step?</p><p><strong>Practice:</strong> Write down an immediate need, a possible source of help, and a brief prayer. Take the safe next step available to you.</p><p><strong>Prayer:</strong> Gentle Savior, give rest to weary hearts and wisdom for practical needs. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 21,
    "value": "<p><strong>Read:</strong> 1 Corinthians 13:4-7; Matthew 25:35-40</p><p><strong>Source and historical context:</strong> The chapter “Love” portrays Catherine’s concern for people facing poverty, addiction, rejection, and spiritual discouragement. It describes her meetings and correspondence, and the many people who sought her counsel.</p><p><strong>Devotional focus:</strong> Love cannot be measured only by how intensely we feel for strangers. It takes shape in listening, food, shelter, safety, and patient companionship. When serving people who struggle, we must see neighbors with agency rather than projects to rescue. Christian love makes space for practical help and for the recipient’s own needs, voice, and decisions.</p><p><strong>Reflect:</strong> Who might need me to listen before I decide what help to offer?</p><p><strong>Practice:</strong> Ask someone facing difficulty what kind of support they would welcome; follow through without making it conditional on sharing your beliefs.</p><p><strong>Prayer:</strong> Jesus, deepen our compassion and teach us to honor every person we meet. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 22,
    "value": "<p><strong>Read:</strong> Luke 10:33-37; Galatians 6:2</p><p><strong>Source and historical context:</strong> Even while gravely ill, Catherine reportedly asks her daughter to remember an imprisoned man and his family. Duff records the mother’s continuing prayers for people far beyond her immediate circle.</p><p><strong>Devotional focus:</strong> Compassion keeps names and needs in view when a moving meeting has ended. The Samaritan’s help was concrete, attentive, and costly. We cannot meet every need ourselves, but we can connect people with safe resources, respect their privacy, and remain dependable. Caring for someone in prison also means recognizing their humanity and the needs of their family.</p><p><strong>Reflect:</strong> Whose needs have I heard about but not followed up on?</p><p><strong>Practice:</strong> Follow up on one request for help, offering a specific action or connecting the person to appropriate support.</p><p><strong>Prayer:</strong> Lord, widen our concern and give us wisdom to turn compassion into reliable care. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 23,
    "value": "<p><strong>Read:</strong> Acts 18:24-26; Galatians 3:26-28</p><p><strong>Source and historical context:</strong> In “The Warrior,” Catherine defends her theological convictions, opposes harmful drinking, and fights resistance to women preaching in public. The sketch also records longstanding bodily suffering and periods of exhaustion.</p><p><strong>Devotional focus:</strong> Conviction is strongest when it serves truth and justice without trampling others. Catherine’s resistance to restrictions on women’s voices remains a meaningful challenge to communities that overlook gifts. Her witness does not require us to accept every social judgment or medical claim in the biography. Courage also includes asking for care when our bodies are in pain.</p><p><strong>Reflect:</strong> Where should I make room for a gifted person whom convention has kept out?</p><p><strong>Practice:</strong> Support an overlooked leader or learner, and respect the limits of anyone facing illness rather than urging them to push through it.</p><p><strong>Prayer:</strong> God of courage, free us from unfair barriers and help us defend others with humility. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 24,
    "value": "<p><strong>Read:</strong> Psalm 42:5-11; 2 Corinthians 1:3-4</p><p><strong>Source and historical context:</strong> The memoir of her public work tells of Catherine’s episodes of depression, poverty, lonely ministry campaigns, and her effort to distinguish faith from felt assurance during her final illness.</p><p><strong>Devotional focus:</strong> Depression is not proof that someone lacks faith, and no one should be asked to fight it alone. The psalmist can speak both despair and hope. Prayer, friendship, rest, and professional mental-health support can belong together. Catherine’s persistence is meaningful, but so is the need for comfort and practical help. Faith does not demand that a person feel victorious every day.</p><p><strong>Reflect:</strong> Can I speak honestly about emotional darkness and receive support without shame?</p><p><strong>Practice:</strong> Reach out to a trustworthy person if you feel overwhelmed. If someone confides in you, listen and offer help accessing appropriate care.</p><p><strong>Prayer:</strong> Compassionate God, stay near those in darkness and make us faithful companions. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 25,
    "value": "<p><strong>Read:</strong> Isaiah 46:3-4; 2 Corinthians 12:9</p><p><strong>Source and historical context:</strong> In February 1888 Catherine receives a diagnosis of cancer. Over the following years she gradually gives up meetings, correspondence, drives, and then leaving her room, while continuing to care about the work and children around her. Duff tells this through the language of sacrifice.</p><p><strong>Devotional focus:</strong> A life’s meaning is not erased when illness removes familiar abilities. Love can be given and received in a whisper, a remembered name, or a quiet presence. Christ’s grace is sufficient for weakness; it does not mean that suffering must be welcomed or denied. Good caregiving takes physical pain seriously and honors a sick person’s dignity, preferences, and need for rest.</p><p><strong>Reflect:</strong> How can I show someone with limited strength that their presence matters more than their output?</p><p><strong>Practice:</strong> Offer a gentle visit, a message, a practical errand, or quiet companionship according to the person’s wishes.</p><p><strong>Prayer:</strong> Lord, surround the suffering with tenderness and let them know they remain deeply valued. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 26,
    "value": "<p><strong>Read:</strong> John 14:1-3; Romans 12:15</p><p><strong>Source and historical context:</strong> The biography describes Catherine’s final hours in October 1890, surrounded by family, hymns, and Scripture. It then recounts public viewing at Congress Hall and the many people who came to mourn her.</p><p><strong>Devotional focus:</strong> At the edge of death, presence can matter more than explanations. Families do not all grieve alike, and peace is not measured by whether someone can speak brave words. Jesus speaks hope to troubled hearts, while Scripture also tells us to weep with those who weep. Shared songs, quiet prayer, and practical care can make space for both sorrow and trust.</p><p><strong>Reflect:</strong> How can I be present for someone’s grief without asking them to be strong for me?</p><p><strong>Practice:</strong> Reach out to a bereaved person with one concrete offer of care; let them choose whether to talk, pray, or simply rest.</p><p><strong>Prayer:</strong> God of resurrection hope, hold those who mourn and strengthen those who care for them. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 27,
    "value": "<p><strong>Read:</strong> Hebrews 12:1-2; Matthew 5:16</p><p><strong>Source and historical context:</strong> The final segment remembers the graveside service at Abney Park, hymns, and closing biographical dates including Catherine’s death on October 4, 1890 and funeral on October 11. The text offers a retrospective portrait of her influence.</p><p><strong>Devotional focus:</strong> A faithful legacy is not simply the size of a movement or the number of people who gather at a funeral. It is also the honesty, welcome, service, and courage that others carry into ordinary days. We can learn from Catherine’s life without copying every choice or treating an admiring account as infallible. The call is to follow Christ, not to imitate a hero uncritically.</p><p><strong>Reflect:</strong> What example of love would I most hope people remember from my ordinary life?</p><p><strong>Practice:</strong> Choose one sustainable act of service you can repeat, and thank someone whose example has shaped you for good.</p><p><strong>Prayer:</strong> Jesus, keep our eyes on you and make the fruit of our lives a blessing to others. Amen.</p>"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

-- Replace only plan-level daily Scripture reference arrays. User-owned rows remain untouched.
do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 1,
    "references": [
      "Colossians 3:12-14",
      "Proverbs 12:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 2,
    "references": [
      "2 Corinthians 4:16-18",
      "Psalm 119:105"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 3,
    "references": [
      "2 Corinthians 6:14",
      "Romans 8:15-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 4,
    "references": [
      "2 Timothy 1:7",
      "Philippians 1:6"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 5,
    "references": [
      "Amos 3:3",
      "Ephesians 4:15-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 6,
    "references": [
      "Proverbs 27:17",
      "1 Corinthians 13:4-7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 7,
    "references": [
      "Matthew 5:14-16",
      "Joshua 24:15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 8,
    "references": [
      "Luke 14:28-30",
      "James 1:5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 9,
    "references": [
      "Philippians 4:11-13",
      "Micah 6:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 10,
    "references": [
      "1 Thessalonians 4:13-14",
      "Romans 12:15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 11,
    "references": [
      "Acts 2:17-18",
      "1 Peter 4:10-11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 12,
    "references": [
      "Colossians 4:5-6",
      "2 Timothy 2:15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 13,
    "references": [
      "James 2:1-4",
      "2 Corinthians 5:18-20"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 14,
    "references": [
      "Deuteronomy 6:6-7",
      "Mark 10:13-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 15,
    "references": [
      "Ephesians 4:29-32",
      "James 3:5-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 16,
    "references": [
      "Romans 12:4-8",
      "Isaiah 41:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 17,
    "references": [
      "Proverbs 4:23",
      "1 Corinthians 13:4-7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 18,
    "references": [
      "Colossians 3:23-24",
      "Galatians 6:9-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 19,
    "references": [
      "Micah 6:8",
      "John 8:31-32"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 20,
    "references": [
      "Matthew 11:28-30",
      "Hebrews 4:9-11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 21,
    "references": [
      "1 Corinthians 13:4-7",
      "Matthew 25:35-40"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 22,
    "references": [
      "Luke 10:33-37",
      "Galatians 6:2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 23,
    "references": [
      "Acts 18:24-26",
      "Galatians 3:26-28"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 24,
    "references": [
      "Psalm 42:5-11",
      "2 Corinthians 1:3-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 25,
    "references": [
      "Isaiah 46:3-4",
      "2 Corinthians 12:9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 26,
    "references": [
      "John 14:1-3",
      "Romans 12:15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "day_number": 27,
    "references": [
      "Hebrews 12:1-2",
      "Matthew 5:16"
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
where id = '90000000-0000-0000-0000-000000000329'::uuid;

commit;
