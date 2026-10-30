-- Wave 26: Plan 328 — Dave Ranney (autobiographical memoir).
-- Thirty-two new Scripture-led readings drawn from the supplied source segments.
-- In-place updates retain existing IDs/day numbers/progress; publish after review.
-- Run AFTER all 2026-10-21 modernization migrations (especially parts 03 and 09).
-- No copyrighted modern Bible translation is reproduced.

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
  where id = '90000000-0000-0000-0000-000000000328'::uuid;
  if not found then raise exception 'Plan 328 missing'; end if;
  if current_source is distinct from 'https://www.gutenberg.org/ebooks/13889' or current_total is distinct from 32 then
    raise exception 'Plan 328 metadata differs from source reviewed for Wave 26';
  end if;
  select count(*), min(day_number), max(day_number), count(distinct day_number)
  into day_count, first_day, last_day, unique_days
  from public.devotional_days where plan_id = '90000000-0000-0000-0000-000000000328'::uuid;
  if day_count <> 32 or first_day <> 1 or last_day <> 32 or unique_days <> 32 then
    raise exception 'Plan 328 must contain 32 distinct numbered days; found %', day_count;
  end if;
end
$$;

update public.devotional_plans as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "From the Bowery to a Life of Service: 32 Readings from Dave Ranney"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Thirty-two newly written, Scripture-led devotional readings inspired by Dave Ranney’s autobiographical account of childhood, addiction, homelessness, conversion, work, family relationships, and mission service in New York. Historical claims are presented as personal testimony and interpreted with compassion, safeguarding, and respect for people experiencing hardship. This is a modern editorial adaptation, not a transcription of the memoir."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 1,
    "value": "What We Sow, What We Can Change"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 2,
    "value": "A Way Home After Fear"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 3,
    "value": "What Deserves Our Attention"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 4,
    "value": "The Moment Before a Wrong Choice"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 5,
    "value": "When Concealment Spreads"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 6,
    "value": "The Courage to Resist Pressure"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 7,
    "value": "A Mother’s Prayer and the Truth"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 8,
    "value": "Worth Is Not Lost in a Hard Season"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 9,
    "value": "Grief Without Self-Destruction"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 10,
    "value": "A Meal Instead of a Blow"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 11,
    "value": "Dignity Before Demands"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 12,
    "value": "Grace Opens a New Beginning"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 13,
    "value": "Small Steps Toward Stability"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 14,
    "value": "Kindness Opens Doors"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 15,
    "value": "A Different Answer to an Old Invitation"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 16,
    "value": "Repairing Relationships Takes Time"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 17,
    "value": "When Plans Scatter"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 18,
    "value": "Apologies and Grief Are Both Real"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 19,
    "value": "A Promise in the Midst of Loss"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 20,
    "value": "Speak Firmly, Act Peacefully"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 21,
    "value": "Shelter Is an Act of Welcome"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 22,
    "value": "Help Her Get to Safety"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 23,
    "value": "Do Not Give Up on the Missing"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 24,
    "value": "A Past That Can Serve Justice"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 25,
    "value": "The Coat and the Guest"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 26,
    "value": "Make Room for Someone’s Gifts"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 27,
    "value": "A Second Beginning Is Still a Beginning"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 28,
    "value": "Tools, Work, and Reconnection"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 29,
    "value": "See the Person Beyond the Label"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 30,
    "value": "Go with Someone Who Is Afraid"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 31,
    "value": "A Return Shaped by Mercy"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 32,
    "value": "A Life That Keeps the Door Open"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 1,
    "value": "<p><strong>Read:</strong> Galatians 6:7-10; Lamentations 3:22-23</p><p><strong>Source and historical context:</strong> Ranney begins his memoir with rival childhood neighborhoods, his mother’s concern, early exposure to alcohol, and regret about later years. He writes from the perspective of someone looking back on his choices, not from the viewpoint of a child who could foresee his future.</p><p><strong>Devotional focus:</strong> Small decisions do shape us, but no one is reducible to the worst pattern they learned. The call to sow what is good invites us to tend habits, relationships, and the people whose lives our choices touch. God’s mercies also meet us when the past cannot be undone. Responsibility and hope belong together: we can name real harm without deciding that a person’s future is already lost.</p><p><strong>Reflect:</strong> Which small habit is shaping my relationships, and which hopeful habit could I begin today?</p><p><strong>Practice:</strong> Choose one ordinary act of honesty or care you can repeat this week. If an old pattern is hard to change, identify someone safe who can support you.</p><p><strong>Prayer:</strong> Merciful God, teach me to take my choices seriously without giving up on your power to renew a life. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 2,
    "value": "<p><strong>Read:</strong> Psalm 34:17-18; Luke 15:20-24</p><p><strong>Source and historical context:</strong> Skipping school leads young Dave to the river, where another boy drowns. Later, frightened of punishment, he runs away with Mike, sleeps in a haystack, and returns to a family afraid he had died. These are recollections of danger and grief, not proof that tragedy was God’s punishment.</p><p><strong>Devotional focus:</strong> Fear can make an already difficult situation more dangerous. When a young person hides trouble, what they need most is a safe path toward help and truth. In the story, the family’s relief at Dave’s return speaks louder than a threatened whipping. God’s welcome calls us to be people to whom the frightened can come, and to seek help before a crisis grows.</p><p><strong>Reflect:</strong> Am I making it easier or harder for someone to admit a mistake and ask for help?</p><p><strong>Practice:</strong> Reassure someone in your care that telling the truth will be met with listening. If you are afraid to go home or face someone, contact a safe, trusted adult or support person.</p><p><strong>Prayer:</strong> God of refuge, help frightened people find safety and give me a welcoming heart. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 3,
    "value": "<p><strong>Read:</strong> Philippians 4:8-9; Proverbs 4:23</p><p><strong>Source and historical context:</strong> Ranney remembers improvising clothes so he could play baseball despite being kept home, then warns against the sensational adventure stories he once devoured. His dismissal of an entire kind of fiction reflects his opinion and era.</p><p><strong>Devotional focus:</strong> Our attention is precious. Games and stories can bring imagination and joy, while certain patterns of consumption leave us agitated, dishonest, or careless. The question is not whether every adventure is corrupting; it is whether what we repeatedly choose helps us become truthful, considerate, and wise. Wisdom learns to examine its influences rather than simply ban whatever seems unfamiliar.</p><p><strong>Reflect:</strong> What do my favorite entertainments produce in my speech, mood, and treatment of others?</p><p><strong>Practice:</strong> Notice how one program, game, or reading habit affects you today. Keep what nourishes your life and set a thoughtful limit on what does not.</p><p><strong>Prayer:</strong> Lord, guide my attention toward things that deepen wisdom, joy, and love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 4,
    "value": "<p><strong>Read:</strong> James 1:13-15; Proverbs 28:13</p><p><strong>Source and historical context:</strong> At his first office job, Dave begins taking cigars. Later he secretly takes a wage check his mother had put away, feels troubled, and cashes it. He recalls moments when he could have stopped and told the truth.</p><p><strong>Devotional focus:</strong> Moral failure rarely arrives without a moment of decision. We may explain away a small act, then work harder to hide what follows. Yet conscience can be an invitation to turn back rather than a sentence of permanent disgrace. Confession is not merely feeling guilty; it means naming what happened, making what repair is possible, and learning to choose differently.</p><p><strong>Reflect:</strong> Is there a small dishonesty I am protecting because I am afraid of what truth will cost?</p><p><strong>Practice:</strong> Tell the truth to the appropriate person where it is safe to do so. Identify a practical step of repair, such as returning something or correcting a misleading statement.</p><p><strong>Prayer:</strong> God of truth, give me courage to stop hiding and strength to make things right. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 5,
    "value": "<p><strong>Read:</strong> Ephesians 4:25-28; Psalm 51:6-12</p><p><strong>Source and historical context:</strong> Dave pretends to help search for the check he has already cashed. In the same period, he takes money from his grandfather, loses one office position, and receives another opportunity to work. His account mixes remorse with descriptions of employers who showed trust.</p><p><strong>Devotional focus:</strong> One deception can pull more people into its consequences. The cost is not only money but trust: a mother searches, a family worries, and a worker loses credibility. Still, a new opportunity need not erase accountability, and accountability need not forbid a new start. God invites honesty that is practical enough to rebuild trust, even when rebuilding takes time.</p><p><strong>Reflect:</strong> Where has keeping up an appearance cost more than a truthful apology would?</p><p><strong>Practice:</strong> Write a simple account of one unresolved wrong: what happened, who was affected, and what proportionate repair is possible now. Seek guidance before a difficult disclosure.</p><p><strong>Prayer:</strong> Holy God, make me honest in private and faithful with the trust others place in me. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 6,
    "value": "<p><strong>Read:</strong> 1 Corinthians 10:12-13; Proverbs 13:20</p><p><strong>Source and historical context:</strong> At a new job, Dave meets Mike again, visits a saloon, and drinks when others ridicule his hesitation. His drinking and gambling begin to undermine work. The memoir presents this as a painful turning point in a longer story.</p><p><strong>Devotional focus:</strong> Belonging matters, which is why mockery can be so powerful. Courage is not the absence of longing to fit in; it is finding a different response when the crowd pushes us toward harm. For people dealing with dependence, choosing differently may also require sustained professional care, community, and a recovery plan. Faith can strengthen that effort without replacing needed help.</p><p><strong>Reflect:</strong> Whose approval makes it difficult for me to honor my values or limits?</p><p><strong>Practice:</strong> Prepare one sentence you can use when pressured into something harmful. Identify a trustworthy friend or support group that will respect your boundaries.</p><p><strong>Prayer:</strong> Lord, give me wise companions and courage to choose life when pressure is loud. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 7,
    "value": "<p><strong>Read:</strong> James 5:16; John 8:31-32</p><p><strong>Source and historical context:</strong> After a night of drinking, Dave awakens to his mother praying beside him. He later lies to an employer about missing work and loses the job; his evasions at home continue. His mother’s love and his concealment appear side by side.</p><p><strong>Devotional focus:</strong> Prayer and truth belong together. A loved one may pray faithfully while the person they love remains tangled in mistakes. Such care is not wasted, but neither does it give anyone control over another person’s choices. Truth can feel costly when we fear disappointing people; nevertheless, honest conversation creates a real starting point for help and repair.</p><p><strong>Reflect:</strong> Is there a person whose concern I have answered with evasion rather than honesty?</p><p><strong>Practice:</strong> Thank someone who has cared for you without demanding perfection. Where safe, replace one excuse with a clear and truthful account of what you need.</p><p><strong>Prayer:</strong> God, hear the prayers of worried families and lead us into truth without shame or coercion. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 8,
    "value": "<p><strong>Read:</strong> Psalm 139:13-18; Isaiah 61:1-3</p><p><strong>Source and historical context:</strong> Ranney describes theft, arrest, work found and lost, a brief marriage marked by addiction and hardship, and years of drifting between towns. His memoir includes the suffering of his wife and family as well as his own.</p><p><strong>Devotional focus:</strong> Destructive choices have consequences for others; love must not excuse neglect or make an injured spouse responsible for saving someone. At the same time, a person who has harmed relationships or lost stable work has not lost human dignity. Renewal requires accountability, safe boundaries for those affected, and patient steps toward a different pattern.</p><p><strong>Reflect:</strong> How can I acknowledge the impact of someone’s actions without denying anyone’s dignity?</p><p><strong>Practice:</strong> Consider one neglected responsibility or relationship. Choose an accountable next step and respect the boundaries of people who have been hurt.</p><p><strong>Prayer:</strong> God of justice and mercy, help me face harm clearly and honor the safety of everyone involved. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 9,
    "value": "<p><strong>Read:</strong> Psalm 147:3; Romans 8:38-39</p><p><strong>Source and historical context:</strong> Dave remembers his mother pleading with him while seriously ill. After her death, he describes drinking through the funeral, wandering, imprisonment, and promises made during confinement that did not last.</p><p><strong>Devotional focus:</strong> Grief can expose how little control we have over the past. Regret is real, but it cannot tell the whole story of a relationship or establish that one person caused another’s death. God’s compassion meets mourners, including those who struggle with addiction or shame. Healing may involve grief support, treatment, repentance, and repeated attempts rather than one dramatic moment.</p><p><strong>Reflect:</strong> What regret about someone I have lost needs to be spoken with greater gentleness and truth?</p><p><strong>Practice:</strong> Name one person or community that can help you carry sorrow. If grief is bringing harmful urges, reach out for support before facing them alone.</p><p><strong>Prayer:</strong> Compassionate Lord, hold those who mourn and help us seek care instead of hiding in shame. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 10,
    "value": "<p><strong>Read:</strong> Matthew 25:35-40; Romans 12:20-21</p><p><strong>Source and historical context:</strong> By autumn 1892, Ranney says he is homeless and hungry on the Bowery. Planning to rob someone, he instead meets a man who offers him dinner and an invitation to a mission gathering. A simple act interrupts a dangerous encounter.</p><p><strong>Devotional focus:</strong> A stranger’s hunger is not an invitation to judge them by clothing or reputation. Mercy may begin with a meal, a question, and attention to someone’s immediate need. Ranney later credits these gestures with opening a path he had not imagined. Meeting material needs is not merely a strategy for changing people; it is a worthy act of care in its own right.</p><p><strong>Reflect:</strong> When have I overlooked a practical need because I was focused on someone’s past or appearance?</p><p><strong>Practice:</strong> Offer an appropriate meal, resource, or respectful conversation through a trusted local service. Do so without attaching conditions to the person’s dignity.</p><p><strong>Prayer:</strong> Jesus, teach me to see need clearly and answer it with compassionate action. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 11,
    "value": "<p><strong>Read:</strong> Luke 10:33-37; James 2:14-17</p><p><strong>Source and historical context:</strong> At the mission, Alexander Irvine invites Dave to bathe, gives him clean clothes, listens to his story, and only then speaks about faith. Dave is suspicious because people with his arrest record rarely received such trust.</p><p><strong>Devotional focus:</strong> Care is more believable when it does something tangible. A person facing homelessness may need a safe place, clothing, food, privacy, and patient listening before they can think about anything else. The kindness of Christ does not ask people to prove that they deserve help. We are called to offer assistance that preserves choice, dignity, and trust.</p><p><strong>Reflect:</strong> Do I expect vulnerable people to earn respect before I offer practical kindness?</p><p><strong>Practice:</strong> Identify one local service or ministry meeting basic needs. Support it with time, supplies, or money, and listen to the people it serves rather than assuming what they need.</p><p><strong>Prayer:</strong> Jesus, make my faith visible in respectful, practical love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 12,
    "value": "<p><strong>Read:</strong> John 3:16-17; 2 Corinthians 5:17-19</p><p><strong>Source and historical context:</strong> Alexander Irvine invites Ranney to pray. Dave describes rising with unexpected peace, choosing to seek a sober life, and beginning a long friendship with Irvine. This is the central conversion episode in his own testimony.</p><p><strong>Devotional focus:</strong> Grace does not require a polished history. Christianity announces that God meets people while their need is real and calls them into a new life. Ranney’s turning point matters, but a testimony should not become a rule that every person’s recovery must be instant. Faith, supportive relationships, practical work, and ongoing care can belong to the same process of change.</p><p><strong>Reflect:</strong> Where do I need to receive God’s welcome without pretending I have already finished growing?</p><p><strong>Practice:</strong> Write a short prayer of trust and one concrete next step toward health or reconciliation. Invite a safe person to accompany you in that step.</p><p><strong>Prayer:</strong> Lord Jesus, thank you that your grace welcomes us and calls us toward a hopeful future. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 13,
    "value": "<p><strong>Read:</strong> Colossians 3:23-24; Galatians 6:9</p><p><strong>Source and historical context:</strong> Irvine pays for a week of lodging and food and helps Dave find modest work tending a furnace. Dave feels frustrated by low pay, yet a recommendation, consistent work, and help with meals allow him to begin rebuilding.</p><p><strong>Devotional focus:</strong> After a major change, ordinary work can seem disappointingly slow. But reliability is built through many small actions: showing up, learning, accepting assistance, and taking the next step. No job determines anyone’s worth, and no one should be expected to accept exploitation as a spiritual duty. Still, steady opportunities and fair support can help someone regain stability and confidence.</p><p><strong>Reflect:</strong> Am I dismissing a small but meaningful beginning because it does not look impressive yet?</p><p><strong>Practice:</strong> Identify the next manageable step in an important commitment. Thank one person who makes your progress possible, and offer that support to someone else when you can.</p><p><strong>Prayer:</strong> God, bless honest work, fair opportunity, and the patience to grow one step at a time. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 14,
    "value": "<p><strong>Read:</strong> Proverbs 19:17; 1 Peter 4:10</p><p><strong>Source and historical context:</strong> After harassment in a crowded lodging house, Dave helps deliver Thanksgiving meals. Mrs. Bainbridge arranges a needed winter coat. Later, experience from earlier lumber work helps him find a new job after delivering telephone directories.</p><p><strong>Devotional focus:</strong> Hospitality is often concrete: warm clothing, a meal, a fair introduction, or the chance to use a skill that someone has overlooked. These gifts do not erase a person’s effort; they make effort possible. The memoir also recalls retaliating against harassment, which is not a model for peaceful conflict resolution. We can protect ourselves and others without reproducing harm.</p><p><strong>Reflect:</strong> Which practical kindness made a difference for me when I was struggling?</p><p><strong>Practice:</strong> Offer useful clothing, a reliable work lead, or a warm introduction through an appropriate channel. If you face harassment, seek safe support rather than revenge.</p><p><strong>Prayer:</strong> Generous God, show me how to make room for others through thoughtful, tangible care. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 15,
    "value": "<p><strong>Read:</strong> Titus 2:11-12; 1 Corinthians 10:13</p><p><strong>Source and historical context:</strong> Working at a lumberyard, Dave faces repeated invitations to drink during difficult physical labor. He eventually explains his decision to his coworkers and later offers food and encouragement to men he knew from those days.</p><p><strong>Devotional focus:</strong> Old habits can reappear in familiar places, especially when exhaustion and social pressure meet. A boundary becomes stronger when we can explain it without shaming other people. Saying no can be an act of freedom. People facing substance dependence may need a fuller plan involving evidence-based care and trusted support; spiritual resolve need not carry the entire burden alone.</p><p><strong>Reflect:</strong> Where do familiar circumstances weaken a boundary I need to protect?</p><p><strong>Practice:</strong> Practice a courteous refusal and arrange a safer alternative for one triggering situation. Encourage someone trying to change without policing their progress.</p><p><strong>Prayer:</strong> Lord, steady my choices and make me compassionate toward others facing hard patterns. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 16,
    "value": "<p><strong>Read:</strong> Ephesians 4:31-32; Luke 15:20-24</p><p><strong>Source and historical context:</strong> Irvine asks Ranney to serve at the Sea and Land Church. Dave explains that his wife Mary has suffered during their marriage; she must decide whether to rejoin him. The family eventually reunites, including a son Dave had barely known, and he begins church work.</p><p><strong>Devotional focus:</strong> Reconciliation can be beautiful, but it cannot be demanded from the person who was hurt. Changed conduct, patient trust-building, consent, and a safe environment matter more than a moving reunion scene. Ranney’s joy in knowing his son shows what a renewed commitment can make possible. Christ’s love calls us to become trustworthy, not simply to ask others to forget the past.</p><p><strong>Reflect:</strong> Where might I need to prove change over time rather than seek immediate reassurance?</p><p><strong>Practice:</strong> Choose an action that demonstrates dependability. Honor another person’s right to take time, set limits, or decline reconciliation.</p><p><strong>Prayer:</strong> Father, teach me to rebuild what I can with humility and respect for the choices of others. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 17,
    "value": "<p><strong>Read:</strong> 2 Corinthians 12:9-10; 1 Corinthians 2:1-5</p><p><strong>Source and historical context:</strong> Preparing to lead a church meeting, Dave relies on written notes. A gust from an opened window scatters the pages, and he speaks instead about his life and faith. He later recalls a friend whose experiences at the mission were complicated by an argument.</p><p><strong>Devotional focus:</strong> We sometimes confuse being prepared with being in control. Good preparation is valuable, yet an unexpected interruption can remind us that humility matters more than performance. A truthful story told with care may help people where polished words do not. The test of a witness is not dramatic delivery but whether speech and life point toward love, integrity, and grace.</p><p><strong>Reflect:</strong> How do I react when my plans fail in front of other people?</p><p><strong>Practice:</strong> Prepare for one responsibility carefully, then allow room for honest words and flexibility. If you have spoken harshly to someone, consider making an apology.</p><p><strong>Prayer:</strong> God, use even my awkward moments to teach me humility and truthful love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 18,
    "value": "<p><strong>Read:</strong> Romans 12:15-18; Psalm 34:18</p><p><strong>Source and historical context:</strong> A former companion recounts a painful argument with Ranney and later publicly apologizes. The narrative then shifts to Mary’s serious illness and death, with Dave describing anger, temptation, and distress as he mourns.</p><p><strong>Devotional focus:</strong> An apology can help mend a relationship even when two people disagree about faith. And grief can make ordinary problems feel unbearable; it does not reveal a failure of belief. The compassionate response is to listen, protect relationships from retaliation, and sit with sorrow. God’s nearness is not measured by whether grief quickly disappears.</p><p><strong>Reflect:</strong> What unfinished apology or unacknowledged sorrow might need gentle attention?</p><p><strong>Practice:</strong> Offer a sincere apology without expecting an immediate response. Make space for someone who is grieving, without explaining away their pain.</p><p><strong>Prayer:</strong> Lord, help me seek peace where I have caused hurt, and stay near to those who mourn. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 19,
    "value": "<p><strong>Read:</strong> Psalm 46:1-3; Galatians 6:2</p><p><strong>Source and historical context:</strong> On the day of Mary’s funeral in March 1902, Dave and his son speak about fears he might start drinking again. They pray together, and he promises to pursue sobriety. He later steps away from church employment as the memories remain painful.</p><p><strong>Devotional focus:</strong> A difficult anniversary can awaken old urges and fears. In this scene, a son does not cure his father’s grief; instead, they name a shared concern and seek help. Recovery is strengthened by honest relationships and practical plans, especially in seasons of loss. Changing roles or leaving a place associated with grief can also be a thoughtful response, not a defeat.</p><p><strong>Reflect:</strong> Who can I turn to when grief makes old habits or fears return?</p><p><strong>Practice:</strong> Make a simple support plan for difficult days: people to call, safe places, and help you can request. Offer companionship without making yourself responsible for someone else’s recovery.</p><p><strong>Prayer:</strong> God of refuge, be with families in sorrow and guide us toward support that helps life continue. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 20,
    "value": "<p><strong>Read:</strong> James 1:19-20; Matthew 5:9</p><p><strong>Source and historical context:</strong> Before Mary’s death, Ranney helps run a Chinatown mission in New York. At one crowded gathering he strikes a disruptive man and later praises the action as a way of gaining the audience’s respect.</p><p><strong>Devotional focus:</strong> Passion for a good cause does not excuse violence. A gathering needs safety, clear boundaries, and care for everyone present, including an agitated person. Ranney’s courage and his familiarity with the neighborhood are important parts of his story; his punch is not a pattern Christians should copy. Jesus calls peacemakers blessed, and anger must be governed by wisdom and restraint.</p><p><strong>Reflect:</strong> How do I respond when someone challenges my authority or disrupts my plans?</p><p><strong>Practice:</strong> Think through a nonviolent safety response for a tense situation: calm words, distance, support from others, and appropriate trained help when needed.</p><p><strong>Prayer:</strong> Prince of Peace, keep my convictions strong and my actions gentle and safe. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 21,
    "value": "<p><strong>Read:</strong> Isaiah 58:6-10; Hebrews 13:1-3</p><p><strong>Source and historical context:</strong> The mission hosts many people without a safe place to sleep. Dave sometimes keeps it open overnight, offering warmth and a floor or chair; he recalls both gratitude and objections from health officials. The section then shifts to people living in difficult social conditions.</p><p><strong>Devotional focus:</strong> Compassion sees the cold before it evaluates a person’s reputation. Warmth, rest, and shelter are urgent needs, not prizes for good behavior. Yet protecting people also means providing safe, healthy accommodations. We can honor Ranney’s impulse to welcome strangers while recognizing that a humane community needs sustainable, safe housing and support beyond one room.</p><p><strong>Reflect:</strong> Do I see people without housing first as neighbors or as problems to solve?</p><p><strong>Practice:</strong> Support a reputable shelter or housing service and learn what resources are most needed. Offer help in ways that preserve safety and dignity.</p><p><strong>Prayer:</strong> God who welcomes strangers, stir us to create safe places of rest and belonging. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 22,
    "value": "<p><strong>Read:</strong> Proverbs 31:8-9; Luke 10:33-37</p><p><strong>Source and historical context:</strong> At a Bowery entertainment venue, a distressed young woman named Annie describes being deceived and trapped in exploitation. Ranney and a visitor contact her aunt, arrange travel, and help her leave. Later, a man approaches Dave about his own missing sister.</p><p><strong>Devotional focus:</strong> A person caught in exploitation needs to be believed, treated with dignity, and offered real choices. The focus belongs on those using threats and deception, not on blaming the person targeted. In the memoir, practical help involves listening, contacting someone Annie trusts, and accompanying her toward safety. Today such situations also call for qualified safeguarding and survivor-centered services.</p><p><strong>Reflect:</strong> When someone describes danger, do I listen first or question why they became vulnerable?</p><p><strong>Practice:</strong> Learn how to contact a trusted local anti-trafficking or safeguarding organization. If a person discloses exploitation, prioritize their immediate safety and wishes, and avoid confrontations that raise risk.</p><p><strong>Prayer:</strong> God of justice, protect people facing exploitation and make us wise, respectful helpers. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 23,
    "value": "<p><strong>Read:</strong> Psalm 10:14-18; Romans 12:15</p><p><strong>Source and historical context:</strong> After hearing the account of Annie’s escape, a minister tells Ranney about his sister, who disappeared years earlier, and asks him to keep watch for news. This brief segment offers no resolution to her disappearance.</p><p><strong>Devotional focus:</strong> Some families live with unanswered questions for years. Their sorrow deserves companionship, not a quickly invented happy ending. Being faithful may mean remembering a name, sharing information responsibly, and staying present when answers do not come. Christian hope does not require pretending we know what happened or promising a reunion we cannot guarantee.</p><p><strong>Reflect:</strong> Who is carrying unresolved grief that I could accompany without offering easy explanations?</p><p><strong>Practice:</strong> Reach out to someone living with loss or uncertainty. Listen, ask what practical help would be welcome, and avoid speculation or spreading unverified information.</p><p><strong>Prayer:</strong> Lord of mercy, remember missing people and comfort those who still search and wait. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 24,
    "value": "<p><strong>Read:</strong> Proverbs 31:8-9; 2 Corinthians 5:18-20</p><p><strong>Source and historical context:</strong> Ranney returns to serve in Bowery missions and describes helping people who knew him from his earlier life. When a former prisoner is accused of robbery, Dave testifies about what he personally knows of the man’s whereabouts.</p><p><strong>Devotional focus:</strong> People can change, and their past should not cancel their right to fairness. Genuine advocacy does not require exaggeration: we speak to what we know, respect evidence, and seek due process. Ranney sees meaning in being able to stand in court as someone whose character others now trust. A restored reputation becomes most valuable when used to defend another person’s dignity.</p><p><strong>Reflect:</strong> Can I speak up for someone who is judged only by an old label?</p><p><strong>Practice:</strong> In one conversation, challenge a dismissive label with accurate, respectful language. Where justice is involved, support truthful testimony and fair procedures.</p><p><strong>Prayer:</strong> Righteous God, let my words serve truth, justice, and the dignity of my neighbors. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 25,
    "value": "<p><strong>Read:</strong> Matthew 25:36-40; James 2:1-5</p><p><strong>Source and historical context:</strong> At a mission meeting, a man without a coat receives one from a visitor. Ranney later learns the generous stranger is a French count studying charitable work, and the visitor provides food for many at the mission.</p><p><strong>Devotional focus:</strong> The gift matters before the giver’s title becomes known. A coat protects someone from the cold whether it comes from a noble, a neighbor, or a stranger. Jesus warns against ranking people by status and calls us to care for those in need. Generosity is strongest when the person receiving help is seen as a fellow human being, not as a prop in a public story.</p><p><strong>Reflect:</strong> Would I value an act of kindness differently if the giver had no title or recognition?</p><p><strong>Practice:</strong> Offer useful supplies or a contribution to a trusted community resource without seeking credit. Ask what recipients actually need.</p><p><strong>Prayer:</strong> Generous Jesus, teach me to honor the one who receives help as much as the one who gives it. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 26,
    "value": "<p><strong>Read:</strong> 1 Peter 4:10-11; Romans 12:4-8</p><p><strong>Source and historical context:</strong> Ranney befriends a musician whose drinking has disrupted his life and who begins contributing music to mission gatherings. He also describes meeting an employed father after a street meeting and trying to help him reconsider his choices.</p><p><strong>Devotional focus:</strong> A person is more than the struggle currently visible. Skill, memory, creativity, and hope can remain present through hardship. Helping someone recover a place to contribute can be as important as meeting immediate needs. But a helper must not turn another person into a success story on demand; patient support respects their agency and circumstances.</p><p><strong>Reflect:</strong> Whose talents have I stopped noticing because I focus only on their difficulties?</p><p><strong>Practice:</strong> Invite someone to share a skill or interest in a safe, respectful setting. Listen to what kind of support they want before proposing a solution.</p><p><strong>Prayer:</strong> Creator God, help me see the gifts in every person and make room for them to flourish. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 27,
    "value": "<p><strong>Read:</strong> Lamentations 3:22-23; Galatians 6:1-2</p><p><strong>Source and historical context:</strong> Ranney speaks about alcohol’s harm to a man’s family, then turns to Jim, a skilled bricklayer separated from his wife and children. Jim comes forward at a mission but slips back into drinking before returning to seek help again.</p><p><strong>Devotional focus:</strong> A setback can be painful without proving that the person’s desire to change was false. The call to restore gently means resisting contempt and keeping pathways to support open. Relationships may need boundaries and professional treatment may be necessary. People deserve encouragement grounded in realistic care, not public pressure or promises that one attempt will solve everything.</p><p><strong>Reflect:</strong> How can I support change without turning a setback into a verdict on someone’s character?</p><p><strong>Practice:</strong> Replace one judgmental phrase with a compassionate question. Help identify a next step, whether practical assistance, peer support, or professional care.</p><p><strong>Prayer:</strong> God of new mercies, give us patience to begin again and love that does not shame the struggling. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 28,
    "value": "<p><strong>Read:</strong> James 2:15-17; 1 John 3:16-18</p><p><strong>Source and historical context:</strong> When Jim sustains a period of sobriety, Dave helps recover his pawned work tools and find a bricklaying job. Jim saves money, reaches out to his wife, and the family eventually reconnects. The memoir presents these as important practical supports.</p><p><strong>Devotional focus:</strong> Hope becomes tangible through tools, work, honest communication, and stable relationships. Faithful care asks not only what someone believes but what they need to live safely and responsibly. Reconciliation with family must remain voluntary, especially when past conduct has caused harm. No one should have to return to an unsafe situation to validate another person’s recovery.</p><p><strong>Reflect:</strong> What practical obstacle could I help remove without taking away another person’s choice?</p><p><strong>Practice:</strong> Consider donating tools, mentoring, supporting employment access, or helping someone connect with a legitimate service. Respect privacy and any family member’s boundaries.</p><p><strong>Prayer:</strong> God, let our love take practical shape, and help every home seek safety and trust. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 29,
    "value": "<p><strong>Read:</strong> Isaiah 58:7-11; Luke 15:1-7</p><p><strong>Source and historical context:</strong> Ranney describes overcrowded Bowery lodging houses and people who had once held respected positions. At the Squirrel Inn he offers food and lodging assistance; he recounts helping a man living with anger over a long-ago injury, then meeting a young worker in distress.</p><p><strong>Devotional focus:</strong> A neighborhood’s reputation is never the full story of its residents. Homelessness is shaped by many circumstances, not by a single moral cause. Listening well means seeing the individual with a history, gifts, and needs. Forgiveness may help heal resentment, but it does not erase injustice or require renewed contact with someone who harmed us.</p><p><strong>Reflect:</strong> Whose humanity have I hidden behind words like failure, addict, or outsider?</p><p><strong>Practice:</strong> Speak about someone facing hardship without reducing them to a label. Support material help alongside opportunities for their voice to be heard.</p><p><strong>Prayer:</strong> God of steadfast love, teach me to recognize the dignity you give every neighbor. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 30,
    "value": "<p><strong>Read:</strong> Luke 15:20-24; Ecclesiastes 4:9-10</p><p><strong>Source and historical context:</strong> A young man who left his job becomes stranded after spending his money. Ranney offers lodging and accompanies him home, where his family welcomes him. He then begins a longer account of another young man, Tom, drawn toward New York by promises of easy pleasure.</p><p><strong>Devotional focus:</strong> Sometimes the hardest part of returning is facing people we fear we disappointed. Companionship can make that first step possible, but it should be offered only when home is safe. Ranney’s story highlights the value of going alongside someone rather than merely giving instructions. When we welcome people back, patience and safety are more useful than a speech about their mistakes.</p><p><strong>Reflect:</strong> Who may need accompaniment more than advice right now?</p><p><strong>Practice:</strong> Offer to accompany someone to a safe, meaningful appointment or conversation. Do not push them toward an unsafe home or relationship.</p><p><strong>Prayer:</strong> Father of compassion, give us courage to ask for help and grace to accompany one another. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 31,
    "value": "<p><strong>Read:</strong> Luke 15:17-24; Micah 6:8</p><p><strong>Source and historical context:</strong> The story of Tom continues: he loses money and housing in New York, visits a mission, and begins writing home with Ranney’s help. After months, Tom’s father provides money for a return. Ranney presents this as a prodigal-son story and later reports Tom rebuilding his life.</p><p><strong>Devotional focus:</strong> Jesus’ parable centers on a father who runs to embrace his child. The point is not that hunger and humiliation are useful punishments; no one should be deprived of basic care to teach a lesson. Honest responsibility and safe restoration can go together. A person returning from a hard season needs welcome, material support, and room to grow rather than endless reminders of failure.</p><p><strong>Reflect:</strong> Am I withholding compassion until someone has suffered enough to deserve it?</p><p><strong>Practice:</strong> Offer help that meets immediate needs while also supporting long-term stability. If reconciliation is possible and safe, lead with listening and welcome.</p><p><strong>Prayer:</strong> Loving Father, free me from pride and teach me to welcome others with generous mercy. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 32,
    "value": "<p><strong>Read:</strong> Philippians 1:6; Hebrews 13:1-2</p><p><strong>Source and historical context:</strong> In his closing pages, Ranney encounters a police officer who remembers his arrests and recalls being treated suspiciously in Atlantic City. Later he returns there to speak publicly. He ends by inviting readers to visit him at the Squirrel Inn mission.</p><p><strong>Devotional focus:</strong> A person may carry the memory of an old label long after their life has changed. Our task is not to deny history but to let truth, accountability, and new conduct shape the present. Ranney closes not by claiming perfection but by keeping a door open to people who need welcome. The most convincing testimony is often a place at the table and a willingness to serve.</p><p><strong>Reflect:</strong> What door of belonging could I open to someone others have written off?</p><p><strong>Practice:</strong> Reach out to a person who may feel excluded, and offer specific, respectful welcome. Keep that invitation free of pressure or demands for a dramatic story.</p><p><strong>Prayer:</strong> Lord, continue your good work in us, and make our homes and communities places of welcome. Amen.</p>"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

