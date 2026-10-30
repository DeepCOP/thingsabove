-- Wave 29: Plan 342 — Corrie, Ruth Lynn (12 source chapters, 27 existing day rows).
-- Original, Scripture-led narrative devotions, not a verbatim reprint of this historical fiction.
-- Keeps plan ID, original day IDs, day numbers, and user progress intact.
-- Apply AFTER October 21 language/numeral modernization parts 03 and 10.
-- Editorial DRAFT ONLY; never auto-publish. Review and test in staging before applying.

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
  from public.devotional_plans where id = '90000000-0000-0000-0000-000000000342'::uuid;
  if not found then raise exception 'Plan 342 missing'; end if;
  if current_source is distinct from 'https://www.gutenberg.org/ebooks/75031' or current_total is distinct from 27 then
    raise exception 'Plan 342 source URL or total days differs from Wave 29 review';
  end if;
  select count(*), min(day_number), max(day_number), count(distinct day_number)
  into day_count, first_day, last_day, unique_days
  from public.devotional_days where plan_id = '90000000-0000-0000-0000-000000000342'::uuid;
  if day_count <> 27 or first_day <> 1 or last_day <> 27 or unique_days <> 27 then
    raise exception 'Plan 342 must contain 27 distinct numbered days; found %', day_count;
  end if;
end
$$;

