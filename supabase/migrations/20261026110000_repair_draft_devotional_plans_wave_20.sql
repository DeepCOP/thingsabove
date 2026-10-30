-- Plan 284: The Pulpit of the Reformation, Nos. 1–4 (1834–1835 collection).
-- Thirty-two source-grounded devotional readings; all summaries, reflections, and prayers are new editorial writing.
-- The historical sermons contain disputed polemics and graphic eschatological rhetoric; these are contextualized.
-- Preserve existing day IDs, day numbers, and user progress; no row deletions or insertions in devotional_days.
-- Reviewed for devotional suitability and approved for publication.

begin;

-- Fail safely if the original plan's identity, source, or day count has changed.
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
  where id = '90000000-0000-0000-0000-000000000284'::uuid;
  if not found then raise exception 'Plan 284 is missing'; end if;
  if source_link is distinct from 'https://www.gutenberg.org/ebooks/28104'
     or reported_total is distinct from 32 then
    raise exception 'Plan 284 source URL or total_days differs from reviewed source';
  end if;
  select count(*), min(day_number), max(day_number), count(distinct day_number)
  into present_days, first_day, last_day, distinct_days
  from public.devotional_days
  where plan_id = '90000000-0000-0000-0000-000000000284'::uuid;
  if present_days <> 32 or first_day <> 1 or last_day <> 32 or distinct_days <> 32 then
    raise exception 'Plan 284 must have exactly 32 unique numbered days, found %', present_days;
  end if;
end
$$;


update public.devotional_plans as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "value": "Faith, Grace, and Courage: 32 Readings from the Reformation Pulpit"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;


update public.devotional_plans as target
set description = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "value": "Thirty-two Scripture-led devotional readings inspired by The Pulpit of the Reformation, Nos. 1–4, an 1834–1835 collection presenting sermons of John Welch, Hugh Latimer, and John Knox. The readings follow the inherited progression through Christian watchfulness, divine justice, grace, parables, responsible leadership, exile, resurrection, and God’s comfort under pressure. Each reading contains a newly curated biblical focus, a clearly labeled description of the historical source, original reflection, reflection question, practice, and prayer. These are new editorial adaptations, not verbatim sermons or quotations. Historical anti-Catholic and anti-Muslim polemics, apocalyptic identifications, and judgment rhetoric are treated as period interpretations, not endorsed as judgments on contemporary communities. The original text remains available through the linked Project Gutenberg source."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;


update public.devotional_days as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 1,
    "value": "Awake to What Matters"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 2,
    "value": "Hope under Pressure"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 3,
    "value": "Worship the Creator"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 4,
    "value": "Come to the Throne of Grace"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 5,
    "value": "Lay Down Your Crown"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 6,
    "value": "Justice Without Favoritism"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 7,
    "value": "Hold Fast to Enduring Words"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 8,
    "value": "Search Your Heart, Receive Mercy"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 9,
    "value": "Comfort One Another with Hope"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 10,
    "value": "Stay Awake in Daily Life"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 11,
    "value": "Grace Is Not a Wage"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 12,
    "value": "Honor Faithful Work"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 13,
    "value": "Look for God’s Heart in Christ"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 14,
    "value": "Let the Good Seed Grow"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 15,
    "value": "Leave Final Judgment to God"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 16,
    "value": "Repentance Is a Door, Not a Dead End"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 17,
    "value": "Love Your Enemy without Coercion"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 18,
    "value": "No Earthly Power Is Ultimate"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 19,
    "value": "Leadership Is a Trust"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 20,
    "value": "Speak Up for Those at Risk"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 21,
    "value": "Learn from a Community’s Failures"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 22,
    "value": "Resist Evil without Becoming Cruel"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 23,
    "value": "Faithful in a Strange Land"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 24,
    "value": "Remember God in Trouble"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 25,
    "value": "God Does Not Abandon His People"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 26,
    "value": "Life beyond the Grave"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 27,
    "value": "Dry Bones Can Live Again"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 28,
    "value": "The Seed and the Promise"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 29,
    "value": "Shelter in the Promises of God"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 30,
    "value": "God Sees Hidden Harm"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 31,
    "value": "Trust Justice Beyond Revenge"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 32,
    "value": "It Is I—Do Not Be Afraid"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;


