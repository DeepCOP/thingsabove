-- Wave 36: Plan 392 - C. H. Woolston, The Gospel Object Book.
-- Adapted 24 imported segments: original Scripture-led reading text and two references per day.
-- Hazardous historical demonstrations are not reproduced; source-specific editorial cautions in review.
-- Apply AFTER all October 21 modernization migrations, especially part 13 (20 overlap updates).
-- Preserve plan/day IDs, user progress, existing cover, tags, original source URL and day count.
-- This migration does not delete user-owned Scripture references or user-created data.
-- DRAFT ONLY: editorial, theological, historical and rights approval required before release.
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
  from public.devotional_plans where id = '90000000-0000-0000-0000-000000000392'::uuid;
  if not found then raise exception 'Plan 392 missing'; end if;
  if current_source is distinct from 'https://www.gutenberg.org/ebooks/73388' or current_total is distinct from 24 then
    raise exception 'Plan 392 source URL or total_days mismatch - abort Wave 36';
  end if;
  select count(*), min(day_number), max(day_number), count(distinct day_number)
  into day_count, first_day, last_day, unique_days
  from public.devotional_days where plan_id = '90000000-0000-0000-0000-000000000392'::uuid;
  if day_count <> 24 or first_day <> 1 or last_day <> 24 or unique_days <> 24 then
    raise exception 'Plan 392 expected 24 uniquely numbered days, found %',day_count;
  end if;
  select count(*) into duplicate_reference_days from (
    select sr.day_id
    from public.scripture_references sr
    join public.devotional_days d on d.id = sr.day_id
    where d.plan_id = '90000000-0000-0000-0000-000000000392'::uuid and sr.user_id is null
    group by sr.day_id having count(*)>1
  ) duplicates_per_day;
  if duplicate_reference_days > 0 then
    raise exception 'Plan 392 has % days with multiple global Scripture-reference rows',duplicate_reference_days;
  end if;
end
$$;

