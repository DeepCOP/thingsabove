-- Source-based repairs to eight devotional plans held as draft after the previous wave.
-- Six reviewed prayer and short-sermon plans are republished here.
-- The other two remain draft for the review documented in adaptation-progress.md.
-- No existing devotional day or user progress is deleted.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-22 15:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "value": "Prayer and Neighborly Care: Two Readings from Joseph Phillimore"
  },
  {
    "id": "90000000-0000-0000-0000-000000000373",
    "value": "Remembering Christ in Grief: Seven Readings from an 1832 Sermon"
  },
  {
    "id": "90000000-0000-0000-0000-000000000374",
    "value": "Let Every Breath Praise: Three Readings from Psalm 150"
  },
  {
    "id": "90000000-0000-0000-0000-000000000393",
    "value": "Witnesses to Christ: Three Readings from an 1877 Sermon"
  },
  {
    "id": "90000000-0000-0000-0000-000000000397",
    "value": "Sharing Scripture with Love: Five Readings from an 1815 Sermon"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-22 15:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000102",
    "value": "Charles H. Spurgeon's historical morning and evening readings. Twelve passages of nineteenth-century sectarian polemic have been replaced with clearly labeled editorial reflections. The plan remains under review for modern language, historical context, and devotional suitability across all 366 dates."
  },
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "value": "Two devotional readings adapted from Joseph Phillimore's 1814 pastoral tract. Historical excerpts are identified separately from new Scripture focus, context, reflection, and prayer. The complete linked tract also discusses local parish affairs and nineteenth-century wars."
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Twenty-five newly paraphrased prayers following the themes of Johann Habermann's Morning and Evening Prayers for All Days of the Week: fourteen prayers for the seven mornings and evenings, followed by eleven prayers for everyday life. The wording is a contemporary editorial adaptation; the linked public-domain book is the source."
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "A modern-language adaptation of 115 numbered prayers, hymns, and Scripture readings for children from Little Folded Hands, one item per day. Most items are newly written editorial paraphrases, including passages about illness, death, and family care; the remaining short source items have updated language. The original text is linked as the source."
  },
  {
    "id": "90000000-0000-0000-0000-000000000373",
    "value": "Seven contemporary devotional readings based on John Alexander's 1832 funeral sermon for Joseph Kinghorn. Historical themes are paraphrased and clearly distinguished from new reflection and prayer; the complete sermon remains linked as the source."
  },
  {
    "id": "90000000-0000-0000-0000-000000000374",
    "value": "Three modern-English devotional readings drawn from the Psalm 150 exposition in John Boys's 1613 sermon. The source's political and sectarian arguments are left in their historical setting; the linked original preserves the complete text."
  },
  {
    "id": "90000000-0000-0000-0000-000000000393",
    "value": "Three devotional readings selected from Edward Hoare's 1877 sermon at a bishop's consecration in York. Each includes a Scripture focus, a source excerpt, historical context, a new reflection, and a prayer. The linked original preserves the complete sermon and its Anglican church disputes."
  },
  {
    "id": "90000000-0000-0000-0000-000000000397",
    "value": "Five devotional readings selected from Francis Cunningham's 1815 Bible Society sermon. Short passages from the modernized source are paired with historical context, new reflection, and prayer. The linked original preserves the complete appeal."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-22 15:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "value": "Begin the Day in Prayer",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "value": "Make Room for Every Neighbor",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "Prayer for Faith as I Grow",
    "day_number": 112
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "The Lord's Prayer (modern paraphrase)",
    "day_number": 113
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "Psalm 23 (modern paraphrase)",
    "day_number": 114
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "The Common Doxology (modern paraphrase)",
    "day_number": 115
  },
  {
    "id": "90000000-0000-0000-0000-000000000373",
    "value": "Remembering the Gospel",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000373",
    "value": "Care That Takes Time",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000373",
    "value": "Truth Spoken with Love",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000373",
    "value": "Grace Behind Every Gift",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000373",
    "value": "Hope That Does Not Silence Grief",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000373",
    "value": "Remember by Doing",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000373",
    "value": "A Community That Carries On",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000374",
    "value": "Praise Begins with God",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000393",
    "value": "Strength for Ordinary Service",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000393",
    "value": "Keep Christ in View",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000393",
    "value": "Faith and the Spirit's Presence",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000397",
    "value": "The Good News We Share",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000397",
    "value": "Work Together for Good",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000397",
    "value": "Unity That Serves",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000397",
    "value": "Imagine Receiving the Gift",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000397",
    "value": "Share Comfort Freely",
    "day_number": 5
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-22 15:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000102",
    "value": "<p>Morning</p>\n<p><em>“The Lord our Righteousness.”</em></p>\n<p>Jeremiah 23:6</p>\n<p>It will always give a Christian the greatest calm, quiet, ease, and peace, to think of the perfect righteousness of Christ. How often are the saints of God downcast and sad! I do not think they ought to be. I do not think they would if they could always see their perfection in Christ. There are some who are always talking about corruption, and the depravity of the heart, and the innate evil of the soul. This is quite true, but why not go a little further, and remember that we are “perfect in Christ Jesus.” It is no wonder that those who are dwelling upon their own corruption should wear such downcast looks; but surely if we call to mind that “Christ is made to us righteousness,” we shall be of good cheer. What though distresses afflict me, though Satan assault me, though there may be many things to be experienced before I get to heaven, those are done for me in the covenant of divine grace; there is nothing wanting in my Lord, Christ has done it all. On the cross he said, “It is finished!” and if it be finished, then am I complete in him, and can rejoice with joy unspeakable and full of glory, “Not having my own righteousness, which is of the law, but that which is through the faith of Christ, the righteousness which is of God by faith.” You will not find on this side heaven a holier people than those who receive into their hearts the doctrine of Christ’s righteousness. When the believer says, “I live on Christ alone; I rest on him solely for salvation; and I believe that, however unworthy, I am still saved in Jesus;” then there rises up as a motive of gratitude this thought—“Shall I not live to Christ? Shall I not love him and serve him, seeing that I am saved by his merits?” “The love of Christ constrains us,” “that they which live should not from now on live to themselves but to him which died for them.” If saved by imputed righteousness, we shall greatly value imparted righteousness.</p>\n<p>Evening</p>\n<p><em>“Then Ahimaaz ran by the way of the plain, and overran Cushi.”</em></p>\n<p>2 Samuel 18:23</p>\n<p><strong>Editorial evening reflection:</strong> Ahimaaz chose a level path and arrived first (2 Samuel 18:23). This image can prompt us to seek God with honesty rather than chase promises of a secret shortcut. Bring a real concern to Christ in prayer, and choose one clear act of faithfulness today.</p>\n<p>In reading this passage, it strikes me that if men vie with each other in common matters, and one outruns the other, I ought to be in solemn earnestness so to run that I may obtain. Lord, help me to gird up the loins of my mind, and may I press forward towards the mark for the prize of my high calling of God in Christ Jesus.</p>",
    "day_number": 31
  },
  {
    "id": "90000000-0000-0000-0000-000000000102",
    "value": "<p>Morning</p>\n<p><em>“But all the Israelites went down to the Philistines, to sharpen every man his share, and his coulter, and his axe, and his mattock.”</em></p>\n<p>1 Samuel 13:20</p>\n<p>We are engaged in a great war with the Philistines of evil. Every weapon within our reach must be used. Preaching, teaching, praying, giving, all must be brought into action, and talents which have been thought too mean for service, must now be employed. Coulter, and axe, and mattock, may all be useful in slaying Philistines; rough tools may deal hard blows, and killing need not be elegantly done, so long as it is done effectually. Each moment of time, in season or out of season; each fragment of ability, educated or untutored; each opportunity, favourable or unfavourable, must be used, for our foes are many and our force but slender.</p>\n<p><strong>Editorial morning reflection:</strong> Israel needed tools ready for the work ahead (1 Samuel 13:20). Our service also calls for preparation: Scripture, prayer, skill, and care for people. Ask God to sharpen one gift you can use in love today, without measuring your zeal against another Christian community.</p>\n<p>Evening</p>\n<p><em>“To me, who am less than the least of all saints, is this grace given, that I should preach among the Gentiles the unsearchable riches of Christ.”</em></p>\n<p>Ephesians 3:8</p>\n<p>The apostle Paul felt it a great privilege to be allowed to preach the gospel. He did not look upon his calling as a drudgery, but he entered upon it with intense delight. Yet while Paul was thus thankful for his office, his success in it greatly humbled him. The fuller a vessel becomes, the deeper it sinks in the water. Idlers may indulge a fond conceit of their abilities, because they are untried; but the earnest worker soon learns his own weakness. If you seek humility, try hard work; if you would know your nothingness, attempt some great thing for Jesus. If you would feel how utterly powerless you are apart from the living God, attempt especially the great work of proclaiming the unsearchable riches of Christ, and you will know, as you never knew before, what a weak unworthy thing you are. Although the apostle thus knew and confessed his weakness, he was never perplexed as to the subject of his ministry. From his first sermon to his last, Paul preached Christ, and nothing but Christ. He lifted up the cross, and extolled the Son of God who bled on it. Follow his example in all your personal efforts to spread the glad tidings of salvation, and let “Christ and him crucified” be your ever recurring theme. The Christian should be like those lovely spring flowers which, when the sun is shining, open their golden cups, as if saying, “Fill us with your beams!” but when the sun is hidden behind a cloud, they close their cups and droop their heads. So should the Christian feel the sweet influence of Jesus; Jesus must be his sun, and he must be the flower which yields itself to the Sun of Righteousness. Oh! to speak of Christ alone, this is the subject which is both “seed for the sower, and bread for the eater.” This is the live coal for the lip of the speaker, and the master-key to the heart of the hearer.</p>",
    "day_number": 62
  },
  {
    "id": "90000000-0000-0000-0000-000000000102",
    "value": "<p>Morning</p>\n<p><em>“That through death he might destroy him that had the power of death.”</em></p>\n<p>Hebrews 2:14</p>\n<p>O child of God, death has lost its sting, because the devil’s power over it is destroyed. Then cease to fear dying. Ask grace from God the Holy Spirit, that by an intimate knowledge and a firm belief of your Redeemer’s death, you may be strengthened for that dread hour. Living near the cross of Calvary you may think of death with pleasure, and welcome it when it comes with intense delight. It is sweet to die in the Lord: it is a covenant-blessing to sleep in Jesus. Death is no longer banishment, it is a return from exile, a going home to the many mansions where the loved ones already dwell. The distance between glorified spirits in heaven and militant saints on earth seems great; but it is not so. We are not far from home—a moment will bring us there. The sail is spread; the soul is launched upon the deep. How long will be its voyage? How many wearying winds must beat upon the sail before it shall be reefed in the port of peace? How long shall that soul be tossed upon the waves before it comes to that sea which knows no storm? Listen to the answer, “Absent from the body, present with the Lord.” Yon ship has just departed, but it is already at its haven. It did but spread its sail and it was there. Like that ship of old, upon the Lake of Galilee, a storm had tossed it, but Jesus said, “Peace, be still,” and immediately it came to land. Think not that a long period intervenes between the instant of death and the eternity of glory. When the eyes close on earth they open in heaven. The horses of fire are not an instant on the road. Then, O child of God, what is there for you to fear in death, seeing that through the death of your Lord its curse and sting are destroyed? and now it is but a Jacob’s ladder whose foot is in the dark grave, but its top reaches to glory everlasting.</p>\n<p>Evening</p>\n<p><em>“Fight the Lord’s battles.”</em></p>\n<p>1 Samuel 18:17</p>\n<p><strong>Editorial evening reflection:</strong> In 1 Samuel 18:17, Saul urged David to fight while hiding a selfish motive. We should test any call to battle by the character of Jesus, who taught his followers to love their neighbors. Courage in Christ can mean resisting harm, speaking truth gently, and seeking peace among Christians.</p>",
    "day_number": 111
  },
  {
    "id": "90000000-0000-0000-0000-000000000102",
    "value": "<p>Morning</p>\n<p><em>“You hate wickedness.”</em></p>\n<p>Psalm 45:7</p>\n<p>“Be you angry, and sin not.” There can hardly be goodness in a man if he be not angry at sin; he who loves truth must hate every false way. How our Lord Jesus hated it when the temptation came! Thrice it assailed him in different forms, but ever he met it with, “Get you behind me, Satan.” He hated it in others; none the less fervently because he showed his hate oftener in tears of pity than in words of rebuke; yet what language could be more stern, more Elijah-like, than the words, “Woe to you, scribes and Pharisees, hypocrites! for you devour widows’ houses, and for a pretence make long prayer.” He hated wickedness, so much that he bled to wound it to the heart; he died that it might die; he was buried that he might bury it in his tomb; and he rose that he might forever trample it beneath his feet. Christ is in the Gospel, and that Gospel is opposed to wickedness in every shape. Wickedness arrays itself in fair garments, and imitates the language of holiness; but the precepts of Jesus, like his famous scourge of small cords, chase it out of the temple, and will not tolerate it in the Church. So, too, in the heart where Jesus reigns, what war there is between Christ and Belial! And when our Redeemer shall come to be our Judge, those thundering words, “Depart, you cursed” which are, indeed, but a prolongation of his life-teaching concerning sin, shall manifest his abhorrence of iniquity. As warm as is his love to sinners, so hot is his hatred of sin; as perfect as is his righteousness, so complete shall be the destruction of every form of wickedness. You glorious champion of right, and destroyer of wrong, for this cause has God, even your God, anointed you with the oil of gladness above your fellows.</p>\n<p>Evening</p>\n<p><em>“Cursed be the man before the Lord, that rises up and builds this city Jericho.”</em></p>\n<p>Joshua 6:26</p>\n<p><strong>Historical context and editorial evening reflection:</strong> Joshua 6:26 concerns ancient Jericho. It does not authorize Christians to curse or demean other churches. Spurgeon applied the verse to a nineteenth-century dispute, and that polemical application is omitted here. Ask the Lord for discernment, humility, and truthful speech that honors the people with whom you disagree.</p>",
    "day_number": 150
  },
  {
    "id": "90000000-0000-0000-0000-000000000102",
    "value": "<p>Morning</p>\n<p><em>“And Sarah said, God has made me to laugh, so that all that hear will laugh with me.”</em></p>\n<p>Genesis 21:6</p>\n<p>It was far above the power of nature, and even contrary to its laws, that the aged Sarah should be honoured with a son; and even so it is beyond all ordinary rules that I, a poor, helpless, undone sinner, should find grace to bear about in my soul the indwelling Spirit of the Lord Jesus. I, who once despaired, as well I might, for my nature was as dry, and withered, and barren, and accursed as a howling wilderness, even I have been made to bring forth fruit to holiness. Well may my mouth be filled with joyous laughter, because of the singular, surprising grace which I have received of the Lord, for I have found Jesus, the promised seed, and he is mine forever. This day will I lift up psalms of triumph to the Lord who has remembered my low estate, for “my heart rejoices in the Lord; mine horn is exalted in the Lord; my mouth is enlarged over my enemies, because I rejoice in your salvation.”</p>\n<p>I would have all those that hear of my great deliverance from hell, and my most blessed visitation from on high, laugh for joy with me. I would surprise my family with my abundant peace; I would delight my friends with my ever-increasing happiness; I would edify the Church with my grateful confessions; and even impress the world with the cheerfulness of my daily conversation. Bunyan tells us that Mercy laughed in her sleep, and no wonder when she dreamed of Jesus; my joy shall not stop short of hers while my Beloved is the theme of my daily thoughts. The Lord Jesus is a deep sea of joy: my soul shall dive in it, shall be swallowed up in the delights of his society. Sarah looked on her Isaac, and laughed with excess of rapture, and all her friends laughed with her; and you, my soul, look on your Jesus, and bid heaven and earth unite in your joy unspeakable.</p>\n<p>Evening</p>\n<p><em>“He opens, and no man shuts.”</em></p>\n<p>Revelation 3:7</p>\n<p><strong>Editorial evening reflection:</strong> Jesus holds the key and opens a door no one can shut (Revelation 3:7). His promise calls us to trust his welcome rather than fear other people. Where might you open a door through hospitality, prayer, or patient conversation today?</p>",
    "day_number": 167
  },
  {
    "id": "90000000-0000-0000-0000-000000000102",
    "value": "<p>Morning</p>\n<p><em>“After that you have suffered awhile, make you perfect, establish, strengthen, settle you.”</em></p>\n<p>1 Peter 5:10</p>\n<p>You have seen the arch of heaven as it spans the plain: glorious are its colours, and rare its hues. It is beautiful, but, alas, it passes away, and look, it is not. The fair colours give way to the fleecy clouds, and the sky is no longer brilliant with the tints of heaven. It is not established. How can it be? A glorious show made up of transitory sun-beams and passing rain-drops, how can it abide? The graces of the Christian character must not resemble the rainbow in its transitory beauty, but, on the contrary, must be stablished, settled, abiding. Seek, O believer, that every good thing you have may be an abiding thing. May your character not be a writing upon the sand, but an inscription upon the rock! May your faith be no “baseless fabric of a vision,” but may it be builded of material able to endure that awful fire which shall consume the wood, hay, and stubble of the hypocrite. May you be rooted and grounded in love. May your convictions be deep, your love real, your desires earnest. May your whole life be so settled and established, that all the blasts of hell, and all the storms of earth shall never be able to remove you. But notice how this blessing of being “stablished in the faith” is gained. The apostle’s words point us to suffering as the means employed—“After that you have suffered awhile.” It is of no use to hope that we shall be well rooted if no rough winds pass over us. Those old gnarlings on the root of the oak tree, and those strange twistings of the branches, all tell of the many storms that have swept over it, and they are also indicators of the depth into which the roots have forced their way. So the Christian is made strong, and firmly rooted by all the trials and storms of life. Shrink not then from the tempestuous winds of trial, but take comfort, believing that by their rough discipline God is fulfilling this benediction to you.</p>\n<p>Evening</p>\n<p><em>“Tell you your children of it, and let your children tell their children, and their children another generation.”</em></p>\n<p>Joel 1:3</p>\n<p><strong>Editorial evening reflection:</strong> Joel 1:3 asks one generation to tell the next what it has seen. Share the story of God's help with honesty, including your own questions and failures. Invite younger people to read Scripture, pray, and respond freely; fear of another Christian tradition is not the center of this witness.</p>",
    "day_number": 193
  },
  {
    "id": "90000000-0000-0000-0000-000000000102",
    "value": "<p>Morning</p>\n<p><em>“Watchman, what of the night?”</em></p>\n<p>Isaiah 21:11</p>\n<p>What enemies are abroad? Errors are a numerous horde, and new ones appear every hour: against what heresy am I to be on my guard? Sins creep from their lurking places when the darkness reigns; I must myself mount the watch-tower, and watch to prayer. Our heavenly Protector foresees all the attacks which are about to be made upon us, and when as yet the evil designed us is but in the desire of Satan, he prays for us that our faith fail not, when we are sifted as wheat. Continue O gracious Watchman, to forewarn us of our foes, and for Zion’s sake hold not your peace.</p>\n<p><strong>Editorial morning reflection:</strong> The watchman's question in Isaiah 21:11 calls for alertness, not suspicion of neighbors. Pray for the church, listen carefully to Scripture, and resist teaching that breeds fear. The Lord who sees the night also promises the morning.</p>\n<p>“Watchman, what of the night?” What stars are visible? What precious promises suit our present case? You sound the alarm, give us the consolation also. Christ, the polestar, is ever fixed in his place, and all the stars are secure in the right hand of their Lord.</p>\n<p>But watchman, when comes the morning? The Bridegroom tarries. Are there no signs of his coming forth as the Sun of Righteousness? Has not the morning star arisen as the pledge of day? When will the day dawn, and the shadows flee away? O Jesus, if you come not in person to your waiting Church this day, yet come in Spirit to my sighing heart, and make it sing for joy.</p>\n<p>Evening</p>\n<p><em>“Let the whole earth be filled with his glory; Amen, and Amen.”</em></p>\n<p>Psalm 72:19</p>\n<p>This is a large petition. To intercede for a whole city needs a stretch of faith, and there are times when a prayer for one man is enough to stagger us. But how far-reaching was the psalmist’s dying intercession! How comprehensive! How sublime! “Let the whole earth be filled with his glory.” It does not exempt a single country however crushed by the foot of superstition; it does not exclude a single nation however barbarous. For the cannibal as well as for the civilized, for all climes and races this prayer is uttered: the whole circle of the earth it encompasses, and omits no son of Adam. We must be up and doing for our Master, or we cannot honestly offer such a prayer. The petition is not asked with a sincere heart unless we endeavour, as God shall help us, to extend the kingdom of our Master. Are there not some who neglect both to plead and to labour? Reader, is it your prayer? Turn your eyes to Calvary. See the Lord of Life nailed to a cross, with the thorn-crown about his brow, with bleeding head, and hands, and feet. What! can you look upon this miracle of miracles, the death of the Son of God, without feeling within your bosom a marvellous adoration that language never can express? And when you feel the blood applied to your conscience, and know that he has blotted out your sins, you are not a man unless you start from your knees and cry, “Let the whole earth be filled with his glory; Amen, and Amen.” Can you bow before the Crucified in loving homage, and not wish to see your Monarch master of the world? Out on you if you can pretend to love your Prince, and desire not to see him the universal ruler. Your piety is worthless unless it leads you to wish that the same mercy which has been extended to you may bless the whole world. Lord, it is harvest-time, put in your sickle and reap.</p>",
    "day_number": 219
  },
  {
    "id": "90000000-0000-0000-0000-000000000102",
    "value": "<p>Morning</p>\n<p><em>“But Simon’s wife’s mother lay sick of a fever, and soon they tell him of her.”</em></p>\n<p>Mark 1:30</p>\n<p><strong>Editorial morning reflection:</strong> When Peter's mother-in-law was ill, the disciples told Jesus, and he cared for her (Mark 1:30–31). Family responsibilities and service to Christ can belong together. Bring someone who is ill to him in prayer, and offer practical help where you can.</p>\n<p>Evening</p>\n<p><em>“Except you see signs and wonders, you will not believe.”</em></p>\n<p>John 4:48</p>\n<p>A craving after marvels was a symptom of the sickly state of men’s minds in our Lord’s day; they refused solid nourishment, and pined after mere wonder. The gospel which they so greatly needed they would not have; the miracles which Jesus did not always choose to give they eagerly demanded. Many nowadays must see signs and wonders, or they will not believe. Some have said in their heart, “I must feel deep horror of soul, or I never will believe in Jesus.” But what if you never should feel it, as probably you never may? Will you go to hell out of spite against God, because he will not treat you like another? One has said to himself, “If I had a dream, or if I could feel a sudden shock of I know not what, then I would believe.” Thus you undeserving mortals dream that my Lord is to be dictated to by you! You are beggars at his gate, asking for mercy, and you must draw up rules and regulations as to how he shall give that mercy. Think you that he will submit to this? My Master is of a generous spirit, but he has a right royal heart, he spurns all dictation, and maintains his sovereignty of action. Why, dear reader, if such be your case, do you crave for signs and wonders? Is not the gospel its own sign and wonder? Is not this a miracle of miracles, that “God so loved the world that he gave his only begotten Son, that whoever believes in him might not perish”? Surely that precious word, “Whoever will, let him come and take the water of life freely” and that solemn promise, “Him that comes to me, I will in no wise cast out,” are better than signs and wonders! A truthful Saviour ought to be believed. He is truth itself. Why will you ask proof of the veracity of One who cannot lie? The devils themselves declared him to be the Son of God; will you mistrust him?</p>",
    "day_number": 246
  },
  {
    "id": "90000000-0000-0000-0000-000000000102",
    "value": "<p>Morning</p>\n<p><em>“Your paths drop fatness.”</em></p>\n<p>Psalm 65:11</p>\n<p>Many are “the paths of the Lord” which “drop fatness,” but an especial one is the path of prayer. No believer, who is much in the closet, will have need to cry, “My leanness, my leanness; woe to me.” Starving souls live at a distance from the mercy- seat, and become like the parched fields in times of drought. Prevalence with God in wrestling prayer is sure to make the believer strong—if not happy. The nearest place to the gate of heaven is the throne of the heavenly grace. Much alone, and you will have much assurance; little alone with Jesus, your religion will be shallow, polluted with many doubts and fears, and not sparkling with the joy of the Lord. Since the soul-enriching path of prayer is open to the very weakest saint; since no high attainments are required; since you are not bidden to come because you are an advanced saint, but freely invited if you be a saint at all; see to it, dear reader, that you are often in the way of private devotion. Be much on your knees, for so Elijah drew the rain upon famished Israel’s fields.</p>\n<p>There is another especial path dropping with fatness to those who walk in it, it is the secret walk of communion. Oh! the delights of fellowship with Jesus! Earth has no words which can set forth the holy calm of a soul leaning on Jesus’ bosom. Few Christians understand it, they live in the lowlands and seldom climb to the top of Nebo: they live in the outer court, they enter not the holy place, they take not up the privilege of priesthood. At a distance they see the sacrifice, but they sit not down with the priest to eat of it, and to enjoy the fat of the burnt offering. But, reader, sit you ever under the shadow of Jesus; come up to that palm tree, and take hold of the branches of it; let your beloved be to you as the apple-tree among the trees of the wood, and you will be satisfied as with marrow and fatness. O Jesus, visit us with your salvation!</p>\n<p>Evening</p>\n<p><em>“See, to obey is better than sacrifice.”</em></p>\n<p>1 Samuel 15:22</p>\n<p><strong>Historical context and editorial evening reflection:</strong> Samuel confronted Saul because Saul used a sacrifice to excuse disobedience (1 Samuel 15:22). The narrative contains warfare in Israel's ancient history; it is not a command to harm people today or to judge other Christians by their worship furnishings. Ask where a religious appearance may be hiding a failure to act with justice, mercy, and humility.</p>",
    "day_number": 292
  },
  {
    "id": "90000000-0000-0000-0000-000000000102",
    "value": "<p>Morning</p>\n<p><em>“No weapon that is formed against you shall prosper.”</em></p>\n<p>Isaiah 54:17</p>\n<p><strong>Historical context and editorial morning reflection:</strong> Earlier editions used this date to recall English political conflicts and to attack Roman Catholics. That application is omitted. Isaiah 54:17 offers God's people hope in adversity; it does not promise that we will never suffer or license hostility toward neighbors. Thank God for protection, pray for those who face danger, and seek peace with people of other traditions.</p>\n<p>Evening</p>\n<p><em>“Be thankful to him, and bless his name.”</em></p>\n<p>Psalm 100:4</p>\n<p>Our Lord would have all his people rich in high and happy thoughts concerning his blessed person. Jesus is not content that his brethren should think meanly of him; it is his pleasure that his espoused ones should be delighted with his beauty. We are not to regard him as a bare necessary, like to bread and water, but as a luxurious delicacy, as a rare and ravishing delight. To this end he has revealed himself as the “pearl of great price” in its peerless beauty, as the “bundle of myrrh” in its refreshing fragrance, as the “rose of Sharon” in its lasting perfume, as the “lily” in its spotless purity.</p>\n<p>As a help to high thoughts of Christ, remember the estimation that Christ is had in beyond the skies, where things are measured by the right standard. Think how God esteems the Only Begotten, his unspeakable gift to us. Consider what the angels think of him, as they count it their highest honour to veil their faces at his feet. Consider what the blood-washed think of him, as day without night they sing his well deserved praises. High thoughts of Christ will enable us to act consistently with our relations towards him. The more loftily we see Christ enthroned, and the more lowly we are when bowing before the foot of the throne, the more truly shall we be prepared to act our part towards him. Our Lord Jesus desires us to think well of him, that we may submit cheerfully to his authority. High thoughts of him increase our love. Love and esteem go together. Therefore, believer, think much of your Master’s excellencies. Study him in his primeval glory, before he took upon himself your nature! Think of the mighty love which drew him from his throne to die upon the cross! Admire him as he conquers all the powers of hell! See him risen, crowned, glorified! Bow before him as the Wonderful, the Counsellor, the mighty God, for only thus will your love to him be what it should.</p>",
    "day_number": 310
  },
  {
    "id": "90000000-0000-0000-0000-000000000102",
    "value": "<p>Morning</p>\n<p><em>“The branch cannot bear fruit of itself.”</em></p>\n<p>John 15:4</p>\n<p>How did you begin to bear fruit? It was when you came to Jesus and cast yourselves on his great atonement, and rested on his finished righteousness. Ah! what fruit you had then! Do you remember those early days? Then indeed the vine flourished, the tender grape appeared, the pomegranates budded forth, and the beds of spices gave forth their smell. Have you declined since then? If you have, we charge you to remember that time of love, and repent, and do your first works. Be most in those engagements which you have experimentally proved to draw you nearest to Christ, because it is from him that all your fruits proceed. Any holy exercise which will bring you to him will help you to bear fruit. The sun is, no doubt, a great worker in fruit-creating among the trees of the orchard: and Jesus is still more so among the trees of his garden of grace. When have you been the most fruitless? Has not it been when you have lived farthest from the Lord Jesus Christ, when you have slackened in prayer, when you have departed from the simplicity of your faith, when your graces have engrossed your attention instead of your Lord, when you have said, “My mountain stands firm, I shall never be moved”; and have forgotten where your strength dwells—has not it been then that your fruit has ceased? Some of us have been taught that we have nothing out of Christ, by terrible abasements of heart before the Lord; and when we have seen the utter barrenness and death of all creature power, we have cried in anguish, “From him all my fruit must be found, for no fruit can ever come from me.” We are taught, by past experience, that the more simply we depend upon the grace of God in Christ, and wait upon the Holy Spirit, the more we shall bring forth fruit to God. Oh! to trust Jesus for fruit as well as for life.</p>\n<p>Evening</p>\n<p><em>“Men ought always to pray.”</em></p>\n<p>Luke 18:1</p>\n<p><strong>Editorial evening reflection:</strong> Jesus taught his disciples to pray persistently and not lose heart (Luke 18:1). Pray for the church and the world with compassion. Name people across Christian traditions, and ask that all of us may bear witness to Christ through truth, mercy, and care for neighbors.</p>",
    "day_number": 318
  },
  {
    "id": "90000000-0000-0000-0000-000000000102",
    "value": "<p>Morning</p>\n<p><em>“For your sakes he became poor.”</em></p>\n<p>2 Corinthians 8:9</p>\n<p>The Lord Jesus Christ was eternally rich, glorious, and exalted; but “though he was rich, yet for your sakes he became poor.” As the rich saint cannot be true in his communion with his poor brethren unless of his substance he ministers to their necessities, so (the same rule holding with the head as between the members), it is impossible that our Divine Lord could have had fellowship with us unless he had imparted to us of his own abounding wealth, and had become poor to make us rich. Had he remained upon his throne of glory, and had we continued in the ruins of the fall without receiving his salvation, communion would have been impossible on both sides. Our position by the fall, apart from the covenant of grace, made it as impossible for fallen man to communicate with God as it is for Belial to be in concord with Christ. In order, therefore, that communion might be compassed, it was necessary that the rich kinsman should bestow his estate upon his poor relatives, that the righteous Saviour should give to his sinning brethren of his own perfection, and that we, the poor and guilty, should receive of his fulness grace for grace; that thus in giving and receiving, the One might descend from the heights, and the other ascend from the depths, and so be able to embrace each other in true and hearty fellowship. Poverty must be enriched by him in whom are infinite treasures before it can venture to commune; and guilt must lose itself in imputed and imparted righteousness before the soul can walk in fellowship with purity. Jesus must clothe his people in his own garments, or he cannot admit them into his palace of glory; and he must wash them in his own blood, or else they will be too defiled for the embrace of his fellowship.</p>\n<p>O believer, in this is love! For your sake the Lord Jesus “became poor” that he might lift you up into communion with himself.</p>\n<p>Evening</p>\n<p><em>“The glory of the Lord shall be revealed, and all flesh shall see it together.”</em></p>\n<p>Isaiah 40:5</p>\n<p><strong>Editorial evening reflection:</strong> Isaiah 40:5 promises that the Lord's glory will be revealed for all people to see. Christians can share that hope openly while honoring the dignity of neighbors who believe differently. Pray for faithful witness, patient listening, and a world in which justice and mercy are visible.</p>\n<p>We are not discouraged by the length of his delays; we are not disheartened by the long period which he allots to the church in which to struggle with little success and much defeat. We believe that God will never suffer this world, which has once seen Christ’s blood shed upon it, to be always the devil’s stronghold. Christ came here to deliver this world from the detested sway of the powers of darkness. What a shout shall that be when men and angels shall unite to cry “Hallelujah, hallelujah, for the Lord God Omnipotent reigns!” What a satisfaction will it be in that day to have had a share in the fight, to have helped to break the arrows of the bow, and to have aided in winning the victory for our Lord! Happy are they who trust themselves with this conquering Lord, and who fight side by side with him, doing their little in his name and by his strength! How unhappy are those on the side of evil! It is a losing side, and it is a matter in which to lose is to lose and to be lost forever. On whose side are you?</p>",
    "day_number": 359
  },
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "value": "<p><strong>Read:</strong> Matthew 6:9-13; Philippians 4:6-7.</p><p><strong>Historical context:</strong> Joseph Phillimore wrote to two English parishes in 1814. He encouraged prayer at home in the morning and evening.</p><p><strong>From the historical tract (language updated):</strong></p><p>In the first place, I shall recommend private prayers, morning and evening, to you in your respective dwellings, that God may bless your industrious, honest endeavours, in this life with prosperity, and patiently to bear adversity.</p><p><strong>Reflect:</strong> A regular time of prayer can make room for gratitude and honest requests. Phillimore's advice names both prosperity and adversity; prayer does not guarantee an easy day. What concern will you bring to God as this day begins?</p><p><strong>Prayer:</strong> Father, teach me to pray today. Guide my choices, and help me face both joy and difficulty with trust in Christ. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "value": "<p><strong>Read:</strong> James 2:1-5; Psalm 139:23-24.</p><p><strong>Historical context:</strong> Phillimore hoped families in his parishes could read Scripture at home. His appeal was tied to local church customs and a specific book-distribution effort.</p><p><strong>From the historical tract (language updated):</strong></p><p>Our blessed Redeemer was no respecter of persons; he came to save the poor as well as the rich, both to be inheritors of the kingdom of heaven.</p><p><strong>Historical tract, paraphrased:</strong> Phillimore wanted households with few resources to have access to Scripture. His proposal for a local book-distribution scheme and Anglican prayer books belonged to his particular parish setting.</p><p><strong>Reflect:</strong> The source speaks in the language of its time, but its concern for access remains practical: faith should not be fenced off by money or status. How can you help a neighbor obtain what they need to learn, pray, or join a community of worship?</p><p><strong>Prayer:</strong> Lord Jesus, you welcomed people of every standing. Remove favoritism from my heart and help me share what is useful with generosity and respect. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Heavenly Father, thank you for carrying me through the night and welcoming me into a new day. Let my thoughts, words, and work honor you. Guide me by your Holy Spirit, guard me from harm, and help me care for those I meet. I offer this day to you through Jesus Christ, your Son. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Merciful Father, thank you for guiding me through this day. Forgive the wrong I have done, and help me make peace where I can. Watch over my family and friends as we rest. Quiet my anxious thoughts, and remind me that I belong to you in waking and in sleep. Through Jesus Christ our Lord, amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>God of mercy, I begin this Monday with thanks for rest and for the work before me. Give me a clear mind and a willing heart. Help me resist what is harmful, speak truthfully, and serve my neighbors well. When I cannot see the way ahead, lead me by your Spirit and keep me close to Christ. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Father, as this day ends, I thank you for every good gift. Forgive what I have done wrong, and guide me to repair any harm I have caused. Be near to those I love, especially anyone who is afraid or unwell. Give us peaceful rest and renewed strength for tomorrow, through Jesus Christ. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Creator of heaven and earth, thank you for morning light, for rest, and for another chance to love and serve. Open my ears to your Word and to people who need help. As I begin my tasks, keep me from selfishness and lead me in the light of Jesus Christ. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>God of compassion, thank you for being with me throughout this Tuesday. I bring you both my gratitude and the troubles I cannot settle tonight. Forgive my sins through Jesus Christ, comfort those who are distressed, and give me rest. Let tomorrow find me ready to seek your peace. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Lord of all creation, the new morning gives me reason to praise you. Thank you for the birds, the light, and the life you sustain. Guide my speech today: keep me from gossip, harsh judgment, and careless words. Teach me to tell the truth with kindness and to follow Jesus in all I do. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Father, Son, and Holy Spirit, one God, thank you for accompanying me through this day. Forgive the words I used badly and help me speak with greater care tomorrow. Shelter those who feel unsafe or alone. Let the peace of Christ steady my heart tonight and through all my days. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Lord Jesus Christ, light of the world, thank you for the gift of this Thursday morning. Shine on the work before me and on the people I will meet. Help me act with patience and courage, especially when I feel uncertain. Keep me faithful to you and ready to do good. Amen.</p>",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Holy God, Father, Son, and Spirit, thank you for your care today. I confess the ways I have fallen short and trust your mercy in Christ. Quiet my fears as evening comes. Give me a grateful heart, peaceful rest, and hope that reaches beyond this present day. Amen.</p>",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Heavenly Father, I place this Friday in your care: my work, my relationships, my hopes, and my worries. Teach me to delight in your Word and to walk in the way of Jesus. When I fail, draw me back to your mercy. Give me strength to serve you and my neighbors faithfully. Amen.</p>",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Lord, thank you for helping me through this Friday. Forgive the things I have done wrong and show me how to put them right. Be a refuge for people facing danger or grief, and give rest to those who are weary. I trust my night and tomorrow to your faithful care, through Christ. Amen.</p>",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Faithful God, thank you for bringing me to Saturday morning. Help me use this day well, doing my responsibilities honestly and treating others with respect. Guard my tongue from lies and my heart from pride. By your Spirit, lead me toward justice, kindness, and the joy of serving Christ. Amen.</p>",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Father, as this week draws to a close, I remember your kindness and bring you what I regret. Forgive me through Jesus Christ and help me begin again. Give rest to my body and peace to my mind. Keep those I love in your care and renew us for the coming week. Amen.</p>",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Lord Jesus, thank you for loving children and welcoming them to you. Help me honor and care for the people in my family. Give parents and caregivers wisdom, patience, and kindness. When something feels wrong or unsafe, help me seek help from someone trustworthy. Teach me to grow in love and truth. Amen.</p>",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Holy Spirit, be with me as I learn. Give me patience when a lesson is hard, courage to ask questions, and kindness toward my teachers and classmates. Help the adults who guide me to be wise and fair. Let what I learn help me love God and serve other people, through Jesus Christ. Amen.</p>",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Father, as I prepare for this journey, I place my plans and the people I leave at home in your care. Help me prepare wisely, travel attentively, and welcome the people I meet. Be with those traveling alongside me. Lead us in peace, and bring us safely where we need to go. In Jesus' name, amen.</p>",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>God of Abraham and of all who travel, be with me on this journey. Guide my choices, protect those alongside me, and help me respond wisely to delays or danger. Care for my loved ones at home. Wherever I go, remind me that your presence is near, through Jesus Christ our Lord. Amen.</p>",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Heavenly Father, thank you for the gift of another birthday and for the people who share my life. Help me receive this new year with gratitude rather than fear. Teach me to use my time kindly, to grow in faith, and to trust that my life is held in the love of Jesus Christ. Amen.</p>",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Father, Son, and Holy Spirit, one God, be with our school and church community. Give teachers wisdom, students curiosity, and all of us the courage to seek truth. Protect those who feel left out or afraid. Help us learn from your Word and care for one another as followers of Jesus. Amen.</p>",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Lord, as I go to worship, open my heart to hear your Word and join the prayers of your people. Help me welcome others and listen with humility. May our praise lead to acts of mercy and justice when we leave. I come to you through Jesus Christ our Lord. Amen.</p>",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Merciful Father, I have not always loved you and my neighbors as I should. Show me the truth about my choices without letting shame drive me from you. Forgive me through Jesus Christ, help me repair the harm I have done, and renew my heart by your Holy Spirit. Lead me into a changed life. Amen.</p>",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>God of light, strengthen my trust in Jesus Christ when my faith feels small. Help me learn your ways, ask honest questions, and hold fast to what is true. Keep me from pride and fear. Let my faith show itself in patient love, good work, and care for those in need. Amen.</p>",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Lord Jesus, be my companion in the ordinary parts of life. Shape my habits so that I grow in honesty, generosity, and prayer. When I become distracted or discouraged, draw me back to your grace. Help me love you more deeply and serve other people with a steady heart. Amen.</p>",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Father of compassion, I bring you my pain and weariness. Give me patience for today and courage to ask for the help I need. Guide those who care for me, and stay near even when healing is slow or uncertain. I trust in the mercy of Jesus Christ and the comfort of your Holy Spirit. Amen.</p>",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Good morning, God. Thank you for watching over me last night. Help me follow Jesus today, and be near to me in all that happens. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Father, thank you for waking me to a bright new day. Forgive me when I do wrong, and guide me by your love as I learn and play. Stay close to me through Jesus. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, thank you for the rest of last night. Help me begin this day with joy and follow Jesus in what I do and say. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>O help me, Lord, this day to be</p><p>Your own dear child and follow You;</p><p>And lead me, Savior, by Your hand</p><p>Until I reach the heavenly land. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, as I rise, help my words and actions please you. Teach me to love the people I meet today. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Jesus, good Shepherd, guide me today. Keep me from harm, help me ask for help when I need it, and teach me to care for others. Stay with me all my days. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Jesus, my Shepherd, thank you for the morning light and your care. Guide me today and help me stay close to you. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, thank you for morning light, shelter, food, friends, and the people who care for me. Help me share your kindness today. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, thank you for rest, friends, work, and play. Guide me through this day, and help me show your love to everyone. In Jesus' name, amen.</p>",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Jesus, gentle Shepherd,</p><p>Bless Your lamb today;</p><p>Keep me in Your footsteps,</p><p>Never let me stray.</p><p>Guard me through the daytime.</p><p>Every hour, I pray;</p><p>Keep my feet from straying</p><p>From the narrow way. Amen.</p>",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Jesus, help me use gentle words and kind hands today. Guide my steps when I play and remind me that I am your child. Amen.</p>",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Jesus, be with me at school and at play. Help me choose what is good, tell the truth, and show kindness. When I make a mistake, guide me back to you. Amen.</p>",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Blessed Lord, care for me, my family, and those I love. Help us seek safety when we need it, and teach me to follow Jesus with kindness. Amen.</p>",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Father, thank you for last night's rest and the light of this morning. I praise you for another day. Amen.</p>",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, I offer you this new day. Guide my choices, teach me what is good, and help me live in your love. Amen.</p>",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, thank you for caring for me through the night. I offer you this day and ask you to guide me in love. Amen.</p>",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Father, whatever I do today, let my words and actions honor Jesus. Lead me in what is right and help me love other people. Amen.</p>",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Heavenly Father, thank you for carrying me safely through the night. Through Jesus Christ, help me live well today. Be near me in body and soul, and guide me by your Spirit. Amen.</p>",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Savior, lay Your hand on me,</p><p>Bless me, and remember me. Amen.</p>",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, as I lie down to sleep, thank you for being near. Give me peaceful rest and help me wake ready for a new day. In Jesus' name, amen.</p>",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Father in heaven, bless the people who care for me and everyone I love. Give us peaceful sleep tonight and help us welcome the morning. Amen.</p>",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Jesus, thank you for being with me today. Forgive what I have done wrong, bless the people I love, and give us quiet sleep. Help me be more like you tomorrow. Amen.</p>",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Heavenly Father, as I lie in bed, listen to my prayer. Be near to me tonight and help me greet the morning with hope. Amen.</p>",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>The day is past and over,</p><p>All thanks, O Lord, to You!</p><p>O Jesus, keep me in Your sight</p><p>And save me through the coming night.</p><p>Amen.</p>",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>The day is done;</p><p>O God the Son,</p><p>Look down upon</p><p>Your little one!</p><p>O Light of Light,</p><p>Keep me this night,</p><p>And shed round me</p><p>Your presence bright.</p><p>I need not fear</p><p>If You are near;</p><p>You are my Savior</p><p>Kind and dear. Amen.</p>",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, forgive the wrong I have done today. Help me make peace with others and rest knowing that Jesus loves me. Amen.</p>",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Watch over a little child tonight,</p><p>Blessed Savior from above,</p><p>And keep me till the morning light</p><p>Within Your arms of love. Amen.</p>",
    "day_number": 27
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Jesus, tender Shepherd, thank you for caring for me today. Forgive my sins, bless my friends, and stay close to me through the night. Amen.</p>",
    "day_number": 28
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, thank you for this day. Forgive the wrong I have done, bless my family and friends, and give us restful sleep. Through Jesus Christ, amen.</p>",
    "day_number": 29
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, stay with me as the day ends. When I feel alone or afraid, help me remember that your love is near. Give me peaceful rest. Amen.</p>",
    "day_number": 30
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, thank you for this day. Forgive my mistakes, help me put right what I can, and watch over me as I sleep. Through Jesus, amen.</p>",
    "day_number": 31
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, thank you for caring for me today. Forgive my mistakes at work or play. Thank you for food and friends; give me peaceful rest tonight. Amen.</p>",
    "day_number": 32
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>God, thank you for the good things of this day. As night comes, keep me safe and remind me of your love in Jesus. Amen.</p>",
    "day_number": 33
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Jesus, thank you for loving me and forgiving my sins. As I rest tonight, help me trust you and remember that I belong to you. Amen.</p>",
    "day_number": 34
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Jesus, as this busy day ends, I bring you my thanks and worries. Make the night peaceful and guide me again tomorrow. Amen.</p>",
    "day_number": 35
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord God, forgive the wrong I have done today, through Jesus Christ. Help me rest safely tonight and begin again tomorrow. Amen.</p>",
    "day_number": 36
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Heavenly Father, thank you for caring for me today. Forgive my sins through Jesus Christ and give me peaceful sleep. I place myself and all my worries in your hands. Amen.</p>",
    "day_number": 37
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Heavenly Father, thank you for this food. We receive it with gratitude, through Jesus Christ our Lord. Amen.</p>",
    "day_number": 38
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Father, bless this food and everyone at the table. Help us share with those who have less. In Jesus' name, amen.</p>",
    "day_number": 39
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord Jesus, be with us as we eat. Thank you for this food and for the people who prepared it. Amen.</p>",
    "day_number": 40
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Jesus, Bread of Life, thank you for caring for our bodies and souls. Bless this meal and guide us today. Amen.</p>",
    "day_number": 41
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, be present at our table. Thank you for this food; make us thankful and generous toward others. Amen.</p>",
    "day_number": 42
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>God, giver of good gifts, thank you for our food. Give us strength to care for others, through Jesus Christ. Amen.</p>",
    "day_number": 43
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Jesus, bless what You have given,</p><p>Feed our souls with bread from heaven;</p><p>Guide and lead us all the way</p><p>In all that we may do and say. Amen.</p>",
    "day_number": 44
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Heavenly Father, thank you for this food and for all your gifts. Help us receive them with gratitude, through Jesus Christ our Lord. Amen.</p>",
    "day_number": 45
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, every living thing depends on your care. Thank you for opening your hand and providing this food. Help us share it gladly. Amen.</p>",
    "day_number": 46
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, whether we eat, drink, work, or play, help us honor you in all we do. Thank you for this meal. Amen.</p>",
    "day_number": 47
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord Jesus, thank you for this meal and for the people who shared it. Help us share your kindness with others. Amen.</p>",
    "day_number": 48
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Thanks be to You, O God! Amen.</p>",
    "day_number": 49
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord Jesus, good Shepherd, thank you for caring for us and giving us what we need today. Amen.</p>",
    "day_number": 50
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, thank you for our food and drink. Through Jesus Christ, teach us to share your gifts. Amen.</p>",
    "day_number": 51
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord Jesus, thank you for joining us in this meal. Stay close to us and help us choose what is good. Amen.</p>",
    "day_number": 52
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, thank you for the food we have eaten. Nourish our hearts with your Word and help us care for others. Amen.</p>",
    "day_number": 53
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>O give thanks to the Lord, for He is good; for His mercy endures forever. Amen.</p>",
    "day_number": 54
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, I bless your holy name and thank you for all the kindness you have shown me. Help me remember your gifts. Amen.</p>",
    "day_number": 55
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Heavenly Father, accept our thanks for this and for all Your blessings, through Jesus Christ. Amen.</p>",
    "day_number": 56
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>God, thank you for food and for everyone who helped provide it. Help us care for people who are hungry. Amen.</p>",
    "day_number": 57
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, thank you for your goodness. Let our words and actions show gratitude for what you have given us. Amen.</p>",
    "day_number": 58
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Heavenly Father, we thank you for all your gifts, through Jesus Christ our Lord. Amen.</p>",
    "day_number": 59
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, thank you for our daily bread. Strengthen our bodies and nourish our hearts with your grace, through Jesus Christ. Amen.</p>",
    "day_number": 60
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, you are kind to all you have made. Thank you for this food and the many gifts we often forget. Amen.</p>",
    "day_number": 61
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Tender Jesus, meek and mild,</p><p>Look on me, a little child;</p><p>Help me, if it is Your will,</p><p>To recover from all ill. Amen.</p>",
    "day_number": 64
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>I am weak, but You are mighty.</p><p>Help me, O my God! Amen.</p>",
    "day_number": 65
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Father, when I am sick, help me remember that you love me. Give me courage to ask for care, and be with those who are helping me. Amen.</p>",
    "day_number": 66
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, in sickness and sadness I turn to you. Please remember me, comfort me, and help me accept care from others. Amen.</p>",
    "day_number": 67
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Father, I am sick today. Please comfort me, guide the people who care for me, and help me rest and recover. Amen.</p>",
    "day_number": 68
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Heavenly Father, I feel sick and need your care. Give me comfort, guide those who are helping me, and help me rest as I receive care. Through Jesus Christ, amen.</p>",
    "day_number": 69
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Jesus, when I feel weak or afraid, stay near. Let me find comfort in your love and in the care of people around me. Amen.</p>",
    "day_number": 70
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord Jesus, hear me when I am ill. Forgive my sins, help me receive care, and remind me that I remain your beloved child. Amen.</p>",
    "day_number": 71
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>God, help me draw near to you when I am sick or worried. Be with me and give me courage for today. Amen.</p>",
    "day_number": 72
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord Jesus, be near me while I am sick. Give me courage, bring me comfort, and guide the people who care for me. Amen.</p>",
    "day_number": 73
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord Jesus, please care for my loved one who is sick. Give them comfort, guide the people helping them, and surround our family with your peace. Amen.</p>",
    "day_number": 74
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Jesus, thank you for another year of life. Guide me day by day and help me grow in kindness and faith. Amen.</p>",
    "day_number": 75
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Father, thank you for those who care for me as I grow. Help me trust your guidance, ask for help when I need it, and care for others. Amen.</p>",
    "day_number": 76
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Jesus, faithful Shepherd, lead me as I grow. Help me notice good gifts, learn from hard times, and love you more each day. Amen.</p>",
    "day_number": 77
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Heavenly Father, thank you for life, food, clothing, and the people who love me. Help me receive your gifts with gratitude and share what I have. Amen.</p>",
    "day_number": 78
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Jesus, be my light as I grow and change. Guide me in good choices today and help me trust you when life feels uncertain. Amen.</p>",
    "day_number": 79
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, guide me as I grow. Help me follow Jesus today and trust your care in all the years ahead. Amen.</p>",
    "day_number": 80
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Faithful God, thank you for life and for every good gift. Care for my body and heart, and help me choose what is right. Amen.</p>",
    "day_number": 81
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord Jesus Christ, be with us today. Send your Holy Spirit to guide our learning and worship. Amen.</p>",
    "day_number": 82
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, teach us how to keep Your day</p><p>And lead and bless us all the way. Amen.</p>",
    "day_number": 83
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, open my heart to hear your Word. Help me understand it and live as your child. Amen.</p>",
    "day_number": 84
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, help me listen to your Word with an open heart. Guide those who teach it, and help us follow Jesus together. Amen.</p>",
    "day_number": 85
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, let the words we heard today take root in our hearts. Help us grow in faith and kindness. Amen.</p>",
    "day_number": 86
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, bless my teachers with patience and wisdom. Help me learn with curiosity and respect, and speak up when I need help. Amen.</p>",
    "day_number": 87
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>God of mercy, thank you for what I learned today. Help me remember what is good and put it into practice. When I make mistakes, guide me back to the way of Jesus. Amen.</p>",
    "day_number": 88
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, let the words I heard today grow in my heart like seeds in good soil. Help me understand them and show their fruit in kindness. Amen.</p>",
    "day_number": 89
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Father, Son, and Holy Spirit, one God, bless us with your grace and love. Help us live in peace with one another and find joy in you. Amen.</p>",
    "day_number": 90
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, like Samuel, help me listen when you call. Give me courage to do what is right. Amen.</p>",
    "day_number": 91
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Jesus, stay among us as we hear your Word. Let your peace and joy grow in our hearts. Amen.</p>",
    "day_number": 92
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, thank you for our time of worship. Help us carry your love into our work, play, joys, and sorrows. Keep us close to Jesus today and always. Amen.</p>",
    "day_number": 93
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>God, I offer you my thoughts, words, and actions. Help me love you, care for others, and trust your grace. In life and in all that lies ahead, hold me close to Jesus. Amen.</p>",
    "day_number": 94
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord, as we leave worship, bless us. Forgive what we have done wrong, and help your Word live in our hearts. Amen.</p>",
    "day_number": 95
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>God of heaven, thank you for giving us your Son, Jesus Christ. Fill our hearts with joy as we celebrate his birth. Amen.</p>",
    "day_number": 96
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Lord Jesus Christ, stay near us as we begin a new year. Guide our steps and hear our prayers. Amen.</p>",
    "day_number": 97
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Jesus, holy Child of Bethlehem, thank you for coming among us. Make your home in our hearts and help us turn from sin. Amen.</p>",
    "day_number": 98
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>O welcome, little Christmas Guest,</p><p>Dear Jesus, from above;</p><p>Upon Your face, so pure and mild,</p><p>We see God's smile of love. Amen.</p>",
    "day_number": 99
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Jesus, child of Bethlehem, you are our Savior, Lord, and King. We praise you for your love for all people. Amen.</p>",
    "day_number": 100
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Dear Jesus, holy Child, make your home in my heart. Help me welcome you with love and trust. Amen.</p>",
    "day_number": 101
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Come, dearest Savior, take my heart</p><p>And let me never from You depart. Amen.</p>",
    "day_number": 102
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Jesus, thank you for loving us, dying for us, and rising again. Help me turn away from what is wrong and live in the joy of your new life. Amen.</p>",
    "day_number": 103
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Jesus, Lamb of God, teach me your gentleness and kindness. Help me care for others and show your love in my words and actions. Amen.</p>",
    "day_number": 104
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Jesus, open my eyes to the good around me, my ears to people who need help, and my hands to acts of kindness. Help me grow more like you. Amen.</p>",
    "day_number": 105
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Dear Jesus, stay close to me and to all children today. Help us know that we are loved, and guide the people who care for us. Amen.</p>",
    "day_number": 106
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Holy Spirit, help me be gentle, patient, and kind like Jesus. Guide me in work and play, and give me courage to choose what is right. Amen.</p>",
    "day_number": 107
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Jesus, Son of God, you came among us and gave your life for us. Be with me as I learn, work, and play. Help me grow in love and hear my prayer. Amen.</p>",
    "day_number": 108
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>God, thank you for parents and caregivers who love and help children. Give them wisdom, patience, and support. Help us care for one another, and bring help to every child who feels unsafe. Through Jesus Christ, amen.</p>",
    "day_number": 109
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Father, thank you for my teachers. Give them patience, wisdom, and support. Help me learn well and use what I learn to help other people. Through Jesus Christ, amen.</p>",
    "day_number": 110
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>God, through Jesus you called people to care for your church. Give our pastor wisdom and kindness in teaching your Word, and help us follow your good news together. Amen.</p>",
    "day_number": 111
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Father, as I grow, strengthen my faith in Jesus. Help me face each day with courage and kindness, trusting that your love stays with me always. Amen.</p>",
    "day_number": 112
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Our Father in heaven, may your name be honored. May your kingdom come and your will be done on earth as in heaven. Give us what we need today. Forgive our sins as we forgive those who sin against us. Lead us away from temptation and deliver us from evil. For the kingdom, the power, and the glory are yours forever. Amen.</p>",
    "day_number": 113
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>1. The Lord is my shepherd; I have what I need.</p><p>2. He lets me rest in green pastures and leads me beside quiet waters.</p><p>3. He renews my life and guides me on right paths for his name's sake.</p><p>4. Even when I walk through a dark valley, I need not fear, because you are with me; your guidance comforts me.</p><p>5. You welcome me to your table even when I face trouble; you honor me, and my cup overflows.</p><p>6. Surely your goodness and love will be with me throughout my life, and I will dwell with you forever.</p>",
    "day_number": 114
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Praise God, the giver of every good gift. Let all creation praise the Father, Son, and Holy Spirit, one God, now and always. Amen.</p>",
    "day_number": 115
  },
  {
    "id": "90000000-0000-0000-0000-000000000373",
    "value": "<p><strong>Read:</strong> 2 Peter 1:12-15</p><p><strong>Historical context:</strong> John Alexander preached in Norwich in 1832 after the death of pastor Joseph Kinghorn. He began with Peter's wish that believers remember the truth even after their teacher is gone.</p><p><strong>Sermon theme, paraphrased:</strong> Alexander describes Christian teaching as a repeated reminder of the grace, promises, and practices found in Christ's gospel. The person who taught matters to his congregation, but the truth of Christ outlasts that person's life.</p><p><strong>Reflect:</strong> Think of a person who helped you recognize the love of Christ. Give thanks for them, then recall one promise of Jesus you can carry today. The comfort lies in the living Lord to whom that person pointed.</p><p><strong>Prayer:</strong> Lord Jesus, thank you for people who have reminded me of your gospel. Keep your truth close to my heart and help me pass it on with love. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000373",
    "value": "<p><strong>Read:</strong> 2 Peter 1:5-8</p><p><strong>Historical context:</strong> In the sermon, Alexander remembers Kinghorn's long years of study, prayer, and care for his congregation. This was a memorial of a particular pastor, not a demand that everyone match his work.</p><p><strong>Sermon theme, paraphrased:</strong> Alexander praises diligence that endured over many years. Kinghorn studied Scripture and attended to the people entrusted to him, joining preparation with personal concern.</p><p><strong>Reflect:</strong> Faithful care is usually built through small, repeated acts. Which person or responsibility needs your patient attention today? Ask God for steadiness, and leave room for rest and help from others.</p><p><strong>Prayer:</strong> God of patience, make me attentive to the people before me. Give me strength for today's work and wisdom to rest in your grace. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000373",
    "value": "<p><strong>Read:</strong> Ephesians 4:15-16</p><p><strong>Historical context:</strong> Alexander recalls Kinghorn's preaching as plain and practical. He says its effect came from both the words spoken and the integrity of the speaker's life.</p><p><strong>Sermon theme, paraphrased:</strong> The sermon values teaching that listeners can understand and apply. It also insists that public words lose force when they are disconnected from humble, faithful conduct.</p><p><strong>Reflect:</strong> Truth can be clear without being harsh. Before a difficult conversation, consider what is true, what the other person may need, and whether your actions support your words. Ask Christ to shape both speech and conduct.</p><p><strong>Prayer:</strong> Lord Jesus, help me speak clearly and kindly. Let my actions agree with the truth I say I believe. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000373",
    "value": "<p><strong>Read:</strong> 1 Corinthians 15:10</p><p><strong>Historical context:</strong> After recalling Kinghorn's diligence and perseverance, Alexander turns attention away from admiration of the minister toward the grace of Christ.</p><p><strong>Sermon theme, paraphrased:</strong> Alexander calls Kinghorn a sinner saved by grace. He honors the servant because the servant's gifts were received and offered back to God.</p><p><strong>Reflect:</strong> It is right to thank God for gifted people without making them faultless heroes. Which gift in your own life could you receive with gratitude instead of pride or shame? Use it in love today.</p><p><strong>Prayer:</strong> Gracious God, every good gift comes from you. Keep me humble, thankful, and ready to serve through Jesus Christ. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000373",
    "value": "<p><strong>Read:</strong> John 11:32-36</p><p><strong>Historical context:</strong> Alexander's funeral sermon speaks of Christian hope and also names the deep sorrow of Kinghorn's congregation. He describes the absent voice, friendship, and care they mourned.</p><p><strong>Sermon theme, paraphrased:</strong> The sermon does not erase the congregation's loss. Alexander tells them that the pastor who advised and comforted them has died, and he acknowledges his own grief as a friend and fellow minister.</p><p><strong>Reflect:</strong> Jesus wept beside a tomb. Hope in his resurrection leaves room for tears, memory, and the company of others. If you grieve today, tell God what you miss; if someone near you grieves, offer presence before advice.</p><p><strong>Prayer:</strong> Compassionate Christ, meet us in loss. Give comfort without asking us to hide our tears, and help us care gently for one another. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000373",
    "value": "<p><strong>Read:</strong> James 1:22-25</p><p><strong>Historical context:</strong> The sermon returns from Kinghorn's biography to the congregation. Alexander asks what it means to remember the teaching they received.</p><p><strong>Sermon theme, paraphrased:</strong> Alexander says that recalling sermons by memory alone is insufficient. A lasting remembrance joins faith to practice.</p><p><strong>Reflect:</strong> What teaching of Jesus do you already know but find hard to practice? Choose one modest act that expresses it today: a word of reconciliation, an honest decision, or care for someone in need.</p><p><strong>Prayer:</strong> Lord, help me receive your word and put it into practice. Guide one concrete act of love today. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000373",
    "value": "<p><strong>Read:</strong> Philippians 2:1-5</p><p><strong>Historical context:</strong> Alexander closed by encouraging a bereaved church to continue in Christ's gospel and in peace with one another. His words were addressed first to that particular Norwich congregation.</p><p><strong>Sermon theme, paraphrased:</strong> The sermon urges believers to keep brotherly love and to persevere together. It points past the mortality of any minister to Jesus Christ, who remains faithful to his people.</p><p><strong>Reflect:</strong> A Christian community cannot rest on one admired person. Where could you strengthen fellowship: by listening, forgiving, serving, or making room for a new voice? Ask Christ to keep your attention on his example.</p><p><strong>Prayer:</strong> Faithful Lord Jesus, sustain your people through change and loss. Give us humble love and unity in you. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000374",
    "value": "<p><strong>Read:</strong> Psalm 150:1</p><p><strong>Historical context:</strong> John Boys preached on Psalm 150 in 1613 during a day of political commemoration in England. This reading follows his Psalm exposition while leaving the sermon’s sectarian argument in its historical setting.</p><p><strong>Sermon theme, paraphrased:</strong> Boys begins with the psalm's repeated invitation to praise the Lord. He considers God's holiness and the shared worship of God's people.</p><p><strong>Reflect:</strong> Praise can begin before you feel cheerful. Name one way God's holiness, mercy, or faithfulness steadies you today. Bring that thought into prayer alone or with others.</p><p><strong>Prayer:</strong> Holy God, turn my attention toward you. Receive my praise and meet me with mercy in the place where I am today. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000393",
    "value": "<p><strong>Read:</strong> Acts 1:8; Ephesians 3:16.</p><p><strong>Historical context:</strong> Edward Hoare preached this sermon at the consecration of a bishop in York. He also said the need for God's strength extends beyond clergy to every believer.</p><p><strong>From the sermon (language updated):</strong></p><p>It follows, therefore, that we all stand in need of power from God. And whatever be our position, whether in the ministry or out of it, whether laymen, deacons, presbyters, or bishops, we all require to be strengthened with might by His Spirit in the inner man.</p><p><strong>Reflect:</strong> The people named in Hoare's sermon held different roles, yet all needed the Spirit's help. Bring a responsibility you face today to God. Where would patient courage, rather than greater status or influence, help you serve well?</p><p><strong>Prayer:</strong> Holy Spirit, strengthen me for the work before me. Give me humble courage and love for the people I serve. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000393",
    "value": "<p><strong>Read:</strong> Acts 1:8; Luke 24:46-48.</p><p><strong>Historical context:</strong> Hoare's sermon called Christians to bear witness to Jesus. These lines are selected from that invitation, apart from the sermon's nineteenth-century dispute about church authority.</p><p><strong>From the sermon (language updated):</strong></p><p>We are to proclaim from His own word what He is, what He has done, what He has promised, and what He is doing. We are to set Him so clearly, so vividly, before the people, that they may see nothing of us, but look fixedly on Him.</p><p><strong>Reflect:</strong> A witness directs attention to Jesus rather than to personal importance. Think of one conversation in which you can listen carefully, speak truthfully, and let Christ remain central without trying to control another person's response.</p><p><strong>Prayer:</strong> Lord Jesus, keep my words honest and gracious. Help me speak of you with humility and leave the outcome in your hands. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000393",
    "value": "<p><strong>Read:</strong> Acts 6:5; Acts 6:10.</p><p><strong>Historical context:</strong> Near the end of the sermon, Hoare pointed to Stephen as an example of faith and the Spirit's presence. His wider conclusion addressed the bishop and Church of England; this reading focuses on the biblical example.</p><p><strong>From the sermon (language updated):</strong></p><p>Here, then, was the key to that marvellous and irresistible power which accompanied his work. He himself was full of faith, and being full of faith, he was full of the Holy Spirit.</p><p><strong>Reflect:</strong> Stephen's witness grew from faith and the Spirit's work, not a title. We cannot manufacture that gift, but we can ask for help and practice faithfulness where we are. What small act of witness or service is open to you today?</p><p><strong>Prayer:</strong> Holy Spirit, deepen my trust in Christ. Guide my words and actions so that they serve others and point toward him. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000397",
    "value": "<p><strong>Read:</strong> Matthew 28:18-20</p><p><strong>Historical context:</strong> Francis Cunningham preached this sermon in 1815 to support a Bible Society. He begins with Christ's commission and asks what good news the church has received.</p><p><strong>Selected sermon passage, lightly modernized:</strong> The Gospel in its strictest sense is good news; it is all that good news of happiness now, which is promised in the ways of religion, and of salvation hereafter.</p><p><strong>Reflect:</strong> The gospel begins with what Jesus has done, not with pressure to win an argument. Recall how Christ's grace has met you. If you speak of faith with someone, let kindness and honest listening shape the conversation.</p><p><strong>Prayer:</strong> Lord Jesus, thank you for your good news. Help me share what I have received with humility, patience, and love. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000397",
    "value": "<p><strong>Read:</strong> Philippians 2:1-4</p><p><strong>Historical context:</strong> Cunningham defended cooperation among Christians from different churches in the work of distributing Scripture. He used the image of neighbors coming together for a shared good.</p><p><strong>Selected sermon passage, lightly modernized:</strong> Would he not account the union, even the partial and temporary union of all parties, to be in itself a great benefit? Would he not be glad, if by any influence, and especially by a good influence, he could lay to rest the evil spirit of bigotry or malevolence?</p><p><strong>Reflect:</strong> Christians can work together without pretending that every difference has disappeared. Which shared act of service could bring you alongside someone from another tradition? Begin with the person who will benefit from that work.</p><p><strong>Prayer:</strong> God of peace, give us humility across our differences. Join our hands in truthful, practical service to our neighbors. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000397",
    "value": "<p><strong>Read:</strong> John 13:34-35</p><p><strong>Historical context:</strong> Much of this part of the 1815 sermon answers arguments between the Church of England and other Protestant groups. The selected sentence names the service and fellowship Cunningham hoped their joint work would foster.</p><p><strong>Selected sermon passage, lightly modernized:</strong> I have now then endeavoured to point out to you the benefit of the principle of co-operation, as proved in this society; its benefit in the astonishing circulation which it has given to the word of God, and in the spirit of union which it has produced.</p><p><strong>Reflect:</strong> Unity becomes visible when people serve together with love. Consider whether a disagreement is keeping you from a modest act of care. You can name a real difference while still treating another Christian as a neighbor in Christ.</p><p><strong>Prayer:</strong> Lord Jesus, teach your people to love one another. Let our shared service point toward you. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000397",
    "value": "<p><strong>Read:</strong> Matthew 7:12</p><p><strong>Historical context:</strong> Cunningham appealed for wider access to the Bible in an age when many people lacked a copy. His figures and assumptions belong to 1815; the invitation to consider another person's perspective remains useful.</p><p><strong>Selected sermon passage, lightly modernized:</strong> Only let us place ourselves in the situation of those millions who have not had the word of God given to them.</p><p><strong>Reflect:</strong> Ask what people actually need before deciding what to give them. Scripture can be shared as an offered gift, with respect for language, culture, and a person's freedom to respond. Whose perspective could you understand better today?</p><p><strong>Prayer:</strong> Generous God, open my eyes to others' needs. Make me ready to listen and to share with respect. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000397",
    "value": "<p><strong>Read:</strong> 2 Corinthians 1:3-4</p><p><strong>Historical context:</strong> At the close of the sermon, Cunningham urged his listeners to give others access to the Scriptural comfort they valued. The original appeal also asked for donations to a named institution.</p><p><strong>Selected sermon passage, lightly modernized:</strong> If then we value these things so much ourselves, let us not seek to shut them out from others; but let us on the other hand, endeavour to disseminate them through the whole world.</p><p><strong>Reflect:</strong> When something has helped you through grief or uncertainty, you may want others to know it too. Offer your story and the Scriptures without treating people as projects. What could it look like to share comfort and practical care together?</p><p><strong>Prayer:</strong> God of all comfort, thank you for meeting me in Christ. Help me offer comfort, Scripture, and practical care freely. Amen.</p>",
    "day_number": 5
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_plans as target
set total_days = edit.value, updated_at = timestamptz '2026-10-22 15:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000374",
    "value": 3
  }
]
$adapt_text$::jsonb) as edit(id uuid, value integer)
where target.id = edit.id;