-- Update only global (plan-level) Scripture references. Never alter user-owned notes.
do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 1,
    "references": [
      "Galatians 6:7-10",
      "Lamentations 3:22-23"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 2,
    "references": [
      "Psalm 34:17-18",
      "Luke 15:20-24"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 3,
    "references": [
      "Philippians 4:8-9",
      "Proverbs 4:23"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 4,
    "references": [
      "James 1:13-15",
      "Proverbs 28:13"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 5,
    "references": [
      "Ephesians 4:25-28",
      "Psalm 51:6-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 6,
    "references": [
      "1 Corinthians 10:12-13",
      "Proverbs 13:20"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 7,
    "references": [
      "James 5:16",
      "John 8:31-32"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 8,
    "references": [
      "Psalm 139:13-18",
      "Isaiah 61:1-3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 9,
    "references": [
      "Psalm 147:3",
      "Romans 8:38-39"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 10,
    "references": [
      "Matthew 25:35-40",
      "Romans 12:20-21"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 11,
    "references": [
      "Luke 10:33-37",
      "James 2:14-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 12,
    "references": [
      "John 3:16-17",
      "2 Corinthians 5:17-19"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 13,
    "references": [
      "Colossians 3:23-24",
      "Galatians 6:9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 14,
    "references": [
      "Proverbs 19:17",
      "1 Peter 4:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 15,
    "references": [
      "Titus 2:11-12",
      "1 Corinthians 10:13"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 16,
    "references": [
      "Ephesians 4:31-32",
      "Luke 15:20-24"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 17,
    "references": [
      "2 Corinthians 12:9-10",
      "1 Corinthians 2:1-5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 18,
    "references": [
      "Romans 12:15-18",
      "Psalm 34:18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 19,
    "references": [
      "Psalm 46:1-3",
      "Galatians 6:2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 20,
    "references": [
      "James 1:19-20",
      "Matthew 5:9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 21,
    "references": [
      "Isaiah 58:6-10",
      "Hebrews 13:1-3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 22,
    "references": [
      "Proverbs 31:8-9",
      "Luke 10:33-37"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 23,
    "references": [
      "Psalm 10:14-18",
      "Romans 12:15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 24,
    "references": [
      "Proverbs 31:8-9",
      "2 Corinthians 5:18-20"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 25,
    "references": [
      "Matthew 25:36-40",
      "James 2:1-5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 26,
    "references": [
      "1 Peter 4:10-11",
      "Romans 12:4-8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 27,
    "references": [
      "Lamentations 3:22-23",
      "Galatians 6:1-2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 28,
    "references": [
      "James 2:15-17",
      "1 John 3:16-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 29,
    "references": [
      "Isaiah 58:7-11",
      "Luke 15:1-7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 30,
    "references": [
      "Luke 15:20-24",
      "Ecclesiastes 4:9-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 31,
    "references": [
      "Luke 15:17-24",
      "Micah 6:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "day_number": 32,
    "references": [
      "Philippians 1:6",
      "Hebrews 13:1-2"
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
where id = '90000000-0000-0000-0000-000000000328'::uuid;

commit;