update public.devotional_plans as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "value": "Everyday Objects, Living Faith: 24 Scripture-Led Readings for Families"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "value": "Twenty-four original, Scripture-led devotional readings inspired by C. H. Woolston’s historical Gospel Object Book, an object-teaching manual for ministers, adults, and children. The readings explore teaching children with care, learning through familiar symbols, grace, community, repentance and repair, the dignity of every person, spiritual growth, and Christmas generosity. Each day offers two Bible passages, historical context, a devotional focus, reflection, an attainable practice, and a prayer. The author’s hazardous object experiments, racial stereotypes, dated educational claims, and coercive disciplinary examples are not endorsed or reproduced as activities. This is an adaptation of 24 mechanically imported segments, not a reproduction of all the historical demonstrations."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 1,
    "value": "See the Possibility in Every Child"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 2,
    "value": "Love Before the Lesson"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 3,
    "value": "Begin with What Is Familiar"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 4,
    "value": "The God Who Teaches Through Signs"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 5,
    "value": "Hear the Child Before Correcting"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 6,
    "value": "Listen Carefully, Respond Freely"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 7,
    "value": "A Faith That Grows in Practice"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 8,
    "value": "Make Room for Learning Together"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 9,
    "value": "Look Beyond the Surface"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 10,
    "value": "Drawn Toward Grace"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 11,
    "value": "The Gift That Arrives in Humility"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 12,
    "value": "Value People Above Possessions"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 13,
    "value": "The Father Who Runs to Welcome"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 14,
    "value": "Grace Leaves Room for the Whole Family"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 15,
    "value": "Forgiveness Is Not a Chemical Trick"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 16,
    "value": "Held in Care, Not Promised a Trouble-Free Life"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 17,
    "value": "Let Your Light Become Kindness"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 18,
    "value": "Hands Ready for Helpful Work"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 19,
    "value": "An Invitation That Travels by Name"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 20,
    "value": "Choose Reconciliation over Resentment"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 21,
    "value": "Repair What Words Have Damaged"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 22,
    "value": "Uncover Space for God’s Word"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 23,
    "value": "Make Time for What Gives Life"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 24,
    "value": "A Small Light of Christmas Welcome"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 1,
    "value": "<p><strong>Read:</strong> John 21:15-17; Mark 10:13-16</p><p><strong>Source and historical context:</strong> In the preface to The Gospel Object Book, C. H. Woolston begins with Jesus asking Peter to care for his lambs. He then recounts a teacher who recognized a boy’s inventiveness where others saw disruption. These are illustrations from an early-twentieth-century teaching manual, not a research study about how all children learn.</p><p><strong>Devotional focus:</strong> Jesus notices people whom a crowd might overlook. To feed his lambs is more than delivering information: it is to see a child as a person worth listening to, protecting, and encouraging. An awkward moment can become a chance to guide rather than shame. Genuine care refuses to make children earn their dignity by being quiet or impressive.</p><p><strong>Reflect:</strong> When a child interrupts or surprises you, is your first instinct to correct the behavior or to understand the person?</p><p><strong>Practice:</strong> Invite a younger person to show you something they enjoy. Listen without rushing to turn the conversation into a lesson, and name one strength you genuinely see.</p><p><strong>Prayer:</strong> Jesus, give me patient eyes and a generous heart. Teach me to care for your little ones with attention, safety, and delight. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 2,
    "value": "<p><strong>Read:</strong> Matthew 18:1-5; 1 Corinthians 13:1-7</p><p><strong>Source and historical context:</strong> Woolston’s introduction, endorsed by G. Campbell Morgan, describes children gathering around a teacher who meets them with affection rather than condescension. The opening of his “Ten Demandments” puts love first and calls adults to know the children they teach.</p><p><strong>Devotional focus:</strong> The disciples once debated greatness; Jesus placed a child among them. He overturned the assumption that power and importance belong only to adults. Christian teaching grows credible when learners experience patience, respect, and welcome. A vivid activity cannot replace the steady trust built through kindness. Children are not projects to manage but neighbors to honor.</p><p><strong>Reflect:</strong> Would the children or beginners who meet you say they are safe asking questions and admitting confusion?</p><p><strong>Practice:</strong> Before preparing another explanation, learn a learner’s name, interests, and concerns. Make space for a question without embarrassment, and avoid using attention or affection as a reward.</p><p><strong>Prayer:</strong> Lord, keep love at the center of what I teach. Give every person in my care room to learn, question, and flourish. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 3,
    "value": "<p><strong>Read:</strong> John 4:7-14; Nehemiah 8:8-12</p><p><strong>Source and historical context:</strong> The next “Demandments” encourage brief, understandable language and learning from familiar objects. Woolston points to Jesus speaking of ordinary well water with a Samaritan woman before discussing living water. He also urges teachers to keep Scripture central.</p><p><strong>Devotional focus:</strong> Good teaching does not confuse simplicity with shallowness. Jesus begins with a drink of water because it belongs to the woman’s world, and from there their conversation reaches spiritual thirst, dignity, and truth. The familiar becomes an opening to something more. Notice also that the woman speaks and asks questions; she is a participant rather than a passive audience.</p><p><strong>Reflect:</strong> What truth have you been explaining in language that your listener has no reason to understand?</p><p><strong>Practice:</strong> Choose one biblical image—bread, water, a seed, or a lamp—and ask someone what it reminds them of. Then read the passage together and let them express its meaning in their own words.</p><p><strong>Prayer:</strong> Teacher of our hearts, help me speak clearly and listen generously. Use ordinary moments to open conversations about your extraordinary grace. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 4,
    "value": "<p><strong>Read:</strong> Jeremiah 18:1-6; Genesis 9:12-17</p><p><strong>Source and historical context:</strong> Woolston surveys biblical object lessons: Jeremiah at the potter’s house, symbolic actions of the prophets, and the rainbow of the covenant. His section turns toward baptism and Communion as visible practices. Some of his statements about learning and biblical cultures reflect the assumptions of his own period.</p><p><strong>Devotional focus:</strong> At the potter’s house, Jeremiah is asked to look closely before listening to God’s interpretation. The sign is not a magic object; it calls people to humility, repentance, and trust. The rainbow similarly directs attention away from itself toward God’s promise. Symbols can help memory, but their meaning comes from the words and context that accompany them.</p><p><strong>Reflect:</strong> Do you stop at the beauty of a symbol, or let it call you toward the promise and responsibility it represents?</p><p><strong>Practice:</strong> Observe a safe, ordinary object—clay, fabric, or the sky—and read one related Bible passage. Discuss what the passage actually says before making a personal application.</p><p><strong>Prayer:</strong> God of patient teaching, open my senses without closing my mind. Let your Word shape the meaning I find in what I see. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 5,
    "value": "<p><strong>Read:</strong> James 1:19-20; Colossians 3:12-14</p><p><strong>Source and historical context:</strong> A story about an artist kneeling to see a painting from a child’s level introduces Woolston’s plea to understand the learner. Another tale describes a boy whose humorous answer about Jonah receives a harsh rebuke, after which he leaves and does not return.</p><p><strong>Devotional focus:</strong> A teacher can know a biblical story and still fail to hear the person sitting nearby. James calls believers to be quick to listen and slow to anger. Correction may sometimes be necessary, but humiliation is not the same as instruction. Children need adults who can distinguish a mistaken answer from deliberate harm and respond without threats.</p><p><strong>Reflect:</strong> Whose perspective have you missed because you were determined to finish your own explanation?</p><p><strong>Practice:</strong> The next time someone gives an unexpected answer, ask what they meant before responding. Affirm the effort, gently clarify the Scripture, and invite another attempt.</p><p><strong>Prayer:</strong> Patient Lord, help me see people as you see them. Replace harshness with gentleness, and let my corrections protect rather than wound. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 6,
    "value": "<p><strong>Read:</strong> 1 Samuel 3:1-10; Psalm 34:17-18</p><p><strong>Source and historical context:</strong> Woolston moves from a dangerous alcohol-and-flame demonstration to a story about prisoners tapping messages through a wall. He uses those taps to describe listening for God’s call. He also follows with a gift-sharing lesson on envy and trust. Neither experiment nor hardship needs to be treated as a divine signal sent to test a child.</p><p><strong>Devotional focus:</strong> Samuel hears his name but needs Eli’s patient guidance to understand what is happening. Discernment involves listening, asking for help, and testing what we believe we hear. God’s nearness in trouble is not proof that God caused the trouble; the psalm speaks of divine care for broken hearts. Listening to God should lead toward truth, compassion, and practical support.</p><p><strong>Reflect:</strong> When life becomes noisy or painful, whom can you ask to help you discern wisely rather than guessing at hidden messages?</p><p><strong>Practice:</strong> Read Samuel’s story in a quiet moment. Write down a concern, discuss it with a trusted person if useful, and offer one concrete act of care to someone struggling.</p><p><strong>Prayer:</strong> God who hears the distressed, give me attentive ears and a steady mind. Help me seek wise counsel and respond to suffering with love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 7,
    "value": "<p><strong>Read:</strong> James 2:14-18; Philippians 3:12-16</p><p><strong>Source and historical context:</strong> In his chapters on making a Christian, Woolston assembles pieces of a flag, holds up a hand as an aid to remembering faith, and draws a cross between “before” and “after.” His lists sometimes make culturally specific choices a universal test of discipleship.</p><p><strong>Devotional focus:</strong> The New Testament measures living faith by trust in Christ that becomes visible in love and action. Growth is a journey, not a flawless uniform or a checklist of permitted amusements. Paul openly acknowledges that he has not yet arrived, while pressing onward in grace. The cross invites ongoing renewal rather than superiority over people with different customs.</p><p><strong>Reflect:</strong> Are you more concerned with appearing religious or with becoming truthful, humble, and helpful?</p><p><strong>Practice:</strong> Choose one small action that gives faith a visible shape: apologize, share a meal, keep a promise, or help someone without seeking credit. Review it without comparing yourself to others.</p><p><strong>Prayer:</strong> Jesus, form your life in me beyond outward labels. Teach me to keep growing through faith that works by love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 8,
    "value": "<p><strong>Read:</strong> Hebrews 10:24-25; Acts 2:42-47</p><p><strong>Source and historical context:</strong> The next chapters use a cardboard church to argue for belonging, illustrated pictures to support preaching, and a “Big Six” memory chart for Bible books. Woolston’s enthusiasm for church participation should be read alongside the needs of people who cannot attend or have experienced harm in religious communities.</p><p><strong>Devotional focus:</strong> The first Christians learned, prayed, and shared resources in community. Belonging offered mutual encouragement; it did not erase anyone’s dignity or independence. A useful lesson can be drawn from the author’s cardboard church: no one person is the whole building. Shared worship is at its best when it makes room for newcomers, questions, and practical care.</p><p><strong>Reflect:</strong> Does your community strengthen the overlooked, or does it quietly expect everyone to fit the same pattern?</p><p><strong>Practice:</strong> Reach out to someone who has been absent or isolated with a simple question about their needs. Offer connection without pressure, and try learning a biblical story with another person.</p><p><strong>Prayer:</strong> God of fellowship, make our gatherings places of welcome and courage. Help us bear one another’s burdens with respect and joy. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 9,
    "value": "<p><strong>Read:</strong> 1 Samuel 16:6-13; John 3:16-17</p><p><strong>Source and historical context:</strong> Woolston contrasts two cups to symbolize outward appearance and the inward life. The following section proposes colored strips to illustrate John 3:16, but it labels human groups through outdated racial colors. Such categorization should not be copied into a family lesson.</p><p><strong>Devotional focus:</strong> When Samuel sees David’s older brothers, God redirects his attention from appearance to the heart. John announces God’s love for the world, not a selection of people ranked by skin or origin. The gospel dismantles narrow judgments; it does not need racial stereotypes to show its reach. A person’s worth is not measured by appearance, social position, or visible religious performance.</p><p><strong>Reflect:</strong> What assumption about another person would change if you began with God’s love rather than outward impressions?</p><p><strong>Practice:</strong> Read John 3:16 aloud, replacing no part of its invitation with racial categories. Welcome someone whose experience differs from your own, and listen to their story.</p><p><strong>Prayer:</strong> Loving Father, free me from shallow judgments and prejudice. Help me recognize your image and your love in every neighbor. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 10,
    "value": "<p><strong>Read:</strong> John 12:32-33; Luke 2:8-20</p><p><strong>Source and historical context:</strong> One imported segment finishes the color illustration, then introduces a magnet as a metaphor for attraction and a “Star Box” for telling the Christmas story. Woolston attributes a particular magnet lesson to Robert Raikes; that origin claim requires separate historical confirmation.</p><p><strong>Devotional focus:</strong> A magnet can remind us of a pull, but people are not metal objects compelled to believe. Jesus speaks of drawing people through the giving of his life, a call that invites trust rather than coercion. In the Christmas narrative, the shepherds respond to good news by going to see, then sharing what they have heard. Grace leads outward toward witness and wonder.</p><p><strong>Reflect:</strong> When you invite someone toward faith, does your manner leave room for their questions and free response?</p><p><strong>Practice:</strong> Read the shepherds’ story and create a simple paper star or note that names one reason for gratitude. Share the story as an invitation, not a demand.</p><p><strong>Prayer:</strong> Jesus, draw me toward your mercy. Make my words and actions an invitation to hope, never an instrument of pressure. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 11,
    "value": "<p><strong>Read:</strong> Luke 2:1-20; Matthew 2:9-12</p><p><strong>Source and historical context:</strong> The “Star Box” chapter offers cloth, stars, straw, and symbolic gifts to retell the birth of Jesus. The objects recall shepherds at work, angels announcing peace, and visitors offering gifts. Some costume colors and imagined details are teaching aids, not facts recorded by the Gospel writers.</p><p><strong>Devotional focus:</strong> Luke places the announcement of Jesus’ birth amid ordinary labor and a place of humble welcome. Matthew describes visitors bringing gifts in honor of the child. The accounts invite us to notice a God whose good news reaches people outside expected centers of influence. Christmas generosity is not a competition in spending but an expression of peace, dignity, and shared joy.</p><p><strong>Reflect:</strong> How could the story of Jesus’ birth change the way you notice people doing quiet, necessary work?</p><p><strong>Practice:</strong> Set aside a practical gift, food item, or encouraging message for someone who might otherwise be overlooked. Read the two accounts without mixing their separate timelines.</p><p><strong>Prayer:</strong> God of Bethlehem, thank you for meeting the world in humility. Make our celebration generous, peaceful, and attentive to those in need. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 12,
    "value": "<p><strong>Read:</strong> Luke 12:15-21; Luke 15:11-20</p><p><strong>Source and historical context:</strong> The Star Box closes with a paper cross, and Woolston next tells how a child named May chooses a poorer-quality doll despite her father’s advice. He then begins retelling the prodigal son with differently colored scraps of cloth. The doll tale is the author’s invented illustration, not a biblical event.</p><p><strong>Devotional focus:</strong> Objects can delight us, but they cannot carry the full weight of our belonging. Jesus warns against measuring life by possessions, and the younger son in his parable discovers how unstable a life built only on wealth can be. Yet neither story licenses adults to shame children for wanting good things. Wisdom grows when guidance is patient and choices are discussed honestly.</p><p><strong>Reflect:</strong> When desire pushes you toward a quick decision, what would help you slow down and ask what truly matters?</p><p><strong>Practice:</strong> Before a nonessential purchase, pause to consider its lasting value. If guiding a child, explain the options respectfully and allow an age-appropriate choice.</p><p><strong>Prayer:</strong> Father, teach me gratitude without greed. Give me patience in my decisions and kindness when others learn through theirs. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 13,
    "value": "<p><strong>Read:</strong> Luke 15:17-24; Ephesians 2:4-10</p><p><strong>Source and historical context:</strong> Woolston continues the prodigal-son story with scraps representing departure, want, repentance, and especially the father’s enduring love. He explicitly insists that the center of the parable is the loving father, not merely the son’s failures.</p><p><strong>Devotional focus:</strong> The son prepares a confession, but the father sees him while he is still far away and runs to meet him. Grace does not deny the hurt caused by choices; it refuses to reduce a person to the worst chapter of their story. God’s welcome is neither purchased by humiliation nor withdrawn because someone has struggled. Repentance can be honest because mercy opens a way home.</p><p><strong>Reflect:</strong> Do you see yourself or others only through mistakes that have already been made?</p><p><strong>Practice:</strong> Read the father’s response slowly. If reconciliation is safe, take one step toward an honest conversation; if it is not safe, seek wise support without putting yourself in danger.</p><p><strong>Prayer:</strong> Merciful God, thank you that your love is larger than my failures. Help me tell the truth, receive grace, and extend welcome wisely. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 14,
    "value": "<p><strong>Read:</strong> Luke 15:25-32; Romans 12:15-18</p><p><strong>Source and historical context:</strong> The final cloth in Woolston’s prodigal-son demonstration represents peace in the household, including the older brother. Luke, however, does not tell us whether the older brother joins the celebration; the father’s invitation remains open. The next chapter introduces a chemical “sin-removal” experiment.</p><p><strong>Devotional focus:</strong> The older brother’s resentment is painfully recognizable: another person receives mercy, and fairness suddenly seems scarce. The father comes out to him too. Grace does not ask us to pretend jealousy is not real; it invites us to bring our grievance into the light without turning our sibling into an enemy. The story’s unfinished ending asks what response we will give.</p><p><strong>Reflect:</strong> Whose good news has been difficult for you to celebrate, and what fear lies underneath that reaction?</p><p><strong>Practice:</strong> Name a resentment honestly in private prayer. Congratulate someone on a good thing without comparing their portion to yours; set healthy boundaries where harm remains unresolved.</p><p><strong>Prayer:</strong> Father, you seek both the one who left and the one who stayed. Soften my comparisons and teach me the patient work of peace. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 15,
    "value": "<p><strong>Read:</strong> 1 John 1:7-9; Ephesians 4:31-32</p><p><strong>Source and historical context:</strong> Woolston’s next visual lesson changes a liquid’s appearance with substances including oxalic acid, tincture of iron, and other materials, claiming this illustrates the cleansing of sin. The same segment introduces “The Gospel Copy Book,” urging readers to follow the example of Jesus. The chemical mixture should not be prepared or demonstrated, especially with children.</p><p><strong>Devotional focus:</strong> A color change may catch the eye, but forgiveness is not a laboratory reaction that erases consequences. First John connects confession with God’s faithfulness; Ephesians calls forgiven people to practice truthfulness and kindness. Genuine repentance can include restitution, changed conduct, and patient rebuilding of trust. Grace restores relationship without requiring us to deny that harm occurred.</p><p><strong>Reflect:</strong> Are you seeking only the relief of feeling forgiven, or also a way to repair what you can?</p><p><strong>Practice:</strong> Skip the chemical display. Use a paper heart with words like “confess,” “repair,” and “renew” as prompts for discussion, and take one safe step to put a wrong right.</p><p><strong>Prayer:</strong> Holy God, thank you for mercy that reaches real lives. Give me courage to confess, make amends, and grow in love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 16,
    "value": "<p><strong>Read:</strong> John 10:27-30; Romans 8:35-39</p><p><strong>Source and historical context:</strong> A commuter follows another man’s pace and misses a train, illustrating how imitating others can mislead. Woolston then uses nested boxes marked with God’s care and love to picture divine security. His assurance is vivid, but readers should not confuse it with a guarantee against illness or hardship.</p><p><strong>Devotional focus:</strong> Jesus describes his sheep as known and held by him. Paul names distress, persecution, and danger, yet insists that none of them can sever believers from Christ’s love. The promise is God’s faithful presence, not an escape from every hard event. Even when a plan falls apart or another person disappoints us, we can seek help and keep walking in trust.</p><p><strong>Reflect:</strong> When circumstances feel insecure, what helps you remember that being loved is not the same as having every problem solved?</p><p><strong>Practice:</strong> Write Romans 8:38–39 on a card or in your notes. Check in with someone who faces uncertainty, and offer specific assistance instead of easy reassurance.</p><p><strong>Prayer:</strong> Lord Jesus, hold me in your faithful love through uncertainty. Help me offer others presence, practical care, and honest hope. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 17,
    "value": "<p><strong>Read:</strong> Matthew 5:14-16; Philippians 2:14-16</p><p><strong>Source and historical context:</strong> Woolston uses candles of different sizes and brightness to illustrate Christian influence. The imported segment also introduces a new lesson using ten fingers as a metaphor for helpful friends. Fire was an arresting image for his audiences but need not be used in a children’s devotional today.</p><p><strong>Devotional focus:</strong> Jesus calls his followers the light of the world and immediately connects that image with good deeds that point beyond themselves to God. Light is not a measure of fame, noise, or spiritual superiority. A small kindness can matter deeply to a person in a dark hour. We need no flame to understand the image: a drawing, window, or daylight can invite the same reflection.</p><p><strong>Reflect:</strong> Where can your ordinary kindness make someone’s path a little clearer today?</p><p><strong>Practice:</strong> Draw a simple lamp or use a battery-operated light; do not light candles for this lesson. Write one specific act of encouragement beside it and do that act.</p><p><strong>Prayer:</strong> God of light, let my presence bring comfort and truth. Keep me from performing goodness for applause, and lead me toward quiet service. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 18,
    "value": "<p><strong>Read:</strong> 1 Corinthians 12:14-27; Proverbs 31:8-9</p><p><strong>Source and historical context:</strong> In “Those Ten Little Friends of Yours,” Woolston calls fingers faithful helpers and points to the everyday usefulness of hands. He then introduces an envelope game for remembering Jesus’ disciples. The image is playful, but not everyone has ten fingers or uses their hands in the same way.</p><p><strong>Devotional focus:</strong> The body of Christ includes people with differing abilities, gifts, and roles. Paul insists that no member can say another is unnecessary. Our hands, voices, attention, mobility aids, and teamwork can all serve love. Christian service is not reserved for people who meet one physical ideal. The question is not whether everyone can do the same task, but whether each person is valued and empowered to contribute.</p><p><strong>Reflect:</strong> Have you overlooked someone’s gifts because they serve differently from you?</p><p><strong>Practice:</strong> Ask a person what kind of help would actually be useful, rather than assuming. Choose one accessible way to speak up for someone who has been excluded.</p><p><strong>Prayer:</strong> Creator God, thank you for the many ways people can give and receive care. Teach us to honor each member and work together for good. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 19,
    "value": "<p><strong>Read:</strong> John 1:35-42; Mark 3:13-19</p><p><strong>Source and historical context:</strong> The “Heavenly Mail” game places clues inside envelopes so children can identify disciples. This segment recalls Andrew bringing someone to Jesus and James among those first called. It begins another sermon built around a candle and the account of Joseph.</p><p><strong>Devotional focus:</strong> Andrew’s simple invitation to Simon Peter becomes part of a much larger Gospel story. We do not have to know every answer to share what has helped us. The named disciples are not interchangeable trophies in a Bible quiz; they are people Jesus invited into fellowship and difficult growth. Learning their names can open conversation about their differing personalities and imperfect beginnings.</p><p><strong>Reflect:</strong> Who first invited you into something life-giving, and whom could you welcome without pressure?</p><p><strong>Practice:</strong> Read John 1:35–42 and write a note of thanks to a mentor or friend. Invite someone to join a conversation, meal, or Bible study while respecting their choice.</p><p><strong>Prayer:</strong> Jesus, thank you for those who have welcomed me. Make me a thoughtful friend whose invitations are gentle and genuine. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 20,
    "value": "<p><strong>Read:</strong> Genesis 45:1-15; Genesis 50:15-21</p><p><strong>Source and historical context:</strong> Woolston personifies a candle to tell the story of Joseph and his brothers, then compares an unburned and a nearly spent candle to encourage using life well. He introduces a nail-and-board illustration about lasting harm. These visual aids are the author’s storytelling choices rather than details from Genesis.</p><p><strong>Devotional focus:</strong> Joseph names his brothers’ wrongdoing and still moves toward preserving life. His forgiveness is not an excuse for betrayal or a command that every injured person reconcile immediately. It is an example of truthful mercy exercised with power and care. The candle metaphor also invites us to invest the life we have in acts that protect others, without shaming the old, ill, or disabled.</p><p><strong>Reflect:</strong> What would an honest, safe step toward mercy look like in a relationship marked by hurt?</p><p><strong>Practice:</strong> Read Joseph’s words and distinguish forgiveness, trust, and reconciliation in a short journal entry. If you have harmed someone, begin with accountability rather than demanding their immediate forgiveness.</p><p><strong>Prayer:</strong> God of mercy, help me face harm truthfully and refuse revenge. Guide my choices toward justice, healing, and wise peace. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 21,
    "value": "<p><strong>Read:</strong> James 3:5-10; Luke 19:1-10</p><p><strong>Source and historical context:</strong> Woolston’s nail-and-board demonstration uses holes left after nails are removed to represent effects of careless words or actions. The same imported day begins “The Buried Bible,” a chapter that imagines a Bible hidden under the ordinary demands of daily life. The nail exercise need not be performed with tools.</p><p><strong>Devotional focus:</strong> Words can leave lasting marks even after an apology. James calls attention to their power, while Zacchaeus shows repentance through restitution. The right response to harm is neither despair nor pretending the damage disappeared. It is naming what happened, making amends where possible, listening to the harmed person, and building different habits over time.</p><p><strong>Reflect:</strong> Have you confused saying “sorry” with fully listening to the effect of what happened?</p><p><strong>Practice:</strong> Without nails or hammers, draw a board with marks on paper. Choose one conversation that needs a truthful apology or one practical form of repair, respecting the other person’s boundaries.</p><p><strong>Prayer:</strong> Merciful Lord, guard my tongue and steady my actions. Give me humility to repair what I can and patience when trust takes time. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 22,
    "value": "<p><strong>Read:</strong> 2 Kings 22:8-13; Psalm 119:9-16</p><p><strong>Source and historical context:</strong> Woolston pictures the Bible covered by schoolbooks, entertainment, appointments, fashion plates, and business records. He alludes to Scripture rediscovered in the Temple. The book’s sharp contrasts reflect its period and should not imply that education, study, work, or leisure are enemies of faith.</p><p><strong>Devotional focus:</strong> In Josiah’s reign, finding the neglected book leads people to listen and reassess their lives. What matters is not that other books disappear, but that Scripture has space to challenge and encourage us. God does not ask us to abandon learning or employment to prove devotion. A sustainable habit can turn attention toward wisdom in the middle of ordinary responsibilities.</p><p><strong>Reflect:</strong> What reliably crowds out reflection in your week, and what small change could open some room?</p><p><strong>Practice:</strong> Choose a realistic five- or ten-minute time to read a short psalm. Do not punish yourself if you miss it; begin again and consider discussing the passage with a friend.</p><p><strong>Prayer:</strong> God who speaks through Scripture, help me make room to listen. Bless my studies and work, and guide me toward a thoughtful rhythm of rest and faith. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 23,
    "value": "<p><strong>Read:</strong> Luke 10:38-42; Colossians 3:15-17</p><p><strong>Source and historical context:</strong> The final paragraphs of “The Buried Bible” compare reading newspapers and attending to financial matters with reading Scripture. A story tells of a busy merchant whose son asks him to make time for the Bible. The next chapter introduces a Christmas candle story.</p><p><strong>Devotional focus:</strong> Martha’s many tasks are real and necessary, yet Jesus welcomes her to notice what Mary has chosen in that moment. The passage is not permission to demean work or impose religious time quotas. It invites us to pause and receive rather than always produce. Families can make room for Scripture and attention to one another without turning busyness into guilt.</p><p><strong>Reflect:</strong> Which routine could hold a small moment of rest and attention without neglecting your responsibilities?</p><p><strong>Practice:</strong> Make a gentle appointment with Scripture or shared conversation this week. Put away one distraction for a short period, then return to your ordinary work with renewed focus.</p><p><strong>Prayer:</strong> Lord, meet me amid crowded hours. Teach me to receive your words and to cherish the people beside me. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 24,
    "value": "<p><strong>Read:</strong> Luke 2:8-14; Matthew 25:34-40</p><p><strong>Source and historical context:</strong> Woolston closes with a story of a young girl keeping a Christmas candle in her window, noticed by a wealthy woman who arrives with gifts. A short evening benediction follows. The scene expresses an ideal of generous attention, though it is a story illustration rather than a documented Gospel event.</p><p><strong>Devotional focus:</strong> The angels announce good news for all people; Jesus later teaches that caring for those in need matters deeply to him. The richest part of the Christmas story is not the arrival of a benefactor but the dignity of the child who was seen and welcomed. No family should need to display poverty publicly to deserve care. Generosity is most faithful when it respects privacy, asks what is needed, and offers help without conditions.</p><p><strong>Reflect:</strong> Who might feel unseen this season, and how could you offer welcome without putting them on display?</p><p><strong>Practice:</strong> Create a paper candle or use a battery-operated light as a safe reminder. Share a meal, gift, or kind message discreetly, guided by what the recipient actually wants.</p><p><strong>Prayer:</strong> God of Christmas peace, help me notice those who feel forgotten. Let my gifts carry respect, warmth, and hope. Amen.</p>"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