do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "day_number": 1,
    "references": [
      "Matthew 6:9-13",
      "Philippians 4:6-7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "day_number": 2,
    "references": [
      "James 2:1-5",
      "Psalm 139:23-24"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000373",
    "day_number": 2,
    "references": [
      "2 Peter 1:5-8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000373",
    "day_number": 3,
    "references": [
      "Ephesians 4:15-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000373",
    "day_number": 4,
    "references": [
      "1 Corinthians 15:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000373",
    "day_number": 5,
    "references": [
      "John 11:32-36"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000373",
    "day_number": 6,
    "references": [
      "James 1:22-25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000373",
    "day_number": 7,
    "references": [
      "Philippians 2:1-5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000374",
    "day_number": 1,
    "references": [
      "Psalm 150:1"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000393",
    "day_number": 1,
    "references": [
      "Acts 1:8",
      "Ephesians 3:16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000393",
    "day_number": 2,
    "references": [
      "Acts 1:8",
      "Luke 24:46-48"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000393",
    "day_number": 3,
    "references": [
      "Acts 6:5",
      "Acts 6:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000397",
    "day_number": 1,
    "references": [
      "Matthew 28:18-20"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000397",
    "day_number": 2,
    "references": [
      "Philippians 2:1-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000397",
    "day_number": 3,
    "references": [
      "John 13:34-35"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000397",
    "day_number": 4,
    "references": [
      "Matthew 7:12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000397",
    "day_number": 5,
    "references": [
      "2 Corinthians 1:3-4"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-22 15:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-22 15:00:00+00', timestamptz '2026-10-22 15:00:00+00');
    end if;
  end loop;
end
$$;

do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_new_days$
[
  {
    "id": "90000000-0000-0000-0000-000000000374",
    "day_number": 2,
    "title": "Praise for Creation and Redemption",
    "references": [
      "Psalm 150:2",
      "Romans 4:25"
    ],
    "content": "<p><strong>Read:</strong> Psalm 150:2; Romans 4:25</p><p><strong>Historical context:</strong> Boys asks why God is to be praised in Psalm 150:2. His long sermon also discusses the politics of his day; this reading keeps the focus on its Scriptural theme.</p><p><strong>Sermon theme, paraphrased:</strong> Boys gathers God's works toward us under creation and redemption. He directs praise to the God who made life and to Christ who died and rose for us.</p><p><strong>Reflect:</strong> Look for one sign of creation's goodness, however small. Then remember that Christian hope rests not on the day going well but on the risen Jesus. How might gratitude and hope change one choice you make today?</p><p><strong>Prayer:</strong> Creator and Redeemer, thank you for life and for the hope given in Jesus Christ. Help me live today in gratitude and trust. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000374",
    "day_number": 3,
    "title": "Let Every Breath Praise",
    "references": [
      "Psalm 150:3-6",
      "Colossians 3:16-17"
    ],
    "content": "<p><strong>Read:</strong> Psalm 150:3-6; Colossians 3:16-17</p><p><strong>Historical context:</strong> Psalm 150 ends with instruments and every breathing creature joining in praise. Boys extends the image to the actions of the whole person.</p><p><strong>Sermon theme, paraphrased:</strong> The sermon imagines eyes turned toward God, ears attentive to Scripture, hands helping people in need, and voices singing. In this way praise includes both worship and daily conduct.</p><p><strong>Reflect:</strong> Music is one gift for praise, but it is not the only one. How might your hands, words, attention, or work honor God today? Choose an ordinary action and offer it to Christ with love.</p><p><strong>Prayer:</strong> Lord, let my voice and actions praise you. Tune my heart to love you and to serve my neighbors. Amen.</p>"
  }
]
$adapt_new_days$::jsonb) loop
    insert into public.devotional_days (plan_id, day_number, title, content, created_at, updated_at)
    values ((item ->> 'id')::uuid, (item ->> 'day_number')::integer,
            item ->> 'title', item ->> 'content', timestamptz '2026-10-22 15:00:00+00', timestamptz '2026-10-22 15:00:00+00')
    on conflict (plan_id, day_number) do update
      set title = excluded.title, content = excluded.content, updated_at = excluded.updated_at
    returning id into target_day_id;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-22 15:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-22 15:00:00+00', timestamptz '2026-10-22 15:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish six reviewed devotional adaptations.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-22 15:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000283'::uuid,
  '90000000-0000-0000-0000-000000000310'::uuid,
  '90000000-0000-0000-0000-000000000373'::uuid,
  '90000000-0000-0000-0000-000000000374'::uuid,
  '90000000-0000-0000-0000-000000000393'::uuid,
  '90000000-0000-0000-0000-000000000397'::uuid
);
