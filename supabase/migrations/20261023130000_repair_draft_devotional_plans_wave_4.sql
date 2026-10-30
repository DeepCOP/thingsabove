-- Four complete devotional reconstructions from historical children's sermons,
-- church architecture, and two civic-religious tracts. Historical polemic and
-- harmful dated examples are identified or omitted in labeled editorial adaptations.
-- Existing day IDs 1-17 in The Children's Six Minutes remain in place; days 18-52 are added.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-23 13:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000384",
    "value": "Light, Truth, and the Holy Spirit: Five Readings from a Chapel Guide"
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "value": "Conscience, Justice, and Peace: Six Readings from a 1710 Civic Sermon"
  },
  {
    "id": "90000000-0000-0000-0000-000000000394",
    "value": "Faith Beyond the Census: Four Readings on Christian Witness"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-23 13:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "Fifty-two brief children's sermons by Bruce S. Wright, reconstructed in their source order. Empty hymn placeholders and damaged archaic verse snippets are replaced by Scripture references; dated, exclusionary, or misleading examples are clearly edited with historical context."
  },
  {
    "id": "90000000-0000-0000-0000-000000000384",
    "value": "Five Scripture-led devotions drawn from Percy C. Morris's 1909 description of the Chapel of the Holy Spirit. Historical Anglican art and architecture supply context for reflection on Jesus, the Spirit of truth, the cross, Communion, and Christian witness."
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "value": "Six Scripture-led readings adapted from Andrew Snape's 1710 Lord Mayor sermon. The devotional sequence draws lessons from Naboth, conscience, accountable power, and peacemaking while clearly setting aside the sermon's royalist polemic and its one-sided account of English history."
  },
  {
    "id": "90000000-0000-0000-0000-000000000394",
    "value": "Four Scripture-led readings adapted from James Skinner's 1860 tract about an English religious census. The devotions retain its questions about confession and conviction while explicitly setting aside its supersessionist, sectarian, and partisan arguments."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-23 13:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "Happy New Year",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "Growth",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "Snow",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "Kindness",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "God's Call",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "A Happy Home",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "System",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "A Boy from the Country",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "The Most Beautiful Thing in the World",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "Easter Light",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "April",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "Helping Fingers",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "Two R's and an A",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "Candle Children",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "Marks and Mercy",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "George Matheson's Perseverance",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "Choosing a King",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000384",
    "value": "The Spirit Brings Jesus to Mind",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000384",
    "value": "Led by Light and Truth",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000384",
    "value": "Abide in the True Vine",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000384",
    "value": "Fruit Shaped by the Spirit",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000384",
    "value": "The Spirit Bears Witness to Jesus",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "value": "Read Historical Parallels Carefully",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "value": "Conscience Before Power",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "value": "Religion Cannot Sanctify Injustice",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "value": "Power Under the Way of Jesus",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "value": "Every Leader Is Accountable",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "value": "Peace Without Falsehood",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000394",
    "value": "Receive and Guard the Good News",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000394",
    "value": "A Public Hope Offered with Gentleness",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000394",
    "value": "Truth Is More Than Popularity",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000394",
    "value": "Faith in Heart, Word, and Deed",
    "day_number": 4
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-23 13:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "<p><strong>Read:</strong> Psalm 19:14</p><p>Happy New Year, Juniors!</p><p>The morning of the first day of every year we enter into a contest. We see who will be the first to give that day's greeting. Before I was awake this morning my boy ran into my room shouting, \"Happy New Year! Happy New Year!\" He won in the contest.</p><p>Now, however, you are in Church and it is not proper for you to speak out loud, so I am able to get ahead of you. A Happy New Year to you, every one.</p><p>Well, what will make this year a happy year for you? I will tell you. Let us take this word Happy, and instead of writing it across the page let us write it straight up and down.</p><p>H stands for Helpful. You cannot have a happy year unless you are helpful. He who does not try to be helpful is never very happy.</p><p>A for Active. I want your year to be full of activity. I hope you will be able to skate and slide down hill many days this winter, and that you will enter into all the spring and summer sports with zest and joy.</p><p>P for Playful. All work and no play makes Jack a dull boy. You will want to do something other than play, of course. You will have some home responsibilities, but sandwiched in with the work may there be a good measure of play.</p><p>P for Purposeful. Yes, early in life you should form a purpose. Two questions will help you gain that purpose. First: What do I want to do? Second: What does God want me to do?</p><p>Y for Youth.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "<p><strong>Read:</strong> Luke 2:40</p><p>This second Sunday morning of the New Year I desire to talk to you about growth. The most important holiday afterthought is the thought of growth. You are going to grow every day of this year. Whenever I see a boy on his way to school, or on the field or gymnasium floor, running, romping, playing, I say to myself, \"Can it be possible that this restless, energetic lad was ever a quiet, helpless little babe in the cradle!\" Yes, he was, but he has grown, and he is going to keep right on growing.</p><p>It was said of the boy Jesus, \"He grew.\" His growth was natural. There was nothing of precociousness in the childhood of Jesus. He grew, just as every boy grows.</p><p>His growth continued. It did not stop with childhood, but right on through boyhood, youth and manhood he kept growing. Best of all his growth was balanced. He grew physically, mentally and spiritually. He had a sound body. He loved the out-of-doors. He spent much time in nature. Most of his graphic illustrations were taken from living, growing things. He talked, almost chiefly, about seeds, grain, harvests, trees, birds and living waters. Boys and girls, strive to grow. Be like your Master who grew inward, outward, and upward; inwardly, toward other people, and toward God. \"How can I grow?\" you ask. I will tell you by passing on to you the secret as given by Maltbie Babcock.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "<p><strong>Read:</strong> Job 38:22</p><p>\"Goody, goody, it's snowing!\" This is what I heard early yesterday morning. I think there were many other homes in which this shout of joy ushered in the day. It being Saturday the day was mostly free for playing in the snow. What did you do? You made a snow man. You built a snow fort or house. You had a snowball battle. You slid down hill. You played fox and geese, tracking one another across white fields and through the woods. You had a happy, wonderful day, I know you did.</p><p>Have you ever thought how snow is made, and where it comes? It is formed high in the air, from vapor, and comes down from the clouds, just like rain. Snowflakes are wonderfully varied; no two have exactly the same form. If you will look at the snowflakes through a magnifying glass you will see a great variety of shapes. And all of them are beautiful. We talk about the sparkling beauty of diamonds and other precious gems; crystal snowflakes are more beautiful by far. If only we could keep them from melting what a necklace or a setting for a ring a collection of snowflakes would make!</p><p>God's love is shown to us in the snow. For a fall of snow is like a great blanket, covering the tender roots and seeds, keeping them from freezing, assuring us of another harvest. As today you walk home through the snow let it speak to you of your Father's love.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "<p><strong>Read:</strong> Ephesians 4:32</p><p>One day last week I saw a huge pair of bobs, heavily loaded with coal, being pulled up the street by two big, fine-looking horses. There were two men on the load. Their faces were covered with coal dust from their work. They stopped the horses in front of the house directly across the street from me. I watched them with interest. The first thing one of the men did was to get down, take a board, go around to the front of the horses, lift up the heavy wagon tongue, place the board underneath it as a brace that the necks of the horses might be relieved of the strain of the wagon tongue. At the same time the other man took two warm blankets and covered the horses with them, tucking in the corners beneath the harness to make them tight and warm. Then the men set to work to carry the coal, basket by basket, into the cellar. That was kindness, was it not, to see that the horses were so well cared for on a cold winter day!</p><p>To my mind one of the finest acts of our city government is the way we are taught kindness to animals and birds, by permitting them to make their homes and nests in the public park. What a delight it is to walk through the park and have the squirrels come running up so close, to eat from one's hand! That is kindness.</p><p>How about kindness to people? Have you ever seen an older person walking along the street with a little child of three or four years of age, the child reaching up as far as he could to take the hand of the older person, the older one jerking, pulling, yanking, all the while saying, \"Come now, hurry up, hurry up.\" That is not kindness, is it?</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "<p><strong>Read:</strong> 1 Samuel 3:10</p><p>God calls each one of you. He asks you to give your life to him. He has a special work for you to do. You have heard of Wendell Phillips who did so much to make slavery unlawful in America! Once, when Wendell was a boy fourteen years of age, he heard Lyman Beecher preach. In the course of his sermon the preacher said, \"You belong to God.\" The boy Wendell thought that the preacher looked straight at him when he said that. He went to his home at the close of the service, climbed the stairs to his room, shut the door, knelt in prayer, saying, \"O God, I belong to you, take what is your own.\" He heard and answered God's call.</p><p>Many, many years before Wendell Phillips lived there was another boy. He worked in the temple. He was a youthful assistant to the minister. I suppose he ran errands for him, and performed any and every service about the temple the minister desired. One night, as usual, the boy went to bed and fell asleep. As he slept he heard a voice calling him. Now he was an obedient boy, and though it was hard for him to rouse himself from a sound sleep and leave his comfortable bed he did so. He ran to the minister saying, \"Here I am, you called me, what do you want?\" The minister said, \"No, my boy, I did not call you, go back to bed.\" The boy returned to his bed and again went to sleep. A second time, and even a third time he was called. Each time the faithful, obedient lad leaped from his couch and ran to the minister. The third time it dawned on the mind of the minister that the voice the lad heard was the voice of God, calling him to himself and to his special service. Being a wise and loving man he said to the boy, \"Return to your bed, and if you hear the call again, say, 'Speak, Lord, for your servant hears.'\" The boy did as instructed and that night was forever memorable in his life, for that was the night God called Samuel and Samuel answered.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "<p><strong>Read:</strong> 2 Samuel 6:11</p><p>This morning, the first thing, my boy said to me, \"Tell me a story.\" This is the story I told him. Once upon a time, it was a long, long time ago, so long ago that we can scarcely realize how long, more than twenty-five hundred years ago. Well, once upon a time there was a home—homes then were quite the same in most ways as homes are now—there were children in that home. They played and were happy. And too, I suppose they had their misunderstandings, and sometimes the children quarreled. One day the children heard music. Looking up the street they saw a great company of men marching right toward them. They were soldiers. There were thirty thousand of them. In the center of the marching army were some oxen. The oxen were harnessed to a fine, new cart. On the cart was a chest, most beautifully carved and decorated. On the soldiers came. What was the amazement of the boys and girls when they stopped right in front of their house! Then the king, majestic in his bearing and gorgeously arrayed, came to their father and said, \"I want to leave this chest here in your house. Take good care of it.\" The king's men brought the wonderful chest within, set it down, went out, and the army marched away. From that hour the home was a different home. There was joy, and peace, and an utter absence of quarreling. Three months passed by. Then one day the king came again and took the chest away. But peace and happiness did not depart with the chest. The home was as happy and peaceful and free from bickering through all the coming months as through the three when the wonderful chest was in the house. What was the chest? It was not the king's chest; it was the ark of God. You will find this true story in Second Samuel, the sixth chapter.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "<p><strong>Read:</strong> 1 Corinthians 16:2</p><p>Here are three books. I put them down like this, one beside the other, that is system. I throw them down carelessly, that is not system, it is not orderly.</p><p>Here is a little box. Inside are letters, such as you see on the sign in front of the Church. Each letter has a space all its own. Now if A were put down at M, M at Z, and E at X, what a task it would be to pick out the letters and make a sign!</p><p><strong>Editorial context:</strong> The original sermon compared schools in two countries through one visitor's narrow judgment. A fairer lesson is that every classroom and community benefits when people arrange shared materials, listen to one another, and make room for different ways of learning.</p><p>Here I have a package of envelopes. There are fifty-two envelopes, one for each Sunday in the year. Each envelope is divided in the center. On one side I read, \"For others.\" On the other half I read, \"For ourselves.\" I need not tell you that these are church envelopes. In this way, this systematic way, we support our local church and pay to missions. We like to have the girls and boys, as well as older people, use these envelopes. The financial secretary of your church is just as willing to keep the records of young people who give but five cents in each side of the envelope as he is to keep the account of the man or woman who places five dollars in each side of the envelope every Sunday. You see we want you to grow up systematic and orderly in all your religious life. Our Master is pleased when we do our religious duties \"decently and in order.\"</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "<p><strong>Read:</strong> 1 Samuel 17:45</p><p>Once upon a time there was a boy who lived in the country. It was said of him that he was \"ruddy and withal of a beautiful countenance, and goodly to look to.\" I think that description fits a country lad. Well, this boy had brothers who were away from home in the army, fighting. One day the boy's father said to him, \"I wish you would go down and see how your brothers are getting along, and take with you this present.\" The boy started on his journey. Now when he came to the place where the soldiers were encamped he saw a strange sight. A giant, from the opposing army, came out, blustering and issuing his challenge to any one who would dare come against him. All seemed afraid of him. Even the big, strong soldiers would not do battle with him. Therefore this youth from the country volunteered saying, \"I will go out and fight him.\" They tried to dissuade him, but he insisted. Now he was a perfect shot with the sling. He chose five smooth stones from the brook. With one of these he prevailed over the giant.</p><p>This lad, however, had some other things which stood him in better stead even than the sling and the stones. What were they? First, he had courage. He possessed what all the others lacked. Second, he had the ability to do one thing and do that one thing well. He could use a sling with the utmost accuracy. Third, he had confidence in himself and faith in God. He was not conceited, no, we do not like that. Rather he had self-confidence. Above all was this—\"I come to you in the name of the Lord of hosts.\" So said the lad from the country as he went to fight the giant. What was his name? It is a good name—David.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "<p><strong>Read:</strong> 1 Corinthians 1:18</p><p>The most beautiful thing in the world! Now what is it? If you will lift your eyes just a little you will see the flowers on the table, but lift them higher than the flowers, higher than this pulpit, higher than the pipes of the organ, above the lights, above the arch, you will see the most beautiful thing in the world. Do you see it? It is the Cross.</p><p>Do you know, girls and boys, that long ago the cross was the most repulsive thing in the world? It was odious. It had none of the charm and beauty that is now woven about it. But from the day that Jesus was crucified on the cross it took on new meaning, and it has grown in charm and power until I think we all agree that it is the most beautiful sight in the world.</p><p>Out in Colorado, high up the side of a mountain, where the snow never melts in the crevices, may be seen two long ravines, one straight up and down, the other straight across. The snow is packed into those ravines all through the year, and lifting the eyes one may see upon the lofty mountain side the Holy Cross.</p><p>In the summer seas, one of the things that mariners are guided by and that tourists look for, is the Southern Cross. There it is, fashioned by the position of the stars in the clear skies of the tropics.</p><p>There are many men who wear a cross as a watch fob. There are women who wear a cross as a pendant about the neck. This is an outward sign of an inner devotion. The important thing, my dear young Christians, is to have the cross, its power and meaning, stamped upon one's heart. Is that where you wear the Saviour's cross?</p>",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "<p><strong>Read:</strong> Matthew 28:1-10</p><p>This glad morning, when the world is so bright and beautiful, I want to talk to you about Easter Light.</p><p>One of the most interesting men in our city is a man who goes about our streets with two long sticks. He is the lamplighter. Here he comes down the street! See how he pauses at each lamp post. With one stick he pulls the little chain that turns on the gas; with the other he sets the light going. He walks into the dark, but he leaves behind him miles of lighted streets. I hope we shall have always many streets lighted with gas, for I love to see the lamplighter dot his way along the streets and avenues with lighted periods.</p><p>In the center of our city is the tall Electric Light Building. On the very tip of the tower is a high power electric light. It is lighted every evening from eight to eleven o'clock. Children, looking out of their windows as they go to bed, think that it is another star in the sky, it is so bright and steady.</p><p>More wonderful than any of these lights is the source of all light. It is the light that God provides for all of his children. The sun warms our fields, makes our gardens grow, and causes our harvests to prosper. The sun never fails us.</p><p>Now there is another light, a light that is above even the sun. That is the light of Easter day. The tomb of death is no longer dark, for the resurrection light brightens every corner and shines in radiance through the open doorway. The light of Easter also lights up the windows of our heavenly home. When you are out of an evening it is not pleasant to return to a dark house. There is a wondrous welcome in lighted windows. That welcome God gives us in the light of Easter day. Christ, and his resurrection, shine in the windows of heaven to greet us when we go home.</p>",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "<p><strong>Read:</strong> John 11:25</p><p>I have in my hand a small branch from a big tree. This branch is from an apple tree. Here are seen the tiny buds, the promise of the blossom, and after that the fruit. Have you ever seen an apple orchard in blossom? People rave about the cherry blossoms of Japan, and the fire trees, flaming red, of the Philippines. I have been in both countries, but I think there is no more beautiful sight in any country than the blossoming apple orchards of America.</p><p>As you came to church this morning you saw all along the streets and avenues hundreds of trees like this branch, sending forth their first buds. What do these buds tell us?</p><p>First of all they tell us of God. I do not see how any one can live through the awakening spring season and not think daily thoughts of God. Most people remember the Creator. The psalmist warns against living as though there were no God. Spring can invite us to wonder, gratitude, and renewed attention to the Creator.</p><p>In the second place, this branch tells us of God's Love. He, the loving Father of all people, makes blessed provision for the care and nurture of his children. He reminds us each year, in seedtime and harvest, of his boundless love. His love never fails. There have been many hundreds of years in the history of the world, yet each year has had its spring, its seedtime, and its Resurrection. Young people, let God's April speak to you.</p>",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "<p><strong>Read:</strong> Ecclesiastes 9:10</p><p><strong>Historical examples, respectfully updated:</strong> While living in Manila, the author saw a hearing child interpret a lecture in sign language for two Deaf children. He later watched a student steady a parcel while a passenger tied it. Both moments show that even a small, attentive action can help another person participate.</p><p>One day a girl, coming out from school, got on a street car to go to her home. The car was crowded. She found a seat next to a woman who was heavily laden with bundles. She had all she could do to hold those bundles in her lap and keep them from falling and scattering their contents on the floor. Then a string about one of the packages became untied. She struggled to get that string fastened securely. She had so many packages, her fingers were numb with cold, and again and again the string slipped just at the crucial time. Finally this school girl, who was an attractive, well-dressed girl, reached over and placed her nicely gloved finger on the obstreperous knot. There was a grateful smile from the troubled woman and a hearty \"Thank you.\" The next stop was the girl's home. As she went to the end of the car she passed a school friend who had watched the little incident. She said to her, \"I see you belong to the helping hand society.\" \"No,\" replied the girl, \"not the helping hand, just the helping finger society.\" This is a great society, girls and boys. Admission to it requires no initiation fee, no dues, simply the desire and the will to be helpful wherever you are.</p>",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "<p><strong>Read:</strong> Psalm 119:11</p><p>Do you know what week this is? We have all sorts of weeks, don't we! There is Sunday School week, Go to Church week, Boy Scout week, Red Cross week, Social Welfare week, Hospital week, Y.W.C.A. and Y.M.C.A. week. Sometimes we wish we could have one week all to ourselves.</p><p>Well, this is a special week. It is called Good Literature week. I want to tell you about Good Literature week by the use of these three letters, two R's and an A.</p><p>The first R stands for Read. By all means read. There is no excuse for not reading, there is so much to read. Indeed I think that is the chief difficulty, we have too much, at least too much of that which is not good to read. Here's the bulky daily paper. When it is delivered there is a rush for it. The children want the comic supplement. So do some of the grownups.</p><p>That is true, and all right, but read something beside the comics.</p><p>The second R is Remember. You cannot remember all that you read. You can remember much. You should train your mind to remember the best. John Ruskin, one of the most gifted of Englishmen, said, \"To this I owe all that I have of power, to the fact that when I was a boy my mother made me learn, every day, and remember, a verse of the Bible.\"</p><p>Now the A. The A stands for, can you guess? It means Action. Read, remember what you read, and then apply it, put it into action. It is a fine thing to read a story like Pollyanna and get all excited over it. It is much finer to read Pollyanna and then put her spirit into action in the daily life of the home.</p>",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "<p><strong>Read:</strong> Matthew 5:14-16</p><p><strong>Source-based editorial adaptation:</strong> Wright used a candle to invite children to grow in a balanced way: caring for body, mind, relationships, and life with God.</p><p>A fragrant candle suggested kindness and unselfishness. Its steady flame suggested integrity: living truthfully and keeping faith even when no one is applauding.</p><p>A candle gives light beyond itself. Jesus calls his followers the light of the world, so our words and actions can make love, truth, and mercy easier for others to see.</p>",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "<p><strong>Read:</strong> Psalm 103:8-12</p><p><strong>Source-based editorial adaptation:</strong> Wright told of nails driven into a door for wrong actions and removed for good ones. The remaining holes illustrated that choices can have consequences even after the action stops.</p><p>The story needs the rest of the Christian message: God is merciful. Confession opens the way to forgiveness, and grace helps us repair harm where we can. A scar may remain, but it does not place a person beyond God's love or beyond a changed life.</p><p>Is there harm you can begin to repair today? Ask God for mercy, courage, and wisdom for the next honest step.</p>",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "<p><strong>Read:</strong> Isaiah 42:16</p><p><strong>Source-based editorial adaptation:</strong> George Matheson became blind while preparing for ministry. He continued his studies with practical support from family and friends, was ordained, served congregations, and wrote hymns that are still sung.</p><p>The original sermon treated blindness as a contrast to spiritual sight. Matheson's life is better honored without suggesting that disability makes a person less capable. His perseverance and the community that supported his work can teach us to receive help, remove barriers, and use our gifts faithfully.</p>",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": "<p><strong>Read:</strong> 1 Samuel 16:7</p><p>What would you do if you were asked to select a young man who should some day be president of the United States? What tests would you apply? Would you look upon the clothes that he wore? Would you consider the color of his hair? Would you insist that he should be of a certain height? Once upon a time there was a good and wise man who was asked to choose a king for his people. He started on his journey in search of the most promising youth he could find. By and by he came to a home where there were many boys. One of these boys stood before him. He was tall. He was well formed. He had a good bearing. Surely, thought the king-chooser, here is just the man. But something inside him, \"the still small voice\" I think it was, said to him, \"No, do not choose him, he is not the one.\" The father then called a second son. Like the first he was goodly to look upon. The great man commissioned to choose a king was about to select this one when the same voice inside warned him to wait. A third son was summoned. A third time the voice said, \"No, he is not the one.\"</p><p>How chagrined the father must have been to have all seven of his splendid sons rejected! All? No, not all. For the king-chooser said, \"Have you no more sons?\" \"Yes, I have one other, but he is young and the keeper of the sheep. I am sure you would not think of him as a king.\" \"Nevertheless,\" said the prophet, \"send for him.\" And he came, the youngest, the most unlikely one of all, at least so the father and the brothers thought. But the voice within said, \"This is the one, choose him.\" You will want to read all of this wonderful story and you will find it in your Bible, First Samuel the sixteenth chapter.</p>",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000384",
    "value": "<p><strong>Read:</strong> John 14:25-27; 1 Corinthians 11:23-26</p><p><strong>Historical context:</strong> Percy C. Morris wrote a guide to a new London church chapel in 1909. Its architecture is the historical setting for these readings; the building itself is not the object of devotion.</p><p><strong>Source-based editorial paraphrase:</strong> Morris says the chapel was intended for Holy Communion and dedicated to the Holy Spirit, whom Jesus calls the Spirit of truth and the Comforter who brings his words to remembrance.</p><p><strong>Reflect:</strong> The Spirit directs attention to Jesus—his teaching, his peace, and his self-giving love. When Christians share Communion, they remember the Lord who gave himself and proclaim his death until he comes. Which word or action of Jesus do you need to remember today?</p><p><strong>Prayer:</strong> Holy Spirit, bring the words of Jesus to mind. Form his peace and self-giving love in us as we remember him. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000384",
    "value": "<p><strong>Read:</strong> Psalm 43:3; John 16:13-15</p><p><strong>Historical context:</strong> The guide celebrates particular universities and makes broad historical claims for them. This reading keeps the artwork's prayer for light while leaving those institutional claims in the source.</p><p><strong>Source-based editorial paraphrase:</strong> The chapel roof pictured the Holy Spirit as a dove sending out rays of light. Nearby university emblems and the prayer “Send out your light and your truth” connected learning with humble dependence on God.</p><p><strong>Reflect:</strong> Learning can serve truth, but education and prestige do not make anyone infallible. Jesus says the Spirit glorifies him. Ask whether a belief leads you toward Christ's truth, humility, justice, and love—and remain willing to be corrected.</p><p><strong>Prayer:</strong> Spirit of truth, lead us out of pride and confusion. Fix our attention on Jesus and teach us to use knowledge for our neighbors' good. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000384",
    "value": "<p><strong>Read:</strong> John 15:1-5; Hebrews 10:10-14</p><p><strong>Historical context:</strong> Morris explains Anglican Eucharistic symbols and devotional art. Christians differ about sacred images and sacramental language; the Scripture focus here is Christ himself and his once-for-all offering.</p><p><strong>Source-based editorial paraphrase:</strong> Carved vines pointed to Jesus, the true vine, while the reredos depicted his crucifixion as his one self-offering on the cross. The art joined continuing life in Christ with the saving work he has completed.</p><p><strong>Reflect:</strong> Branches bear fruit by remaining in the vine. Christian growth begins in communion with Jesus, not in proving our worth. What practice helps you abide in him—Scripture, prayer, Communion, rest, confession, or loving service? Choose one faithful step.</p><p><strong>Prayer:</strong> Lord Jesus, true vine and crucified Savior, keep us in your love. Let the life you give bear patient and generous fruit in us. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000384",
    "value": "<p><strong>Read:</strong> Galatians 5:22-25</p><p><strong>Historical context:</strong> This source section also explains medieval images of penance and several church traditions. Those details remain in the linked guide; this reading centers on Paul's plainly stated fruit of the Spirit.</p><p><strong>Source-based editorial paraphrase:</strong> The chapel windows represented the fruit of the Spirit through flowers, plants, and scenes from Scripture. Morris intended the beauty of the glass to point beyond itself to character formed by God.</p><p><strong>Reflect:</strong> Love, joy, peace, patience, kindness, goodness, faithfulness, gentleness, and self-control grow over time. We do not need to display every fruit perfectly today. Which one does a relationship or decision especially need from you?</p><p><strong>Prayer:</strong> Holy Spirit, grow the life of Jesus in us. Make our words and choices loving, truthful, patient, and gentle today. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000384",
    "value": "<p><strong>Read:</strong> Luke 1:35; Matthew 3:16-17; Acts 1:8</p><p><strong>Historical context:</strong> The figures and symbols belong to a particular church's visual tradition. The biblical center is the triune action they were meant to recall: the Father sends, the Son comes among us, and the Spirit rests upon and bears witness to him.</p><p><strong>Source-based editorial paraphrase:</strong> The east window placed the Annunciation and Jesus' baptism together because both scenes speak of the Holy Spirit. Other images showed apostles and witnesses carrying the good news outward.</p><p><strong>Reflect:</strong> The Spirit's work does not end in private inspiration. Acts says the Spirit gives power to bear witness to Jesus. Where can your witness take the form of a truthful word, a reconciled relationship, or practical care?</p><p><strong>Prayer:</strong> Father, through your Holy Spirit keep us close to your Son. Give us courage and love to bear faithful witness to Jesus. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "value": "<p><strong>Read:</strong> 1 Kings 21:1-16; 2 Timothy 2:15</p><p><strong>Historical context:</strong> Andrew Snape preached this sermon at St. Paul's Cathedral in 1710 on a royal commemoration. He compared King Charles I with Naboth and attacked the king's opponents. These readings do not adopt that political parallel.</p><p><strong>Source-based editorial paraphrase:</strong> Snape briefly warns that biblical events and later history should be compared carefully. He says no human merit or suffering should be treated as equal to that of the crucified Redeemer, even while making an extended comparison of his own.</p><p><strong>Reflect:</strong> Scripture can illuminate public life, but it can also be recruited to make our preferred side look innocent and its opponents wicked. Read the whole biblical account, test historical claims, and keep Jesus—not a ruler, party, or nation—as the standard.</p><p><strong>Prayer:</strong> God of truth, teach us to handle Scripture faithfully. Guard us from using your word to flatter power or excuse our side. Keep our eyes on Jesus. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "value": "<p><strong>Read:</strong> 1 Kings 21:1-4; Acts 5:29</p><p><strong>Historical context:</strong> Snape reads Naboth's refusal through Israel's inheritance law, then uses it to defend Charles I. The devotional lesson here remains with Naboth and the limits that faith and justice place on powerful demands.</p><p><strong>Source-based editorial paraphrase:</strong> Naboth would not surrender his ancestral vineyard merely because a king wanted it. Snape also acknowledges that God alone judges the heart without error and that human judgments should be charitable and cautious.</p><p><strong>Reflect:</strong> Authority does not turn an unjust demand into a just one. A faithful refusal can be costly, so conscience needs Scripture, wise counsel, honest facts, and concern for those affected. Where do you need courage to say no—or humility to reconsider a demand you have made?</p><p><strong>Prayer:</strong> Lord, form our consciences in truth and love. Give courage to resist injustice and humility to examine our own use of power. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "value": "<p><strong>Read:</strong> 1 Kings 21:8-16; Isaiah 58:6-10</p><p><strong>Historical context:</strong> The sermon emphasizes that Jezebel's plot used a fast, an assembly, false charges, and perjured witnesses. Snape then maps those details onto a disputed English execution; that royalist argument is left in the source.</p><p><strong>Source-based editorial paraphrase:</strong> Naboth's killers surrounded injustice with religious ceremony. Public fasting and solemn language did not make false witness, corrupt judgment, and murder holy.</p><p><strong>Reflect:</strong> Religious words cannot cleanse a cruel plan. Isaiah joins true worship to freeing the oppressed, sharing bread, and refusing accusation. When a cause invokes God, examine its methods: Does it tell the truth, protect the vulnerable, and allow honest accountability?</p><p><strong>Prayer:</strong> Holy God, expose worship that hides injustice. Make our prayer truthful and our devotion active in mercy, fairness, and care for people at risk. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "value": "<p><strong>Read:</strong> Mark 10:42-45; Proverbs 15:22</p><p><strong>Historical context:</strong> Snape's fourth section gives a partisan account of conflict between Charles I and Parliament. It is not reliable as a stand-alone history. Its descriptions of pressure, advisers, and unchecked power can prompt a broader examination of leadership.</p><p><strong>Source-based editorial paraphrase:</strong> The sermon describes political actors competing for control, dismissing trusted counsel, and treating opposition as treachery. Snape applies those charges almost entirely to one side.</p><p><strong>Reflect:</strong> Jesus rejects leadership that lords power over others and names service as greatness. Healthy authority welcomes truthful counsel and clear limits. In your own influence—at home, work, church, or community—whose voice is easy to dismiss, and how can you listen responsibly?</p><p><strong>Prayer:</strong> Servant King, reshape our use of authority. Give leaders wise counsel, protect those affected by their choices, and teach us to serve rather than dominate. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "value": "<p><strong>Read:</strong> Psalm 146:3-5; Micah 6:8</p><p><strong>Historical context:</strong> Even while defending Charles I, Snape concedes that the reign included legitimate grievances, unjust demands, and mistakes. He writes that princes are fallible human beings whose advisers can mislead them.</p><p><strong>Source-based editorial paraphrase:</strong> No ruler is beyond error. Snape's concession interrupts the sermon’s idealized royal portrait and reminds readers that public authority must answer to justice rather than personal loyalty.</p><p><strong>Reflect:</strong> Scripture tells us not to place saving trust in rulers. We may respect an office, pray for leaders, challenge wrongdoing, and protect neighbors at the same time. Which public claim do you need to examine by the demands of justice, mercy, and humility?</p><p><strong>Prayer:</strong> God, judge all power with truth and mercy. Give leaders humility, give communities courage, and help us seek justice without making an idol of any person or institution. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "value": "<p><strong>Read:</strong> Ephesians 4:1-6; James 3:17-18</p><p><strong>Historical context:</strong> Snape laments the factions that fed the English Civil War, although his sermon also repeats inflammatory claims about the opposing faction. Historical grief can teach peace only when we examine the rhetoric of our own side too.</p><p><strong>Source-based editorial paraphrase:</strong> The sermon warns that suspicion, hostile labels, and party formation can harden into destructive division. It closes by urging civic leaders toward religion and virtue, framed through the politics of its time.</p><p><strong>Reflect:</strong> Christian unity is neither uniformity nor silence about harm. James describes heavenly wisdom as peace-loving, gentle, open to reason, and sincere. What label or suspicion keeps you from hearing someone truthfully? Seek one step toward peace that does not conceal injustice.</p><p><strong>Prayer:</strong> Prince of Peace, free us from contempt and dishonest unity. Make us gentle, open to reason, courageous about harm, and eager to preserve the Spirit's bond of peace. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000394",
    "value": "<p><strong>Read:</strong> 2 Timothy 1:13-14; 1 Corinthians 15:1-4</p><p><strong>Historical context:</strong> James Skinner wrote in 1860 during an English dispute over whether a national census should ask about religious profession. He defended the Church of England in strongly sectarian terms. This reading takes his concern for received Christian truth without his attacks on Jewish people or other Christians.</p><p><strong>Source-based editorial paraphrase:</strong> Skinner points to historic Christian creeds, Baptism, and Communion as ways the church receives and hands on its confession. His tract argues that faith has content and that Christians are responsible for remembering it.</p><p><strong>Reflect:</strong> Paul summarizes the gospel around Jesus Christ: he died for our sins, was buried, was raised, and appeared to witnesses. Guarding that good news requires more than defending a label. It means letting Christ's death and resurrection shape our worship, truthfulness, hope, and love.</p><p><strong>Prayer:</strong> Faithful God, keep the good news of Jesus alive in your church. Give us humility to receive it, courage to confess it, and love to embody it. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000394",
    "value": "<p><strong>Read:</strong> 1 Peter 3:15-16; Matthew 5:14-16</p><p><strong>Historical context:</strong> Skinner treated a proposed census question as a test of willingness to confess Christ. A state form and Christian witness are different matters. Freedom of conscience includes both the freedom to speak about faith and the freedom not to be coerced by government or church.</p><p><strong>Source-based editorial paraphrase:</strong> The tract insists that Christian faith cannot be reduced to a private idea with no effect on speech or conduct. It gathers biblical examples of people who spoke about their hope in public.</p><p><strong>Reflect:</strong> Peter joins readiness to speak with gentleness, respect, and a clear conscience. Public witness does not require pressure, contempt, or control. What could it look like for your hope in Christ to become visible through an honest explanation and a loving action?</p><p><strong>Prayer:</strong> Jesus, light of the world, make our hope visible without pride or coercion. Give us gentle words, clear consciences, and deeds that honor our neighbors. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000394",
    "value": "<p><strong>Read:</strong> John 14:6; Ephesians 4:15</p><p><strong>Historical context:</strong> Skinner argued that a religious census could count adherents but could not decide whether a belief was true. He then used biblical minorities to claim superiority for his own church position. This reading keeps the distinction between truth and popularity while rejecting contempt for people outside one's group.</p><p><strong>Source-based editorial paraphrase:</strong> The tract observes that numbers alone cannot establish religious truth. A popular claim may be false, and a small community may also be mistaken; counting does not replace discernment.</p><p><strong>Reflect:</strong> Christians seek truth in Jesus and are told to speak it in love. Humility asks both, “Am I merely following the crowd?” and “Am I treating my minority position as proof that I am right?” Bring convictions into prayer, Scripture, accountable community, and patient attention to their fruit.</p><p><strong>Prayer:</strong> Lord Jesus, lead us in your truth. Free us from fear of the crowd and from pride in being different; teach us to speak truth in love. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000394",
    "value": "<p><strong>Read:</strong> Romans 10:9-10; 1 John 3:18</p><p><strong>Historical context:</strong> The tract ends by pressing English readers to state a religious identity and condemning political opponents. Its enduring question is narrower: does professed faith remain hidden from a person's words and actions? The census dispute and partisan denunciations remain in the linked historical source.</p><p><strong>Source-based editorial paraphrase:</strong> Skinner argues that inner conviction and outward confession belong together. He warns against using private belief as an excuse for silence, although he applies that warning too harshly to a political controversy.</p><p><strong>Reflect:</strong> Romans connects trust in the risen Jesus with confession, and 1 John joins love to concrete action. Some people cannot speak safely in every setting, so public faithfulness will take different forms. Where can your trust in Christ become a truthful word or a deed of love today?</p><p><strong>Prayer:</strong> Risen Lord, unite our hearts, words, and actions. Give courage to speak when it is wise, restraint when another's safety requires it, and steadfast love in every setting. Amen.</p>",
    "day_number": 4
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_plans as target
set total_days = edit.value, updated_at = timestamptz '2026-10-23 13:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "value": 52
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
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 1,
    "references": [
      "Psalm 19:14"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 2,
    "references": [
      "Luke 2:40"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 3,
    "references": [
      "Job 38:22"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 4,
    "references": [
      "Ephesians 4:32"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 5,
    "references": [
      "1 Samuel 3:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 6,
    "references": [
      "2 Samuel 6:11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 7,
    "references": [
      "1 Corinthians 16:2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 8,
    "references": [
      "1 Samuel 17:45"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 9,
    "references": [
      "1 Corinthians 1:18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 10,
    "references": [
      "Matthew 28:1-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 11,
    "references": [
      "John 11:25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 12,
    "references": [
      "Ecclesiastes 9:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 13,
    "references": [
      "Psalm 119:11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 14,
    "references": [
      "Matthew 5:14-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 15,
    "references": [
      "Psalm 103:8-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 16,
    "references": [
      "Isaiah 42:16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 17,
    "references": [
      "1 Samuel 16:7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000384",
    "day_number": 1,
    "references": [
      "John 14:25-27",
      "1 Corinthians 11:23-26"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000384",
    "day_number": 2,
    "references": [
      "Psalm 43:3",
      "John 16:13-15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000384",
    "day_number": 3,
    "references": [
      "John 15:1-5",
      "Hebrews 10:10-14"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000384",
    "day_number": 4,
    "references": [
      "Galatians 5:22-25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000384",
    "day_number": 5,
    "references": [
      "Luke 1:35",
      "Matthew 3:16-17",
      "Acts 1:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "day_number": 1,
    "references": [
      "1 Kings 21:1-16",
      "2 Timothy 2:15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "day_number": 2,
    "references": [
      "1 Kings 21:1-4",
      "Acts 5:29"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "day_number": 3,
    "references": [
      "1 Kings 21:8-16",
      "Isaiah 58:6-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "day_number": 4,
    "references": [
      "Mark 10:42-45",
      "Proverbs 15:22"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "day_number": 5,
    "references": [
      "Psalm 146:3-5",
      "Micah 6:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "day_number": 6,
    "references": [
      "Ephesians 4:1-6",
      "James 3:17-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000394",
    "day_number": 1,
    "references": [
      "2 Timothy 1:13-14",
      "1 Corinthians 15:1-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000394",
    "day_number": 2,
    "references": [
      "1 Peter 3:15-16",
      "Matthew 5:14-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000394",
    "day_number": 3,
    "references": [
      "John 14:6",
      "Ephesians 4:15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000394",
    "day_number": 4,
    "references": [
      "Romans 10:9-10",
      "1 John 3:18"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-23 13:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-23 13:00:00+00', timestamptz '2026-10-23 13:00:00+00');
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
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 18,
    "title": "Worship and Toil",
    "content": "<p><strong>Read:</strong> Luke 11:1</p><p>One day about one hundred years ago a little boy named Jean stood by his father's side watching the setting sun sink into the waves of the sea. The glory of the scene stirred his boyish enthusiasm and he poured out his heart in an ecstasy of joy. The father reverently took off his cap and said, \"My son, it is God.\" The boy never forgot that word, \"It is God.\"</p><p>Jean came of a peasant family, so he had to take his place in the field and earn his bread \"by the sweat of his brow.\" On Sundays the fields were forsaken and the family went to the village church where the father was the leader of the choir. After church friends and relatives sometimes came home to spend the afternoon with the family. One Sunday, soon after the return from church, the bent figure of an aged peasant slowly made his way along the road. There was something about the figure that struck the boy Jean. He took a piece of charcoal and hurriedly drew a sketch upon the wall. Every movement and attitude was so perfectly depicted that everybody laughed—everybody but the father. He sensed the gift possessed by his boy, whose growing talent he had been watching. \"My Jean,\" he said, \"I will no longer hinder you from learning that which you are so anxious to know.\"</p><p>Jean Francis Millet, for such is his full name, became the artist of peasantry. He never made any other boast. His character was of the highest. He had a firm faith in God. He believed in the Bible as the Word of God. He looked upon his use of the brush as preaching upon canvas the purity and truth he believed.</p><p>\"The Angelus\" is the name of the best known picture that he painted. It shows two workers in a potato field, a man and a woman, who hear from the near-by village the faint tones of the Angelus bell calling them to prayer. They pause, stand erect, bow their heads and worship. It is a beautiful picture. I hope you have a copy framed in your room.</p>",
    "references": [
      "Luke 11:1"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 19,
    "title": "God's Clock",
    "content": "<p><strong>Read:</strong> Psalm 74:16</p><p>Do you own a watch? If you do not now you will some day. I have a friend whose watch came to him this way. His father said to him, \"When you graduate from High School I will give you a watch.\"</p><p>Is there a \"town clock\" where you live? Is it dependable? Do men set their watches by it? Do people, passing it, glance up to see if they are late? In the village where I began my ministry the Baptist tower held the town clock. I lived but a few doors away. I went to bed by it. I studied by it. I was wakened by it. Even now, and many years have passed since then, I can hear its clear bell strike the hours.</p><p>The strangest clock I ever saw was in China. I went up the West River to the city of Canton. I was carried through the narrow, crowded streets to the top of a little hill at the city's edge. There, on the very tip-top I saw the \"Water Clock.\" I read, \"This water clock is a most ancient, authentic, celebrated and sacred relic of Kwong Tung Province, over 1,300 years old. It was erected on the top story of the north Worshiping Tower which was built by Chin To, King of the South of China.\"</p><p>It was an ancient water-powered clock. I stood and looked at it and thought, \"This clock was running when George Washington was president; it was running when Christopher Columbus sailed on his great voyage of discovery; long years, long centuries before that it was built.\"</p><p><strong>Editorial context:</strong> The sun has helped people mark days and seasons across many cultures. Earth's rotation and its journey around the sun give us reliable patterns for daily life. Creation invites wonder and worship, while pointing beyond every created light to God the Creator.</p>",
    "references": [
      "Psalm 74:16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 20,
    "title": "The Human Kodak",
    "content": "<p><strong>Read:</strong> Proverbs 4:25</p><p>I wonder how many of you have a kodak. Yes, many of you own one. What a wonderful little machine a kodak is! First we buy a film, then we open the kodak and place the film. Now pull the paper over to the empty roll and fasten, close the kodak and begin to wind. Oh, here you are, No. 1. The day is clear, for we must have a clear day to get the best picture. We hold the kodak very steady, then snap, we have it. Next we pull a little slide in the back, take a pencil and write down the date and name. Let me see, what was that picture? Oh, yes, \"Chrysanthemum (is that the way to spell it?) exhibition.\" Next the films are developed, and the kodak pictures are complete, all but pasting them in a big book.</p><p>For all that the kodak is a whole lot of fuss, isn't it? But, do you know, each one of us has a kodak God has given him which works itself. We have the open circle through which the pictures are taken, our eyes, and beyond the eyes, in the brain, are thousands of films. We start out in the morning and the moment we open our eyes we begin exposing those films. We do not have to do any clicking for these pictures, one after another, click, click, click, and they are developed as fast as they are taken.</p><p>If you should say to a man who has reached three score years and ten, \"Tell me the clearest picture you can remember,\" he would not show a picture that was taken yesterday, or last week, or last year. He would turn back the pages of his memory book fifty, sixty years. The clearest pictures he possesses are those that were snapped in his boyhood. Every day you are taking pictures that are going to remain with you as long as you live. Let us resolve, girls and boys, that as we go out each morning and our human kodak begins clicking, we shall take only pictures that are true, pure and clean.</p>",
    "references": [
      "Proverbs 4:25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 21,
    "title": "Watch Lessons",
    "content": "<p><strong>Read:</strong> 1 Corinthians 15:58</p><p>My grandfather was a foreman in a tannery for a great many years. Finally, as he was approaching seventy years of age, he left the tannery to retire to a quieter life. The men who worked in his department had a real affection for him. As an expression of that esteem they presented him, on his last day with them, a beautiful, solid gold watch. On the inner cover they engraved his name, the date, and the occasion of the presentation. When my grandfather died the watch became my father's possession. Then upon my father's death the watch came to me. What a joy it is to carry such a watch! Here are some lessons my watch teaches me.</p><p>The case is but the outside. It is nice to have a gold case, it looks so well. But that does not make the watch keep any better time. It would keep just as accurate time if the case were iron. You see it is the inside that counts. It is the same with life. The inner workings matter as much as the outer case; character cannot be measured by appearance or wealth.</p><p>Now here is the tiny second hand. It rushes around, jumping, hurrying, fussy, as though it were doing the whole job. But you cannot tell time by the second hand. Knock it off and the watch goes right on running.</p><p>Here's the minute hand. How big, and solemn and serious it looks! Surely the minute hand is important. What time is it? Fifteen minutes after. Fifteen minutes after what? The minute hand does not say.</p><p>Ah, here's the hour hand. Strong, steady, dependable. The hour hand does not move very fast, you cannot see it move. It makes no fuss at all, but you can tell time by the hour hand. Let your life be like the hour hand of the watch, so true and steady that other girls and boys who daily watch you may know life's time, may never be led astray.</p>",
    "references": [
      "1 Corinthians 15:58"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 22,
    "title": "What Did You See?",
    "content": "<p><strong>Read:</strong> Psalm 92:13</p><p>A few days ago I made a trip on the train. When I returned home one of the first questions my little boy asked me was, \"What did you see?\" I shall tell you what I told him.</p><p>Looking out of the car window I saw an immense field, acres and acres, and in that field were planted hundreds, yes thousands, of little trees. I inquired of the man who sat next me, \"What are those little trees for?\" He said, \"They are growing those little trees to reforest the desolate, burned over regions of the Adirondacks.\" I said to myself, \"That is just what we are doing in my church. We are growing girls and boys to reforest the needy places of the earth.\" I inquired, \"How long do they keep those little trees there?\" \"Not very long,\" said he, \"just long enough to give them a good start. Then they transplant them.\" Again I said to myself, \"That is exactly what we do. We keep the girls and boys only a little while, then they are transplanted.\"</p><p>I had another question. \"When they transplant these little trees how do they plant them, haphazard, every-which-way?\" \"No, indeed,\" was his answer, \"they are planted in rows, and close together.\" Exactly what we are doing in our church, I thought. We are growing our girls and boys, and we are keeping them close together, because they are such a help to one another, and there is great inspiration in numbers.</p><p>Looking out of the train window at those trees of future forests, I thought of the verse in Isaiah, \"The mountains and the trees shall break forth before you into singing, and all the trees of the field shall clap their hands.\" I can hear the mountains and the hills of the Adirondacks singing because of the growing trees, and I hear the mountains and the hills of earth singing because of the millions of growing girls and boys who shall reforest the desolate places of earth.</p>",
    "references": [
      "Psalm 92:13"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 23,
    "title": "Knife Lessons",
    "content": "<p><strong>Read:</strong> 1 Corinthians 9:22</p><p>I have here a knife. It was given me by a friend, a token of his affection and esteem, when I went aboard the steamer in Manila, Philippine Islands, to return to the homeland. All these years since then the knife has been on my study desk, daily teaching me. What lessons does this knife teach?</p><p>First of all the knife tells me of Strength. The most important part of this knife is what I call the backbone. It is the main portion of the knife to which all the blades are fastened, as well as the polished pearl handle. This would be a weak and useless knife did it not have a backbone. It says to me every day \"Be strong, stand up, have convictions, be steadfast.\"</p><p>Lesson number two, Discipline. This knife has been subjected to many trials and tests. The steel of which these blades are made had to go through a hard, hot, trying process before they were tempered and fit to take an edge and hold it. Sometimes I rebel about certain processes of the days, then I think of my knife and learn from it the lesson of discipline.</p><p>The third lesson this knife teaches me is Neatness. Now I can picture the man who bought this knife. As he went into the store, he stood before the glass show case in which were displayed scores of different kinds of knives. There were dark knives and light knives, big knives and little knives. His eye caught this knife, with its graceful lines, its smooth pearl handle, and he said, \"That is a neat knife, I'll take that one.\" People are attracted to you by your neatness.</p><p>The fourth lesson is Usefulness. Really it is quite wonderful the variety of uses to which this knife can be put. Here is a big blade, and a small blade; here is a blade with a file; folded in the back is a tiny pair of scissors. A tool's usefulness was Wright's final lesson. A person's worth, however, comes from being loved by God; service is a grateful response to that love, not the price of our value.</p>",
    "references": [
      "1 Corinthians 9:22"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 24,
    "title": "Letters",
    "content": "<p><strong>Read:</strong> 1 John 2:12</p><p>Who is the most popular man in your town? The Postman. Who is the man who is most eagerly looked for as he comes down the street? The Postman. Who receives, at every door where he stops, a most cordial welcome? The Postman. I wonder if the thrill of getting a letter will ever pass away. When you come home from school the first thing you do is to look on the hall table to see if the Postman has brought you a letter. It is the same when we grow up. No matter how many letters we may receive we never get over the keen delight at having the Postman bring us letters.</p><p>Last Sunday afternoon you wrote your grandmother. You said, \"Only two months more of school and then I am coming to see you, and all the summer vacation I am going to play around your big house, and in the barn, and across the fields, and through the woods.\" On your way to school Monday morning, you posted that letter. Monday afternoon you began looking for an answer. Tuesday you were impatient that you had not received a reply. Wednesday you were almost in tears, though, had you only stopped to think you would have known that it takes two days for a letter to get to your grandmother, she lives so far away. Thursday the answer came. \"I am eager for vacation time to come so that you, my dear grandchild, may be here with me.\"</p><p>I have here an unusual book. It is a book of letters. All the letters were written by a big man, a father, to little children, his children. The man who wrote them was Theodore Roosevelt. What fortunate children were his! Not many fathers take time to write to their children as did our great president. Oh, for more fathers like Roosevelt! Oh, for appreciative children, who will not only gladly receive, but cheerfully write, letters of love!</p>",
    "references": [
      "1 John 2:12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 25,
    "title": "A Unique Psalm",
    "content": "<p><strong>Read:</strong> Psalm 119:94</p><p><strong>Source-based editorial adaptation:</strong> Psalm 119 is the Bible's longest psalm. Its 176 verses form 22 sections based on the Hebrew alphabet, with eight verses in each section.</p><p>Again and again the psalm speaks of God's word, instruction, promises, and ways. Its prayer is more than a lesson in structure: the writer asks God for understanding and help to live faithfully.</p><p>Verse 94 says, “I am yours; save me.” Let that short prayer become your own as you read: I belong to you, God. Teach me and keep me in your way.</p>",
    "references": [
      "Psalm 119:94"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 26,
    "title": "The Father's Care",
    "content": "<p><strong>Read:</strong> Matthew 6:28-29</p><p>I have here a nut. It is a pecan. It grows in our southern states. It is a well formed nut with a hard shell. This nut I have is cracked. I open it and I notice just inside a thin, brown coating that covers the food. I touch this coating to my lips. It is bitter and causes me to pucker my lips. This is the Creator's blessed provision for the protection of the nut in its growing stage. The bitter coating keeps insects and pests away.</p><p>On my way to church this morning I looked up and saw a long piece of yarn flying across the street at a rapid rate. I wondered what could cause that. Then at the front end of the yarn I saw a bird. The bird flew to the gable of a big house. There, in a protected corner, she was making her nest. The yarn was to be woven into her new spring house. So God gives instinct to birds and all his creatures as a mark of his loving care.</p><p>The most delicate, sensitive portion of your body is the eye. When I consider how tender and open to harm the eye is I wonder that so many of us go through life with our eyes unhurt. But God has provided a sleepless protection for our eyes. There is a guard, always on duty. Whenever danger comes near, that guard, our eyelid, closes and effectively wards off impending trouble.</p><p><strong>Source-based editorial adaptation:</strong> The author moved from examples of protection in nature to God's care for people. Scripture teaches that every person is made in God's image and has lasting worth. God also gives us communities, wisdom, conscience, prayer, and other means of grace through which we can give and receive care.</p>",
    "references": [
      "Matthew 6:28-29"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 27,
    "title": "Yokes",
    "content": "<p><strong>Read:</strong> Matthew 11:29-30</p><p>A Yoke is a help, not a hindrance. Our first thought is that a yoke is burdensome. A little study reveals to us the great usefulness of the yoke.</p><p>Have you ever seen a yoke of oxen? What heavy, slow-moving creatures they are! But they are pullers of heavy loads. These loads could not be drawn by them were they not yoked together.</p><p>The author remembered seeing workers carry a load from a pole balanced across one person's shoulders or shared between two people. His example shows how equipment and cooperation can make a heavy task more manageable.</p><p><strong>Editorial context:</strong> Jesus uses a yoke as an invitation to learn from him. He is gentle and humble, and he promises rest to weary people. Following him still involves responsibility, but no one has to pretend to be self-sufficient; Christ meets us with grace and teaches us to share burdens.</p>",
    "references": [
      "Matthew 11:29-30"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 28,
    "title": "Good Advice",
    "content": "<p><strong>Read:</strong> Psalm 119:9</p><p>Most of us, men and women as well as girls and boys, do not take kindly to advice. We very much prefer that people keep their advice to themselves. There are times, however, when we are compelled to listen to advice, because of the source. Here is a bit of advice that commands our attention. It is from the great English novelist, Charles Dickens.</p><p>Charles Dickens' youngest boy, Edward, left home when he was sixteen years of age and went to Australia. His father wrote him a parting letter, which is worth while for all boys, whether or no they leave home. In that letter the great Dickens said,</p><p>\"I put a New Testament among your books for the very same reasons and with the very same hopes that made me write an easy account of it for you when you were a little child. Because it is the best book that ever was or ever will be in the world. And because it teaches you the best lessons by which any human creature who tries to be truthful and faithful to duty can possibly be guided. As your brothers have gone away, one by one, I have written to each such words as I am now writing to you and have asked them all to guide themselves by this book, putting aside the interpretations and inventions of men. Never abandon the wholesome practice of saying your own private prayers, night and morning. I have never abandoned it myself, and I know the comfort of it.\"</p><p>Now that we are done reading this letter it does not sound like advice at all, does it. It is all so wholesome and sturdy that we feel like speaking right out loud, \"Thank you, Mr. Dickens, thank you very much.\"</p>",
    "references": [
      "Psalm 119:9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 29,
    "title": "If I Were Young Again",
    "content": "<p><strong>Read:</strong> Psalm 103:1-5</p><p><strong>Source-based editorial adaptation:</strong> Educator William Rainey Harper left notes about what he would practice if he were young again: learn from wise lives, know the Bible, seek good companions, and study the life and character of Jesus.</p><p>Children and adults can practice those habits now. Read with care, ask honest questions, learn from trustworthy people, and let Jesus' love shape how you treat family, friends, and strangers.</p><p>Which one of these habits would help you grow this week? Choose a small step you can actually take.</p>",
    "references": [
      "Psalm 103:1-5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 30,
    "title": "One by One",
    "content": "<p><strong>Read:</strong> Matthew 6:34</p><p>Here is this great church building. It is a beautiful structure, is it not? It is so substantial, it has stood here so many years, we take it so for granted that it seems as though it had always been here. But there was a day when the ground upon which this building stands was vacant ground. Then men came with picks and shovels, wagons and plows, and set to work. They laid the foundations, stone upon stone. Then the walls rose, stone upon stone. Then the spire, stone upon stone, until the very peak was reached, for our church is stone from the foundation to the top of the spire. How were these thousands of stones put in place? One by one.</p><p>Think also of the roof of our church. It is a tile roof. How in the world did they get all those tiles up on the roof and fitted in place? Did some man who was very strong stand back and throw a handful of tile at the roof? No, it was done one by one.</p><p>Today it is snowing outside. Some one has figured that in a square mile one foot of snow would weigh 65,000 tons. If you should take sleds and horses, and put a ton of snow on each sled, and arrange the horses and sleds in a procession, the sleds carrying the snow from that square mile of territory would reach from Philadelphia to New York, and beyond New York, straight up the Hudson, almost to Albany. That is only one square mile, and there are thousands of square miles every winter covered with snow. How does this snow come? In tiny flakes, one by one.</p><p>It is the same with life. God gives us many days, but he sends them one at a time. He also sends us many duties, but they do not come en masse. He is good and sends them one by one.</p>",
    "references": [
      "Matthew 6:34"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 31,
    "title": "Christ's Welcome at Every Age",
    "content": "<p><strong>Read:</strong> Matthew 11:28</p><p><strong>Source-based editorial adaptation:</strong> Wright used a magnet and nails to picture Christ's invitation, “Come to me.” His illustration claimed that people become less able to answer God as they age. Jesus' welcome is wider than that claim.</p><p>Christ calls children, young people, adults, and older people. No history, habit, disability, or season of life makes someone too difficult for his mercy. We may answer today, and we may help others hear the invitation without pressure or shame.</p>",
    "references": [
      "Matthew 11:28"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 32,
    "title": "Love and Loyalty",
    "content": "<p><strong>Read:</strong> Ruth 1:16-17</p><p><strong>Source-based editorial adaptation:</strong> When famine and bereavement left Naomi and her daughters-in-law facing uncertain futures, Naomi chose to return to Judah. Ruth freely chose to remain with her: “Where you go, I will go ... your people will be my people, and your God my God.”</p><p>Ruth's promise expresses loyal love in a time of grief and migration. Loyalty does not require remaining in danger or accepting abuse. Healthy faithfulness seeks another person's good while honoring truth, safety, and freely given commitment.</p><p>Who may need steady companionship today? Consider one caring action that respects both their needs and their choices.</p>",
    "references": [
      "Ruth 1:16-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 33,
    "title": "Scripture in Every Language",
    "content": "<p><strong>Read:</strong> Luke 4:16</p><p><strong>Source-based editorial adaptation:</strong> Wright pointed to a long word printed in a colonial-era catechism and to John Eliot's translation work in the Massachusett language. His account used a slur and spoke as though Indigenous people had no written or intellectual traditions of their own; those claims are omitted here.</p><p>The history of colonial missions includes both Scripture translation and serious harm to Indigenous communities. Translation is faithful when it respects a community's language, knowledge, leadership, and freedom rather than treating culture as something to erase.</p><p>Jesus read Scripture in the language of his community. Give thanks for people who translate and teach with humility, and pray that every person can encounter God's word in a language they understand.</p>",
    "references": [
      "Luke 4:16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 34,
    "title": "What the Trees Said to Me",
    "content": "<p><strong>Read:</strong> Isaiah 61:3</p><p><strong>Source-based editorial adaptation:</strong> During a walk through a park, Wright imagined trees offering lessons. A tall pine suggested courage; an elm suggested courtesy and justice; a maple suggested steadfastness; and a birch suggested renewal.</p><p>Bodies stand, move, and communicate in many different ways, so faithful character cannot be measured by posture or appearance. The better questions are whether we act with justice, treat others with respect, keep hope through difficulty, and receive God's renewing grace.</p><p>What part of creation helps you remember God's care? Pause to notice it, then choose one quality of love to practice today.</p>",
    "references": [
      "Isaiah 61:3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 35,
    "title": "Banks",
    "content": "<p><strong>Read:</strong> Matthew 6:21</p><p>Here is a bank. I have been reading lately about banks. You know that in Jesus' day they did not have banks such as we have. People took their treasures and jewels and hid them in a vessel, or dug a hole in the earth and covered their valuable possessions with dirt. But now one of the most prominent institutions of any community is the bank.</p><p>What does this bank stand for? In the first place it means Strength. It is made of very heavy, hard material. There is money in this bank. It does not belong to me, it is the property of our Beginners' Department. Each Sunday they put their birthday money in here, then at the end of the year they open it and the contents is given to our Sunday School Missionary Society. That the money may be kept safe and sound to the end of the year the bank is made very strong.</p><p>In the second place I notice that there is a single opening and that the opening is made very small. It is meant for small coins, I could not possibly get a one dollar piece into this opening. No, it is meant for dimes, nickels and pennies. That is, it stands for Thrift. Each little child brings his or her amount, small in itself, but when they are all together there is a considerable sum.</p><p>Again, I see that this bank is made in the form of a church. It is really quite a beautiful building. Here is the steeple, here the steps and the wide entrance doors, and the windows with genuine cathedral glass. I think it is splendid to have a bank look like a church, for after all a church is a sort of bank. It stands for those treasures which Jesus talked about when he said, \"Lay up for yourselves treasures in heaven, where neither moth nor rust does corrupt, and where thieves do not break through and steal.\"</p>",
    "references": [
      "Matthew 6:21"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 36,
    "title": "Work, Rest, and Play",
    "content": "<p><strong>Read:</strong> Matthew 21:28</p><p><strong>Source-based editorial adaptation:</strong> Wright wanted children to see that work and play both belong in a healthy life. His original wording called a child “useless” and praised child labor; those claims are rejected here. A person's worth never depends on productivity.</p><p>Children need learning, safety, rest, play, and age-appropriate ways to contribute. Adults also need a humane balance. Work can serve neighbors and develop gifts, while Sabbath reminds us that God's love is received rather than earned.</p><p>What task is yours today, and what rest do you need? Ask God to help you do each at the right time.</p>",
    "references": [
      "Matthew 21:28"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 37,
    "title": "The Big Store",
    "content": "<p><strong>Read:</strong> Philippians 4:8</p><p>Many of the girls and boys who read this little book live in or near one of the great cities where they have huge department stores. I love to visit a big store. I have spent hours, more likely days, if I should count up all the time, in Wanamaker's in New York and Philadelphia, Marshall Field's in Chicago, Hengerer's in Buffalo, and Eaton's in Toronto. Any season of the year, and almost any hour of the day, these stores are thronged with people, for people like to go to the big store.</p><p>Now I am thinking of another big store, a truly big store, the great big store of Life. We have to visit at this store whether we want to or not. It is not a matter of choice but of necessity. Every morning you visit the big store of Life. Every evening you return home with what you have bought.</p><p>Not only must you visit this store but you must also buy. When you visit Wanamaker's you do not have to buy unless you choose. In the big store of Life, however, you have no choice in the matter, you must buy. What must you buy? Well, you may buy anything you choose. This is the beautiful thing about the big store of Life—while we are compelled to buy we are permitted to choose. We must also pay.</p><p>\"Good morning, John, what would you like to buy this morning.\"</p><p>\"I think I'll buy a good geography lesson.\"</p><p>\"All right, you can buy that, but you must pay the price.\"</p><p>\"What is the price?\"</p><p>\"Study, earnest study. Never leave the preparation until the last minute or trust to luck.\"</p><p>Yes, it is true, right on through every department in the big store of Life, you can buy whatever you choose, but you must pay the price.</p><p><strong>Editorial context:</strong> Effort matters in learning and daily responsibility. God's grace and our human worth are gifts; neither can be purchased by achievement.</p>",
    "references": [
      "Philippians 4:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 38,
    "title": "Bread",
    "content": "<p><strong>Read:</strong> John 6:51</p><p>I have here a loaf of bread. This is good-looking bread, is it not? I can almost hear you say, \"Please pass the bread.\" That is, I hope you say that. I hope you do not say, \"Gimme the bread.\"</p><p>Now every girl and boy here knows what it is to be hungry, I'm sure of that. And when one is real hungry there is nothing that tastes as good as bread. Of course there should be some butter, or jam, or peanut butter spread over the top—my, it makes the mouth water, doesn't it!</p><p>We speak of bread as the staff of life because we could not be strong in body if we did not have bread. We love ice cream and cake, food and potatoes, and many other things, but our meal is not properly balanced unless there is a plate of bread on the table.</p><p>Jesus taught us to pray, \"Give us this day our daily bread.\" I think this has a twofold meaning. It refers to our physical hunger and our spiritual needs. All bread comes from the Father above, our Father of love. Do you remember those beautiful lines,</p><p>Jesus once spoke of himself as the Bread sent down from above. Our Father gives us daily bread for our physical needs, and he has also sent us Christ for our spiritual strength. My dear young people, take him as your Saviour.</p>",
    "references": [
      "John 6:51"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 39,
    "title": "God's Measure",
    "content": "<p><strong>Read:</strong> Ephesians 4:13</p><p>Here I have some measures. This is a rule, we call it a folding foot rule. Here is a square. And here is a tape measure. There are other measures, quarts and pecks and bushels. Then there are liquid measures, quarts and gallons and barrels. There are also measures of weight, ounces, pounds and tons. Now these different measures are the same all over the United States. A pound of butter in New York is the same as a pound of butter in California. There are other countries that do not have measures like ours. France, for example, has the metric system. Should you go into a dry goods store in Paris you would not ask for a yard of cloth, but for a meter.</p><p>God's measures are the same. God has a measure for girls and boys, and that measure is the same in Ohio, Mexico, England or Spain. If it is wrong to steal in Germany, it is wrong to steal in Brazil. If it was wrong to commit murder in the first century, it is wrong to take life in this century. The Ten Commandments are some of God's measures for us.</p><p><strong>Editorial context:</strong> The author measured a child's height and then spoke of growth in Christ. Physical size, ability, achievement, and appearance do not measure spiritual worth. Ephesians pictures the whole community growing toward maturity in Christ through truth and love.</p>",
    "references": [
      "Ephesians 4:13"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 40,
    "title": "Sleep",
    "content": "<p><strong>Read:</strong> Psalm 127:2</p><p>I hope you had a good sleep last night. I hope you sleep well every night. God's best gift to his children is sleep. You think there are some better gifts, do you? Name them. Ah, I thought you were mistaken. The more you think about it the more you will agree with me that sleep, the Father's loving provision for tired people, is a most blessed gift.</p><p>Now God gives sleep not only to girls and boys but to all of his creatures. Do you know how some of those creatures sleep? I will tell you. Elephants and horses commonly sleep standing up. How would you like to hear your mother say to you, \"Robert, it's time to go to bed, stand in the corner there and sleep.\" Most birds sleep with the head turned toward the tail and the beak poked in under the feathers. Storks, gulls and all other long-legged birds sleep standing on one leg. It would be more difficult to sleep that way than just standing in the corner, wouldn't it? The fox and the wolf sleep with the tip of the nose and the soles of the feet close together, and the big, bushy tail covering all to keep them warm. Owls sleep in the daytime. They have eyelids, and over the eyelids, curtains. These curtains are drawn across the eyes, sideways, and keep out the strong light of the day. Hares, snakes and fish sleep with their eyes open.</p><p>Why does God give us sleep? Is it for the pleasure of sleeping? No. He gives us sleep that our bodies and minds may be refreshed. The strength we have expended during the day is repaid us in the sleep of the night. Be grateful to your heavenly Father when tonight you kneel to pray:</p><p>\"Now I lay me down to sleep.\"</p>",
    "references": [
      "Psalm 127:2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 41,
    "title": "On Time",
    "content": "<p><strong>Read:</strong> Ephesians 5:15-16</p><p><strong>Source-based editorial adaptation:</strong> Wright told of a public clock that ran fifteen minutes slow. Because many people relied on it, students arrived late, workers lost time, and travelers missed a train.</p><p>Our choices can affect other people, so attention and reliability are forms of care. Yet illness, disability, caregiving, unsafe travel, and other barriers can disrupt even careful plans. Responsibility should grow together with patience and practical help.</p><p>Ephesians urges us to use time wisely. What commitment needs your attention today, and whose circumstances call for understanding rather than a quick judgment?</p>",
    "references": [
      "Ephesians 5:15-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 42,
    "title": "Doors",
    "content": "<p><strong>Read:</strong> Revelation 3:20</p><p>This morning, after you were awake, you passed through your bedroom door. Then you went through the bathroom door. Later you entered, through a door, the dining room. After a time, with your father and mother, you left the house through the outside door. You walked down the street and here you are in church, having entered through yonder door. Every day you are passing through various doors. What wonderful things doors are! I wonder who invented doors. What would we do without doors?</p><p>There are doors to houses and there are doors to life. Let me tell you about them. A door is made of wood. What beautiful wood is in these church doors! The doors of life are made of our will. By the exercise of our will we open and close whatever doors of life we choose.</p><p>The doors of our houses swing on hinges. Heavy doors seem as light as a feather because they are so delicately hung upon hinges. The hinges of the doors of life are made not of brass or iron, but of love.</p><p>When, in a little while, you leave this church you will take hold of a knob and pull open the door. The doors of life have knobs. Those knobs are called courtesy. You can open well near any door you choose if only you will use the knob courtesy.</p><p><strong>Editorial context:</strong> Wright compared faith to a door's lock. Faith does not guarantee that trouble or injustice will never enter our lives. It opens us to Christ, who remains with us in danger and calls the church to truthful, practical care. Revelation 3:20 first addresses a complacent church, inviting it to hear Christ and renew fellowship with him.</p>",
    "references": [
      "Revelation 3:20"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 43,
    "title": "Cheapest and Best",
    "content": "<p><strong>Read:</strong> Isaiah 55:1</p><p><strong>Source-based editorial adaptation:</strong> Wright contrasted costly goods with essential gifts such as air, water, Scripture, worship, hope, prayer, and love. His prices and claim that water costs nothing reflect his setting; many neighbors still lack safe water or affordable access to basic needs.</p><p>Isaiah invites thirsty people to receive God's provision without money. The invitation points to grace that cannot be bought. Because God's gifts are received, Christians are also called to share material necessities and remove barriers that keep others from them.</p><p>Where have you treated grace as something to earn? Receive God's generosity, then consider one gift—time, food, water, attention, or money—you can share without demanding a return.</p>",
    "references": [
      "Isaiah 55:1"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 44,
    "title": "In the Dark",
    "content": "<p><strong>Read:</strong> Psalm 139:12</p><p>I have here what are commonly known as Chinese lilies. Two weeks ago they were only two or three inches high. Now they are between two and three feet. How rapidly they have grown! How can we account for it? I can give one reason. It is because they had adequate preparation. The bulbs from which these lilies grew were kept in the dark for ten days. There, in the dark, they stored up strength and energy for the work that was before them.</p><p>Many years of our Saviour's life were spent in obscurity. They were years when, as far as the world is concerned, he was in the dark, preparing for the great work of his public ministry. My dear young people, do not be fretful over the days and years you have to go to school. They are not simply days of waiting, they are days of preparation.</p><p><strong>Editorial context:</strong> The lilies grew from an ordinary dish of stones. Wright compared that hidden growth with Jesus' quiet years before his public ministry. Difficult or unnoticed seasons do not prove that God has abandoned us, and poverty is not a spiritual defect. God meets people in every kind of home and calls communities to share what their neighbors need.</p><p>Faith, hope, love, patience, courage, and truth can grow in hidden seasons. Ask God for the support you need, and look for a practical way to stand with someone whose path is hard.</p>",
    "references": [
      "Psalm 139:12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 45,
    "title": "The Still Small Voice",
    "content": "<p><strong>Read:</strong> 1 Kings 19:12</p><p>What is the loudest noise you ever heard? Did you ever hear an immense cannon fired? Of course you have heard thunder. The loudest, most terrifying noise I ever heard was a boiler explosion. The town heating plant was only three doors from my home. The whole plant blew up one prayer meeting evening. The church building was plunged into darkness, the walls shook, windows were broken on every side. In terror people got down on their knees and crept toward the door. That was the loudest noise I ever heard.</p><p>Now I have here a hammer. I will drop it to the floor. Listen. Is the noise very loud? Here I have a heavy railroad spike. Hear the noise this makes as it is dropped. And now I shall drop this large nail. The noise that made is not nearly as loud as the noise occasioned by the falling hammer. Here is a small nail. You will have to listen very carefully if you hear the sound of the nail as it strikes the carpet. Have you good ears? Let us test them. Here is an ordinary pin. If you keep very quiet you will be able to hear the falling of this tiny pin. Do not move in your seat. Every one, attention! Listen. Did you hear it? Yes, most of you did.</p><p><strong>Editorial context:</strong> The quiet prompting we call conscience deserves attention, but an inner feeling is not automatically God's voice. Test it by Scripture's witness to Jesus, by love of God and neighbor, and by the counsel of wise, trustworthy people. God's Spirit does not lead us toward cruelty, deceit, or abuse.</p>",
    "references": [
      "1 Kings 19:12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 46,
    "title": "Thanksgiving",
    "content": "<p><strong>Read:</strong> Psalm 150:6</p><p>What does Thanksgiving mean to you? I hear one boy say, \"It means a big dinner.\" I think we all agree with him. Who does not welcome and enjoy a good dinner! I hear Mary say, \"Thanksgiving means a day off from school.\" I guess you are right too. School is not such a charming place that girls and boys are unwilling to have an occasional holiday.</p><p>Now I am going to ask some of the older people what the day means to them. There is a young woman. She is a stenographer. She says, \"Thanksgiving means a day away from the office. I am at the office every day except Sunday, and I do appreciate, now and then, a day that is really my own.\" Yonder is a traveling salesman. What does Thanksgiving mean to you? He says, \"It means a day at home. Last year I spent one hundred and sixty-nine nights away from home. I have three children. I should like to see them every day. There are times when many days pass and I do not see them. Thanksgiving week I plan to be at home.\"</p><p>There are others I could ask. Each has his answer. But Thanksgiving has a special meaning for us. It is the Harvest time. I have here an apple. Isn't this a beautiful apple? What color! Who mixed the paints, who handled the brush to give such color to this apple? God. He, in his infinite love and wisdom, has provided, through the unfailing laws of nature, for the growth, sweetness, coloring and beautifying of all the products of the fields. This apple is but one of many kinds of fruits.</p><p>Praise, then, is the great meaning of Thanksgiving. God, our heavenly Father, sends us every good gift. From his bountiful hand come our daily and nightly mercies. We should praise him every day. But the day for the united chorus of praise is Thanksgiving.</p>",
    "references": [
      "Psalm 150:6"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 47,
    "title": "Marbles in the Pocket",
    "content": "<p><strong>Read:</strong> Matthew 7:12</p><p>Do you know what a Missionary Box is? Well, I will tell you. It is a box or barrel sent from a missionary society in a city or town to a missionary family or school on the frontier. The box contains clothing, bedding, and sometimes toys, dolls and picture books if there are children at the frontier end of the journey.</p><p>In a certain city one Christmas season the children of the Sunday School brought gifts to fill a box. Some brought clothes they had outgrown. Some who had two coats decided they could give one. Others brought books. One little girl brought a beautiful doll. She had other dolls, and this one she dearly loved, but she said, \"I want some other little girl to be happy, and I think I can get along without this doll, though I shall miss her dreadfully.\"</p><p>One day the committee came together to sort the gifts and pack the box. One woman picked up a boy's coat. She felt something, hard in one of the pockets. Another woman said, \"Better look all through those pockets; you can never tell what a boy will use his pockets for.\" So she went all through the pockets. In one of them she found a soiled handkerchief tied in a knot. With much pulling, for it was a hard knot, she loosed the little package, and there she found five marbles. With the marbles was a note scrawled in a boy's hand—</p><p>\"DEAR BOY WHO GETS THIS COAT,</p><p>I have eight marbles. First I put in four for you. Then I put in another one. I hope you will like the coat, and the marbles.</p><p>From your friend,</p><p>JOHN MASON.\"</p><p>Now what do you think of that? Isn't it glorious? To give more to the other fellow than you keep for yourself, especially when that other fellow is some one you have never seen, is Christlike.</p>",
    "references": [
      "Matthew 7:12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 48,
    "title": "The First Month",
    "content": "<p><strong>Read:</strong> Luke 2:8-12</p><p>What month is this? December. It is the first month in the year. \"No, no,\" you say, \"December is the last month.\" I cannot entirely agree with you. December is last on the calendar but first in importance. Now you agree with me, do you not?</p><p>How many days has December? One day. \"No, no,\" I again hear you say, \"December has thirty-one days.\" I think we can reach an agreement on this point too. There is one day in December of unexcelled importance and loveliness; that day is the twenty-fifth. Yes, we all say there is but one day in December. How readily we agree when we understand one another!</p><p><strong>Editorial context:</strong> Christians celebrate Jesus' birth on December 25, although Scripture does not give the calendar date. The celebration points to the Son of God sharing our humanity as a baby, growing through childhood into adulthood, and coming as Savior.</p><p>Luke says the good news was first announced to shepherds keeping watch at night. Their ordinary work became the setting for a message of joy for all people. God's welcome is not reserved for wealth, rank, or public importance.</p>",
    "references": [
      "Luke 2:8-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 49,
    "title": "Him and Hymn",
    "content": "<p><strong>Read:</strong> Matthew 2:6</p><p>I want to tell you today about two \"Hims.\" The first is a man \"Him.\" The second is a song \"Hymn.\"</p><p>The man \"him\" is Phillips Brooks. He was born in 1835 and died in 1893. He never married, so he had no girls and boys of his own. But he loved all children. He had a great, warm heart, and in that heart was a big corner for all young people. He became a minister. His first church was in Philadelphia. Later he moved to Boston. He had not been in Boston very long when, one night, about midnight, the people saw flames breaking out through the roof of the church. A sorrowing congregation, with their pastor, watched their loved church as it burned to the ground.</p><p>When, after the fire, they came together, they inquired, \"What shall we do? Shall we rebuild here or shall we take another location?\" Finally it was decided to build a new church on Copley Square. That was many years ago. They built a beautiful temple of worship. It is still known everywhere as \"Phillips Brooks' Church,\" so wonderfully did his personality enter into the project.</p><p>Now the second \"hymn.\" When Phillips Brooks was a young man in Philadelphia he made a trip to the Holy Land. As Christmas drew near he wrote and sent back to the girls and boys of his Sunday School, a Christmas poem. The organist of his church composed music for the words, and this hymn was sung for the first time in Trinity church, Philadelphia. It is a beautiful Christmas hymn. Yes, it is my favorite.</p><p>\"Oh, little town of Bethlehem, How still we see you lie.\"</p>",
    "references": [
      "Matthew 2:6"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 50,
    "title": "The Christmas Tree",
    "content": "<p><strong>Read:</strong> John 3:16</p><p>For a few years I lived in a country where \"December is as pleasant as May.\" The weather was warm all through the year. The ground was never frozen, for there was never any frost. I never saw a snowflake in all the years I lived in the tropics. The trees were trees of the hot climate, mostly palm, bamboo and acacia trees. When Christmas drew near I thought the day would be a very dreary day, and wholly unChristmaslike because there would be no snow, and we would be without our accustomed tree.</p><p>A few days before our first Christmas in the tropics a friend said to me, \"I am sending a tree down from the mountains for your children.\" In due time the tree arrived. You can imagine the joy of our entire household when they looked upon a genuine, evergreen, Christmas tree. We set it up in our big \"sala,\" that is our living room, and there it remained for many days, the delight of our eyes.</p><p>The tree of the Christmas season has some specifically Christmas messages. First, it is evergreen. That reminds us of the eternal Saviour, \"the same yesterday, today and forever.\" At the very tiptop of the tree we place a star. There it shines, high above all else, reminding us of the higher, holier life to which we are summoned. The star beckons us to loftier aspirations. Christ came down from heaven. He became one of us, sharing our human life. But he is ever above us as well as with us, luring us on to the life of God. The Christmas tree is ablaze with lights. Jesus brought light into the world. How dark the world would be without him! About the base of the tree, and suspended from the branches are many gifts. They are tokens of the love and esteem we hold for each other, and remind us of God's great gift of love, Christ himself.</p>",
    "references": [
      "John 3:16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 51,
    "title": "The Best Word",
    "content": "<p><strong>Read:</strong> John 1:4</p><p>What is the best word! I think I can hear each of you as he answers. One says \"Mother is the best word.\" Another says, \"Father.\" Still another, \"Daddy.\" A fourth one answers, \"Home.\" Now I hear a voice that says, \"America.\" Another voice shouts, \"Friend.\" Yes, there are many, many words to which we might rightfully give the title \"best word.\"</p><p>But for this season of the year, and for this particular Sunday, there is one word that stands out from among all the others. That one word is \"Christmas.\" Tomorrow will be Christmas day. I think this word \"Christmas\" is the best word because it includes all the other good words.</p><p>In your home you have a rug. There are many colors in that rug, yet it is all one fabric. The many colors are skillfully woven and beautifully blended to make the one fabric. Think of this word Christmas as a rug, made up of many words of many colors. We see in this rug the names of people who care for us: family, friends, neighbors, and a community that can become a home. Then clearest of all in this wonderful rug is the word Christ. Christ is Christmas. Yes, Christmas is the best word for it gathers within its meaning all other good words.</p><p>\"This happy day, whose risen sun Shall set not through eternity; This holy day, when Christ, the Lord, Took on him our humanity; For little children everywhere A joyous season still we make; We bring our precious gifts to them, Even for the dear Child, Jesus' sake.\"</p>",
    "references": [
      "John 1:4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000309",
    "day_number": 52,
    "title": "Last but Not Least",
    "content": "<p><strong>Read:</strong> Mark 10:31</p><p>How often have we heard this phrase! You girls and boys use it, \"Here I am, last but not least.\"</p><p>When Jesus was on earth there was often a discussion among the disciples concerning rank among them. Some were fearful that they would be last. One day the mother of two disciples asked Jesus to grant permission that her two sons might sit, the one on his left hand, the other on his right, in the kingdom. Then He made a very beautiful as well as perfectly true statement, \"Whoever will be chief among you, let him be your servant; even as the Son of man came not to be ministered to, but to minister, and to give his life a ransom for many.\"</p><p>There was another time, when Jesus sat at supper with his disciples, wishing to show them, by example, the utter worthlessness of station, for station's sake, rose from the table, took a towel and basin, and began to wash the disciples' feet. Peter objected, but when he understood, he said, \"Not my feet only, but also my hands and my head.\" At the last Jesus said, \"Truly I say to you, the servant is not greater than his Lord; neither he that is sent greater than he that sent him.\"</p><p>Girls and boys, if you desire a high place in life, begin low. If you want to occupy a leading place you must be willing to serve in the least. It always has been so, it will never change, this great law of life, that he who would be first must be willing to be last. It is the eternal law of service.</p>",
    "references": [
      "Mark 10:31"
    ]
  }
]
$adapt_new_days$::jsonb) loop
    insert into public.devotional_days (plan_id, day_number, title, content, created_at, updated_at)
    values ((item ->> 'id')::uuid, (item ->> 'day_number')::integer,
            item ->> 'title', item ->> 'content', timestamptz '2026-10-23 13:00:00+00', timestamptz '2026-10-23 13:00:00+00')
    on conflict (plan_id, day_number) do update
      set title = excluded.title, content = excluded.content, updated_at = excluded.updated_at
    returning id into target_day_id;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-23 13:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-23 13:00:00+00', timestamptz '2026-10-23 13:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish four reconstructed and source-checked devotional adaptations.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-23 13:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000309'::uuid,
  '90000000-0000-0000-0000-000000000384'::uuid,
  '90000000-0000-0000-0000-000000000390'::uuid,
  '90000000-0000-0000-0000-000000000394'::uuid
);
