-- Wave 32: Plan 367 — M. W. Mayow, Remarks upon the First Report of the Royal Commission on Ritual.
-- Lecture delivered in Brighton 1867; published 1868. Nineteen original Scripture-led adaptations.
-- Historical Anglican legal and ceremonial claims are labeled as period-specific arguments.
-- Preserve existing plan/day IDs, reading progress, metadata and user-owned Scripture notes.
-- Apply after October 21 language-modernization migrations, including part 12.
-- Editorial DRAFT ONLY. Review in staging before publication.

begin;

do $$
declare
  current_source text;
  current_total integer;
  day_count integer;
  first_day integer;
  last_day integer;
  unique_days integer;
  duplicates integer;
begin
  select source_url, total_days into current_source, current_total
  from public.devotional_plans where id = '90000000-0000-0000-0000-000000000367'::uuid;
  if not found then raise exception 'Plan 367 missing'; end if;
  if current_source is distinct from 'https://www.gutenberg.org/ebooks/49145' or current_total is distinct from 19 then
    raise exception 'Plan 367 source URL or total days differs from Wave 32 review';
  end if;
  select count(*), min(day_number), max(day_number), count(distinct day_number)
  into day_count, first_day, last_day, unique_days
  from public.devotional_days where plan_id = '90000000-0000-0000-0000-000000000367'::uuid;
  if day_count <> 19 or first_day <> 1 or last_day <> 19 or unique_days <> 19 then
    raise exception 'Plan 367 must contain 19 distinct numbered days; found %', day_count;
  end if;
  select count(*) into duplicates from (
     select sr.day_id
     from public.scripture_references sr
     join public.devotional_days d on d.id = sr.day_id
     where d.plan_id = '90000000-0000-0000-0000-000000000367'::uuid and sr.user_id is null
     group by sr.day_id having count(*) > 1
  ) duplicates_per_day;
  if duplicates > 0 then
    raise exception 'Plan 367 has % days with duplicate plan-level Scripture-reference rows', duplicates;
  end if;
end
$$;

