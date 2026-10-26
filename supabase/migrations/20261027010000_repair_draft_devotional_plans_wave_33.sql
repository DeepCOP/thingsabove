-- Wave 33: Plan 371 — Thomas Sherlock, Trial of the Witnesses of the Resurrection of Jesus.
-- First published circa 1729; one literary court case mechanically divided into 29 imported segments.
-- Historical claims are distinguished from Scripture and modern verification.
-- Preserve existing IDs, user progress, tags, cover art, source URL, and user-authored Scripture references.
-- Apply AFTER October 21 language-modernization migrations, including part 13.
-- DRAFT ONLY; editorial review required before publication.

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
  from public.devotional_plans where id = '90000000-0000-0000-0000-000000000371'::uuid;
  if not found then raise exception 'Plan 371 missing'; end if;
  if current_source is distinct from 'https://www.gutenberg.org/ebooks/5608' or current_total is distinct from 29 then
    raise exception 'Plan 371 source URL or day count does not match Wave 33 preflight';
  end if;
  select count(*), min(day_number), max(day_number), count(distinct day_number)
  into day_count, first_day, last_day, unique_days
  from public.devotional_days where plan_id = '90000000-0000-0000-0000-000000000371'::uuid;
  if day_count <> 29 or first_day <> 1 or last_day <> 29 or unique_days <> 29 then
    raise exception 'Plan 371 must have 29 uniquely numbered days, found %', day_count;
  end if;
  select count(*) into duplicate_reference_days from (
    select sr.day_id
    from public.scripture_references sr
    join public.devotional_days d on d.id = sr.day_id
    where d.plan_id = '90000000-0000-0000-0000-000000000371'::uuid and sr.user_id is null
    group by sr.day_id having count(*) > 1
  ) duplicates_per_day;
  if duplicate_reference_days > 0 then
    raise exception 'Plan 371 has % days with duplicate plan-level Scripture rows', duplicate_reference_days;
  end if;
end
$$;

