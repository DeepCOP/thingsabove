-- Wave 31: Plan 362 — Gloria Crucis, J. H. Beibitz (addresses 1907, published 1908).
-- Thirty original Scripture-led thematic readings, not verbatim sermon transcripts.
-- Beibitz's atonement arguments are historically contextualized, not presented as
-- universal doctrinal consensus. Preserve existing plan/day IDs, counts, metadata,
-- progress and any user-owned Scripture references.
-- Apply AFTER October 21 language modernization, particularly part 12, which edits
-- existing Plan 362 day contents. Do not reapply that modernization afterward.
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
  from public.devotional_plans where id = '90000000-0000-0000-0000-000000000362'::uuid;
  if not found then raise exception 'Plan 362 missing'; end if;
  if current_source is distinct from 'https://www.gutenberg.org/ebooks/24153' or current_total is distinct from 30 then
    raise exception 'Plan 362 source URL or total days differs from Wave 31 review';
  end if;
  select count(*), min(day_number), max(day_number), count(distinct day_number)
  into day_count, first_day, last_day, unique_days
  from public.devotional_days where plan_id = '90000000-0000-0000-0000-000000000362'::uuid;
  if day_count <> 30 or first_day <> 1 or last_day <> 30 or unique_days <> 30 then
    raise exception 'Plan 362 must contain 30 distinct numbered days; found %', day_count;
  end if;
  select count(*) into duplicates from (
     select sr.day_id
     from public.scripture_references sr
     join public.devotional_days d on d.id = sr.day_id
     where d.plan_id = '90000000-0000-0000-0000-000000000362'::uuid and sr.user_id is null
     group by sr.day_id having count(*) > 1
  ) duplicates_per_day;
  if duplicates > 0 then
    raise exception 'Plan 362 has % days with duplicate plan-level Scripture-reference rows', duplicates;
  end if;
end
$$;