update public.devotional_plans as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "value": "Worship, Conscience, and Christian Unity: 19 Readings from a Victorian Debate"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "value": "Nineteen Scripture-led devotional readings inspired by M. W. Mayow’s 1867 lecture, published in 1868, on the first report of the Royal Commission on Ritual and the Book of Common Prayer. Explore faithful worship, conscience, Christian freedom, fair church decisions, leadership, respectful disagreement, inherited tradition, and hope for unity. The readings place his Anglican ceremonial and legal arguments in their historical context rather than treating them as binding rules for all Christians. Each day offers Scripture, source context, reflection, a practical response, and prayer."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 1,
    "value": "Faithfulness When Traditions Are Questioned"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 2,
    "value": "What Is Essential, and to Whom?"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 3,
    "value": "The Cross as a Sign, Not a Substitute"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 4,
    "value": "When an Outward Gesture Has Meaning"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 5,
    "value": "Liberty Requires Thoughtful Responsibility"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 6,
    "value": "The Difference Between a Mandate and a Remedy"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 7,
    "value": "A Crisis Calls for More Than Alarm"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 8,
    "value": "Authority Needs Clear Limits"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 9,
    "value": "Disagreement Deserves Due Process"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 10,
    "value": "Beauty Can Point Beyond Itself"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 11,
    "value": "Do Not Confuse Fear with Faithfulness"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 12,
    "value": "When Strong Labels Cloud the Question"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 13,
    "value": "A Change in Practice Should Be Named Honestly"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 14,
    "value": "Making a Respectful Public Appeal"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 15,
    "value": "Fairness Across a Change of Rules"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 16,
    "value": "Preserve Convictions Without Wounding Others"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 17,
    "value": "Guard the Treasure Without Closing the Door"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 18,
    "value": "A Wider Family Than Our Own Church"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 19,
    "value": "Hope for Unity, Work for Peace Today"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 1,
    "value": "<p><strong>Read:</strong> Colossians 3:12-17; John 17:20-23</p><p><strong>Source and historical context:</strong> In a lecture delivered to the Brighton English Church Union on November 27, 1867, and printed in 1868, M. W. Mayow warned that proposals following a Royal Commission might endanger the Book of Common Prayer. He called the debate a crisis for the Church of England and linked it to hopes for Christian unity.</p><p><strong>Devotional focus:</strong> Communities sometimes face changes that unsettle familiar forms of worship. Paul urges believers to clothe themselves with love, gratitude, and peace. That does not make every inherited practice beyond examination; it asks us to conduct difficult conversations with patience and fidelity. Our deepest unity is not maintained by anxiety alone but by listening to Christ and one another.</p><p><strong>Reflect:</strong> When a practice I value is questioned, do I respond first with suspicion or with an effort to understand?</p><p><strong>Practice:</strong> Pray for people on different sides of a church disagreement. Name one question you could ask respectfully before taking a position.</p><p><strong>Prayer:</strong> Lord Jesus, keep us faithful in what matters and gentle toward those who see questions differently. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 2,
    "value": "<p><strong>Read:</strong> Romans 14:1-6; 1 Corinthians 10:31-33</p><p><strong>Source and historical context:</strong> Mayow discusses the Royal Commission’s first report of August 1867 concerning clerical vestments. The commissioners judged such clothing not essential yet offensive to many, and proposed restrictions. Mayow argued that this conclusion failed to consider why vestments mattered to worshippers who valued them.</p><p><strong>Devotional focus:</strong> A dispute can become sharper when everyone uses the same word differently. The question of what is essential to salvation differs from what is meaningful for communal worship. Paul calls Christians to honor God while considering one another’s consciences. The first response need not be to declare one party foolish; it may be to discover what a cherished symbol communicates and whom a choice affects.</p><p><strong>Reflect:</strong> Am I calling something insignificant simply because it does not matter to me?</p><p><strong>Practice:</strong> Before criticizing an unfamiliar worship custom, ask a participant what it means. Listen without pretending agreement.</p><p><strong>Prayer:</strong> God of wisdom, help me distinguish the heart of faith from the forms by which people seek to express it. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 3,
    "value": "<p><strong>Read:</strong> Galatians 6:14; Romans 6:3-4</p><p><strong>Source and historical context:</strong> Mayow turns to Canon 30 of the Church of England’s 1603 canons. It defended the sign of the cross after baptism, even while acknowledging that the sign itself was not necessary for the sacrament’s validity. He used this example to challenge the proposed restriction of vestments.</p><p><strong>Devotional focus:</strong> A visible sign may help us remember a profound promise without becoming the source of that promise. Christians differ in how they practice baptism and interpret sacramental signs. Paul points beyond a gesture to belonging to the crucified and risen Christ. When a tradition helps us attend to Jesus and love others, we may receive it with gratitude; when it distracts or wounds, we should examine how it is used.</p><p><strong>Reflect:</strong> What visible practice helps me remember Christ, and do I ever mistake the reminder for the reality?</p><p><strong>Practice:</strong> Reflect on the meaning of a familiar cross or baptismal remembrance. Let it lead to one humble action today.</p><p><strong>Prayer:</strong> Crucified and risen Lord, make our signs honest reminders of your grace and our shared calling. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 4,
    "value": "<p><strong>Read:</strong> Matthew 28:18-20; 1 Corinthians 12:12-13</p><p><strong>Source and historical context:</strong> Continuing the baptism example, Mayow quotes Canon 30’s distinction between baptism itself and the later making of the sign of the cross. He argues that an outward ceremony can convey reverence without adding to the sacrament. He also cites the Savoy Conference to explain the authority of established rubrics.</p><p><strong>Devotional focus:</strong> Meaningful practices should serve what they signify. Baptism directs attention to Christ and the community that receives the baptized person. The exact role of ceremonies differs among Christian churches, so this Anglican historical argument should not be treated as a command for every believer. Whatever the form, the call to become a people of welcome, discipleship, and mutual care remains urgent.</p><p><strong>Reflect:</strong> Do our congregational symbols make newcomers feel invited into Christ’s life or tested on unfamiliar customs?</p><p><strong>Practice:</strong> If you help lead worship, explain one tradition in plain words and make room for sincere questions.</p><p><strong>Prayer:</strong> Father, let our worship show your welcome and help us honor those who are learning. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 5,
    "value": "<p><strong>Read:</strong> 1 Corinthians 8:9-13; Galatians 5:13-14</p><p><strong>Source and historical context:</strong> Mayow quotes the Savoy bishops in reply to Nonconformist objections to ceremonies they considered unnecessary. He then offers the freedom of clergy to marry as another case where something not required for priestly ministry may still be important to protect. The examples serve his defense of liturgical liberty.</p><p><strong>Devotional focus:</strong> Christian freedom is neither contempt for others nor a license to control them. Paul asks believers to consider how their freedom affects another person, and to use it for love. Communities need room to differ about practices while also protecting people from coercion. A right becomes better understood when we see both its meaning for the person who holds it and its consequences for the people around them.</p><p><strong>Reflect:</strong> When I ask for freedom in worship, do I extend patient consideration to someone seeking a different freedom?</p><p><strong>Practice:</strong> Choose one conversation where both principle and compassion deserve to be heard. State the other person’s concern fairly.</p><p><strong>Prayer:</strong> Gracious God, guide our liberties away from pride and toward service. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 6,
    "value": "<p><strong>Read:</strong> Proverbs 18:13-17; Micah 6:8</p><p><strong>Source and historical context:</strong> Mayow notes that the commission was tasked with considering uniformity in essential matters yet recommended limits on vestments its witnesses deemed nonessential. He then argues that giving aggrieved parishioners legal power to forbid existing lawful dress would, in effect, alter the Prayer Book’s authority.</p><p><strong>Devotional focus:</strong> Fair decisions require clarity about the question being asked and the power being used. Proverbs warns against answering before hearing, and Micah calls for justice with humility. Whether one agrees with Mayow’s legal reasoning or not, his argument challenges us to examine whether a proposed remedy addresses the harm it names and whether its consequences are explained openly.</p><p><strong>Reflect:</strong> Have I ever supported a rule because of its promised benefit without examining what else it changes?</p><p><strong>Practice:</strong> Before endorsing a policy at church or work, write down its stated aim, its likely effects, and whose voice has been missed.</p><p><strong>Prayer:</strong> Just God, teach us to seek remedies that are truthful, fair, and humane. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 7,
    "value": "<p><strong>Read:</strong> James 1:19-20; Philippians 4:5-7</p><p><strong>Source and historical context:</strong> Mayow urges an organized defense of the Prayer Book and considers remedies discussed by the Bishop of Gloucester and Bristol. He reviews plans for wholesale revision or wider episcopal discretion, objecting that changes in authority may also produce greater inconsistency among parishes.</p><p><strong>Devotional focus:</strong> When people fear that their community may lose something precious, urgency can narrow listening. James counsels slowness to anger, and Paul commends gentleness even under pressure. This is not a call to silence principled disagreement. It is an invitation to act responsibly: gather evidence, consider alternatives, and refuse the temptation to make opponents into enemies.</p><p><strong>Reflect:</strong> What would calm, well-informed courage look like in a disagreement that feels urgent?</p><p><strong>Practice:</strong> Find one reliable account of the opposing position. Summarize it without insults before forming your response.</p><p><strong>Prayer:</strong> God of peace, steady our hearts so that conviction and gentleness may belong together. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 8,
    "value": "<p><strong>Read:</strong> 1 Peter 5:2-3; Acts 15:6-12</p><p><strong>Source and historical context:</strong> Mayow considers proposals that would grant bishops more discretion over local ritual or create a new intermediate process. He worries about unequal rules between dioceses, uncertainty for clergy and parishioners, and changes to the established authority of Prayer Book rubrics.</p><p><strong>Devotional focus:</strong> Leadership exists to shepherd rather than dominate. Peter warns elders against lording power over others, while the Jerusalem council models shared deliberation. These passages do not decide nineteenth-century Anglican constitutional law. They do, however, invite churches today to make authority transparent, accountable, and attentive to people who bear the consequences of decisions.</p><p><strong>Reflect:</strong> Can those affected by a decision understand who makes it, what guides it, and how concerns can be heard?</p><p><strong>Practice:</strong> Identify one unclear rule in a group you belong to. Ask for a gracious, public explanation rather than relying on rumor.</p><p><strong>Prayer:</strong> Faithful Shepherd, grant leaders humility and communities the patience to deliberate well. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 9,
    "value": "<p><strong>Read:</strong> Matthew 18:15-17; Proverbs 15:22</p><p><strong>Source and historical context:</strong> Mayow examines a proposal to let existing courts resolve contested points of ritual practice. He challenges the claim that clergy whose actions are judged unlawful would necessarily abandon the Church of England and argues that disputed practices ought to be examined before condemnation.</p><p><strong>Devotional focus:</strong> Sound judgment listens, tests claims, and keeps a door open for correction. Jesus describes a careful process for confronting wrongdoing; wisdom grows through counsel. Neither passage turns legal process into a substitute for pastoral care. Where conscience and communal standards conflict, fairness means giving people an honest hearing while protecting those who may be harmed.</p><p><strong>Reflect:</strong> Do I rush to label a person disloyal before I have heard their explanation?</p><p><strong>Practice:</strong> If you must raise a complaint, describe the action and its effects accurately; avoid speculating about someone’s motives.</p><p><strong>Prayer:</strong> Lord, make us slow to accuse, willing to listen, and courageous enough to address real harm. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 10,
    "value": "<p><strong>Read:</strong> Psalm 96:1-9; John 4:21-24</p><p><strong>Source and historical context:</strong> Mayow approvingly quotes the Bishop of Vermont in defense of ordered and expressive worship. The cited argument compares church ritual with worship traditions in Eastern churches and asks whether beautiful forms may help turn human attention toward God.</p><p><strong>Devotional focus:</strong> Scripture gives room for music, dignity, and reverent beauty, but it does not measure devotion by expense or spectacle. Jesus speaks of worship in spirit and truth. Beautiful spaces can lift hearts; simple rooms can also hold sincere prayer. The most important question is not whether a service looks impressive but whether it directs people toward God and love of neighbor.</p><p><strong>Reflect:</strong> What helps me attend to God in worship, and do I honor others whose worship looks different?</p><p><strong>Practice:</strong> Notice one element of beauty in an ordinary setting. Thank God without making it a standard everyone must meet.</p><p><strong>Prayer:</strong> Creator of beauty, train our senses to seek truth, compassion, and reverence rather than display. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 11,
    "value": "<p><strong>Read:</strong> 2 Timothy 1:6-7; Ephesians 4:1-6</p><p><strong>Source and historical context:</strong> Mayow disputes Bishop Ellicott’s expectation that a judicial settlement favorable to ceremonialists might provoke widespread departure from the established Church. He fears instead that legislative limits on its Catholic character would alienate those who cherish the Prayer Book. He then recounts a proposal to restrict innovations in worship dress.</p><p><strong>Devotional focus:</strong> Predictions about a community’s collapse can become instruments of fear. Paul calls believers to courage, patience, and unity of the Spirit. These virtues do not settle the historical debate or require all Christians to remain in every institution. They can help us speak about change without threatening others, and protect space for informed conscience.</p><p><strong>Reflect:</strong> Am I imagining the worst outcome as certain because it would strengthen my argument?</p><p><strong>Practice:</strong> Replace one sweeping prediction with a careful statement of what is known, feared, and still uncertain.</p><p><strong>Prayer:</strong> Spirit of truth, free us from panic and help us seek unity without silencing conscience. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 12,
    "value": "<p><strong>Read:</strong> Ephesians 4:25-32; James 3:13-18</p><p><strong>Source and historical context:</strong> Mayow responds to the charge that ritualist clergy acted with recklessness and self-will. He says many believed they were following existing law. He challenges a proposed legislative restraint that its advocate maintained would not amount to repeal of the ornaments rubric.</p><p><strong>Devotional focus:</strong> When a disagreement becomes personal, the central question can disappear behind harsh descriptions. Paul asks us to put away corrosive speech; James praises wisdom that is peaceable and open to reason. We can still disagree strongly about policy while distinguishing alleged actions, evidence, legal interpretations, and the dignity of the people involved.</p><p><strong>Reflect:</strong> Have I used a harsh label when a precise description would have been more truthful?</p><p><strong>Practice:</strong> Revise one sentence you plan to say in a disagreement so that it states the issue without insulting a person.</p><p><strong>Prayer:</strong> God of wisdom, guard my tongue and make my words both courageous and kind. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 13,
    "value": "<p><strong>Read:</strong> Matthew 5:33-37; Proverbs 11:1-3</p><p><strong>Source and historical context:</strong> Mayow argues that leaving an old rubric printed in the Prayer Book while passing a new law limiting its operation would still amount to changing its force. He illustrates the point by imagining a rule that appears in a text but is no longer permitted to be practiced, and turns toward public efforts to influence the commission.</p><p><strong>Devotional focus:</strong> Trust grows when leaders describe what a decision will actually do, not only what they choose to call it. Jesus teaches plain speech; Proverbs commends honest dealing. A policy may be prudent or unwise, but its effect should be explained accurately. Candor allows a community to disagree without being misled about the stakes.</p><p><strong>Reflect:</strong> Where might I be using a reassuring label to avoid acknowledging a real change?</p><p><strong>Practice:</strong> When explaining a proposed change, compare the former practice with the new one in one clear sentence each.</p><p><strong>Prayer:</strong> Lord of truth, let our descriptions be as honest as our intentions. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 14,
    "value": "<p><strong>Read:</strong> Esther 4:13-16; 1 Timothy 2:1-2</p><p><strong>Source and historical context:</strong> Mayow discusses the public meeting at St. James’s Hall and the decision to send a memorial to the royal commissioners. He argues that petitioning an official body need not be improper pressure, especially when people believe their inherited worship is at risk.</p><p><strong>Devotional focus:</strong> Faith can move people to speak publicly, yet public witness still requires integrity. Esther accepted responsibility within a perilous political situation, while Paul urges prayer for those in authority. Neither example authorizes intimidation or contempt. A respectful appeal states its reasons, represents facts fairly, and remembers that the people receiving it are neighbors too.</p><p><strong>Reflect:</strong> If I were writing to a leader, would I state my concern without caricaturing those who disagree?</p><p><strong>Practice:</strong> Write a short, calm request about a matter that affects your community: the issue, a reason, and a fair request for review.</p><p><strong>Prayer:</strong> God, give us courage to participate in public life with truthful and peaceable words. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 15,
    "value": "<p><strong>Read:</strong> Leviticus 19:15-18; Luke 6:31</p><p><strong>Source and historical context:</strong> Mayow calls attention to ex post facto legislation: the possibility that clergy who had relied upon one interpretation of the law might later be censured under a changed rule. He sees danger in turning formerly defended liturgical choices into evidence of disloyalty.</p><p><strong>Devotional focus:</strong> People deserve to know which rules govern their conduct and whether those rules have changed. Biblical justice calls for honest judgment, not favoritism, and Jesus asks us to treat others as we wish to be treated. The source’s legal classification is a historical argument, not a verified judgment under modern law. The enduring devotional question is whether our process is predictable, humane, and impartial.</p><p><strong>Reflect:</strong> Have I judged someone by expectations I explained only after they acted?</p><p><strong>Practice:</strong> When setting expectations for others, state them in advance and offer a fair way to ask questions or seek review.</p><p><strong>Prayer:</strong> Righteous God, help us join accountability with fairness and clarity. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 16,
    "value": "<p><strong>Read:</strong> Romans 15:1-7; 1 Corinthians 13:4-7</p><p><strong>Source and historical context:</strong> Mayow clarifies that he is defending the integrity of the Prayer Book rather than requiring every parish to adopt elaborate ritual. He acknowledges that customs long discontinued may be reintroduced unwisely if they shock people, even while arguing for legal room to retain them.</p><p><strong>Devotional focus:</strong> A tradition can be lawful and meaningful while its introduction still calls for care. Paul asks the strong to bear with the weak, and love refuses to insist on its own way. This does not mean that prejudice must control a church. It means that trust, teaching, consultation, and pastoral sensitivity often serve faith better than sudden changes that leave neighbors feeling disregarded.</p><p><strong>Reflect:</strong> Am I equating my freedom to do something with a duty to do it immediately?</p><p><strong>Practice:</strong> Before changing a group practice, ask those affected what they need to understand and participate well.</p><p><strong>Prayer:</strong> Lord of patience, keep our convictions firm and our dealings with others gentle. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 17,
    "value": "<p><strong>Read:</strong> 2 Timothy 1:13-14; 1 Corinthians 3:10-11</p><p><strong>Source and historical context:</strong> Mayow cites John Keble’s earlier warning, written in 1865, that revising a single ornaments rubric could have consequences for the wider Prayer Book and the doctrine its worship expressed. He uses Keble’s words as an authority for resisting rapid legislation.</p><p><strong>Devotional focus:</strong> We inherit practices and teaching from people who sought to serve Christ before us. Paul calls for guarding a good deposit, but the foundation of the church remains Jesus Christ. Honoring an inheritance means understanding its purpose, not assuming every interpretation is beyond question. Faithful stewardship welcomes serious study, truthful criticism, and patient care for the next generation.</p><p><strong>Reflect:</strong> Which teaching do I want to pass on, and can I explain its purpose rather than merely demand compliance?</p><p><strong>Practice:</strong> Ask an older member why a practice matters; then explain what you have learned to someone younger.</p><p><strong>Prayer:</strong> Jesus, our foundation, make us trustworthy stewards rather than anxious gatekeepers. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 18,
    "value": "<p><strong>Read:</strong> John 17:20-23; Ephesians 2:14-22</p><p><strong>Source and historical context:</strong> Following Keble’s warning, Mayow connects the contested ornaments rubric with the possibility of reunion among churches of East and West. He speaks of the Church of England’s place in the wider Christian world and his prayer for an ecumenical council to address divisions.</p><p><strong>Devotional focus:</strong> Christian unity is bigger than any single nation, tradition, or disputed garment. Jesus prays for believers to be one so that the world may recognize God’s love. Unity does not require pretending that significant differences vanish. It invites shared prayer, honest conversation, hospitality, and the refusal to make denominational identity more important than love.</p><p><strong>Reflect:</strong> Where do I treat my own Christian tradition as the whole of the church?</p><p><strong>Practice:</strong> Learn about one Christian community different from your own. Pray for its people and for wise, respectful dialogue.</p><p><strong>Prayer:</strong> Lord Jesus, teach your people to seek communion in truth and love, without erasing one another. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 19,
    "value": "<p><strong>Read:</strong> Romans 12:9-18; Revelation 21:1-5</p><p><strong>Source and historical context:</strong> Mayow ends by defending hope for a future general council of Christendom, even if reunion appears unrealistic. He insists that his immediate duty is to resist changes he believes would weaken the Catholic standing of the Church of England and its Prayer Book.</p><p><strong>Devotional focus:</strong> Large hopes can seem distant when disagreements are strong. Paul offers a present task: pursue peace as far as it depends on us; practice hospitality and overcome evil with good. Christians may disagree about councils, denominational authority, and necessary reforms. We need not agree with Mayow’s prescription to learn from his longing for a church whose divisions will not have the last word.</p><p><strong>Reflect:</strong> What act of peace is within my reach while larger questions remain unresolved?</p><p><strong>Practice:</strong> Take one practical step toward reconciliation or cooperation today, respecting boundaries and genuine differences.</p><p><strong>Prayer:</strong> God of hope, let our longing for unity become patient acts of love today. Amen.</p>"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

