-- Scripture-led adaptation of Martin Luther's 1520 letter and Concerning Christian Liberty.
-- Plan 268: preserve existing 18 day IDs/numbers and user progress.
-- New prose is explicitly editorial, not quotations from Luther.
-- Luther's Reformation positions and anti-Catholic polemics are handled as historical context.
-- Reviewed for devotional suitability and approved for publication.

begin;

-- Guard the plan structure before making any changes.
do $$
declare
  present_days integer;
  first_day integer;
  last_day integer;
  source_link text;
  reported_total integer;
begin
  select source_url, total_days into source_link, reported_total
  from public.devotional_plans
  where id = '90000000-0000-0000-0000-000000000268'::uuid;
  if not found then
    raise exception 'Plan 268 is missing';
  end if;
  if source_link is distinct from 'https://www.gutenberg.org/ebooks/1911' or reported_total is distinct from 18 then
    raise exception 'Plan 268 source URL or total_days differs from the reviewed source';
  end if;
  select count(*), min(day_number), max(day_number)
  into present_days, first_day, last_day
  from public.devotional_days
  where plan_id = '90000000-0000-0000-0000-000000000268'::uuid;
  if present_days <> 18 or first_day <> 1 or last_day <> 18 then
    raise exception 'Plan 268 must have exactly 18 numbered days, found %', present_days;
  end if;
end
$$;