update public.devotional_plans as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "value": "Resurrection and Reason: 29 Readings on Testimony, Faith, and Hope"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "value": "Twenty-nine Scripture-led devotional readings inspired by Thomas Sherlock’s eighteenth-century courtroom dialogue, Trial of the Witnesses of the Resurrection of Jesus. Explore the resurrection narratives, the nature of testimony, honest questions, faithful witness, the first Easter witnesses, and hope for transformed living. Sherlock’s arguments and literary verdict are identified as historical apologetics, not independent proof of every event or a real court finding. Each day includes Scripture, historical source context, devotional reflection, a practical response, and prayer."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 1,
    "value": "Make Room for Honest Questions"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 2,
    "value": "Clarify the Question Before You Argue"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 3,
    "value": "Examine Each Claim on Its Own Merits"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 4,
    "value": "When God’s Kingdom Defies Expectations"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 5,
    "value": "Evidence Is Not the Same as a Story"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 6,
    "value": "Courage to Resist Popular Expectations"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 7,
    "value": "The Kingdom Is Not a Prize to Seize"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 8,
    "value": "Let Hope Be More Than a Convenient Claim"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 9,
    "value": "The Tomb and the Responsibility to Be Precise"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 10,
    "value": "When an Objection Needs Its Own Evidence"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 11,
    "value": "Listening Before Reaching a Verdict"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 12,
    "value": "A Story Must Be Possible, Not Just Suspicious"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 13,
    "value": "The Third Day and the Language of Hope"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 14,
    "value": "Answer Opposition Without Dehumanizing People"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 15,
    "value": "The Resurrection Matters to the Whole Faith"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 16,
    "value": "Extraordinary Claims Invite Patient Investigation"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 17,
    "value": "The Humility to Revise an Assumption"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 18,
    "value": "A Living Hope in an Unexpected Encounter"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 19,
    "value": "Recognizing What We Did Not Expect"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 20,
    "value": "The Wounds and the Promise of New Life"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 21,
    "value": "Witnesses for a Wider World"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 22,
    "value": "Hear the Women Who Came First"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 23,
    "value": "Sincerity and Truth Are Different Questions"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 24,
    "value": "Trace the Story from Claim to Conclusion"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 25,
    "value": "Confront Difficult Accounts with Integrity"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 26,
    "value": "Faith Is Not a Contest of Timetables"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 27,
    "value": "Revisit the Evidence with Fairness"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 28,
    "value": "Witness That Costs Something"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 29,
    "value": "A Verdict Is the Beginning of Responsibility"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 1,
    "value": "<p><strong>Read:</strong> 1 Corinthians 15:1-8; Acts 17:10-12</p><p><strong>Source and historical context:</strong> Thomas Sherlock opens his circa-1729 defense of the resurrection as a fictional conversation among lawyers responding to Thomas Woolston’s criticisms of Jesus’ miracles. Friendly disagreement becomes a mock courtroom hearing, with an appointed judge and jury. The scene is an argument arranged by Sherlock, not a historical trial of the apostles.</p><p><strong>Devotional focus:</strong> Christian faith does not need to begin by pretending that questions have disappeared. Paul identifies the resurrection as central to the message he received and proclaimed. The Bereans, meanwhile, listened carefully and examined the Scriptures. These habits belong together: listen without panic, test what is claimed, and allow a question to sharpen understanding rather than silence compassion.</p><p><strong>Reflect:</strong> Which question about faith have I avoided because I feared what someone might think?</p><p><strong>Practice:</strong> Write down one sincere question. Read the passages slowly and speak with someone who will listen without pressuring you.</p><p><strong>Prayer:</strong> Risen Lord, give me patience to ask, honesty to listen, and courage to follow what is true. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 2,
    "value": "<p><strong>Read:</strong> Luke 1:1-4; Proverbs 18:13-17</p><p><strong>Source and historical context:</strong> In the second source segment, the two imaginary advocates dispute who must introduce the evidence. The judge narrows the proceeding: the question is whether particular objections defeat the testimony already under discussion. One speaker rejects the idea that long-standing belief alone can override reason.</p><p><strong>Devotional focus:</strong> Much confusion begins when people answer different questions without noticing. Luke explains that he investigated accounts so a reader could understand what had been taught. Proverbs cautions us against judging before hearing a matter. Clarifying the claim does not force agreement, but it makes a conversation fairer and gives everyone a chance to speak honestly.</p><p><strong>Reflect:</strong> When I defend a belief, can I explain the precise question without attacking the person asking?</p><p><strong>Practice:</strong> Before your next disagreement, restate the other person’s question in words they would recognize. Then answer that question, not an easier one.</p><p><strong>Prayer:</strong> God of truth, help my words be clear, fair, and free from needless defensiveness. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 3,
    "value": "<p><strong>Read:</strong> 1 Thessalonians 5:21-22; Acts 17:11-12</p><p><strong>Source and historical context:</strong> Sherlock’s courtroom figures compare the resurrection with other religious claims and a contemporary controversy about a reported revival from death. The dialogue includes unfair descriptions of Islam. The mock jury then asks to hear objections and responses one by one, rather than in an overwhelming bundle.</p><p><strong>Devotional focus:</strong> Paul invites believers to test what they hear and hold fast to what is good. That discipline includes examining claims carefully and describing neighbors’ faiths without caricature. An extraordinary testimony deserves thoughtful questions, but dismissive comparisons are no substitute for careful inquiry. Seeking truth and treating people honorably strengthen rather than weaken one another.</p><p><strong>Reflect:</strong> Do I test an idea fairly, or do I first look for an unflattering comparison?</p><p><strong>Practice:</strong> Choose one claim you have heard secondhand. Separate what was reported, what was inferred, and what you have not verified.</p><p><strong>Prayer:</strong> Lord, teach me to seek understanding without prejudice and to speak with respect. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 4,
    "value": "<p><strong>Read:</strong> John 18:33-37; Luke 24:25-27</p><p><strong>Source and historical context:</strong> The imaginary skeptical advocate proposes a political plot: Jesus allegedly reinterpreted messianic hopes to build a movement. The speech characterizes Jewish people in sweeping and prejudicial ways. These are accusations spoken by a fictional advocate, not historical findings, and they require rejection as descriptions of an entire people.</p><p><strong>Devotional focus:</strong> Before Pilate, Jesus describes a kingdom that does not advance by the ordinary weapons of earthly power. After Easter, the risen Jesus helps disciples reread the Scriptures in light of suffering and glory. The Gospel challenges every generation’s desire to turn faith into domination. We can examine the difficult history of Jesus’ trial without blaming Jewish people collectively or making political success the measure of God’s work.</p><p><strong>Reflect:</strong> Where have I confused the power of God with the power to control others?</p><p><strong>Practice:</strong> Read John 18 carefully. Name one way to serve truth this week without trying to force someone else to agree.</p><p><strong>Prayer:</strong> Jesus, reshape my expectations so that I seek your truth and peace instead of status. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 5,
    "value": "<p><strong>Read:</strong> 1 Corinthians 15:3-8; John 20:30-31</p><p><strong>Source and historical context:</strong> The defender challenges the skeptic’s imagined account of a deliberate conspiracy. In Sherlock’s courtroom, he repeatedly demands evidence for accusations and asks how the earliest believers came to accept the resurrection rather than merely inheriting a later tradition.</p><p><strong>Devotional focus:</strong> An explanation can sound complete and still rest on assumptions. Paul names people and communities connected with the early proclamation of Jesus’ rising. John says his Gospel records signs so readers may believe and have life in Christ. Those texts invite us to examine what the witnesses actually claim. They do not remove every historical question, but they remind us to distinguish testimony from an invented account of motives.</p><p><strong>Reflect:</strong> When I hear a confident theory, do I ask which parts are supported and which parts are guessed?</p><p><strong>Practice:</strong> Read 1 Corinthians 15:3–8. Make two columns: what Paul explicitly states, and what you would need further evidence to establish.</p><p><strong>Prayer:</strong> God of light, guard me from easy accusations and guide me toward careful listening. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 6,
    "value": "<p><strong>Read:</strong> John 6:14-15; Mark 10:42-45</p><p><strong>Source and historical context:</strong> Sherlock’s fictional defender argues that a schemer trying to win political support would normally flatter popular expectations. Instead, he says, Jesus disappointed hopes for a worldly conqueror, which complicates the proposed conspiracy. The argument takes place within an eighteenth-century interpretation of first-century events.</p><p><strong>Devotional focus:</strong> In John’s Gospel, Jesus refuses a crowd’s attempt to make him king. In Mark, he tells disciples that greatness is found not in ruling over others but in serving them. Courage sometimes means turning away from the applause we could easily obtain. Faithfulness cannot be judged only by how well a message satisfies a crowd.</p><p><strong>Reflect:</strong> Am I tempted to say what will win approval rather than what will be helpful and true?</p><p><strong>Practice:</strong> In one conversation today, choose a gentle but honest response over the answer most likely to impress.</p><p><strong>Prayer:</strong> Servant King, free my heart from the need to be applauded. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 7,
    "value": "<p><strong>Read:</strong> John 18:36-37; Matthew 20:25-28</p><p><strong>Source and historical context:</strong> The debate turns to the allegation that Jesus secretly sought political rule while publicly denying a worldly kingdom. Sherlock’s defender points out the tension in this theory: opposition to an expected political deliverer would seem an odd method of gathering political power.</p><p><strong>Devotional focus:</strong> Jesus describes his kingdom as different from the kingdoms of this world and teaches his followers to lead through service. These passages do not settle every question of ancient politics, but they speak directly to the way believers use influence. Christian leadership becomes distorted when the language of the kingdom hides ambition for personal control.</p><p><strong>Reflect:</strong> Where might I use the language of service while hoping secretly to gain an advantage?</p><p><strong>Practice:</strong> Practice leadership as service: do one useful task that benefits someone who cannot reward you.</p><p><strong>Prayer:</strong> Lord Jesus, teach me to serve without disguising ambition as faith. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 8,
    "value": "<p><strong>Read:</strong> Luke 24:44-48; Acts 2:22-24</p><p><strong>Source and historical context:</strong> Sherlock’s defender considers the prediction of Jesus’ death and rising, then distinguishes between a calculated fraud and mistaken enthusiasm. The dialogue insists these are different claims requiring different arguments; the actors cannot simply change a theory without accounting for the change.</p><p><strong>Devotional focus:</strong> The Gospel presents Jesus’ suffering and resurrection as the ground of repentance and forgiveness. Peter likewise preaches that the crucified Jesus was raised by God. The announcement of hope calls for more than a slogan: it invites patient attention to the story, humility about what we can prove, and a response of transformed living.</p><p><strong>Reflect:</strong> Do I change my explanation whenever it becomes uncomfortable, or admit where I remain uncertain?</p><p><strong>Practice:</strong> Read Luke 24:44–48 and write down the practical response Jesus asks of his witnesses.</p><p><strong>Prayer:</strong> Risen Christ, shape my hope around your life and teach me honest, humble conviction. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 9,
    "value": "<p><strong>Read:</strong> Matthew 27:62-66; Matthew 28:1-10</p><p><strong>Source and historical context:</strong> The skeptical advocate turns to Matthew’s account of Jesus’ burial, the guards, and the sealed tomb. He treats the guard and seal as evidence of an alleged breach and theft. These points are literary claims within Sherlock’s staged debate, not independent surviving records from Roman or Judean officials.</p><p><strong>Devotional focus:</strong> Matthew describes people trying to secure the tomb, followed by women arriving with grief and receiving news that changes their understanding. When reading a familiar story, it matters which details the Gospel gives us and which conclusions later writers add. Careful reading honors Scripture by resisting the urge to claim more certainty than the text supplies.</p><p><strong>Reflect:</strong> What detail of a familiar Bible story have I repeated without checking the passage?</p><p><strong>Practice:</strong> Read Matthew 27:62–28:10 in one sitting. Mark what the narrator says, what each character says, and what remains unstated.</p><p><strong>Prayer:</strong> God of truth, make me attentive to your Word and careful with the claims I pass on. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 10,
    "value": "<p><strong>Read:</strong> John 11:43-45; John 12:9-11</p><p><strong>Source and historical context:</strong> Sherlock’s defender responds to claims about the sealed tomb and a theory that the raising of Lazarus was a known fraud. He asks whether there is evidence of that accusation and distinguishes an allegation from facts reported in the Gospels.</p><p><strong>Devotional focus:</strong> John records Lazarus leaving the tomb and shows how differently people responded: some believed, while others opposed Jesus. A reaction to an event, whether enthusiastic or suspicious, is not the same as an independent investigation. As we read, we can be open to what the Gospel intends to proclaim while identifying where arguments about its historicity rely on interpretation.</p><p><strong>Reflect:</strong> Do I assume an accusation becomes evidence merely because it has been repeated?</p><p><strong>Practice:</strong> Before passing on a serious allegation, identify its original source and what has actually been established.</p><p><strong>Prayer:</strong> Lord, protect my speech from rumor and give me a love for careful truth. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 11,
    "value": "<p><strong>Read:</strong> Matthew 28:11-15; Proverbs 18:13-17</p><p><strong>Source and historical context:</strong> In this part of Sherlock’s dialogue, the defense addresses the reported story that disciples stole Jesus’ body. He examines whether people who were asleep could know what happened and argues over what testimony can fairly establish.</p><p><strong>Devotional focus:</strong> Matthew tells a story about a competing explanation for the empty tomb. Proverbs warns that answering before hearing is folly. Both readings challenge us to distinguish what a witness saw from what a witness inferred or heard from someone else. Fairness does not demand treating every account as equally strong; it asks us to understand why we trust one explanation and question another.</p><p><strong>Reflect:</strong> Am I willing to identify the limits of my own knowledge when I testify about something?</p><p><strong>Practice:</strong> For one disputed story, label each statement firsthand observation, secondhand report, or inference.</p><p><strong>Prayer:</strong> Wise God, make me honest about what I know and generous when others struggle to understand. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 12,
    "value": "<p><strong>Read:</strong> Matthew 28:1-15; Proverbs 14:15</p><p><strong>Source and historical context:</strong> Sherlock’s defender presses the practical difficulties of the body-theft explanation: the disciples’ fear, the presence of guards, and what would be required to move a body unnoticed. These remain arguments developed from the Gospel narrative rather than independently verified reconstructions.</p><p><strong>Devotional focus:</strong> Proverbs praises the prudent person who weighs a step rather than believing every report. Skepticism can be useful, but it is incomplete when it invents a suspicious story without checking how it might have occurred. Likewise, believing the resurrection need not mean refusing difficult questions. Careful thinking follows a claim through its consequences and recognizes its limits.</p><p><strong>Reflect:</strong> Do I find a theory persuasive because it sounds clever, or because it fits the evidence available?</p><p><strong>Practice:</strong> Pick one explanation of a difficult event. Ask what facts would make it stronger, and what would count against it.</p><p><strong>Prayer:</strong> Lord, give me patience with complex questions and freedom from careless suspicion. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 13,
    "value": "<p><strong>Read:</strong> Luke 24:1-7; Acts 4:1-12</p><p><strong>Source and historical context:</strong> The debate considers Friday-to-Sunday timing and explains an ancient inclusive way of counting days. Sherlock then argues from the apostles’ later public testimony that the theft accusation had little force in their own time. His conclusions are interpretations of the Gospel and Acts accounts.</p><p><strong>Devotional focus:</strong> Luke places the announcement of the resurrection on the first day of the week. In Acts, Peter publicly names Jesus as the one raised from the dead. The Gospel’s hope is not a puzzle about clocks alone; it is a proclamation that loss and death do not have the final word. We can study ancient language carefully without turning faith into a contest of technicalities.</p><p><strong>Reflect:</strong> Does my attention to minor disputes sometimes eclipse the hope at the center of Easter?</p><p><strong>Practice:</strong> Read Luke 24:1–7 aloud, then name one circumstance in which the promise of new life gives you courage.</p><p><strong>Prayer:</strong> Risen Jesus, deepen my understanding and keep my heart fixed on your living hope. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 14,
    "value": "<p><strong>Read:</strong> Acts 5:27-42; Acts 26:24-29</p><p><strong>Source and historical context:</strong> Sherlock next appeals to Acts, including Gamaliel’s advice, the apostles’ hearings, and Paul’s conversation before Agrippa. He treats the absence of a recorded fraud accusation as meaningful. His sweeping characterizations of Jewish opponents reflect polemical habits that require critical distance.</p><p><strong>Devotional focus:</strong> Acts portrays real conflict among people, leaders, and communities, including Jewish followers of Jesus themselves. Peter and the apostles answer with a commitment to obey God; Paul explains his hope before political authorities. Their examples can encourage courage under questioning without making any religious or ethnic community the villain of the story.</p><p><strong>Reflect:</strong> Can I stand firm about my beliefs without simplifying another group into enemies?</p><p><strong>Practice:</strong> Describe an opponent’s position accurately and pray for the dignity and safety of everyone in the disagreement.</p><p><strong>Prayer:</strong> God of peace, let my convictions be strong and my treatment of others gentle. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 15,
    "value": "<p><strong>Read:</strong> 1 Corinthians 15:12-20; Luke 24:36-43</p><p><strong>Source and historical context:</strong> A new section of the staged trial asks whether reports of Jesus alive after death can bear the weight placed upon them. The skeptic argues that so extraordinary an event cannot be established by ordinary testimony and questions the character of the appearances.</p><p><strong>Devotional focus:</strong> Paul takes resurrection seriously enough to say that Christian hope would be empty without it. Luke describes startled disciples receiving reassurance from Jesus. These texts neither forbid honest doubt nor pretend every question can be solved by confidence alone. They show why the claim matters: Easter is presented as more than a metaphor for positive thinking.</p><p><strong>Reflect:</strong> What difference would it make to my faith if resurrection were only a symbol?</p><p><strong>Practice:</strong> Read 1 Corinthians 15:12–20. Write down the specific consequences Paul connects with Christ’s rising.</p><p><strong>Prayer:</strong> Risen Lord, help me face the central claims of my faith with openness and care. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 16,
    "value": "<p><strong>Read:</strong> 1 Corinthians 15:14-19; 1 Thessalonians 5:21</p><p><strong>Source and historical context:</strong> Sherlock’s defender uses a comparison with unfamiliar natural phenomena, including water becoming ice, to challenge the claim that testimony cannot establish an unexpected event. The analogy is part of his eighteenth-century reasoning; it is not a scientific proof of a miracle.</p><p><strong>Devotional focus:</strong> Paul calls believers to test what they hear. The Gospel’s resurrection proclamation asks us to consider testimony that differs from ordinary experience. We need not treat every unfamiliar account as true, nor dismiss it merely because it surprises us. Intellectual humility asks what kind of evidence a claim would require and whether the sources actually supply it.</p><p><strong>Reflect:</strong> Do I confuse what I have never seen with what is impossible, or what I wish were true with what is proven?</p><p><strong>Practice:</strong> Consider one unusual claim and list which observations or sources would genuinely help assess it.</p><p><strong>Prayer:</strong> God of wisdom, teach me discernment that is neither gullible nor closed. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 17,
    "value": "<p><strong>Read:</strong> John 20:24-29; 1 Peter 3:15-16</p><p><strong>Source and historical context:</strong> The advocate distinguishes disbelief in someone’s testimony from proof that an event could not have occurred. He concedes that unusual claims need more evidence and argues that people sometimes mistake the limits of familiar experience for the limits of possibility.</p><p><strong>Devotional focus:</strong> Thomas seeks a particular kind of reassurance, and Jesus meets him without treating his questions as the end of the conversation. Peter calls believers to give reasons for hope with gentleness and respect. The point is not to force certainty on anyone. It is to allow honest testing, patience, and a willingness to revise an assumption if there is good reason to do so.</p><p><strong>Reflect:</strong> What belief about the world have I treated as unquestionable merely because it is familiar?</p><p><strong>Practice:</strong> Name one assumption and ask what kind of new information could responsibly change your mind.</p><p><strong>Prayer:</strong> Patient Lord, free me from pride and help me welcome truth even when it surprises me. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 18,
    "value": "<p><strong>Read:</strong> Luke 24:36-43; John 20:11-18</p><p><strong>Source and historical context:</strong> The debate returns to the ordinary expectation that people do not rise after dying. Sherlock then considers the Gospel stories of Mary Magdalene and the road to Emmaus, defending the reality of Jesus’ risen body against the suggestion that the appearances were only phantoms.</p><p><strong>Devotional focus:</strong> Luke portrays disciples startled by an appearance they cannot immediately explain. John portrays Mary moving from grief to recognition when Jesus calls her by name. These passages hold together deep sorrow and an unexpected claim of new life. They do not require us to deny the reality of loss; they invite us to notice how the Easter narratives speak hope into it.</p><p><strong>Reflect:</strong> When grief changes the way I see the world, can I make room for patient companionship and hope?</p><p><strong>Practice:</strong> Read John 20:11–18, noticing Mary’s questions and emotions. Offer attentive presence to someone who is grieving.</p><p><strong>Prayer:</strong> Living Jesus, meet us in loss and teach us to be gentle companions to one another. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 19,
    "value": "<p><strong>Read:</strong> Luke 24:13-35; John 20:19-23</p><p><strong>Source and historical context:</strong> Sherlock addresses the Emmaus travelers’ delayed recognition of Jesus and descriptions of his appearing or disappearing. He proposes that the accounts may be read without assuming the risen Jesus had no real body. He admits that some details invite interpretation.</p><p><strong>Devotional focus:</strong> In Luke’s narrative, understanding unfolds through conversation, Scripture, hospitality, and the breaking of bread. Recognition does not arrive on demand. Believers sometimes understand a truth gradually rather than in one dramatic instant. The story encourages us to keep walking, listening, and welcoming others even when our understanding remains partial.</p><p><strong>Reflect:</strong> Where might I need to stop demanding instant clarity and practice patient attention?</p><p><strong>Practice:</strong> Read the Emmaus story. Share a meal or conversation in which listening matters more than winning an argument.</p><p><strong>Prayer:</strong> Lord Jesus, walk with us in confusion and open our hearts to wisdom and hospitality. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 20,
    "value": "<p><strong>Read:</strong> John 20:24-29; 1 Corinthians 15:35-44</p><p><strong>Source and historical context:</strong> Sherlock tackles a new objection about Jesus’ wounds, then turns to the question of why the risen Christ did not appear publicly to every ruler and citizen. He reasons about what kind of witnesses the Gospels present and where their testimony was directed.</p><p><strong>Devotional focus:</strong> John shows Thomas encountering the wounded risen Jesus; Paul describes resurrection as transformation rather than simple reversal of ordinary mortality. Christian hope does not erase the history of suffering or require every hard question to disappear. The wounds in the story direct our attention to Christ’s costly love and the possibility of life made new.</p><p><strong>Reflect:</strong> What part of my experience do I wish could simply be erased rather than held with care?</p><p><strong>Practice:</strong> Read John 20:24–29. Pray for those living with pain and offer a concrete act of support if you can.</p><p><strong>Prayer:</strong> Jesus, whose risen life bears the marks of love, help us honor suffering without glorifying harm. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 21,
    "value": "<p><strong>Read:</strong> Matthew 28:16-20; Acts 1:6-11</p><p><strong>Source and historical context:</strong> The defender explains why the Gospels describe appearances to selected followers rather than a public demonstration before Jerusalem’s rulers or Rome’s senate. Sherlock frames the resurrection as the beginning of a mission intended for people beyond one place.</p><p><strong>Devotional focus:</strong> Matthew sends disciples to all nations, and Acts portrays them receiving a commission that reaches beyond their immediate community. The Christian mission must not be interpreted as God discarding the Jewish people; the first followers of Jesus were themselves Jewish. For believers now, Easter witness should take the shape of humble teaching, shared life, and hospitality instead of religious superiority.</p><p><strong>Reflect:</strong> Does my understanding of mission lead me to invite and serve, or to speak as though others lack dignity?</p><p><strong>Practice:</strong> Consider how your church welcomes people from different backgrounds. Make one change that helps someone feel genuinely included.</p><p><strong>Prayer:</strong> Lord of all nations, send us as humble witnesses whose words and actions carry your love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 22,
    "value": "<p><strong>Read:</strong> Luke 24:1-12; John 20:1-18</p><p><strong>Source and historical context:</strong> The debate specifically addresses the women at the tomb. Its eighteenth-century speakers repeat a sexist insult while disputing whether women should count as witnesses. The defender ultimately acknowledges that women could report what they saw, though he still treats male testimony as the decisive public evidence.</p><p><strong>Devotional focus:</strong> The Gospels themselves place women at the center of the first Easter morning. They come in grief, notice the empty tomb, receive a message, and speak to others. Their voices should not be dismissed because of their gender. The risen Christ’s story teaches us to listen to those whom custom or prejudice is quick to disregard.</p><p><strong>Reflect:</strong> Whose truthful account do I discount because I have been taught to value some voices more than others?</p><p><strong>Practice:</strong> Read John 20:1–18 and notice Mary’s actions. Invite someone usually interrupted to tell their story without interference.</p><p><strong>Prayer:</strong> Risen Lord, teach us to hear faithfully and honor every person who bears witness to truth. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 23,
    "value": "<p><strong>Read:</strong> 1 Corinthians 15:3-8; Acts 4:13-20</p><p><strong>Source and historical context:</strong> Sherlock considers claims that apostolic courage and miraculous signs supported their preaching. The skeptical speaker replies that people of many religions have suffered for beliefs that may be mistaken; the discussion then distinguishes sincere conviction from the truth of the event asserted.</p><p><strong>Devotional focus:</strong> Peter and John speak before a council with striking courage, yet courage alone is not proof of every claim they make. Paul preserves an early testimony about resurrection and appearances. We can respect sincere conviction while still examining reasons. Christian witness is strongest when it welcomes fair questions and refuses the idea that hardship automatically settles a dispute.</p><p><strong>Reflect:</strong> Do I confuse how intensely someone believes with whether their belief has been established?</p><p><strong>Practice:</strong> In one discussion, affirm a person’s sincerity while asking what evidence or reasoning supports the claim.</p><p><strong>Prayer:</strong> God of truth, make me both charitable toward people and careful with what I affirm. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 24,
    "value": "<p><strong>Read:</strong> Luke 23:44-56; Matthew 27:62-66</p><p><strong>Source and historical context:</strong> The mock judge now summarizes the entire case. He divides it into three periods: Jesus’ ministry, the interval from his death to the reported resurrection, and the later testimony. This segment especially revisits the preparation of the alleged fraud and the sealed tomb.</p><p><strong>Devotional focus:</strong> A complicated question becomes easier to assess when we identify which stage each statement concerns. Luke tells of Jesus’ death and burial; Matthew adds the guard story. The accounts were written for theological purposes as well as narration. Respectful reading requires us not to mix separate moments or claim an ancient narrator answered questions he did not address.</p><p><strong>Reflect:</strong> Can I explain the difference between the event being claimed and the later interpretation offered?</p><p><strong>Practice:</strong> Draw a simple timeline of the passages, labeling narrated events separately from inferences made by later interpreters.</p><p><strong>Prayer:</strong> Lord, grant me patience for careful reading and freedom from rushed conclusions. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 25,
    "value": "<p><strong>Read:</strong> Matthew 28:1-15; Acts 5:34-39</p><p><strong>Source and historical context:</strong> The judge’s summary returns to the guards, the empty tomb, and a reported explanation of theft. He also considers whether political leaders had reason to investigate the apostles’ public testimony. The courtroom speech treats several contested Gospel details as evidence and draws conclusions that are Sherlock’s own.</p><p><strong>Devotional focus:</strong> Matthew places rival accounts side by side; Acts includes Gamaliel urging caution before making destructive judgments. Faithful reading is not helped by disguising interpretive questions as settled facts. We can take Scripture seriously and still say, “This is what the text reports; here is what I infer; here is what I do not know.” Such honesty can make room for deeper trust.</p><p><strong>Reflect:</strong> Am I prepared to acknowledge limits in an argument that supports something precious to me?</p><p><strong>Practice:</strong> Choose one line of argument about Easter and distinguish its textual foundation from the conclusions drawn beyond it.</p><p><strong>Prayer:</strong> God of truth, keep me faithful without exaggeration and courageous without contempt. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 26,
    "value": "<p><strong>Read:</strong> Luke 24:1-12; Acts 4:5-12</p><p><strong>Source and historical context:</strong> The judge revisits inclusive counting of the third day, public hearings described in Acts, and an objection that resurrection lies outside the usual course of nature. He answers by emphasizing the difference between the unfamiliar and the logically impossible.</p><p><strong>Devotional focus:</strong> Luke’s resurrection account turns mourners toward unexpected hope; Peter’s witness in Acts centers on Jesus whom God raised. Questions about calendar expressions deserve clear historical explanation, but they are not the heart of the Gospel. The Easter claim invites careful thought and a response of trust, courage, and love.</p><p><strong>Reflect:</strong> Am I using a secondary technical detail to avoid considering the central meaning of Easter?</p><p><strong>Practice:</strong> Study the opening of Luke 24. Write one sentence about what the witnesses say happened and one about why it matters to you.</p><p><strong>Prayer:</strong> Living Lord, help me seek understanding without losing sight of your call to new life. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 27,
    "value": "<p><strong>Read:</strong> Luke 24:36-49; John 20:24-29</p><p><strong>Source and historical context:</strong> The judge recaps arguments about Jesus’ bodily appearances, Mary Magdalene, the disciples behind closed doors, the selection of witnesses, and the women’s testimony. He also acknowledges the skeptic’s warning that suffering for a belief does not by itself establish that belief.</p><p><strong>Devotional focus:</strong> The Gospels portray people surprised, afraid, questioning, and slowly convinced. These human responses matter more than the caricature that faith always arrives without thought. A fair review does not suppress difficult evidence or mock doubts. It asks what the sources say and what follows reasonably from them, while remembering that real people live behind our arguments.</p><p><strong>Reflect:</strong> Can I describe a sincere objection to my belief without mocking it?</p><p><strong>Practice:</strong> Summarize a viewpoint you disagree with in three fair sentences. Then read John 20:24–29 with empathy for Thomas.</p><p><strong>Prayer:</strong> Lord Jesus, make me teachable and respectful while I look for truth. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 28,
    "value": "<p><strong>Read:</strong> Acts 4:18-21; 2 Corinthians 4:7-12</p><p><strong>Source and historical context:</strong> The judge distinguishes dying for an inherited opinion from enduring hardship for a claim one says one directly witnessed. Sherlock applies this to the apostles and argues that their refusal to recant supports sincerity. Such reasoning does not establish independently how each apostle died or prove the resurrection on its own.</p><p><strong>Devotional focus:</strong> In Acts, Peter and John refuse to stop speaking about what they say they have seen and heard. Paul describes the fragility of witnesses who carry treasure in ordinary human lives. Faithful witness may require cost, but it must never become a demand to seek danger or remain in abuse. The calling is truthful perseverance joined to care.</p><p><strong>Reflect:</strong> What does costly faithfulness look like without recklessness or pressure to suffer?</p><p><strong>Practice:</strong> Identify one small, safe action where honesty has a price. Choose integrity while also respecting your wellbeing and others’ safety.</p><p><strong>Prayer:</strong> Sustaining God, help me bear witness with courage, humility, and wisdom. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 29,
    "value": "<p><strong>Read:</strong> Acts 5:30-32; John 20:30-31</p><p><strong>Source and historical context:</strong> The fictional judge concludes the debate, weighing reported miracles, the apostles’ testimony, and the objections that later readers cannot witness ancient events directly. The imaginary jury finds the apostles “not guilty” of false testimony, and the dialogue ends with another proposed case concerning Lazarus. This is Sherlock’s literary verdict, not an actual court judgment.</p><p><strong>Devotional focus:</strong> John explains that his testimony is written to invite life-giving belief in Jesus. Acts portrays witnesses speaking from conviction and attributing their courage to the Spirit. Reading a persuasive argument may bring us toward faith, leave us uncertain, or open new questions. The worthy next step is neither triumph over skeptics nor shame for doubters, but a life that seeks truth and practices love.</p><p><strong>Reflect:</strong> What kind of person am I becoming as I consider the resurrection?</p><p><strong>Practice:</strong> Write one hope, one remaining question, and one act of love that your reading invites you to practice this week.</p><p><strong>Prayer:</strong> Living Christ, lead me beyond arguments alone into faithfulness, truth, and love. Amen.</p>"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