-- Update only plan-owned Scripture references; do not touch user-owned records.
do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 1,
    "references": [
      "Colossians 3:12-17",
      "John 17:20-23"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 2,
    "references": [
      "Romans 14:1-6",
      "1 Corinthians 10:31-33"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 3,
    "references": [
      "Galatians 6:14",
      "Romans 6:3-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 4,
    "references": [
      "Matthew 28:18-20",
      "1 Corinthians 12:12-13"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 5,
    "references": [
      "1 Corinthians 8:9-13",
      "Galatians 5:13-14"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 6,
    "references": [
      "Proverbs 18:13-17",
      "Micah 6:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 7,
    "references": [
      "James 1:19-20",
      "Philippians 4:5-7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 8,
    "references": [
      "1 Peter 5:2-3",
      "Acts 15:6-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 9,
    "references": [
      "Matthew 18:15-17",
      "Proverbs 15:22"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 10,
    "references": [
      "Psalm 96:1-9",
      "John 4:21-24"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 11,
    "references": [
      "2 Timothy 1:6-7",
      "Ephesians 4:1-6"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 12,
    "references": [
      "Ephesians 4:25-32",
      "James 3:13-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 13,
    "references": [
      "Matthew 5:33-37",
      "Proverbs 11:1-3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 14,
    "references": [
      "Esther 4:13-16",
      "1 Timothy 2:1-2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 15,
    "references": [
      "Leviticus 19:15-18",
      "Luke 6:31"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 16,
    "references": [
      "Romans 15:1-7",
      "1 Corinthians 13:4-7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 17,
    "references": [
      "2 Timothy 1:13-14",
      "1 Corinthians 3:10-11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 18,
    "references": [
      "John 17:20-23",
      "Ephesians 2:14-22"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000367",
    "day_number": 19,
    "references": [
      "Romans 12:9-18",
      "Revelation 21:1-5"
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
where id = '90000000-0000-0000-0000-000000000367'::uuid;

commit;
