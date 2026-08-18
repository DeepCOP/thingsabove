-- Public devotional plans for books of the Bible (NIV).
-- The NIV divides each book into sections; each section becomes one plan day
-- with a short 5-10 minute devotional, and the section reference is stored as
-- the day passage (public.scripture_references).
-- Follows the existing seeding migrations, e.g.
-- 20260529120000_add_100_public_domain_devotional_plans.sql. Idempotent upsert.

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
        "content": "<p>Scripture opens with a direct declaration: in the beginning God created the heavens and the earth. Before there was time or matter, before the sun or the sea, God existed. Out of nothing He spoke, and things that had never existed came to be. In the rhythm of evenings and mornings, God is shown working with order and purpose, pausing over each act of creation and calling it good; on the sixth day He forms the man in His own image, blesses him, and gives him vocation and relationship.</p><p><strong>Interpretation/Application:</strong> The crown of creation is not a place but a person. Everything in the opening chapters builds toward God making people to know Him and reflect Him. Take a moment today to reflect on your createdness: you are not an accident of chance but a deliberate, beloved image-bearer. Receive again that good word over your life, and let the One who called light out of darkness speak order into whatever feels formless in you.</p>",
        "references": [
          "Genesis 1:1-2:3"
        ]
      },
      {
        "day_number": 2,
        "title": "Day 2 - Adam and Eve (Genesis 2:4-25)",
        "content": "<p>Scripture zooms in on the garden, a sanctuary where God walks with man. It records God forming Adam from the dust, breathing life into his nostrils, providing a garden of delight, and giving him fruitful work. It records that it is not good for the man to be alone, and so God shapes a companion. Adam and Eve stand before each other, unashamed and whole.</p><p><strong>Interpretation/Application:</strong> In Eden, rest and responsibility go together; work is not a curse but a calling, and marriage is presented as a bond of belonging - leaving, cleaving, becoming one. Relationships are God's design, not an afterthought. God still longs to be near His children. Like Adam, you were made for communion - with God and with others. Do not hide your need; let yourself be known, receive the gift of companionship, and tend the garden He has entrusted to you with diligence and delight.</p>",
        "references": [
          "Genesis 2:4-25"
        ]
      },
      {
        "day_number": 3,
        "title": "Day 3 - The Fall (Genesis 3:1-24)",
        "content": "<p>Scripture records that the serpent asks Eve, Did God really say? He tells her that when she eats of the tree she will be like God, knowing good and evil. She takes the fruit and gives some to Adam, and they eat. Their eyes are opened, they realize they are naked, and they hide from the Lord. God clothes their nakedness and, in the curse on the serpent, declares that the offspring of the woman will crush the serpent's head.</p><p><strong>Interpretation/Application:</strong> The first attack on humanity is not against God's existence but against His character - it sows distrust of God's goodness. In a single choice, mistrust enters, shame follows, and the peace of Eden shatters. Yet even in judgment God is merciful: He does not abandon them, and amid the curse He speaks of a coming offspring who will crush the serpent's head - grace already glimmering in the field of thorns. We still hear that ancient whisper when temptation arises: doubt God, distrust His word, take control. We do not have to find our own way back; God comes looking for us. When shame tempts you to hide, run to Him instead - His mercy is greater than the fall.</p>",
        "references": [
          "Genesis 3:1-24"
        ]
      },
      {
        "day_number": 4,
        "title": "Day 4 - Cain and Abel (Genesis 4:1-16)",
        "content": "<p>Scripture records that two brothers bring offerings to the Lord: Abel's gift is accepted and Cain's is not. God speaks directly to Cain, saying, Why are you angry? Why is your face downcast? If you do what is right, will you not be accepted? But sin is crouching at his door and desires to have him. Cain rises up and kills his brother Abel. The Lord asks Cain, Where is your brother Abel?</p><p><strong>Interpretation/Application:</strong> The difference between the two offerings is not said to be the value of the gift but the condition of the heart. What begins as wounded pride can, if unguarded, harden into something far darker. God's question - Where is your brother? - echoes through the ages: we are our brother's keeper, whether we like it or not. When your offering, your role, or your reward is not what you expected, watch your heart; sin is always crouching at the door. Rather than feeding resentment, bring your raw disappointment to God, who speaks to you as He spoke to Cain - with patience, with warning, and still with the offer of a way.</p>",
        "references": [
          "Genesis 4:1-16"
        ]
      },
      {
        "day_number": 5,
        "title": "Day 5 - Cain's Descendants (Genesis 4:17-26)",
        "content": "<p>After the account of Cain comes a turn: Scripture records that Cain, marked and wandering, still builds a city and fathers a line - those who work in bronze and iron, who raise livestock, who make music. It also records Lamech, who speaks a boast of vengeance far exceeding the harm done to him. Then Adam and Eve have another son, Seth, and Scripture notes that in Seth's time people began to call on the name of the Lord.</p><p><strong>Interpretation/Application:</strong> Even a broken family carries the image of a creative God, and alongside the proud line of human achievement runs a humble line of worship - two ways of living already emerging: one built on human glory and escalating violence, the other on calling on God. Which city are you building? Talent and culture are gifts of God, but they can never substitute for Him. Whatever you are good at, let it be wrapped in the posture that marked Seth's descendants - calling on the name of the Lord.</p>",
        "references": [
          "Genesis 4:17-26"
        ]
      },
      {
        "day_number": 6,
        "title": "Day 6 - From Adam to Noah (Genesis 5:1-32)",
        "content": "<p>Scripture records chapter five as a long roll call of generations - the names, ages, and the repeated phrase, and then he died, of the line from Adam to Noah. Among the names is Enoch, who Scripture says walked faithfully with God and was no more, because God took him; and the list ends with Noah, whose birth, his father says, points toward comfort from the cursed ground.</p><p><strong>Interpretation/Application:</strong> Beneath the repetition, Adam's line is marked by both the image of God and the taint of death, and yet death is not the only thread - God is at work through ordinary, faithful people across generations to prepare a rescue. Your years matter to Him. You may feel like one small name in a long line, but every link matters in God's story. Walk with God today - steadily, faithfully - and let the cadence of your life testify that death does not have the final word.</p>",
        "references": [
          "Genesis 5:1-32"
        ]
      },
      {
        "day_number": 7,
        "title": "Day 7 - Wickedness in the World (Genesis 6:1-8)",
        "content": "<p>Scripture records that when the human race increases, wickedness grows, and that every inclination of the human heart is only evil all the time. The Lord is grieved over His creation. Scripture also says that Noah found favor in the eyes of the Lord, because Noah was righteous and blameless among his people and walked faithfully with God.</p><p><strong>Interpretation/Application:</strong> The God of Genesis is not indifferent; He grieves - judgment is not His delight but His sorrowful response to entrenched evil. Yet in the very same passage grace appears: Noah found favor in the eyes of the Lord; the word behind favor echoes the idea of grace, something undeserved and freely given. Remember that God was not looking for a crowd in Noah's day; He was looking for one faithful heart. Be that person in your own circle - receiving God's grace and lending your life to His purposes rather than to the tide of the times.</p>",
        "references": [
          "Genesis 6:1-8"
        ]
      },
      {
        "day_number": 8,
        "title": "Day 8 - Noah and the Flood (Genesis 6:9-8:22)",
        "content": "<p>Scripture records that Noah was righteous and blameless among his people and walked faithfully with God. When God revealed the coming flood, Noah did everything just as God commanded him, building an ark; in the same chapter God says that a dove returns to the ark with an olive leaf, and that Noah builds an altar to the Lord after the waters recede.</p><p><strong>Interpretation/Application:</strong> Noah's response was not debate but obedience, and building an ark on dry land must have looked foolish to the world, yet it meant life for his whole household. The flood is both judgment on evil and rescue for a remnant - the same waters that washed away corruption carried Noah to a new beginning, and deliverance is met with gratitude and worship. Step into whatever impossible task God has set before you, believing it may one day mean life for your household; and when the storm passes, build an altar and give thanks to the God who remembered you.</p>",
        "references": [
          "Genesis 6:9-8:22"
        ]
      },
      {
        "day_number": 9,
        "title": "Day 9 - God's Covenant With Noah (Genesis 9:1-17)",
        "content": "<p>Scripture records that after the waters, God blesses Noah and his sons, and for the first time the word covenant is used as God binds Himself to a lasting commitment. He sets the rainbow in the clouds as the sign and says, Never again will the waters become a flood to destroy all life.</p><p><strong>Interpretation/Application:</strong> The same God who judged now also shows mercy - the rainbow, placed across the sky after storm, is a visible reminder that judgment will not be the final word, and that God's mercy holds back what His holiness could unleash. Your own story may have its floodwaters - failures, fears, seasons of upheaval. Look for the rainbow. God is a covenant-making God who keeps His word. When you are tempted to think His anger outlasts His love, remember the bow in the clouds: He is not out to destroy you; He is committed to you.</p>",
        "references": [
          "Genesis 9:1-17"
        ]
      },
      {
        "day_number": 10,
        "title": "Day 10 - The Sons of Noah (Genesis 9:18-29)",
        "content": "<p>Scripture records that after his deliverance, Noah plants a vineyard and, in a moment of weakness, becomes drunk and lies uncovered in his tent. Ham sees his father's nakedness and tells his brothers outside, while Shem and Japheth walk in backward with a garment to cover their father. When Noah wakes he speaks a curse and a blessing over his sons' descendants.</p><p><strong>Interpretation/Application:</strong> The scene is strikingly human - even the hero of the flood stumbles - and what follows is not a vindictive burst but a glimpse of how our choices ripple outward: Ham's disrespect becomes a defining memory, while Shem is honored as the line through whom blessing continues. The response of the two brothers shows what love does in the presence of another's shame: it covers rather than exposes. When others stumble, how do you respond? The instinct of the world is to look, to broadcast, to feel superior; love, by contrast, walks backward and covers. Guard your own heart against the pride of the early days of faith, and be the kind of person who protects the dignity of others even when they have fallen.</p>",
        "references": [
          "Genesis 9:18-29"
        ]
      },
      {
        "day_number": 11,
        "title": "Day 11 - The Table of Nations (Genesis 10:1-32)",
        "content": "<p>Scripture widens its lens to take in the whole earth, listing the families of Shem, Ham and Japheth as they spread out, each with its language, clan and territory. It mentions particular individuals such as Nimrod the mighty hunter and builder of cities.</p><p><strong>Interpretation/Application:</strong> This genealogy is not a tedious list but a map of divine generosity - humanity scattering and filling the earth as God promised, diverse yet one family. Behind every name, the biblical story presents real people, and within the global story runs a single thread that will narrow, surprisingly, to one man and one family. Before you dismiss the long list, notice that God sees every nation and every name; no people are beyond His reach or beneath His care. You are part of a vast human family that God is gathering. The same God who scattered these peoples is the God who knows you by name and is working history toward a great reunion.</p>",
        "references": [
          "Genesis 10:1-32"
        ]
      },
      {
        "day_number": 12,
        "title": "Day 12 - The Tower of Babel (Genesis 11:1-9)",
        "content": "<p>Scripture records that humanity, united in one language, decides to build a city and a tower whose top reaches the heavens, to make a name for themselves and avoid being scattered. The Lord comes down, confuses their language so they cannot understand one another, and scatters them across the earth, so they stop building the city.</p><p><strong>Interpretation/Application:</strong> On the surface the project is impressive; underneath it is rebellion - their aim is not to glorify God but to be self-sufficient, to live as if they need nothing from above. Babel teaches us that our grandest efforts to save ourselves will fragment; pride builds towers, humility builds altars. Where is your own tower? It may be a reputation, a security plan, a career, or a relationship organized entirely around yourself. God compassionately interrupts our self-building because He loves us too much to let us live without Him; release your need to make a name for yourself, and let God be your name, your honor, and your true foundation.</p>",
        "references": [
          "Genesis 11:1-9"
        ]
      },
      {
        "day_number": 13,
        "title": "Day 13 - From Shem to Abram (Genesis 11:10-26)",
        "content": "<p>After Babel, Scripture narrows the story once more, following the line of Shem generation by generation until it reaches Terah, and out of his household comes Abram. The names and ages carry the quiet weight of a promise repeated across generations.</p><p><strong>Interpretation/Application:</strong> The genealogy reminds us that God works through the unremarkable, patient accumulation of years - there are no dramatic chapters here, only faithful continuance, and the God who spans all of history works inside the slow, daily progress of an ordinary family. Do not despise the small, seemingly ordinary parts of your story; the years that feel like waiting or repetition may be exactly where God is preparing you for something generations later. The line from Shem to Abram teaches us that God is never in a hurry and never forgets a promise.</p>",
        "references": [
          "Genesis 11:10-26"
        ]
      },
      {
        "day_number": 14,
        "title": "Day 14 - Abram's Family (Genesis 11:27-32)",
        "content": "<p>Scripture introduces Abram in the city of Ur, embedded in a family that carries both promise and pain: Sarai is barren, and Terah sets out with his family toward the land of Canaan but settles in Harran. The section ends with the simple notice that Terah died in Harran.</p><p><strong>Interpretation/Application:</strong> This is honest realism: God's redemptive plan advances through people who are old, who are childless, whose father dies halfway to the destination. Faithfulness does not require a flawless start; it requires a God who keeps moving His people forward even when they stop short. Your own pilgrimage may have detours and unfinished chapters; a dream may seem stalled in Harran, a barrenness may persist. Take heart - Abram's story does not end in Harran, and neither does yours. God is not finished with the family He has called; He will get you the rest of the way.</p>",
        "references": [
          "Genesis 11:27-32"
        ]
      },
      {
        "day_number": 15,
        "title": "Day 15 - The Call of Abram (Genesis 12:1-9)",
        "content": "<p>Scripture records God speaking to Abram: Leave your country, your people and your father's household, and I will make you into a great nation; I will bless you and make your name great, and all peoples on earth will be blessed through you. It records that Abram goes, and that he builds altars at the places the Lord appeared.</p><p><strong>Interpretation/Application:</strong> Without a map or a guarantee, Abram goes - a covenant that will shape history begins with an act of obedient leaving. The posture of it all matters: Abram builds altars and calls on the Lord's name, showing that blessing is not only received but passed on - the point of God's favor being that through Abraham all the families of the earth would be blessed. What is God asking you to leave today - a comfort, a reputation, a familiar place - in order to follow Him? Faith rarely begins with a full picture; it begins with a step. And when you step, build an altar: remember where God met you, and live as a channel of His blessing to the people around you.</p>",
        "references": [
          "Genesis 12:1-9"
        ]
      },
      {
        "day_number": 16,
        "title": "Day 16 - Abram in Egypt (Genesis 12:10-20)",
        "content": "<p>Scripture records that, hard on the heels of his step of faith, a famine drives Abram to Egypt. Fearing for his life, he asks Sarai to say she is his sister; Pharaoh takes her into his household, and only when the Lord afflicts Pharaoh's household with plagues is the deception exposed. Abram is confronted and sent away.</p><p><strong>Interpretation/Application:</strong> The passage is disturbingly honest about the life of faith: the same man who left everything to follow God is here unraveled by fear. What is prominent in the story is not Abram's heroism but God's protection - even through his failure, God guards His promise. Faith does not mean never faltering; it means that God is faithful when we are not. You may have a famine season coming - a crisis that tempts you to grasp, to scheme, to protect your own name. In such moments honesty with God and with others is the way back. Let this passage free you from the guilt of past lapses and teach you to trust God's protection rather than your own maneuvering.</p>",
        "references": [
          "Genesis 12:10-20"
        ]
      },
      {
        "day_number": 17,
        "title": "Day 17 - Abram and Lot Separate (Genesis 13:1-18)",
        "content": "<p>Scripture records that Abram and his nephew Lot find their herds so numerous that the land cannot support them both. Rather than quarrel, Abram offers Lot first choice; Lot looks at the well-watered plain toward Sodom and takes it, leaving Abram the less promising high country.</p><p><strong>Interpretation/Application:</strong> Here we see the quiet strength of humility: Abram does not insist on his rights or leverage his seniority, but trusts that God is his portion and that blessing does not depend on the most fertile-looking plot of ground. His eyes are on the promise, not the pasture. Lot chose by appearance; Abram chose by faith. When you face a decision between the visibly attractive and the faithfully right, remember who cares for you. You can afford to defer, to release advantage, to let God choose your portion - because if God is your shield and reward, no poor-looking choice can rob you.</p>",
        "references": [
          "Genesis 13:1-18"
        ]
      },
      {
        "day_number": 18,
        "title": "Day 18 - Abram Rescues Lot (Genesis 14:1-24)",
        "content": "<p>Scripture records that a coalition of kings sweeps through the region and carries off Lot, now living near Sodom, with his goods. When word reaches Abram, he musters his trained men, pursues the captors, and recovers Lot, the people and the plunder. On his return he meets Melchizedek, king of Salem and priest of God Most High, who blesses him and to whom Abram gives a tenth; the king of Sodom offers him wealth, but Abram refuses it.</p><p><strong>Interpretation/Application:</strong> Faith is not merely contemplative; it is willing to get its hands dirty for others. Abram models both mercy and integrity: he risks himself for a relative who had chosen badly, and he protects the purity of his testimony, determined that no man should say he made Abram rich - he will be dependent on God alone. Ask yourself where you are called to fight for someone who cannot fight for themselves, and where you must refuse a bargain that would dilute your dependence on God.</p>",
        "references": [
          "Genesis 14:1-24"
        ]
      },
      {
        "day_number": 19,
        "title": "Day 19 - God's Covenant With Abram (Genesis 15:1-21)",
        "content": "<p>Scripture records God speaking to Abram in a vision: Do not be afraid, Abram. I am your shield, your very great reward. Yet Abram voices his ache: You have given me no children. Into this wound God speaks the promise of descendants as numerous as the stars, and the text says Abram believed the Lord, and it was credited to him as righteousness. The covenant is then sealed with a solemn ritual, and as Abram falls into a deep sleep God passes between the pieces alone.</p><p><strong>Interpretation/Application:</strong> Faith here is not a feeling but a settled trust in God's word, and the covenant rests not on Abram's capacity but on God's own commitment - God takes the promise upon Himself. When God's timeline outpaces yours, bring the honest ache of your heart to Him as Abram did. And remember whose covenant this is: God bound Himself to you before you could keep your side. Believe Him, and let that belief be counted righteous - resting not in your performance but in His faithfulness.</p>",
        "references": [
          "Genesis 15:1-21"
        ]
      },
      {
        "day_number": 20,
        "title": "Day 20 - Hagar and Ishmael (Genesis 16:1-16)",
        "content": "<p>Scripture records that Sarai, still childless, gives her servant Hagar to Abram as a wife, and Hagar conceives. Sarai despises Hagar, Hagar despises her mistress, and Hagar flees into the desert. There the angel of the Lord meets Hagar, calls her by name, gives her a promise for her son Ishmael, and she names the place, saying, You are the God who sees me.</p><p><strong>Interpretation/Application:</strong> Human schemes to hurry God's promise produce heartbreak, but the desert is not the end - the God of Abraham is also the God of the overlooked and the outcast, who sees the one pushed aside. When you take control of your life because God seems slow, you may reap complications, as Sarai did; yet even our messes are not beyond His reach. If you feel unseen and pushed out, remember Hagar: there is a God who sees you, calls you by name, and promises to be present even in your heartbreak.</p>",
        "references": [
          "Genesis 16:1-16"
        ]
      },
      {
        "day_number": 21,
        "title": "Day 21 - The Covenant of Circumcision (Genesis 17:1-27)",
        "content": "<p>Scripture records that thirteen years later God appears to Abram again: I am God Almighty; walk before me faithfully and be blameless. He renames Abram as Abraham - father of many nations - and Sarai as Sarah, and sets the covenant in the flesh of the household through circumcision. Abraham laughs at the thought of a son in his old age, yet God reaffirms that Sarah herself will bear a son, Isaac.</p><p><strong>Interpretation/Application:</strong> The sign of the covenant is physical, visible and costly, marking every generation and reminding them that relationship with God is not casual but cut into the very fabric of their lives. Covenant is costly; for us the sign is the cross, a body given and blood shed, and a Spirit who marks us as God's own. How do you cultivate the holy habit of belonging? Let the reminder of God's faithfulness be more than memory - let it become a daily, visible commitment of your whole self to walk before Him.</p>",
        "references": [
          "Genesis 17:1-27"
        ]
      },
      {
        "day_number": 22,
        "title": "Day 22 - The Three Visitors (Genesis 18:1-15)",
        "content": "<p>Scripture records that by the great trees at Mamre Abraham welcomes three strangers with lavish hospitality, and Scripture says that in this way people have, without knowing it, shown hospitality to angels. One of the visitors carries an impossible message: about this time next year, Sarah will have a son. Sarah, listening at the tent door, laughs to herself, for she is old; the Lord hears her and asks, Is anything too hard for the Lord?</p><p><strong>Interpretation/Application:</strong> Whatever has died in you - a hope, a relationship, a calling you let go of long ago - hold it up to that question. Your laughter may be the laughter of cynicism or of deferred hope, but God's word remains. Receive His promise with humility and wonder, and let the impossible become the foundation of your expectation. The question that haunts every season of doubt also carries the answer: nothing is too hard for the Lord.</p>",
        "references": [
          "Genesis 18:1-15"
        ]
      },
      {
        "day_number": 23,
        "title": "Day 23 - Abraham Pleads for Sodom (Genesis 18:16-33)",
        "content": "<p>Scripture records that as the visitors prepare to leave, the Lord reveals what He intends for Sodom. Abraham draws near and intercedes: Will you sweep away the righteous with the wicked? Far be it from you! He pleads from fifty down to ten, and each time the Lord assures him that He will spare the city for the sake of the righteous. The text also records that the Lord did not find even ten righteous there.</p><p><strong>Interpretation/Application:</strong> Here we see both the justice and the patience of God, and the privilege of prayer: Abraham does not only believe in God; he talks with Him, counts on His mercy, and intercedes for a wicked city. Prayer is not bending God to our will but aligning us with His mercy, which is broader than we imagine. How often do you draw near to God on behalf of others? Intercede today for the people and places that seem farthest from God - it may be that your prayers are the only restraint between a city and its judgment.</p>",
        "references": [
          "Genesis 18:16-33"
        ]
      },
      {
        "day_number": 24,
        "title": "Day 24 - Sodom and Gomorrah Destroyed (Genesis 19:1-29)",
        "content": "<p>Scripture records that two angels arrive in Sodom and Lot, though entangled in the city's corruption, urges them into his home. The angels pull him back and warn of the coming destruction: Flee so that you may live. The text records that Lot lingers and is rescued only when the angels seize him, and that his wife looks back and becomes a pillar of salt.</p><p><strong>Interpretation/Application:</strong> The story weaves together the terribleness of judgment and the persistence of grace: one who was entangled in sin is still pulled from the fire because God is merciful, and because the prayers of the faithful reach even the least deserving. Where are you lingering, looking back at a life you know must be left behind? Judgment and grace both bid you flee to the mountains. Do not be a Lot who hesitates; run toward life fully, and remember that the God who delivered Lot through the intercession of Abraham is the God who delivers you through a greater intercessor.</p>",
        "references": [
          "Genesis 19:1-29"
        ]
      },
      {
        "day_number": 25,
        "title": "Day 25 - Abraham and Abimelek (Genesis 20:1-18)",
        "content": "<p>Scripture records that Abraham moves into the region of Gerar and, fearing for his life, asks Sarah to say she is his sister; Abimelek takes her. The text records that God warns Abimelek in a dream and protects the promise, that Abimelek acts with more integrity in the situation than Abraham does, and that Abraham confesses his fear.</p><p><strong>Interpretation/Application:</strong> It is humbling to meet the pattern of our own repeated failures - Abraham repeats the very deception he fell into in Egypt, the same unbelief rising at the same pressure point. But notice what is constant: God's commitment does not depend on Abraham's courage. When you recognize an old sin resurfacing, do not despair at the pattern; bring it to God, who forgives and restores again. His covenant with you holds even when your faith wavers.</p>",
        "references": [
          "Genesis 20:1-18"
        ]
      },
      {
        "day_number": 26,
        "title": "Day 26 - The Birth of Isaac (Genesis 21:1-21)",
        "content": "<p>Scripture records that at last the Lord did for Sarah what He had promised: after decades of waiting, against every human possibility, a child is born and named Isaac, and Sarah says that God has brought her laughter. Hagar and Ishmael are then sent away, and once more Scripture records God meeting the outcast in the desert, hearing the boy's cry and promising to make him into a great nation.</p><p><strong>Interpretation/Application:</strong> The impossible promise has become flesh - as God said, it is done - and yet the chapter is seasoned with tension, showing God faithful to both sons, to the son of promise and to the son of the flesh. The birth of Isaac is the answer the whole story has been building toward: God keeps His word. If you are waiting on a promise that seems past hope, hold on; and if you have felt cast out like Hagar, know that God sees your tears and has a plan for your life too. No one is beyond His faithfulness.</p>",
        "references": [
          "Genesis 21:1-21"
        ]
      },
      {
        "day_number": 27,
        "title": "Day 27 - The Treaty at Beersheba (Genesis 21:22-34)",
        "content": "<p>Scripture records that Abimelek comes to Abraham seeking a treaty, saying, God is with you in everything you do. Abraham agrees, and the two make an oath at Beersheba; Scripture records that Abraham plants a tree and calls on the name of the Lord, the Everlasting God.</p><p><strong>Interpretation/Application:</strong> The chapter gives a rare window of peace and stability - the long wanderer, who had so often been on the move, now plants a tree, a gesture of trust that he will remain and that God has given him a place at last. His life has become visible testimony, and even a foreign king recognizes the hand of God upon him. Does the presence of God on your life show? Let your faithfulness at work, at home, and in your community be evident enough that others take notice and want to be near you. Plant roots where God has put you, and call on Him as the Everlasting God.</p>",
        "references": [
          "Genesis 21:22-34"
        ]
      },
      {
        "day_number": 28,
        "title": "Day 28 - Abraham Tested (Genesis 22:1-19)",
        "content": "<p>Scripture records that God said, Take your son, your only son, Isaac, whom you love, and sacrifice him there as a burnt offering. Abraham rises early and goes. To Isaac's question, where is the lamb?, Abraham answers, God himself will provide the lamb. At the last moment the angel calls out, and Abraham sees a ram caught in the thicket; he names the place The Lord Will Provide.</p><p><strong>Interpretation/Application:</strong> This is the deepest test of trust, and its resolution reveals the heart of the whole Bible: Abraham holds nothing back from God, and God holds nothing back from the world - years later giving His own Son on a hill, the lamb provided at last. Is there anything you are unwilling to entrust to God? Faith does not demand that you know the outcome, only that you trust the One who does. Bring your dearest treasure to Him, and be ready to discover the ram in the thicket - that God has provided what you could not imagine.</p>",
        "references": [
          "Genesis 22:1-19"
        ]
      },
      {
        "day_number": 29,
        "title": "Day 29 - Nahor's Sons (Genesis 22:20-24)",
        "content": "<p>Scripture records that after the moment on Mount Moriah, word reaches Abraham that his brother Nahor has children - among them a girl named Rebekah, who will become a key figure in the covenant story that follows.</p><p><strong>Interpretation/Application:</strong> The dramatic peak of chapter twenty-two gives way to a quiet family report that, to an untrained eye, might seem a footnote; but in the biblical story it is a bridge, introducing the girl who will become Isaac's wife, through whom the promise continues. Never discount the small and the unremarkable, for God's great purposes often travel along uncelebrated roads. The life you may think is only a footnote is woven into a larger story you cannot yet see. Tend your family relationships and your quiet faithfulness - God is writing His story in them.</p>",
        "references": [
          "Genesis 22:20-24"
        ]
      },
      {
        "day_number": 30,
        "title": "Day 30 - The Death of Sarah (Genesis 23:1-20)",
        "content": "<p>Scripture records that Sarah dies at Kiriath Arba and that Abraham comes to mourn and to weep for her. Owning no land in the country God had promised him, he insists on paying full price for a burial plot - the cave of Machpelah - refusing even a gift so that the land would genuinely be his, and there he buries Sarah.</p><p><strong>Interpretation/Application:</strong> The chapter is a study in faith touching the ground of grief: Abraham mourns openly, yet he acts in the settled confidence of the promise, purchasing a foothold in the land God had pledged and burying Sarah there as a down payment on a future he would not see. Faith does not deny the tears of loss; it gives them a horizon. When you face loss, you may feel like a sojourner with nothing you can truly call your own; yet even your grief can be placed in the territory of God's promises. Mourn fully, but let your sorrow be anchored in hope - the hope that the same God who gave a land will give resurrection.</p>",
        "references": [
          "Genesis 23:1-20"
        ]
      },
      {
        "day_number": 31,
        "title": "Day 31 - Isaac and Rebekah (Genesis 24:1-67)",
        "content": "<p>Scripture records that Abraham sends his trusted servant to find a wife for Isaac from his own kindred. At the well the servant prays for a sign, and before he finishes, Rebekah appears and shows the very hospitality he had asked for. The servant bows and worships; Rebekah and her family consent; and when Rebekah sees Isaac in the field, she dismounts and covers herself with her veil.</p><p><strong>Interpretation/Application:</strong> It is a chapter of answered prayer and yielded obedience, moving with the quiet confidence that God is guiding - the covenant line is passed on through an ordinary act of trust: a prayer at a well, a girl with a water jar, a servant who told God his request. For decisions large and small, you can bring your way before God and trust Him to guide. Pray specifically, act with integrity, and leave room for the divine yes. And learn from Isaac and Rebekah - when God brings you to the right place and person, receive it with joy and be comforted.</p>",
        "references": [
          "Genesis 24:1-67"
        ]
      },
      {
        "day_number": 32,
        "title": "Day 32 - The Death of Abraham (Genesis 25:1-18)",
        "content": "<p>Scripture records that Abraham marries again and has more children, but gives everything he owns to Isaac, the son of promise, while sending the other sons away with gifts. Then, at a good old age, Abraham dies and is gathered to his people, and his sons Isaac and Ishmael bury him in the cave of Machpelah beside Sarah. The text also lists Ishmael's descendants.</p><p><strong>Interpretation/Application:</strong> The close of Abraham's life affirms the faithfulness of God to an ordinary man who became the father of nations, and the record of Ishmael's descendants shows God keeping His promise to Hagar's son as well - every branch of the family tree stands under God's care. Your life, too, will one day be a completed chapter; what will remain is not the size of your name but your faithfulness to the promise you lived by. Leave a clear inheritance of what matters, make peace where you can, and let your final years be a testimony that God has been with you in everything you did.</p>",
        "references": [
          "Genesis 25:1-18"
        ]
      },
      {
        "day_number": 33,
        "title": "Day 33 - Jacob and Esau (Genesis 25:19-34)",
        "content": "<p>Scripture records that Rebekah's pregnancy is difficult, and that God tells her two nations are in her womb and the older will serve the younger. Esau is born first, hairy and strong, a hunter; Jacob comes out grasping his heel. Then, in a moment of hungry exhaustion, Esau sells his birthright to Jacob for a bowl of stew, and the text says Esau despised his birthright.</p><p><strong>Interpretation/Application:</strong> The story is a study in trading lasting worth for immediate satisfaction - Esau despises his birthright and later finds no place for repentance though he seeks it with tears. Jacob, for his part, is no saint; he takes advantage of his brother's weakness. Yet God's purpose runs through both their failures, working out the promise of the older serving the younger. Do you sometimes sell the precious for the immediate - your integrity for approval, your future for comfort, your calling for convenience? Like Esau, we are all one hungry moment away from folly in desperate haste. Go before God with your appetites, and treasure what cannot be bought back.</p>",
        "references": [
          "Genesis 25:19-34"
        ]
      },
      {
        "day_number": 34,
        "title": "Day 34 - Isaac and Abimelek (Genesis 26:1-33)",
        "content": "<p>Scripture records that a famine drives Isaac to Gerar and that the Lord appears to him, repeating the promise made to Abraham: I will be with you and will bless you. Isaac reopens the wells his father had dug, and time and again he digs a well and the herdsmen quarrel over it, so he moves on and digs again, until at last the Lord appears to him and says, I am the God of your father Abraham; do not be afraid. Abimelek then comes to him saying, We saw clearly that the Lord was with you.</p><p><strong>Interpretation/Application:</strong> The center of the chapter is a story of perseverance in the dry places - sometimes the faithful path is simply to keep digging, quietly, refusing to fight for what God will give. Persistency in obedience is its own testimony. When your wells are disputed, keep digging in faith, and let God be the one to vindicate you.</p>",
        "references": [
          "Genesis 26:1-33"
        ]
      },
      {
        "day_number": 35,
        "title": "Day 35 - Jacob Gets Isaac's Blessing (Genesis 27:1-40)",
        "content": "<p>Scripture records that Isaac, old and blind, intends to give his blessing to Esau, the eldest. Rebekah, who knows the promise is for Jacob, orchestrates a deception: Jacob covers himself with goatskins and his brother's clothing, lies to his father, and receives the blessing meant for Esau. When Esau discovers it, his plea - bless me too, my father - meets only grief, and Scripture records that Isaac trembles violently.</p><p><strong>Interpretation/Application:</strong> The chapter shows the mess of a family trying to manage God's promise by their own scheming. Jacob gains the blessing but at the cost of a broken brother and a lifetime of running; God's purposes cannot be stopped, but our methods of grasping can wound deeply. When we believe God's timing is slow, temptation whispers to scheme, deceive and take control; but God does not need our lies to fulfill His word. Ask Him to search out the places where you are grasping through manipulation, and trust that His blessing comes to those who wait on Him instead of taking matters into their own hands.</p>",
        "references": [
          "Genesis 27:1-40"
        ]
      },
      {
        "day_number": 36,
        "title": "Day 36 - Jacob Flees to Laban (Genesis 27:41-28:9)",
        "content": "<p>Scripture records that Esau resolves to kill Jacob once their father dies, and that Rebekah, hearing of it, sends Jacob away to her family in Paddan Aram. His parents charge him to find a wife from their own people, keeping the covenant line in view.</p><p><strong>Interpretation/Application:</strong> The man who stole a blessing is now a fugitive, fleeing the anger he earned - a man whose cunning has cost him his home, holding a blessing he seized by deceit as a man on the run. It is a sober reminder that what we gain through our own schemes often comes wrapped in loss. It is tempting to think we can secure God's favor by our cleverness, but God's discipline in Jacob's life is gentle and persistent. If you are living with the aftermath of an unwise or dishonest choice, do not let shame keep you from the road God has for you; He who disciplined Jacob will meet you too, often most powerfully at your lowest point.</p>",
        "references": [
          "Genesis 27:41-28:9"
        ]
      },
      {
        "day_number": 37,
        "title": "Day 37 - Jacob's Dream at Bethel (Genesis 28:10-22)",
        "content": "<p>Scripture records that Jacob, a homeless fugitive, lays his head on a stone in the open country and in a dream sees a ladder resting on the earth with its top reaching to heaven, with angels ascending and descending on it. Above it stands the Lord, who repeats the promises made to Abraham and adds, I am with you and will watch over you wherever you go. Jacob wakes and declares, Surely the Lord is in this place.</p><p><strong>Interpretation/Application:</strong> The God of the sanctuary meets His man in the wilderness, on the run and emptied of everything; a staircase of grace connects heaven and earth, and the gospels tell us Jesus Himself is the one on whom the angels ascend and descend. Have you ever felt at your lowest, a stone for a pillow? It is often there - not in the well-ordered sanctuary but in the wilderness of our failure - that God draws near with a word of presence. He meets you where you are, and His promise is not revoked by your flight. There is a ladder between God and you, and it is held by Jesus Himself.</p>",
        "references": [
          "Genesis 28:10-22"
        ]
      },
      {
        "day_number": 38,
        "title": "Day 38 - Jacob Arrives in Paddan Aram (Genesis 29:1-30)",
        "content": "<p>Scripture records that Jacob comes to a well and meets Rachel, his cousin, and agrees to serve Laban seven years for her; the text says the years seemed like only a few days to him because of his love. But Laban deceives the deceiver, and on the wedding night Jacob discovers it is Leah he has married, and he must work another seven years for Rachel.</p><p><strong>Interpretation/Application:</strong> The tables have turned - the man who tricked his father is now tricked by his uncle, and he tastes the bitterness of being deceived. Yet the chapter is not without mercy: Leah, unloved, is the one God sees, and she will become the mother of Judah, through whom the Savior comes. When our own past deceptions boomerang, it is easy to feel we are only reaping what we sowed; but notice how God weaves grace even into the trickery of Laban's household. However you have been treated or have treated others, God sees you and can bring life from the wounded places.</p>",
        "references": [
          "Genesis 29:1-30"
        ]
      },
      {
        "day_number": 39,
        "title": "Day 39 - Jacob's Children (Genesis 29:31-30:24)",
        "content": "<p>Scripture records that the account of Jacob's growing family is shadowed by rivalry: Leah, unloved, and Rachel, barren, compete, and each wife names her children out of her own ache - Leah, the Scripture says, finds hope in the Lord who saw her misery; Rachel cries out, Give me children, or I will die.</p><p><strong>Interpretation/Application:</strong> Into this turbulent family the covenant advances - a messy genealogy full of envy and manipulation, yet out of it come the twelve tribes of Israel. God is not embarrassed by the tangled families He works with; He brings life and purpose out of our competing desires and disappointments. Your own family tree may have rivalry, brokenness, and barren seasons. Do not conclude that God is absent from it; He specializes in naming children of hope from wombs of grief. Trust Him with the parts of your story that are competitive or empty, and look for how He is bringing fruitfulness even where you see only trouble.</p>",
        "references": [
          "Genesis 29:31-30:24"
        ]
      },
      {
        "day_number": 40,
        "title": "Day 40 - Jacob's Flocks Increase (Genesis 30:25-43)",
        "content": "<p>Scripture records that Jacob, having served his time, asks to leave. Laban, seeing that the Lord has blessed him because of Jacob, urges him to stay, and they strike an unusual arrangement: Jacob will keep the streaked and spotted and dark animals as his wages. The text says the stronger animals produce the sort that belong to Jacob, so that he grows exceedingly prosperous while Laban's herds dwindle.</p><p><strong>Interpretation/Application:</strong> The chapter shows a shrewd man working the system, yet Scripture is clear that the true source is God - the blessing does not come from Jacob's cleverness alone but from the God of his father being with him. We may scheme and strive and outmaneuver, but the One who causes the flock to increase is God. When you prosper, do not imagine it is only your effort; give the growth to God, hold your success loosely, and let prosperity form gratitude rather than pride in you, for blessing is a stewardship from Him.</p>",
        "references": [
          "Genesis 30:25-43"
        ]
      },
      {
        "day_number": 41,
        "title": "Day 41 - Jacob Flees From Laban (Genesis 31:1-55)",
        "content": "<p>Scripture records that Laban's sons grumble that Jacob has taken everything, and that the Lord tells Jacob, Go back to the land of your fathers. Jacob gathers his family and flocks and slips away; Rachel, unknown to Jacob, has taken her father's household gods, and when Laban catches up there is a tense confrontation beside a pile of stones.</p><p><strong>Interpretation/Application:</strong> The text records that God speaks to Laban in a dream, warning him not to harm Jacob, and that the pair are sent away in peace, each wary of the other but bound by a covenant of mutual restraint. Sometimes God calls us to leave situations that have grown toxic and envious, even when the leaving is complicated; the same God who told Jacob to go promises to go with him. Releasing an old tension that can never be truly healed is not failure; it is wisdom. Let God be your defense when there is no human judge who can see the whole truth.</p>",
        "references": [
          "Genesis 31:1-55"
        ]
      },
      {
        "day_number": 42,
        "title": "Day 42 - Jacob Prepares to Meet Esau (Genesis 32:1-21)",
        "content": "<p>Scripture records that after twenty years away, Jacob must finally face the brother he wronged. Messengers return with news that Esau is coming with four hundred men, and Jacob is filled with dread. He splits his camp as a safeguard and then prays, I am unworthy of all the kindness and faithfulness you have shown your servant; save me, I pray, from the hand of my brother. He also sends wave after wave of gifts ahead to calm Esau.</p><p><strong>Interpretation/Application:</strong> It is a portrait of a man caught between trust in God and his own frantic management, covering every angle because the fear is so real. When the person we have wronged stands before us, no gift or strategy can quite quiet the heart - only honest prayer can. Bring your unworthiness to God as Jacob did; weakened and exposed, you are in the best place to discover that God is your only sufficient defense against the consequences you deserve.</p>",
        "references": [
          "Genesis 32:1-21"
        ]
      },
      {
        "day_number": 43,
        "title": "Day 43 - Jacob Wrestles With God (Genesis 32:22-32)",
        "content": "<p>Scripture records that that night Jacob sends his family across the ford and is left alone. A man wrestles with him until daybreak; the man dislocates Jacob's hip with a touch, and yet Jacob will not let him go. When the man asks Jacob's name, Jacob confesses it, and the man declares: Your name will no longer be Jacob, but Israel, because you have struggled with God and with humans and have overcome.</p><p><strong>Interpretation/Application:</strong> Jacob limps away with a new name, a changed man, marked for life. He had asked God to save him, and the answer came as a fight in the dark; grace does not always arrive gently - sometimes it grips us, wounds us, and refuses to let us go until we yield every claim to our own strength. What are you wrestling with tonight? It may be that God Himself is in the struggle, seeking not your defeat but your transformation. Do not let go until He blesses you; it is better to enter the day crippled and named by God than to cross it self-sufficient and unchanged. His blessing often leaves a mark, but the mark is glory.</p>",
        "references": [
          "Genesis 32:22-32"
        ]
      },
      {
        "day_number": 44,
        "title": "Day 44 - Jacob Meets Esau (Genesis 33:1-20)",
        "content": "<p>Scripture records that Jacob looks up and sees Esau coming with four hundred men, and he places the maidservants and children first, then Leah and Rachel, keeping himself behind. But Esau runs to meet him, embraces him, throws his arms around his neck, kisses him, and they weep. Jacob says to him, To see your face is like seeing the face of God.</p><p><strong>Interpretation/Application:</strong> The reunion is startlingly gracious - Esau, who had once planned to kill his brother, receives Jacob with open arms, and Jacob, humbled and limping, can barely believe it. The one who had feared to meet his brother meets instead a face of undeserved mercy. Is there a broken relationship you have rehearsed as a battlefield only to find it could be a reunion? Sometimes the fears that grip us most are the very ones God dissolves in an embrace. Offer and receive forgiveness freely, and do not let old offenses keep you at a distance from those God has reconciled to you.</p>",
        "references": [
          "Genesis 33:1-20"
        ]
      },
      {
        "day_number": 45,
        "title": "Day 45 - Dinah and the Shechemites (Genesis 34:1-31)",
        "content": "<p>Scripture records that Dinah, the daughter of Jacob, is forced by Shechem; learning of it, her brothers are filled with grief and fury. They deceive the whole city into circumcision and then, while the men are recovering, Simeon and Levi kill them and take Dinah back.</p><p><strong>Interpretation/Application:</strong> It is a dark and troubling chapter, and the Bible does not soften it - the sin of Shechem is met not with justice but with disproportionate and deceptive violence, and the household's name is left in ruin. The account forces us to sit with the reality that even the people of the promise commit terrible wrongs in the name of defending honor; it warns us that bloodshed never restores what sin has taken, and it stirs us to grieve the ways we cannot undo the damage we cause. Bring such sorrow before God; He is not frightened by our brutality and longs to heal what has been broken.</p>",
        "references": [
          "Genesis 34:1-31"
        ]
      },
      {
        "day_number": 46,
        "title": "Day 46 - Jacob Returns to Bethel (Genesis 35:1-15)",
        "content": "<p>Scripture records that God says to Jacob, Go up to Bethel and settle there, and build an altar there to God, who appeared to you when you were fleeing from your brother. Jacob responds by putting away the foreign gods in his household and purifying his family, and there God renews the promise and the name Israel.</p><p><strong>Interpretation/Application:</strong> Bethel - the house of God - was the site of Jacob's ladder, his lowest point elevated by grace; now, years later, he is called back to remember, and the return is marked by worship and cleansing, a resetting of the house around the God who had met him in the wilderness when he had nothing to offer. Do you have a Bethel - a place where God met you at your lowest? The discipline of return is one of the most healing we can practice. Go back to the place of your first love, offer your life afresh, and lay aside the gods that have gathered in your house. God is still there, still promising, still ready to renew your name.</p>",
        "references": [
          "Genesis 35:1-15"
        ]
      },
      {
        "day_number": 47,
        "title": "Day 47 - The Deaths of Rachel and Isaac (Genesis 35:16-29)",
        "content": "<p>Scripture records that Rachel, the beloved wife, dies giving birth to Benjamin and names him in her last breath, and that Jacob sets up a pillar over her grave. It also records that Isaac then dies, and that his sons Esau and Jacob bury him together beside Sarah in the cave of Machpelah.</p><p><strong>Interpretation/Application:</strong> There is an aching tenderness here: the family that has been so torn by rivalry comes together at last, united by grief and by the quiet dignity of burial - loss gathers even the estranged. Grief is the great equalizer, and it can also be the great reconciler. When you lose one you love, do not rush past the sorrow or let it fester into bitterness; lay a pillar of remembrance, let the tears come, and allow your losses, in their way, to draw you closer to the family and the God who remain. Death is still not the final word - for them or for you.</p>",
        "references": [
          "Genesis 35:16-29"
        ]
      },
      {
        "day_number": 48,
        "title": "Day 48 - Esau's Descendants (Genesis 36:1-43)",
        "content": "<p>Scripture records that before the story turns from Esau to Joseph, it pauses to list the descendants of Esau - now called Edom: a long list of sons, chiefs, and kings of Edom, established in the hill country before Israel had a king.</p><p><strong>Interpretation/Application:</strong> The genealogy shows that Esau, though he lost the birthright, was blessed by God with a fruitful and powerful line; this extended chapter honors the promise to Esau even as the main narrative presses toward Jacob. Not every branch of the family walks the central covenant road, and yet God is faithful to the branches He set aside. Do not assume that because your story is not the central one, God has forgotten you; He is gracious to all whom He has made. You may feel like a footnote in another's life, but you are a chapter in God's. Serve faithfully in the place He has given you, and trust that His blessing reaches every family line He has scattered.</p>",
        "references": [
          "Genesis 36:1-43"
        ]
      },
      {
        "day_number": 49,
        "title": "Day 49 - Joseph's Dreams (Genesis 37:1-36)",
        "content": "<p>Scripture records that the saga of Joseph begins with favor and jealousy: he is the son of Jacob's old age, loved above his brothers and given an ornate robe. His dreams - of sheaves and stars bowing before him - inflame the envy until his brothers strip him of the robe, throw him into a cistern, and sell him to merchants bound for Egypt; they deceive their father into thinking he has been devoured by a wild animal.</p><p><strong>Interpretation/Application:</strong> There is almost nothing comforting in the scene except the betrayal itself, yet hidden in the wreckage is the working of God, who will take an evil intended against His servant and use it to save many alive - the robe is torn, but the dream is not dead. Betrayal stains some of our deepest stories, and we may wonder where God is in them; remember Joseph, for the favor of God on your life will draw envy, but it will also be the thing that carries you. You do not have to orchestrate the ending; the God who gave the dream is still watching that pit, and He is not finished.</p>",
        "references": [
          "Genesis 37:1-36"
        ]
      },
      {
        "day_number": 50,
        "title": "Day 50 - Judah and Tamar (Genesis 38:1-30)",
        "content": "<p>Scripture records that the narrative turns from Joseph in Egypt to tell the story of Judah. Judah marries and has sons; the eldest dies, and Tamar his widow is denied each of the next sons in turn, her rights under family custom neglected. In her desperation she traps Judah by disguise and conceives, later producing proof of his identity; Judah is confronted and confesses, She is more righteous than I.</p><p><strong>Interpretation/Application:</strong> It is a sordid tale - sexual deceit, broken oaths, family failure - yet out of Tamar's bold and wounded integrity comes Perez, an ancestor of David and ultimately of Jesus. The gospel does not sanitize the family tree; it enters through a lineage of the broken and the reclaimed. We should not sanitize it either. God can take a story laced with shame and turn it into the saving line; if your past holds episodes you are ashamed to speak, the Redeemer does not come swaddled in a spotless ancestry - He is willing to be named with the Tamars and the Judahs. Bring your whole story to Him, and let it become part of His.</p>",
        "references": [
          "Genesis 38:1-30"
        ]
      },
      {
        "day_number": 51,
        "title": "Day 51 - Joseph and Potiphar's Wife (Genesis 39:1-23)",
        "content": "<p>Scripture records that in Egypt Joseph is sold to Potiphar, an officer of Pharaoh, and that the Lord is with him so that he prospers and is put in charge of the household. When Potiphar's wife urges him to lie with her, Joseph refuses, saying, How then could I do such a wicked thing and sin against God? Falsely accused, he is thrown into prison, and the text notes that the Lord was with Joseph even in prison.</p><p><strong>Interpretation/Application:</strong> The chapter is a window into integrity when no one is looking and when the cost is high: Joseph chooses faithfulness over advantage, and though it costs him years, Scripture keeps underscoring that the Lord was with him, giving him success in whatever he did. You may sometimes wonder if your refusal to compromise matters when the payoff for bending seems great and no one will know; Joseph's life is the answer - the Lord does know, and His presence is the truest definition of success. Choose faithfulness for God's sake, and trust Him with the outcome, even when the prison seems to say otherwise.</p>",
        "references": [
          "Genesis 39:1-23"
        ]
      },
      {
        "day_number": 52,
        "title": "Day 52 - The Cupbearer and the Baker (Genesis 40:1-23)",
        "content": "<p>Scripture records that two of Pharaoh's officials - the chief cupbearer and the chief baker - are thrown into the prison where Joseph is, and that both have troubling dreams. Seeing their dejection, Joseph asks why they are so sad; when they say no one can interpret the dreams, Joseph answers, Do not interpretations belong to God? Tell me your dreams. He interprets them accurately, and both come true exactly as he said; but the cupbearer, restored to his post, forgets Joseph.</p><p><strong>Interpretation/Application:</strong> Too often we rely on human memory, and it fails us; but the lesson of the chapter is that God has not forgotten, even when people do. When your name is overlooked and your faithfulness goes unremembered, do not let hope die - the Bible narrates the delay without despair because God is still writing. Sooner or later, on His clock, the dream will be remembered, and your waiting is part of the story He is still telling.</p>",
        "references": [
          "Genesis 40:1-23"
        ]
      },
      {
        "day_number": 53,
        "title": "Day 53 - Pharaoh's Dreams (Genesis 41:1-36)",
        "content": "<p>Scripture records that two full years pass, and Pharaoh dreams of fat and thin cows and of full and scorched heads of grain, and none of Egypt's magicians can interpret them. Then the cupbearer remembers Joseph. Brought from the dungeon and put before Pharaoh, Joseph says he cannot interpret apart from God, and through God he unfolds the dreams: seven years of abundance followed by seven years of famine. He then advises Pharaoh to appoint a discerning man to store grain during the good years.</p><p><strong>Interpretation/Application:</strong> Joseph does more than interpret; he gives counsel that displays both wisdom and humility, and the dreaming prisoner becomes the wise counselor of a kingdom. God uses waiting seasons to prepare us for assignments we cannot yet see; the two years in the dungeon were not wasted, but shaped the man who could stand calm before the king. If your waiting feels endless, trust that God is preparing you for the moment of remembrance. When it comes, give Him the glory and let your wisdom serve the moment.</p>",
        "references": [
          "Genesis 41:1-36"
        ]
      },
      {
        "day_number": 54,
        "title": "Day 54 - Joseph in Charge of Egypt (Genesis 41:37-57)",
        "content": "<p>Scripture records that Pharaoh recognizes the spirit of God in Joseph and sets him over all Egypt, second only to the throne, giving him an Egyptian name and a wife. Joseph, now thirty, stores up grain through the seven years of plenty, and when the famine spreads there is grain in Egypt for all the world.</p><p><strong>Interpretation/Application:</strong> The story turns on a quiet truth: the man who was sold as a slave is now clothed in royal robes - not through self-promotion but through faithful stewardship at every stage, the same character that marked him in the dungeon governing him in the palace. God's exaltation came after years of proving faithful with what was small and hidden. Do you tend the small responsibilities God has placed before you as if they were the palace? The diligence you show now is the training for the responsibility God may give you later. Do not despise the seasons of storing and waiting and obeying; they are the assembly where God equips you for the work He intends.</p>",
        "references": [
          "Genesis 41:37-57"
        ]
      },
      {
        "day_number": 55,
        "title": "Day 55 - Joseph's Brothers Go to Egypt (Genesis 42:1-38)",
        "content": "<p>Scripture records that, emboldened by the famine, Jacob sends his sons to Egypt for grain. They bow before its governor - unknowingly fulfilling Joseph's dream of the sheaves - and Joseph recognizes his brothers. He tests them harshly, accusing them of being spies, keeping Simeon, and demanding that they return with their youngest brother Benjamin. Overhearing them speak in their own tongue, he hears them say, Surely we are being punished because of our brother, and Joseph turns aside and weeps.</p><p><strong>Interpretation/Application:</strong> The brothers, whose conscience has been slumbering for years, are suddenly awakened, and Joseph's tears show that the wounds of the past are still tender. Guilt has a long memory, and it is often God's servant in our lives, bringing us to the point of confession long after the deed; the famine of circumstances can be the very thing that makes us finally face what we have buried. Do not resist the discomfort that surfaces your hidden sins; let it drive you toward the grace that alone can pardon and heal them.</p>",
        "references": [
          "Genesis 42:1-38"
        ]
      },
      {
        "day_number": 56,
        "title": "Day 56 - The Second Journey to Egypt (Genesis 43:1-34)",
        "content": "<p>Scripture records that the famine presses on and the grain from the first journey runs out. Jacob resists sending Benjamin, but Judah steps forward with a pledge: I myself will guarantee his safety; you can hold me personally responsible for him. At last Jacob relents, and the brothers return to Egypt bearing gifts and double the silver; this time the governor receives them with hospitality, seating them in order of their birth and astonishing them with his insight.</p><p><strong>Interpretation/Application:</strong> The chapter is marked by the quiet rise of Judah, who took on risk and leadership, and we see Joseph, still masked to his brothers, moved with longing and unable to contain himself until the right moment. Note how a measure of responsibility moves a relationship forward: Judah risked his own place for his father and brother, and the door began to open. Sometimes we are the ones called to guarantee the safety of those who stumble. Take that role seriously, even when it costs you, and trust God to be working the reunion you cannot yet see.</p>",
        "references": [
          "Genesis 43:1-34"
        ]
      },
      {
        "day_number": 57,
        "title": "Day 57 - A Silver Cup in a Sack (Genesis 44:1-34)",
        "content": "<p>Scripture records that Joseph stages one more test: he hides his silver cup in Benjamin's sack and sends his brothers on their way, only to have his steward overtake them and accuse them of theft. When the cup is found, the brothers return to Joseph, and Judah pleads, Let the boy go back with his brothers; I will remain as your servant. He is willing to take Benjamin's place to spare his father's grief.</p><p><strong>Interpretation/Application:</strong> Judah, who once sold a brother for silver, now offers himself for a brother - and his intercession, take me instead, is a shadow of a greater substitution yet to come, for the salvation of the family will hinge on someone willing to stand in another's place. Would you stand in another's place? Judah's selfless speech moves the story toward its climax because sacrificial love is what finally breaks estrangement; and in it we see, dimly, the One who would one day say to the Father: let him go free, I will take his place. Let that love shape how you plead for others today.</p>",
        "references": [
          "Genesis 44:1-34"
        ]
      },
      {
        "day_number": 58,
        "title": "Day 58 - Joseph Makes Himself Known (Genesis 45:1-28)",
        "content": "<p>Scripture records that Joseph can contain himself no longer: he orders everyone out and, weeping so loudly that all Egypt hears, reveals himself to his brothers - I am Joseph! They are terrified and speechless, but Joseph lifts them up: Do not be distressed and do not be angry with yourselves for selling me here, because it was to save lives that God sent me ahead of you. Then he falls on their necks and weeps, and they talk together as family again.</p><p><strong>Interpretation/Application:</strong> Here is the gospel in miniature: the one who was wronged chooses not revenge but reconciliation, and he frames the whole betrayal as part of God's saving purpose - a sovereignty large enough to work even through human evil. Is there a wound you have resisted the urge to reconcile? Extending and receiving forgiveness is not the same as pretending the wrong never happened; it is refusing to let it have the last word. Like Joseph, you can choose to forgive because you trust the God who works through what others meant for harm.</p>",
        "references": [
          "Genesis 45:1-28"
        ]
      },
      {
        "day_number": 59,
        "title": "Day 59 - Jacob Goes to Egypt (Genesis 46:1-34)",
        "content": "<p>Scripture records that Jacob sets out with all he has, and at Beersheba he offers sacrifices to the God of his father Isaac. There God speaks to him in a vision: Do not be afraid to go down to Egypt, for I will make you into a great nation there, and I will surely bring you back again. Reassured, the aging patriarch goes down with his whole household, and the chapter lists the descendants who make the journey - seventy persons.</p><p><strong>Interpretation/Application:</strong> The journey is as much about trust as about travel: Jacob clings to the promise that God will bring his family back, and when he stands before Joseph - the son he had mourned as dead - his response is the settled joy of a man with little left to lose: Now I am ready to die, since I have seen for myself that you are still alive. Sometimes God asks us to go places that seem like departure from His promise - yet He goes with us. Lay your need before Him at the altar as Jacob did, and hear His word: do not be afraid. And notice the reunion you may have long given up on; God specializes in restoring what we thought was gone forever.</p>",
        "references": [
          "Genesis 46:1-34"
        ]
      },
      {
        "day_number": 60,
        "title": "Day 60 - Joseph and His Family Settle in Goshen (Genesis 47:1-12)",
        "content": "<p>Scripture records that Joseph presents his family to Pharaoh, and his brothers - though shepherds, an occupation detested in Egypt - are granted the land of Goshen, the best of the land. Joseph ushers his elderly father into Pharaoh's presence, and Jacob blesses Pharaoh.</p><p><strong>Interpretation/Application:</strong> The family of promise, once threatened with famine, is now settled and provided for in the midst of a pagan empire - and notice that the aging father, dependent and frail, still blesses the great king. In God's economy the weakest can carry the greatest authority, because blessing flows from God through His people to the nations. Do you feel too old or too small to matter in the grand scheme? Jacob's example says otherwise - even in your seasons of dependence you carry blessing for those around you. Do not underestimate the quiet power of your prayers and your presence; God has placed you where you are to be a channel of His favor, however unimpressive it may look.</p>",
        "references": [
          "Genesis 47:1-12"
        ]
      },
      {
        "day_number": 61,
        "title": "Day 61 - Joseph and the Famine (Genesis 47:13-26)",
        "content": "<p>Scripture records that the famine grows severe and Joseph's management sustains the land. When the people's silver runs out, they trade their livestock for grain; when that is gone, they sell their land and finally themselves, becoming Pharaoh's servants. Joseph supplies them with seed in exchange for a fifth of the harvest, and the people respond, You have saved our lives.</p><p><strong>Interpretation/Application:</strong> The chapter records the consolidation of Pharaoh's power, and a modern reader may wince at what looks like economic entrenchment; yet the narrative emphasis falls on provision in crisis - that through Joseph, God saved many people alive, even as their circumstances changed. Provision is a form of ministry: not everyone is called to rescue at a dramatic moment, but everyone can steward resources and gifts for the good of others in hard times. Ask how your abundance - of money, time, insight, or influence - could become seed for someone facing their own famine. Generosity is God's way of saving lives.</p>",
        "references": [
          "Genesis 47:13-26"
        ]
      },
      {
        "day_number": 62,
        "title": "Day 62 - Jacob's Final Request (Genesis 47:27-31)",
        "content": "<p>Scripture records that Jacob, now near the end, lives in Egypt seventeen more years, and summons Joseph and makes him swear that he will not bury him in Egypt but will carry his body up to the cave of Machpelah, beside Abraham and Sarah and Isaac and Rebekah. Joseph swears it, and Israel bows in worship at the head of his bed.</p><p><strong>Interpretation/Application:</strong> The request is laden with faith - an old man in a rich land could have accepted an Egyptian burial, but Jacob wants to be laid in the burial-place of the promise, staking even his burial on the future God promised. Faith, for him, reaches all the way down to where his bones will rest. How far does your faith extend? Jacob's reach into the grave is a whole-lifetime trust that God's word is true. Die with hope, if you are that near the end, and live with that same hope the rest of the way - what God has promised, He will fulfill, even if the fulfillment comes after your bones are buried in the soil of that promise.</p>",
        "references": [
          "Genesis 47:27-31"
        ]
      },
      {
        "day_number": 63,
        "title": "Day 63 - Manasseh and Ephraim (Genesis 48:1-22)",
        "content": "<p>Scripture records that Joseph brings his two sons to his ailing father, placing Manasseh, the firstborn, at Jacob's right hand. But Jacob crosses his hands and lays his right hand on Ephraim, the younger, blessing them with a reversal; when Joseph protests, Jacob insists, saying the younger brother will be greater.</p><p><strong>Interpretation/Application:</strong> This is no senile confusion; it is the same divine freedom that chose Jacob over Esau and Joseph over his brothers - over and over, God's ways overturn human calculations of priority. Blessing is not allocated by birthright but by the sovereign favor of God, who delights in using the younger, the overlooked, and the unexpected. You may have been overlooked by your family, your school, or your church because you are not the steady and obviously favored one. Take heart: God chooses what the world passes over, and He is not bound by human ranking. Entrust your significance to Him, and watch Him lay His hand on you and bless you beyond the expectations of any birth order.</p>",
        "references": [
          "Genesis 48:1-22"
        ]
      },
      {
        "day_number": 64,
        "title": "Day 64 - Jacob Blesses His Sons (Genesis 49:1-28)",
        "content": "<p>Scripture records that Jacob, gathering his sons, speaks over each of them a blessing that is also an unveiling: some receive words of strength, others warnings that expose long-buried sins - Reuben's instability, the violence of Simeon and Levi, and Judah receiving the promise of a ruler whose scepter will not depart from him until Shiloh comes.</p><p><strong>Interpretation/Application:</strong> Jacob speaks with the eyes of one who has seen enough of life to say hard truths gently; he does not pretend his sons are perfect, yet he blesses them all as the bearers of Israel's future, and the tribe of Judah - born out of the broken story of Tamar - is singled out for the line of kingship. Families need honest words spoken in love. You may carry another's blame, just as these brothers carried remembered failures, or you may need to speak what is hard because it is healing; let the harsh truth be wrapped in the blessing of belonging. And rest in this: out of Judah's troubled line came the Lion of Judah, who redeems every tribe's twisted history.</p>",
        "references": [
          "Genesis 49:1-28"
        ]
      },
      {
        "day_number": 65,
        "title": "Day 65 - The Death of Jacob (Genesis 49:29-33)",
        "content": "<p>Scripture records that Jacob, having finished blessing his sons, gives his final charge: Bury me with my fathers in the cave in the field of Machpelah, beside Abraham and Sarah, Isaac and Rebekah, and Leah. When he has finished giving his charge, he draws his feet up into the bed, breathes his last, and is gathered to his people.</p><p><strong>Interpretation/Application:</strong> There is a quiet completeness to this death: Jacob - the schemer, the wrestler, the one who had snatched and struggled all his life - dies at peace, at rest with his children, pointed toward the promise of a land he never fully possessed. How do you want to die? The question is not morbid but clarifying. Jacob's end was shaped by the hopes he had leaned on all his days. Live toward the promise now - lay up the peace, mend the relationships, and fix your heart on the land God has pledged - so that when you draw your feet into the bed, you too may be gathered to your people, at peace and full of hope.</p>",
        "references": [
          "Genesis 49:29-33"
        ]
      },
      {
        "day_number": 66,
        "title": "Day 66 - Jacob's Burial (Genesis 50:1-14)",
        "content": "<p>Scripture records that Joseph weeps over his father and then begins the long journey of honor: embalmed in Egypt, mourned for seventy days, carried by a great procession of Pharaoh's officials and chariots up to the land of Canaan, where Jacob is buried in the cave of Machpelah exactly as he had requested.</p><p><strong>Interpretation/Application:</strong> The funeral is a testimony more than a formality: all of Egypt sees an old Hebrew buried in his promised homeland, and it marks an unbreakable tie between the covenant family and the land - a stone in that cave holding the promise that they will not belong to Egypt forever. Honor the dead as they lived in hope, and let your own life point toward a promised destination; the way we bury those we love can speak as loudly as our living. And whatever land you are currently sojourning in, remember that you are being carried toward a resting place God has sworn - a homeland that will not let you be held forever.</p>",
        "references": [
          "Genesis 50:1-14"
        ]
      },
      {
        "day_number": 67,
        "title": "Day 67 - Joseph Reassures His Brothers (Genesis 50:15-21)",
        "content": "<p>Scripture records that with their father dead, the brothers' old guilt resurfaces, and they fear Joseph will pay them back for selling him into slavery. Joseph weeps at their fear. Then his brothers bow before him, and he says, Don't be afraid. Am I in the place of God? You intended to harm me, but God intended it for good to accomplish what is now being done, the saving of many lives.</p><p><strong>Interpretation/Application:</strong> Joseph refuses the bitterness that entitlement would grant him; he has seen, from the pit to the palace, that God was redeeming the evil done against him. Forgiveness here is not a vague sentiment but a settled trust that God can take the worst intentions of others and weave them into good. Is there a harm done to you that you have let define you? Forgiveness is not saying the wrong did not matter, nor that you are nothing to God; it is handing the intention and the outcome to the One who is in the place of God. Let Him turn what was meant for harm into the saving of many lives, and set your heart free.</p>",
        "references": [
          "Genesis 50:15-21"
        ]
      },
      {
        "day_number": 68,
        "title": "Day 68 - The Death of Joseph (Genesis 50:22-26)",
        "content": "<p>Scripture records that Joseph lives to see the third generation of his children, and at a hundred and ten he speaks his final words, reminding his family of the promise: God will surely come to your aid and take you up out of this land to the land he promised on oath to Abraham, Isaac and Jacob. He makes them swear to carry his bones up out of Egypt with them, then dies and is placed in a coffin in Egypt.</p><p><strong>Interpretation/Application:</strong> It is a striking way to end the book: Joseph does not ask for a grand Egyptian burial but for his bones, one day, to be carried to the promised land - the prayer of a dying man becoming a treasury of hope for generations, the assurance that Egypt is not home and the exodus is coming. The book of Genesis closes looking forward: from creation to the cross, from the beginning to a coffin in Egypt, the theme is the same - God keeps His promises. You, too, are living between a promise and its fulfillment. Do not live as if this world were all there is; carry hope in your bones - the God who began this story will surely come to your aid.</p>",
        "references": [
          "Genesis 50:22-26"
        ]
      }
    ]
  },
  {
    "id": "93000000-0000-0000-0000-0000000000c8",
    "title": "Exodus: Deliverance, Covenant, and Presence",
    "description": "A walk through the book of Exodus following its major movements: the oppression and rescue of Israel, the plagues, the Passover, the crossing of the sea, the giving of the Law at Sinai, and the building of the tabernacle. Each day pairs a section of Exodus with a 5-10 minute devotional and the section reference as the day passage.",
    "total_days": 23,
    "tags": [
      "deliverance",
      "covenant",
      "faith",
      "reading",
      "wisdom"
    ],
    "cover_image": "https://images.unsplash.com/photo-1445116572660-236099ec97a0?auto=format&fit=crop&w=1200&q=80",
    "days": [
      {
        "day_number": 1,
        "title": "Day 1 - The Birth of Moses (Exodus 2:1-10)",
        "content": "<p>Scripture records that a Levite woman bears a son and, seeing that he is a fine child, hides him for three months. When she can hide him no longer she places him in a papyrus basket, sets it among the reeds on the bank of the Nile, and stations his sister at a distance to see what happens. Pharaoh's daughter comes down to bathe, finds the basket, and has pity on the crying child; the boy's sister offers to fetch a Hebrew woman to nurse him, so the baby is raised by his own mother until he is weaned, and then he becomes the adopted son of Pharaoh's daughter, who names him Moses, because she drew him out of the water.</p><p><strong>Interpretation/Application:</strong> God preserves a hopeless child through the risk and courage of ordinary people - his mother's faith, his sister's quick wit, a princess's compassion. The text presents this as God at work behind human choices. Identify the baskets God has used in your life - small, brave acts by others that kept you afloat - and consider how your courage today might cradle someone else's future.</p>",
        "references": [
          "Exodus 2:1-10"
        ]
      },
      {
        "day_number": 2,
        "title": "Day 2 - Moses Flees to Midian (Exodus 2:11-25)",
        "content": "<p>Scripture records that after Moses has grown up he goes out and, seeing an Egyptian beating a Hebrew, strikes the Egyptian and hides him in the sand. The next day he finds two Hebrews quarreling and asks why one is striking the other; the man replies, who made you ruler and judge over us? Are you thinking of killing me as you killed the Egyptian? Moses flees to Midian, where he sits down by a well and defends the daughters of Reuel from shepherds, is invited into their home, and marries Zipporah. Meanwhile Scripture records that the Israelites groan in their slavery and cry out, and that God hears their groaning, remembers his covenant with Abraham, Isaac and Jacob, looks on them and is concerned about them.</p><p><strong>Interpretation/Application:</strong> Moses attempts deliverance in his own strength and it backfires, yet the text shows that God is already hearing the cry of his people. Our initiatives can be sincere but premature; God's timing is part of his deliverance. When your well-timed effort meets resistance, recall that God remembers the covenant - the foundation of rescue is God's faithfulness, not your premature zeal.</p>",
        "references": [
          "Exodus 2:11-25"
        ]
      },
      {
        "day_number": 3,
        "title": "Day 3 - The Burning Bush (Exodus 3:1-22)",
        "content": "<p>Scripture records that Moses, tending the flock of his father-in-law, comes to Horeb, the mountain of God, and sees a bush burning yet not consumed. As he turns aside to look, God calls to him from within the bush and tells him to remove his sandals, for he is standing on holy ground. God reveals himself as the God of Abraham, Isaac and Jacob, says he has seen the misery of his people and heard their cry, and commissions Moses to bring them out of Egypt. When Moses asks what he should say, God declares his name and his plan to lead the people to a land flowing with milk and honey.</p><p><strong>Interpretation/Application:</strong> The God who hears the cry of slaves draws near to the ordinary work of a shepherd. Holy ground can be anywhere God is; the same fire that reveals his glory does not consume. Whether you feel qualified or not, God's call is rooted in who HE is, not in what you can prove.</p>",
        "references": [
          "Exodus 3:1-22"
        ]
      },
      {
        "day_number": 4,
        "title": "Day 4 - Signs for Moses (Exodus 4:1-17)",
        "content": "<p>Scripture records that Moses objects that the people will not believe him, so God shows him three signs: his staff becomes a serpent and back again, his hand becomes leprous and is restored, and water from the Nile becomes blood on the dry land. Moses continues to protest that he is not eloquent, slow of speech and tongue, and asks God to send someone else. Scripture records that the Lord's anger burns against Moses, yet he gives Aaron his brother to be his spokesman, saying, I will help both of you speak and will teach you what to do.</p><p><strong>Interpretation/Application:</strong> God patiently supplies proof for doubt and a partner for weakness, yet the narrative does not hide that Moses's last excuse grieved the Lord. God meets us in our reluctance, often with provision - but the call remains. Examine what you think disqualifies you, and see whether God is offering you both the sign and the Aaron you need.</p>",
        "references": [
          "Exodus 4:1-17"
        ]
      },
      {
        "day_number": 5,
        "title": "Day 5 - Moses Returns to Egypt (Exodus 4:18-31)",
        "content": "<p>Scripture records that Moses tells his father-in-law he must return to his own people in Egypt and takes his wife and sons, carrying the staff of God in his hand. It records that he and Aaron gather the elders of Israel, that Aaron tells them everything the Lord has said to Moses and performs the signs before the people, and that the people believed and bowed down and worshiped, for they saw that the Lord was concerned about the Israelites and had seen their misery.</p><p><strong>Interpretation/Application:</strong> The word of deliverance is first received by a believing remnant before any visible change in circumstance. Faith rests on God's word and signs even when Pharaoh has not yet relented. In your own waiting, do not require the outcome to be complete before you believe; begin with the testimony of God's concern, and let that shape your worship.</p>",
        "references": [
          "Exodus 4:18-31"
        ]
      },
      {
        "day_number": 6,
        "title": "Day 6 - Bricks Without Straw (Exodus 5:1-23)",
        "content": "<p>Scripture records that Moses and Aaron go to Pharaoh saying, Let my people go, so that they may hold a festival to me in the wilderness; Pharaoh replies, I do not know the Lord and I will not let Israel go. He then orders the taskmasters to stop supplying straw, forcing the Israelites to gather straw for themselves while still meeting the same quota, because, he says, they are lazy. The Israelite officials, beaten for failing their quota, turn on Moses and Aaron, and Moses cries out, Why, Lord, have you brought trouble on this people?</p><p><strong>Interpretation/Application:</strong> Faithful obedience does not insulate us from immediate hardship; the first word of deliverance made things harder before they improved. Moses's complaint is honest and is not rebuked. When obedience seems to increase the burden, it does not mean you are outside God's purposes - the narrative of rescue often begins with a season of darker night before the morning.</p>",
        "references": [
          "Exodus 5:1-23"
        ]
      },
      {
        "day_number": 7,
        "title": "Day 7 - God Promises Deliverance (Exodus 6:1-30)",
        "content": "<p>Scripture records that the Lord tells Moses, I am the Lord. I appeared to Abraham, to Isaac and to Jacob as God Almighty, but by my name the Lord I did not make myself fully known. He says he has heard the groaning of the Israelites and will redeem them with an outstretched arm, will take them as his own people and be their God, and will bring them into the land he promised. He reminds them that he is the Lord. The passage also records the family of Moses and Aaron.</p><p><strong>Interpretation/Application:</strong> When circumstances have not yet changed, God anchors hope in who he is and the covenant he remembers. The promise that I will be your God precedes any visible rescue. In discouraged seasons, rehearse the character of God rather than the size of the problem; the covenant-keeping name stands even when the situation has not yet moved.</p>",
        "references": [
          "Exodus 6:1-30"
        ]
      },
      {
        "day_number": 8,
        "title": "Day 8 - The First Signs Before Pharaoh (Exodus 7:1-13)",
        "content": "<p>Scripture records that the Lord tells Moses he has made him like God to Pharaoh, with Aaron as his prophet, and that he will harden Pharaoh's heart so the Egyptians will know he is the Lord. Moses and Aaron do as the Lord commands: Aaron throws down his staff and it becomes a snake, and when the Egyptian magicians do the same, Aaron's staff swallows up their staffs. Scripture records that yet Pharaoh's heart became hard and he would not listen, just as the Lord had said.</p><p><strong>Interpretation/Application:</strong> Divine signs can be met with imitation and resistance, and God's sovereignty over Pharaoh's hard heart is put forward as part of a larger purpose: that Egypt might know the Lord. When truth is contested and hearts grow hard, remember the purpose is beyond the immediate battle - God is making himself known. Keep faithfulness anchored in his character, not in immediate persuasion.</p>",
        "references": [
          "Exodus 7:1-13"
        ]
      },
      {
        "day_number": 9,
        "title": "Day 9 - Plague of Blood and Frogs (Exodus 7:14-8:15)",
        "content": "<p>Scripture records that because Pharaoh will not let the people go, the Lord tells Moses to strike the Nile, and the water turns to blood: the fish die and the river stinks, yet the magicians do the same by their secret arts and Pharaoh's heart remains hard. Then the Lord sends frogs that come up and cover the land of Egypt. Pharaoh calls for Moses and promises to let the people go if the frogs are removed; when they die in a heap, Pharaoh hardens his heart and breaks his word, just as the Lord had said he would.</p><p><strong>Interpretation/Application:</strong> God's power is shown to be above the magicians of Egypt, yet hardened hearts find reasons to resist even clear evidence. The pattern is instructive: relief from pressure was followed by a broken promise. When God answers our cry and the pressure lifts, we are tempted to return to our own way. Let answered prayer lead to renewed obedience rather than to forgetfulness.</p>",
        "references": [
          "Exodus 7:14-8:15"
        ]
      },
      {
        "day_number": 10,
        "title": "Day 10 - Plague of Gnats and Flies (Exodus 8:16-32)",
        "content": "<p>Scripture records that the dust of the land becomes gnats, and when the magicians try to produce gnats by their secret arts they fail and confess, This is the finger of God. Even so Pharaoh will not listen. Then the Lord sends swarms of flies on Egypt but sets apart the land of Goshen where his people live, so that the flies do not touch them. Pharaoh tries to bargain - go, but do not go far - and once more, when the flies are removed, he hardens his heart and will not let the people go.</p><p><strong>Interpretation/Application:</strong> Here God begins to make a distinction between his people and Egypt, and even the magicians are forced to acknowledge a power beyond their own. God's people are not spared every discomfort, but they are set apart and protected. When you face a season of trouble around you, remember that God sees and knows where you live, and that being set apart for him is a protection even in hard times.</p>",
        "references": [
          "Exodus 8:16-32"
        ]
      },
      {
        "day_number": 11,
        "title": "Day 11 - Plague on Livestock, Boils, and Hail (Exodus 9:1-35)",
        "content": "<p>Scripture records that the livestock of Egypt die, but not one of the livestock of Israel dies. Then boils break out on people and animals throughout Egypt, and even the magicians cannot stand before Moses because of the boils. Then a severe hail storm, the worst Egypt has known, strikes down everything in the field. Moses warns the people to bring their livestock and workers in from the open; those who feared the word of the Lord brought their servants in, while those who did not left theirs in the storm. Pharaoh again confesses, I have sinned this time, but when the hail stops he hardens his heart.</p><p><strong>Interpretation/Application:</strong> In the hail we see a line drawn between those who take God's warning seriously and those who do not. Faith is practical: it moves livestock indoors when judgment is announced. Half-converted confessions, like Pharaoh's, that do not endure beyond the immediate crisis are not yet repentance. Take God's warnings to heart in the small, practical choices of today.</p>",
        "references": [
          "Exodus 9:1-35"
        ]
      },
      {
        "day_number": 12,
        "title": "Day 12 - Plague of Locusts and Darkness (Exodus 10:1-29)",
        "content": "<p>Scripture records that locusts swarm over Egypt and eat every plant that the hail had left, so that nothing green remains. Pharaoh, having called Moses in haste, admits, I have sinned against the Lord your God and against you, and asks for forgiveness just once more; but after the locusts are swept into the sea, the Lord hardens Pharaoh's heart and he does not let the people go. Then a darkness that can be felt settles over Egypt for three days, yet the Israelites have light where they live. Pharaoh offers to let the people go but without their flocks and herds; Moses refuses, and Pharaoh tells him never to appear before him again.</p><p><strong>Interpretation/Application:</strong> Pharaoh's repeated confessions, undone each time relief comes, show that true repentance is a change of course, not just words spoken under pressure. The darkness that is felt over Egypt while Israel has light points to God's care for his own. When you are tempted to bargain with God - giving him part of your life but not all - hear the call to go without holding back, trusting him with your whole story.</p>",
        "references": [
          "Exodus 10:1-29"
        ]
      },
      {
        "day_number": 13,
        "title": "Day 13 - The Passover (Exodus 12:1-30)",
        "content": "<p>Scripture records that the Lord institutes the Passover: each household is to take a lamb without defect, keep it, and slaughter it at twilight, putting its blood on the doorposts and lintel of the house. They are to eat the meat roasted with fire, with unleavened bread and bitter herbs, dressed ready to travel. On that night the angel of the Lord passes over the houses marked with blood and strikes down every firstborn in Egypt - man and animal - while the people of Israel, sheltered by the blood, are passed over. There is loud wailing in Egypt, for there is hardly a house without someone dead.</p><p><strong>Interpretation/Application:</strong> The lamb's blood on the door is the hinge of the whole exodus: rescue comes through a substitute and its blood applied to the place where each household lives. The Passover looked forward, in the Christian reading, to Christ the Lamb of God whose blood delivers. Here, salvation is not earned but received by heed to God's command. Keep the posture of those ready to move - alert, gathered, and trusting in the blood of the lamb, not in your own standing.</p>",
        "references": [
          "Exodus 12:1-30"
        ]
      },
      {
        "day_number": 14,
        "title": "Day 14 - The Exodus (Exodus 12:31-51)",
        "content": "<p>Scripture records that during the night Pharaoh summons Moses and Aaron and urges them to take the Israelites and go - take your flocks and herds as you have said, and also bless me. The people, who have asked the Egyptians for articles of silver and gold and clothing, plunder the Egyptians as they leave. Six hundred thousand men on foot, besides women and children, and a mixed crowd go up out of Egypt after four hundred and thirty years, to the very day the Lord had promised. Scripture notes that it was a night of watching kept to the Lord and that the Israelites went out in battle formation under a strict rule about who may eat the Passover.</p><p><strong>Interpretation/Application:</strong> God delivers on his word to the day, and a promise made long to Abraham is kept exactly. The exodus is both a political rescue and a demonstration that God remembers his covenant. When you are between the promise and the fulfillment, remember that God keeps time. He who numbers the days of your waiting is the same God who came through for Israel on the very night he had appointed.</p>",
        "references": [
          "Exodus 12:31-51"
        ]
      },
      {
        "day_number": 15,
        "title": "Day 15 - Crossing the Red Sea (Exodus 14:1-31)",
        "content": "<p>Scripture records that Pharaoh, regretting letting Israel go, chases after them with chariots and traps them between his army and the sea. The people cry out in fear, blaming Moses, who tells them, Do not be afraid. Stand firm and you will see the deliverance the Lord will bring you today. The angel of God and the pillar of cloud move between Israel and Egypt. Moses stretches out his hand, the Lord drives the sea back with a strong east wind, and Israel crosses on dry ground with walls of water on either side. The Egyptians pursue, their chariot wheels clog, and the waters return, drowning the entire army. Israel sees the great power of the Lord and fears him and puts their trust in him.</p><p><strong>Interpretation/Application:</strong> When a way seems impossible and pursued, deliverance comes from a direction none could predict. Israel's part was only to stand firm and move forward when God said go. Fear is natural - the same people who had seen the plagues still trembled - yet they were told to stand still and see the Lord's salvation. In your own cornered moments, resist panic; your calling is to obey the next step and watch God open the sea.</p>",
        "references": [
          "Exodus 14:1-31"
        ]
      },
      {
        "day_number": 16,
        "title": "Day 16 - The Song of Moses and Miriam (Exodus 15:1-21)",
        "content": "<p>Scripture records Moses and the Israelites singing to the Lord, I will sing to the Lord, for he is highly exalted. Both horse and driver he has hurled into the sea. The song retells the deliverance: the Lord is a warrior, your right hand, Lord, was majestic in power; in the greatness of your majesty you threw down those who opposed you. Who among the gods is like you? In your unfailing love you will lead the people you have redeemed. Then Miriam the prophetess takes a tambourine and leads the women in dance, singing the same refrain, for he is highly exalted.</p><p><strong>Interpretation/Application:</strong> The first response of the redeemed is worship; the song rehearses what God has done before it asks anything. Remembering, in the form of song, is how a delivered people stay delivered. When you come through a rescue, do not quickly move on - spend time rehearsing God's faithfulness aloud, alone and with others, the way Israel sang of a God who redeems by unfailing love.</p>",
        "references": [
          "Exodus 15:1-21"
        ]
      },
      {
        "day_number": 17,
        "title": "Day 17 - Manna, Water, and Quail (Exodus 16:1-17:16)",
        "content": "<p>Scripture records that in the Desert of Sin the whole community grumbles against Moses and Aaron for lack of food, longing to have died in Egypt where there was bread. God promises bread from heaven: in the morning the people gather manna, a fine flaky substance like frost on the ground, one omer per person, with twice as much on the sixth day so the Sabbath may rest. At Rephidim the people quarrel for water and God tells Moses to strike the rock, and water comes out for the people to drink. Later, the Amalekites attack, and while Aaron and Hur hold up Moses' hands, Israel prevails. Moses builds an altar and calls it The Lord is my Banner.</p><p><strong>Interpretation/Application:</strong> In the wilderness God tests and teaches his people, giving daily bread so they learn daily trust, and water from a rock to quench an impossible thirst. Grumbling reveals a memory problem - the same people who saw the sea parted doubt that God can give bread. God's provision for the spirit comes one day at a time. When the immediate need feels empty, remember that the God who fed manna and split the rock still gives grace for today, and let need drive you to him rather than to complaint.</p>",
        "references": [
          "Exodus 16:1-17:16"
        ]
      },
      {
        "day_number": 18,
        "title": "Day 18 - The Ten Commandments (Exodus 19:1-20:21)",
        "content": "<p>Scripture records that, arriving in the Desert of Sinai, Israel camps before the mountain, and the Lord tells them, if you obey me fully and keep my covenant, then out of all nations you will be my treasured possession. The people consecrate themselves, and on the third day the mountain is covered with smoke and fire as the Lord descends to speak. At the giving of the Law, God proclaims: You shall have no other gods before me; you shall not make idols; you shall not misuse the name of the Lord; remember the Sabbath; honor your father and mother; you shall not murder, commit adultery, steal, give false testimony, or covet. The people, trembling, stand at a distance while Moses draws near.</p><p><strong>Interpretation/Application:</strong> The covenant shapes a delivered people: because you have been freed, now live as God's treasured possession. The commandments are not a ladder to be saved by but a portrait of a life in right relation to God and neighbor, with the first table about loving God and the second about loving people. Before a holy God, the people rightly tremble; the Law reveals both the standard and our need. Receive it not as cold rule but as how a people who have been redeemed are called to live.</p>",
        "references": [
          "Exodus 19:1-20:21"
        ]
      },
      {
        "day_number": 19,
        "title": "Day 19 - The Book of the Covenant (Exodus 21:1-24:18)",
        "content": "<p>Scripture records the laws God gives to regulate the life of his people after deliverance: how Hebrew servants are to be treated, laws about restitution, care for the poor and the foreigner, justice for the vulnerable, the yearly festivals, the year of rest for the land, and honesty in business and in borrowing. The people respond with one voice, Everything the Lord has said we will do. The blood of the covenant is sprinkled on the people, and Moses, Aaron and the elders go up the mountain and see the God of Israel, and they eat and drink in his presence. Moses then enters the cloud on the mountain for forty days.</p><p><strong>Interpretation/Application:</strong> The covenant community is ordered so that the weak - servants, the poor, the foreigner, the widow - are protected, showing that redeemed people are to reflect the character of their redeemer in everyday practice. Law is given to a people already saved, not to save them. As one who has been delivered, consider how God's commands order your treatment of those with less power, and let your yes to God be a wholehearted Everything the Lord has said we will do.</p>",
        "references": [
          "Exodus 21:1-24:18"
        ]
      },
      {
        "day_number": 20,
        "title": "Day 20 - The Tabernacle (Exodus 25:1-31:18)",
        "content": "<p>Scripture records the Lord's detailed instructions for a sanctuary so that he may dwell among his people: an ark of the covenant with atonement cover, a table for bread, a gold lampstand, a curtained framework of the tabernacle itself, an altar of bronze for burnt offerings, and the priestly garments of Aaron. The people are to bring offerings of gold, silver, bronze, fine linen and precious stones, all from willing hearts. Everything is to be made exactly after the pattern shown on the mountain, that he may dwell in the midst of them. Scripture also records the institution of the Sabbath as a sign between God and his people through their generations.</p><p><strong>Interpretation/Application:</strong> The tabernacle expresses the central longing of the exodus - not merely freedom from Egypt, but the presence of God dwelling among his people. Every detail, costly and carefully ordered, points to a God who is both holy and near. Notice that the whole community gives freely so that God's dwelling can be built. Consider what offering of your skill, resources or time participates in making a place for God's presence in the world around you today.</p>",
        "references": [
          "Exodus 25:1-31:18"
        ]
      },
      {
        "day_number": 21,
        "title": "Day 21 - The Golden Calf (Exodus 32:1-35)",
        "content": "<p>Scripture records that when Moses delays on the mountain, the people become restless and demand that Aaron make gods to go before them. He fashions a gold calf, and the people say, These are your gods, Israel, who brought you up out of Egypt, and they hold a festival. God tells Moses what his people have done, and Moses intercedes for them, turning aside God's anger. Coming down, Moses sees the calf and the dancing, throws down and shatters the tablets, grinds the calf to powder, and confronts Aaron. He calls for those who are for the Lord to come to him, and that day about three thousand fall. Yet Moses again asks God to forgive the people's sin.</p><p><strong>Interpretation/Application:</strong> The heart's great temptation is to fashion a god we can control from the very things God has given us, even while the true God is still speaking. Idolatry replaces trust with manufactured certainty, and it corrupts worship into indulgence. Yet the chapter also shows intercession: Moses pleads for a people who have betrayed the covenant. When you have turned from God, do not simply accept failure - turn back, and know there is one who stands in the gap and pleads for you as Moses did.</p>",
        "references": [
          "Exodus 32:1-35"
        ]
      },
      {
        "day_number": 22,
        "title": "Day 22 - The Renewed Covenant and God's Glory (Exodus 33:1-34:35)",
        "content": "<p>Scripture records Moses pitching a tent outside the camp and meeting the Lord there; he asks to see God's glory, and God passes by proclaiming, The Lord, the Lord, the compassionate and gracious God, slow to anger, abounding in love and faithfulness, maintaining love to thousands, forgiving wickedness. Moses comes down with the two new stone tablets, his face radiant because he had spoken with the Lord, so that the people are afraid to come near and he puts a veil over his face. God renews the covenant with the people and repeats the command to keep it, so that they may know that he is the Lord their God.</p><p><strong>Interpretation/Application:</strong> After the fracture of the golden calf, the covenant is renewed, not because the people are reliable but because God is gracious and abounding in steadfast love. Glory in Scripture is not raw brightness but God's character made known - compassionate, slow to anger, faithful, forgiving. When you have broken covenant, God's own self-description is your hope: he maintains love to thousands and forgives. Let the radiant face of one who has been with God remind you that time in God's presence changes what people see in you.</p>",
        "references": [
          "Exodus 33:1-34:35"
        ]
      },
      {
        "day_number": 23,
        "title": "Day 23 - The Tabernacle Completed and God's Glory Fills It (Exodus 35:1-40:38)",
        "content": "<p>Scripture records that, after Moses returns from the mountain with Moses' face concealed, the people bring more than enough offerings, and every skilled worker helps to build the tabernacle, its courtyard, the ark, the lampstand, the altar, and the priestly garments - all made just as the Lord commanded Moses. When everything is finished, the cloud covers the tent of meeting, and the glory of the Lord fills the tabernacle, so that Moses cannot enter. From then on, whenever the cloud lifts from the tabernacle, the Israelites set out, and wherever it settles, they encamp; through all their journeys the cloud of the Lord is over the tabernacle by day and fire is in the cloud by night, in the sight of all Israel.</p><p><strong>Interpretation/Application:</strong> The exodus that began with a burning bush ends with God dwelling in the midst of his people, the same glory that descended at Sinai now filling a house built among them. Everything was constructed exactly as commanded, and then the presence came - obedience prepared a dwelling, but the glory was God's own doing. The tabernacle was a mobile home for a pilgrim people, guiding their every move. Let your life be built according to his pattern, and look for the presence that fills it; and when the cloud moves, be ready to move with him.</p>",
        "references": [
          "Exodus 35:1-40:38"
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
-- End Scripture devotion plans.