-- Update one plan-owned Scripture-reference row per day. User-owned notes/references are untouched.
do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 1,
    "references": [
      "1 Corinthians 15:1-8",
      "Acts 17:10-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 2,
    "references": [
      "Luke 1:1-4",
      "Proverbs 18:13-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 3,
    "references": [
      "1 Thessalonians 5:21-22",
      "Acts 17:11-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 4,
    "references": [
      "John 18:33-37",
      "Luke 24:25-27"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 5,
    "references": [
      "1 Corinthians 15:3-8",
      "John 20:30-31"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 6,
    "references": [
      "John 6:14-15",
      "Mark 10:42-45"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 7,
    "references": [
      "John 18:36-37",
      "Matthew 20:25-28"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 8,
    "references": [
      "Luke 24:44-48",
      "Acts 2:22-24"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 9,
    "references": [
      "Matthew 27:62-66",
      "Matthew 28:1-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 10,
    "references": [
      "John 11:43-45",
      "John 12:9-11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 11,
    "references": [
      "Matthew 28:11-15",
      "Proverbs 18:13-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 12,
    "references": [
      "Matthew 28:1-15",
      "Proverbs 14:15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 13,
    "references": [
      "Luke 24:1-7",
      "Acts 4:1-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 14,
    "references": [
      "Acts 5:27-42",
      "Acts 26:24-29"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 15,
    "references": [
      "1 Corinthians 15:12-20",
      "Luke 24:36-43"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 16,
    "references": [
      "1 Corinthians 15:14-19",
      "1 Thessalonians 5:21"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 17,
    "references": [
      "John 20:24-29",
      "1 Peter 3:15-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 18,
    "references": [
      "Luke 24:36-43",
      "John 20:11-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 19,
    "references": [
      "Luke 24:13-35",
      "John 20:19-23"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 20,
    "references": [
      "John 20:24-29",
      "1 Corinthians 15:35-44"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 21,
    "references": [
      "Matthew 28:16-20",
      "Acts 1:6-11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 22,
    "references": [
      "Luke 24:1-12",
      "John 20:1-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 23,
    "references": [
      "1 Corinthians 15:3-8",
      "Acts 4:13-20"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 24,
    "references": [
      "Luke 23:44-56",
      "Matthew 27:62-66"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 25,
    "references": [
      "Matthew 28:1-15",
      "Acts 5:34-39"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 26,
    "references": [
      "Luke 24:1-12",
      "Acts 4:5-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 27,
    "references": [
      "Luke 24:36-49",
      "John 20:24-29"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 28,
    "references": [
      "Acts 4:18-21",
      "2 Corinthians 4:7-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000371",
    "day_number": 29,
    "references": [
      "Acts 5:30-32",
      "John 20:30-31"
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
where id = '90000000-0000-0000-0000-000000000371'::uuid;

commit;