update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-26 06:45:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "value": "Christian Freedom and Neighborly Love: Eighteen Readings from Martin Luther"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-26 06:45:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "value": "Eighteen Scripture-led devotional readings adapted from Martin Luther’s 1520 letter to Pope Leo X and his treatise Concerning Christian Liberty. The first four readings consider truthfulness, conflict, peacemaking, and the transition from Luther’s historical letter to his account of Christian freedom; the remaining fourteen follow the treatise’s movement from faith in Christ and God’s promises to freely serving neighbors in love. These are newly written editorial paraphrases, reflections, and prayers—not quotations from Luther or an endorsement of his anti-Catholic polemic. Luther’s argument for justification by faith is identified as his Reformation teaching; Christian traditions continue to describe the relationship of faith, grace, sacraments, and good works differently. Scripture references are selected devotional anchors rather than citations attributed to Luther. The full historical text remains available through the source link."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-26 06:45:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 1,
    "value": "Speak Truth with Care"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 2,
    "value": "Pray Across Deep Disagreement"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 3,
    "value": "Seek Peace without Surrendering Truth"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 4,
    "value": "Free in Christ, Ready to Serve"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 5,
    "value": "The Word That Gives Life"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 6,
    "value": "Receive the Promise of Grace"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 7,
    "value": "Trust the God Who Keeps Promises"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 8,
    "value": "Christ Bears Our Need"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 9,
    "value": "A People Called to Prayer and Service"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 10,
    "value": "Faith in the Living Christ"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 11,
    "value": "Practice the Life Grace Has Given"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 12,
    "value": "Good Fruit Grows from Grace"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 13,
    "value": "Grace Turns Us Toward Others"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 14,
    "value": "Love without Keeping Score"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 15,
    "value": "Use Freedom with Wisdom"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 16,
    "value": "Let Gifts Flow to Your Neighbor"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 17,
    "value": "Hold Conviction with Tenderness"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 18,
    "value": "Build a Life, Not a Scaffold"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-26 06:45:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 1,
    "value": "<p><strong>Read:</strong> Ephesians 4:15; Matthew 7:3-5.</p><p><strong>Source and historical context:</strong> In his 1520 letter to Pope Leo X, Martin Luther says he wishes Leo well while sharply criticizing the Roman court. The accusations and rhetoric belong to a particular Reformation controversy, not to this devotional’s instruction about another Christian community.</p><p><strong>Devotional focus:</strong> Truth and love belong together. We may name a real wrong without delighting in humiliation or pretending to know another person’s heart. Christ calls us to examine ourselves as carefully as we examine others.</p><p><strong>Reflect:</strong> When you disagree with someone, do you aim to protect what is true and good, or to win the argument? Describe the concern accurately, admit what you do not know, and choose words that preserve the other person’s dignity.</p><p><strong>Prayer:</strong> Lord Jesus, make my speech truthful and gracious. Expose pride in me, strengthen my courage to confront harm, and keep me from turning disagreement into contempt. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 2,
    "value": "<p><strong>Read:</strong> Matthew 5:43-48; 1 Timothy 2:1-2.</p><p><strong>Source and historical context:</strong> Luther’s letter depicts Leo as surrounded by advisers whom Luther considers corrupt and describes the Roman court with severe accusations. This records Luther’s position in 1520; the devotion does not adopt his judgments about Catholics as a group.</p><p><strong>Devotional focus:</strong> Prayer need not wait for agreement. Jesus calls his followers to pray even for opponents. Such prayer does not excuse injustice; it entrusts people and institutions to God’s judgment while seeking their true good.</p><p><strong>Reflect:</strong> Name a person or community with whom you disagree. What would a prayer for their safety, wisdom, honesty, and peace sound like if it included no insult and did not require you to abandon your convictions?</p><p><strong>Prayer:</strong> Father of mercy, grant wisdom to leaders and kindness to those divided by conflict. Teach us to resist wrongdoing while desiring healing, truth, and justice for everyone concerned. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 3,
    "value": "<p><strong>Read:</strong> Matthew 5:9; James 3:17-18.</p><p><strong>Source and historical context:</strong> In a later section of the letter, Luther recounts disputed negotiations and says he would welcome peace but cannot surrender what he understands as the word of God. The accusations against named opponents are his historical account, not settled judgments offered here.</p><p><strong>Devotional focus:</strong> Peacemaking is more than silence, and conviction is more than stubbornness. Wisdom listens, makes room for correction, and seeks just reconciliation without requiring the vulnerable to accept harm.</p><p><strong>Reflect:</strong> Think of a strained conversation. What is the central issue that must be addressed? What accusation or distraction could you set aside, and what honest invitation to dialogue could you make?</p><p><strong>Prayer:</strong> God of peace and truth, free me from vanity and needless quarrels. Give me humility to listen, courage to speak rightly, and patience to work for a just peace. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 4,
    "value": "<p><strong>Read:</strong> 1 Corinthians 9:19; Galatians 5:13.</p><p><strong>Source and historical context:</strong> Luther closes his letter to Leo and begins Concerning Christian Liberty by placing freedom and service side by side. He states a deliberate paradox: the Christian is free before God and yet willingly becomes a servant to others.</p><p><strong>Devotional focus:</strong> Freedom in Christ is not permission to ignore people. Receiving grace releases us from proving our worth through superiority and opens our hands for loving service. Freedom and responsibility are not enemies.</p><p><strong>Reflect:</strong> Where do you treat independence as an excuse to avoid another person’s need? Choose one unforced act of care that can express freedom rather than obligation or a desire for praise.</p><p><strong>Prayer:</strong> Lord Jesus, teach me the freedom that comes from your grace. Let my confidence in you make me generous, humble, and ready to serve. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 5,
    "value": "<p><strong>Read:</strong> John 8:31-36; Romans 10:8-10.</p><p><strong>Source and historical context:</strong> At the opening of the treatise, Luther distinguishes outward religious activities from the inward trust formed by the gospel. He centers the message on Jesus Christ, incarnate, crucified, risen, and proclaimed through the Spirit.</p><p><strong>Devotional focus:</strong> Religious activity can be meaningful, but no impressive appearance substitutes for meeting Christ in faith. Scripture directs us to the Son who makes people free, not toward confidence in status or display.</p><p><strong>Reflect:</strong> Are you relying on religious knowledge, routines, or reputation to avoid honest trust in God? Read today’s Gospel passage slowly and name the promise of Christ you most need to receive.</p><p><strong>Prayer:</strong> Living Word, draw me beyond appearances into genuine trust. Let the gospel of your death and resurrection renew my mind, my hope, and my love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 6,
    "value": "<p><strong>Read:</strong> Romans 3:21-26; Ephesians 2:8-10.</p><p><strong>Source and historical context:</strong> Luther explains the distinction between God’s commands, which expose human need, and God’s promises, which announce grace in Christ. His account of justification through faith alone is a distinct Reformation emphasis; Christians articulate its relationship to sacramental life and good works differently.</p><p><strong>Devotional focus:</strong> God’s commands reveal the goodness to which we are called, but the gospel also tells of mercy for people who fall short. Repentance can be truthful without becoming despair, because the crucified and risen Christ is the center of Christian hope.</p><p><strong>Reflect:</strong> Where has awareness of failure turned into hopelessness or frantic attempts to earn approval? Confess what needs changing, then receive the promise of mercy and take one faithful step forward.</p><p><strong>Prayer:</strong> Merciful Father, I cannot repair myself by boasting or bargaining. Lead me to repentance, draw me to Christ, and form in me the good works of grateful love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 7,
    "value": "<p><strong>Read:</strong> John 1:12-13; Romans 4:20-22.</p><p><strong>Source and historical context:</strong> Luther likens faith’s reception of God’s word to metal taking on the warmth of fire. He also says that trusting God honors God as truthful and pictures communion with Christ through a marriage image.</p><p><strong>Devotional focus:</strong> Faith rests on God’s character rather than on the intensity of our feelings. God’s promises invite dependence, not self-congratulation. Union with Christ is the gift that grounds our belonging.</p><p><strong>Reflect:</strong> Which promise of God do you find hardest to trust today? Say why without hiding your doubt. Return to the life of Jesus and ask what his faithfulness reveals about the Father.</p><p><strong>Prayer:</strong> Faithful God, when my trust is weak, hold me near to Christ. Teach me to receive your word with humility, confidence, and obedience born of love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 8,
    "value": "<p><strong>Read:</strong> 2 Corinthians 5:17-21; 1 Corinthians 15:54-57.</p><p><strong>Source and historical context:</strong> Using a marriage metaphor, Luther describes Christ sharing the believer’s burden and giving the believer a share in his life and righteousness. The historical passage uses harsh imagery for the soul; this reading keeps the central grace theme without repeating degrading language.</p><p><strong>Devotional focus:</strong> Jesus does not stand far off from human sin and suffering. By his death and resurrection, he opens the way to reconciliation with God. Christian hope rests on Christ’s victory, not on pretending we have no need of mercy.</p><p><strong>Reflect:</strong> What guilt, fear, or grief are you carrying alone? Bring it honestly before Christ. If another person has been harmed, let receiving forgiveness move you toward appropriate confession and repair.</p><p><strong>Prayer:</strong> Risen Lord, thank you for meeting us with mercy and new life. Help me trust your saving work, turn from sin, and act justly toward those I have hurt. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 9,
    "value": "<p><strong>Read:</strong> 1 Peter 2:9-10; Hebrews 4:14-16.</p><p><strong>Source and historical context:</strong> Luther develops the language of believers sharing in Christ’s royal priesthood. He contrasts spiritual dignity with worldly power and argues that ministers are called to serve rather than dominate.</p><p><strong>Devotional focus:</strong> Belonging to Christ brings the privilege of approaching God and the responsibility of caring for others. Spiritual dignity does not confer control over neighbors or guarantee freedom from pain; it calls us toward prayer, humility, and witness.</p><p><strong>Reflect:</strong> Whose voice has been overlooked because of age, status, or position? Honor that person’s dignity today, and pray for someone whose burden you cannot carry alone.</p><p><strong>Prayer:</strong> Great High Priest, open our hearts to your mercy. Keep our churches from pride and teach every member to pray, speak truth, and serve in love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 10,
    "value": "<p><strong>Read:</strong> 1 Corinthians 15:54-57; Romans 8:22-25.</p><p><strong>Source and historical context:</strong> After discussing the dignity of believers, Luther insists that preaching should explain what Christ has done for them, rather than offer only historical facts or rules. He then moves from inward faith to the outward life of loving action.</p><p><strong>Devotional focus:</strong> The Christian message is not merely an admired biography. Christ’s resurrection gives living hope while we still wait, struggle, and grieve. Grace sends us back into ordinary life with purpose.</p><p><strong>Reflect:</strong> Does your understanding of Jesus remain distant information, or does it shape how you face fear and serve others? Name one way the resurrection can change your response to today’s difficulty.</p><p><strong>Prayer:</strong> Lord Jesus, make your life, death, and resurrection more than facts I repeat. Renew my hope and let gratitude become faithful action. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 11,
    "value": "<p><strong>Read:</strong> Galatians 5:22-25; Genesis 2:15.</p><p><strong>Source and historical context:</strong> Luther argues that bodily discipline and honest work follow faith; they do not purchase acceptance with God. He uses the image of Adam tending the garden and warns against severe practices that damage a person’s health.</p><p><strong>Devotional focus:</strong> Prayer, fasting, rest, and work can train our attention toward God and our neighbors. Their value is not measured by how much pain we can endure, but by the love, self-control, and faithfulness they help cultivate.</p><p><strong>Reflect:</strong> Which habit strengthens your service, and which habit has become a contest for approval? Choose one sustainable practice today that builds patience and care without harming your body.</p><p><strong>Prayer:</strong> Holy Spirit, grow your fruit in my daily habits. Give me discipline without harshness, work without vanity, and rest without guilt. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 12,
    "value": "<p><strong>Read:</strong> Matthew 7:16-20; Titus 3:4-8.</p><p><strong>Source and historical context:</strong> Luther says a healthy tree produces good fruit, rather than fruit creating the tree. He applies the illustration to the relation between faith, grace, and good works, rejecting the idea that actions can be used to demand salvation as wages.</p><p><strong>Devotional focus:</strong> Good works matter deeply because neighbors need them. Yet they are not bargaining chips used to secure God’s love. Grace changes what we trust and why we act, so that mercy becomes visible in everyday conduct.</p><p><strong>Reflect:</strong> If no one noticed your efforts, which acts of kindness would you still do? Choose one practical good work for someone who cannot repay you.</p><p><strong>Prayer:</strong> God of mercy, plant in me trust that bears good fruit. Free my service from boasting, and make my actions useful to those around me. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 13,
    "value": "<p><strong>Read:</strong> Romans 14:7-8; Philippians 2:1-4.</p><p><strong>Source and historical context:</strong> Luther warns that the call to repentance must be followed by the promise of forgiveness. He then turns to neighborly service: believers do not live for themselves alone, and work can provide resources to share with people in need.</p><p><strong>Devotional focus:</strong> The gospel binds truth and mercy together. God does not awaken conscience simply to leave people in shame; receiving grace can free us to notice the needs of people we might otherwise pass by.</p><p><strong>Reflect:</strong> Where have you concentrated on your own spiritual performance while overlooking a practical need nearby? Offer time, listening, food, or another fitting form of support today.</p><p><strong>Prayer:</strong> Compassionate Father, bring me honestly to repentance and gently to hope. Open my eyes to my neighbors and show me how to serve them wisely. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 14,
    "value": "<p><strong>Read:</strong> Philippians 2:5-8; Galatians 2:20.</p><p><strong>Source and historical context:</strong> Luther describes love flowing from the generosity received in Christ. He points to Jesus humbling himself for others and urges believers to help neighbors without calculating gratitude, praise, or advantage.</p><p><strong>Devotional focus:</strong> Christ’s self-giving love sets the pattern for discipleship. We are not called to become saviors of other people, but to reflect the Savior’s compassion in relationships shaped by humility, justice, and freely given care.</p><p><strong>Reflect:</strong> When you help, do you secretly expect recognition or repayment? Choose a kindness that protects another person’s dignity and respects healthy boundaries.</p><p><strong>Prayer:</strong> Lord Jesus, you served us in love. Free me from keeping score, and teach me to give generously with wisdom and joy. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 15,
    "value": "<p><strong>Read:</strong> Romans 14:13-19; Matthew 17:24-27.</p><p><strong>Source and historical context:</strong> Luther compares Paul’s choices about Timothy and Titus and Jesus’ payment of the temple tax. He argues that Christians may voluntarily yield in secondary matters for another’s good without treating those practices as a way to earn salvation.</p><p><strong>Devotional focus:</strong> Not every right needs to be exercised at every moment. Mature freedom weighs the effect of our choices on others while refusing demands that require wrongdoing or suppress conscience.</p><p><strong>Reflect:</strong> Is there a preference you could set aside to preserve peace or help someone learn? Equally, is there a boundary you must keep because yielding would permit harm?</p><p><strong>Prayer:</strong> God of wisdom, guard me from selfish insistence and fearful compliance. Help me use freedom truthfully and lovingly. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 16,
    "value": "<p><strong>Read:</strong> Galatians 5:13-14; Romans 14:3.</p><p><strong>Source and historical context:</strong> Near the treatise’s conclusion, Luther says that God’s gifts should move through believers toward other people. He also warns against judging Christians merely because they practice outward traditions differently.</p><p><strong>Devotional focus:</strong> The test of our freedom is not the ability to win religious arguments; it is the willingness to love. Faith receives from Christ, and neighborly service makes that love tangible without asking others to carry our pride.</p><p><strong>Reflect:</strong> Who needs something that is within your capacity to share—attention, skill, food, encouragement, or honest advocacy? Offer what is helpful and listen to what the person actually needs.</p><p><strong>Prayer:</strong> Generous God, every good gift is yours. Make me openhanded and teach me to love neighbors without judging their worth by my preferences. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 17,
    "value": "<p><strong>Read:</strong> 1 Corinthians 8:9-13; Romans 14:19-22.</p><p><strong>Source and historical context:</strong> Luther distinguishes firm opposition to imposed religious requirements from patience with people who are unsure or vulnerable. His labels for opponents are products of controversy; this devotional applies the pastoral concern without repeating insults.</p><p><strong>Devotional focus:</strong> Courage and gentleness are not rivals. We can challenge coercion while refusing to mock people who have been taught differently. Love listens and works patiently toward truth.</p><p><strong>Reflect:</strong> Are you tempted to ridicule someone’s tradition, or to remain silent when another person is pressured? Choose a response that protects conscience and welcomes careful conversation.</p><p><strong>Prayer:</strong> Holy Spirit, give me conviction without cruelty and gentleness without dishonesty. Help me defend the vulnerable and honor those with whom I disagree. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 18,
    "value": "<p><strong>Read:</strong> Jeremiah 31:33-34; 2 Timothy 3:5-7.</p><p><strong>Source and historical context:</strong> Luther closes with the picture of scaffolding needed during construction but not itself the finished building. Religious practices can be useful, he argues, but they should not replace trust in Christ and an inwardly renewed life.</p><p><strong>Devotional focus:</strong> Habits, traditions, and structures can help form disciples, but the goal is life in God’s truth and love. Rather than praising our own spiritual achievements, we ask God to write his ways on our hearts and to make mercy visible.</p><p><strong>Reflect:</strong> Which useful practice has become an end in itself for you? Keep what supports love, loosen what creates pride, and identify one relationship in which renewed faith can become renewed care.</p><p><strong>Prayer:</strong> Faithful God, write your teaching upon my heart. Let every good practice point toward Christ, deepen love, and strengthen service to others. Amen.</p>"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