update public.devotional_days as target
set content = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 1,
    "value": "<p><strong>Read:</strong> Revelation 2:4-5; Revelation 3:1-3</p><p><strong>Source and historical context:</strong> John Welch opens his sermon on judgment by describing the church as spiritually sleepy. Drawing on the messages to the seven churches in Revelation, he asks hearers to consider whether outward religion has replaced living devotion.</p><p><strong>Devotional focus:</strong> An honest spiritual inventory begins not with predicting the end of the world but with examining the present heart. The call to return to first love is both serious and merciful: Christ notices complacency, yet invites renewal. Our attention can turn again toward truth, prayer, and neighborly love.</p><p><strong>Reflect:</strong> Where have you kept the appearance of faith while neglecting its practice?</p><p><strong>Practice:</strong> Name one habit of love or prayer that has grown cold. Take one small, sincere step to restore it today.</p><p><strong>Prayer:</strong> Lord Jesus, awaken what has grown indifferent in me. Give me a truthful heart, a willingness to repent, and fresh love for you and those around me. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 2,
    "value": "<p><strong>Read:</strong> Revelation 7:13-17; 1 Peter 5:8-10</p><p><strong>Source and historical context:</strong> Welch pictures the suffering church through Revelation’s seals, the souls of witnesses, and the promise of a people comforted before God. He also describes frightening symbolic visions and hostile figures using the controversies of his own era.</p><p><strong>Devotional focus:</strong> Apocalyptic images have often helped persecuted communities say that suffering and injustice are not the last word. We should resist turning every image into a confident prediction about current nations or religious groups. The promise at the center is God’s presence with people who have endured pain.</p><p><strong>Reflect:</strong> Who needs reassurance that their suffering has been seen and not dismissed?</p><p><strong>Practice:</strong> Offer steady help to someone experiencing hardship. Read Revelation’s promise of God wiping away tears before arguing about its symbols.</p><p><strong>Prayer:</strong> God of consolation, keep those who are afraid or persecuted. Make our hope patient, our words humble, and our care practical. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 3,
    "value": "<p><strong>Read:</strong> Revelation 14:6-7; Psalm 95:1-7</p><p><strong>Source and historical context:</strong> In a rapid survey of Revelation, Welch speaks of the Lamb, a new song, the everlasting gospel, and the call to worship the Maker of heaven and earth. His polemical identifications of the beasts and Babylon reflect a particular Reformation interpretation.</p><p><strong>Devotional focus:</strong> The call to worship the Creator addresses every generation without giving us permission to label present-day neighbors as enemies of God. Worship puts human power and pride in proportion. Before speculating about every symbol, we can ask whether our lives honor the One who gives them meaning.</p><p><strong>Reflect:</strong> Do you spend more attention on identifying threats than on worship, faithfulness, and love?</p><p><strong>Practice:</strong> Set aside anxious prediction. Pray through Psalm 95 and thank God for three ordinary gifts of creation.</p><p><strong>Prayer:</strong> Creator of heaven and earth, turn my attention from fear and contempt toward reverence. Teach me to live faithfully in this day. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 4,
    "value": "<p><strong>Read:</strong> Hebrews 4:14-16; Revelation 20:11-12</p><p><strong>Source and historical context:</strong> Welch contrasts Christ’s saving first coming with a future scene of judgment. Against the image of a final throne, he urges his congregation to approach the throne of grace while mercy is offered.</p><p><strong>Devotional focus:</strong> Accountability matters, yet the gospel does not ask us to manufacture safety through terror. Hebrews invites those who need mercy to approach confidently through Jesus. Honest confession can begin with trust that God hears us, rather than with an attempt to hide every weakness.</p><p><strong>Reflect:</strong> What have you concealed because you imagine that asking for mercy is itself a failure?</p><p><strong>Practice:</strong> In private prayer, name one burden honestly and ask for grace to make a fitting repair.</p><p><strong>Prayer:</strong> Merciful Christ, I come with need rather than excuses. Teach me to receive forgiveness and to walk toward what is right. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 5,
    "value": "<p><strong>Read:</strong> Revelation 4:9-11; Philippians 2:9-11</p><p><strong>Source and historical context:</strong> Welch dwells on the greatness of the throne in Revelation. He compares it with earthly rulers, Solomon’s splendor, gathered saints, and the crowns laid down before God.</p><p><strong>Devotional focus:</strong> No title, office, income, or influence makes a person ultimate. The elders’ worship is a picture of relinquishing the need to be at the center. Remembering God’s greatness should make leaders more accountable and all of us more willing to serve.</p><p><strong>Reflect:</strong> Which status or achievement are you tempted to treat as proof of your worth?</p><p><strong>Practice:</strong> Use an advantage you possess to make room for someone whose voice is usually overlooked.</p><p><strong>Prayer:</strong> King of all creation, free me from the need to stand above others. Teach me to use every responsibility with humility. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 6,
    "value": "<p><strong>Read:</strong> Genesis 18:25; 2 Corinthians 5:10</p><p><strong>Source and historical context:</strong> Welch explains the great white throne as an image of a judge who acts righteously, before whom powerful and ordinary people alike are accountable. His language includes the severe warnings typical of his preaching.</p><p><strong>Devotional focus:</strong> The conviction that God judges justly should unsettle favoritism, not license us to declare specific people condemned. We cannot know every human heart. We can, however, examine our dealings: do we tell the truth, defend the vulnerable, and refuse a double standard?</p><p><strong>Reflect:</strong> Where do you excuse in yourself what you criticize in someone with less influence?</p><p><strong>Practice:</strong> Review one decision for fairness. Correct any avoidable disadvantage you have imposed on another person.</p><p><strong>Prayer:</strong> Righteous God, judge my motives and correct my biases. Teach me to act fairly and trust judgment beyond my knowledge to you. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 7,
    "value": "<p><strong>Read:</strong> Luke 21:33; Matthew 25:31-40</p><p><strong>Source and historical context:</strong> Welch closes his vivid sermon on final judgment with an appeal to the enduring word of Christ and the seriousness of meeting him. His imagery stresses urgency and the need to take one’s conscience seriously.</p><p><strong>Devotional focus:</strong> Urgency need not become panic. Jesus calls for watchfulness expressed in faithfulness: feeding the hungry, welcoming strangers, and caring for the vulnerable are meaningful ways of taking his words seriously. Today is a real opportunity to love.</p><p><strong>Reflect:</strong> What act of mercy is being postponed while you worry about what the future might hold?</p><p><strong>Practice:</strong> Choose one tangible act of service, then read Jesus’ words about care for those in need.</p><p><strong>Prayer:</strong> Faithful Lord, anchor me in what endures. Replace speculation without action with courage to love my neighbor now. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 8,
    "value": "<p><strong>Read:</strong> 1 John 1:8-9; Hebrews 4:16</p><p><strong>Source and historical context:</strong> The inherited eighth section finishes Welch’s call to examine the conscience and seek pardon; it then begins Hugh Latimer’s sermon on the day of judgment. Both preachers urge readiness, though they speak in different voices.</p><p><strong>Devotional focus:</strong> Self-examination becomes destructive when it leaves no room for grace. Scripture joins honest acknowledgment of sin to God’s faithfulness in forgiveness. We do not need to exaggerate our guilt or our innocence. We can tell the truth and take a next step.</p><p><strong>Reflect:</strong> When you examine your actions, do you tend to excuse everything or condemn yourself without hope?</p><p><strong>Practice:</strong> Confess one specific wrong before God and consider one appropriate act of restitution or reconciliation.</p><p><strong>Prayer:</strong> God of truth and mercy, give me courage to see clearly and hope to begin again. Guide me toward repair and renewed trust. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 9,
    "value": "<p><strong>Read:</strong> 1 Thessalonians 4:13-18; Luke 21:27-28</p><p><strong>Source and historical context:</strong> Hugh Latimer speaks of Christ’s coming, the resurrection, and hope for those who have died. He urges his hearers to be ready and uses the images of budding trees and approaching events.</p><p><strong>Devotional focus:</strong> The Christian hope of resurrection is not a timetable for predicting a date. Paul offers it especially as comfort to grieving believers. The future belongs to God; meanwhile, hope can keep us attentive, compassionate, and faithful rather than trapped in dread.</p><p><strong>Reflect:</strong> How can your understanding of Christian hope become a comfort instead of a source of alarm?</p><p><strong>Practice:</strong> Reach out gently to someone carrying grief. Offer companionship without claiming to know when or how their pain will resolve.</p><p><strong>Prayer:</strong> Risen Jesus, strengthen those who mourn. Give us hope that steadies love and patience in the present. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 10,
    "value": "<p><strong>Read:</strong> Luke 21:34-36; Matthew 20:1-16</p><p><strong>Source and historical context:</strong> Latimer ends his sermon about watchfulness by urging prayer on waking and sleeping. This inherited day then introduces his sermon on the vineyard laborers and the surprising generosity of the householder.</p><p><strong>Devotional focus:</strong> Readiness is less about an anxious countdown and more about the ordinary habits that keep love alive. The vineyard parable adds a second insight: God’s generosity exceeds human calculations. A watchful heart makes room for grateful service, not comparison.</p><p><strong>Reflect:</strong> Do your daily routines help you remain attentive to God and generous toward others?</p><p><strong>Practice:</strong> Begin and end today with a short prayer. Notice one person whose labor you often take for granted.</p><p><strong>Prayer:</strong> Lord, wake me to the good I can do today. Free me from comparison and strengthen the habits that keep me close to you. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 11,
    "value": "<p><strong>Read:</strong> Matthew 20:1-16; Ephesians 2:8-10</p><p><strong>Source and historical context:</strong> In the parable of the laborers, Latimer challenges those who demand greater reward for longer service. He uses a sharp Reformation critique of religious merit and insists that the poor are not excluded from God’s gifts.</p><p><strong>Devotional focus:</strong> We easily turn gratitude into a comparison: why did someone else receive so much? Jesus’ parable invites us to recognize generosity without denying the real importance of fair treatment among workers. God’s grace is not a prize earned by competing against our neighbors.</p><p><strong>Reflect:</strong> Whose blessing has stirred resentment because it does not match your expectations?</p><p><strong>Practice:</strong> Thank God for one unearned gift, then congratulate someone else without adding a comparison.</p><p><strong>Prayer:</strong> Generous Father, teach me to rejoice in grace rather than count other people’s rewards. Make me fair, grateful, and glad to serve. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 12,
    "value": "<p><strong>Read:</strong> Colossians 3:23-24; 1 Corinthians 4:7</p><p><strong>Source and historical context:</strong> Latimer continues the vineyard sermon by speaking about wealth, daily work, and the equal dignity of people who serve God in different stations of life. He contrasts the world’s status rankings with the welcome of Christ.</p><p><strong>Devotional focus:</strong> The worth of a worker is not measured only in wages, prestige, or visibility. Work done with integrity and care matters, and those who labor under difficult conditions deserve respect and justice. Gratitude for what we have can turn into generosity toward those who have less.</p><p><strong>Reflect:</strong> Whose essential labor is invisible to you because of their job or social position?</p><p><strong>Practice:</strong> Thank someone for practical work and, where you have influence, support fair and humane conditions.</p><p><strong>Prayer:</strong> God who sees every person, keep me from arrogance. Let the work of my hands become a blessing and my treatment of workers be just. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 13,
    "value": "<p><strong>Read:</strong> John 1:18; John 3:16-17</p><p><strong>Source and historical context:</strong> Latimer urges hearers not to speculate about hidden decrees but to learn the Father’s character through the Son. His sermon repeatedly returns to Christ as the place to seek assurance of God’s goodwill.</p><p><strong>Devotional focus:</strong> When questions become overwhelming, the life and teaching of Jesus give us a concrete starting point: compassion, truth, the cross, and the promise of reconciliation. This does not settle every theological debate, but it prevents abstract fear from crowding out the gospel’s invitation.</p><p><strong>Reflect:</strong> What picture of God has fear painted for you, and how might Jesus’ actions challenge it?</p><p><strong>Practice:</strong> Read John 3:16–17 slowly. Write down one quality of God you see in the sending of Jesus.</p><p><strong>Prayer:</strong> Father, meet my questions through the life of your Son. Lead me from anxious speculation into trust that shapes love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 14,
    "value": "<p><strong>Read:</strong> Matthew 13:24-30; Matthew 13:36-43</p><p><strong>Source and historical context:</strong> The inherited day closes Latimer’s teaching on God’s love and then opens his sermon on the parable of the weeds among the wheat. He explains why parables use everyday images to teach difficult spiritual matters.</p><p><strong>Devotional focus:</strong> The field teaches humility about what we can see. Good and harmful actions have consequences, yet people are more complex than a quick label. Jesus warns against destructive eagerness to tear up the whole field while protecting the growing crop.</p><p><strong>Reflect:</strong> When have you decided too quickly that another person could never grow or change?</p><p><strong>Practice:</strong> Replace one sweeping judgment with a truthful description of behavior and a constructive response.</p><p><strong>Prayer:</strong> Patient God, help me recognize harm without rushing to condemn people beyond hope. Teach me wise care for what is good. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 15,
    "value": "<p><strong>Read:</strong> Matthew 13:36-43; Romans 12:19</p><p><strong>Source and historical context:</strong> Latimer interprets the weeds and harvest as images of evil and judgment. His sermon contains graphic warnings about punishment, reflecting the rhetorical conventions and convictions of his period.</p><p><strong>Devotional focus:</strong> Jesus’ explanation takes wrongdoing seriously; it does not give Christians authority to harm those they consider weeds. Final judgment belongs to God. Our work today is to protect people from harm, speak truth, practice repentance, and refuse revenge.</p><p><strong>Reflect:</strong> Where are you tempted to assume the role of final judge over someone who has wronged you?</p><p><strong>Practice:</strong> Choose one responsible boundary or act of accountability that does not rely on humiliation or retaliation.</p><p><strong>Prayer:</strong> Just Lord, defend those at risk and restrain harm. Keep me from vengeance and teach me to seek justice with mercy. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 16,
    "value": "<p><strong>Read:</strong> 2 Peter 3:9; 1 John 1:9</p><p><strong>Source and historical context:</strong> Latimer’s sermon continues with urgent calls to turn away from wrongdoing. He also argues that a living faith shows itself in a struggle against sin rather than complacent permission to cause harm.</p><p><strong>Devotional focus:</strong> Real repentance is not a performance of despair. It is a truthful turning that can include apology, repair, changed habits, and asking for help. God’s patience does not make wrongdoing harmless; it makes transformation possible.</p><p><strong>Reflect:</strong> Which repeated pattern calls for a plan to change, not merely another expression of regret?</p><p><strong>Practice:</strong> Identify one trigger, one accountability step, and one concrete repair you can make this week.</p><p><strong>Prayer:</strong> Merciful God, give me repentance that is honest and active. Help me receive forgiveness and practice a better way. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 17,
    "value": "<p><strong>Read:</strong> Matthew 5:43-48; 2 Corinthians 10:3-4</p><p><strong>Source and historical context:</strong> Latimer asks his hearers to examine how they respond to personal enemies and then argues, using the parable of the weeds, against using violence to force belief. The inherited section next introduces John Knox and his sermon on Isaiah.</p><p><strong>Devotional focus:</strong> Jesus’ call to love enemies is difficult, but it is never permission to enable abuse or ignore injustice. Faith cannot be manufactured by threats. Christians can oppose harmful acts, preserve firm boundaries, and still refuse dehumanization.</p><p><strong>Reflect:</strong> Can you reject a person’s harmful behavior without allowing resentment to define your own conduct?</p><p><strong>Practice:</strong> Pray for wisdom about a strained relationship. Choose a safe, noncoercive act of honesty or restraint.</p><p><strong>Prayer:</strong> Jesus, teach me love that is courageous rather than naïve. Help me keep necessary boundaries and refuse cruelty. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 18,
    "value": "<p><strong>Read:</strong> Isaiah 26:13-14; John 18:36</p><p><strong>Source and historical context:</strong> A historical preface introduces John Knox’s sermon preached amid conflict in the Scottish court, followed by his exposition of Isaiah’s words about other lords ruling over God’s people. The account reflects contentious sixteenth-century church and state relations.</p><p><strong>Devotional focus:</strong> People may owe practical duties to institutions, yet no earthly leader deserves the devotion owed to God. Historical polemics should not be adopted as blanket judgments on today’s religious communities. The devotional question is whether conscience remains grounded in truth and the dignity of persons.</p><p><strong>Reflect:</strong> Which demand for loyalty tempts you to compromise honesty or compassion?</p><p><strong>Practice:</strong> Consider a decision where authority and conscience intersect. Identify a peaceful, responsible way to uphold what is right.</p><p><strong>Prayer:</strong> God above every throne, free me from fear of human approval. Make my convictions truthful, humble, and peaceable. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 19,
    "value": "<p><strong>Read:</strong> Deuteronomy 17:18-20; Mark 10:42-45</p><p><strong>Source and historical context:</strong> Knox argues that power derives its legitimacy from God and that rulers should know justice and use authority for the good of people. His sermon sharply reproves negligent or self-serving leadership.</p><p><strong>Devotional focus:</strong> Authority is not self-justifying. Whether we lead a household, workplace, church, or institution, power should answer to truth, accountability, and the people affected by decisions. Jesus turns greatness toward service rather than domination.</p><p><strong>Reflect:</strong> What decision under your control needs more listening and less self-protection?</p><p><strong>Practice:</strong> Invite honest feedback from someone affected by your choices, then make one adjustment you can explain openly.</p><p><strong>Prayer:</strong> Servant King, teach all who hold power to act justly. Begin with me: make my influence a means of care rather than control. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 20,
    "value": "<p><strong>Read:</strong> Proverbs 31:8-9; Isaiah 1:17</p><p><strong>Source and historical context:</strong> Knox warns rulers that neglected duties have moral consequences. He uses examples from Israel’s history to argue that the powerful are responsible for their own choices and for harms they knowingly allow.</p><p><strong>Devotional focus:</strong> Silence can protect injustice when we have both knowledge and a realistic opportunity to help. Scripture asks for advocacy, fair judgment, and defense of the vulnerable. That responsibility calls for wisdom: speaking out should not needlessly endanger those we intend to protect.</p><p><strong>Reflect:</strong> Whose interests are missing from a decision in which you have a voice?</p><p><strong>Practice:</strong> Raise a concrete concern, document it accurately, or connect someone to responsible help using a safe channel.</p><p><strong>Prayer:</strong> God of justice, make us attentive to the unheard. Give courage to those with influence and protection to those at risk. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 21,
    "value": "<p><strong>Read:</strong> Jeremiah 22:3; Psalm 82:3-4</p><p><strong>Source and historical context:</strong> In continuing his exposition, Knox recounts how disobedience and neglect of God’s prophets damaged Israel. He uses that history as a warning to his own religious and political community.</p><p><strong>Devotional focus:</strong> Ancient judgments cannot simply be mapped onto the hardships of modern people or nations. Yet communities can learn from their failures: oppression, dishonesty, and disregard for the weak erode trust. The faithful response is to change what we can instead of searching for scapegoats.</p><p><strong>Reflect:</strong> What harmful pattern has your community normalized because it has lasted for years?</p><p><strong>Practice:</strong> Choose one modest corrective action within your reach and invite accountability from others.</p><p><strong>Prayer:</strong> Lord of truth, expose injustice without hardening our hearts. Give our communities humility to acknowledge wrong and courage to repair it. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 22,
    "value": "<p><strong>Read:</strong> Romans 12:17-21; 1 Peter 2:23</p><p><strong>Source and historical context:</strong> Knox speaks sternly about rulers who oppress and the hope of an afflicted church. His sermon describes the overthrow of tyrants in the language of divine judgment.</p><p><strong>Devotional focus:</strong> God’s opposition to oppression does not make revenge a holy calling. Paul urges believers not to repay evil with evil. We can protect people, seek legal and communal accountability, and speak against injustice without taking pleasure in another person’s suffering.</p><p><strong>Reflect:</strong> What does a just response look like when anger is justified but retaliation would cause further harm?</p><p><strong>Practice:</strong> Name the harm precisely and identify a peaceful, proportionate step toward protection or accountability.</p><p><strong>Prayer:</strong> God who knows every wrong, keep my desire for justice from becoming hatred. Help me defend others and overcome evil with good. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 23,
    "value": "<p><strong>Read:</strong> Daniel 6:16-23; Psalm 137:1-4</p><p><strong>Source and historical context:</strong> Knox turns to the exile and deliverance of God’s people, including the witness of Daniel under foreign rulers. He sees continuity between ancient exiles and Christians facing religious pressure in his time.</p><p><strong>Devotional focus:</strong> Faithfulness may require living amid institutions or cultures we do not control. The story of Daniel is not a guarantee of physical escape from every danger, but it encourages integrity, prayer, and courage. Exile and displacement also call for practical solidarity with people who have lost home or safety.</p><p><strong>Reflect:</strong> What would faithful courage look like in a setting where you feel out of place?</p><p><strong>Practice:</strong> Support someone experiencing displacement or social isolation, and practice one truthful commitment you have been tempted to hide.</p><p><strong>Prayer:</strong> God of those far from home, strengthen everyone under pressure. Give us courage to remain faithful and kindness toward the displaced. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 24,
    "value": "<p><strong>Read:</strong> Isaiah 26:16; Psalm 46:1</p><p><strong>Source and historical context:</strong> Knox describes signs of God’s care in the lives of exiles and the return from captivity, then returns to Isaiah’s line about people pouring out prayer in trouble.</p><p><strong>Devotional focus:</strong> Difficulty can expose the fragility of the things we rely on, but suffering is not proof that the sufferer is being punished. Isaiah’s prayer offers language for seeking God honestly when circumstances are beyond our control. Dependence can coexist with responsible action and community support.</p><p><strong>Reflect:</strong> When trouble comes, do you isolate yourself rather than ask for help?</p><p><strong>Practice:</strong> Pray honestly about one pressure, then contact a trustworthy person or practical resource instead of carrying it alone.</p><p><strong>Prayer:</strong> Refuge in trouble, hear our anxious voices. Lead us toward wise action, steadfast hope, and people who can help. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 25,
    "value": "<p><strong>Read:</strong> Psalm 103:13-14; Hebrews 12:5-11</p><p><strong>Source and historical context:</strong> Knox distinguishes between what he considers judgment on persistent wrongdoing and the discipline or testing of people who belong to God. He insists that trouble does not mean God has forgotten the faithful.</p><p><strong>Devotional focus:</strong> Scripture’s language of discipline needs pastoral care. We should not identify another person’s illness, loss, or persecution as punishment from God. Instead, we can seek humility in hardship and trust that compassion and correction need not be opposed.</p><p><strong>Reflect:</strong> What false conclusion about yourself or another person have you drawn simply because suffering occurred?</p><p><strong>Practice:</strong> Release one ungrounded accusation. Offer care or ask for support where hardship is present.</p><p><strong>Prayer:</strong> Compassionate Father, keep us from judging people by their pain. Guide us toward wise correction and mercy that never abandons. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 26,
    "value": "<p><strong>Read:</strong> Isaiah 26:19; 1 Corinthians 15:20-22</p><p><strong>Source and historical context:</strong> Knox turns to Isaiah’s resurrection language and argues that the hope of life beyond death sustains a community under oppression. He links confidence in God’s power to the promise that death will not have the final word.</p><p><strong>Devotional focus:</strong> Christian hope does not require pretending that mortality is easy. The New Testament places resurrection hope in Christ and invites grief to speak truthfully. We can live courageously because our lives are more than the fears that surround us.</p><p><strong>Reflect:</strong> How might resurrection hope reshape a choice you are making out of fear?</p><p><strong>Practice:</strong> Read 1 Corinthians 15:20–22 and pray for someone facing death, bereavement, or deep uncertainty.</p><p><strong>Prayer:</strong> God of life, meet us at the limits of our strength. Ground our hope in the risen Christ and make us tender toward mourners. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 27,
    "value": "<p><strong>Read:</strong> Ezekiel 37:1-14; Isaiah 26:19</p><p><strong>Source and historical context:</strong> Knox recalls Ezekiel’s vision of dry bones to explain how God can restore a people who believe they are forgotten. He reads the image alongside Isaiah’s declaration that the dead shall live.</p><p><strong>Devotional focus:</strong> Ezekiel’s vision first speaks hope to a devastated community. It should not be used as an easy promise that every loss will quickly reverse. Still, it tells exhausted people that their apparent end does not exhaust God’s possibilities. Renewal may begin with truthful lament and the smallest return of courage.</p><p><strong>Reflect:</strong> Where have you called a situation hopeless before allowing room for help or patient restoration?</p><p><strong>Practice:</strong> Take one realistic step toward rebuilding a relationship, practice, or support system that has been neglected.</p><p><strong>Prayer:</strong> Breath of God, visit the weary and the forgotten. Where hope seems spent, create room for courage, help, and new life. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 28,
    "value": "<p><strong>Read:</strong> 1 Corinthians 15:35-44; John 12:24</p><p><strong>Source and historical context:</strong> Knox appeals to Paul’s comparison of a seed placed in the earth and life raised beyond what can be seen. He connects the pattern of growth to trust in God’s power to raise the dead.</p><p><strong>Devotional focus:</strong> A seed is an image of transformation, not a scientific explanation of resurrection or a reason to dismiss loss. Paul’s teaching points beyond what present experience can measure. Christians may admit mystery while trusting the God who brings life and gives dignity to bodies and creation.</p><p><strong>Reflect:</strong> Can you hold faith and unanswered questions together without demanding false certainty?</p><p><strong>Practice:</strong> Plant or tend something living as an act of gratitude. Pray for patience with what you cannot yet understand.</p><p><strong>Prayer:</strong> Creator and giver of life, teach me wonder without careless certainty. Strengthen my hope while I honor the world you have made. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 29,
    "value": "<p><strong>Read:</strong> Isaiah 26:20; Psalm 91:1-2</p><p><strong>Source and historical context:</strong> Knox interprets Isaiah’s invitation to enter a chamber until danger passes as an image of refuge in God’s promises. He addresses a community fearful of persecution and uncertain about its future.</p><p><strong>Devotional focus:</strong> Seeking refuge in God is not a command to ignore physical danger or to remain in an unsafe place. Prayer, wise planning, and community protection can belong together. Scripture offers spiritual shelter that can sustain courage while people seek real safety.</p><p><strong>Reflect:</strong> Where do you need both inner steadiness and an outward plan for protection?</p><p><strong>Practice:</strong> Identify one safe person, practical support, or protective step relevant to a worry you face, then bring it into prayer.</p><p><strong>Prayer:</strong> Sheltering God, sustain those exposed to harm. Lead us toward safety, truthful counsel, and confidence that we are not alone. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 30,
    "value": "<p><strong>Read:</strong> Isaiah 26:21; Genesis 4:10</p><p><strong>Source and historical context:</strong> Knox describes God bringing hidden bloodshed into the light and calls violent rulers to account. He uses forceful images to insist that crimes concealed by power are not concealed from God.</p><p><strong>Devotional focus:</strong> Victims of violence deserve to be believed, protected, and treated with dignity. Biblical language about blood crying out is a summons to truth and justice, not permission for vigilantism or for naming every hardship divine revenge. Hidden harm calls for careful reporting and protection.</p><p><strong>Reflect:</strong> Whose suffering has been concealed because acknowledging it would be inconvenient for the powerful?</p><p><strong>Practice:</strong> If safe, support trustworthy accountability and trauma-aware care. Avoid rumors and protect confidential information.</p><p><strong>Prayer:</strong> God who hears the unheard, bring hidden wrong into truth. Protect the vulnerable and guide us toward justice without retaliation. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 31,
    "value": "<p><strong>Read:</strong> Romans 12:19-21; Revelation 21:4</p><p><strong>Source and historical context:</strong> Knox continues his warning about the blood of the innocent and offers consolation to believers harmed by persecution. His sermon is severe toward those who use power for cruelty.</p><p><strong>Devotional focus:</strong> A just world cannot be built through indifference, but neither can it be built by cultivating delight in revenge. We can pursue protection, truth, and proportionate accountability while leaving ultimate judgment to God. The promise of a world without tears helps us care for those whose wounds are still present.</p><p><strong>Reflect:</strong> What would change if you made restoration and protection more central than punishment?</p><p><strong>Practice:</strong> Pray for people harmed by violence and support a constructive, nonviolent response you can responsibly take.</p><p><strong>Prayer:</strong> Judge of all the earth, comfort those who have been hurt. Give us courage for justice, restraint in anger, and hope beyond sorrow. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 32,
    "value": "<p><strong>Read:</strong> Matthew 14:22-33; Isaiah 41:10</p><p><strong>Source and historical context:</strong> The final inherited section ends Knox’s sermon with prayer and moves into an extract from his Admonition to England. Taking Jesus’ words to frightened disciples as its theme, the extract recalls God’s promises to Abraham, Jacob, and Moses amid danger.</p><p><strong>Devotional focus:</strong> God’s presence does not mean storms disappear on command. Christ’s reassurance invites trust while the disciples remain in a fragile boat. Knox uses this theme to encourage threatened believers; we can hear it as an invitation to seek God’s help, act wisely, and stand alongside those in distress.</p><p><strong>Reflect:</strong> What frightening situation needs a response of faith joined with thoughtful action?</p><p><strong>Practice:</strong> Write a short prayer naming your fear, then choose one practical next step and one person who can support you.</p><p><strong>Prayer:</strong> Jesus, meet us in the storm. Give us courage to face what is real, wisdom to seek help, and grace to offer your peace to others. Amen.</p>"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;


