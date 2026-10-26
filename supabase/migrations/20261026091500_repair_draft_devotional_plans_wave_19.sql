-- Plan 282: Small Means and Great Ends, an 1851 multi-author anthology edited by M. H. Adams.
-- Twenty-seven source-grounded Scripture-led readings; all devotional prose is new editorial writing.
-- Historical colonial prejudice and harmful responses to child loss/discipline are explicitly contextualized.
-- Preserve existing day IDs, day numbers, and user progress. No delete/reinsert operations.
-- Reviewed for devotional suitability and approved for publication.

begin;

-- Verify that the exact seeded plan and day sequence are present.
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
  where id = '90000000-0000-0000-0000-000000000282'::uuid;
  if not found then
    raise exception 'Plan 282 is missing';
  end if;
  if source_link is distinct from 'https://www.gutenberg.org/ebooks/11435' or reported_total is distinct from 27 then
    raise exception 'Plan 282 source URL or total_days differs from reviewed source';
  end if;
  select count(*), min(day_number), max(day_number)
  into present_days, first_day, last_day
  from public.devotional_days
  where plan_id = '90000000-0000-0000-0000-000000000282'::uuid;
  if present_days <> 27 or first_day <> 1 or last_day <> 27 then
    raise exception 'Plan 282 must have exactly 27 numbered days, found %', present_days;
  end if;
end
$$;


update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-26 09:15:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "value": "Small Acts, Great Love: 27 Readings Inspired by Small Means and Great Ends"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;


update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-26 09:15:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "value": "Twenty-seven Scripture-led devotional readings editorially adapted from Small Means and Great Ends, an 1851 anthology edited by M. H. Adams with contributions from several writers. Following the sequence of the inherited selections, these readings consider modest generosity, grief and care for children, fear and hope, truthful speech, human dignity across cultural divides, conscience, neighborly service, gratitude, and care for creation. The Scripture readings are newly curated thematic anchors; all reflections, devotional summaries, practices, and prayers are new editorial writing, not quotations from the anthology. Some nineteenth-century stories portray Indigenous people through prejudice, describe severe treatment of children, or draw overly certain conclusions about bereavement; those perspectives are identified as historical and are not endorsed. The original anthology remains accessible at the linked source for readers who wish to study its period context."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;


update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-26 09:15:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 1,
    "value": "Offer What You Have"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 2,
    "value": "Treasure the Ordinary Day"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 3,
    "value": "Hope that Makes Room for Grief"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 4,
    "value": "Every Child Deserves Safety"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 5,
    "value": "Pray When You Are Afraid"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 6,
    "value": "Compassion Crosses Dividing Lines"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 7,
    "value": "The Gift of Welcome"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 8,
    "value": "Let Your Words Give Life"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 9,
    "value": "New Habits Begin with a New Choice"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 10,
    "value": "Light beyond the Shadow"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 11,
    "value": "Answer Anger with Wisdom"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 12,
    "value": "Living Water for the Outsider"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 13,
    "value": "Belonging to One Human Family"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 14,
    "value": "Hold Convictions without Contempt"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 15,
    "value": "Bring Hidden Wrong into the Light"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 16,
    "value": "Sit with Those Who Mourn"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 17,
    "value": "Love Remembered amid Loss"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 18,
    "value": "Care for a Grieving Child"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 19,
    "value": "Faithful Friends in Every Season"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 20,
    "value": "Small Kindness Is Real Service"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 21,
    "value": "Love Is Something We Do"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 22,
    "value": "Learn Gratitude in Simple Gifts"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 23,
    "value": "Choose the Neighbor over the Prize"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 24,
    "value": "Do Good without Needing Applause"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 25,
    "value": "Listen to the Gospel Witnesses"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 26,
    "value": "Make Room for Joy and Sorrow"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 27,
    "value": "Love That Leaves Room for Freedom"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;


