-- Wave 34: Plan 375 — Robert Waln, Observations on the Sermons of Elias Hicks (1826).
-- One historical polemic mechanically divided into 25 imported segments.
-- All 25 readings are newly authored and map to their respective source segments.
-- Preserve IDs, plan progress, user-owned Scripture rows, tags, cover, source URL, and day count.
-- Apply AFTER October 21 modernization migrations, especially part 13 (11 overlapping rows).
-- DRAFT ONLY; editorial and theological review required before publication.

begin;

do $$
declare
  current_source text;
  current_total integer;
  day_count integer;
  first_day integer;
  last_day integer;
  unique_days integer;
  duplicate_reference_days integer;
begin
  select source_url, total_days into current_source, current_total
  from public.devotional_plans where id = '90000000-0000-0000-0000-000000000375'::uuid;
  if not found then raise exception 'Plan 375 missing'; end if;
  if current_source is distinct from 'https://www.gutenberg.org/ebooks/58078' or current_total is distinct from 25 then
    raise exception 'Plan 375 source URL or day count does not match Wave 34 preflight';
  end if;
  select count(*), min(day_number), max(day_number), count(distinct day_number)
  into day_count, first_day, last_day, unique_days
  from public.devotional_days where plan_id = '90000000-0000-0000-0000-000000000375'::uuid;
  if day_count <> 25 or first_day <> 1 or last_day <> 25 or unique_days <> 25 then
    raise exception 'Plan 375 must have 25 uniquely numbered days, found %', day_count;
  end if;
  select count(*) into duplicate_reference_days from (
    select sr.day_id
    from public.scripture_references sr
    join public.devotional_days d on d.id = sr.day_id
    where d.plan_id = '90000000-0000-0000-0000-000000000375'::uuid and sr.user_id is null
    group by sr.day_id having count(*) > 1
  ) duplicates_per_day;
  if duplicate_reference_days > 0 then
    raise exception 'Plan 375 has % days with duplicate plan-level Scripture rows', duplicate_reference_days;
  end if;
end
$$;