-- Replace the plan's global Scripture anchors without touching user-specific notes.
do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 1,
    "references": [
      "Ephesians 4:15",
      "Matthew 7:3-5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 2,
    "references": [
      "Matthew 5:43-48",
      "1 Timothy 2:1-2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 3,
    "references": [
      "Matthew 5:9",
      "James 3:17-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 4,
    "references": [
      "1 Corinthians 9:19",
      "Galatians 5:13"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 5,
    "references": [
      "John 8:31-36",
      "Romans 10:8-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 6,
    "references": [
      "Romans 3:21-26",
      "Ephesians 2:8-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 7,
    "references": [
      "John 1:12-13",
      "Romans 4:20-22"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 8,
    "references": [
      "2 Corinthians 5:17-21",
      "1 Corinthians 15:54-57"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 9,
    "references": [
      "1 Peter 2:9-10",
      "Hebrews 4:14-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 10,
    "references": [
      "1 Corinthians 15:54-57",
      "Romans 8:22-25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 11,
    "references": [
      "Galatians 5:22-25",
      "Genesis 2:15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 12,
    "references": [
      "Matthew 7:16-20",
      "Titus 3:4-8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 13,
    "references": [
      "Romans 14:7-8",
      "Philippians 2:1-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 14,
    "references": [
      "Philippians 2:5-8",
      "Galatians 2:20"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 15,
    "references": [
      "Romans 14:13-19",
      "Matthew 17:24-27"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 16,
    "references": [
      "Galatians 5:13-14",
      "Romans 14:3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 17,
    "references": [
      "1 Corinthians 8:9-13",
      "Romans 14:19-22"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000268",
    "day_number": 18,
    "references": [
      "Jeremiah 31:33-34",
      "2 Timothy 3:5-7"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid
      and day_number = (item ->> 'day_number')::integer;

    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-26 06:45:00+00'
    where day_id = target_day_id and user_id is null;

    if not found then
      insert into public.scripture_references
      (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id,
              array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-26 06:45:00+00', timestamptz '2026-10-26 06:45:00+00');
    end if;
  end loop;
end
$$;

-- Publish the reviewed, contextualized adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-26 06:45:00+00'
where id = '90000000-0000-0000-0000-000000000268'::uuid;

commit;