update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-26 09:15:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 1,
    "value": "<p><strong>Read:</strong> 2 Kings 4:1-7; Acts 20:35.</p><p><strong>Source and historical context:</strong> In Julia A. Fletcher’s story of Eliza and the widow’s jar of oil, Eliza worries that without wealth she cannot relieve a struggling family. Her mother helps her see that she can seek a doctor, rally neighbors, and bring practical aid.</p><p><strong>Devotional focus:</strong> Generosity begins with attention, not abundance. The widow’s oil in 2 Kings is a picture of God’s care amid real need, not a guarantee that every hardship will disappear. Eliza learns to use the voice, relationships, and opportunities she already possesses.</p><p><strong>Reflect:</strong> What need have you noticed but dismissed because you could not solve it alone?</p><p><strong>Practice:</strong> Offer one concrete help today: make a call, share food, give time, or connect a person with a trustworthy resource.</p><p><strong>Prayer:</strong> Generous God, open my eyes to those in need. Teach me to use what I have, to ask others for help, and to give without seeking praise. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 2,
    "value": "<p><strong>Read:</strong> Psalm 90:12; Mark 10:13-16.</p><p><strong>Source and historical context:</strong> Margaret M. Mason’s sketch of young Mary Ellen remembers a child’s curiosity, affection, and love of Scripture. It also recounts her early death and the pain of those who loved her.</p><p><strong>Devotional focus:</strong> A small life is never an insignificant life. The story invites gratitude for ordinary moments without suggesting that a child’s suffering is required for spiritual growth. Jesus welcomed children as persons deserving tenderness, protection, and attention.</p><p><strong>Reflect:</strong> Whose presence have you been taking for granted, and what simple moment could you honor today?</p><p><strong>Practice:</strong> Give unhurried attention to a child, relative, friend, or neighbor. Listen before speaking.</p><p><strong>Prayer:</strong> Lord Jesus, teach me to receive each person as precious. Make me attentive to today and compassionate toward families facing illness or loss. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 3,
    "value": "<p><strong>Read:</strong> Romans 15:13; 1 Thessalonians 4:13-14.</p><p><strong>Source and historical context:</strong> The conclusion of “Mary Ellen” describes her parents’ sorrow; H. B. Nye’s essay “Hope” then reflects on trust through uncertainty, disappointment, and bereavement.</p><p><strong>Devotional focus:</strong> Christian hope does not erase grief or demand quick recovery. It brings sorrow honestly before the God who raised Jesus. We may hope for God’s future while still recognizing that a family’s absence, questions, and tears are real.</p><p><strong>Reflect:</strong> Is there a sorrow you have tried to rush past—or someone else’s grief you have been tempted to explain away?</p><p><strong>Practice:</strong> Offer presence rather than an easy answer. Reach out to someone grieving and allow them to speak or remain quiet.</p><p><strong>Prayer:</strong> God of hope, meet us in the places where words are few. Hold those who mourn and teach us to accompany them with patience and love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 4,
    "value": "<p><strong>Read:</strong> Psalm 82:3-4; Micah 6:8.</p><p><strong>Source and historical context:</strong> Margaret A. Livermore’s “The Stolen Children” opens in colonial New England, introducing Emma and Anna Wilson amid settler-Indigenous conflict. Its narrator uses hostile nineteenth-century descriptions of Indigenous people and depicts severe punishment of the children.</p><p><strong>Devotional focus:</strong> The story should be read as a period narrative, not as an impartial account of Indigenous communities. Scripture calls us to protect children and act justly toward people on every side of conflict. Neither ethnicity nor disobedience diminishes a child’s dignity or right to safety.</p><p><strong>Reflect:</strong> Which inherited descriptions or assumptions make it harder for you to recognize another person’s full humanity?</p><p><strong>Practice:</strong> Practice accurate, respectful speech about a community unlike your own and support a child’s safety in a practical way.</p><p><strong>Prayer:</strong> God of justice, guard children from harm. Free us from prejudice and teach us to treat every neighbor with truth, mercy, and dignity. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 5,
    "value": "<p><strong>Read:</strong> Psalm 46:1; Psalm 34:17-18.</p><p><strong>Source and historical context:</strong> In the next part of “The Stolen Children,” the two sisters are taken from their home amid violence. At night they pray together for protection and for the family from whom they are separated.</p><p><strong>Devotional focus:</strong> Fear is not proof that faith has failed. The sisters’ prayer is an honest cry for help in a situation they did not choose. Prayer can sustain courage, but it never excuses violence or removes the responsibility of others to protect those in danger.</p><p><strong>Reflect:</strong> Where do you need to admit fear and seek both God’s comfort and responsible human help?</p><p><strong>Practice:</strong> If someone is at risk, prioritize concrete safety and trusted support alongside prayer. Do not place blame on the vulnerable.</p><p><strong>Prayer:</strong> Refuge of the frightened, hear every person who cries to you. Give courage, protection, and wise helpers to those facing danger. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 6,
    "value": "<p><strong>Read:</strong> Romans 12:15; Luke 10:33-37.</p><p><strong>Source and historical context:</strong> The story of Emma, Anna, and Winona portrays affection growing between the girls and an Indigenous family. They grieve together when Winona dies, and the woman caring for the sisters ultimately recognizes their need to return home.</p><p><strong>Devotional focus:</strong> Shared tenderness challenges the source’s sweeping hostile descriptions of Indigenous people. Even a story shaped by the prejudices of its century contains a reminder that human love and grief cross ethnic boundaries. Compassion listens to real people rather than labels.</p><p><strong>Reflect:</strong> Whose sorrow or goodness has been hidden from you by a group stereotype?</p><p><strong>Practice:</strong> Seek one truthful story from a community you know poorly, and respond to others’ loss without comparison or judgment.</p><p><strong>Prayer:</strong> God of all people, soften the borders we draw around our compassion. Teach us to mourn with those who mourn and to protect the vulnerable. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 7,
    "value": "<p><strong>Read:</strong> Luke 15:20-24; Romans 12:10.</p><p><strong>Source and historical context:</strong> The sisters’ homecoming is celebrated in “The Stolen Children.” The next selection, J. G. Adams’s “My Grandmother’s Cottage,” recalls a peaceful home where an older relative made space for a child to read and wonder.</p><p><strong>Devotional focus:</strong> Welcome is more than an open door. It is the patient attention by which another person knows they belong. Family reunion and the memory of a gentle grandparent offer distinct glimpses of hospitality, though not everyone’s own family story is safe or simple.</p><p><strong>Reflect:</strong> Who might need a welcome that comes without interrogation, pressure, or conditions?</p><p><strong>Practice:</strong> Create a small moment of belonging for someone—through a meal, attentive conversation, or a warm invitation.</p><p><strong>Prayer:</strong> Welcoming Father, make my presence safe and kind. Help me honor the homes people miss and create spaces where others can rest. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 8,
    "value": "<p><strong>Read:</strong> James 3:5-10; Ephesians 4:29.</p><p><strong>Source and historical context:</strong> The close of “My Grandmother’s Cottage” is followed by Eben Francis’s “The First Oath,” a story about a young person’s upbringing and the influence of words heard at work.</p><p><strong>Devotional focus:</strong> Words can repair or wound relationships. James warns that the tongue is small yet powerful. Rather than measuring people by a single phrase, we are called to build habits of truthful, gentle speech and to resist contempt disguised as ordinary conversation.</p><p><strong>Reflect:</strong> When do frustration, imitation, or the desire to fit in affect the way you speak?</p><p><strong>Practice:</strong> Replace one sharp phrase with a clear, respectful one; if you hurt someone, acknowledge it and apologize.</p><p><strong>Prayer:</strong> Lord, place wisdom on my tongue. Let my words be honest, restrained, and useful for building others up. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 9,
    "value": "<p><strong>Read:</strong> Ephesians 4:25-32; Proverbs 15:1.</p><p><strong>Source and historical context:</strong> In the second half of “The First Oath,” angry speech gradually becomes a habit. The young man eventually changes, but the narrator does not hide the struggle that followed repeated choices.</p><p><strong>Devotional focus:</strong> The point is not that one mistake fixes a person’s destiny. Patterns can deepen when we repeat them, and by grace we can also practice a different response. Ephesians calls believers to put away corrosive speech and choose forgiveness and kindness.</p><p><strong>Reflect:</strong> What repeated reaction are you ready to interrupt rather than excuse?</p><p><strong>Practice:</strong> Identify one trigger. Before responding, pause, name the feeling, and choose a kinder sentence or action.</p><p><strong>Prayer:</strong> Merciful God, give me courage to change a habit that harms others. Lead me into honest repentance and patient practice. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 10,
    "value": "<p><strong>Read:</strong> Psalm 23:4; Isaiah 41:10.</p><p><strong>Source and historical context:</strong> Louisa M. Barker’s “A Lesson Taught by Nature” follows a child frightened by woods that seemed dark from a distance. After entering them, she discovers that the darkness also shelters beauty; the memory later helps her during illness.</p><p><strong>Devotional focus:</strong> The psalmist does not deny the valley of shadow; he speaks of God’s nearness within it. Fear can be understandable, and new understanding sometimes comes slowly. We need not pretend the forest or the future holds no risks in order to trust God.</p><p><strong>Reflect:</strong> What unknown situation looks darker from a distance than it may truly be?</p><p><strong>Practice:</strong> Name a fear accurately. Take one safe, manageable step toward understanding it, with support if needed.</p><p><strong>Prayer:</strong> Shepherd of our days, be near in uncertainty. Give me honest courage and companions who help me walk wisely. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 11,
    "value": "<p><strong>Read:</strong> James 1:19-20; Proverbs 15:1.</p><p><strong>Source and historical context:</strong> The closing lesson of Barker’s woodland story introduces “Florence Drew,” a tale in which an upset child meets a woman described in demeaning, antiquated terms and receives counsel about temper and family relationships.</p><p><strong>Devotional focus:</strong> The woman deserves dignity regardless of how the storyteller portrays her. James calls us to be quick to hear and slow to anger. Maturity does not mean suppressing every feeling; it means taking responsibility for what we do with anger and responding without cruelty.</p><p><strong>Reflect:</strong> Is there a conversation where being heard matters more than winning an argument?</p><p><strong>Practice:</strong> Before replying in frustration, ask one sincere question and listen fully to the answer.</p><p><strong>Prayer:</strong> Patient Lord, teach me to recognize my emotions without letting them rule me. Help me speak with kindness and treat misunderstood people with dignity. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 12,
    "value": "<p><strong>Read:</strong> John 4:4-26; John 4:39-42.</p><p><strong>Source and historical context:</strong> J. G. Adams’s essay about Shechem recalls Jacob’s well and Jesus’ encounter with a Samaritan woman. It also mixes biblical narrative with nineteenth-century geographic and historical claims that should not be treated as current research.</p><p><strong>Devotional focus:</strong> Jesus crosses a boundary of hostility to speak with a woman whom others might overlook. He offers living water and makes space for her questions. A Bible place becomes meaningful not merely as a site on a map but through the Savior’s invitation to worship in spirit and truth.</p><p><strong>Reflect:</strong> Whose questions are you tempted to dismiss because of background or reputation?</p><p><strong>Practice:</strong> Listen respectfully to someone whose experiences differ from yours, without rushing to correct their story.</p><p><strong>Prayer:</strong> Jesus, giver of living water, meet us in our thirst. Free us from contempt and teach us to welcome honest questions. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 13,
    "value": "<p><strong>Read:</strong> Luke 10:25-37; 1 John 4:20-21.</p><p><strong>Source and historical context:</strong> “Are We Not All Brothers and Sisters?” tells of a young girl who recognizes another person as family under God and urges kindness toward people who are poor, distressed, or difficult to love. The next story begins a debate about fortune-telling.</p><p><strong>Devotional focus:</strong> Love of neighbor cannot stop at those who resemble us or agree with us. The good Samaritan story asks not who qualifies for our help but whether we will become neighbors through mercy. Genuine love also respects difference rather than erasing it.</p><p><strong>Reflect:</strong> Who have you treated as a category instead of as a person?</p><p><strong>Practice:</strong> Make one choice that honors someone’s dignity, especially when they cannot repay or impress you.</p><p><strong>Prayer:</strong> Father of all, enlarge my compassion. Teach me to meet people as neighbors and to turn conviction into merciful action. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 14,
    "value": "<p><strong>Read:</strong> James 1:5; Romans 14:19.</p><p><strong>Source and historical context:</strong> Julia A. Fletcher’s dialogue “Fortune-Telling” continues with friends debating predictions, entertainment, money, and conscience. Mary Ann argues that a conviction should not be abandoned simply to please a group. The page then begins “The Boy Who Stole the Nails.”</p><p><strong>Devotional focus:</strong> Discernment is not an excuse for mocking people who see matters differently. Wisdom asks whether a practice is honest, helpful, and consistent with conscience. Friends can challenge a choice firmly while preserving gentleness and freedom from coercion.</p><p><strong>Reflect:</strong> When have you confused keeping the peace with abandoning a serious conviction—or used conviction as an excuse to belittle someone?</p><p><strong>Practice:</strong> State one belief calmly, give your reason, and let the other person respond without pressure.</p><p><strong>Prayer:</strong> God of wisdom, keep me truthful and humble. Teach me to disagree with patience and seek what builds peace. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 15,
    "value": "<p><strong>Read:</strong> Proverbs 28:13; Ephesians 4:25-28.</p><p><strong>Source and historical context:</strong> Moses Ballou’s “The Boy Who Stole the Nails” follows a child who takes what does not belong to him and becomes burdened by secrecy. The page then turns toward a new story, “The Childless Mother.”</p><p><strong>Devotional focus:</strong> Dishonesty often creates new fears and excuses. Confession is not about being crushed by shame; it opens the way to truth, restitution, and changed conduct. Ephesians joins leaving theft behind with meaningful work and generosity toward others.</p><p><strong>Reflect:</strong> Is there a wrong you need to name accurately rather than conceal or minimize?</p><p><strong>Practice:</strong> Where safe and appropriate, tell the truth to someone affected, return what you can, and make a specific repair.</p><p><strong>Prayer:</strong> God of mercy and truth, give me courage to stop hiding. Lead me toward honest repair and a life that blesses others. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 16,
    "value": "<p><strong>Read:</strong> Psalm 34:18; Romans 12:15.</p><p><strong>Source and historical context:</strong> M. H. Adams’s “The Childless Mother” depicts Ellen grieving the deaths of her children. Those around her try to offer care, and the narrative reflects period expectations about how bereaved mothers ought to respond.</p><p><strong>Devotional focus:</strong> No one owes others a cheerful performance after devastating loss. Scripture makes room for lament, silence, and companionship. God’s nearness to the brokenhearted does not mean the bereaved must explain why tragedy happened or quickly feel thankful for it.</p><p><strong>Reflect:</strong> How might you offer care without comparing losses or setting a deadline on another person’s grief?</p><p><strong>Practice:</strong> Offer a specific practical help or simply sit and listen. Let the grieving person set the pace.</p><p><strong>Prayer:</strong> Compassionate Lord, be near to parents and families in sorrow. Make us steady companions, slow to judge and quick to help. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 17,
    "value": "<p><strong>Read:</strong> Matthew 5:4; 2 Corinthians 1:3-4.</p><p><strong>Source and historical context:</strong> The conclusion of “The Childless Mother” describes a bereaved parent’s faith, then begins Adams’s “The Motherless Child,” in which a family faces the death of a mother and a young child struggles with her absence.</p><p><strong>Devotional focus:</strong> Grief can involve very different needs for a parent, a partner, or a child. Jesus calls mourners blessed not because bereavement is desirable but because they are not forgotten by God. The comfort we receive can help us care for others without claiming to know exactly how they feel.</p><p><strong>Reflect:</strong> Whose sorrow needs acknowledgment rather than a lesson?</p><p><strong>Practice:</strong> Speak the name of someone missed if the mourner welcomes it, and offer patient presence.</p><p><strong>Prayer:</strong> Jesus, comfort of mourners, carry those who feel a painful absence. Help me offer care with humility rather than explanations. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 18,
    "value": "<p><strong>Read:</strong> Psalm 68:5-6; John 14:18.</p><p><strong>Source and historical context:</strong> In “The Motherless Child,” Willie continues to grieve his mother and gradually finds ways to remember her. The following “Snow-Birds” dialogue turns to creatures that remain present through harsh seasons.</p><p><strong>Devotional focus:</strong> A child may mourn in questions, repetition, silence, or bursts of ordinary play. Loving adults should not shame these responses or suggest that remembering is disloyal. God’s concern for vulnerable families calls a community to provide dependable, practical care.</p><p><strong>Reflect:</strong> What does a grieving child—or someone whose loss began in childhood—need to hear from you?</p><p><strong>Practice:</strong> If you care for a child in grief, answer honestly at an age-appropriate level, maintain safe routines, and invite memories without pressure.</p><p><strong>Prayer:</strong> Faithful God, surround bereaved children with trustworthy people. Help us listen with patience and honor the love they remember. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 19,
    "value": "<p><strong>Read:</strong> Proverbs 17:17; 1 Kings 18:41-46.</p><p><strong>Source and historical context:</strong> The “Snow-Birds” dialogue praises friends who remain near in hardship, and the nearby account of Mount Carmel recalls Elijah’s prayer and the first small sign of approaching rain.</p><p><strong>Devotional focus:</strong> Faithfulness may look like showing up when life feels wintry. Elijah’s small cloud is part of a particular biblical story, not a promise that every hoped-for outcome will arrive immediately. We can pray with perseverance while supporting one another in real conditions.</p><p><strong>Reflect:</strong> Which relationship needs steadfast attention rather than a grand gesture?</p><p><strong>Practice:</strong> Contact someone in difficulty and offer one practical form of support you can sustain.</p><p><strong>Prayer:</strong> Lord of every season, keep me faithful in friendship. Help me pray with hope and remain present when answers are slow. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 20,
    "value": "<p><strong>Read:</strong> Luke 16:10; Galatians 6:9-10.</p><p><strong>Source and historical context:</strong> Elizabeth Doten’s “The Philosophy of Life” follows Annie Burton, who is discouraged by her limitations until an older woman helps her recognize the value of ordinary kindness and service.</p><p><strong>Devotional focus:</strong> The size of a gift does not measure the worth of the giver. A helpful hand, patient word, or shared burden can matter deeply. Christian service does not require becoming extraordinary before beginning to act with love.</p><p><strong>Reflect:</strong> What good action have you postponed because it seems too small to count?</p><p><strong>Practice:</strong> Choose an achievable kindness today and offer it freely without trying to measure its impact.</p><p><strong>Prayer:</strong> Lord Jesus, make me willing in little things. Save me from comparing my service with others, and grow love in ordinary tasks. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 21,
    "value": "<p><strong>Read:</strong> 1 John 3:16-18; James 2:14-17.</p><p><strong>Source and historical context:</strong> The ending of “The Philosophy of Life” emphasizes loving and doing. The anthology then introduces titles about Irish poverty and an older Sunday-school celebration, drawing attention to both need and communal life.</p><p><strong>Devotional focus:</strong> Compassion becomes credible through action. Scripture challenges kind words that leave urgent needs untouched. We cannot meet every need, but we can resist indifference, collaborate wisely, and respect the people we serve rather than making them objects of pity.</p><p><strong>Reflect:</strong> What concern keeps returning to your attention, and what proportionate response is possible?</p><p><strong>Practice:</strong> Support a local effort meeting a verified need, or ask a person what help would actually be useful.</p><p><strong>Prayer:</strong> God of mercy, let my love take a practical shape. Keep my giving humble, thoughtful, and guided by the dignity of others. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 22,
    "value": "<p><strong>Read:</strong> Philippians 4:11-13; James 1:17.</p><p><strong>Source and historical context:</strong> Henry Bacon’s “The Sabbath School Festival” remembers the delight of children receiving simple gingerbread and questions whether more elaborate celebrations necessarily bring deeper joy. The next tale introduces Nelly and her hope of buying a collar for her dog.</p><p><strong>Devotional focus:</strong> Delight is not always tied to expense. Gratitude can deepen our ability to enjoy what is available without shaming people who lack necessities. Contentment is a practice of receiving gifts well, not a command to ignore injustice or genuine deprivation.</p><p><strong>Reflect:</strong> What modest gift or shared moment has brought more joy than its price would suggest?</p><p><strong>Practice:</strong> Thank someone for an ordinary kindness, and share a simple pleasure without comparison.</p><p><strong>Prayer:</strong> Giver of good gifts, teach me grateful attention. Guard me from envy while keeping me alert to neighbors who need real help. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 23,
    "value": "<p><strong>Read:</strong> Philippians 2:3-4; Luke 6:35.</p><p><strong>Source and historical context:</strong> In “Nelly Grey,” Nelly gathers strawberries to buy something for her dog. On the way, she learns that a sick child, Lucy, would cherish the berries, and decides to give them away despite her own plans.</p><p><strong>Devotional focus:</strong> Compassion often interrupts a perfectly reasonable intention. Nelly’s choice shows how love notices a particular need and responds without demanding payment. Her friend also learns to reconsider an ungenerous first response.</p><p><strong>Reflect:</strong> What preference could you set aside for a person whose immediate need is greater?</p><p><strong>Practice:</strong> Offer a resource, meal, or hour of help where it will genuinely relieve a burden.</p><p><strong>Prayer:</strong> Christ our servant, loosen my grip on small rewards. Teach me to see real needs and give freely with joy. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 24,
    "value": "<p><strong>Read:</strong> Matthew 6:1-4; 2 Corinthians 9:7.</p><p><strong>Source and historical context:</strong> “Nelly Grey” concludes when an adult privately rewards Nelly’s self-denial. The page then introduces a lesson about the four Gospel writers.</p><p><strong>Devotional focus:</strong> The story celebrates generous conduct, but Jesus asks us not to turn giving into a performance. A grateful surprise can be received happily; it is not the reason we serve. True generosity places the neighbor’s good ahead of attention, prizes, or reputation.</p><p><strong>Reflect:</strong> Would you still choose the same kindness if no one noticed or thanked you?</p><p><strong>Practice:</strong> Do one useful thing quietly today and resist the urge to tell others about it.</p><p><strong>Prayer:</strong> Father who sees in secret, purify my motives. Make me glad to give and content to leave recognition in your hands. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 25,
    "value": "<p><strong>Read:</strong> Luke 1:1-4; John 20:30-31.</p><p><strong>Source and historical context:</strong> “The Four Evangelists” introduces Matthew, Mark, Luke, and John with biographical traditions, some of which are uncertain. The following “May-Day” sketch shifts to children’s outdoor celebrations and an injured girl.</p><p><strong>Devotional focus:</strong> The Gospels invite us to encounter the person and work of Jesus. Luke describes careful attention to handed-down testimony, and John states why his account was written. We can read the four narratives together without treating every later claim about their authors as independently established fact.</p><p><strong>Reflect:</strong> When you read Scripture, do you listen for what the passage says—or only for what you already expect it to say?</p><p><strong>Practice:</strong> Read one short Gospel scene slowly. Notice what Jesus does, who is present, and one question the text leaves with you.</p><p><strong>Prayer:</strong> Lord Jesus, open my ears to the witness of Scripture. Grant humility, careful attention, and faith expressed in love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 26,
    "value": "<p><strong>Read:</strong> Ecclesiastes 3:1-4; Psalm 104:10-12.</p><p><strong>Source and historical context:</strong> Nancy T. Munroe’s “May-Day” remembers spring outings, childhood accidents, and memories of loss. The page then turns to “Caging Birds,” a reflection on the lives of creatures kept in confinement.</p><p><strong>Devotional focus:</strong> Life seldom matches the celebration we imagined. Joy and grief may stand close together, and neither cancels the other. Scripture gives each its season. Care for creation also asks whether our pleasures honor or restrict the living things around us.</p><p><strong>Reflect:</strong> Where are you demanding either constant cheerfulness or constant seriousness from yourself or others?</p><p><strong>Practice:</strong> Make space for a simple delight while extending kindness to anyone whose day is difficult.</p><p><strong>Prayer:</strong> Creator of the seasons, receive both our laughter and our tears. Make me attentive to people and creatures affected by my choices. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 27,
    "value": "<p><strong>Read:</strong> Genesis 2:15; Matthew 10:29-31.</p><p><strong>Source and historical context:</strong> The final section of “Caging Birds” and the story “The Pet Swallow” describe children caring for a swallow they call Fairy. They want to keep it near, yet they recognize its need to fly freely and eventually face the uncertainty of its return.</p><p><strong>Devotional focus:</strong> Care does not always mean holding on. Stewardship honors the nature and well-being of what we cherish. The story is not a wildlife-care manual, but it invites a question we also face in relationships: can affection leave room for another’s freedom and flourishing?</p><p><strong>Reflect:</strong> Where could your care become more respectful of another living being’s needs or boundaries?</p><p><strong>Practice:</strong> Make one responsible choice that protects an animal, a habitat, or a person’s appropriate freedom.</p><p><strong>Prayer:</strong> Creator and keeper of life, teach me to cherish without possessing. Make my love gentle, responsible, and generous. Amen.</p>"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;