update public.devotional_plans as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "value": "Faithful Discernment: 25 Readings on Scripture, Humility, and Christian Love"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "value": "Twenty-five Scripture-led devotional readings inspired by Robert Waln’s 1826 Observations on the Sermons of Elias Hicks, a historical polemic within and around the Society of Friends. Explore humility, shared discernment, the relationship of Scripture and spiritual experience, meaningful worship, freedom of conscience, responsible speech, and practical compassion. The reflections distinguish Waln’s opinions from the beliefs of Elias Hicks and other Quaker traditions; historic accusations are not treated as proven facts. Each day offers Bible readings, historical context, reflection, an actionable practice, and prayer."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 1,
    "value": "Humility Before We Lead"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 2,
    "value": "Young Voices, Patient Listening"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 3,
    "value": "Words That Clarify Rather Than Impress"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 4,
    "value": "Test a Claim Without Despising the Person"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 5,
    "value": "Wonder at the Incarnation"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 6,
    "value": "Much to Do, Much to Learn"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 7,
    "value": "Reason as a Gift to Cultivate"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 8,
    "value": "Read Scripture in Context"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 9,
    "value": "The Written Word and the Living God"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 10,
    "value": "Make Space for Silence"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 11,
    "value": "Order Should Serve People"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 12,
    "value": "Accountability Without Uniformity"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 13,
    "value": "Grace Is Not an Accounting Ledger"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 14,
    "value": "Healing and Forgiveness in Their Own Context"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 15,
    "value": "The Spirit Does Not Cancel Discernment"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 16,
    "value": "Do Not Mistake Certainty for Truth"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 17,
    "value": "Speak of God with Reverence"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 18,
    "value": "Practical Care Is a Test of Teaching"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 19,
    "value": "Faith, Questions, and What We Cannot Explain"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 20,
    "value": "We Live with Reasonable Trust"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 21,
    "value": "A Simple Message Can Be Deep"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 22,
    "value": "Freedom of Conscience Is a Neighborly Duty"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 23,
    "value": "Honor Service Beyond Your Own Circle"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 24,
    "value": "Let Correction Begin at Home"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 25,
    "value": "A Quiet Witness of Love"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 1,
    "value": "<p><strong>Read:</strong> Philippians 2:1-5; 1 Peter 5:2-5</p><p><strong>Source and historical context:</strong> In his 1826 address to younger members of the Society of Friends, Robert Waln remembers meetings characterized by patient consensus. He fears that some teachers resist the advice of elders and mistake personal ambition for spiritual certainty. This is Waln’s assessment of a live Quaker dispute, not an impartial account of everyone involved.</p><p><strong>Devotional focus:</strong> Paul invites believers to place others before themselves, while Peter asks leaders to shepherd willingly rather than dominate. Shared discernment needs both humility and accountability. Neither age nor spiritual confidence makes anyone beyond correction, and supervision should protect people instead of securing power.</p><p><strong>Reflect:</strong> When have I confused being listened to with being right?</p><p><strong>Practice:</strong> Invite thoughtful feedback on one decision you have made, especially from someone whose experience differs from yours.</p><p><strong>Prayer:</strong> Lord, make my leadership gentle, accountable, and attentive to your people. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 2,
    "value": "<p><strong>Read:</strong> 1 Timothy 4:12-16; James 1:19-20</p><p><strong>Source and historical context:</strong> Waln worries that inexperienced younger Friends may join church deliberations too confidently. He also advises young readers to attend meetings and learn from established participants. His language favors age and seniority, but the dispute raises a broader question about readiness to speak and willingness to listen.</p><p><strong>Devotional focus:</strong> Paul tells Timothy not to let youth disqualify him, and James calls everyone to be quick to hear. A community needs fresh insight as well as memory and experience. The better standard is not age alone but thoughtful preparation, honest speech, sound character, and a willingness to be corrected.</p><p><strong>Reflect:</strong> Do I dismiss someone because they are young, or speak without first understanding the conversation?</p><p><strong>Practice:</strong> In your next group discussion, invite a quieter voice and summarize another person’s view before giving your own.</p><p><strong>Prayer:</strong> God, teach me courage without arrogance and listening without fear. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 3,
    "value": "<p><strong>Read:</strong> 1 Corinthians 14:6-12; Proverbs 18:13</p><p><strong>Source and historical context:</strong> Beginning his first letter, Waln criticizes Elias Hicks’s speaking style as elaborate, repetitive, and sometimes unclear. He argues that the ability to reason grows through learning and observation. His harsh judgments about Hicks are polemical; the concern worth examining is whether religious language genuinely serves those listening.</p><p><strong>Devotional focus:</strong> Paul measures speech in worship by whether it builds others up. Wisdom does not require impressive vocabulary or lengthy explanations. Clear words make room for questions, acknowledge limits, and help hearers take a faithful next step. Learning to think more carefully should make us more patient, not more superior.</p><p><strong>Reflect:</strong> Am I trying to explain a truth, or to win admiration for sounding knowledgeable?</p><p><strong>Practice:</strong> Rewrite one complicated spiritual idea in plain language that a new reader could understand.</p><p><strong>Prayer:</strong> God of truth, shape my speech to give light rather than display. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 4,
    "value": "<p><strong>Read:</strong> 1 Thessalonians 5:19-22; Acts 17:10-12</p><p><strong>Source and historical context:</strong> Waln argues that claims of immediate spiritual inspiration should be weighed against Scripture and sound reasoning. He cites John Locke and Robert Barclay to challenge the idea that private certainty is sufficient proof. These are arguments within a particular Quaker theological controversy, not a reason to mock spiritual experience.</p><p><strong>Devotional focus:</strong> The Thessalonian church is told neither to despise prophetic speech nor to accept everything untested. The Bereans investigate what they hear with care. Discernment holds two responsibilities together: remain open to God’s work and be honest about the evidence and consequences of a claim. Confidence becomes healthier when it welcomes scrutiny.</p><p><strong>Reflect:</strong> How do I react when a sincere person asks me to explain a spiritual conviction?</p><p><strong>Practice:</strong> For one important belief or impression, identify its scriptural context, its fruit in practice, and a trusted person with whom to discuss it.</p><p><strong>Prayer:</strong> Holy Spirit, keep me receptive, discerning, and kind. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 5,
    "value": "<p><strong>Read:</strong> Luke 1:26-38; John 1:14-18</p><p><strong>Source and historical context:</strong> Waln disputes Hicks’s reported statement that a spirit cannot beget a material body. The disagreement concerns Christian understandings of Jesus’s birth and the limits of human reasoning. Waln regards Hicks’s explanation as contradictory; readers should recognize that this is the author’s presentation of a theological dispute.</p><p><strong>Devotional focus:</strong> Luke portrays Mary receiving startling news with an honest question, and John proclaims that the Word became flesh. Their passages ask us to consider God entering real human life, not merely a theory to be won in debate. Questions can be reverent; what matters is whether they direct us toward understanding, trust, and loving action.</p><p><strong>Reflect:</strong> Can I hold questions about the mystery of Jesus without turning disagreement into contempt?</p><p><strong>Practice:</strong> Read Luke 1:26–38 slowly. Write down one honest question and one reason the passage invites hope.</p><p><strong>Prayer:</strong> God who came near in Christ, guide my questions with humility. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 6,
    "value": "<p><strong>Read:</strong> Micah 6:6-8; Deuteronomy 29:29</p><p><strong>Source and historical context:</strong> Waln quotes a prayer asking to be released from fruitless speculation and drawn back to necessary duties. He then criticizes what he sees as contradictions in Hicks’s account of reason and revelation. The prayer supplies a gentler center to this section than its sharp debate.</p><p><strong>Devotional focus:</strong> Deuteronomy distinguishes hidden things from responsibilities that have been made known. Micah points toward justice, mercy, and humble fellowship with God. The inability to solve every theological mystery is not a failure of faith. We can study with seriousness while refusing to let unanswered questions become excuses to neglect our neighbor.</p><p><strong>Reflect:</strong> Which unresolved question occupies more energy than the good I already know to do?</p><p><strong>Practice:</strong> Give a short period to study, then perform one concrete act of justice, mercy, or service.</p><p><strong>Prayer:</strong> Lord, help me learn faithfully and act on the light I have. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 7,
    "value": "<p><strong>Read:</strong> Proverbs 2:1-6; Romans 12:1-2</p><p><strong>Source and historical context:</strong> Waln analyzes a New York sermon in which Hicks describes rational creatures, divine revelation, and a faculty for comparing ideas. Waln challenges what he considers confused definitions and insists that reason grows through disciplined observation and study.</p><p><strong>Devotional focus:</strong> Proverbs portrays understanding as something sought with effort, while Romans describes the renewal of the mind. Reason is not a rival to devotion when it helps us recognize error, listen to evidence, and judge with care. At the same time, clever arguments can be used selfishly. A renewed mind learns with humility and serves love.</p><p><strong>Reflect:</strong> Do I cultivate thoughtful judgment, or assume that my first impression is already wisdom?</p><p><strong>Practice:</strong> Choose an issue you care about, read a responsible view different from your own, and summarize it fairly.</p><p><strong>Prayer:</strong> Creator of understanding, teach me to think patiently and to use knowledge well. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 8,
    "value": "<p><strong>Read:</strong> Luke 10:25-37; 2 Timothy 2:14-15</p><p><strong>Source and historical context:</strong> Waln begins criticizing Hicks’s frequent allegorical explanations of Bible passages, arguing that imaginative readings can displace what a text originally says. He does allow that biblical stories can illuminate a moral lesson. His disagreement invites careful interpretation rather than blanket suspicion of imagery.</p><p><strong>Devotional focus:</strong> Jesus uses a story about a wounded traveler to lead a listener toward mercy. Paul urges responsible handling of the word of truth. Scripture includes history, poetry, parable, and symbol; faithful reading attends to the kind of writing before applying it. An attractive interpretation should not be allowed to silence a passage’s actual subject.</p><p><strong>Reflect:</strong> Have I used a favorite spiritual lesson to avoid a passage’s uncomfortable call?</p><p><strong>Practice:</strong> Read Luke 10:25–37 and separate what happens in the story from the application Jesus asks his listener to make.</p><p><strong>Prayer:</strong> Lord, give me reverence for your word and mercy toward those it calls me to love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 9,
    "value": "<p><strong>Read:</strong> Psalm 119:97-105; John 5:39-40</p><p><strong>Source and historical context:</strong> Waln continues debating statements that treat biblical writing as only an outward shadow. He compares Scripture to a guide that directs the reader beyond itself, while warning that elaborate allegory can make a text say anything. His examples come from a contentious conversation about inward guidance and written revelation.</p><p><strong>Devotional focus:</strong> The psalmist delights in the word as a lamp for a path. Jesus warns that searching the Scriptures is not the same as coming to him. Both truths belong together: written testimony matters, and the goal is a living relationship expressed in faithful conduct. We need neither worship the page nor dismiss its witness.</p><p><strong>Reflect:</strong> Does my Bible reading lead me to greater trust and compassion, or only to arguments?</p><p><strong>Practice:</strong> Read a short Gospel passage, identify its plain emphasis, and name one response in your own life.</p><p><strong>Prayer:</strong> Living Lord, let the Scriptures lead me toward you and toward love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 10,
    "value": "<p><strong>Read:</strong> Psalm 46:10-11; Mark 1:35-39</p><p><strong>Source and historical context:</strong> In another letter Waln describes silent waiting as a valued practice among Friends and criticizes a sermon he finds distracted and overly long. He worries that display can crowd out a gathered community’s attention to God. This reflects his interpretation of Quaker worship and should not be applied as a rule against all spoken preaching.</p><p><strong>Devotional focus:</strong> The psalm calls us to stillness before God; the Gospels show Jesus seeking a solitary place to pray before continuing his work. Quiet is not empty when it helps us relinquish performance, hear our own motives, and return to service. Spoken words, too, can be holy when offered with care rather than pride.</p><p><strong>Reflect:</strong> When did I last become quiet enough to notice what has been shaping my heart?</p><p><strong>Practice:</strong> Set aside ten undistracted minutes today for silence, a brief Scripture reading, and a simple prayer.</p><p><strong>Prayer:</strong> God of peace, free me from the need to perform and draw me near to you. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 11,
    "value": "<p><strong>Read:</strong> 1 Corinthians 14:26-33; Galatians 5:13-15</p><p><strong>Source and historical context:</strong> Waln objects to Hicks’s reported claim that sufficiently enlightened people would need no shared rules. He argues that a voluntary religious community still needs agreed practices, while acknowledging each person’s right to worship according to conscience. This exposes a tension between freedom and community discipline.</p><p><strong>Devotional focus:</strong> Paul asks that a gathered church build up its members and conduct worship peaceably. Galatians says freedom is an opening for love, not a license to disregard others. Rules deserve neither automatic worship nor automatic rejection. The question is whether they make participation safer, fairer, and more attentive to God.</p><p><strong>Reflect:</strong> Does the structure of a community protect its members or mainly protect the standing of its leaders?</p><p><strong>Practice:</strong> Review one group rule and ask whose needs it serves and whether those affected can question it respectfully.</p><p><strong>Prayer:</strong> Lord, give our communities practices that make room for truth, peace, and love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 12,
    "value": "<p><strong>Read:</strong> Ephesians 4:11-16; Romans 14:4-13</p><p><strong>Source and historical context:</strong> Waln imagines confusion in a meeting where everyone treats private inspiration as above common discernment. He then opens a new letter about salvation, grace, and personal responsibility. His caricature should not be mistaken for an accurate description of all Friends or of Hicks’s followers.</p><p><strong>Devotional focus:</strong> Ephesians describes a body growing as its members speak truth in love. Romans cautions believers against assuming the role of another person’s master. We can honor freedom of conscience and still ask people entrusted with power to explain their actions. Accountability is most Christian when it protects the vulnerable without demanding sameness in every conviction.</p><p><strong>Reflect:</strong> Where have I mistaken healthy disagreement for disorder, or personal freedom for freedom from responsibility?</p><p><strong>Practice:</strong> In a group you belong to, agree on one transparent way to raise concerns without humiliation.</p><p><strong>Prayer:</strong> God, let our differences be met with patience and our responsibilities carried with care. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 13,
    "value": "<p><strong>Read:</strong> Ephesians 2:8-10; Luke 18:9-14</p><p><strong>Source and historical context:</strong> Waln disputes a metaphor he attributes to Hicks: treating wrongdoing and good actions like entries in an account with God. He regards it as a mistaken picture of salvation earned by an acceptable balance. The original letter presents a specifically Christian argument about grace and the meaning of Jesus’s work.</p><p><strong>Devotional focus:</strong> Ephesians says salvation is a gift of grace that opens into good works. Jesus’s parable contrasts self-congratulation with an honest appeal for mercy. Doing good matters deeply, but acts of service need not become a currency that purchases God’s acceptance. Grace frees us to repent without disguising wrong and to serve without keeping score.</p><p><strong>Reflect:</strong> Do I secretly count my good deeds to avoid admitting where I need mercy?</p><p><strong>Practice:</strong> Name one wrong honestly, seek to repair it, and do one good thing without expecting recognition.</p><p><strong>Prayer:</strong> Merciful God, release me from self-justification and teach me to live gratefully. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 14,
    "value": "<p><strong>Read:</strong> Luke 5:17-26; Mark 2:1-12</p><p><strong>Source and historical context:</strong> Waln challenges an allegorical treatment of Jesus healing the paralyzed man. He argues that the Gospel tells the healing as a public event joined to a declaration of forgiveness. His sharp rhetoric is part of a historical dispute about whether miracle narratives should be read literally or figuratively.</p><p><strong>Devotional focus:</strong> Luke and Mark place a person in need at the center, surrounded by friends who seek help. Jesus addresses both forgiveness and bodily need, but the story should not be used to suggest that disability always results from personal sin or that healing is owed to anyone who has enough faith. The community’s determination to bring someone near to care remains a powerful invitation.</p><p><strong>Reflect:</strong> Whose needs am I overlooking while debating the meaning of an extraordinary story?</p><p><strong>Practice:</strong> Ask someone facing practical barriers what support would actually help, and honor their answer.</p><p><strong>Prayer:</strong> Compassionate Jesus, let my interpretation lead to dignity and concrete care. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 15,
    "value": "<p><strong>Read:</strong> 2 Timothy 3:14-17; 1 John 4:1-3</p><p><strong>Source and historical context:</strong> Waln appeals to early Quaker writer Robert Barclay, arguing that inward guidance should not contradict Scripture or sound reason. He contrasts this with his account of Hicks’s metaphorical preaching. The argument belongs to an internal Quaker disagreement about revelation and authority.</p><p><strong>Devotional focus:</strong> John asks believers to test spiritual claims; Timothy is encouraged to remain grounded in the sacred writings that formed his faith. This does not require suspicion toward everyone who describes personal spiritual experience. It calls for humility about our own interpretations, honest attention to Scripture, and careful consideration of the character and effects of what is taught.</p><p><strong>Reflect:</strong> Can I examine a teaching closely without assuming the worst about the teacher?</p><p><strong>Practice:</strong> Discuss one disputed passage with someone you trust, looking together at its context and practical fruit.</p><p><strong>Prayer:</strong> Holy Spirit, keep my discernment patient, truthful, and free from contempt. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 16,
    "value": "<p><strong>Read:</strong> Proverbs 18:17; James 3:13-18</p><p><strong>Source and historical context:</strong> Waln warns that private conviction can become a distorted mirror: a person may treat their own ideas as self-confirming evidence. He insists that premises and conclusions must be examined, even when a speaker sincerely believes their words are inspired.</p><p><strong>Devotional focus:</strong> Proverbs reminds us that a persuasive first account can look different after questions. James locates heavenly wisdom in purity, peace, gentleness, and openness to reason. Confidence is not inherently wrong; it becomes dangerous when it refuses correction. A trustworthy teacher can say both what they believe and what would make them reconsider.</p><p><strong>Reflect:</strong> Have I treated criticism as proof that others are less faithful than I am?</p><p><strong>Practice:</strong> State one belief you hold strongly and one fair question someone could ask about it.</p><p><strong>Prayer:</strong> Lord, give me conviction shaped by humility and wisdom that makes peace. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 17,
    "value": "<p><strong>Read:</strong> Isaiah 55:8-11; Acts 17:24-28</p><p><strong>Source and historical context:</strong> Waln objects to metaphysical descriptions of God that, in his view, blur the distinction between Creator and creation. He disputes interpretations of heaven, divine government, and the human spirit, bringing philosophical disagreement into the theological controversy.</p><p><strong>Devotional focus:</strong> Isaiah reminds us that God’s ways exceed ours, while Paul speaks of the Creator as near to every human life. Both transcendence and nearness matter. Theological language can guide worship, but our analogies are limited. Reverence invites us to describe God carefully rather than force divine mystery into a system that flatters our reasoning.</p><p><strong>Reflect:</strong> Do my explanations of God leave space for wonder and for the lives of people who experience faith differently?</p><p><strong>Practice:</strong> Compare one favorite image of God with the language of Isaiah 55 or Acts 17; note what it reveals and what it cannot capture.</p><p><strong>Prayer:</strong> Eternal God, draw me near while teaching me wonder before what I cannot contain. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 18,
    "value": "<p><strong>Read:</strong> Matthew 7:15-20; James 1:22-27</p><p><strong>Source and historical context:</strong> Waln quotes Isaac Newton about the order of creation, then turns back to the effect of Hicks’s sermons on ordinary listeners. He worries that elaborate speculation can replace clear teaching about honesty, compassion, and everyday faithfulness. His account of particular sermons remains a partisan judgment.</p><p><strong>Devotional focus:</strong> Jesus tells his hearers to look for fruit, and James warns against hearing without doing. The value of teaching is not measured by how grand it sounds but by whether it leads people toward truthfulness, generosity, justice, and care. Questions about the universe matter, yet we should never use them to neglect the person sitting beside us.</p><p><strong>Reflect:</strong> What fruit is growing from the religious ideas I spend most time discussing?</p><p><strong>Practice:</strong> Turn one insight from your reading into an act of help that another person can actually experience.</p><p><strong>Prayer:</strong> God of wisdom, make my learning fruitful in everyday love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 19,
    "value": "<p><strong>Read:</strong> John 20:24-29; 1 Corinthians 13:9-12</p><p><strong>Source and historical context:</strong> Waln objects to the claim that people cannot believe anything they do not fully understand. He distinguishes an idea that contradicts reason from one that exceeds present understanding. His philosophical examples form part of an 1826 controversy; they do not resolve every modern question about revelation.</p><p><strong>Devotional focus:</strong> Thomas asks for evidence and Jesus meets him with an invitation rather than ridicule. Paul says our knowledge remains partial. Christian belief need not pretend to answer every question, and honest inquiry need not be called unbelief. The challenge is to remain truthful about what is known, what is trusted, and what is still unresolved.</p><p><strong>Reflect:</strong> Which question do I need permission to ask without shame?</p><p><strong>Practice:</strong> Write your question down, read John 20:24–29, and talk it through with a patient, knowledgeable person.</p><p><strong>Prayer:</strong> Risen Christ, meet my questions with truth, patience, and hope. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 20,
    "value": "<p><strong>Read:</strong> Proverbs 3:5-6; 2 Corinthians 5:6-10</p><p><strong>Source and historical context:</strong> A short continuation of Waln’s argument says that even ordinary decisions rely on trustworthy evidence and moral judgment rather than complete comprehension. He argues that demanding exhaustive understanding before every action would prevent daily life itself.</p><p><strong>Devotional focus:</strong> Proverbs calls believers to acknowledge God in their paths, not to abandon thought. Paul describes a life of faith expressed in responsible conduct. Trust is not the opposite of careful judgment: we examine what we can, act with integrity, and admit that we cannot control every outcome. This is especially important when our choices affect other people.</p><p><strong>Reflect:</strong> When does my desire for certainty become an excuse to avoid a responsible decision?</p><p><strong>Practice:</strong> Make one modest, reversible decision after gathering the information you reasonably need, then review its effects.</p><p><strong>Prayer:</strong> Guide my steps, Lord, when understanding is incomplete and responsibility remains. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 21,
    "value": "<p><strong>Read:</strong> 1 Corinthians 1:18-25; 1 Corinthians 2:1-5</p><p><strong>Source and historical context:</strong> Waln quotes a review discussing reason and revelation. He then recalls the early Christian preachers and hearers, insisting that the practical message of the Gospel was accessible without advanced schooling. His contrast should not be used to equate limited formal education with limited wisdom.</p><p><strong>Devotional focus:</strong> Paul refuses to let verbal brilliance become the foundation of faith. The message of Christ crucified can be profound without requiring every hearer to master philosophical vocabulary. Simplicity is not shallowness; it can be a disciplined act of love. Teaching well means making truth understandable while welcoming further study.</p><p><strong>Reflect:</strong> Whose understanding might I unintentionally exclude with my language or assumptions?</p><p><strong>Practice:</strong> Explain an important passage to a friend without jargon, and invite them to ask anything that remains unclear.</p><p><strong>Prayer:</strong> Lord Jesus, help me share good news clearly and listen to every learner. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 22,
    "value": "<p><strong>Read:</strong> Romans 14:1-13; 1 Peter 3:15-16</p><p><strong>Source and historical context:</strong> Waln opens a letter defending freedom of conscience, recalling the Society of Friends’ resistance to religious persecution and the history of religious liberty in Pennsylvania. He warns that people who were once persecuted can still become harsh toward those with different convictions.</p><p><strong>Devotional focus:</strong> Paul cautions believers against treating another person as their servant to judge. Peter calls for answers marked by gentleness and respect. Religious liberty is more than asking space for our own beliefs; it means protecting another person’s dignity and freedom even when we disagree. Humility should appear most clearly when convictions are deeply held.</p><p><strong>Reflect:</strong> Do I defend liberty for people I agree with more readily than for those I oppose?</p><p><strong>Practice:</strong> Describe a religious disagreement in terms that preserve both parties’ dignity and freedom.</p><p><strong>Prayer:</strong> God of conscience and peace, let my faith make me a protector, not a persecutor. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 23,
    "value": "<p><strong>Read:</strong> Mark 9:38-41; Philippians 1:15-18</p><p><strong>Source and historical context:</strong> Waln criticizes Hicks’s reported denunciations of Bible and missionary societies and defends Christians who serve outside the Friends tradition. He also acknowledges that charitable projects deserve scrutiny. His examples show a debate over how to judge work done by people with different theology or methods.</p><p><strong>Devotional focus:</strong> Jesus tells his disciples not to assume that good done in his name is worthless simply because the worker is outside their circle. Paul recognizes that motives can be mixed. We should neither excuse harmful practices because they bear a religious label nor dismiss sincere service because it comes from an unfamiliar community.</p><p><strong>Reflect:</strong> Have I rejected a useful act of care because I dislike the group associated with it?</p><p><strong>Practice:</strong> Learn about a service effort outside your tradition; ask whom it helps, how it is accountable, and what you can affirm.</p><p><strong>Prayer:</strong> Lord, enlarge my charity and sharpen my discernment toward every work of service. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 24,
    "value": "<p><strong>Read:</strong> James 3:1-12; Matthew 7:1-5</p><p><strong>Source and historical context:</strong> Waln reflects on the danger of unguarded speech, especially from respected teachers. He also observes how readily religious people correct others while overlooking their own failings. As he reaches his conclusion, his own sharply critical tone gives readers reason to apply his counsel to every side of the dispute.</p><p><strong>Devotional focus:</strong> James describes the tongue’s power to bless or injure. Jesus’s image of the speck and the plank asks us to examine ourselves before correcting a neighbor. Responsible criticism can protect a community, but contempt rarely teaches. Truth spoken with self-scrutiny is more credible than certainty offered from a position of imagined innocence.</p><p><strong>Reflect:</strong> Where have I demanded a gentleness from others that I have not shown myself?</p><p><strong>Practice:</strong> Before raising one concern, name your own contribution to the difficulty and choose words that invite repair.</p><p><strong>Prayer:</strong> God of mercy, guard my speech and make me willing to correct myself first. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 25,
    "value": "<p><strong>Read:</strong> Micah 6:8; 1 Corinthians 13:1-7</p><p><strong>Source and historical context:</strong> Waln ends by commending the writings and life of fellow Quaker John Woolman. He praises Woolman’s modesty, care for others, and willingness to examine his own conduct rather than claim extraordinary status. Waln hopes Friends will recover humility and charity despite their conflict.</p><p><strong>Devotional focus:</strong> Micah calls for justice, mercy, and humble walking with God. Paul says even impressive spiritual gifts lose their value without love. The deepest witness is often quiet: keeping promises, attending to the neglected, learning from correction, and refusing to make ourselves the center. The close of a bitter argument can still turn us toward a more generous pattern.</p><p><strong>Reflect:</strong> Whose humble example helps me see what faithful love looks like beyond words?</p><p><strong>Practice:</strong> Choose one unseen act of service today and thank someone whose steady kindness you have learned from.</p><p><strong>Prayer:</strong> Lord, make my life a patient, honest, and compassionate witness. Amen.</p>"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