-- Update each existing plan-level Scripture reference row without changing user-owned rows.
do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 1,
    "references": [
      "John 21:15-17",
      "Mark 10:13-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 2,
    "references": [
      "Matthew 18:1-5",
      "1 Corinthians 13:1-7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 3,
    "references": [
      "John 4:7-14",
      "Nehemiah 8:8-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 4,
    "references": [
      "Jeremiah 18:1-6",
      "Genesis 9:12-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 5,
    "references": [
      "James 1:19-20",
      "Colossians 3:12-14"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 6,
    "references": [
      "1 Samuel 3:1-10",
      "Psalm 34:17-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 7,
    "references": [
      "James 2:14-18",
      "Philippians 3:12-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 8,
    "references": [
      "Hebrews 10:24-25",
      "Acts 2:42-47"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 9,
    "references": [
      "1 Samuel 16:6-13",
      "John 3:16-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 10,
    "references": [
      "John 12:32-33",
      "Luke 2:8-20"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 11,
    "references": [
      "Luke 2:1-20",
      "Matthew 2:9-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 12,
    "references": [
      "Luke 12:15-21",
      "Luke 15:11-20"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 13,
    "references": [
      "Luke 15:17-24",
      "Ephesians 2:4-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 14,
    "references": [
      "Luke 15:25-32",
      "Romans 12:15-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 15,
    "references": [
      "1 John 1:7-9",
      "Ephesians 4:31-32"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 16,
    "references": [
      "John 10:27-30",
      "Romans 8:35-39"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 17,
    "references": [
      "Matthew 5:14-16",
      "Philippians 2:14-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 18,
    "references": [
      "1 Corinthians 12:14-27",
      "Proverbs 31:8-9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 19,
    "references": [
      "John 1:35-42",
      "Mark 3:13-19"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 20,
    "references": [
      "Genesis 45:1-15",
      "Genesis 50:15-21"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 21,
    "references": [
      "James 3:5-10",
      "Luke 19:1-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 22,
    "references": [
      "2 Kings 22:8-13",
      "Psalm 119:9-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 23,
    "references": [
      "Luke 10:38-42",
      "Colossians 3:15-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000392",
    "day_number": 24,
    "references": [
      "Luke 2:8-14",
      "Matthew 25:34-40"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
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
where id = '90000000-0000-0000-0000-000000000392'::uuid;

commit;