-- Only update plan-level Scripture references (user_id IS NULL); preserve user-created entries.
do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 1,
    "references": [
      "Revelation 2:4-5",
      "Revelation 3:1-3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 2,
    "references": [
      "Revelation 7:13-17",
      "1 Peter 5:8-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 3,
    "references": [
      "Revelation 14:6-7",
      "Psalm 95:1-7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 4,
    "references": [
      "Hebrews 4:14-16",
      "Revelation 20:11-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 5,
    "references": [
      "Revelation 4:9-11",
      "Philippians 2:9-11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 6,
    "references": [
      "Genesis 18:25",
      "2 Corinthians 5:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 7,
    "references": [
      "Luke 21:33",
      "Matthew 25:31-40"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 8,
    "references": [
      "1 John 1:8-9",
      "Hebrews 4:16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 9,
    "references": [
      "1 Thessalonians 4:13-18",
      "Luke 21:27-28"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 10,
    "references": [
      "Luke 21:34-36",
      "Matthew 20:1-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 11,
    "references": [
      "Matthew 20:1-16",
      "Ephesians 2:8-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 12,
    "references": [
      "Colossians 3:23-24",
      "1 Corinthians 4:7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 13,
    "references": [
      "John 1:18",
      "John 3:16-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 14,
    "references": [
      "Matthew 13:24-30",
      "Matthew 13:36-43"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 15,
    "references": [
      "Matthew 13:36-43",
      "Romans 12:19"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 16,
    "references": [
      "2 Peter 3:9",
      "1 John 1:9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 17,
    "references": [
      "Matthew 5:43-48",
      "2 Corinthians 10:3-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 18,
    "references": [
      "Isaiah 26:13-14",
      "John 18:36"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 19,
    "references": [
      "Deuteronomy 17:18-20",
      "Mark 10:42-45"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 20,
    "references": [
      "Proverbs 31:8-9",
      "Isaiah 1:17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 21,
    "references": [
      "Jeremiah 22:3",
      "Psalm 82:3-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 22,
    "references": [
      "Romans 12:17-21",
      "1 Peter 2:23"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 23,
    "references": [
      "Daniel 6:16-23",
      "Psalm 137:1-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 24,
    "references": [
      "Isaiah 26:16",
      "Psalm 46:1"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 25,
    "references": [
      "Psalm 103:13-14",
      "Hebrews 12:5-11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 26,
    "references": [
      "Isaiah 26:19",
      "1 Corinthians 15:20-22"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 27,
    "references": [
      "Ezekiel 37:1-14",
      "Isaiah 26:19"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 28,
    "references": [
      "1 Corinthians 15:35-44",
      "John 12:24"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 29,
    "references": [
      "Isaiah 26:20",
      "Psalm 91:1-2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 30,
    "references": [
      "Isaiah 26:21",
      "Genesis 4:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 31,
    "references": [
      "Romans 12:19-21",
      "Revelation 21:4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000284",
    "day_number": 32,
    "references": [
      "Matthew 14:22-33",
      "Isaiah 41:10"
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

-- Publish the reviewed, contextualized adaptation.
update public.devotional_plans
set status = 'published', updated_at = now()
where id = '90000000-0000-0000-0000-000000000284'::uuid;

commit;
