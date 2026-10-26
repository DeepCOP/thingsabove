-- Twenty-nine curated, Scripture-led readings from O. F. Walton's fictional story Christie's Old Organ.
-- Literary events are editorial paraphrases, not verbatim source quotations or historical testimony.
-- Existing day IDs, day numbers, total_days, source URL and progress relationships remain unchanged.
-- Child grief, illness, poverty, and safeguarding are handled without making death desirable.
-- Publication is authorized after source, editorial, and distribution review.

begin;

-- Guard against a missing or structurally changed target before updating any records.
do $$
declare
  present_days integer;
  first_day integer;
  last_day integer;
  matching_source text;
  reported_total integer;
begin
  select source_url, total_days into matching_source, reported_total
  from public.devotional_plans where id = '90000000-0000-0000-0000-000000000253'::uuid;
  if not found then
    raise exception 'Plan 253 is missing';
  end if;
  if matching_source is distinct from 'https://www.gutenberg.org/ebooks/21997' or reported_total <> 29 then
    raise exception 'Plan 253 source URL or total_days differs from the reviewed seed';
  end if;
  select count(*), min(day_number), max(day_number) into present_days, first_day, last_day
  from public.devotional_days where plan_id = '90000000-0000-0000-0000-000000000253'::uuid;
  if present_days <> 29 or first_day <> 1 or last_day <> 29 then
    raise exception 'Plan 253 must have exactly 29 numbered days, found %', present_days;
  end if;