update public.devotional_plans as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "value": "The Glory of the Cross: 30 Readings on Love, Repentance, and Hope"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "value": "Thirty Scripture-led devotional readings inspired by J. H. Beibitz’s Gloria Crucis, delivered during Holy Week and Good Friday at Lichfield Cathedral in 1907. Reflect on the Cross, conscience, the meaning of sin, repentance, grace, sacrificial love, the Seven Last Words of Jesus, and resurrection hope. Each reading includes historical and theological context, a reflection, a practical response, and prayer. Beibitz’s distinctive atonement arguments are presented as his interpretation, not the settled view of all Christian traditions; the devotions focus on mercy, truthful change, and compassionate service."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 1,
    "value": "The Cross and the Healing of Our Hearts"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 2,
    "value": "Justice, Mercy, and Honest Questions"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 3,
    "value": "A Mystery Greater Than Any Theory"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 4,
    "value": "Conscience and the Nearness of God"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 5,
    "value": "The Cross Within Real History"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 6,
    "value": "A Living Faith Must Love People"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 7,
    "value": "Sin Matters, but Pain Is Not a Verdict"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 8,
    "value": "Learning from Experience and Conscience"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 9,
    "value": "Reading Genesis with Care"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 10,
    "value": "Good Desires Need Wise Direction"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 11,
    "value": "Human Dignity and Moral Responsibility"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 12,
    "value": "Love Looks Toward Another’s Good"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 13,
    "value": "When Wrongdoing Damages Fellowship"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 14,
    "value": "Repentance Means a Changed Direction"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 15,
    "value": "Grace Gives Us Strength to Grow"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 16,
    "value": "Obedience Is the Shape of Love"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 17,
    "value": "Grace Is Offered, Faith Responds"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 18,
    "value": "God Meets Us in Embodied Life"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 19,
    "value": "Sacrifice and the Gift of Communion"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 20,
    "value": "The Cross Calls Us Into Service"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 21,
    "value": "Learning Christ in the Seven Last Words"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 22,
    "value": "Forgiveness Without Denying Harm"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 23,
    "value": "Grace for the One Who Turns to Christ"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 24,
    "value": "Love Begins with Those Near Us"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 25,
    "value": "When Jesus Cried Out in Anguish"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 26,
    "value": "The Humanity of Christ in “I Thirst”"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 27,
    "value": "Compassion in the Shadow of the Cross"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 28,
    "value": "“It Is Finished”: Faithful Love Endures"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 29,
    "value": "Entrusting Life and Death to God"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 30,
    "value": "Easter Hope for a Changed Life"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 1,
    "value": "<p><strong>Read:</strong> Galatians 6:14; 2 Corinthians 5:18-19</p><p><strong>Source and historical context:</strong> The opening of J. H. Beibitz’s Holy Week addresses, delivered at Lichfield Cathedral in 1907 and published in 1908, questions accounts of the atonement framed as a bargain between Father and Son. He argues that Christ comes to heal the alienation of sin and restore fellowship with God.</p><p><strong>Devotional focus:</strong> The cross is not a puzzle to master before we can receive love. Paul points to God reconciling the world in Christ. Different Christian traditions describe the mystery of atonement differently; these addresses especially invite us to notice the restoration Christ begins within us. Grace is not an excuse to disregard harm. It opens a way to confession, trust, and change.</p><p><strong>Reflect:</strong> When I think of the cross, do I first imagine punishment, distant theology, or God drawing near?</p><p><strong>Practice:</strong> Read Galatians 6:14 slowly. Name one relationship or habit in which you long for reconciliation.</p><p><strong>Prayer:</strong> God of reconciling love, help me see Jesus clearly and welcome the renewal his cross makes possible. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 2,
    "value": "<p><strong>Read:</strong> Romans 3:21-26; 1 John 4:9-10</p><p><strong>Source and historical context:</strong> Beibitz challenges a popular picture of the Father directing vengeance at an innocent Son. He names problems of justice, ethical transformation, and the unity of God. These are his objections to particular atonement explanations, not a neutral summary of every Christian tradition.</p><p><strong>Devotional focus:</strong> Serious questions about the cross need not be treated as disloyalty. Scripture speaks both of God’s justice and of love revealed through Jesus. It is possible to listen carefully when Christians disagree over how those truths fit together. What should remain visible in our discussion is the character of Christ: one who refuses to abandon sinners and calls them into a different life.</p><p><strong>Reflect:</strong> Can I discuss a difficult doctrine without belittling the faith or intelligence of another believer?</p><p><strong>Practice:</strong> Write one genuine question about the cross. Explore a Scripture passage before rushing to win an argument.</p><p><strong>Prayer:</strong> Holy God, make my searching humble, my speech fair, and my trust anchored in your love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 3,
    "value": "<p><strong>Read:</strong> 1 Corinthians 1:18-25; Ephesians 3:16-19</p><p><strong>Source and historical context:</strong> After criticizing one theory of atonement, Beibitz argues that no single theological model exhausts the meaning of the cross. He connects Christ’s death with questions about human existence and the moral direction of the world.</p><p><strong>Devotional focus:</strong> The gospel is deeper than a slogan. We can learn from faithful thinkers of earlier centuries without imagining our own vocabulary settles everything. Paul calls the cross God’s wisdom even when human expectations are overturned. That does not forbid patient reasoning; it invites reasoning joined to reverence, knowing that Christ’s love exceeds the limits of our explanations.</p><p><strong>Reflect:</strong> Which familiar explanation have I treated as though it were larger than Christ himself?</p><p><strong>Practice:</strong> Read the passages and write one thing you know, one thing you wonder, and one thing you can live out today.</p><p><strong>Prayer:</strong> Lord Jesus, enlarge my understanding without allowing certainty to harden into pride. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 4,
    "value": "<p><strong>Read:</strong> Romans 2:14-16; Acts 17:24-28</p><p><strong>Source and historical context:</strong> In this section Beibitz reflects on the human sense that righteousness matters, then describes God as present to creation rather than an isolated being far away. He understands sin as alienation from the divine life that gives human relationships their unity.</p><p><strong>Devotional focus:</strong> Conscience can awaken us to what is good, yet conscience itself needs education and correction. Paul says we live and move in God, not beyond God’s notice or reach. Instead of using divine nearness to deny wrongdoing, we can let it call us to honesty: our choices touch both our inner lives and the people around us. The cross opens a path toward restored fellowship.</p><p><strong>Reflect:</strong> Where has my conscience been warning me about a choice that harms another person?</p><p><strong>Practice:</strong> Make one quiet examination of conscience. Seek advice if a situation is complex, then take a truthful next step.</p><p><strong>Prayer:</strong> God who is near, shape my conscience through your word and lead me toward integrity. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 5,
    "value": "<p><strong>Read:</strong> Acts 2:22-24; Luke 23:13-25</p><p><strong>Source and historical context:</strong> Beibitz begins a new address by tracing the historical circumstances of Jesus’ execution. He names entrenched expectations, religious resistance, and political interests, while insisting that theological reflection must start with the gospel accounts.</p><p><strong>Devotional focus:</strong> Jesus did not suffer in an imaginary world. Fear, misuse of authority, and the refusal to reconsider assumptions can destroy lives. The responsibility of the particular actors described in the Gospels must never be turned into collective blame against Jewish people. Reading the Passion should first examine our own readiness to follow truth when it challenges us.</p><p><strong>Reflect:</strong> How do fear or loyalty to a group make it harder for me to hear an uncomfortable truth?</p><p><strong>Practice:</strong> Read Luke’s account of the trial without assigning guilt to an entire people. Identify one place to choose honesty over convenience.</p><p><strong>Prayer:</strong> Jesus, truthful and merciful, free me from prejudice and from the desire to protect myself at another’s cost. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 6,
    "value": "<p><strong>Read:</strong> Mark 7:6-13; Matthew 23:23-28</p><p><strong>Source and historical context:</strong> The author critiques inherited rules that crowd out love and describes the political incentives of some Jerusalem leaders. His sweeping characterizations of Pharisees and Sadducees reflect the language and historical assumptions of his era.</p><p><strong>Devotional focus:</strong> Jesus confronts hypocrisy wherever it appears, including in the church today. The answer is not to speak contemptuously of Judaism or portray Jewish religious life as lifeless. Rather, we should ask whether our own traditions make room for mercy, justice, and attention to real people. Good habits can nurture faith; they become distorted when we use them to excuse indifference.</p><p><strong>Reflect:</strong> Have I ever defended a religious habit while overlooking someone who needed kindness?</p><p><strong>Practice:</strong> Choose one act of practical mercy that expresses what you say you believe.</p><p><strong>Prayer:</strong> Living God, preserve the best of our traditions and correct the habits that obscure your love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 7,
    "value": "<p><strong>Read:</strong> 1 Corinthians 15:3-4; James 1:13-17</p><p><strong>Source and historical context:</strong> Beibitz distinguishes the historical causes of Jesus’ death from the deeper spiritual question of sin. He also begins asking why moral wrongdoing differs from experiences of physical suffering or misfortune.</p><p><strong>Devotional focus:</strong> The cross takes moral evil seriously because harmful choices matter. Yet a person’s illness, disability, grief, or poverty does not establish that they have committed some special sin. James refuses to portray God as the tempter of humanity. Christian repentance concerns our own actions and their effects; compassion concerns how we accompany people who are suffering.</p><p><strong>Reflect:</strong> Do I sometimes confuse someone’s suffering with a judgment about their character?</p><p><strong>Practice:</strong> Offer support to a person in difficulty without asking what they did to deserve it.</p><p><strong>Prayer:</strong> Merciful Christ, teach me to repent of harm and to meet suffering with compassion. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 8,
    "value": "<p><strong>Read:</strong> Psalm 139:23-24; Romans 7:18-25</p><p><strong>Source and historical context:</strong> Here the author appeals to lived experience, remorse, and conscience in order to explain why moral failure is not merely an unpleasant event. He then turns toward the relationship between scientific accounts of human development and the Genesis narrative.</p><p><strong>Devotional focus:</strong> Remorse can help us recognize where we have acted against love, but constant self-accusation is not the same as repentance. Paul is honest about conflict within the self while also looking toward deliverance in Christ. Wisdom asks for both truthful self-examination and hope: we can acknowledge what we have done without making our failures our entire identity.</p><p><strong>Reflect:</strong> Is there an action I need to face honestly without sliding into hopeless shame?</p><p><strong>Practice:</strong> Ask God to search your heart. Name one repair you can make, and one burden of shame to bring to grace.</p><p><strong>Prayer:</strong> Search me, O God, and make room in my life for truth, mercy, and change. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 9,
    "value": "<p><strong>Read:</strong> Genesis 3:1-13; 2 Timothy 3:14-17</p><p><strong>Source and historical context:</strong> Beibitz sets a contemporary account of human moral development beside Genesis 3. He reads the early Genesis narrative as spiritual teaching expressed in story form, and he argues that its moral insights can remain useful amid changing scientific explanations.</p><p><strong>Devotional focus:</strong> Christians hold different convictions about the genre and historical interpretation of Genesis. What is shared in this passage is a searching account of desire, mistrust, concealment, and broken fellowship. Scripture invites us to ask what temptation promises, what it conceals, and how our choices affect others. Humility matters both when reading an ancient text and when discussing science.</p><p><strong>Reflect:</strong> Which part of the temptation story feels uncomfortably familiar in my own decisions?</p><p><strong>Practice:</strong> Read Genesis 3 and trace the movement from desire to hiding. Write one truthful alternative at each step.</p><p><strong>Prayer:</strong> Creator God, teach me to receive Scripture wisely and answer temptation with truth. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 10,
    "value": "<p><strong>Read:</strong> 1 John 3:16-18; Galatians 5:13-16</p><p><strong>Source and historical context:</strong> The author draws lessons from Eve’s encounter with the tree, arguing that bodily needs, desire for beauty, and the search for knowledge can be good but become destructive when detached from love and wisdom. He then opens a discussion of the divine image and the meaning of self-giving love.</p><p><strong>Devotional focus:</strong> Spiritual growth is not hostility toward our bodies or curiosity. Food, beauty, learning, and rest are gifts to steward. Problems arise when desire becomes an excuse to deceive or use another person. John points us toward the love revealed by Jesus, a love that moves from words to action. The question is not whether desire exists, but how it is ordered.</p><p><strong>Reflect:</strong> Which good desire has recently become so urgent that I am tempted to ignore someone else?</p><p><strong>Practice:</strong> Enjoy a gift gratefully today while setting one healthy boundary that protects love and truth.</p><p><strong>Prayer:</strong> God of wisdom, teach my desires to serve life rather than rule it. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 11,
    "value": "<p><strong>Read:</strong> Genesis 1:26-27; Romans 8:5-11</p><p><strong>Source and historical context:</strong> Beibitz uses evolutionary language to distinguish ordinary survival impulses from responsible moral choices. He locates moral wrongdoing in the will rather than treating the body or animal life as evil.</p><p><strong>Devotional focus:</strong> Scripture describes people as bearing God’s image, which means their dignity cannot be reduced to performance, strength, or self-control. Our bodily needs are real and deserve care. The Spirit calls us to make choices that protect neighbors and cultivate life. We should not turn the author’s dated hierarchy of development into a judgment about other people, cultures, or those with disabilities.</p><p><strong>Reflect:</strong> Where do I need to accept a human need while taking responsibility for how I act on it?</p><p><strong>Practice:</strong> Attend to a basic need—rest, food, or safety—and consider one choice that expresses love at the same time.</p><p><strong>Prayer:</strong> Image-making God, help me honor the dignity and needs of every person. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 12,
    "value": "<p><strong>Read:</strong> Philippians 2:1-8; 1 John 4:7-12</p><p><strong>Source and historical context:</strong> The author contrasts self-protective impulses with the self-giving love he sees displayed at the cross. He describes that love as the revelation of what human life is intended to become, then turns to the lasting effects of wrongdoing.</p><p><strong>Devotional focus:</strong> Jesus’ humility is not an invitation to accept exploitation or erase all personal boundaries. Love seeks the real good of another, and sometimes that means speaking honestly, asking for help, or saying no. Paul calls believers to consider others without denying that they, too, are persons worthy of care. Christ-like life is generous, truthful, and free from contempt.</p><p><strong>Reflect:</strong> Does my picture of sacrificial love leave room for wisdom and protection from harm?</p><p><strong>Practice:</strong> Do one specific kindness freely, without treating your own needs or another person’s boundaries as unimportant.</p><p><strong>Prayer:</strong> Jesus, form in me a love that serves without controlling and gives without despising. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 13,
    "value": "<p><strong>Read:</strong> Isaiah 59:1-2; 2 Corinthians 5:17-21</p><p><strong>Source and historical context:</strong> Beibitz argues that sin does lasting harm to a person and creates alienation from God and others. He discusses divine wrath as God’s settled opposition to what destroys love, before turning to reconciliation in Christ.</p><p><strong>Devotional focus:</strong> We should not minimize the consequences of wrongdoing: trust may need to be rebuilt, and the damage done to others must be taken seriously. Yet alienation is not the last word of the gospel. Paul speaks of God making reconciliation possible through Christ. Restoration is more than declaring everything fine; it involves truthful acknowledgment, grace, and sometimes long, patient repair.</p><p><strong>Reflect:</strong> What relationship or responsibility has been affected by a choice I need to acknowledge?</p><p><strong>Practice:</strong> Where it is safe and appropriate, take one concrete step toward restitution or accountability.</p><p><strong>Prayer:</strong> Reconciling God, help me face the truth and participate in your patient work of restoration. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 14,
    "value": "<p><strong>Read:</strong> Mark 1:14-15; Romans 12:1-2</p><p><strong>Source and historical context:</strong> This reading comes from Beibitz’s explanation of the Greek word metanoia as a change of mind. He connects repentance with sharing Christ’s opposition to sin and with faith understood as a surrender of self-centered control.</p><p><strong>Devotional focus:</strong> Repentance is not a performance of despair. It is turning toward the good, receiving grace, and becoming willing to change what we can. Jesus’ call to repent is paired with the invitation to believe good news. A transformed mind learns to name wrongdoing accurately, reject its false promises, and practice something different.</p><p><strong>Reflect:</strong> What would change in my routine if repentance were more than regret?</p><p><strong>Practice:</strong> Choose one repeated harmful pattern. Identify its trigger and plan one small, truthful alternative.</p><p><strong>Prayer:</strong> Lord Jesus, renew my mind and strengthen my next obedient step. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 15,
    "value": "<p><strong>Read:</strong> Galatians 2:19-21; Philippians 1:6</p><p><strong>Source and historical context:</strong> Beibitz describes the believer’s union with Christ in language drawn from Paul: dying to sin and living toward God. He insists that Christ’s work is not only outside us but also at work through the Spirit in our continuing efforts to grow.</p><p><strong>Devotional focus:</strong> Faith is not self-improvement powered only by willpower. Neither is it a claim that every struggle ends immediately. Paul can speak of Christ living in him, while another letter trusts God to continue a work not yet complete. Grace meets us in unfinished lives, leading us toward habits of love, courage, and truthful repair without reducing spiritual maturity to perfectionism.</p><p><strong>Reflect:</strong> Where have I mistaken slow growth for the complete absence of God’s work?</p><p><strong>Practice:</strong> Thank God for one real step of growth. Ask for help with one next step rather than demanding instant success.</p><p><strong>Prayer:</strong> Faithful God, continue what you have begun and make me patient with the work of grace. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 16,
    "value": "<p><strong>Read:</strong> Hebrews 5:7-9; John 15:9-12</p><p><strong>Source and historical context:</strong> The author discusses humanity’s longing for fullness and Christ’s lifelong obedience culminating in the cross. He describes baptism and Communion as ways believers share in Christ’s life, reflecting his Anglican sacramental theology.</p><p><strong>Devotional focus:</strong> Christ’s obedience is not blind submission to cruelty; it is faithfulness to the Father’s love even amid opposition. Jesus commands his followers to remain in his love and to love one another. Different churches explain the sacraments in different ways, but the call to imitate Christ’s faithful service reaches ordinary decisions: speak truth, protect the vulnerable, and refuse harm.</p><p><strong>Reflect:</strong> Where might faithfulness require courage rather than simply following the strongest voice?</p><p><strong>Practice:</strong> Carry out one neglected responsibility with care, especially if it benefits someone with less power.</p><p><strong>Prayer:</strong> Obedient Savior, let love guide my choices and give me courage when doing good is costly. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 17,
    "value": "<p><strong>Read:</strong> John 15:1-8; Ephesians 2:8-10</p><p><strong>Source and historical context:</strong> Beibitz reflects on Christ’s shared humanity and the image of the vine, then describes faith as receiving what grace gives. He begins to explain how outward signs and physical things can communicate inward realities.</p><p><strong>Devotional focus:</strong> A branch does not make itself fruitful apart from the vine. Jesus invites his disciples to remain in him, not merely to admire him from a distance. Paul holds grace and purposeful good work together: we are not saved by impressive performance, yet grace opens a fruitful way of living. Receiving does not mean passivity; it means drawing strength from a relationship we did not create.</p><p><strong>Reflect:</strong> Am I treating faith as a list of achievements or as a living relationship that bears fruit?</p><p><strong>Practice:</strong> Spend ten quiet minutes with John 15 and choose one act of love that could grow from it.</p><p><strong>Prayer:</strong> Christ our vine, help me receive your life and bear fruit that nourishes others. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 18,
    "value": "<p><strong>Read:</strong> 1 Corinthians 10:16-17; Colossians 1:15-20</p><p><strong>Source and historical context:</strong> The author uses sunsets, bodies, and material objects to explain what he calls a sacramental principle. He connects this theme with Christian Communion and warns against treating the sacrament like a magical mechanism that bypasses the believer’s response.</p><p><strong>Devotional focus:</strong> Faith is not practiced in an imaginary, disembodied place. Bread shared at a table, care offered through our hands, and the beauty of creation can remind us that ordinary life matters to God. Churches differ in their understanding of sacramental presence; this reflection does not settle those differences. It asks us to approach worship with gratitude and respond to it through love.</p><p><strong>Reflect:</strong> What ordinary material thing can remind me today that worship should affect how I live?</p><p><strong>Practice:</strong> Share a meal or practical help with someone. Receive the moment with gratitude rather than haste.</p><p><strong>Prayer:</strong> Lord, meet us in the ordinary and shape our worship into living care. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 19,
    "value": "<p><strong>Read:</strong> Hebrews 9:11-14; Romans 12:1-2</p><p><strong>Source and historical context:</strong> Beibitz surveys ancient sacrificial practices and argues that their deepest meaning involves self-offering and shared life. Some of his historical claims about the origins of sacrifice reflect early twentieth-century scholarship and require independent checking.</p><p><strong>Devotional focus:</strong> The New Testament calls Christ’s sacrifice decisive and invites believers to present their lives in service to God. We do not need to recreate the ancient rites to hear the ethical call: worship should move us away from cruelty and toward mercy. Historical theories can be discussed carefully without confusing them with the biblical text itself.</p><p><strong>Reflect:</strong> When I use the word sacrifice, am I thinking of costly love or of pain as an end in itself?</p><p><strong>Practice:</strong> Read Hebrews 9 and Romans 12. Choose one way to give time or attention for another person’s good.</p><p><strong>Prayer:</strong> Holy God, purify my motives and let my worship become generous service. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 20,
    "value": "<p><strong>Read:</strong> Mark 10:42-45; Hebrews 13:15-16</p><p><strong>Source and historical context:</strong> This section identifies the cross as the completion of Jesus’ life of self-giving obedience. Beibitz argues that Christ’s sacrifice enables believers to offer themselves in loving service, rather than merely escaping responsibility.</p><p><strong>Devotional focus:</strong> Jesus came to serve and give his life. That service is not a demand that vulnerable people endure mistreatment silently; it challenges those with power to use it for others. Praise and doing good belong together in Hebrews. The cross turns us outward: forgiven people can seek justice, share resources, and take responsibility for their neighbors.</p><p><strong>Reflect:</strong> How does my view of Jesus’ sacrifice affect the way I treat someone who depends on me?</p><p><strong>Practice:</strong> Give practical help in a way that respects the other person’s wishes and dignity.</p><p><strong>Prayer:</strong> Servant Lord, turn my gratitude into wise and courageous care. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 21,
    "value": "<p><strong>Read:</strong> Ephesians 4:20-24; Luke 23:32-34</p><p><strong>Source and historical context:</strong> After completing his addresses on sacrifice, Beibitz introduces a Good Friday devotion centered on the Seven Last Words. He describes meditation as a way to learn the mind and character of Jesus, beginning with the prayer for forgiveness of those involved in his execution.</p><p><strong>Devotional focus:</strong> Learning Christ is more than collecting facts. It means allowing his mercy, truthfulness, and courage to shape us. At the cross, Jesus refuses to answer violence with vengeance. We should receive these words carefully, remembering that Christian faith never requires a victim to remain unsafe or disregard justice. His mercy can inform our response even as wrongdoing is named.</p><p><strong>Reflect:</strong> What do Jesus’ words reveal about the kind of person he calls me to become?</p><p><strong>Practice:</strong> Read Luke 23:32-34. Pray for the courage to tell the truth without nourishing revenge.</p><p><strong>Prayer:</strong> Jesus, help me learn your ways and resist the cycle of harm. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 22,
    "value": "<p><strong>Read:</strong> Matthew 5:43-48; Romans 12:17-21</p><p><strong>Source and historical context:</strong> The next segment expands on Jesus’ first word from the cross, arguing that forgiveness is strong rather than cowardly. The author urges believers to abandon personal resentment and recognizes the ignorance often involved in wrongdoing.</p><p><strong>Devotional focus:</strong> Forgiveness can loosen the hold of retaliation while still affirming that evil was evil. It is not the same as instant trust, compulsory reconciliation, or the removal of consequences. Paul tells believers not to repay evil with evil and to overcome evil with good. In circumstances involving abuse or danger, wisdom includes boundaries, support, and appropriate protection.</p><p><strong>Reflect:</strong> What is the difference between letting go of revenge and pretending that nothing happened?</p><p><strong>Practice:</strong> Bring one resentment honestly into prayer. If safety is involved, seek trustworthy support instead of forcing contact.</p><p><strong>Prayer:</strong> Merciful Christ, guard my heart against vengeance and help me pursue truth and safety. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 23,
    "value": "<p><strong>Read:</strong> Luke 23:39-43; 1 John 1:8-9</p><p><strong>Source and historical context:</strong> Beibitz considers Jesus’ promise to the repentant criminal. He identifies contrition, confession, and amendment as features of repentance and insists that forgiveness can be received without delay, while the consequences of past actions may still remain.</p><p><strong>Devotional focus:</strong> The man beside Jesus has no opportunity to assemble an impressive record of good works. He turns to Christ in honesty and hope. This is encouragement for those who fear they are too late or too stained to ask for mercy. It is not a reason to avoid making amends when we can. Grace welcomes the penitent and gives courage to begin a changed direction.</p><p><strong>Reflect:</strong> Is shame keeping me from turning toward the mercy Christ offers?</p><p><strong>Practice:</strong> Pray with the words “Jesus, remember me.” Where possible, make one honest repair.</p><p><strong>Prayer:</strong> Lord Jesus, remember me in mercy and guide me into truthful repentance. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 24,
    "value": "<p><strong>Read:</strong> John 19:25-27; 1 Timothy 5:4-8</p><p><strong>Source and historical context:</strong> The author turns to Jesus’ words to his mother and the beloved disciple. He treats Christ’s concern for Mary as a model of practical consideration and speaks of renewed friendship that becomes visible through service. The next section introduces Jesus’ cry of abandonment.</p><p><strong>Devotional focus:</strong> Even in profound suffering, Jesus notices a person who will need care. Christian love should not be measured only by dramatic sacrifices far away; it is tested in patient attention to people close to us. Caring wisely may involve relatives, friends, trusted communities, and professional help. It is not a demand that a single person shoulder every burden alone.</p><p><strong>Reflect:</strong> Whose need is easy for me to overlook because it is familiar or inconvenient?</p><p><strong>Practice:</strong> Ask someone close to you what concrete support would help, and respond within your capacity.</p><p><strong>Prayer:</strong> Caring Christ, teach me to see nearby needs and build dependable circles of support. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 25,
    "value": "<p><strong>Read:</strong> Psalm 22:1-24; Mark 15:33-39</p><p><strong>Source and historical context:</strong> Beibitz analyzes the Fourth Word, “My God, my God, why have you forsaken me?” He considers the agony of isolation, death, and sin, and interprets the cry as a real expression of Jesus’ human suffering.</p><p><strong>Devotional focus:</strong> Jesus’ cry gives believers language for pain that cannot be made tidy. The opening of Psalm 22 is a prayer of anguish, not a sign that someone who suffers has less faith. We must not tell grieving or ill people that their distress proves divine rejection. The cross allows honest lament to stand within the story of God’s love; community is called to stay present rather than explain another person’s pain away.</p><p><strong>Reflect:</strong> What sorrow have I been afraid to speak honestly in prayer?</p><p><strong>Practice:</strong> Read Psalm 22 aloud or in silence. Offer presence, not a quick explanation, to someone who grieves.</p><p><strong>Prayer:</strong> God who hears the forsaken, receive our cries and keep us close in suffering. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 26,
    "value": "<p><strong>Read:</strong> John 19:28-30; Hebrews 4:14-16</p><p><strong>Source and historical context:</strong> The Fifth Word begins with Jesus’ bodily thirst. Beibitz reflects on the reality of physical pain and treats Christ’s deliberate speech as evidence of courage. He also develops a broad argument that hardship can train spiritual life.</p><p><strong>Devotional focus:</strong> Jesus is not a distant spectator of bodily need. His thirst tells us that hunger, pain, exhaustion, and vulnerability belong within the story of incarnation. Physical suffering is not inherently holy, nor should it be romanticized as necessary for growth. Christians may pursue treatment, rest, and relief while asking God for endurance and companionship through what cannot immediately be changed.</p><p><strong>Reflect:</strong> Do I treat my own bodily limits, or someone else’s, as something embarrassing to ignore?</p><p><strong>Practice:</strong> Attend to a real physical need today. Offer water, rest, or practical assistance to someone who needs it.</p><p><strong>Prayer:</strong> Compassionate Savior, teach me to honor bodies and respond to suffering with care. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 27,
    "value": "<p><strong>Read:</strong> Matthew 25:34-40; John 19:29-30</p><p><strong>Source and historical context:</strong> The author finishes discussing Christ’s thirst by drawing attention to the person who offered him drink. He then introduces the Sixth Word, “It is finished,” and reads the cross as the culmination of Jesus’ faithful mission rather than an isolated episode.</p><p><strong>Devotional focus:</strong> The simple act of offering relief matters. Jesus says that care given to the hungry, thirsty, and vulnerable is not forgotten. His completed work does not excuse indifference; it frees us to participate in love. We need not understand every theory of the cross before beginning to practice mercy. A cup of water can become a genuine response to God’s costly love.</p><p><strong>Reflect:</strong> What small act of relief is within my reach right now?</p><p><strong>Practice:</strong> Help one person with a concrete need today, without making them feel indebted or inferior.</p><p><strong>Prayer:</strong> Lord Jesus, let the fullness of your love make my hands ready to serve. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 28,
    "value": "<p><strong>Read:</strong> John 19:30; Philippians 2:5-11</p><p><strong>Source and historical context:</strong> Beibitz reflects on the Sixth Word as the victory of a life of obedience. In the same segment he introduces the Seventh Word, Jesus entrusting his spirit to the Father, and contrasts joyful trust with passive resignation.</p><p><strong>Devotional focus:</strong> When Jesus says that his work is finished, he does not announce that human suffering is good or that his followers need never act again. He brings his costly mission of love to its completion. We are invited to persevere in faithful service, not to measure ourselves against a burden we cannot carry. Trust grows as we learn to recognize the goodness of God’s will.</p><p><strong>Reflect:</strong> Where do I need to distinguish faithful perseverance from exhaustion or harmful pressure?</p><p><strong>Practice:</strong> Complete one manageable act of service, and then receive rest without guilt.</p><p><strong>Prayer:</strong> Faithful Jesus, teach me the courage to serve and the humility to rest. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 29,
    "value": "<p><strong>Read:</strong> Luke 23:44-49; Romans 6:3-5</p><p><strong>Source and historical context:</strong> At the close of the Seven Words, Beibitz presents surrender to the Father as confidence in divine love. He then moves to the burial of Jesus and baptismal imagery for dying to an old way of living and being raised into new life.</p><p><strong>Devotional focus:</strong> The words “into your hands” are an act of trust, not a demand to feel untroubled in the face of loss. Christian hope can coexist with grief and uncertainty. Paul’s image of baptism connects Jesus’ death and resurrection with a new way of life. Traditions differ in how they explain the sacrament, but all may hear the invitation to leave behind what destroys life and walk toward Christ.</p><p><strong>Reflect:</strong> What fear or burden can I entrust to God today without pretending it has disappeared?</p><p><strong>Practice:</strong> Pray Luke 23:46, then write one hopeful step you can take while uncertainty remains.</p><p><strong>Prayer:</strong> Loving Father, hold us in life and death, and lead us in paths of new life. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 30,
    "value": "<p><strong>Read:</strong> Romans 6:4-11; 1 Corinthians 15:3-8</p><p><strong>Source and historical context:</strong> The closing paragraph links Jesus’ death, burial, and resurrection with transformation in believers’ lives. Beibitz ends by encouraging worshippers to approach Easter Communion with hope that divine grace can renew their moral and spiritual life.</p><p><strong>Devotional focus:</strong> The Christian proclamation does not stop at the grave. Paul proclaims the risen Christ and calls believers to walk in newness of life. Personal growth can be uneven, and faith should not be turned into a promise of instant perfection or physical healing. Easter hope means the future is not exhausted by yesterday’s failures. We can begin again, relying on God’s faithful love.</p><p><strong>Reflect:</strong> Where do I need hope for a new beginning rather than another attempt to punish myself?</p><p><strong>Practice:</strong> Celebrate Easter hope with gratitude. Choose one achievable act that expresses the new life you seek.</p><p><strong>Prayer:</strong> Risen Lord, renew our courage, heal what is broken, and teach us to walk in hope. Amen.</p>"
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
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 1,
    "references": [
      "Galatians 6:14",
      "2 Corinthians 5:18-19"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 2,
    "references": [
      "Romans 3:21-26",
      "1 John 4:9-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 3,
    "references": [
      "1 Corinthians 1:18-25",
      "Ephesians 3:16-19"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 4,
    "references": [
      "Romans 2:14-16",
      "Acts 17:24-28"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 5,
    "references": [
      "Acts 2:22-24",
      "Luke 23:13-25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 6,
    "references": [
      "Mark 7:6-13",
      "Matthew 23:23-28"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 7,
    "references": [
      "1 Corinthians 15:3-4",
      "James 1:13-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 8,
    "references": [
      "Psalm 139:23-24",
      "Romans 7:18-25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 9,
    "references": [
      "Genesis 3:1-13",
      "2 Timothy 3:14-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 10,
    "references": [
      "1 John 3:16-18",
      "Galatians 5:13-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 11,
    "references": [
      "Genesis 1:26-27",
      "Romans 8:5-11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 12,
    "references": [
      "Philippians 2:1-8",
      "1 John 4:7-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 13,
    "references": [
      "Isaiah 59:1-2",
      "2 Corinthians 5:17-21"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 14,
    "references": [
      "Mark 1:14-15",
      "Romans 12:1-2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 15,
    "references": [
      "Galatians 2:19-21",
      "Philippians 1:6"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 16,
    "references": [
      "Hebrews 5:7-9",
      "John 15:9-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 17,
    "references": [
      "John 15:1-8",
      "Ephesians 2:8-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 18,
    "references": [
      "1 Corinthians 10:16-17",
      "Colossians 1:15-20"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 19,
    "references": [
      "Hebrews 9:11-14",
      "Romans 12:1-2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 20,
    "references": [
      "Mark 10:42-45",
      "Hebrews 13:15-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 21,
    "references": [
      "Ephesians 4:20-24",
      "Luke 23:32-34"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 22,
    "references": [
      "Matthew 5:43-48",
      "Romans 12:17-21"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 23,
    "references": [
      "Luke 23:39-43",
      "1 John 1:8-9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 24,
    "references": [
      "John 19:25-27",
      "1 Timothy 5:4-8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 25,
    "references": [
      "Psalm 22:1-24",
      "Mark 15:33-39"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 26,
    "references": [
      "John 19:28-30",
      "Hebrews 4:14-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 27,
    "references": [
      "Matthew 25:34-40",
      "John 19:29-30"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 28,
    "references": [
      "John 19:30",
      "Philippians 2:5-11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 29,
    "references": [
      "Luke 23:44-49",
      "Romans 6:3-5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000362",
    "day_number": 30,
    "references": [
      "Romans 6:4-11",
      "1 Corinthians 15:3-8"
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
where id = '90000000-0000-0000-0000-000000000362'::uuid;

commit;