-- Update the plan-level Scripture row per day, leaving user-owned references untouched.
do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 1,
    "references": [
      "Philippians 2:1-5",
      "1 Peter 5:2-5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 2,
    "references": [
      "1 Timothy 4:12-16",
      "James 1:19-20"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 3,
    "references": [
      "1 Corinthians 14:6-12",
      "Proverbs 18:13"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 4,
    "references": [
      "1 Thessalonians 5:19-22",
      "Acts 17:10-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 5,
    "references": [
      "Luke 1:26-38",
      "John 1:14-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 6,
    "references": [
      "Micah 6:6-8",
      "Deuteronomy 29:29"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 7,
    "references": [
      "Proverbs 2:1-6",
      "Romans 12:1-2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 8,
    "references": [
      "Luke 10:25-37",
      "2 Timothy 2:14-15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 9,
    "references": [
      "Psalm 119:97-105",
      "John 5:39-40"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 10,
    "references": [
      "Psalm 46:10-11",
      "Mark 1:35-39"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 11,
    "references": [
      "1 Corinthians 14:26-33",
      "Galatians 5:13-15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 12,
    "references": [
      "Ephesians 4:11-16",
      "Romans 14:4-13"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 13,
    "references": [
      "Ephesians 2:8-10",
      "Luke 18:9-14"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 14,
    "references": [
      "Luke 5:17-26",
      "Mark 2:1-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 15,
    "references": [
      "2 Timothy 3:14-17",
      "1 John 4:1-3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 16,
    "references": [
      "Proverbs 18:17",
      "James 3:13-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 17,
    "references": [
      "Isaiah 55:8-11",
      "Acts 17:24-28"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 18,
    "references": [
      "Matthew 7:15-20",
      "James 1:22-27"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 19,
    "references": [
      "John 20:24-29",
      "1 Corinthians 13:9-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 20,
    "references": [
      "Proverbs 3:5-6",
      "2 Corinthians 5:6-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 21,
    "references": [
      "1 Corinthians 1:18-25",
      "1 Corinthians 2:1-5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 22,
    "references": [
      "Romans 14:1-13",
      "1 Peter 3:15-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 23,
    "references": [
      "Mark 9:38-41",
      "Philippians 1:15-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 24,
    "references": [
      "James 3:1-12",
      "Matthew 7:1-5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000375",
    "day_number": 25,
    "references": [
      "Micah 6:8",
      "1 Corinthians 13:1-7"
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
      values (null, target_day_id,
        array(select jsonb_array_elements_text(item -> 'references')), now(), now());
    end if;
  end loop;
end
$$;

update public.devotional_plans
set status = 'published', updated_at = now()
where id = '90000000-0000-0000-0000-000000000375'::uuid;

commit;