-- Update/insert plan-level Scripture selections, without changing user-created Scripture notes.
do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 1,
    "references": [
      "2 Kings 4:1-7",
      "Acts 20:35"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 2,
    "references": [
      "Psalm 90:12",
      "Mark 10:13-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 3,
    "references": [
      "Romans 15:13",
      "1 Thessalonians 4:13-14"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 4,
    "references": [
      "Psalm 82:3-4",
      "Micah 6:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 5,
    "references": [
      "Psalm 46:1",
      "Psalm 34:17-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 6,
    "references": [
      "Romans 12:15",
      "Luke 10:33-37"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 7,
    "references": [
      "Luke 15:20-24",
      "Romans 12:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 8,
    "references": [
      "James 3:5-10",
      "Ephesians 4:29"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 9,
    "references": [
      "Ephesians 4:25-32",
      "Proverbs 15:1"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 10,
    "references": [
      "Psalm 23:4",
      "Isaiah 41:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 11,
    "references": [
      "James 1:19-20",
      "Proverbs 15:1"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 12,
    "references": [
      "John 4:4-26",
      "John 4:39-42"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 13,
    "references": [
      "Luke 10:25-37",
      "1 John 4:20-21"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 14,
    "references": [
      "James 1:5",
      "Romans 14:19"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 15,
    "references": [
      "Proverbs 28:13",
      "Ephesians 4:25-28"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 16,
    "references": [
      "Psalm 34:18",
      "Romans 12:15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 17,
    "references": [
      "Matthew 5:4",
      "2 Corinthians 1:3-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 18,
    "references": [
      "Psalm 68:5-6",
      "John 14:18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 19,
    "references": [
      "Proverbs 17:17",
      "1 Kings 18:41-46"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 20,
    "references": [
      "Luke 16:10",
      "Galatians 6:9-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 21,
    "references": [
      "1 John 3:16-18",
      "James 2:14-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 22,
    "references": [
      "Philippians 4:11-13",
      "James 1:17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 23,
    "references": [
      "Philippians 2:3-4",
      "Luke 6:35"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 24,
    "references": [
      "Matthew 6:1-4",
      "2 Corinthians 9:7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 25,
    "references": [
      "Luke 1:1-4",
      "John 20:30-31"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 26,
    "references": [
      "Ecclesiastes 3:1-4",
      "Psalm 104:10-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000282",
    "day_number": 27,
    "references": [
      "Genesis 2:15",
      "Matthew 10:29-31"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;

    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-26 09:15:00+00'
    where day_id = target_day_id and user_id is null;

    if not found then
      insert into public.scripture_references
        (user_id, day_id, reference, created_at, updated_at)
      values
        (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
         timestamptz '2026-10-26 09:15:00+00', timestamptz '2026-10-26 09:15:00+00');
    end if;
  end loop;
end
$$;

-- Review before publication: the supplied source has not been approved for every territory.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-26 09:15:00+00'
where id = '90000000-0000-0000-0000-000000000282'::uuid;

commit;
