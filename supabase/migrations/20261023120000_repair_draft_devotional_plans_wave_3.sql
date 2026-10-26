-- Three contemporary devotional adaptations from historical antislavery and sermon texts.
-- Existing plan/day IDs, day numbers, and user progress remain in place.
-- Historical source arguments are clearly identified as paraphrases.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-23 12:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "value": "Praying for Freedom: Nine Readings from an Antislavery Tract"
  },
  {
    "id": "90000000-0000-0000-0000-000000000350",
    "value": "Following Christ: Five Readings from William Penn"
  },
  {
    "id": "90000000-0000-0000-0000-000000000357",
    "value": "Gratitude and the Common Good: Six Readings from an 1855 Sermon"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-23 12:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "value": "Nine devotional readings from James A. Thome's 1859 American antislavery tract and an appended sermon by E. N. Kirk. Each day presents a short, labeled editorial paraphrase of the historical argument, a Scripture focus, context, a new reflection, and a prayer. The source is an abolitionist appeal, not firsthand testimony from people who were enslaved. Its full text is linked."
  },
  {
    "id": "90000000-0000-0000-0000-000000000350",
    "value": "Five contemporary devotional readings based on William Penn's 1694 sermon, reprinted in 1836. Each pairs a labeled source-based paraphrase with Scripture, context, reflection, and prayer. The linked edition includes a later publisher's preface that is omitted here."
  },
  {
    "id": "90000000-0000-0000-0000-000000000357",
    "value": "Six contemporary devotional readings based on N. C. Burt's 1855 Baltimore Thanksgiving sermon. Clearly labeled source paraphrases are paired with Scripture, context, reflection, and prayer. The full linked sermon also advocates a favored public role for Christianity; that historical argument needs careful reading."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-23 12:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "value": "No Person Is Property",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "value": "The Spirit Helps Us Pray",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "value": "Face Injustice Directly",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "value": "Remember the Oppressed Together",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "value": "Pray and Act for Freedom",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "value": "Remember People, Not an Abstraction",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "value": "Pray for Freedom without Favoritism",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "value": "Carry This Prayer into Community",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "value": "Repentance and Repair",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000350",
    "value": "A Light That Leads Us Home",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000350",
    "value": "Christ Is Near in Our Weakness",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000350",
    "value": "Living to the One Who Loves Us",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000350",
    "value": "Look to Jesus When Weary",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000350",
    "value": "The Shepherd Who Seeks the Lost",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000357",
    "value": "Gratitude with Compassion",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000357",
    "value": "Trust Without Presuming",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000357",
    "value": "Faith Expressed in Public Life",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000357",
    "value": "A Family of Nations",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000357",
    "value": "Peacemaking Beyond Pride",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000357",
    "value": "Serve the Common Good",
    "day_number": 6
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-23 12:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "value": "<p><strong>Scripture focus:</strong> Genesis 1:26-27</p><p><strong>Historical context:</strong> The 1859 tract opens with a separate antislavery statement by Albert Barnes, then begins Thome's own appeal. This reading follows Thome's opening account of slavery under American law.</p><p><strong>Source paraphrase — James A. Thome (1859):</strong> Thome says that slavery's central wrong is treating people as property. Its laws denied enslaved people rights and protection while serving the interests of those who claimed to own them.</p><p><strong>Reflection:</strong> Genesis names every human being as God's image-bearer. The law Thome describes contradicted that dignity; its victims were people with lives and voices of their own. Whose voice can you listen to today before speaking on their behalf?</p><p><strong>Prayer:</strong> Creator God, teach us to honor your image in every person. Expose ways we deny others dignity, and lead us to listen and act justly. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "value": "<p><strong>Scripture focus:</strong> Romans 8:26-27</p><p><strong>Historical context:</strong> Thome rejects the claim that slavery was acceptable if individual owners were kind. He then turns to Christian prayer as part of the struggle to abolish the institution.</p><p><strong>Source paraphrase — James A. Thome (1859):</strong> The wrong lies in making a person someone else's possession, Thome argues. He urges believers to pray for its end, trusting the Holy Spirit to shape their petitions and Jesus Christ to intercede.</p><p><strong>Reflection:</strong> The Spirit helps us pray when we do not know what to say. Prayer is not a way to control God or avoid responsibility. Bring a specific injustice before him, and ask what love and truth require of you.</p><p><strong>Prayer:</strong> Holy Spirit, guide our prayers toward your justice. Lord Jesus, intercede for those harmed by oppression and make us faithful neighbors. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "value": "<p><strong>Scripture focus:</strong> Isaiah 58:6-7</p><p><strong>Historical context:</strong> Thome addresses churches that hoped slavery would fade without direct opposition. He writes before emancipation in the United States.</p><p><strong>Source paraphrase — James A. Thome (1859):</strong> Thome argues that the church must name slavery as sin, oppose it openly, and seek immediate emancipation. Quiet hope that it will disappear on its own is inadequate.</p><p><strong>Reflection:</strong> Isaiah joins worship to loosening unjust bonds and sharing what people need. When a wrong is known, what truthful and practical step can your community take? Listen first to those who bear its cost.</p><p><strong>Prayer:</strong> God of justice, keep our worship honest. Give your church courage to name wrong, hear those harmed, and pursue their freedom. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "value": "<p><strong>Scripture focus:</strong> Luke 18:1-8</p><p><strong>Historical context:</strong> In the tract's next section, Thome laments the absence of prayer for enslaved people in American church gatherings. He also reviews the public antislavery efforts of his day.</p><p><strong>Source paraphrase — James A. Thome (1859):</strong> Thome says believers should not leave enslaved people out of their shared prayers. He sees persistent prayer as necessary alongside public words and other attempts to end slavery.</p><p><strong>Reflection:</strong> Jesus' parable honors a widow who keeps asking for justice. A congregation can likewise remember people harmed by injustice without speaking over them. Whose stated needs could your community carry into prayer and concrete care?</p><p><strong>Prayer:</strong> Faithful God, hear those who cry out for justice. Keep our shared prayers attentive to their needs and move us toward faithful care. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "value": "<p><strong>Scripture focus:</strong> James 2:15-17</p><p><strong>Historical context:</strong> Thome calls Christians to pray urgently for abolition while acknowledging other means of opposing slavery. He resists an appeal to peace that would leave the institution intact.</p><p><strong>Source paraphrase — James A. Thome (1859):</strong> Thome urges sustained personal and shared prayer for enslaved people's freedom. He does not discard other efforts; he asks that prayer accompany an unambiguous demand to end slavery.</p><p><strong>Reflection:</strong> James asks what good it does to bless a neighbor while withholding needed help. Prayer can steady courageous action; action can give shape to prayer. What useful step is within your reach this week?</p><p><strong>Prayer:</strong> Lord, keep us from settling for words alone. Give us wisdom, perseverance, and practical love in the work of justice. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "value": "<p><strong>Scripture focus:</strong> Hebrews 13:3</p><p><strong>Historical context:</strong> After arguing against the institution, Thome turns attention to the people who suffered under it. His tract speaks about them from an abolitionist's position, not in their own voices.</p><p><strong>Source paraphrase — James A. Thome (1859):</strong> Thome insists that opposing slavery cannot remain an abstract position. Enslaved people belonged to the same human family, with rights, relationships, and hopes that slavery violated.</p><p><strong>Reflection:</strong> Hebrews asks us to remember people in prison as though bound with them. Remembering begins with refusing to reduce people to a cause or a statistic. Whose testimony could make your concern more attentive and specific?</p><p><strong>Prayer:</strong> God who sees each person, hear those whose freedom and relationships are threatened. Teach us to attend to their voices and defend their dignity. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "value": "<p><strong>Scripture focus:</strong> James 2:1-9</p><p><strong>Historical context:</strong> Thome rejects prayers that assume bondage must continue. He also challenges racial prejudice that could make Christians less willing to pray for Black people enslaved in the United States.</p><p><strong>Source paraphrase — James A. Thome (1859):</strong> Thome asks believers to pray for emancipation, not only for comfort within slavery. He warns that prejudice must not diminish concern for enslaved neighbors.</p><p><strong>Reflection:</strong> James condemns favoritism among believers. Prayer for freedom should make room for people's own choices, families, work, and worship. Where might bias narrow the circle of people you notice or the freedom you want for them?</p><p><strong>Prayer:</strong> Impartial Lord, uncover prejudice in us. Teach us to seek freedom and full dignity for every neighbor. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "value": "<p><strong>Scripture focus:</strong> Galatians 6:2</p><p><strong>Historical context:</strong> Thome closes his tract by appealing to readers, parents, new believers, and ministers. The inherited slice then begins a separately attributed sermon; this reading draws only on Thome's closing appeal.</p><p><strong>Source paraphrase — James A. Thome (1859):</strong> Thome asks Christians to bring the wrongs suffered by enslaved people into private and gathered prayer. He calls households and churches to share this burden instead of overlooking it.</p><p><strong>Reflection:</strong> Bearing a burden together takes more than one moment of concern. Make room for sustained prayer, listening, and accountable help in your community. What practice could you begin or strengthen?</p><p><strong>Prayer:</strong> Lord Jesus, teach our households and churches to carry one another's burdens. Keep us attentive, humble, and steadfast. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "value": "<p><strong>Scripture focus:</strong> James 5:1-6</p><p><strong>Historical context:</strong> The source's final prose is an appended sermon by E. N. Kirk, not by Thome. Kirk addresses the harm done by slaveholders and calls Christians to pray for them as well as for those enslaved.</p><p><strong>Source paraphrase — E. N. Kirk (appended sermon):</strong> Kirk lists losses imposed on enslaved people: control over their work, wages, family life, and worship. He urges prayer that those who maintain slavery will turn from it.</p><p><strong>Reflection:</strong> James says withheld wages cry out to God. Concern for wrongdoers cannot take priority over the freedom and material needs of those harmed. Repentance must surrender unjust power and make repair where possible.</p><p><strong>Prayer:</strong> God of truth and mercy, hear those deprived of freedom and the fruit of their work. Turn oppressors from harm; bring justice, restitution, and healing. Amen.</p>",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000350",
    "value": "<p><strong>Read:</strong> John 3:16-17; Romans 5:1</p><p><strong>Historical context:</strong> William Penn preached to a Quaker meeting in London in 1694. An 1836 publisher added a later preface to the surviving edition; this reading begins in Penn's sermon. He speaks of Christ as the light who makes peace with God possible.</p><p><strong>Source-based editorial paraphrase:</strong> Those who receive Christ's light and turn from sin may find peace with God.</p><p><strong>Reflect:</strong> Penn invites hearers to receive the light of Christ and turn from what damages their communion with God. Jesus' gift comes before our effort to change. Where do you need his light today? Name one honest step toward peace with God and with another person.</p><p><strong>Prayer:</strong> Lord Jesus, thank you for coming toward us in love. Show me what I need to bring into your light, and lead me in the way of peace. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000350",
    "value": "<p><strong>Read:</strong> John 14:6; Hebrews 4:15-16</p><p><strong>Historical context:</strong> Penn's sermon places reconciliation with God in Jesus Christ. Later in this section he also urges self-examination; his invitation begins with Christ's help.</p><p><strong>Source-based editorial paraphrase:</strong> Only Jesus Christ can bring people back into communion with God; he is the light and leader of his people.</p><p><strong>Reflect:</strong> A truthful look at our lives can reveal weakness without leaving us alone with it. Hebrews says Jesus knows temptation and invites us to approach him for mercy. What need have you been hiding because you think you must solve it first? Bring it to him plainly.</p><p><strong>Prayer:</strong> Merciful Christ, meet me in weakness. Give me courage to be truthful, to receive your grace, and to take the next faithful step. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000350",
    "value": "<p><strong>Read:</strong> Romans 6:11-14; 2 Corinthians 5:14-15</p><p><strong>Historical context:</strong> Penn turns from receiving Christ to the shape of a changed life. His language of dying to sin echoes Paul's account of being alive to God in Christ.</p><p><strong>Source-based editorial paraphrase:</strong> Penn urges believers to turn from sin and live for Christ, who died for them.</p><p><strong>Reflect:</strong> Christ's love can change what we choose when an old habit calls. Change is usually practiced in ordinary decisions, with grace for the times we stumble. Which habit draws you away from love of God or neighbor? Ask for help with one concrete choice today.</p><p><strong>Prayer:</strong> Jesus, you gave yourself for us. Teach me to live in your grace, to turn from harmful habits, and to love the people before me today. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000350",
    "value": "<p><strong>Read:</strong> Hebrews 12:1-3</p><p><strong>Historical context:</strong> This part of Penn's sermon quotes Hebrews at length and addresses persecution. The source thought is summarized here so the Scripture itself can be read in its full setting.</p><p><strong>Source-based editorial paraphrase:</strong> Penn urges his hearers to keep Jesus in view through trials. Drawing on Hebrews 12, he points to Christ's endurance and calls weary believers to continue their journey with patience.</p><p><strong>Reflect:</strong> Hebrews does not ask us to pretend that a hard road is easy. It points us to Jesus, who endured suffering and now sustains his people. What is making you weary? Consider a small next step, and let someone trustworthy know where you need support.</p><p><strong>Prayer:</strong> Patient Lord, keep my eyes on Jesus. Strengthen me in difficulty, and help me receive the companionship and care I need. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000350",
    "value": "<p><strong>Read:</strong> Luke 15:3-7; Isaiah 40:11</p><p><strong>Historical context:</strong> Penn ends his sermon with the image of Christ gathering wandering sheep. He draws together Jesus' lost-sheep teaching and the Bible's picture of a shepherd's care.</p><p><strong>Source-based editorial paraphrase:</strong> Penn pictures Christ as a shepherd who seeks wandering people, carries them, and leads them to rest and life.</p><p><strong>Reflect:</strong> A wandering sheep needs to be found and carried, not scolded into finding the way alone. Jesus describes the shepherd's joy in finding what was lost. Where do you need to receive his care? Who near you might need patient, practical help today?</p><p><strong>Prayer:</strong> Good Shepherd, seek those who feel far away, including me. Carry the weary, guide our steps, and teach us to care for one another. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000357",
    "value": "<p><strong>Read:</strong> Psalm 136:1; Romans 12:15</p><p><strong>Historical context:</strong> N. C. Burt preached this Thanksgiving sermon in Baltimore in 1855. He gave thanks that a nearby epidemic had spared his city, while acknowledging its devastation elsewhere.</p><p><strong>Source-based editorial paraphrase:</strong> The congregation gathered to give thanks for mercies received during the preceding year.</p><p><strong>Reflect:</strong> Gratitude for a mercy received can live alongside grief for those who suffered. Thanksgiving need not suggest that God loved the spared more. Name a gift you have received; then consider how it might move you toward someone who is ill or grieving.</p><p><strong>Prayer:</strong> God of mercy, thank you for the gifts of this day. Comfort those who mourn and make my gratitude generous toward others. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000357",
    "value": "<p><strong>Read:</strong> Psalm 46:1-3; Daniel 2:20-22</p><p><strong>Historical context:</strong> Burt argues that God is at work in history and then cites biblical accounts of nations. Those accounts concern particular events in Scripture; they do not authorize us to label every present event as a specific act of divine judgment.</p><p><strong>Source-based editorial paraphrase:</strong> Burt sees God's providence in history and believes nations bear responsibilities before God.</p><p><strong>Reflect:</strong> Faith can trust God's rule while admitting how little we know about the meaning of an event. When news is troubling, resist easy claims about whom God is punishing. Pray for those affected, and ask what help you can offer.</p><p><strong>Prayer:</strong> Lord of history, hold us steady when events confuse or frighten us. Give us humility in our words and compassion in our actions. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000357",
    "value": "<p><strong>Read:</strong> Micah 6:8; Romans 13:10</p><p><strong>Historical context:</strong> Burt also argued that government should favor Christianity, a claim shaped by his 1855 setting. This selection concerns the believer's own conduct in public life, where faith can be shown through justice, mercy, and respect for every neighbor's conscience.</p><p><strong>Source-based editorial paraphrase:</strong> Burt argues that personal faith should shape a person's conduct in every relationship.</p><p><strong>Reflect:</strong> Our choices as neighbors, workers, and citizens affect other people. Micah names justice, mercy, and humble walking with God. Where could you practice these today in a public responsibility, especially toward someone whose beliefs differ from yours?</p><p><strong>Prayer:</strong> God, shape my public and private choices with justice and mercy. Help me honor the conscience and dignity of every neighbor. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000357",
    "value": "<p><strong>Read:</strong> Acts 17:26-27; Philippians 2:3-4</p><p><strong>Historical context:</strong> Burt turns from one country's concerns to the bonds among nations. His image of a human family draws on Paul's speech in Acts 17.</p><p><strong>Source-based editorial paraphrase:</strong> Burt says nations depend on one another and owe care to one another. Love of country has limits within a wider human family.</p><p><strong>Reflect:</strong> Love of home need not close our eyes to people elsewhere. Goods, labor, knowledge, and care cross borders every day. Think of one person or community beyond your own country whose well-being is connected to yours. How can you pray, learn, or act with care?</p><p><strong>Prayer:</strong> Creator of every people, widen my concern beyond familiar borders. Help nations and neighbors work for one another's good. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000357",
    "value": "<p><strong>Read:</strong> Matthew 5:9; James 3:17-18</p><p><strong>Historical context:</strong> Burt condemned a contemporary war among Christian-majority countries. In the middle of a national sermon, he questioned pride and revenge dressed as patriotism.</p><p><strong>Source-based editorial paraphrase:</strong> Burt asks that love of country turn away from pride and revenge toward concern for other people.</p><p><strong>Reflect:</strong> Jesus calls peacemakers blessed. Peacemaking begins where we resist dehumanizing speech and listen before taking a side. It also seeks justice for those harmed. Where could you replace pride or retaliation with a truthful, peace-seeking action?</p><p><strong>Prayer:</strong> Prince of Peace, turn our anger away from cruelty. Teach me to seek justice and peace with humility, courage, and love. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000357",
    "value": "<p><strong>Read:</strong> Jeremiah 29:7; Matthew 5:16</p><p><strong>Historical context:</strong> The original conclusion also treats America's future as specially bound to national Christian identity. This reading draws its call to integrity into a prayer for the good of all who share a community.</p><p><strong>Source-based editorial paraphrase:</strong> Burt closes by urging citizens to resist corrupt party loyalties and seek fair representation. He links the nation's welfare to the moral choices of its people.</p><p><strong>Reflect:</strong> Jeremiah urged exiles to seek the welfare of the city where they lived. Honest public life serves people across parties and beliefs. What local need could you meet with a neighbor this week? Choose a step that helps without asking for recognition.</p><p><strong>Prayer:</strong> Lord, help me seek the good of my community. Give its leaders integrity and give me a generous heart toward every neighbor. Amen.</p>",
    "day_number": 6
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "day_number": 1,
    "references": [
      "Genesis 1:26-27"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "day_number": 2,
    "references": [
      "Romans 8:26-27"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "day_number": 3,
    "references": [
      "Isaiah 58:6-7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "day_number": 4,
    "references": [
      "Luke 18:1-8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "day_number": 5,
    "references": [
      "James 2:15-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "day_number": 6,
    "references": [
      "Hebrews 13:3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "day_number": 7,
    "references": [
      "James 2:1-9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "day_number": 8,
    "references": [
      "Galatians 6:2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000219",
    "day_number": 9,
    "references": [
      "James 5:1-6"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000350",
    "day_number": 1,
    "references": [
      "John 3:16-17",
      "Romans 5:1"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000350",
    "day_number": 2,
    "references": [
      "John 14:6",
      "Hebrews 4:15-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000350",
    "day_number": 3,
    "references": [
      "Romans 6:11-14",
      "2 Corinthians 5:14-15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000350",
    "day_number": 5,
    "references": [
      "Luke 15:3-7",
      "Isaiah 40:11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000357",
    "day_number": 1,
    "references": [
      "Psalm 136:1",
      "Romans 12:15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000357",
    "day_number": 2,
    "references": [
      "Psalm 46:1-3",
      "Daniel 2:20-22"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000357",
    "day_number": 3,
    "references": [
      "Micah 6:8",
      "Romans 13:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000357",
    "day_number": 4,
    "references": [
      "Acts 17:26-27",
      "Philippians 2:3-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000357",
    "day_number": 5,
    "references": [
      "Matthew 5:9",
      "James 3:17-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000357",
    "day_number": 6,
    "references": [
      "Jeremiah 29:7",
      "Matthew 5:16"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-23 12:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-23 12:00:00+00', timestamptz '2026-10-23 12:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish three source-checked devotional adaptations.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-23 12:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000219'::uuid,
  '90000000-0000-0000-0000-000000000350'::uuid,
  '90000000-0000-0000-0000-000000000357'::uuid
);
