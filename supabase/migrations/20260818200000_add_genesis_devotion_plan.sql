-- Add a public devotional plan for the book of Genesis (NIV).
-- The NIV divides Genesis into sections; each section becomes one plan day
-- with a short 5-10 minute devotional, and the section reference is stored as
-- the day passage (public.scripture_references).
-- Follows the existing seeding migrations, e.g.
-- 20260529120000_add_100_public_domain_devotional_plans.sql. Idempotent upsert.

do $$
declare
  v_now constant timestamptz := timestamptz '2026-08-18 20:00:00+00';
  v_plan jsonb;
  v_day jsonb;
  v_plan_id uuid;
  v_day_id uuid;
begin
  for v_plan in
    select value
    from jsonb_array_elements($plans$
[
  {
    "id": "93000000-0000-0000-0000-0000000000c7",
    "title": "Genesis: In the Beginning - Foundations of Faith",
    "description": "A walk through the book of Genesis following the NIV outline, one passage at a time. For every major section of Genesis there is one devotional reading plus the section reference as the day passage, shaped for a 5-10 minute quiet time.",
    "total_days": 68,
    "tags": [
      "faith",
      "covenants",
      "wisdom",
      "family",
      "reading"
    ],
    "cover_image": "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80",
    "days": [
      {
        "day_number": 1,
        "title": "Day 1 - The Beginning (Genesis 1:1-2:3)",
        "content": "<p>The Bible opens with a simple, stunning declaration: God is the beginning. Before there was time or matter, before the sun or the sea, God was. Out of nothing He spoke, and things that had never existed came to be. In the rhythm of evenings and mornings we watch a God of order, purpose and delight, pausing over each work and calling it good. He is not a distant force but a personal Creator who shapes chaos into beauty with a word.</p><p>Notice that the crown of creation is not a place but a person. On day six God forms the man in His own image, blessing him and giving him vocation and relationship. Everything earlier builds toward this: a God who makes us to know Him and to reflect Him.</p><p>Take a moment today to revel in your createdness. You are not an accident of chance but a deliberate, beloved image-bearer. Receive again that good word over your life, and let the One who called light out of darkness speak order into whatever feels formless in you.</p>",
        "references": [
          "Genesis 1:1-2:3"
        ]
      },
      {
        "day_number": 2,
        "title": "Day 2 - Adam and Eve (Genesis 2:4-25)",
        "content": "<p>Genesis zooms in on the garden, a sanctuary where God walks with man. Here we see intimacy: God forming Adam from the dust, breathing life into his nostrils, providing a garden of delight, and giving him fruitful work. But the deepest gift is presence. It is not good for the man to be alone, and so God, in exquisite kindness, shapes a companion. Adam and Eve stand before each other, unashamed and whole.</p><p>In Eden, rest and responsibility go together. Work is not a curse but a calling, and marriage is presented as a bond of belonging - leaving, cleaving, becoming one. Relationships are God's design, not an afterthought.</p><p>God still longs to be near His children. Like Adam, you were made for communion - with God and with others. Do not hide your need. Let yourself be known, receive the gift of companionship, and tend the garden He has entrusted to you with diligence and delight.</p>",
        "references": [
          "Genesis 2:4-25"
        ]
      },
      {
        "day_number": 3,
        "title": "Day 3 - The Fall (Genesis 3:1-24)",
        "content": "<p>The serpent casts doubt on God's goodness: Did God really say? The first attack on humanity is not against God's existence but against His character. Eve trades the fullness of grace for the deceptive promise that she could become like God, knowing good and evil. In a single choice, mistrust enters, shame follows, and the peace of Eden shatters. Adam and Eve hide from the One who made them and loved them.</p><p>Yet even in judgment God is merciful. He does not abandon them. He clothes their nakedness and, amid the curse, speaks a promise of a coming offspring who will crush the serpent's head. Grace is already glimmering in the field of thorns.</p><p>We still hear that ancient whisper when temptation arises: doubt God, distrust His word, take control. But we do not have to find our own way back; God comes looking for us. When shame tempts you to hide, run to Him instead. His mercy is greater than the fall.</p>",
        "references": [
          "Genesis 3:1-24"
        ]
      },
{
        "day_number": 4,
        "title": "Day 4 - Cain and Abel (Genesis 4:1-16)",
        "content": "<p>Two brothers bring offerings to the Lord. Abel's gift is accepted; Cain's is not. The difference is not the value of the gift but the condition of the heart. God speaks directly to Cain: Why are you angry? Do what is right and you will be accepted. But sin, crouching at the door, masters him, and jealousy spirals into the first murder.</p><p>The story confronts us with an uncomfortable truth: what begins as wounded pride can, if unguarded, harden into something far darker. God's question to Cain echoes through the ages - Where is your brother? We are our brother's keeper, whether we like it or not.</p><p>When your offering, your role, or your reward is not what you expected, watch your heart. Sin will always be crouching at the door. Rather than feeding resentment, bring your raw disappointment to God, who speaks to you as He spoke to Cain - with patience, with warning, and still with the offer of a way.</p>",
        "references": [
          "Genesis 4:1-16"
        ]
      },
      {
        "day_number": 5,
        "title": "Day 5 - Cain's Descendants (Genesis 4:17-26)",
        "content": "<p>After the tragedy of Cain comes a surprising turn: God's mercy continues. Cain, marked and wandering, still builds a city and fathers a line of innovators - those who work in bronze and iron, who raise livestock, who make music. Even a broken family carries the image of a creative God. Yet alongside this flourishing we meet Lamech, whose vengeance far exceeds the harm done to him, showing how sin multiplies when left unchecked.</p><p>In stark contrast, Adam and Eve have another son, Seth, and Scripture notes that in his time people began to call on the name of the Lord. Alongside the proud line of human achievement runs a humble line of worship. Two ways of living are already emerging: one built on human glory and escalating violence, the other on calling on God.</p><p>Which city are you building? Talent and culture are gifts of God, but they can never substitute for Him. Whatever you are good at, let it be wrapped in the posture that marked Seth's descendants - calling on the name of the Lord.</p>",
        "references": [
          "Genesis 4:17-26"
        ]
      },
      {
        "day_number": 6,
        "title": "Day 6 - From Adam to Noah (Genesis 5:1-32)",
        "content": "<p>Chapter five unfolds as a long roll call of generations - a list of names, ages, and the repeated phrase and then he died. Beneath the repetition we glimpse a profound truth: Adam's line is marked by both the image of God and the taint of death. Each generation receives a father's name, yet death seems to win every time.</p><p>But the genealogy is not hopeless. Tucked among the names is Enoch, who walked faithfully with God and was taken without tasting death. One man chose a different path, and eternity bent toward him. The list also leads somewhere: to Noah, whose birth points toward comfort and rest. God is at work through ordinary, faithful people across generations to prepare a rescue.</p><p>Your years matter to Him. You may feel like one small name in a long line, but every link matters in God's story. Walk with God today - steadily, faithfully - and let the cadence of your life testify that death does not have the final word.</p>",
        "references": [
          "Genesis 5:1-32"
        ]
      },
{
        "day_number": 7,
        "title": "Day 7 - Wickedness in the World (Genesis 6:1-8)",
        "content": "<p>The population grows, and with it wickedness. Scripture paints a grim picture: every inclination of the human heart was only evil all the time. God's heart is filled with grief over His creation. The God of Genesis is not indifferent; He grieves. Judgment is not His delight but His sorrowful response to entrenched evil.</p><p>Yet in the very same passage, grace appears like a seam of gold: But Noah found favor in the eyes of the Lord. Even when a generation is drowning in darkness, God sees the one who walks with Him. The word behind favor echoes the idea of grace - something undeserved and freely given.</p><p>Perhaps you grieve the state of your world, or feel surrounded by compromise. Remember that God was not looking for a crowd in Noah's day; He was looking for one faithful heart. Noah did not change the whole world, but he and his household walked with God. Be that person in your own circle - receiving God's grace and lending your life to His purposes rather than the tide of the times.</p>",
        "references": [
          "Genesis 6:1-8"
        ]
      },
      {
        "day_number": 8,
        "title": "Day 8 - Noah and the Flood (Genesis 6:9-8:22)",
        "content": "<p>Noah was righteous and blameless among his people, and he walked faithfully with God. When God revealed the coming flood, Noah's response was not debate but obedience - he did everything just as God commanded. Building an ark on dry land for decades must have looked foolish to the world, yet it meant life for his whole household.</p><p>The flood is both judgment on evil and rescue for a remnant. The same waters that washed away corruption carried Noah to a new beginning. When the waters recede and the dove returns with an olive leaf, Noah worships. Deliverance is met with gratitude.</p><p>The flood reminds us that God both weighs evil and preserves the faithful. Step into whatever impossible task He has set before you, believing it may one day mean life for your household. And when the storm passes, be like Noah: build an altar, and give thanks to the God who remembered you.</p>",
        "references": [
          "Genesis 6:9-8:22"
        ]
      },
      {
        "day_number": 9,
        "title": "Day 9 - God's Covenant With Noah (Genesis 9:1-17)",
        "content": "<p>After the waters, God never simply starts over; He makes promises. He reaffirms His blessing on humanity and then, for the first time, the word covenant appears with Israel's God as He binds Himself to a lasting commitment. He sets the rainbow in the clouds as the sign: never again will a flood destroy the earth.</p><p>This is remarkable. The same God who judged drowns the world in grace. The rainbow, placed across the sky after storm, is a visible reminder that judgment will not be the final word. God's mercy holds back what His holiness could unleash.</p><p>Your own story may have its floodwaters - failures, fears, seasons of upheaval. Look for the rainbow. God is a covenant-making God who keeps His word. When you are tempted to think His anger outlasts His love, remember the bow in the clouds. He is not out to destroy you; He is committed to you.</p>",
        "references": [
          "Genesis 9:1-17"
        ]
      },
{
        "day_number": 10,
        "title": "Day 10 - The Sons of Noah (Genesis 9:18-29)",
        "content": "<p>The chapter turns from covenant to character. After his deliverance, Noah plants a vineyard and, in a moment of weakness, becomes drunk and uncovered. Ham sees his father's shame but does not honor him, while Shem and Japheth walk backward with a garment to cover their father. The scene is strikingly human - even the hero of the flood stumbles.</p><p>What follows is not a vindictive curse but a glimpse of how our choices ripple outward. Ham's disrespect becomes a defining memory, while Shem is honored as the line through whom blessing would continue. The response of the two brothers shows us what love does in the presence of another's shame: it covers rather than exposes.</p><p>When others stumble, how do you respond? The instinct of the world is to look, to broadcast, to feel superior. Love, by contrast, walks backward and covers. Guard your own heart against the pride of the early days of faith, and be the kind of person who protects the dignity of others even when they have fallen.</p>",
        "references": [
          "Genesis 9:18-29"
        ]
      },
      {
        "day_number": 11,
        "title": "Day 11 - The Table of Nations (Genesis 10:1-32)",
        "content": "<p>Here Scripture widens its lens to take in the whole earth. The families of Shem, Ham and Japheth spread out, each with its language, clan and territory. This genealogy is not a tedious list but a map of divine generosity - humanity scattering and filling the earth as God promised, diverse yet one family.</p><p>The mention of particular individuals, like Nimrod the mighty hunter and builder of cities, reminds us that the biblical story is history, not myth. Behind every name stands a real people shaped by real events, and within the global story runs a single thread that will narrow, surprisingly, to one man and one family.</p><p>Before you dismiss the long list, notice that God sees every nation and every name. No people are beyond His reach or beneath His care. You are part of a vast human family that God is gathering. The same God who scattered these peoples is the God who knows you by name and is working history toward a great reunion.</p>",
        "references": [
          "Genesis 10:1-32"
        ]
      },
      {
        "day_number": 12,
        "title": "Day 12 - The Tower of Babel (Genesis 11:1-9)",
        "content": "<p>Humanity, united in language, decides to build a city and a tower whose top reaches the heavens, determined to make a name for themselves and so avoid being scattered. On the surface it is impressive; underneath it is rebellion. Their aim is not to glorify God but to be self-sufficient, to live as if they need nothing from above.</p><p>God sees the ambition and confuses their language, scattering them across the earth. What looked like a plan for glory becomes division. Babel teaches us that our grandest efforts to be our own savior will always fragment. Pride builds towers; humility builds altars.</p><p>Where is your own tower? It may be a reputation, a security plan, a career, or a relationship organized entirely around yourself. God compassionately interrupts our self-building because He loves us too much to let us live without Him. Release your need to make a name for yourself, and let God be your name, your honor, and your true foundation.</p>",
        "references": [
          "Genesis 11:1-9"
        ]
      },
{
        "day_number": 13,
        "title": "Day 13 - From Shem to Abram (Genesis 11:10-26)",
        "content": "<p>After Babel, the story narrows once more. We follow the line of Shem generation by generation until we reach a man named Terah, and out of his household comes Abram. The names and ages may blur together, but they carry the quiet weight of promise: God has not abandoned His plan. In one ordinary family line, He is preparing a man through whom all nations will be blessed.</p><p>This genealogy reminds us that God works through the unremarkable, patient accumulation of years. There are no dramatic chapters here, only faithful continuance. The God who spans all of history works inside the slow, daily progress of an ordinary family.</p><p>Do not despise the small, seemingly ordinary parts of your story. The years that feel like waiting or repetition may be exactly where God is preparing you for something generations later. Trust His timing. The line from Shem to Abram teaches us that God is never in a hurry and never forgets a promise.</p>",
        "references": [
          "Genesis 11:10-26"
        ]
      },
      {
        "day_number": 14,
        "title": "Day 14 - Abram's Family (Genesis 11:27-32)",
        "content": "<p>We meet Abram in the city of Ur, embedded in a family that carries both promise and pain. Sarai is barren, a grief that shadows the household. Terah sets out with his family toward the land of Canaan but settles in Harran. The journey toward the promise begins tentatively, haltingly, and the story ends this section with a simple, sober notice: Terah died in Harran.</p><p>This is honest realism. God's redemptive plan advances through people who are old, who are childless, whose father dies halfway to the destination. Faithfulness does not require a flawless start; it requires a God who keeps moving His people forward even when they stop short.</p><p>Your own pilgrimage may have detours and unfinished chapters. A dream may seem stalled in Harran, a barrenness may persist. Take heart - Abram's story does not end in Harran, and neither does yours. God is not finished with the family He has called. He will get you the rest of the way.</p>",
        "references": [
          "Genesis 11:27-32"
        ]
      },
      {
        "day_number": 15,
        "title": "Day 15 - The Call of Abram (Genesis 12:1-9)",
        "content": "<p>God speaks to Abram and makes a breathtaking promise: leave your country, your people and your father's household, and I will make you into a great nation. I will bless you and make your name great, and all peoples on earth will be blessed through you. Without a map or a guarantee, Abram goes, and the covenant that will shape all history begins with a single act of obedient leaving.</p><p>Notice the posture of it all. Abram builds altars at the places the Lord appears, calling on His name. Blessing is not only received but passed on; the point of God's favor is that through Abraham all the families of the earth would be blessed.</p><p>What is God asking you to leave today - a comfort, a reputation, a familiar place - in order to follow Him? Faith rarely begins with a full picture; it begins with a step. And when you step, build an altar. Remember where God met you, and live as a channel of His blessing to the people around you.</p>",
        "references": [
          "Genesis 12:1-9"
        ]
      },
{
        "day_number": 16,
        "title": "Day 16 - Abram in Egypt (Genesis 12:10-20)",
        "content": "<p>Hard on the heels of his great step of faith, a famine drives Abram to Egypt. Fearing for his life, he asks Sarai to claim she is his sister, and the half-truth unravels. Pharaoh takes her into his household, and only when God intervenes with plagues is the deception exposed. Abram is confronted, humiliated, and sent away.</p><p>The passage is disturbingly honest about the life of faith. The same man who left everything to follow God is here unraveled by fear. Prominent in the story is not Abram's heroism but God's protection. Even through his failure, God guards His promise. Faith does not mean never faltering; it means that God is faithful when we are not.</p><p>You may have a famine season coming - a crisis that tempts you to grasp, to scheme, to protect your own name. In such moments honesty with God and with others is the way back. Let this passage free you from the guilt of past lapses and teach you to trust God's protection rather than your own maneuvering.</p>",
        "references": [
          "Genesis 12:10-20"
        ]
      },
      {
        "day_number": 17,
        "title": "Day 17 - Abram and Lot Separate (Genesis 13:1-18)",
        "content": "<p>Back in the land, Abram and his nephew Lot find their herds so numerous that the land cannot support them both. Rather than fight, Abram, the elder and the one holding the promise, offers Lot first choice. Lot looks at the well-watered plain toward Sodom and takes it, leaving Abram the less promising high country.</p><p>Here we see the quiet strength of humility. Abram does not insist on his rights or leverage his seniority. He trusts that God is his portion and that blessing does not depend on the most fertile-looking plot of ground. His eyes are on the promise, not the pasture.</p><p>Lot chose by appearance; Abram chose by faith. When you face a decision between the visibly attractive and the faithfully right, remember who cares for you. You can afford to defer, to release advantage, to let God choose your portion - because if God is your shield and reward, no poor-looking choice can rob you.</p>",
        "references": [
          "Genesis 13:1-18"
        ]
      },
      {
        "day_number": 18,
        "title": "Day 18 - Abram Rescues Lot (Genesis 14:1-24)",
        "content": "<p>A coalition of kings sweeps through the region, and Lot, now living near Sodom, is carried off with his goods. When word reaches Abram, he does not hesitate even though he owes Lot nothing. He musters his trained men, pursues the captors, and recovers Lot, the people and the plunder. Faith is not merely contemplative; it is willing to get its hands dirty for others.</p><p>On his return, Abram meets Melchizedek, king of Salem and priest of God Most High, who blesses him and to whom Abram gives a tenth. In the same scene the king of Sodom offers wealth, but Abram refuses it, determined that no man should say he made Abram rich. He will be dependent on God alone.</p><p>Abram models both mercy and integrity: he risks himself for a relative who had chosen badly, and he protects the purity of his testimony. Ask yourself where you are called to fight for someone who cannot fight for themselves, and where you must refuse a bargain that would dilute your dependence on God.</p>",
        "references": [
          "Genesis 14:1-24"
        ]
      },
{
        "day_number": 19,
        "title": "Day 19 - God's Covenant With Abram (Genesis 15:1-21)",
        "content": "<p>God speaks to Abram in a vision: Do not be afraid, Abram. I am your shield, your very great reward. Yet Abram voices the ache at the center of his life: You have given me no children. What can you give me? Into this wound of delay God speaks the breathtaking promise of descendants as numerous as the stars, and Abram believes the Lord, and it is credited to him as righteousness.</p><p>Faith here is not a feeling but a settled trust in God's word. The covenant is then sealed through a deeply solemn ritual, and as Abram falls into a deep sleep, God walks between the pieces alone. The covenant rests not on Abram's capacity but on God's own commitment. God takes the promise upon Himself.</p><p>When His timeline outpaces yours, bring the honest ache of your heart to Him as Abram did. And remember whose covenant this is: God bound Himself to you before you could keep your side. Believe Him, and let that belief be counted righteous - resting not in your performance but in His faithfulness.</p>",
        "references": [
          "Genesis 15:1-21"
        ]
      },
      {
        "day_number": 20,
        "title": "Day 20 - Hagar and Ishmael (Genesis 16:1-16)",
        "content": "<p>Sarai, still childless and years past hope, takes matters into her own hands. She gives her servant Hagar to Abram as a wife, and Hagar conceives. Pride and pain collide: Sarai despises Hagar, Hagar despises her mistress, and Hagar flees into the desert. Human schemes to hurry God's promise produce heartbreak.</p><p>But the desert is not the end. There the Angel of the Lord meets Hagar, calls her by name, and gives her a promise for her son Ishmael. He sees her. Hagar names the place with wonder: You are the God who sees me. The God of Abraham is also the God of the overlooked and the outcast.</p><p>When you take control of your life because God seems slow, you may reap complications, as Sarai did. Yet even our messes are not beyond His reach. If you feel unseen and pushed out, remember Hagar. There is a God who sees you, calls you by name, and promises to be present even in your heartbreak.</p>",
        "references": [
          "Genesis 16:1-16"
        ]
      },
      {
        "day_number": 21,
        "title": "Day 21 - The Covenant of Circumcision (Genesis 17:1-27)",
        "content": "<p>Thirteen years pass. Now God appears again: I am God Almighty; walk before me faithfully and be blameless. He renames Abram as Abraham - father of many nations - and Sarai as Sarah. The covenant is set in the flesh of the household through circumcision, an unmistakable sign that this people belongs to God.</p><p>Abraham laughs at the thought of a son in his old age, yet God reaffirms the promise with startling specificity: Sarah herself will bear Isaac. The sign of the covenant is physical, visible, costly. It marks every generation and reminds them that relationship with God is not casual but cut into the very fabric of their lives.</p><p>Covenant is costly. For us the sign is the cross, a body given and blood shed, and a Spirit who marks us as God's own. How do you cultivate the holy habit of belonging? Let the reminder of God's faithfulness be more than memory - let it become a daily, visible commitment of your whole self to walk before Him.</p>",
        "references": [
          "Genesis 17:1-27"
        ]
      },
{
        "day_number": 22,
        "title": "Day 22 - The Three Visitors (Genesis 18:1-15)",
        "content": "<p>By the great trees at Mamre, Abraham welcomes three strangers with lavish hospitality - bowing, washing feet, preparing the best calf. In receiving them, scripture tells us, he is entertaining angels, and one of them carries an impossible message: about this time next year, Sarah will have a son.</p><p>Sarah, listening at the tent door, laughs to herself, for she is old and the dream had long seemed dead. But the Lord hears even her silent laughter and asks the question that haunts every season of doubt: Is anything too hard for the Lord? Nothing, we are told, is.</p><p>Is anything too hard for the Lord? Whatever has died in you - a hope, a relationship, a calling you let go of long ago - hold it up to that question. Your laughter may be the laughter of cynicism or of deferred hope, but God's Word remains. Receive His promise with humility and wonder, and let the impossible become the foundation of your expectation.</p>",
        "references": [
          "Genesis 18:1-15"
        ]
      },
      {
        "day_number": 23,
        "title": "Day 23 - Abraham Pleads for Sodom (Genesis 18:16-33)",
        "content": "<p>As the visitors prepare to leave, the Lord reveals what He intends for Sodom. Abraham, drawing near, begins to intercede: Will you sweep away the righteous with the wicked? Far be it from you! He bargains from fifty down to ten, and each time God yields. The picture is of a God who restrains judgment in response to the pleas of a friend.</p><p>Here we see both the justice and the patience of God, and the privilege of prayer. Abraham does not only believe in God; he talks with Him, counts on His mercy, and intercedes for a wicked city. The chapter ends with the haunting note that the Lord did not find even ten righteous there - yet Abraham's conversation had already revealed God's heart.</p><p>How often do you draw near to God on behalf of others? Prayer is not bending God to our will but aligning us with His mercy, which is broader than we imagine. Intercede today for the people and places that seem farthest from God. It may be that your prayers are the only restraint between a city and its judgment.</p>",
        "references": [
          "Genesis 18:16-33"
        ]
      },
      {
        "day_number": 24,
        "title": "Day 24 - Sodom and Gomorrah Destroyed (Genesis 19:1-29)",
        "content": "<p>The two angels arrive in Sodom, and Lot, though entangled in the city's corruption, urges them into his home. When the men of the city surround the house in wickedness, Lot protects his guests. The angels pull him back and warn of the coming destruction: Flee so that you may live. Yet Lot lingers, and even in flight his heart remains divided, looking back at the burning city.</p><p>God nevertheless remembers Abraham and rescues Lot, sparing him from the overthrow. The story weaves together the terribleness of judgment and the persistence of grace. One who was entangled in sin is still pulled from the fire because God is merciful and because the prayers of the faithful reach even the least deserving.</p><p>Where are you lingering, looking back at a life you know must be left behind? Judgment and grace both bid you flee to the mountains. Do not be a Lot who hesitates. Run toward life fully, and remember that the God who delivered Lot through the intercession of Abraham is the God who delivers you through a greater intercessor.</p>",
        "references": [
          "Genesis 19:1-29"
        ]
      },
{
        "day_number": 25,
        "title": "Day 25 - Abraham and Abimelek (Genesis 20:1-18)",
        "content": "<p>Abraham moves into the region of Gerar, and once again fear gets the better of him. Fearing for his life, he asks Sarah to say she is his sister, and Abimelek takes her. The sobering part is that Abraham repeats the very deception he fell into in Egypt, years earlier - the same unbelief rising at the same pressure point.</p><p>Yet God again intervenes, warning Abimelek in a dream and protecting the promise. Abimelek, though a pagan king, acts with more integrity in the situation than Abraham does. Grace keeps the covenant intact despite its bearer's weakness, and Abraham is restored even as he confesses his fear.</p><p>It is humbling to meet the patterns of our own repeated failures. But notice what is constant: God's commitment does not depend on Abraham's courage. When you recognize an old sin resurfacing, do not despair at the pattern - bring it to God, who forgives and restores again. His covenant with you holds even when your faith wavers.</p>",
        "references": [
          "Genesis 20:1-18"
        ]
      },
      {
        "day_number": 26,
        "title": "Day 26 - The Birth of Isaac (Genesis 21:1-21)",
        "content": "<p>At last the Lord did for Sarah what He had promised. After decades of waiting, against every human possibility, the child is born, and the one who laughed in disbelief names her joy. The impossible promise has become flesh. As God said, it is done.</p><p>Yet the chapter is seasoned with tension. Hagar and Ishmael are sent away, and once more God meets the outcast in the desert, hearing the boy's cry and promising to make him into a great nation. God is faithful to both sons - to the son of promise and to the son of the flesh.</p><p>Is anything too hard for the Lord? The birth of Isaac is the answer the whole story has been building toward: God keeps His word. If you are waiting on a promise that seems past hope, hold on. And if you have felt cast out like Hagar, know that God sees your tears and has a plan for your life too. No one is beyond His faithfulness.</p>",
        "references": [
          "Genesis 21:1-21"
        ]
      },
      {
        "day_number": 27,
        "title": "Day 27 - The Treaty at Beersheba (Genesis 21:22-34)",
        "content": "<p>Abimelek comes to Abraham seeking a treaty, acknowledging what had become obvious to everyone: God is with you in everything you do. Abraham agrees, and the two enter an oath at Beersheba - the well of the oath. Abraham plants a tree and calls on the name of the Lord, the Everlasting God.</p><p>The chapter gives us a rare window of peace and stability. The long wanderer, the one who had so often been on the move, now plants a tree - a gesture of trust that he will remain, that God has given him a place at last. His life has become visible testimony, and even a foreign king recognizes the hand of God upon him.</p><p>Does the presence of God on your life show? Abimelek saw in Abraham a man blessed and protected, and he chose to become his friend. Let your faithfulness at work, at home, and in your community be evident enough that others take notice and want to be near you. Plant roots where God has put you, and call on Him as the Everlasting God.</p>",
        "references": [
          "Genesis 21:22-34"
        ]
      },
{
        "day_number": 28,
        "title": "Day 28 - Abraham Tested (Genesis 22:1-19)",
        "content": "<p>Then God said: Take your son, your only son, Isaac, whom you love, and sacrifice him. The request seems to tear the promise apart, yet Abraham rises early and goes. To Isaac's question, where is the lamb? Abraham answers in faith: God himself will provide. At the last moment the angel calls out, and Abraham sees a ram caught in the thicket. On the mountain he names the place The Lord Will Provide.</p><p>This is the deepest test of trust, and its resolution reveals the heart of the whole Bible. Abraham holds nothing back from God, and God holds nothing back from the world - years later giving His own Son on a hill, the lamb provided at last. The place Abraham saw provision is the place the cross casts its broad shadow.</p><p>Is there anything you are unwilling to entrust to God? Faith does not demand that you know the outcome, only that you trust the One who does. Bring your dearest treasure to Him, and be ready to discover the ram in the thicket - that God has provided what you could not imagine.</p>",
        "references": [
          "Genesis 22:1-19"
        ]
      },
      {
        "day_number": 29,
        "title": "Day 29 - Nahor's Sons (Genesis 22:20-24)",
        "content": "<p>The dramatic peak of chapter twenty-two gives way to a quiet family report. Word reaches Abraham that his brother Nahor has children - among them Rebekah. To an untrained eye these verses are a footnote, but to the biblical storyteller they are a bridge: the girl who will become Isaac's wife, and through whom the promise continues, is already being introduced.</p><p>This genealogical aside reminds us again that God works through the ordinary fabric of family life. No trumpet sounds when Rebekah is born; no angel announces her. Yet in the everyday birth of a child, the covenant takes another step forward.</p><p>Never discount the small and the unremarkable, for God's great purposes often travel along uncelebrated roads. The life you may think is only a footnote is woven into a larger story you cannot yet see. Tend your family relationships, your quiet faithfulness, and the ordinary births and births of opportunity - God is writing His story in them.</p>",
        "references": [
          "Genesis 22:20-24"
        ]
      },
      {
        "day_number": 30,
        "title": "Day 30 - The Death of Sarah (Genesis 23:1-20)",
        "content": "<p>Sarah dies at Kiriath Arba, and Abraham comes to mourn and to weep for her. He is a foreigner and a sojourner, owning no land in the country God had promised him. So he insists on paying full price for a burial plot - the cave of Machpelah - refusing even a gift so that the land would genuinely be his.</p><p>The chapter is a study in faith touching the ground of grief. Abraham mourns openly, yet he acts in the settled confidence of the promise: he is purchasing a foothold in the land God had pledged, burying Sarah there as a down payment on a future he would not see. Faith does not deny the tears of loss; it gives them a horizon.</p><p>When you face loss, you may feel like a sojourner with nothing you can truly call your own. Yet even your grief can be placed in the territory of God's promises. Mourn fully, but let your sorrow be anchored in hope - the hope that the same God who gave a land will give resurrection.</p>",
        "references": [
          "Genesis 23:1-20"
        ]
      },
{
        "day_number": 31,
        "title": "Day 31 - Isaac and Rebekah (Genesis 24:1-67)",
        "content": "<p>Abraham, old and sure of the importance of the moment, sends his most trusted servant to find a wife for Isaac - not from the people of the land but from his own kindred. The servant prays by the well for a sign, and before he finishes, Rebekah appears and shows the very hospitality he had asked for. The whole story moves with the quiet confidence that God is guiding.</p><p>It is a chapter of answered prayer and yielded obedience. The servant bows and worships; Rebekah and her family consent; and when Rebekah sees Isaac in the field, she dismounts and covers herself. The covenant line is passed on through an ordinary act of trust: a prayer at a well, a girl with a water jar, a servant who told God his request.</p><p>The Lord brought the servant on his way. For decisions large and small, you can bring your way before God and trust Him to guide. Pray specifically, act with integrity, and leave room for the divine yes. And learn from Isaac and Rebekah - when God brings you to the right place and person, receive it with joy and be comforted.</p>",
        "references": [
          "Genesis 24:1-67"
        ]
      },
      {
        "day_number": 32,
        "title": "Day 32 - The Death of Abraham (Genesis 25:1-18)",
        "content": "<p>Abraham marries again and has more children, but he gives everything he owns to Isaac, the son of promise, while sending the others away with gifts. Then, at a good old age, Abraham breathes his last and is gathered to his people. His sons Isaac and Ishmael come together to bury him in the cave of Machpelah, beside Sarah.</p><p>The close of Abraham's life affirms the faithfulness of God to an ordinary man who became the father of nations. The record even lists Ishmael's descendants, showing that God kept His promise to Hagar's son as well. No story in Scripture is wasted; every branch of the family tree stands under God's care.</p><p>Your life, too, will one day be a completed chapter. What will remain is not the size of your name but your faithfulness to the promise you lived by. Leave a clear inheritance of what matters, make peace where you can, and let your final years be a testimony that God has been with you in everything you did.</p>",
        "references": [
          "Genesis 25:1-18"
        ]
      },
      {
        "day_number": 33,
        "title": "Day 33 - Jacob and Esau (Genesis 25:19-34)",
        "content": "<p>Rebekah's pregnancy is difficult, and God reveals that two nations are in her womb, the older will serve the younger. Esau is born first, hairy and strong, a hunter; Jacob comes out grasping his heel. The two boys could hardly be more different. Then, in a moment of hungry exhaustion, Esau sells his birthright to Jacob for a bowl of stew.</p><p>The story is a study in trading lasting worth for immediate satisfaction. Esau despises his birthright, and later he will weep for it and find no place of repentance. Jacob, for his part, is no saint - he takes advantage of his brother's weakness. Yet God's purpose runs through both their failures, working out the promise of the younger serving none.</p><p>Do you sometimes sell the precious for the immediate - your integrity for approval, your future for comfort, your calling for convenience? Like Esau, we are all one hungry moment away from folly in desperate haste. Go before God with your appetites, and treasure what cannot be bought back.</p>",
        "references": [
          "Genesis 25:19-34"
        ]
      },
{
        "day_number": 34,
        "title": "Day 34 - Isaac and Abimelek (Genesis 26:1-33)",
        "content": "<p>A famine drives Isaac to Gerar, and the Lord appears to him, repeating the promise made to Abraham: I will be with you and will bless you, and through your offspring all nations will be blessed. Isaac reopens the wells his father had dug, refilling them with living water, and the herds multiply until the Philistines envy him. He is even confronted for repeating his father's deception about Rebekah - only now the pattern is being passed down.</p><p>The center of the chapter is a story of perseverance in the dry places. Time and again Isaac digs a well and the herdsmen quarrel over it, moves on, and digs again. He keeps going until at last the Lord appears to him and says, I am the God of your father Abraham; do not be afraid.</p><p>Sometimes the faithful path is simply to keep digging, quietly, refusing to fight for what God will give. Persistency in obedience is its own testimony, and Abimelek comes to say: We saw clearly that the Lord was with you. When your wells are disputed, keep digging in faith, and let God be the one to vindicate you.</p>",
        "references": [
          "Genesis 26:1-33"
        ]
      },
      {
        "day_number": 35,
        "title": "Day 35 - Jacob Gets Isaac's Blessing (Genesis 27:1-40)",
        "content": "<p>Isaac, old and blind, intends to give his blessing to Esau, the eldest. But Rebekah, who knows the promise is for Jacob, orchestrates a deception. Jacob covers himself with goatskins and esau's clothing, lies to his father, and receives the blessing meant for his brother. When Esau discovers it, his cry is raw and terrible, and his desperate plea - bless me too, my father - meets only grief.</p><p>The chapter shows the mess of a family managing God's promise by their own scheming. Jacob gains the blessing but at the cost of a broken brother and a lifetime of running. God's purposes cannot be stopped, but our methods of grasping can wound deeply, and old Isaac trembles violently when he learns what has happened.</p><p>When we believe God's timing is slow, temptation whispers to scheme, deceive, and take control. But God does not need our lies to fulfill His word. Ask Him to search out the places where you are grasping through manipulation, and trust that His blessing comes to those who wait on Him instead of taking matters into their own hands.</p>",
        "references": [
          "Genesis 27:1-40"
        ]
      },
      {
        "day_number": 36,
        "title": "Day 36 - Jacob Flees to Laban (Genesis 27:41-28:9)",
        "content": "<p>Esau resolves to kill Jacob once their father dies, and Rebekah, hearing of it, sends Jacob away to her family in Paddan Aram. The man who stole a blessing is now a fugitive, fleeing the anger he earned. Yet even in the sorrow of exile, his parents charge him to find a wife from their own people - the covenant line continuing through him.</p><p>Jacob leaves with a stolen blessing but a heavy heart, a man whose cunning has cost him his home. The blessing he seized by deceit he now holds as a man on the run. It is a sober reminder that what we gain through our own schemes often comes wrapped in loss.</p><p>It is tempting to think we can secure God's favor by our cleverness, but God's discipline in Jacob's life is gentle and persistent. If you are living with the aftermath of an unwise or dishonest choice, do not let shame keep you from the road God has for you. He who disciplined Jacob will meet you too, often most powerfully at your lowest point.</p>",
        "references": [
          "Genesis 27:41-28:9"
        ]
      },
{
        "day_number": 37,
        "title": "Day 37 - Jacob's Dream at Bethel (Genesis 28:10-22)",
        "content": "<p>Jacob, a homeless fugitive, lays his head on a stone in the open country. In a dream he sees a ladder resting on the earth with its top reaching to heaven, and angels ascending and descending on it. Above it stands the Lord, who repeats to Jacob the promises made to Abraham and adds the gift of His abiding presence: I am with you and will watch over you wherever you go.</p><p>Jacob wakes and declares, Surely the Lord is in this place, and this is the house of God. The God of the sanctuary meets His man in the wilderness, on the run and emptied of everything. A staircase of grace connects heaven and earth, and at the center of it stands Jesus, who in the gospel says we will see heaven open and the angels ascending on the Son of Man.</p><p>Have you ever felt at your lowest, a stone for a pillow? It is often there - not in the well-ordered sanctuary but in the wilderness of our failure - that God draws near with a word of presence. He meets you where you are, and His promise is not revoked by your flight. There is a ladder between God and you, and it is held by Jesus Himself.</p>",
        "references": [
          "Genesis 28:10-22"
        ]
      },
      {
        "day_number": 38,
        "title": "Day 38 - Jacob Arrives in Paddan Aram (Genesis 29:1-30)",
        "content": "<p>Jacob comes to a well in the open country and meets Rachel, his cousin, and is immediately smitten. He agrees to serve Laban seven years for her, and they seem like only a few days to him because of his love. But Laban deceives the deceiver, and on the wedding night Jacob discovers it is Leah he has married. He must work another seven years for Rachel.</p><p>The tables have turned. The man who tricked his father is now tricked by his uncle, and he tastes the bitterness of being deceived. Yet the chapter is not without mercy. Leah, unloved, is the one God sees - she will become the mother of Judah, through whom the Savior comes.</p><p>When our own past deceptions boomerang, it is easy to feel we are only reaping what we sowed. But notice how God weaves grace even into the trickery of Laban's household. The overlooked and unloved has a place in His story. However you have been treated or have treated others, God sees you and can bring life from the wounded places.</p>",
        "references": [
          "Genesis 29:1-30"
        ]
      },
      {
        "day_number": 39,
        "title": "Day 39 - Jacob's Children (Genesis 29:31-30:24)",
        "content": "<p>The account of Jacob's growing family is shadowed by rivalry. Leah, unloved, and Rachel, barren, compete for fertility, and the household swells with sons born of lesser-known relationships. Each wife names her children out of her own ache - Leah finding hope in the Lord who saw her misery, Rachel crying out to Jacob, Give me children, or I will die.</p><p>Into this turbulent family the covenant advances. It is a messy genealogy, full of envy and manipulation, yet out of it come the twelve tribes of Israel. God is not embarrassed by the tangled families He works with; He brings life and purpose out of our competing desires and disappointments.</p><p>Your own family tree may have rivalry, brokenness, and barren seasons. Do not conclude that God is absent from it. He specializes in naming children of hope from wombs of grief. Trust Him with the parts of your story that are competitive or empty, and look for how He is bringing fruitfulness even where you see only trouble.</p>",
        "references": [
          "Genesis 29:31-30:24"
        ]
      },
{
        "day_number": 40,
        "title": "Day 40 - Jacob's Flocks Increase (Genesis 30:25-43)",
        "content": "<p>Jacob, having served his time, asks to leave. Laban, seeing that the Lord has blessed him because of Jacob, urges him to stay, and they strike an unusual arrangement: Jacob will keep the streaked and spotted and dark animals as his wages. Through a selective breeding practice - and the hand of God, as Jacob will later testify - the stronger animals produce the sort that belong to Jacob, so that he grows exceedingly prosperous while Laban's herds dwindle.</p><p>The chapter shows a shrewd man working the system, yet Scripture is clear that the true source is God. The blessing does not come from Jacob's cleverness alone but from the God of his father being with him. Two competing self-interests - Laban's greed and Jacob's ambition - are both subsumed into God's larger plan to establish His servant.</p><p>Fair enough, we may scheme and strive and outmaneuver, but the One who causes the flock to increase is God. When you prosper, do not imagine it is only your effort. Give the growth to God, hold your success loosely, and let prosperity form gratitude rather than pride in you, for blessing is a stewardship from Him.</p>",
        "references": [
          "Genesis 30:25-43"
        ]
      },
      {
        "day_number": 41,
        "title": "Day 41 - Jacob Flees From Laban (Genesis 31:1-55)",
        "content": "<p>Laban's sons grumble that Jacob has taken everything, and Laban's welcome has cooled. So the Lord tells Jacob: Go back to the land of your fathers. Jacob gathers his family and flocks and slips away while Laban is shearings some distance off. Rachel, unknown to Jacob, has taken her father's household gods, and when Laban catches up there is a tense confrontation.</p><p>The two men, equal in cunning, face each other across a pile of stones. Laban cannot find his gods, and the family divides sharply along old wounds. Yet God speaks to Laban in a dream, warning him not to harm Jacob, and at the last the pair are sent away in peace, each wary of the other but bound by a covenant of mutual restraint.</p><p>Sometimes God calls us to leave situations that have grown toxic and envious, even when the leaving is complicated. The same God who told Jacob to go promises to go with him. Releasing an old tension that can never be truly healed is not failure; it is wisdom. Let God be your defense when there is no human judge who can see the whole truth.</p>",
        "references": [
          "Genesis 31:1-55"
        ]
      },
      {
        "day_number": 42,
        "title": "Day 42 - Jacob Prepares to Meet Esau (Genesis 32:1-21)",
        "content": "<p>After twenty years away, Jacob must finally face the brother he wronged. Messengers return with news that Esau is coming with four hundred men, and Jacob is filled with dread. He does the only things available to him: he splits his camp as a safeguard, and then, alone, he prays the prayer of a man with nowhere left to hide - I am unworthy of all the kindness and faithfulness you have shown your servant; save me, I pray, from the hand of my brother.</p><p>Then, almost cancelled out by the very anxiety he is trying to settle, Jacob sends wave after wave of gifts ahead to calm Esau. It is a portrait of a man caught between trust in God and his own frantic management, covering every angle because the fear is so real.</p><p>When the person we have wronged stands before us, no gift or strategy can quite quiet the heart - only honest prayer can. Bring your unworthiness to God as Jacob did. Weakened and exposed, you are in the best place to discover that God is your only sufficient defense against the consequences you deserve.</p>",
        "references": [
          "Genesis 32:1-21"
        ]
      },
{
        "day_number": 43,
        "title": "Day 43 - Jacob Wrestles With God (Genesis 32:22-32)",
        "content": "<p>That night Jacob sends his family across the ford and is left alone. A man wrestles with him until daybreak, and Jacob, refusing to let go, clings to him and demands a blessing. The stranger dislocates Jacob's hip with a touch, yet Jacob still will not let him go. He asks Jacobs name, and Jacob confesses it; then the man declares: Your name will no longer be Jacob, but Israel, because you have struggled with God and with humans and have overcome.</p><p>Jacob limps away with a new name, a changed man, marked for life. He had asked God to save him, and the answer came as a fight in the dark. Grace does not always arrive gently; sometimes it grips us, wounds us, and refuses to let us go until we yield every claim to our own strength.</p><p>What are you wrestling with tonight? It may be that God Himself is in the struggle, seeking not your defeat but your transformation. Do not let go until He blesses you. It is better to enter the day crippled and named by God than to cross it self-sufficient and unchanged. His blessing often leaves a mark, but the mark is glory.</p>",
        "references": [
          "Genesis 32:22-32"
        ]
      },
      {
        "day_number": 44,
        "title": "Day 44 - Jacob Meets Esau (Genesis 33:1-20)",
        "content": "<p>Jacob looks up and sees Esau coming with his four hundred men. He places the maidservants and children first, then Leah and Rachel, keeping himself behind - a man braced for the worst. But Esau runs to meet him, embraces him, throws his arms around his neck and kisses him, and weeps. The long-cherished mountain of offense dissolves into forgiveness.</p><p>The reunion is startlingly gracious. Esau, who had once vowed to kill his brother, receives Jacob with open arms. Jacob, humbled and limping, can barely believe it: To see your face is like seeing the face of God. He who had feared to meet his brother meets instead a face of undeserved mercy.</p><p>Is there a broken relationship you have rehearsed as a battlefield only to find it could be a reunion? Sometimes the fears that grip us most are the very ones God dissolves in an embrace. Offer and receive forgiveness freely, and do not let old offenses keep you at a distance from those God has reconciled to you.</p>",
        "references": [
          "Genesis 33:1-20"
        ]
      },
      {
        "day_number": 45,
        "title": "Day 45 - Dinah and the Shechemites (Genesis 34:1-31)",
        "content": "<p>The sons of Jacob leave Dinah, their sister, with the people of the land, and Shechem forces her and then speaks tenderly to win her. Learning of it, her brothers are filled with grief and fury. They deceive the whole city into circumcision and then, while the men are recovering, Simeon and Levi kill them and take Dinah back, leaving the household's name in ruin.</p><p>It is a dark and troubling chapter, and the Bible does not soften it. The sin of Shechem is met not with justice but with disproportionate and deceptive violence. Jacob's response is distress at the danger to his own family, and the chapter closes unresolved, a family that had been reconciled on one front now stained on another.</p><p>The account forces us to sit with the reality that even the people of the promise commit terrible wrongs in the name of defending honor. It warns us that bloodshed never restores what sin has taken, and it stirs us to grieve the ways we cannot undo the damage we cause. Bring such sorrow before God; He is not frightened by our brutality and longs to heal what has been broken.</p>",
        "references": [
          "Genesis 34:1-31"
        ]
      },
{
        "day_number": 46,
        "title": "Day 46 - Jacob Returns to Bethel (Genesis 35:1-15)",
        "content": "<p>God says to Jacob: Go up to Bethel and settle there, and build an altar there to God, who appeared to you when you were fleeing from your brother. Jacob responds to the moment by putting away the foreign gods in his household, purifying his family, and returning to the place where heaven once opened to a homeless fugitive. There God renews the promise and the name Israel.</p><p>Bethel - the house of God - was the site of Jacob's ladder, his lowest point elevated by grace. Now, years later, he is called back to remember. The return is marked by worship and cleansing, a resetting of the house around the God who had met him in the wilderness when he had nothing to offer.</p><p>Do you have a Bethel - a place where God met you at your lowest? The discipline of return is one of the most healing we can practice. Go back to the place of your first love, offer your life afresh, and lay aside the gods that have gathered in your house. God is still there, still promising, still ready to renew your name.</p>",
        "references": [
          "Genesis 35:1-15"
        ]
      },
      {
        "day_number": 47,
        "title": "Day 47 - The Deaths of Rachel and Isaac (Genesis 35:16-29)",
        "content": "<p>The chapter closes with grief upon grief. Rachel, the beloved wife, dies giving birth to Benjamin and names him in her last breath; Jacob sets a pillar over her grave. Then Isaac breathes his last, and his sons Esau and Jacob bury him together beside Sarah in the cave of Machpelah.</p><p>There is an aching tenderness here. The family that has been so torn by rivalry comes together at last, united by death and by the quiet dignity of burial. Loss gathers even the estranged. Jacob, who has limped and fled and wrestled all his life, now stands as the father of a growing household, shaped by the graves he has laid beside.</p><p>Grief is the great equalizer, and it can also be the great reconciler. When you lose one you love, do not rush past the sorrow or let it fester into bitterness. Lay a pillar of remembrance, let the tears come, and allow your losses, in their way, to draw you closer to the family and the God who remain. Death is still not the final word - for them or for you.</p>",
        "references": [
          "Genesis 35:16-29"
        ]
      },
      {
        "day_number": 48,
        "title": "Day 48 - Esau's Descendants (Genesis 36:1-43)",
        "content": "<p>Before the story turns from Esau to Jacob's favored son Joseph, Scripture pauses to record the descendants of Esau - now called Edom. It is a long list of sons, chiefs, and kings of Edom, established in the hill country before Israel had a king. The genealogy shows that Esau, though he lost the birthright, was blessed by God with a fruitful and powerful line.</p><p>This extended chapter serves a quiet purpose: it honors the promise to Esau even as the main narrative presses toward Jacob. Not every branch of the family walks the central covenant road, and yet God is faithful to the branches He set aside. The one who was spurned by his brother is nonetheless made great in his own land.</p><p>Do not assume that because your story is not the central one, God has forgotten you. He multiplied Esau's descendants because He is gracious to all whom He has made. You may feel like a footnote in another's life, but you are a chapter in God's. Serve faithfully in the place He has given you, and trust that His blessing reaches every family line He has scattered.</p>",
        "references": [
          "Genesis 36:1-43"
        ]
      },
{
        "day_number": 49,
        "title": "Day 49 - Joseph's Dreams (Genesis 37:1-36)",
        "content": "<p>The saga of Joseph begins with favor and jealousy. He is the son of Jacob's old age, and his father loves him above his brothers, giving him an ornate robe. Joseph's dreams - of sheaves and stars bowing before him - only inflame the envy until his brothers strip him of the robe, throw him into a cistern, and sell him to merchants bound for Egypt. They deceive their father into believing he has been devoured by a wild animal.</p><p>There is almost nothing comforting in the scene except the confession that the brothers acted not in a vacuum but because hatred had consumed them. Yet hidden in the wreckage is the working of God, who will take an evil intended against His servant and use it to save many alive. The robe is torn, but the dream is not dead.</p><p>Betrayal stains some of our deepest stories, and we may wonder where God is in them. Remember Joseph: the favor of God on your life will draw envy, but it will also be the thing that carries you. You do not have to orchestrate the ending; the God who gave the dream is still watching that pit, and He is not finished.</p>",
        "references": [
          "Genesis 37:1-36"
        ]
      },
      {
        "day_number": 50,
        "title": "Day 50 - Judah and Tamar (Genesis 38:1-30)",
        "content": "<p>The narrative abruptly leaves Joseph in Egypt to tell the story of Judah. Judah marries and has sons; the eldest dies, and Tamar his widow is denied the next two sons in turn, her rights under the family custom neglected. In her desperation she disguises herself and traps Judah, conceiving a child whom she will later produce as proof of his identity. Judah is confronted and confesses: She is more righteous than I.</p><p>It is a sordid tale - sexual deceit, broken oaths, family failure - yet out of Tamar's bold and wounded integrity comes Perez, an ancestor of David and ultimately of Jesus. The gospel does not sanitize its family tree; it enters through a lineage of the broken and the reclaimed.</p><p>We should not sanitize it either. God can take a story laced with shame and turn it into the saving line. If your past holds episodes you are ashamed to speak, hear this: the Redeemer does not come swaddled in a spotless ancestry. He is willing to be named with the Tamars and the Judahs. Bring your whole story to Him, and let it become part of His.</p>",
        "references": [
          "Genesis 38:1-30"
        ]
      },
      {
        "day_number": 51,
        "title": "Day 51 - Joseph and Potiphar's Wife (Genesis 39:1-23)",
        "content": "<p>In Egypt, Joseph is sold to Potiphar, an officer of Pharaoh, and the Lord is with him so that he prospers and is put in charge of the household. But Potiphar's wife casts her eyes on him and urges him to lie with her. Joseph refuses out of loyalty to his master and, more fundamentally, to God: How then could I do such a wicked thing and sin against God? Falsely accused, he is thrown into prison.</p><p>The chapter is a window into integrity when no one is looking and when the cost is high. Joseph chooses faithfulness over advantage, and though it costs him years, Scripture underscores the refrain: The Lord was with Joseph, giving him success in whatever he did - even in the prison.</p><p>You may sometimes wonder if your refusal to compromise matters when the payoff for bending seems great and no one will know. Joseph's life is the answer: the Lord does know, and His presence is the truest definition of success. Choose faithfulness for God's sake, and trust Him with the outcome, even when the prison seems to say otherwise.</p>",
        "references": [
          "Genesis 39:1-23"
        ]
      },
{
        "day_number": 52,
        "title": "Day 52 - The Cupbearer and the Baker (Genesis 40:1-23)",
        "content": "<p>Two of Pharaoh's officials - the chief cupbearer and the chief baker - are thrown into the prison where Joseph is. Both have troubling dreams, and Joseph, seeing their dejection, asks why they are so sad. When they tell him they have no one to interpret the dreams, Joseph answers with a humility that still holds hope: Do not interpretations belong to God? Tell me your dreams.</p><p>Joseph interprets them accurately, and days later both dreams come true exactly as he said. He asks the cupbearer to remember him, to speak to Pharaoh about his wrongful imprisonment. Yet the cupbearer, restored to his post, forgets Joseph. Deliverance is delayed, and the imprisoned dreamer waits.</p><p>Too often we rely on human memory, and it fails us. But the lesson of the chapter is that God has not forgotten, even when people do. When your name is overlooked and your faithfulness goes unremembered, do not let hope die. The Bible narrates the delay without despair because God is still writing. Sooner or later, on His clock, the dream will be remembered.</p>",
        "references": [
          "Genesis 40:1-23"
        ]
      },
      {
        "day_number": 53,
        "title": "Day 53 - Pharaoh's Dreams (Genesis 41:1-36)",
        "content": "<p>Two full years pass, and Pharaoh dreams of fat and thin cows and of full and scorched heads of grain. None of Egypt's magicians can interpret the dreams. Then the cupbearer finally remembers Joseph. Brought from the dungeon and put before Pharaoh, Joseph insists that he cannot interpret apart from God - and then, through God, he unfolds the dreams: seven years of abundance followed by seven years of famine.</p><p>Joseph does more than interpret; he gives counsel that displays both wisdom and humility. He urges Pharaoh to appoint a discerning man to store grain during the good years against the coming famine. The dreaming prisoner becomes the wise counselor of a kingdom.</p><p>God uses waiting seasons to prepare us for assignments we cannot yet see. The two years in the dungeon were not wasted; they shaped the man who could stand calm before the king. If your waiting feels endless, trust that God is preparing you for the moment of remembrance. When it comes, give Him the glory and let your wisdom serve the moment.</p>",
        "references": [
          "Genesis 41:1-36"
        ]
      },
      {
        "day_number": 54,
        "title": "Day 54 - Joseph in Charge of Egypt (Genesis 41:37-57)",
        "content": "<p>Pharaoh recognizes the spirit of God in Joseph and sets him over all Egypt, second only to the throne. He gives him an Egyptian name and a wife, and Joseph, now thirty, stores up grain in the seven years of plenty with the same faithfulness he showed in Potiphar's house and in prison. When the famine spreads, there is grain in Egypt for all the world because Joseph was faithful in the ordinary work of gathering.</p><p>The story turns on a quiet truth: the man who was sold as a slave is now clothed in royal robes, not through self-promotion but through faithful stewardship at every stage. The same character that marked him in the dungeon governs him in the palace. God's exaltation came after years of proving faithful with what was small and hidden.</p><p>Do you tend the small responsibilities God has placed before you as if they were the palace? The diligence you show now is the training for the responsibility God may give you later. Do not despise the seasons of storing and waiting and obeying; they are the assembly where God equips you for the throne He intends.</p>",
        "references": [
          "Genesis 41:37-57"
        ]
      },
{
        "day_number": 55,
        "title": "Day 55 - Joseph's Brothers Go to Egypt (Genesis 42:1-38)",
        "content": "<p>Emboldened by famine, Jacob sends his sons to Egypt for grain. They bow before its governor - unknowingly fulfilling Joseph's dream of the sheaves - and Joseph recognizes his brothers. He tests them harshly, accusing them of being spies, keeping Simeon, and demanding that they return with their youngest brother Benjamin.</p><p>The brothers, whose conscience has been slumbering for years, are suddenly awakened: Surely we are being punished because of our brother, for we saw the anguish of his soul when he pleaded with us, and we did not listen. Joseph, hearing them speak in their own tongue of their guilt, turns aside and weeps. The wounds of the past are still tender.</p><p>Guilt has a long memory, and it is often God's servant in our lives, bringing us to the point of confession long after the deed. The famine of circumstances can be the very thing that finally makes us face what we have buried. Do not resist the discomfort that surfaces your hidden sins; let it drive you toward the grace that alone can pardon and heal them.</p>",
        "references": [
          "Genesis 42:1-38"
        ]
      },
      {
        "day_number": 56,
        "title": "Day 56 - The Second Journey to Egypt (Genesis 43:1-34)",
        "content": "<p>The famine presses on, and the grain bought on the first journey runs out. Jacob resists sending Benjamin, fearing another loss, but Judah steps forward with a pledge: I myself will guarantee his safety; you can hold me personally responsible for him. At last Jacob relents, and the brothers return to Egypt bearing gifts and double the silver, and this time the governor receives them with hospitality, seating them by order of birth and astonishing them with his insight.</p><p>The chapter is marked by the quiet rise of Judah, who stayed with middle risk and leadership. And we see Joseph, still masked to his brothers, moved with longing and unable to contain himself until the right moment. The reconciliation is being prepared in ways none of the brothers can yet see.</p><p>Note how a measure of responsibility moves a relationship forward. Judah risked his own place for his father and brother, and the door began to open. Sometimes we are the ones called to guarantee the safety of those who stumble. Take that role seriously, even when it costs you, and trust God to be working the reunion you cannot yet see.</p>",
        "references": [
          "Genesis 43:1-34"
        ]
      },
      {
        "day_number": 57,
        "title": "Day 57 - A Silver Cup in a Sack (Genesis 44:1-34)",
        "content": "<p>Joseph stages one more test. He hides his silver cup in Benjamin's sack and sends his brothers on their way, only to have his steward overtake them and accuse them of theft. When the cup is found, the brothers return to Joseph, and Judah makes the plea that changes everything: I will remain as your servant; let the boy go back with his brothers. He is willing to take Benjamin's place to spare his father's grief.</p><p>Judah, who once sold a brother for silver, now offers himself for a brother. He is a changed man, and his intercession - take me instead - is a shadow of a greater substitution yet to come. The salvation of the family will hinge on someone willing to stand in another's place.</p><p>Would you stand in another's place? Judah's selfless speech moves the story toward its climax because sacrificial love is what finally breaks estrangement. And in it we see, dimly, the One who would one day say to the Father: let him go free, I will take his place. Let that love shape how you plead for others today.</p>",
        "references": [
          "Genesis 44:1-34"
        ]
      },
{
        "day_number": 58,
        "title": "Day 58 - Joseph Makes Himself Known (Genesis 45:1-28)",
        "content": "<p>Joseph can contain himself no longer. He orders everyone out and, weeping so loudly that all Egypt hears, reveals himself to his brothers: I am Joseph! His brothers are terrified and speechless, but Joseph does not make them grovel. Instead he lifts them up: Do not be distressed and do not be angry with yourselves for selling me here, because it was to save lives that God sent me ahead of you. Then he falls on their necks and weeps, and after a lifetime of estrangement they talk together as family again.</p><p>Here is the gospel in miniature: the one who was wronged chooses not revenge but reconciliation, and he frames the whole betrayal as part of God's saving purpose. Joseph's words - God sent me ahead of you to preserve for you a remnant - reveal a sovereignty large enough to work even through human evil.</p><p>Is there a wound you have resisted the urge to reconcile? Extending and receiving forgiveness is not the same as pretending the wrong never happened; it is refusing to let it have the last word. Like Joseph, you can choose to forgive because you trust the God who works through what others meant for harm.</p>",
        "references": [
          "Genesis 45:1-28"
        ]
      },
      {
        "day_number": 59,
        "title": "Day 59 - Jacob Goes to Egypt (Genesis 46:1-34)",
        "content": "<p>Jacob sets out with all he has, and at Beersheba he offers sacrifices to the God of his father Isaac. There God speaks to him in a vision: Do not be afraid to go down to Egypt, for I will make you into a great nation there, and I will surely bring you back again. Reassured, the aging patriarch goes down with his whole household, and the chapter carefully lists the descendants who make the journey - all seventy persons.</p><p>The journey is as much about trust as about travel. Jacob clings to the promise that God will bring his family back, and when he finally stands before Joseph, the son he had mourned as dead, his response is the settled joy of a man with little left to lose: Now I am ready to die, since I have seen for myself that you are still alive.</p><p>Sometimes God asks us to go places that seem like departure from His promise - yet He goes with us. Lay your need before Him at the altar as Jacob did, and hear His word: do not be afraid. And notice the reunion you may have long given up on; God specializes in restoring what we thought was gone forever.</p>",
        "references": [
          "Genesis 46:1-34"
        ]
      },
      {
        "day_number": 60,
        "title": "Day 60 - Joseph and His Family Settle in Goshen (Genesis 47:1-12)",
        "content": "<p>Joseph presents his family to Pharaoh, and his brothers, though shepherds - an occupation detested in Egypt - are granted the land of Goshen, the best of the land. Joseph ushers his elderly father into Pharaoh's presence, and Jacob blesses Pharaoh. The family of promise, once threatened with famine, is now settled and provided for in the midst of a pagan empire.</p><p>Notice how the aging father, dependent and frail, still blesses the great king. Jacob has little to give by earthly measure, yet he lifts his hands over Pharaoh in blessing. In God's economy, the weakest can carry the greatest authority, because blessing flows from God through His people to the nations.</p><p>Do you feel too old or too small to matter in the grand scheme? Jacob's example says otherwise. Even in your seasons of dependence, you carry blessing for those around you. Do not underestimate the quiet power of your prayers and your presence. God has placed you where you are to be a channel of His favor, however unimpressive it may look.</p>",
        "references": [
          "Genesis 47:1-12"
        ]
      },
{
        "day_number": 61,
        "title": "Day 61 - Joseph and the Famine (Genesis 47:13-26)",
        "content": "<p>The famine grows severe, and Joseph's management sustains the land. When the people's silver runs out, they trade their livestock for grain; when that too is gone, they sell their land and finally themselves, becoming Pharaoh's servants. Joseph supplies them with seed in exchange for a fifth of the harvest, and the people respond not with resentment but with gratitude: You have saved our lives.</p><p>The chapter records the consolidation of Pharaoh's power, and a modern reader may wince at what looks like economic entrenchment. Yet the narrative emphasis falls on provision in crisis - that through Joseph, God saved many people alive, even as their circumstances changed. The wisdom that stored grain in plenty becomes the mercy that feeds a starving world.</p><p>Provision is a form of ministry. Not everyone is called to rescue at a dramatic moment, but everyone can steward resources and gifts for the good of others in hard times. Ask how your abundance - of money, time, insight, or influence - could become seed for someone facing their own famine. Generosity is God's way of saving lives.</p>",
        "references": [
          "Genesis 47:13-26"
        ]
      },
      {
        "day_number": 62,
        "title": "Day 62 - Jacob's Final Request (Genesis 47:27-31)",
        "content": "<p>Jacob, now near the end, lives in Egypt for seventeen more years, and the days of Israel's death draw near. He summons Joseph and makes him swear by putting his hand under his thigh that he will not bury him in Egypt but will carry his body up to the cave of Machpelah, beside Abraham and Sarah and Isaac and Rebekah. Joseph swears it, and Israel bows in worship at the head of his bed.</p><p>The request is laden with faith. An old man in a rich land could have accepted an Egyptian burial, but Jacob wants to be laid in the burial-place of the promise. He is staking even his burial on the future God promised - that one day his descendants will inherit that land. Faith, for him, reaches all the way down to where his bones will rest.</p><p>How far does your faith extend? Jacob's reach into the grave is a whole-lifetime trust that God's word is true. Die with hope, if you are that near the end, and live with that same hope the rest of the way. What God has promised, He will fulfill - even if the fulfillment comes after your bones are buried in the soil of that promise.</p>",
        "references": [
          "Genesis 47:27-31"
        ]
      },
      {
        "day_number": 63,
        "title": "Day 63 - Manasseh and Ephraim (Genesis 48:1-22)",
        "content": "<p>Joseph brings his two sons to his ailing father, placing Manasseh, the firstborn, at Jacob's right hand so he might receive the primary blessing. But Jacob deliberately crosses his hands, laying his right hand on Ephraim, the younger, and blesses them with a startling reversal. When Joseph protests, Jacob insists: He too will become great, but his younger brother will be greater than he. He blesses them, saying, May they increase and become numerous.</p><p>This is no senile confusion; it is the same divine freedom that chose Jacob over Esau and Joseph over his brothers. Over and over, God's ways overturn human calculations of priority. Blessing is not allocated by birthright but by the sovereign favor of God, who delights in using the younger, the overlooked, and the unexpected.</p><p>You may have been overlooked by your family, your school, or your church because you are not the steady and obviously favored one. Take heart: God chooses what the world passes over. He is not bound by human ranking. Entrust your significance to Him, and watch Him lay His hand on you and bless you beyond the expectations of any birth order.</p>",
        "references": [
          "Genesis 48:1-22"
        ]
      },
{
        "day_number": 64,
        "title": "Day 64 - Jacob Blesses His Sons (Genesis 49:1-28)",
        "content": "<p>Gathering his sons, Jacob speaks over each of them a blessing that is also an unveiling. Some receive words of strength, others warnings that expose long-buried sins - Reuben's instability, the violence of Simeon and Levi, Judah receiving the promise of a ruler whose scepter will not depart from him until Shiloh comes. Even the most wounded words are spoken in the context of the covenant that will carry forward through all twelve tribes.</p><p>Jacob speaks with the eyes of one who has seen enough of life to say hard truths gently. He does not pretend his sons are perfect, yet he blesses them all as the bearers of Israel's future. The tribe of Judah, born out of the broken story of Tamar, is singled out for the line of kingship.</p><p>Families need honest words spoken in love. You may carry another's blame, just as these brothers carried remembered failures; or you may need to speak what is hard because it is healing. Let the harsh truth be wrapped in the blessing of belonging. And rest in this: out of Judah's troubled line came the Lion of Judah, who redeems every tribe's twisted history.</p>",
        "references": [
          "Genesis 49:1-28"
        ]
      },
      {
        "day_number": 65,
        "title": "Day 65 - The Death of Jacob (Genesis 49:29-33)",
        "content": "<p>Jacob, having finished blessing his sons, gives his final charge: Bury me with my fathers in the cave in the field of Machpelah, beside Abraham and Sarah, Isaac and Rebekah, and Leah. When he has finished giving his charge, he draws his feet up into the bed, breathes his last, and is gathered to his people. The long pilgrimage that began with a stolen birthright and a fleeing from home ends in a simple, faithful surrender.</p><p>There is a quiet completeness to this death. Jacob - the schemer, the wrestler, the one who had snatched and struggled all his life - dies at peace, at rest with his children, pointed toward the promise of a land he never fully possessed. With him the story of the patriarchs closes in trust.</p><p>How do you want to die? The question is not morbid but clarifying. Jacob's end was shaped by the hopes he had leaned on all his days. Live toward the promise now - lay up the peace, mend the relationships, and fix your heart on the land God has pledged - so that when you draw your feet into the bed, you too may be gathered to your people, at peace and full of hope.</p>",
        "references": [
          "Genesis 49:29-33"
        ]
      },
      {
        "day_number": 66,
        "title": "Day 66 - Jacob's Burial (Genesis 50:1-14)",
        "content": "<p>Joseph weeps over his father, and then begins the long journey of honor: embalmed in Egypt, mourned for seventy days, carried by a great procession of Pharaoh's officials and chariots up to the land of Canaan, where Jacob is buried in the cave of Machpelah exactly as he had requested. Even in death, the family of promise plants its flag in the land God had sworn to give.</p><p>The funeral is a testimony more than a formality. All of Egypt sees an old Hebrew buried in his promised homeland, and it marks an unbreakable tie between the covenant family and the land. Joseph and his brothers return to Egypt, but a stone in that cave now holds the promise that they will not belong to Egypt forever.</p><p>Honor the dead as they lived in hope, and let your own life point toward a promised destination. The way we bury those we love can speak as loudly as our living. And whatever land you are currently sojourning in, remember that you are being carried toward a resting place God has sworn - a homeland that will not let you be held forever.</p>",
        "references": [
          "Genesis 50:1-14"
        ]
      },
{
        "day_number": 67,
        "title": "Day 67 - Joseph Reassures His Brothers (Genesis 50:15-21)",
        "content": "<p>With their father dead, the brothers' old guilt resurfaces. They fear Joseph has only been biding his time and will now pay them back for selling him into slavery. They even send a fabricated message pretending Jacob had asked Joseph to forgive them. The news of their fear grieves Joseph, who weeps. Then his brothers bow before him, and he gives one of the most beautiful statements in all of Scripture: Don't be afraid. Am I in the place of God? You intended to harm me, but God intended it for good to accomplish what is now being done, the saving of many lives.</p><p>Joseph refuses the bitterness that entitlement would grant him. He has seen, from the pit to the palace, that God was redeeming the evil done against him. Forgiveness here is not a vague sentiment; it is a settled trust that God can take the worst intentions of others and weave them into good.</p><p>Is there a harm done to you that you have let define you? Forgiveness is not saying the wrong did not matter, nor that you are nothing to God. It is handing the intention and the outcome to the One who is in the place of God. Let Him turn what was meant for harm into the saving of many lives, and set your heart free.</p>",
        "references": [
          "Genesis 50:15-21"
        ]
      },
      {
        "day_number": 68,
        "title": "Day 68 - The Death of Joseph (Genesis 50:22-26)",
        "content": "<p>Joseph lives to see the third generation of his children, and at the age of a hundred and ten he speaks his final words to his family. He reminds them of the promise: God will surely come to your aid and take you up out of this land to the land he promised on oath to Abraham, Isaac and Jacob. And then he makes them swear to carry his bones up out of Egypt with them. He dies and is placed in a coffin in Egypt, waiting in faith for a deliverance he will never see.</p><p>It is a striking way to end the book. Joseph does not ask for a grand Egyptian burial but for his bones, one day, to be carried to the promised land. The prayer of a dying man becomes a treasury of hope for the people of God for generations - the assurance that Egypt is not home and the exodus is coming.</p><p>The book of Genesis closes looking forward. From creation to the cross, from the beginning to a coffin in Egypt, the theme is the same: God keeps His promises. You, too, are living between a promise and its fulfillment. Do not live as if this world were all there is. Carry hope in your bones - the God who began this story will surely come to your aid.</p>",
        "references": [
          "Genesis 50:22-26"
        ]
      }
    ]
  }
]
$plans$::jsonb)
  loop
    v_plan_id := (v_plan ->> 'id')::uuid;

    insert into public.devotional_plans (
      id, title, description, cover_image, completions, tags, status, total_days, author_id, created_at, updated_at
    )
    values (
      v_plan_id,
      v_plan ->> 'title',
      v_plan ->> 'description',
      v_plan ->> 'cover_image',
      0,
      array(select jsonb_array_elements_text(v_plan -> 'tags')),
      'published',
      (v_plan ->> 'total_days')::int,
      null,
      v_now,
      v_now
    )
    on conflict (id) do update
    set title = excluded.title,
        description = excluded.description,
        cover_image = excluded.cover_image,
        tags = excluded.tags,
        status = excluded.status,
        total_days = excluded.total_days,
        updated_at = excluded.updated_at;

    delete from public.scripture_references
    where day_id in (
      select id
      from public.devotional_days
      where plan_id = v_plan_id
    );

    delete from public.devotional_days
    where plan_id = v_plan_id;

    for v_day in
      select value
      from jsonb_array_elements(v_plan -> 'days')
    loop
      insert into public.devotional_days (
        plan_id, day_number, content, title, created_at, updated_at
      )
      values (
        v_plan_id,
        (v_day ->> 'day_number')::int,
        v_day ->> 'content',
        v_day ->> 'title',
        v_now,
        v_now
      )
      returning id into v_day_id;

      insert into public.scripture_references (
        user_id, day_id, reference, created_at, updated_at
      )
      values (
        null,
        v_day_id,
        array(select jsonb_array_elements_text(coalesce(v_day -> 'references', '[]'::jsonb))),
        v_now,
        v_now
      );
    end loop;
  end loop;
end
$$;
-- End Genesis devotion plan.