update public.devotional_plans as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Corrie: Twenty-Seven Readings on Compassion, Courage, and Grace"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Twenty-seven newly written, Scripture-led devotions adapted from Ruth Lynn’s public-domain Christian story Corrie. Follow Robin, Corrie, their mother, Jonathan, and the children of Oaklands through Christmas kindness, shared belonging, secrecy and repentance, restored trust, and hope amid loss. Each day pairs its original story segment with historical context, a devotional reflection, a question, a practical response, and prayer. The story’s period attitudes toward disability, poverty, and discipline are thoughtfully contextualized."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 1,
    "value": "The Good News in a Small Room"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 2,
    "value": "Love That Notices the Burden"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 3,
    "value": "A Refuge That Holds Grief"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 4,
    "value": "Rooted for the Good of Others"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 5,
    "value": "The Rainbow of Shared Joy"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 6,
    "value": "The Small Gift That Costs Something"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 7,
    "value": "A Small Tree, a Great Welcome"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 8,
    "value": "An Open Path to Belonging"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 9,
    "value": "Fruit in the Quiet Places"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 10,
    "value": "The Humility to Keep Learning"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 11,
    "value": "When a Favor Has Hidden Strings"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 12,
    "value": "The Exhaustion of Keeping Secrets"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 13,
    "value": "Love That Makes Truth Possible"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 14,
    "value": "An Accident Is Not a Secret to Carry"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 15,
    "value": "Do Not Let Someone Else Carry Your Blame"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 16,
    "value": "The Peace of a Clear Conscience"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 17,
    "value": "What Is Money For?"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 18,
    "value": "Celebrate with Open Eyes"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 19,
    "value": "Before You Decide Who Is Guilty"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 20,
    "value": "The Cost of a Tangled Story"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 21,
    "value": "The Courage to Come Forward"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 22,
    "value": "Truth Opens a New Door"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 23,
    "value": "Mercy That Repairs Trust"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 24,
    "value": "A Place to Breathe"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 25,
    "value": "Belonging Beyond a Change of Place"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 26,
    "value": "Faithful Love When Strength Changes"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 27,
    "value": "The Garden of Lasting Hope"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 1,
    "value": "<p><strong>Read:</strong> Luke 2:8-20; John 10:11-15</p><p><strong>Source and historical context:</strong> On a moonlit evening before Christmas, Robin tells his younger sister Corrie the story of the shepherds and the birth of Jesus. He sits beside her in their modest home, attentive to her questions and to the pain caused by her paralysis.</p><p><strong>Devotional focus:</strong> The angelic announcement is good news for all people, not only those with money, health, or freedom of movement. Robin shares the story he received from his teacher because he knows it might comfort someone he loves. Corrie is not simply an object of care: her curiosity and faith shape the conversation. Christ the Good Shepherd sees both children as people of worth, present in the world and beloved now.</p><p><strong>Reflect:</strong> Whose questions or fears might I meet with a patient story of God’s love?</p><p><strong>Practice:</strong> Read Luke 2 aloud, slowly. Ask someone what part of the story gives them hope, then listen without rushing to correct them.</p><p><strong>Prayer:</strong> Jesus, bring your good news into our ordinary rooms. Teach us to see and cherish each person you love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 2,
    "value": "<p><strong>Read:</strong> 1 John 3:16-18; Philippians 2:3-4</p><p><strong>Source and historical context:</strong> Robin helps his exhausted mother after her day of laundry work, keeps Corrie company, and begins imagining a little Christmas tree for his sister. Their household has little money, but its members keep noticing one another’s needs.</p><p><strong>Devotional focus:</strong> Love has hands: it makes tea, shares chores, searches for something that will delight a child, and recognizes the fatigue of a caregiver. The story asks Corrie to bear pain without burdening others; today we can recognize instead that pain is not a moral failure, and that a person who hurts has permission to ask for help. Serving each other includes receiving care and making room for honest feelings.</p><p><strong>Reflect:</strong> What ordinary burden in my home or community could I help carry?</p><p><strong>Practice:</strong> Offer one specific practical kindness today, such as an errand, a meal, or an uninterrupted chance for someone to rest.</p><p><strong>Prayer:</strong> God of tender care, make me attentive to needs that are easy to overlook. Help our love be honest as well as generous. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 3,
    "value": "<p><strong>Read:</strong> Psalm 46:1-7; Revelation 21:1-5</p><p><strong>Source and historical context:</strong> Before setting out to Oaklands, Robin remembers the news of his father’s death at sea. Psalm 46, spoken during the family’s bereavement, has become “father’s psalm.” He begins the morning with prayer, work, and remembrance.</p><p><strong>Devotional focus:</strong> The promise of God as refuge does not cancel the ache of a death or guarantee an easy day afterward. It gives grieving people words to carry when their own fail. Robin’s care for his family grows alongside his sadness, not because it has disappeared. Christian hope names a future without tears while honoring the real loss experienced here and now.</p><p><strong>Reflect:</strong> What grief am I trying to hurry past instead of carrying honestly before God?</p><p><strong>Practice:</strong> Read Psalm 46 in memory of someone or something lost. If a grieving friend comes to mind, offer a simple message of care.</p><p><strong>Prayer:</strong> God, remain near when the familiar world changes. Give peace without asking us to deny our sorrow. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 4,
    "value": "<p><strong>Read:</strong> Psalm 1:1-3; John 15:4-5</p><p><strong>Source and historical context:</strong> At Oaklands, Jonathan and Robin lift a fir tree for the family’s Christmas celebration. Robin asks for one of its cut branches so he can take a little tree to Corrie. Jonathan uses the surrounding woods to speak about being rooted in Christ.</p><p><strong>Devotional focus:</strong> A tree does not bear fruit by performing for its observers; it grows by drawing life from its roots. So faith grows through attention to Christ and slowly becomes kindness, endurance, and honest work. The humble branch meant for Corrie shows how something small can create welcome. We can grow roots in prayer and Scripture without treating productivity as a measure of anyone’s spiritual worth.</p><p><strong>Reflect:</strong> What is nourishing my inner life, and whom could its fruit serve?</p><p><strong>Practice:</strong> Spend five quiet minutes with John 15, then use something already available to brighten another person’s day.</p><p><strong>Prayer:</strong> Christ, root my life in your faithful love. Let the care I receive become care I freely share. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 5,
    "value": "<p><strong>Read:</strong> Philippians 2:3-5; Romans 12:15</p><p><strong>Source and historical context:</strong> At Oaklands, Clarice learns about Corrie and offers to find toys for her tree. Meanwhile Milly, confined indoors by a cough, is upset that she cannot join the other children outside. Her father invites her to notice another person’s joy.</p><p><strong>Devotional focus:</strong> Disappointment is real even when another person’s struggle is greater. The answer is not to compare pain or demand constant cheerfulness. In this scene, a new act of kindness allows Milly to participate in the celebration in a way her health permits. Paul asks believers to look beyond themselves, which can widen joy without erasing their own needs. We can acknowledge feelings and still choose compassionate action.</p><p><strong>Reflect:</strong> Where could caring about someone else make room for joy, without denying my own frustration?</p><p><strong>Practice:</strong> Name one disappointment honestly. Then choose one manageable way to include or encourage another person.</p><p><strong>Prayer:</strong> Jesus, teach me to be truthful about my feelings and generous with my attention. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 6,
    "value": "<p><strong>Read:</strong> 2 Corinthians 9:6-8; Mark 12:41-44</p><p><strong>Source and historical context:</strong> Clarice and Milly decorate the little fir branch for Corrie with toys and bright paper. Milly hesitates before deciding to add her much-loved sugar lamb to the gifts.</p><p><strong>Devotional focus:</strong> Giving becomes meaningful when it is thoughtful rather than showy. Milly’s small sacrifice is not the price of approval; it is her voluntary way of saying another child matters to her. God delights in generosity offered freely, with wisdom and affection. Different people have different resources, and kindness can take the form of a gift, a listening ear, or an invitation.</p><p><strong>Reflect:</strong> What can I offer freely that would help someone feel remembered?</p><p><strong>Practice:</strong> Choose a small, personal gift or act of help that matches the recipient’s real interests rather than your need to be praised.</p><p><strong>Prayer:</strong> Generous God, free me to give with joy and to receive without shame. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 7,
    "value": "<p><strong>Read:</strong> Luke 2:10-14; Nehemiah 8:10</p><p><strong>Source and historical context:</strong> Corrie receives her decorated branch with astonishment. Robin and the Oaklands children experience the pleasure of giving, while the family worships at Christmas and hears again the promise of the child born for the world.</p><p><strong>Devotional focus:</strong> The Christmas story puts good news into ordinary circumstances. The fir branch is modest, yet the care behind it is real. It becomes a sign that Corrie is remembered by people outside her household. True celebration grows when the circle widens to include those who are often overlooked. Joy can coexist with disability, grief, scarce resources, and a difficult winter.</p><p><strong>Reflect:</strong> Who might be absent from the way I usually celebrate?</p><p><strong>Practice:</strong> Invite someone into a gathering, or arrange an accessible way for them to share in a celebration on their own terms.</p><p><strong>Prayer:</strong> Lord Jesus, make our celebrations generous and our welcome sincere. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 8,
    "value": "<p><strong>Read:</strong> Mark 10:13-16; Galatians 6:2</p><p><strong>Source and historical context:</strong> When spring arrives, Milly cares for an orphaned lamb. The Oaklands children also save money for a basket carriage that lets Corrie join them among the primroses, rather than only hearing descriptions of the countryside.</p><p><strong>Devotional focus:</strong> Belonging is more than being loved from a distance; it includes practical access to shared life. The children work together to remove an obstacle so Corrie can encounter the trees and flowers for herself. Jesus welcomed children and would not have them pushed to the margins. Care that listens, adapts, and makes participation possible honors dignity better than sentimental pity.</p><p><strong>Reflect:</strong> What barrier prevents someone from joining an activity I take for granted?</p><p><strong>Practice:</strong> Ask what would make an outing, meeting, or celebration easier to access. Offer help based on the person’s answer.</p><p><strong>Prayer:</strong> Welcoming Christ, show us how to remove barriers rather than merely express sympathy. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 9,
    "value": "<p><strong>Read:</strong> Numbers 17:8; John 15:5-8</p><p><strong>Source and historical context:</strong> In his cottage and garden Jonathan teaches Robin from the blossoms on an almond branch, comparing them with Aaron’s budding rod. He explains fruitful living through everyday examples such as kindly words and unselfish actions.</p><p><strong>Devotional focus:</strong> The signs of a flourishing life are not always public achievements. In John’s Gospel, fruit grows through abiding in Christ; here it is seen in steady friendship, patience, and kindness. Jonathan has also lived with deep family loss, yet continues to nurture others. Some seasons are quiet or limited by illness and age. They still hold opportunities for love, and no one needs to earn dignity by proving usefulness.</p><p><strong>Reflect:</strong> Where might patient, quiet kindness be taking root around me?</p><p><strong>Practice:</strong> Thank a person whose often-unnoticed care has strengthened you. Offer a gentle word to someone who needs encouragement.</p><p><strong>Prayer:</strong> God of life, teach me to recognize fruitfulness in humble places and to remain rooted in you. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 10,
    "value": "<p><strong>Read:</strong> Proverbs 12:1; James 1:19-22</p><p><strong>Source and historical context:</strong> Robin begins working as Jonathan’s assistant and feels proud to contribute wages to the family. Although grateful for his mentor, he starts wondering why Jonathan warns him so strongly about pride and temptation, especially after a correction about neglected plants.</p><p><strong>Devotional focus:</strong> New responsibility often brings new confidence. Confidence is good when paired with willingness to learn, but it can turn brittle when we assume we are beyond correction. The invitation of James is to listen and put truth into practice. Robin’s confusion reminds us that instruction works best when accompanied by patient explanation and fairness; neither age nor authority makes every correction automatically right.</p><p><strong>Reflect:</strong> What feedback have I rejected before trying to understand it?</p><p><strong>Practice:</strong> Invite one trusted person to offer constructive feedback, and first ask what they mean before defending yourself.</p><p><strong>Prayer:</strong> Lord, grow in me a teachable spirit that welcomes truth and refuses shame as a method of learning. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 11,
    "value": "<p><strong>Read:</strong> Proverbs 29:5; Ephesians 4:25</p><p><strong>Source and historical context:</strong> The cook at Oaklands praises Robin, offers him apple tart, and asks him to carry a covered basket to an address in town while keeping the errand secret. He feels uneasy but wants to believe he is simply being helpful.</p><p><strong>Devotional focus:</strong> Flattery can become manipulation when an appealing favor is used to obtain silence. Robin faces a pressure he does not yet understand fully. Christian truthfulness does not require instant suspicion of everyone; it asks us to notice secrecy and seek trustworthy advice. A young worker can be both responsible for choices and vulnerable when an older person uses authority or gifts to draw him into wrongdoing.</p><p><strong>Reflect:</strong> Is there a request that feels wrong mainly because I am being told to hide it?</p><p><strong>Practice:</strong> Before agreeing to a secretive favor, seek clarity and consult someone trustworthy. You may say no without providing an elaborate defense.</p><p><strong>Prayer:</strong> God of truth, give me wisdom to recognize pressure and courage to ask for help. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 12,
    "value": "<p><strong>Read:</strong> Proverbs 28:13; Psalm 32:3-5</p><p><strong>Source and historical context:</strong> Robin takes the hidden basket to Andover Street and misleads his mother about why he came home late. He avoids Jonathan’s questions, misses his usual morning help at home, and accepts more cake from the cook.</p><p><strong>Devotional focus:</strong> A concealed choice can spread into several parts of daily life: strained trust, divided loyalties, and fear of being discovered. Robin’s growing distress is not proof that every anxious person has done something wrong. In this particular scene, he knows he is hiding an act he should disclose. Proverbs invites us to turn toward mercy by acknowledging the truth instead of relying on further cover stories.</p><p><strong>Reflect:</strong> Is there a specific truth I need help telling, rather than a vague feeling of guilt?</p><p><strong>Practice:</strong> Talk with a safe, trustworthy person about one situation you have been concealing. Choose a responsible next step that does not place anyone in danger.</p><p><strong>Prayer:</strong> Merciful God, bring light where secrecy has become heavy. Give me wise and safe ways to tell the truth. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 13,
    "value": "<p><strong>Read:</strong> 1 John 1:5-9; Psalm 139:23-24</p><p><strong>Source and historical context:</strong> After receiving cake from Robin, Corrie asks him to tell the story of the first garden. Her questions about God seeing in darkness bring back Robin’s hidden errand. She also recalls that her mother still loves her when she has done wrong.</p><p><strong>Devotional focus:</strong> Corrie’s question points toward a vital distinction: love does not depend on a person’s perfect record. Honest confession is possible because mercy offers hope beyond the mistake. Light is not meant to humiliate; it helps us stop concealing damage and begin repair. Loving someone while naming wrongdoing neither dismisses accountability nor defines them forever by one choice.</p><p><strong>Reflect:</strong> When I make a mistake, do I expect only rejection, or can I imagine a path toward truthful repair?</p><p><strong>Practice:</strong> Read 1 John 1 slowly. Write down one practical step toward honesty and one reminder that you are more than your worst choice.</p><p><strong>Prayer:</strong> Father, let your love lead me into truth, not away from it. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 14,
    "value": "<p><strong>Read:</strong> Proverbs 12:22; James 5:16</p><p><strong>Source and historical context:</strong> Robin has been carrying the cook’s baskets when he accidentally chips a valuable vase while helping Jonathan with flowers. Terrified he might lose his job, he takes the fragment to the cook, who conceals the damage and now has more power over him.</p><p><strong>Devotional focus:</strong> An accident and a deliberate deception are not the same thing. A careful response would be to report the breakage, ask for help, and make reasonable amends. The cook instead uses Robin’s fear to deepen the secret. Scripture’s call to truthful speech is also a call for communities to respond fairly to mistakes; severe or unpredictable punishment makes honesty harder. Grace invites responsibility without coercion.</p><p><strong>Reflect:</strong> Do people around me feel safe enough to report an honest mistake?</p><p><strong>Practice:</strong> If something has gone wrong, describe what happened without exaggeration, own your part, and ask how to make it right.</p><p><strong>Prayer:</strong> God of justice, help us distinguish accidents from lies and offer fair paths to accountability. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 15,
    "value": "<p><strong>Read:</strong> Exodus 23:1-2; Ephesians 4:25</p><p><strong>Source and historical context:</strong> When Clarice lifts the vase to clear away faded roses, its earlier hidden damage causes it to fall apart. She is punished for disobeying a household rule, though she insists the vase broke unexpectedly. Robin hears Jonathan comfort and counsel her while he keeps silent about what he knows.</p><p><strong>Devotional focus:</strong> Clarice may need to discuss her own decision to handle the vase, but she should not bear false blame for the hidden breakage. Robin’s silence turns private fear into another person’s suffering. Loving our neighbor includes telling the truth when our omission lets another person be wrongly accused. We can pursue honesty with appropriate support, especially when power differences make confession frightening.</p><p><strong>Reflect:</strong> Has someone borne consequences because I kept back information that could help them?</p><p><strong>Practice:</strong> Correct a misleading impression you have allowed to stand. If the situation is difficult, ask a trusted person to support a fair conversation.</p><p><strong>Prayer:</strong> Truthful God, make me brave enough to protect another person from a blame that is not theirs. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 16,
    "value": "<p><strong>Read:</strong> Matthew 6:22-23; Psalm 51:10-12</p><p><strong>Source and historical context:</strong> The chapter ends with two children beneath the same moonlight. Clarice prays with renewed peace after speaking with Jonathan; Robin cannot rest because he still hides the truth about the vase and the cook’s errands.</p><p><strong>Devotional focus:</strong> The contrast in the story is not between naturally good and bad children. It is between being willing to come into the light and being afraid to do so. Jesus’s image of the eye and the light asks what guides our vision. Shame can tempt us to withdraw, but grace offers another way: honest prayer, trusted support, and concrete acts of repair.</p><p><strong>Reflect:</strong> Where has shame made me turn away from a truthful conversation?</p><p><strong>Practice:</strong> Name one difficult fact before God. Plan a safe, timely conversation with the person who needs to hear it.</p><p><strong>Prayer:</strong> Jesus, cleanse my vision and help me choose the honest path toward peace. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 17,
    "value": "<p><strong>Read:</strong> Matthew 6:19-21; 1 Timothy 6:17-19</p><p><strong>Source and historical context:</strong> Clarice wakes on her birthday to the canary’s song, her family’s affection, and a table of presents. She receives a gold sovereign, while her father gently questions whether she is becoming too attached to money. Clarice hints that she has a purpose for the gift.</p><p><strong>Devotional focus:</strong> Money is neither a sign of moral superiority nor automatically a temptation. It is a resource we can steward toward good ends. Jesus urges us to consider where our treasure draws our heart. Clarice’s excitement is mixed with a desire to repair what was lost in the earlier vase incident. A gift can become more meaningful when we turn from possession alone toward generous intention.</p><p><strong>Reflect:</strong> What do my spending and saving choices suggest I most value?</p><p><strong>Practice:</strong> Set aside a manageable amount or useful item for a purpose that repairs harm or helps someone else flourish.</p><p><strong>Prayer:</strong> Generous Father, give me gratitude for what I have and wisdom about how to use it. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 18,
    "value": "<p><strong>Read:</strong> Luke 15:8-10; Romans 12:15</p><p><strong>Source and historical context:</strong> Clarice plans to use her birthday sovereign to replace her mother’s vase. Her family hosts a generous gathering in the garden, and Corrie joins the guests. Yet Robin struggles with guilt while celebration continues. At day’s end the sovereign is missing.</p><p><strong>Devotional focus:</strong> A day can hold both joy and trouble. Celebrating others does not mean ignoring those who seem uneasy, and noticing distress need not ruin a gathering. The story’s lost money becomes an occasion to pursue truth carefully rather than indulge suspicion. Like the woman searching for her coin in Jesus’s parable, we may respond with attention and persistence, while remembering that people matter more than property.</p><p><strong>Reflect:</strong> Who at our shared celebrations might need attention rather than another performance of cheerfulness?</p><p><strong>Practice:</strong> Offer a sincere welcome and a quiet check-in to someone at the edge of a gathering, without pressuring them to explain.</p><p><strong>Prayer:</strong> God of joy, help us celebrate generously and notice those whose hearts are troubled. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 19,
    "value": "<p><strong>Read:</strong> Proverbs 18:13; Deuteronomy 19:15</p><p><strong>Source and historical context:</strong> After the sovereign disappears, the household searches. The cook joins the search and suggests that Clarice may simply have misplaced the money. Jonathan notices the uncertainty but does not yet have enough evidence to reach a conclusion.</p><p><strong>Devotional focus:</strong> An accusation can injure a person long after an item is found. Scripture counsels against judgments made before the facts are known. This small scene reminds us to distinguish what we saw from what we suppose. Patient investigation is compatible with care for the person who has suffered the loss and fairness toward everyone questioned.</p><p><strong>Reflect:</strong> Have I treated a suspicion as though it were already an established fact?</p><p><strong>Practice:</strong> When you hear a troubling report, write down what is known, what remains unknown, and who can responsibly clarify it.</p><p><strong>Prayer:</strong> Wise God, guard my words from careless accusation and help me seek truth without favoritism. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 20,
    "value": "<p><strong>Read:</strong> Proverbs 10:9; James 5:16</p><p><strong>Source and historical context:</strong> Jonathan grows concerned after seeing Robin take an unexplained route with a basket. Meanwhile Robin, still hiding his errands, makes another plan to avoid his mother’s questions and takes Corrie out among the fields. Jonathan begins speaking with Mrs. Campbell.</p><p><strong>Devotional focus:</strong> A hidden story demands constant adjustments. Robin’s desire to keep everyone happy has become a maze of evasions. Yet caution matters: someone who behaves secretively may be afraid, pressured, or in genuine danger, not merely dishonest. Jonathan’s careful attention is useful when joined to evidence and protection. The path toward freedom will require a truthful account, not more ingenious excuses.</p><p><strong>Reflect:</strong> Where am I spending energy maintaining a story instead of seeking help?</p><p><strong>Practice:</strong> List the facts of one confusing situation. If someone is using secrecy to control you, speak to a safe person before confronting them.</p><p><strong>Prayer:</strong> God, lead us out of confusion with both truth and compassion. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 21,
    "value": "<p><strong>Read:</strong> Psalm 32:1-5; Galatians 6:1-2</p><p><strong>Source and historical context:</strong> Jonathan asks Robin directly about the basket, and the boy finally admits his role in the hidden errands. Mrs. Campbell is devastated; Robin asks her forgiveness and fears losing his work. Jonathan offers to accompany him to the owner instead of leaving him to face the conversation alone.</p><p><strong>Devotional focus:</strong> Confession is a beginning, not the whole work of repair. Robin needs to account for what he did, while the adults also need to examine how he was pressured. Paul directs believers to restore someone gently and carry burdens together. Jonathan’s presence can model the courage of accompaniment: do not excuse the wrong, but do not abandon the person who is seeking a way back.</p><p><strong>Reflect:</strong> Whom could I accompany through a difficult but necessary conversation?</p><p><strong>Practice:</strong> If you need to confess a mistake, arrange support from someone fair and trustworthy, then state the facts and accept appropriate responsibility.</p><p><strong>Prayer:</strong> Patient Lord, give us courage for truth and companions who make repair possible. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 22,
    "value": "<p><strong>Read:</strong> Luke 19:1-10; 1 John 1:8-9</p><p><strong>Source and historical context:</strong> Robin and Jonathan meet the owner of Oaklands. The basket is opened, revealing stolen household food and the missing ring’s pawn ticket; the cook’s dishonest scheme comes to light. Robin tells the truth about his involvement and is allowed to remain at work.</p><p><strong>Devotional focus:</strong> The owner holds different people accountable for what they did, and Robin receives a chance to begin again. In the story, the cook is dismissed and later suffers serious consequences; this should not be read as a promise that punishment alone heals wrongdoing. Jesus’s encounter with Zacchaeus joins repentance to restitution and a restored future. Mercy does not deny harm. It creates a route for truthful change and fair repair.</p><p><strong>Reflect:</strong> What would meaningful repair look like after a particular wrong?</p><p><strong>Practice:</strong> Identify the harm, the person affected, and one proportionate step toward restitution. Avoid promises you cannot keep.</p><p><strong>Prayer:</strong> Merciful Christ, teach us to name wrong clearly and make space for real change. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 23,
    "value": "<p><strong>Read:</strong> Psalm 51:1-12; Ephesians 4:31-32</p><p><strong>Source and historical context:</strong> Robin prays words of Psalm 51. Jonathan retrieves the pawned ring, and Clarice later lets Robin know that her mother understands the truth about the damaged vase. Robin finds renewed ease speaking openly with his mother and telling Corrie stories.</p><p><strong>Devotional focus:</strong> Forgiveness does not mean that yesterday never happened. Robin must learn from what his choices cost, and practical restitution is still needed. But his story also refuses the claim that one failure fixes a person’s identity forever. Psalm 51 asks for a renewed heart, and Paul calls communities to gentleness and forgiveness. Healing takes truth, time, responsibility, and relationships willing to rebuild.</p><p><strong>Reflect:</strong> What small action could help restore trust without demanding immediate closeness?</p><p><strong>Practice:</strong> Choose an act of restitution or a consistent habit that demonstrates the change you hope to make.</p><p><strong>Prayer:</strong> God of steadfast mercy, renew my heart and guide me toward faithful repair. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 24,
    "value": "<p><strong>Read:</strong> Isaiah 58:6-10; Psalm 46:1-3</p><p><strong>Source and historical context:</strong> Mrs. Campbell is told the rent on her town home will rise beyond what she can pay. She seeks help at Oaklands and discovers that the family has prepared a new cottage, Forest Lodge, for her and the children as part of her laundry work arrangement.</p><p><strong>Devotional focus:</strong> Housing insecurity is not a failure of character. This scene holds both the threat of displacement and the practical mercy of a secure place to live. Help is more than kind words: it can include fair housing, work, accessible transport, and protection from exploitation. The offer of Forest Lodge changes the family’s circumstances because people with resources decide to act. Faithful communities can do the same without expecting gratitude to replace justice.</p><p><strong>Reflect:</strong> Where could I move from expressing sympathy to helping meet a practical need?</p><p><strong>Practice:</strong> Support a local effort addressing housing, food, or accessible care—or assist a neighbor with a specific urgent task.</p><p><strong>Prayer:</strong> God our refuge, make us generous and just toward people whose homes and livelihoods are under pressure. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 25,
    "value": "<p><strong>Read:</strong> Romans 12:9-13; Philippians 4:11-13</p><p><strong>Source and historical context:</strong> As the Campbells settle into Forest Lodge, Corrie gains easier access to the outdoors, friendship with the Oaklands children, and more varied days. The text says she does not completely recover, but her world becomes richer through inclusion and care.</p><p><strong>Devotional focus:</strong> A change of address does not remove every limitation or make someone’s life worthwhile for the first time. Corrie had dignity and agency in the city too. What the move provides is access, companionship, rest, and opportunities to share life. Christian hospitality is not measured only by grand gifts; it becomes meaningful when it changes the experience of the people welcomed and lets them participate freely.</p><p><strong>Reflect:</strong> Who in my community is welcome in words but still excluded in practice?</p><p><strong>Practice:</strong> Make one concrete change that improves someone’s ability to participate—transport, seating, timing, or accessible communication.</p><p><strong>Prayer:</strong> Lord, make our homes and communities places of genuine belonging. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 26,
    "value": "<p><strong>Read:</strong> Psalm 92:12-15; Revelation 22:1-5</p><p><strong>Source and historical context:</strong> Years pass at Forest Lodge. Jonathan’s health declines, and the family cares for him as he once cared for them. Corrie continues to share friendship and thoughtful conversation. Together they speak of Eden, the river of life, and the promised renewal of creation.</p><p><strong>Devotional focus:</strong> Aging and disability are not failures to produce enough. Jonathan and Corrie can receive love, offer presence, and hold hope without being described as passive burdens. Psalm 92 imagines fruit even in old age; Revelation looks toward a world healed by God. Neither passage obliges a sick person to be cheerful or to call suffering good. The Christian community is invited to honor and accompany people through every season.</p><p><strong>Reflect:</strong> How can I honor someone whose strength has changed without treating them as less valuable?</p><p><strong>Practice:</strong> Spend unhurried time with an older person or someone whose activity is limited. Follow their lead in what they want to talk about or do.</p><p><strong>Prayer:</strong> God of every season, uphold us as our abilities change and make our care mutual. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 27,
    "value": "<p><strong>Read:</strong> Psalm 23:4-6; Revelation 21:3-5</p><p><strong>Source and historical context:</strong> Jonathan receives a flowering almond branch from Clarice, speaks of the promised resurrection, and dies after their final Sunday conversation. The family mourns him and remembers the care he gave children, neighbors, and the Campbells.</p><p><strong>Devotional focus:</strong> The Christian hope of new life does not tell mourners to stop missing someone they love. Jonathan’s parting scene joins the familiar blossoms of his garden to a promise that death will not have the last word. The remembrance of his faithful presence matters because love leaves traces in a community. We can honor those who have died through gratitude, grief, and the living acts of care they taught us.</p><p><strong>Reflect:</strong> Whose influence continues to shape the way I love others?</p><p><strong>Practice:</strong> Recall a person you miss, name a gift they gave you, and carry one expression of that gift into your life today.</p><p><strong>Prayer:</strong> Lord of resurrection, comfort those who grieve and keep hope alive alongside our tears. Amen.</p>"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