end
$$;

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-25 20:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Home, Belonging, and Hope: 29 Readings from Christie’s Old Organ"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-25 20:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Twenty-nine Scripture-led devotional readings adapted from the events of Mrs. O. F. Walton's nineteenth-century Christian children's novel Christie's Old Organ; or, Home, Sweet Home. Each existing story installment is presented as a labeled editorial paraphrase rather than a verbatim excerpt, followed by a new devotional focus, reflection, and prayer. The fictional narrative includes poverty, child labor, serious illness, bereavement, and a grieving child's wish to join deceased loved ones; these themes are addressed with attention to dignity, safeguarding, practical care, and Christian resurrection hope. The original novel remains available at the linked source URL. Scripture selections are editorial devotional anchors, not quotations or references claimed by the author."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-25 20:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "The Unnoticed Musician",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "A Song and a Memory",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Room for One Another",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Trusted with Something Precious",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Snowdrops and Simple Kindness",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Seeking Help for Treffy",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Questions About Home",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Mabel Speaks of Jesus",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "A Door into Community",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Fear in the Storm",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "When Hope Feels Closed",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "The Promise of Cleansing",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "A Prayer in the Attic",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "The Snowdrops Return",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Grace Is a Gift",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Companionship Changes a Room",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Growing into a New Life",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Love While Time Remains",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Peace in a Painful Farewell",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Hope and Mourning Together",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "A Child Needs a Future",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Grief Should Not Mean Abandonment",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "When the Vulnerable Become Ill",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Someone Finally Comes",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "A Practical Commitment to Care",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Returning with Good News",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Love Made Visible Over Years",
    "day_number": 27
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Faithful Work Has Limits",
    "day_number": 28
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "A Home Built in Love",
    "day_number": 29
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-25 20:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> Psalm 68:5-6; James 2:1-4.</p><p><strong>Story context:</strong> Mrs. O. F. Walton's Christian novel opens among people living in poverty. Treffy and Christie are fictional characters, not historical witnesses.</p><p><strong>Source-based editorial paraphrase:</strong> An elderly musician named Treffy plays a worn barrel-organ and treasures its tune about home. Strangers dismiss him, and a cold day's work earns scarcely enough for bread. In his lonely attic, the music is the companion he can still count on.</p><p><strong>Devotional focus:</strong> Age, poverty, and social standing never diminish a person's dignity before God. The story asks readers to notice the lives and needs that busy streets overlook.</p><p><strong>Reflect:</strong> Who is treated as invisible where you live? Offer a respectful conversation or practical support rather than pity alone.</p><p><strong>Prayer:</strong> Father of mercies, open my eyes to overlooked neighbors. Teach me to honor their dignity and share what I can. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> Psalm 34:18; Romans 12:15.</p><p><strong>Story context:</strong> The old organ's familiar tune also matters deeply to Christie, a child grieving the death of his mother.</p><p><strong>Source-based editorial paraphrase:</strong> Christie hears the music through Treffy's door. It recalls his mother's voice and her final words about going home. The melody draws him upstairs even when he must listen in the cold, because it keeps a cherished memory close.</p><p><strong>Devotional focus:</strong> Grief can attach itself to ordinary sounds, places, and objects. Scripture makes room for sorrow and calls others to draw near without trying to hurry it away.</p><p><strong>Reflect:</strong> Is there someone mourning a loss who needs to be heard? Make room for memory without insisting on cheerful words.</p><p><strong>Prayer:</strong> God of compassion, be near to the grieving. Give me patience to listen, remember, and accompany them with love. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> 1 John 3:16-18; Galatians 6:2.</p><p><strong>Story context:</strong> Christie and Treffy are isolated in a crowded lodging house, yet their unexpected friendship changes the attic.</p><p><strong>Source-based editorial paraphrase:</strong> When Treffy falls to the floor, Christie enters and helps him to bed. Soon the boy carries the organ, tends the fire, runs errands, and has a place to sleep. The old man, in turn, welcomes him into a modest companionship neither had expected.</p><p><strong>Devotional focus:</strong> Their kindness is real, but a child should not have to shoulder an ill adult's care alone. Christian community is called to support both vulnerable children and older neighbors.</p><p><strong>Reflect:</strong> What burden could you share today, and who else could join you so that care is safe and sustainable?</p><p><strong>Prayer:</strong> Lord Jesus, build friendships across age and circumstance. Make our care practical, wise, and shared. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> Luke 16:10; Philippians 2:4.</p><p><strong>Story context:</strong> Illness prevents Treffy from taking his organ into the streets, so he entrusts it to Christie.</p><p><strong>Source-based editorial paraphrase:</strong> Treffy anxiously explains how to protect his beloved instrument. Christie listens, carries it carefully, plays for passersby, and brings home money and food. His joy lies not merely in earning coins but in helping someone who trusts him.</p><p><strong>Devotional focus:</strong> Faithfulness is often visible in small responsibilities and consideration for another person's concerns. That does not make child labor an ideal; the scene also reveals the family's need for better support.</p><p><strong>Reflect:</strong> Whose trust is in your hands? Honor it in one small task, while noticing whether someone needs assistance beyond what they can provide.</p><p><strong>Prayer:</strong> Faithful God, teach me to keep trust with others and to seek help where the burden is too great. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> Matthew 25:35-40; Romans 12:10.</p><p><strong>Story context:</strong> In a wealthier neighborhood, Christie encounters children whose home is very different from his lodging house.</p><p><strong>Source-based editorial paraphrase:</strong> The music draws Mabel and Charlie to the window. They offer pennies, speak with Christie, and give him delicate snowdrops after learning that his mother has died. A small exchange leaves him with a moment of belonging as well as material help.</p><p><strong>Devotional focus:</strong> Compassion begins when a stranger becomes a person with a name and story. Giving is better when joined to respect, welcome, and attention to continuing needs.</p><p><strong>Reflect:</strong> Do you treat the person receiving help as an equal? Learn a name, listen, and give something genuinely useful.</p><p><strong>Prayer:</strong> God of welcome, free me from condescension. Help me offer kindness that honors the one who receives it. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> Proverbs 31:8-9; James 2:15-17.</p><p><strong>Story context:</strong> Treffy's health declines, and Christie grows afraid of losing the person who has become his family.</p><p><strong>Source-based editorial paraphrase:</strong> Christie watches for a doctor who is visiting the landlady and persuades him to climb to the attic. The doctor examines Treffy and explains privately that his remaining time may be short. Christie returns upstairs heartbroken, uncertain how to speak about the news.</p><p><strong>Devotional focus:</strong> Loving concern does more than worry silently: it seeks appropriate medical help, truthful information, and trusted people who can share difficult decisions. No child should have to navigate such news alone.</p><p><strong>Reflect:</strong> Where is fear preventing you from asking for skilled help or supportive company? Take one responsible step today.</p><p><strong>Prayer:</strong> Merciful Lord, sustain people facing illness and those who care for them. Give us wisdom, medical support, and companions in hard conversations. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> Psalm 90:12; John 14:1-3.</p><p><strong>Story context:</strong> After the doctor's visit, Treffy and Christie talk about mortality and what the word home might mean.</p><p><strong>Source-based editorial paraphrase:</strong> Treffy is shaken by the thought of dying and knows little about the hope Christie remembers his mother describing. The two speak honestly of their fears and agree to keep looking for understanding rather than pretending to have answers.</p><p><strong>Devotional focus:</strong> Christian hope does not require pretending that illness, separation, and death are easy. Jesus invites troubled hearts to trust him while families also need honest conversation and loving presence now.</p><p><strong>Reflect:</strong> What question about loss or the future have you avoided? Bring it into prayer or discuss it with a trustworthy person.</p><p><strong>Prayer:</strong> Lord Jesus, meet our questions with your peace. Give courage for honest conversations and tenderness toward those who fear loss. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> John 14:1-3; Mark 10:13-16.</p><p><strong>Story context:</strong> Christie meets Mabel again while playing the organ near her family home.</p><p><strong>Source-based editorial paraphrase:</strong> Mabel delights in turning the instrument and describes the heavenly home she has learned about. She asks Christie whether he knows and loves Jesus. His uncertain answer reveals how little opportunity he has had to hear the Christian story clearly.</p><p><strong>Devotional focus:</strong> Faith is not inherited from comfort or wealth, and questions deserve patient answers rather than pressure. Jesus welcomes children; adults should make space for their curiosity, safety, and understanding.</p><p><strong>Reflect:</strong> How do you respond when someone admits not knowing what you know? Explain gently, and listen before you speak.</p><p><strong>Prayer:</strong> Welcoming Savior, help me speak of you with humility, clarity, and care, especially with those still learning. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> Romans 10:14-15; Hebrews 10:24-25.</p><p><strong>Story context:</strong> Christie is still trying to make sense of what Mabel said about Jesus and the hope of heaven.</p><p><strong>Source-based editorial paraphrase:</strong> While resting with the organ, he hears neighbors mention a Sunday mission-room service and the clergyman, Mr. Wilton. Christie carries that news home and asks Treffy about loving Jesus. Neither can explain much, so the invitation offers a place to listen and ask questions.</p><p><strong>Devotional focus:</strong> A faithful community makes room for people without religious vocabulary, secure housing, or polished clothes. An invitation matters most when it leads to welcome and ongoing care.</p><p><strong>Reflect:</strong> Who may feel excluded from your community? Offer an invitation that includes practical help and freedom to ask questions.</p><p><strong>Prayer:</strong> God of truth, make our gatherings hospitable. Let seeking people encounter patient teaching and genuine friendship. Amen.</p>",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> Revelation 21:1-4; Romans 8:1.</p><p><strong>Story context:</strong> A thunderstorm unsettles Treffy, whose anxieties about death and wrongdoing have grown intense.</p><p><strong>Source-based editorial paraphrase:</strong> Treffy describes a frightening dream about a shining gate and worries that his past bars him from entering. Christie stays beside him. Later, Christie visits the mission-room and hears a sermon about a holy city where sorrow and evil are absent.</p><p><strong>Devotional focus:</strong> Conscience can awaken needed repentance, but terror is not the final word of the Christian gospel. In Christ, God's promise includes forgiveness, renewal, and comfort for troubled people.</p><p><strong>Reflect:</strong> Does fear leave you unable to hear grace? Speak with a wise, compassionate Christian who can help you distinguish conviction from despair.</p><p><strong>Prayer:</strong> Holy and merciful God, receive our honest fears. Lead us from shame toward repentance, hope, and the peace of Christ. Amen.</p>",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> Romans 3:23-24; Revelation 21:27.</p><p><strong>Story context:</strong> The first mission-room sermon focuses on the purity and peace of the heavenly city.</p><p><strong>Source-based editorial paraphrase:</strong> Christie listens with longing, but he hears the exclusion of sin more clearly than the promise of mercy. At home he repeats the fearful part to Treffy, who concludes that he has no hope. The two remain distressed because the story of grace has not yet reached them fully.</p><p><strong>Devotional focus:</strong> A true message can be badly misunderstood when heard only in fragments. The holiness of God must not be separated from the good news of grace through Jesus Christ.</p><p><strong>Reflect:</strong> Have you spoken about sin without making room for Christ's mercy? Consider how to communicate the whole message with care.</p><p><strong>Prayer:</strong> Gracious Father, make our words truthful and complete. Let those burdened by guilt hear the hope you give in Jesus. Amen.</p>",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> 1 John 1:7-9; Romans 5:8.</p><p><strong>Story context:</strong> In the next mission-room meeting, Mr. Wilton explains forgiveness through the death of Jesus Christ.</p><p><strong>Source-based editorial paraphrase:</strong> Christie eagerly listens as the clergyman speaks of God's mercy reaching every kind of wrongdoing. The boy realizes that the message addresses both him and Treffy. He leaves with renewed hope and the desire to share it immediately.</p><p><strong>Devotional focus:</strong> Christian forgiveness is grounded in Christ's self-giving love, not in a person's age, record, or ability to earn a new beginning. Confession is a turn toward mercy rather than a purchase of it.</p><p><strong>Reflect:</strong> Where are you treating forgiveness as something to deserve? Confess honestly and receive God's invitation to begin again.</p><p><strong>Prayer:</strong> Lord Jesus Christ, thank you for your saving love. Teach us repentance, trust, and gratitude for your mercy. Amen.</p>",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> Matthew 11:28-30; 1 John 1:9.</p><p><strong>Story context:</strong> Christie returns from the mission-room and shares what he has learned with Treffy.</p><p><strong>Source-based editorial paraphrase:</strong> The boy repeats the promise that Christ can cleanse from sin. Treffy worries that his past is too heavy, but Christie reminds him that the promise does not exclude him. Side by side in their small room, they pray in simple words for forgiveness.</p><p><strong>Devotional focus:</strong> People need not possess elegant religious language before turning to God. Prayer may be honest, plain, and shared with someone who offers encouragement instead of judgment.</p><p><strong>Reflect:</strong> Could you pray with someone without correcting their words or requiring them to hide their questions?</p><p><strong>Prayer:</strong> Merciful Jesus, receive our imperfect prayers. Help us trust your grace and accompany one another with gentleness. Amen.</p>",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> Isaiah 1:18; Psalm 51:7.</p><p><strong>Story context:</strong> After the prayer, Christie is relieved, but Treffy continues to struggle with doubt and guilt.</p><p><strong>Source-based editorial paraphrase:</strong> Christie meets Mabel and her mother, who listen to Treffy's plight. Mabel sends a fresh bunch of white snowdrops and teaches a short prayer about being made clean. Christie carries the flowers home as a tangible sign of care and a reminder of God's promise.</p><p><strong>Devotional focus:</strong> Feelings may lag behind the trust a person is learning to place in God. The flowers are not magic; their beauty helps the characters remember mercy, and their delivery is itself an act of human kindness.</p><p><strong>Reflect:</strong> What concrete reminder of grace could help a worried person today? Offer encouragement together with practical support.</p><p><strong>Prayer:</strong> God of mercy, steady those troubled by guilt or uncertainty. Let kindness and your promises draw them toward hope. Amen.</p>",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> Ephesians 2:8-10; Romans 5:1-2.</p><p><strong>Story context:</strong> Mr. Wilton visits Treffy and listens to his difficulty trusting that forgiveness could be freely given.</p><p><strong>Source-based editorial paraphrase:</strong> The clergyman uses an ordinary gift to show what it means to receive generosity rather than earn it. Treffy listens and prays with him and Christie. As the visitors part, the snowdrops continue to remind them of the mercy they have discussed.</p><p><strong>Devotional focus:</strong> Grace cannot be bought by merit or certainty of feeling. Faith receives God's gift in Christ and grows into gratitude and good works, not superiority over others.</p><p><strong>Reflect:</strong> Where do you confuse receiving grace with proving yourself worthy? Thank God, then do one good work out of gratitude.</p><p><strong>Prayer:</strong> Generous God, teach me to receive your gift with humility and respond with love rather than fear. Amen.</p>",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> Philippians 4:6-7; Romans 12:13.</p><p><strong>Story context:</strong> Treffy begins to experience peace, and new visitors bring encouragement to the attic.</p><p><strong>Source-based editorial paraphrase:</strong> Mabel and her mother arrive with helpful supplies, read Scripture aloud, and speak with Treffy about Christ. The old organ and snowdrops become shared reminders of affection. Christie sees how the mood of the room changes when people do not leave the ill and poor isolated.</p><p><strong>Devotional focus:</strong> Prayer and practical generosity belong together. Spiritual comfort does not remove the need for food, medical attention, or supportive relationships.</p><p><strong>Reflect:</strong> Who is alone or housebound today? Arrange a visit, a call, or concrete assistance that respects their wishes.</p><p><strong>Prayer:</strong> God of peace, give us hearts that visit, listen, share, and pray. Let vulnerable neighbors receive continuing care. Amen.</p>",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> Colossians 1:12-14; Galatians 5:22-25.</p><p><strong>Story context:</strong> At another mission-room service, Mr. Wilton speaks of the life that follows forgiveness.</p><p><strong>Source-based editorial paraphrase:</strong> Christie hears that believers are not only welcomed by grace but also shaped over time by God's Spirit. The preacher describes the slow work of learning to love what is good and resist wrongdoing, and Christie hopes to explain this teaching to Treffy.</p><p><strong>Devotional focus:</strong> Sanctification is a continuing work of the Holy Spirit, not instant moral perfection. Its fruit is seen in patient love, truthfulness, self-control, and service.</p><p><strong>Reflect:</strong> What small habit needs the Spirit's renewing work? Choose one concrete act of patience, honesty, or kindness.</p><p><strong>Prayer:</strong> Holy Spirit, renew my desires and habits. Grow in me the fruit of a life formed by Jesus Christ. Amen.</p>",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> Galatians 6:2; Psalm 46:1.</p><p><strong>Story context:</strong> Treffy's condition worsens just as Christie encounters another family facing serious illness.</p><p><strong>Source-based editorial paraphrase:</strong> Treffy speaks with gratitude about following Jesus, while Christie fears their parting. Outside Mabel's home, Christie learns her mother is very ill. The two children share their sadness and their longing for the people they love.</p><p><strong>Devotional focus:</strong> Children facing illness or bereavement need attentive adults, honest explanations, and steady support. Hope in Christ need not silence tears, and a sick person is never less valuable because their life is fragile.</p><p><strong>Reflect:</strong> Who needs you to stay near during uncertainty, rather than offer explanations you cannot know?</p><p><strong>Prayer:</strong> Compassionate Father, hold the sick and grieving in your care. Surround children and families with trustworthy, practical help. Amen.</p>",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> John 14:27; John 11:25-26.</p><p><strong>Story context:</strong> The story's farewell scene follows a visit from Mr. Wilton, who comforts Christie and Treffy.</p><p><strong>Source-based editorial paraphrase:</strong> The clergyman reads Jesus' promise of peace and gently prays with the distressed boy. During the night, Treffy asks Christie to play their cherished tune. Treffy dies as the old organ sounds, leaving Christie grieving and alone.</p><p><strong>Devotional focus:</strong> Christian hope in the risen Lord does not erase the pain of death or make separation desirable. The living need comfort, care, and companionship as they mourn.</p><p><strong>Reflect:</strong> What can you do for someone newly bereaved in the days after others have gone home? Offer a specific, lasting kindness.</p><p><strong>Prayer:</strong> Risen Christ, be close to those saying goodbye and those left behind. Give them comfort and people who remain with them. Amen.</p>",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> Revelation 7:9-17; 1 Thessalonians 4:13-14.</p><p><strong>Story context:</strong> After Treffy's death, Christie attends the mission-room, where Mr. Wilton remembers the old man.</p><p><strong>Source-based editorial paraphrase:</strong> The clergyman thanks God for Treffy's trust in Christ and speaks of the promised community of the redeemed. Christie listens with a grieving heart. The sermon offers hope, but he still faces the hard reality of life without his friend.</p><p><strong>Devotional focus:</strong> Resurrection hope gives Christian grief a horizon; it does not make tears unnecessary. Faithful communities must follow hopeful words with protection and care for those who remain.</p><p><strong>Reflect:</strong> How might you pair words of consolation with meals, visits, transport, or help securing a safe place to live?</p><p><strong>Prayer:</strong> God of resurrection hope, meet mourners in their sorrow. Make us faithful companions as they find their way forward. Amen.</p>",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> Psalm 34:18; Psalm 27:13-14.</p><p><strong>Story context:</strong> Christie's grief becomes especially acute after hearing the minister speak of his departed friend.</p><p><strong>Source-based editorial paraphrase:</strong> Christie tells Mr. Wilton that he wants to be with his mother and Treffy. The minister responds with tenderness and encourages him to continue living, serving, and trusting God. Christie returns to the attic still grieving, praying for patience.</p><p><strong>Devotional focus:</strong> A child's wish to join deceased loved ones is a signal for serious, compassionate attention—not a devotional ideal. Christie's need is for safety, ongoing adult care, and reasons to hope within his present life.</p><p><strong>Reflect:</strong> If a grieving person says they want to die, take it seriously: stay with them and help them obtain immediate, qualified support. Do not rely on encouragement alone.</p><p><strong>Prayer:</strong> Lord of life, shelter those overwhelmed by grief. Equip us to notice danger, seek help, and offer steady love. Amen.</p>",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> James 1:27; Romans 12:15.</p><p><strong>Story context:</strong> Christie follows Treffy's humble funeral procession and soon loses his place in the attic.</p><p><strong>Source-based editorial paraphrase:</strong> He sees another funeral and realizes that Mabel's mother has died too. The landlady reclaims Treffy's attic, leaving Christie in the crowded lodging room. The organ remains his treasured gift, but when he goes looking for Mabel, he learns her family has left the country.</p><p><strong>Devotional focus:</strong> Two losses and a housing change leave a child almost unsupported. Honoring the dead includes protecting the living, especially children without reliable caregivers.</p><p><strong>Reflect:</strong> What could your church or neighborhood do to ensure a bereaved child receives safe housing, care, and practical advocacy?</p><p><strong>Prayer:</strong> Father of the vulnerable, call your people beyond sympathy to lasting protection, friendship, and justice. Amen.</p>",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> James 2:14-17; Matthew 25:36.</p><p><strong>Story context:</strong> With his closest companions gone, Christie continues to work until exhaustion and sickness overtake him.</p><p><strong>Source-based editorial paraphrase:</strong> He returns to the lodging house longing for rest but is turned away while the landlady cleans. He becomes feverish and bewildered, eventually lying among adults who barely notice his distress. The remembered tune offers comfort but cannot secure the help he needs.</p><p><strong>Devotional focus:</strong> The story exposes more than private sadness: poverty, insecurity, and neglect put a child's health at risk. Faithful love notices illness and connects people to appropriate care.</p><p><strong>Reflect:</strong> Who may be unwell but unseen? Help arrange prompt medical care and follow-up support rather than assuming someone else will intervene.</p><p><strong>Prayer:</strong> Healing God, guide caregivers and health workers. Make our concern alert, practical, and responsible. Amen.</p>",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> Matthew 25:36; Psalm 68:5-6.</p><p><strong>Story context:</strong> Christie's serious illness leaves him weak and isolated in a dark room in the lodging house.</p><p><strong>Source-based editorial paraphrase:</strong> After a dangerous fever, Christie slowly regains consciousness, but very few people visit. Weeks pass before Mr. Wilton returns from a journey, notices the boy's absence, and comes to see him. Christie is overwhelmed with relief when a familiar, caring person enters.</p><p><strong>Devotional focus:</strong> Presence matters, but prolonged isolation and inadequate care should never be excused as a spiritual test. Vulnerable sick people need timely medical treatment, adequate food, safe surroundings, and consistent advocacy.</p><p><strong>Reflect:</strong> Can you check on someone who has disappeared from your usual gathering and make sure their real needs are being met?</p><p><strong>Prayer:</strong> Lord, make us attentive to those who are missing. Give the sick skilled care, protection, and reliable companions. Amen.</p>",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> Luke 10:33-37; Matthew 25:40.</p><p><strong>Story context:</strong> A letter from Mabel's father reveals that her late mother had wanted Christie to be cared for.</p><p><strong>Source-based editorial paraphrase:</strong> Her father sends funds for Christie's needs and proposes schooling and, later, work as a Scripture-reader if Christie wishes. Mr. Wilton shares the news, and Christie responds with gratitude that he may have a safer future and a meaningful vocation.</p><p><strong>Devotional focus:</strong> The turning point is not merely a kind feeling: an adult commits money, education, and future opportunity. Care should respect the child's agency and provide choices beyond hardship.</p><p><strong>Reflect:</strong> Where can you turn sympathy into a sustained commitment—education, mentoring, safeguarding, or material support?</p><p><strong>Prayer:</strong> Generous Father, inspire faithful commitments that open safe opportunities and honor the hopes of those we serve. Amen.</p>",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> Isaiah 58:6-7; 2 Corinthians 1:3-4.</p><p><strong>Story context:</strong> Years later, the fictional Christie is an adult Scripture-reader serving people in the neighborhood of his childhood.</p><p><strong>Source-based editorial paraphrase:</strong> Christie returns to Ivy Court alongside Mabel, now Mrs. Villiers. They visit a sick woman in Treffy's former attic, pray with her, and read from the small Testament once carried by Mabel's mother. Their visit joins spiritual encouragement to continuing personal attention.</p><p><strong>Devotional focus:</strong> The memory of care becomes a calling to care for others. Christian service remains incomplete if it offers words but neglects food, safe housing, health, and dignity.</p><p><strong>Reflect:</strong> How can past kindness shape the way you share Scripture and respond to someone's actual circumstances today?</p><p><strong>Prayer:</strong> God of comfort, let mercy received become mercy practiced. Join our witness to justice, generosity, and steady friendship. Amen.</p>",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> 1 John 3:18; Colossians 3:12-14.</p><p><strong>Story context:</strong> Christie's adult work takes him through the same streets and households where he once struggled.</p><p><strong>Source-based editorial paraphrase:</strong> Mrs. White remembers giving him scraps of food as a child and now speaks gratefully of his visits and care. Christie continues reading Scripture and speaking with families. At home, he is surprised by the sound of Treffy's organ and discovers that Mr. Wilton has returned to visit.</p><p><strong>Devotional focus:</strong> A life of service grows through repeated, ordinary acts. The memories of old neighbors show how relationships can mature when love is offered over many years.</p><p><strong>Reflect:</strong> What long-term relationship deserves renewed attention? Commit to a reliable action rather than a one-time display.</p><p><strong>Prayer:</strong> Lord Jesus, make my kindness consistent. Teach me to honor old friends and serve new neighbors with patience. Amen.</p>",
    "day_number": 27
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> Mark 14:8; 1 Corinthians 3:6-7.</p><p><strong>Story context:</strong> In their reunion, Christie and Mr. Wilton speak about the needs of the neighborhood and the work of ministry.</p><p><strong>Source-based editorial paraphrase:</strong> Christie keeps the organ in memory of Treffy. He wishes to spend more years serving because there is so much need around him. Mr. Wilton reminds him that no single person can accomplish everything and prays for faithful service within human limits.</p><p><strong>Devotional focus:</strong> Service is not measured by solving every problem. We offer what we can, welcome others' contributions, and trust God with what lies beyond our control.</p><p><strong>Reflect:</strong> Where are you carrying responsibility that belongs to a wider community? Identify one task to share or one needed boundary.</p><p><strong>Prayer:</strong> Lord of the harvest, keep me faithful without pride or exhaustion. Help us work together and leave results in your care. Amen.</p>",
    "day_number": 28
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "<p><strong>Read:</strong> Luke 14:15-23; Revelation 21:1-5.</p><p><strong>Story context:</strong> Walton's final chapter returns to the mission-room and then brings Christie's story to a hopeful conclusion.</p><p><strong>Source-based editorial paraphrase:</strong> Mr. Wilton preaches Jesus' invitation to God's feast and later takes Christie away for rest. Months afterward, Christie writes that he and Nellie have made a loving home together. Remembering his earlier homelessness, he gives thanks for an earthly home while looking toward God's promised renewal.</p><p><strong>Devotional focus:</strong> Hope for the life to come should strengthen our care for life today. Safe homes, rest, friendship, and lasting love are goods worth building, not distractions from faith.</p><p><strong>Reflect:</strong> How can you help make your household or community a place of genuine welcome and security for someone else?</p><p><strong>Prayer:</strong> God of every good gift, thank you for companionship, rest, and home. Teach us to build places of peace as we hope in your renewed creation. Amen.</p>",
    "day_number": 29
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
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 1,
    "references": [
      "Psalm 68:5-6",
      "James 2:1-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 2,
    "references": [
      "Psalm 34:18",
      "Romans 12:15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 3,
    "references": [
      "1 John 3:16-18",
      "Galatians 6:2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 4,
    "references": [
      "Luke 16:10",
      "Philippians 2:4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 5,
    "references": [
      "Matthew 25:35-40",
      "Romans 12:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 6,
    "references": [
      "Proverbs 31:8-9",
      "James 2:15-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 7,
    "references": [
      "Psalm 90:12",
      "John 14:1-3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 8,
    "references": [
      "John 14:1-3",
      "Mark 10:13-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 9,
    "references": [
      "Romans 10:14-15",
      "Hebrews 10:24-25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 10,
    "references": [
      "Revelation 21:1-4",
      "Romans 8:1"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 11,
    "references": [
      "Romans 3:23-24",
      "Revelation 21:27"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 12,
    "references": [
      "1 John 1:7-9",
      "Romans 5:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 13,
    "references": [
      "Matthew 11:28-30",
      "1 John 1:9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 14,
    "references": [
      "Isaiah 1:18",
      "Psalm 51:7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 15,
    "references": [
      "Ephesians 2:8-10",
      "Romans 5:1-2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 16,
    "references": [
      "Philippians 4:6-7",
      "Romans 12:13"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 17,
    "references": [
      "Colossians 1:12-14",
      "Galatians 5:22-25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 18,
    "references": [
      "Galatians 6:2",
      "Psalm 46:1"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 19,
    "references": [
      "John 14:27",
      "John 11:25-26"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 20,
    "references": [
      "Revelation 7:9-17",
      "1 Thessalonians 4:13-14"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 21,
    "references": [
      "Psalm 34:18",
      "Psalm 27:13-14"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 22,
    "references": [
      "James 1:27",
      "Romans 12:15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 23,
    "references": [
      "James 2:14-17",
      "Matthew 25:36"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 24,
    "references": [
      "Matthew 25:36",
      "Psalm 68:5-6"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 25,
    "references": [
      "Luke 10:33-37",
      "Matthew 25:40"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 26,
    "references": [
      "Isaiah 58:6-7",
      "2 Corinthians 1:3-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 27,
    "references": [
      "1 John 3:18",
      "Colossians 3:12-14"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 28,
    "references": [
      "Mark 14:8",
      "1 Corinthians 3:6-7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "day_number": 29,
    "references": [
      "Luke 14:15-23",
      "Revelation 21:1-5"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-25 20:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-25 20:00:00+00', timestamptz '2026-10-25 20:00:00+00');
    end if;
  end loop;
end
$$;

-- Publish the reviewed Christie adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-25 20:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000253'::uuid
);

commit;