-- Update only plan-level Scripture references, never user-owned reference rows.
do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 1,
    "references": [
      "Luke 2:8-20",
      "John 10:11-15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 2,
    "references": [
      "1 John 3:16-18",
      "Philippians 2:3-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 3,
    "references": [
      "Psalm 46:1-7",
      "Revelation 21:1-5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 4,
    "references": [
      "Psalm 1:1-3",
      "John 15:4-5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 5,
    "references": [
      "Philippians 2:3-5",
      "Romans 12:15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 6,
    "references": [
      "2 Corinthians 9:6-8",
      "Mark 12:41-44"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 7,
    "references": [
      "Luke 2:10-14",
      "Nehemiah 8:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 8,
    "references": [
      "Mark 10:13-16",
      "Galatians 6:2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 9,
    "references": [
      "Numbers 17:8",
      "John 15:5-8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 10,
    "references": [
      "Proverbs 12:1",
      "James 1:19-22"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 11,
    "references": [
      "Proverbs 29:5",
      "Ephesians 4:25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 12,
    "references": [
      "Proverbs 28:13",
      "Psalm 32:3-5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 13,
    "references": [
      "1 John 1:5-9",
      "Psalm 139:23-24"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 14,
    "references": [
      "Proverbs 12:22",
      "James 5:16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 15,
    "references": [
      "Exodus 23:1-2",
      "Ephesians 4:25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 16,
    "references": [
      "Matthew 6:22-23",
      "Psalm 51:10-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 17,
    "references": [
      "Matthew 6:19-21",
      "1 Timothy 6:17-19"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 18,
    "references": [
      "Luke 15:8-10",
      "Romans 12:15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 19,
    "references": [
      "Proverbs 18:13",
      "Deuteronomy 19:15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 20,
    "references": [
      "Proverbs 10:9",
      "James 5:16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 21,
    "references": [
      "Psalm 32:1-5",
      "Galatians 6:1-2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 22,
    "references": [
      "Luke 19:1-10",
      "1 John 1:8-9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 23,
    "references": [
      "Psalm 51:1-12",
      "Ephesians 4:31-32"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 24,
    "references": [
      "Isaiah 58:6-10",
      "Psalm 46:1-3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 25,
    "references": [
      "Romans 12:9-13",
      "Philippians 4:11-13"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 26,
    "references": [
      "Psalm 92:12-15",
      "Revelation 22:1-5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "day_number": 27,
    "references": [
      "Psalm 23:4-6",
      "Revelation 21:3-5"
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
where id = '90000000-0000-0000-0000-000000000342'::uuid;

commit;
