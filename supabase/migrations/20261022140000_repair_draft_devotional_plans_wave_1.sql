-- Source-checked repairs to seven devotional plans held after the first adaptation wave.
-- Existing day numbers and day IDs remain stable. Little Folded Hands gains days 2-115.
-- Five repaired plans remain draft for the editorial concerns in adaptation-progress.md.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-22 14:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000369",
    "value": "Living and Dying to the Lord: Four Readings from an 1838 Sermon"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-22 14:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Selected historical quiet-hour meditations from Dwight L. Moody's public-domain collection, with modernized wording and clearly marked editorial reflections where a source epigraph was split into its own day. Day 1 is an original opening devotion."
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Twenty-five complete prayers selected from Johann Habermann's Morning and Evening Prayers for All Days of the Week: the seven morning and evening pairs, followed by prayers for everyday life. The wording follows the existing modernized seed text; hymns, editor matter, and unrelated verse references have been omitted."
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "A source-checked collection of 115 numbered prayers, hymns, and Scripture readings for children, one complete item per day. Historical wording is retained pending child-suitability and language editing."
  },
  {
    "id": "90000000-0000-0000-0000-000000000327",
    "value": "Three selected readings from the 1851 public-domain memorial of Sarah G., with new Scripture focus, historical context, reflection, and prayer. The source recounts a child's illness and death; read with care when grieving."
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Four new editorial devotions on 1 Corinthians 10:24 and neighbor-love introduce nine adapted readings from Robert Cushman's 1621 sermon. The sermon is a historical Protestant text and the later readings retain its original setting and language."
  },
  {
    "id": "90000000-0000-0000-0000-000000000369",
    "value": "Four devotional readings adapted from James Slade's 1838 funeral sermon for the Rev. William Thistlethwaite in Bolton. Each day includes an exact sermon excerpt, a Scripture focus, an editorial reflection, and a prayer. The linked historical source preserves the complete sermon."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-22 14:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Mercy Takes Hold",
    "day_number": 345
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer for Sunday Morning",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer for Sunday Evening",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer for Monday Morning",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer for Monday Evening",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer for Tuesday Morning",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer for Tuesday Evening",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer for Wednesday Morning",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer for Wednesday Evening",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer for Thursday Morning",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer for Thursday Evening",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer for Friday Morning",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer for Friday Evening",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer for Saturday Morning",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer for Saturday Evening",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer of a Child",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer of a School Child for the Holy Spirit",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer on the Eve of a Journey",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer During a Journey",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "A Birthday Prayer",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "A Prayer for School",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer When Going to Church",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer for Sincere Repentance",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer for True Faith",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer for a Pious Life",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "Prayer of a Patient",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "Morning Prayer 1",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000327",
    "value": "Trusting Jesus in Hardship",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000327",
    "value": "Hope That Makes Room for Grief",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000327",
    "value": "Come to Jesus as You Are",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Seek Your Neighbor's Good",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "One Body, Shared Concern",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Love in Practical Care",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Examine Our Motives",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000369",
    "value": "Belonging to the Lord",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000369",
    "value": "Serving Christ in Daily Life",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000369",
    "value": "Trust When We Grieve",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000369",
    "value": "Known by the Lord",
    "day_number": 4
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-22 14:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "<p>Christ is all, and in all. Col. 3. 11.</p><p>Editorial reflection: The source's meditation names Christ as the service, direction, joy, and hope of a life. Colossians does not ask us to add Christ to an otherwise unchanged day. Ask which ordinary task can become service to him today, and let his presence shape how you do it.</p>",
    "day_number": 31
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "<p>Get you out of your country, and from your kindred, and from your father's house. Gen. 12. 1.</p><p>Editorial reflection: Abraham's departure began with God's call before he could see its outcome. Faith can require a step away from what is familiar, but it does not require pretending that change is easy. Name one step of obedience you can take today and entrust its result to God.</p>",
    "day_number": 38
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "<p>What means these stones? Josh. 4. 21.</p><p>Editorial reflection: Joshua asked Israel to tell the story behind the memorial stones. Remembering God's help should lead us to tell the next generation what happened and to live as witnesses now. What act of faithfulness will help someone else recognize God's care through you?</p>",
    "day_number": 43
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "<p>Their eyes were holden. Luke 24. 16.</p><p>Editorial reflection: The travelers to Emmaus did not recognize Jesus while he walked beside them. His presence was real before they understood it. When a day feels uncertain, return to Scripture and prayer; ask the risen Lord to open your eyes to his companionship and direction.</p>",
    "day_number": 75
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "<p>Could you not watch with me one hour? Matt. 26. 40.</p><p>Editorial reflection: Jesus asked his friends to stay awake with him in Gethsemane. Prayer is a way to remain present to God and to people under pressure. Give this hour your attention rather than a hurried promise: pause, listen, and pray for someone who needs courage.</p>",
    "day_number": 103
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "<p>The Lord is risen indeed, and has appeared to Simon. Luke 24. 34.</p><p>Editorial reflection: The risen Jesus met Simon personally before Peter spoke publicly at Pentecost. Witness grows from an encounter with Christ, not merely from finding the right words. Spend time with the Lord before trying to speak for him, and ask for a truthful and gentle voice.</p>",
    "day_number": 121
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "<p>Without me you can do nothing. John 15. 5.</p><p>Editorial reflection: Jesus calls his disciples to abide in him, as branches depend on a vine. This is a promise of living dependence, not a demand to manufacture strength alone. Before today's work, ask Christ for the patience and love you cannot produce by willpower alone.</p>",
    "day_number": 143
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "<p>I am black . . . as the tents of Kedar. Song of Sol. i. 5.</p><p>Editorial reflection: Song of Songs gives voice to a beloved person who is seen and loved. The historical selection pairs this image with the assurance that the Lord knows us fully and still loves us. Bring what you would rather hide into honest prayer and receive his mercy without ranking anyone's worth by appearance.</p>",
    "day_number": 147
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "<p>I have set you . . . that you should be for salvation to the ends of the earth. Acts 13. 47.</p><p>Editorial reflection: The mission in Acts reaches beyond one place or people. A faithful witness begins wherever we are and points toward God's welcome for the nations. Pray for someone outside your usual circle, then consider one concrete act of hospitality or service.</p>",
    "day_number": 158
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "<p>As your days, so shall your strength be. Deut. 33. 25.</p><p>Editorial reflection: God's promise of strength for each day invites trust for the present burden. It does not mean that weakness or hardship will vanish. Ask Christ for enough grace to do the next faithful thing, and allow another person to help when you need it.</p>",
    "day_number": 167
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "<p>Judas Iscariot . . . was a thief, and had the bag, and bore what was put in it. John 12. 4, 6.</p><p>Editorial reflection: John's account warns that religious language can conceal self-interest. The money in Judas's care was meant for service, not private gain. Examine how you handle what has been entrusted to you and choose one practical way to care for a neighbor in need.</p>",
    "day_number": 180
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "<p>They that wait upon the Lord shall change their strength. Isa. 40. 31. (R. V.)</p><p>Editorial reflection: Those who wait for the Lord do not have to pretend they are never weary. Waiting can mean bringing that weariness into his presence and receiving strength for what lies ahead. Set aside a few quiet minutes to pray before you resume your work.</p>",
    "day_number": 212
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "<p>He placed . . . cherubims, and a flaming sword . . . to keep the way of the tree of life. Gen. 3. 24.</p><p>Editorial reflection: Genesis pictures the way to the tree of life closed after human rebellion. The final vision of Scripture holds out life with God again. Let that promised future steady you today: Christ's work gives hope stronger than loss and calls you to walk in his light.</p>",
    "day_number": 285
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "<p>These have turned the world upside down. Acts 17. 6.</p><p>Editorial reflection: The early Christians were accused of unsettling the world. Their witness was sustained by loyalty to Jesus, not by chasing influence for its own sake. Ask where a steady, truthful, and compassionate life might challenge an unjust habit around you.</p>",
    "day_number": 311
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "<p>What is your life? It is even a vapor, that appeared for a little time, and then vanishes away. James 4. 14.</p><p>Editorial reflection: James reminds us that life is brief and uncertain. That truth need not lead to fear; it can bring our attention back to the people and work God has placed before us. Give this day to Christ, and do one good thing that should not wait for tomorrow.</p>",
    "day_number": 325
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "<p>Cleanse me from hidden faults. Psa. 19. 12.</p><p>The world needs men who are free from secret faults. Most men are free from gross, public faults.— Selected.</p>",
    "day_number": 332
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "<p>Noah found grace in the eyes of the Lord. Gen. 6. 8.</p><p>Editorial reflection: Noah received grace before the long work of building and waiting was complete. God's favor is a gift, not a reward for having every answer. When the next step feels slow or lonely, ask for grace to obey faithfully today and trust God with what follows.</p>",
    "day_number": 344
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Lord, our Heavenly Father, Eternal God! Blessed be Your divine power and might; magnified Your fathomless goodness and mercy; praised Your eternal wisdom and truth. For You have shielded me with Your hand against the perils of this night, and have suffered me to rest and slumber in peace under the shadow of Your wings. You have kept and safeguarded me with a father’s care against the Evil One and all his wicked designs and purposes. Therefore, I magnify Your goodness and the wonders which You do for the children of men. I will exalt You in the congregation. Your praise shall forever be in my mouth. My soul shall bless You, O my Lord, all that is within me shall bless Your holy name, and nevermore will I forget Your benefits. May the praises of my lips, which in singleness of heart I bring before You at this early hour, be acceptable in Your sight. I call upon You with all my heart to preserve me this day against all danger of body and soul. May Your holy angels have charge over me and keep me in all my ways. Encompass me with Your shield and lead me on the paths of Your commandments that, like the children of light, I may be blameless in Your service, to Your good pleasure. Stay the Evil One and all wickedness of this world. Restrain my own flesh and blood that I be not overcome by them. Lead me with Your Holy Spirit that I attempt, do, speak, or think nothing except what is well-pleasing in Your sight and conducive to the glory of Your divine Majesty. See, O God, I consecrate and dedicate myself entirely to Your holy will, with body and soul, all my powers and abilities, inwardly and outwardly. Make me a living sacrifice, holy and acceptable to You, so that I may render You a reasonable and pleasing service. Therefore, Most Holy Father, Almighty God, let me be wholly Your. Govern You my heart and soul, and all my emotions that I know and understand none but You. O Lord, in the morning Will you hear my voice. Early will I seek You and look up to You. Early will I praise You, and will not cease when evening comes. Through Jesus Christ. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Eternal God, Merciful Father, I lift up my hands to You as an evening sacrifice, and render You most hearty thanks, praise, and glory, that You have protected me this day and all the days of my life from all evil and calamity, and through the ministrations of Your holy angels have graciously guarded me against the Evil One. I ask you to forgive me all my sins, wherever I have done wrong. Surround me this night with Your holy angels. May you compass me round and cast a trench about me, that I may escape the snares and evil cunning of the enemy. I commend myself to Your goodness and mercy. Protect me with Your outstretched arm; for from my heart do I pant after You in the nightwatches, and with my spirit within me do I watch for You at all times. I wait upon Your goodness, and my soul trusts in You, the living God, for You are my refuge and my Savior. See, O Lord, whether we sleep or wake, we Are yours: whether we live or die, You are our God who has called us into being. Therefore, I cry to You: let Your grace be not far from me. Shelter me with Your shield. Keep me, that I lie in quiet, sleep in peace, and awake again in health. Hide me in Your pavilion in the time of trouble, in the secret of Your tabernacle hide me, set me upon the rock, and I will fear no evil. Yes, though I walk through the valley of the shadow of death, I will fear no evil: for You are with me; Your rod and Your staff they comfort me. Grant me grace, that though my body sleep, my soul may ever wake for You, that I may ever have You in my heart and before my mind, and be not overcome by the night of sin. Keep me from all wicked and evil dreams, from restless wakings and useless anxieties, from depraved and hurtful thoughts, from all grief. My Lord and God, into Your gracious care do I commend my body and soul, my brothers and sisters, and all my kin and loved ones. May it please You, O Lord, to save us, and turn not Your mercy from us. May Your grace and fidelity protect us always. Cover us this night with Your goodness, and encompass us with Your mercy, that we be safe-guarded in body and soul. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>O You Eternal and Merciful God! You have commanded Your people in Your law each morning to offer You a burnt offering, by it to praise and thank You for Your merciful protection: thus I too would bring to You my offering of praise, that is the fruit of my lips, and magnify Your holy name. For by Your grace and mercy You have kept me this night from all evil and harm in body and soul, and have graciously protected me. If You had not been my shield and my help, manifold calamities would have engulfed me, and I could not have risen in health and safety. Therefore, I thank You for Your protection. But I continue to call to You from the depths of my heart, and my supplication ascends to You in the early hour. Early do I seek Your countenance and Ask you to safeguard me and mine from the wiles and power of the devil, from sin and disgrace and all wickedness. Visit You me in this early hour with Your grace, as without You I can do nothing, and grant that I may this day begin all my work in Your name and end it joyously, to the glory of Your divine majesty and the betterment of my neighbor. Preserve my soul, mind, reason, senses, and thoughts, all that I do and leave undone, that the prince of darkness do me no injury. Safeguard me against the destruction that wastes at noonday. Defend me against my enemies that neither secretly nor openly they harm or injure me with their craft and cunning, violence or malice. O God, Father and Lord of my life, shield me from all impurity and disorderly conduct. Keep me from all intemperance and unchastity, and turn from me shameless thoughts. Help me by Your grace to pluck out the eye that offends me and cast it away, and renounce all wicked and impure desires of the heart. Grant whatever is pleasing to You and useful to me, that I may serve You in the true faith. Look upon me with the eyes of Your mercy, You Savior of the world, and enlighten my heart and eyes, that I may walk in the light of Your grace, which rises above me, and never lose You, the Eternal Light. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>O You Mighty and Everlasting God, the Father of our Lord Jesus Christ, I thank You that by Your divine power You have this day preserved me from all injury and danger of body and life. I owe it to Your mercy alone that You did protect me on all my paths. I ask you to forgive me all my sins which I have committed against You, and this night and during our entire lives mercifully to defend me and my loved ones against all sorrow and anxiety, and against the craft and power of the devil, with which day and night he seeks to ensnare us. Preserve us from the deadly pestilence that walks in the darkness, and deliver us from the snare of the enemy. Protect us from the temptation and terror of Satan, from all evils of body and soul. For You are our strong fortress, our sword and buckler. All our hope and trust rests in You. Therefore, O faithful God, may Your eyes be upon us and we be safeguarded this night against all violence and assault of the enemy. Be You our keeper and protector. Encompass us with Your shelter, for in You is our salvation. To You only, from whom comes my help, do I lift up my eyes. My help comes from the Lord, who made heaven and earth. See, as the eyes of servants look to the hands of their masters, and as the eyes of a maiden to the hand of her mistress; so our eyes wait upon the Lord our God, until that He have mercy upon us. Have mercy upon us, O Lord, have mercy, for we are poor and needy. Lift upon me the light of Your countenance lest I sleep the sleep of death. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Blessed be God, the maker of heaven and earth, blessed be the Lord, who only does wondrous things, and blessed be His glorious name forever who has made both day and night through His glorious wisdom, and so ruled, that while the earth remains, they shall not cease, that man may rest by night, and proceed again to his labors by day. O Lord, how manifold are Your works! In wisdom Have you made them all: the earth is full of Your riches. For such Your gifts we should thank You before the sun rises, and come into Your presence when the light breaks forth. Therefore I bless You now also, for You have suffered me securely to rest and sleep this night, and again awakened me to the joy of living. You have mercifully sheltered me from the assaults and malice of enemies. I supplicate Your grace: grant that my soul may repose in Your hands, my body continue in health according to Your good pleasure, and be kept from all injury and peril. Be You my mighty protection and strong stay, a defence from heat, and my cover from the sun at noon, my preservation from stumbling, and my help from falling, that no harm may come to me. O Merciful God, knowing the hour is come to awaken out of the sleep of sin and iniquity, for now is our salvation so near, the night is far spent, the day is at hand: so help us to cast off the works of darkness, and put on the armour of light, that we may walk honestly as in the day; not in rioting and drunkenness, not in chambering and wantonness, not in strife and envying, but putting on the Lord Jesus Christ in the true faith and a Christian conduct. Thus awaken us each morning. Open You my ears that I may hear Your holy Word with a believing heart and keep the same in my memory. Let my ears incline to the entreaties and prayers of the needy, not to forsake them in their distress. And when in my distress I cry to You, hear You the voice of my supplications, and despise not my sighings in the hour of death. Let my prayers come before You early. Incline Your ears to my entreaties. Satisfy us early with Your mercy; that we may rejoice and be glad all our days. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Lord, Merciful God, Holy Father, in the daytime do I cry to You with my voice, in my distress I call upon You, and at eventime I remember Your goodness and mercy, which You have wrought for me. And especially do I magnify You now, that purely out of fatherly grace and mercy, without any merit or worthiness on my part, You have this day preserved me from all harm and danger and kept me from sudden death. Therefore do I now and at all times render to You praise and thanksgiving, and Ask you, for the sake of the bitter sufferings of Jesus Christ, to forgive me wherever I have sinned against You this day. Mercifully protect me during the night against my adversary, the devil, and against the fears and terrors of the night. Suffer me to rest without anxieties and worries, and may the eyes of my faith ever see the lustre of Your countenance even during the shades of night. For You who shining and true light, which dispels all darkness that surrounds us. You, O Lord, are always with me. You are my rock, and my fortress, my deliverer, my strength, in whom I will trust, my buckler, the horn of my salvation, and my high tower. Lord, my God, at eventime do I lift up my hands to You. Come to me as the latter rains that make the earth fruitful. Abide with us, for the day is far spent and in the darkness there is none to defend us save You alone, our God. Hasten to uphold us. Defend us this night, lest our souls fall into the sleep of sin and our bodies be overcome with evil. Awake us again in due time, and make us to hear joy and peace, for we love Your word and Your testimonies, which are the delight of our souls. May our ears be saved from all messages of sorrow, and all anguish be turned from our souls; for You can prosper all that lives, and fill my life with Your blessing; in Jesus Christ, our Lord. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Almighty, All-gracious God! All Your creatures should praise and glorify You. The birds under the heavens magnify You with lovely songs early in the morning as their Lord and Maker. So will I too heartily thank You, that You have preserved me under Your shelter and protection during the night now past, and all my life even to the present hour, and awakening me from the sleep of the darkness of this night, have suffered me to arise again in health and joy. I ask you for the sake of the saving resurrection of Jesus Christ from the dead, that You would ever keep me together with all my loved ones from all danger and evil. O Lord, save Your people, and bless Your inheritance: feed them also, and lift them up forever. Fill me also at this early hour with Your grace, that I may pass this day rejoicing in Your commandments, and free from mortal sin. Let me experience Your grace as a dew from the womb of the morning, and as the refreshing moisture that diffuses at the break of day, making the land fruitful. You would spread Your goodness over me, that I may gladly and zealously do Your will. Govern me with Your Holy Spirit that I may serve You in righteousness and holiness of truth, well pleasing in Your sight. Guard me that I sin not against You, nor defile my conscience with carnal lusts that militate against the soul. Keep my tongue from evil, and my lips from speaking guile. Foolish talking or jesting, unbecoming of Christians, be ever far removed from me. Grant, that I offend none with my lips, nor backbite, judge nor condemn, defame nor vilify. O that I might put a lock to my lips and seal them with a strong seal, that they bring me not to nothing, nor my tongue destroy me. Give me grace that I may know my shortcomings and correct them, and not fall into Your righteous judgment and condemnation. Grant my prayer, O Eternal God, for the sake of Your dear Son, Jesus Christ. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Most Holy Trinity, One in essence, Three in person, who are my life, salvation, and eternal joy, I praise and thank You with mouth and heart that You have so graciously protected me throughout this day. I pray Your divine goodness to cover up all my shortcomings, and especially where this day, with my tongue, with vain and unprofitable words, slander or otherwise, I have sinned against You and Your holy commandments. According to Your name, O God, so is Your praise to the ends of the earth: Your right hand is full of righteousness. Therefore I commend my body and my soul into Your hands. Your divine Majesty bless me; Your holy Trinity shelter me; Your eternal Unity preserve me. May Your unbounded mercy protect me; Your inexpressible benevolence defend me, the sublime truth of God cover me; profound knowledge of Christ strengthen me; the unfathomable goodness of the Lord keep me. The grace of the Father govern me; the wisdom of the Son refresh me; the power of the Holy Spirit enlighten me. My Creator aid me, my Redeemer quicken me, my Comforter abide with me. The Lord bless me and keep me. The Lord make His face shine upon me and be gracious to me. The Lord lift up His countenance upon me and give me peace. The protection and blessing of the one and eternal Godhead be between me and all my enemies, visible and invisible, today and always, that they may not approach nor injure me. As the pillar of the cloud went between the army of the Egyptians and the army of Israel, so that they could not come together, and no harm befall the children of Israel, so May you be a pillar of fire and a wall of separation between me and my enemies, that no harm come over me. Keep me also in my last hour. When my eyes no longer see, my ears no longer hear, my tongue no longer speak, be You with me, O blessed Trinity, that the Evil One have no power over me. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Jesus Christ, You are the eternal light, which dispels the darkness of night and the shadow of death: I magnify Your name, I glorify and thank You. For You have so graciously kept me during this night, and have brought me out of the darkness to the light of day. You have shielded me against the terrors of the night, the snares of the devil, the noisome pestilence, that walks in the darkness, manifold illness and disease. You have guarded and watched over my soul, even as the shepherd watches over his flock. And all that I possess is kept from harm through Your great mercy. Praise and thanks be said to You for Your gracious protection and all Your gifts. I will speak of Your power and magnify Your goodness, when the day breaks. For You are my refuge, my strong tower, my present help, my faithful God, in whom I trust. You make glad my heart and my countenance rejoices. I ask you, for the sake of Your holy birth and incarnation, suffer Your grace to rise in my heart and break forth even as the beauty of the morning, and come over me as the early rain. Illumine me with Your radiance, and be You the light of my heart, for You are the right day star and the true light, that lights men to the eternal life. Be merciful to me, O Lord, for in You do I put my trust. My soul waits for You, more than they that watch for the morning, yes more than they that watch for the morning. Be You mine arm in the morning, my salvation also in the time of trouble. Protect me in body and soul, that no evil befall me and no plague come near to my dwelling. Keep from me all wicked spirits. Defend me from evildoers. Stand up for me against the workers of iniquity and shield me, that the hands of mine adversaries may not touch me. O Lord, our God, establish You the work of our hands upon us; yes, the work of our hands establish You it, and strengthen our hands, and teach us that we may keep Your commandments and sin not against You this day. Grant us this for the sake of Your mercy, which endures forever and ever. Amen.</p>",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Praise be to You, O God, our Father, through Jesus Christ in the Holy Spirit, one, eternal God, who through Your manifold compassion have kept me this day, a poor sinner and miserable creature, from the fiery darts of Satan that fly by day, from the destruction that wastes at noonday, and have graciously protected me from a sudden and evil death. Your mercy, O Lord, is in the heavens; and Your faithfulness reaches to the clouds. You are gracious and merciful, and all Your acts are glorious. I ask you, O merciful God, graciously to forgive me all that I have done against You this day, in thought, word, or deed. Turn Your mercy toward me, that I may slumber and rest during this coming night, and that I may never turn from You, who are the eternal rest. Suffer me ever to abide in You in the true faith, and safely to sojourn under Your protection, so that the enemy may never come near to me, nor do me injury. Lord, You are my light and my salvation; whom shall I fear? You are the strength of my life; of whom shall I be afraid? My heart trusts in You, and I am helped. You are my strength and my great shield. Your right hand strengthens me. Your right hand gladdens my heart, and in the shadow of Your wings will I make my refuge. See, my God, in the daytime do I cry to You, and You hear me, and in the night season I am not silent, and You answers my prayer. I remember You on my bed, and meditate on You in the night watches, because You have been my help. Therefore in the shadow of Your wings will I rejoice. My soul cleaves to You, for Your right hand defends me. When darkness comes over me, then You, O Lord, are my light and my salvation. O gracious God, vouchsafe to me Your grace, so that when that last hour comes, and I lay me down on my deathbed for the eternal rest, through Your help, in the true faith, in all confidence and trust, I may happily fall asleep for the eternal life. Meanwhile keep me in You, that I may ever watch and pass my days in all sobriety and moderation, and be found in Christian readiness, since I can not know the hour when You come, O God, to call me hence, so that I may be worthy to stand before the Son of Man, and be not put to shame; who lives and reigns with You and the Holy Spirit, world without end. Amen.</p>",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Blessed be God, my Maker! Blessed be God, my Savior! Blessed be God, my Comforter! Who gives to me my health, my life, and every blessing; my very present help and my protection. You have kept me according to Your great and most blessed compassion during this night now past against the onslaughts of Satan, and preserved me in health. I urge you, Heavenly Father, through Jesus Christ, Your dear Son, take me this day also into Your divine protection, and shield me that no evil may assail my life. For into Your hands do I this day and all days commend my body and soul, my thoughts, words, and deeds, all that I do or leave undone, my going out and my coming in, my walks and ways, my rising up and my lying down, my will and counsel, my thoughts and desires, my faith and profession, the end of my life, the day and hour of my death, my passing away and my resurrection. O Lord God, do You with me as You will: for You know what serves best Your glory and my salvation. Keep me in Your fear and in the true knowledge of You. Protect me from the deeds of unrighteousness. And if perhaps and by reason of my frailty I sin against You, I ask you take not from me Your mercy; turn not from me Your grace; withdraw not Your help. For there is none other God nor Helper but You, and as there is none before You, there is none after You. You are the first and the last, Alpha and Omega, and there is none other God beside You. Therefore do I call only upon You: may Your goodness rule over me. Cause me to hear Your loving kindness in the morning; for in You do I trust. Lead me on the paths of righteousness, that I may not walk in the counsel of the ungodly, nor stand in the way of sinners, nor yet sit in the seat of the scornful, but that my heart may ever delight in Your word and commandments, and meditate upon them day and night; through Jesus Christ, our Lord. Amen.</p>",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Blessed be the Lord God, who only does wondrous things! And blessed be His glorious name forever: and let the whole earth be filled with His glory! Daily will I praise the Lord, and at eventime my mouth shall thank Him while I have any being. For when I cry with my voice, He hears me, and gives ear to my supplication. When I pray, He attends to my voice. The Lord is my refuge and strength, a very present help in trouble. Therefore do I laud and magnify You, Eternal God, that You have this day so mercifully kept me from every harm and evil. My heart is glad and my soul glorifies You for Your goodness and mercy. Ever shall my tongue speak of You and say, Blessed be the Lord, and blessed be Your holy name! I ask you, graciously pardon, wherever I have this day sinned against You, and grant me and mine Your protection during the coming night. Be You my shield, and my shade upon my right hand. O Lord, preserve me from all evil, preserve my soul. Be gracious to me, for in You do I put my trust. I trust in the Lord, and cry to God, the Highest, to God Who ends all mine affliction. See, He that keeps Israel shall neither slumber nor sleep. He will guide my steps on the paths of righteousness, that I slip not and my feet do not falter. He will not suffer my feet to be moved, and His word is a light to my path. Therefore as I lay me down, I will not be afraid of sudden terror, neither of the desolation of wicked people, when it comes. For You keep my foot from being taken, and deliver me from the snares of death. O Lord God, lift upon me the light of Your countenance, that I may lie down and sleep in peace, and dwell in safety under Your protection. For You alone, O Lord, can help me. In Your name will I lie down to rest and let my eyelids slumber. You, O Lord, will again awaken me with rejoicing, to the glory and praise of Your eternal majesty; through Jesus Christ, our Lord. Amen.</p>",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>O You Very and Eternal God, the Father of our Lord Jesus Christ. To You do I lift up my heart in dutiful gratitude. I will not hide Your righteousness within my heart. I will declare Your salvation. I will not conceal Your loving kindness and Your truth from the great congregation, and all the good that You have shown me will I not keep silent. For it is a good thing to give thanks to the Lord, and to sing praises to Your name, O Most High: to show forth Your loving kindness in the morning, and Your faithfulness every night. Therefore my soul does magnify You, that You in Your immeasurable grace have kept me during the night now past. Blessed be You, Lord God Sabaoth, who are merciful to all, that seek You and love Your salvation. Blessed is Your holy name in all the earth, who are our refuge and our help! Blessed are all Your works which You do for the children of men! I urge you, protect me this day, that the Evil One may not harm me, and the hands of the wicked touch me not. Lord God, my Savior, early will I seek You, early do I cry to You. Grant, that I may fulfill the duties of my calling and all that is committed to me with diligence and trust to the glory of Your name and the betterment of my fellowman, so that I may not misuse the light of this day, neither any of Your creatures in the service of sin and vanity, neither grieve You, nor transgress the covenant of my Baptism with anything I do or leave undone. Vouchsafe to me Your grace, that I may guard myself against the six things which You do hate, yes, seven which are an abomination to You: a proud look, a lying tongue, and hands that shed innocent blood, a heart that devises wicked imaginations, feet that are swift in running to mischief, a false witness that speaks lies, and he that sows discord among brethren. From such and the like vices preserve me, O God, that I may nevermore be led nor consent to them, but teach me to do Your will; for You are my God: Your Spirit is good. Lead me into the land of uprightness, that I may serve You in a life that is without blame, and my deeds and all my conduct be pleasing in Your sight; for Christ’s sake. Amen.</p>",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Praise be to You, You great and unchangeable God! Praise be to Your goodness and mercy! Praise be to Your eternal wisdom and truth, that You have preserved me during the day now past from all danger and harm. I ask you, graciously perfect Your goodness which You have begun in me, and suffer me to rest this night under Your protecting shield, and cover me with Your wings. Suffer me to put my trust under the shadow of Your hands, that I fear no evil. Keep me, O God, as the apple of the eye. Hide me under the shadow of Your wings. Lord, You are the portion of my inheritance; my salvation is in Your hands. Grant to me, according to Your goodness, that neither fear nor trembling come over me, and no terrors of the night overwhelm me. Be merciful to me, for in You do I put my trust, and under the shadow of Your wings do I find my refuge. I seek the Lord in the time of need; my hand is outstretched in the night without ceasing; for my soul has none other comfort; and I know of none other helper in heaven or earth but You alone. At midnight when I awaken, I meditate upon Your name, so altogether lovely, upon Your goodness and fidelity, vouchsafed to me, and I praise You because of Your righteous judgments. When I am troubled I remember God, when my spirit is overwhelmed I speak of my Savior. For He redeems my life from destruction and saves me from the snares of death. Lord God, my Savior, by day and by night do I cry to You, pardon all my transgressions, which during this day and the week now past I have committed against You. O Lord, deliver my soul for Your mercy’s sake. You are gracious and just, and our God is merciful. The Lord preserves the simple. I was brought low, and He helped me. Therefore will I rejoice and praise You, and sing aloud upon my bed. For the days of my life will appear as noonday, and darkness as the morning’s light, and I will rejoice that You, O God, are my hope and my rest in life and death. I lay me down, and none will terrify me. Thus do I commend my body and soul into Your hands, You Faithful God. You have redeemed me through Jesus Christ, our Lord. Amen.</p>",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Almighty and Eternal God! You have commanded me to honor my parents, and in all things, which are not contrary to Your word, to obey them. I urge you, for the sake of the obedience of Your dear Son, Jesus Christ, my Lord, grant to me, that I may duly honor my father and mother, serve them, obey, love, and esteem them, so that their blessing may dwell with me to the end of my days. Keep me from sin and evil communications, that I may not anger or grieve my dear parents with hatred, sadness, scornfulness, disobedience, or obstinacy, and thus bring upon myself on this earth already their and Your curse, and in the after-life Your eternal wrath. And since I have sinned many times through weakness, I urge you, work in me sorrow and true repentance, through Jesus Christ, my Savior, who gave to me the example of true obedience. Grant, that according to His example I may ever grow, and increase in wisdom, stature, and grace before You, O God, and all men. Amen.</p>",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>O my dear Lord, Jesus Christ, I thank You, that to the present day, You ordain church and school ordinances and regulations, and have given to my parents and me grace, that I too may be thus trained. I urge you, fill me with Your Holy Spirit, that I may ever obey my dear parents and teachers, who only seek my welfare. Give to me a docile heart, that I may learn my catechism, noble arts and language, and thus increase in godliness, wisdom, understanding, and every virtue. O my dear Lord Jesus Christ, create in me a pure, chaste, and modest heart. May I ever serve You in upright faith and true fear, and love You from all my heart. Subdue in me all evil lusts. Endow me with Your Holy Spirit. Help me to continue in true humility. Grant me an obedient heart, to honor my parents according to Your commandment, and neither anger nor grieve them. May they live long on this earth, and protect You and preserve them from disease, evil, and harm. Be gracious to us and merciful. Bless us in body and soul, now and forevermore. Amen.</p>",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Almighty and Gracious God and Father, You protector of all that trust in You from their hearts! In Your name will I proceed and undertake this journey. For You are my God and preserve my going out and my coming in. You lead my feet in right paths and will not suffer them to be moved. I heartily Urge you to be my gracious guide and companion on this present journey. Send Your holy angels, and command them, in all my wanderings, to keep me from all evil in body and soul. Lead me on the paths of the righteous and bring me safely to my destination, that I may laud and magnify You, here in time and in eternity forever. And now, O Lord God and Father, into Your hands do I commit my body and soul and all that I possess. Your holy angel be my safe guard. Amen.</p>",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Almighty and Most Merciful God! We are always in Your sight wherever we be. You preserve our coming in and our going out, and lead us on the right paths that we slip not. I ask you, that as You did lead Your servant Abraham from the land of the Chaldees and kept him unharmed in his pilgrimage, and did say to his grandson Jacob when he journeyed to Mesopotamia, I am with you, and will bring you again into this land; and as You also did lead the Children of Israel through the Red Sea and through the desert, and did go before them, by day in a pillar of a cloud and night in a pillar of fire: thus Would you also be with me on my wandering, protect me on land and sea, by day and by night, and keep me from all harm and danger. And when my business is completed bring me home again in full health of body and soul. And as You did accompany youthful Tobias through Your angel Raphael, likewise do You accompany me in all my ways, so that when I, too, have happily returned to my home, I with all my own may have the greater reason to laud and praise You as my true and faithful guide. Meanwhile I commend to Your care all that I leave at home, and Urge you to have charge concerning them, and suffer me to find them unharmed when I return. Amen.</p>",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Dear Father in heaven, I thank You from all my heart, that You have put me into this world and made me a rational being. I am born of Christian parents and made a member of Your holy Church. Today the anniversary of my birth has come, and since I have been permitted to reach this day and thus complete another year of my pilgrimage, I thank You from all my heart and joyfully reiterate the thanksgiving of Your servant David, “Bless the Lord, O my soul, and all that is within me bless His holy name. Bless the Lord, O my soul, and forget not all His benefits: who forgives all your iniquities; who heals all your diseases; who redeems your life from destruction; who crowns you with loving kindness and tender mercies.”</p><p>Since every day of my life, however, is one step nearer to death, which can strike me this hour, yes, this very minute, I urge you so to shape and rule every day of my life, that I may walk according to Your pleasure as in the day, that is circumspectly in Your sight, honestly, and conscious of my responsibility, in short as a true Christian and in conformity with the promise made by me to You, my dear God, in my baptism. And if this prove my last year and my last birthday, I place all things into Your gracious keeping. If it is Your will that I should cease to live, then I have lived enough. For if it is sufficient for You, it is sufficient for me. Am I old enough for You, I am old enough for me. Here I again put myself under Your shield and protection, into Your sublime and eternal power. If I live this year, may I live in You; if I die, may I die in You, so that I may live, and move, and have my being in You, and whether living or dying I may be Your to all eternity. Amen.</p>",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>We ask you, everlasting God, Father, Son, and Holy Spirit, You eternal and inseparable Trinity and inexpressible Unity, that You would faithfully take under Your protecting wing the flock of Your Christendom, and ever abide in our midst with Your grace and truth. Be You with us, O Lord, our God. Be You a wall of fire round about us, and destroy them who hate You and are hostile to Your name. So rule us, O God, that we may ever be guided by Your clear and pure word and are not seduced by the external appearance of things. Keep us, Lord Jesus, from error and false doctrine, and send us faithful teachers who take heed to Your congregation, purchased with Your blood, and are anxious to perform Your will. Grant us obedient hearts, so that we, as lambs of Your flock, may obey Your voice, and be filled with fruits of righteousness. Teach us ever to do Your will, for You are our God: Your spirit is good. Lead us into the land of uprightness, to the end that we, too, through a blessed departure from this life may attain to You and the everlasting joy and blessedness, and see Your glory to all eternity. Amen.</p>",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Almighty God, Heavenly Father, because of Your great mercy I will go to Your house and worship You in Your temple in Your fear. Lord, lead me in the paths of righteousness, and make Your way straight before my face. Guide me on the paths of Your commandments, for You are my God, and the Lord of my salvation. I delight in Your sanctuary and rejoice in the congregation of Your saints, who confess and glorify You. How amiable are Your tabernacles, O Lord of hosts! My soul longs, yes, even faints for the courts of the Lord. O come, let us worship and bow down: let us kneel before the Lord our maker. For He is our God; and we are the people of His pasture, and the sheep of His hand. Magnify the Lord our God, adore at His footstool; for He is holy. I worship You, O God, in the accepted time through Your great mercy. Hear me according to Your grace. Amen.</p>",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Merciful and Gracious God, You are slow to anger and plenteous in mercy! You call us daily through the gracious preaching of Your word to devout conversion, and in Your name cause repentance and remission of sins to be preached. And You show Your forbearance with us through Your long suffering and inexpressible mercy, and do not suddenly come upon sinners in the midst of their evil deeds with Your righteous wrath and judgment to punish them, but gives place and time for repentance, so that no one can justly charge or accuse You. For You are not willing that any should perish, but that all should come to repentance and have everlasting life. O dear God, You know the sluggishness of our flesh and the hardness of our hearts, that we through inherited sin are thus far deranged and so deeply sunk in sin, that of our own accord we can not rise or return. Therefore, for the sake of the wounds of Jesus Christ, my Lord, I urge you, convert You me, and I am converted. For You are my God, and where I am converted I will truly repent. Save You me, O Lord, and I am saved. Help me, and I am helped. See, I am like an erring and lost sheep. Seek You Your servant, that I forget not Your commandments. Circumcise the foreskin of my heart. Purge me, and I shall be clean. Wash me, and I shall be whiter than snow. Create in me a clean heart, O God; and renew a right spirit within me. Cast me not away from Your presence; and take not Your Holy Spirit from me. O dear God, look upon me, as You did look upon Mary Magdalene, the repentant sinner, as she lay at Your feet and wept over her transgressions; and the publican in the temple, as he smote his breast and besought Your grace. Vouchsafe to me sincere sorrow and contrition over my sin, and a true faith with firm confidence in Your grace, and also worthy fruits of repentance. Let me discern the day of Your visitation, and not despise the riches of Your mercy, so that I may not neglect the accepted time, and the day of Your salvation, and not fail to turn to You, my Lord and God. May I not postpone my repentance from one day to another, nor yet to the last hour, but rather turn to You this day and repent. Amen.</p>",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Lord, Almighty God, You Father of lights, with whom there is no variableness, neither shadow of turning, from whom every good and perfect gift comes, I ask you, since all men have not faith: implant and maintain in my heart through the workings of Your Holy Spirit the true knowledge of Your dear Son Jesus Christ, and increase it from day to day, so that I, too, may be filled with the knowledge of Your will in all wisdom and spiritual understanding, that I may walk worthy of You to all pleasing, being faithful in every good work, and increase in such knowledge according to Your glorious power in all patience and long suffering with joy. Grant to me, according to the riches of Your glory, that I may be strengthened with might by Your Spirit in the inner man, that Christ may dwell in my heart by faith. O dear God, since no man knows the Son but You, O Father, and no man knows You, the Father, but only the same Your Son, and he to whom the Son will reveal You, I ask you, draw You me to You. Grant me the knowledge of salvation, which is the forgiveness of sins. Strengthen my weak faith, which is small as the mustard seed, so that it may increase, and I be rooted and grounded in You, and may stand steadfast and unmoveable. Gracious God, You have kindled the spark of faith in my heart and has begun this good work in me, I cry to You, perfect it until the end, that we may ever increase in knowledge and understanding, and be sincere and without offense till the day of Christ, being filled with the fruits of righteousness, which are by Jesus Christ, to the glory and praise of God. Preserve what You have begun, that we might war a good warfare, holding faith and a good conscience, and not waver or succumb in trial and temptation and make shipwreck concerning faith. Therefore protect me, my God, that I am not led astray among the errors, schisms, and heresies of the world. Preserve me from superstitions and all false doctrine, that I may neither err nor doubt in any article of faith. And vouchsafe to me Your grace, that my faith be not lifeless, inactive, or without good fruits, but active and energetic, serving in love, so that I, too, may carry off the end of faith, which is the soul’s salvation. Amen.</p>",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>O my dear Lord Jesus, illumine me today and forever, that I may shape the course of my Christian life and direct it toward the eternal Jerusalem, my eternal home. And as You yearn for me, may I also have all my delight and thirst in You, seek You early, yearn for You, and make of You, the bread of life, the companion of all my ways. Keep me, O unchangeable, everlasting God, from the inconstancy of the children of this world, that I may not fall into hypocrisy as they do, but today and always, in all my calling, prove myself constant in godliness, so that my life may decrease in vice and increase in virtue. May I always faithfully serve You, my Lord, disdain the worldly, be exalted in You, experience Your grace and protection, and eternally thank You, for Christ’s sake. Amen.</p>",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "value": "<p>Lord God, Heavenly Father! You are a faithful God, and will not suffer any one to be tempted beyond what he is able, but rather with the temptation will also make a way to escape, that he may be able to bear it. I supplicate You in my great suffering and pain, so shape the cross, that it may not lay too heavily upon me, and strengthen me that I may bear it with patience, and nevermore despair of Your mercy. O Christ, You Son of the living God! You have endured the agony of the cross for me, and have died for my sins, I urge you with my whole heart, have mercy upon me a poor sinner, and forgive me my transgressions, wherever I have sinned against You. Let my faith in no wise diminish. O God Holy Spirit! You true comforter in all times of need. Keep me ever in the spirit of patience and supplication. Sanctify me in my reliance upon You. Turn not from me in the hour of my death, and lead me from this vale of sorrow to Yourself in heaven. Amen.</p>",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": "<p>Now I awake and see the light;</p><p>Lord, Thou hast kept me through the night.</p><p>To Thee I lift my voice and pray</p><p>That Thou wilt keep me through the day.</p><p>If I should die before 'tis done,</p><p>O God, accept me through Thy Son! Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000327",
    "value": "<p><strong>Read: Mark 10:13–16; Proverbs 15:17.</strong></p><p><em>Historical context:</em> This 1851 memorial remembers Sarah, a child in a London family who faced hunger and illness. The paragraphs below are selected from the historical account.</p><p><strong>From the memorial:</strong></p><p>Sarah G—— was one of several children, living with their parents in a narrow lane in London. Early in the year 1847, Sarah's father had met with a serious accident, and was then in the hospital, where he remained for many weeks a severe sufferer. Sarah and her brothers, deprived of the usual means of support, and their mother being in constant attendance on her husband, were consequently often left in great necessity. More than once have these little ones been known to reach the hour of four or five in the afternoon, before taking any food; but amidst all their privations, no complaint was heard from the lips of Sarah. It was not known until after her death, how silently, yet how powerfully, the Spirit of God was, even at this time, working in her heart.</p><p>There was nothing particularly attractive in her appearance; quiet and unobtrusive, she seemed to the outward observer like most other children; but \"the Lord sees not as man sees.\" The Great Shepherd of the sheep had his eye on this little lamb of the fold, and marked her for his own. At home she was gentle and affectionate, obedient to her parents, and during their absence she watched kindly over her little brothers.</p><p>Her poor family tasted largely of the cup of sorrow, but poverty and distress, instead of producing impatience and unkindness, seemed to bind each one more closely to the other. They experienced the truth of those words: \"Better is a dinner of herbs where love is, than a stalled ox and hatred with it,\" Prov. 15:17. \"Better is a dry morsel, and quietness with it, than a house full of sacrifices with strife,\" Prov. 17:1.</p><p>Another feature in Sarah's character may be here noticed: this was her love of truth. \"She has never deceived me,\" was her mother's frequent remark. \"I cannot remember a single instance of untruth, even in play ,\" and perhaps this truthfulness of spirit enabled her the more readily to trust the word of another. \"She promised me,\" Sarah would say, and on the promise she would ever rest, in all the sweet dependence of a child. Surely this may speak a word to those professing to be the followers of Him who keeps his promise forever—the covenant-keeping God. How lightly are promises often made! how carelessly and thoughtlessly broken!</p><p>At an early period of her illness, a violent attack of pain and palpitation of the heart made her think she was dying, and she told her mother so, adding, \"But I am not afraid, I am so happy.\" \"What makes you so happy?\" was asked. \"Because I am going to heaven, and when I pray to Jesus, my heart seems lifted up.\" \"But, Sarah, do you think your sins forgiven?\" \"Yes, mother, I am sure so.\" \"What makes you so sure?\" \"Because Jesus says so .\"</p><p>\"Jesus says,\"—this was ever the ground of her confidence, and proved to all around her the Saviour's often-repeated lesson,—\"Whoever shall not receive the kingdom of God as a little child, shall in no wise enter in it.\"</p><p><strong>Reflect:</strong> The account notices Sarah's love for her family and her trust in Jesus amid hardship. Poverty and illness are not signs that God has abandoned a family. What practical care could you offer someone facing need today? Which promise of Jesus can you bring to prayer?</p><p><strong>Prayer:</strong> Lord Jesus, receive us with the kindness you showed to children. Teach us to trust your word and to care for neighbors in need. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000327",
    "value": "<p><strong>Read: Psalm 23:4; John 10:27–29.</strong></p><p><em>Historical context:</em> The memorial tells of Sarah's final illness and her family's grief. Its language reflects one family's experience; it does not prescribe how every person must face death.</p><p><strong>From the memorial:</strong></p><p>Many were the words of comfort she spoke to her poor sorrowing mother, whose heart at times seemed almost broken at the prospect of losing her. She said, \"You will not cry, when I am in heaven, dear mother. I am only going a little while first, and you will soon follow;\" and once, on an occasion of deep family distress, she pointed to the surest way for relief, saying, \"Mother, why do you cry so? Does not the Bible say God cares for the sparrows, and are not you better than a sparrow? O mother, pray, do pray, and then you will be so happy.\"</p><p>In this state of mind Sarah drew near the end of her pilgrimage, and it was not until about three days before her death that even the shadow of a cloud seemed to darken her path. Then, for the first time, her mind was agitated with doubts as to her Saviour's love for her, and very distressing to those around her were her anxious cries for pardon. \"Father, forgive me, for Jesus Christ's sake,\" was her constant petition. She was visited by a minister and by several Christian friends, who used every effort to give her relief, but for some time all in vain; she seemed unable to lay hold on any promise for her comfort. One of these friends especially felt a deep interest in the dear child, though she had not known her until now. Of her little Sarah asked most earnestly, \"Do you think that Jesus loves me?\" She was assured that he did. \"Do you know he loves me?\" she asked; and then followed the solemn inquiry, \"How do you know it?\" After reading and talking with her for some time, she begged her friend would \"pray with her to make her a little happy?\" and afterwards in her own words, she would again plead with God, \"Father, forgive me, for Jesus Christ's sake, and wash me in his blood, and make me a good girl, and take me to heaven.\" On one occasion she said, \"I wish I could be a little happy,—I want something, I do not know what I want.\" She was answered, \"I think I can tell you what you want, it is peace, it is to feel that God has pardoned all your sins.\" \"Yes,\" she replied, \"I think that is it.\"</p><p>At night, as her parents were watching beside her, she suddenly raised herself, and, throwing her arms alternately round the neck of each, seemed to take a last farewell. She was unable to speak, but to her mother's inquiry, \"Tell me once again, my child, are you quite happy?\" she replied by lifting up her hand, and pointing to heaven, while the brightest smile lighted up her countenance. This was her last act of consciousness. She lingered a few hours without any apparent suffering, and then her happy spirit took its flight, and joined the blissful company, that, having washed their robes and made them white in the blood of the Lamb, are ever before the throne of God, rejoicing in their Saviour's love.</p><p>Sarah died at the age of eleven years, in August, 1848.</p><p><strong>Reflect:</strong> Sarah's words tried to comfort her mother, and the account also records Sarah's own fear and need for reassurance. Grief and anxiety do not disqualify anyone from Christ's care. Where do you need companionship or prayer today? How could you sit with someone who is grieving?</p><p><strong>Prayer:</strong> Good Shepherd, be near those who are ill and those who mourn. Hold us when we are afraid, and make us patient companions to one another. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000327",
    "value": "<p><strong>Read: Mark 10:14; John 6:37.</strong></p><p><em>Historical context:</em> The booklet closes with a direct invitation to trust Jesus. Its questions belong to the original memorial.</p><p><strong>From the memorial:</strong></p><p>Dear reader, before you close this book, ask, \"Am I like Sarah G——? Have I ever prayed to Jesus to wash away all my sins, and make my soul quite white in his precious blood?\" And then have you begged him to take you to heaven when you die, that you may be happy with him forever? If not, do not wait another day, but ask him now to give you his Holy Spirit to teach you to love him. Remember, it is this kind Saviour who calls you, who says, \"Suffer the little children to come to me, and forbid them not;\" and who promises to gather the lambs with his arm, and to carry them in his bosom.</p><p><strong>Reflect:</strong> Sarah's story is a testimony, not a standard of courage that children or adults must meet. Jesus welcomes people who come to him, including those who have questions, sorrow, or little strength. What would you like to tell him honestly today?</p><p><strong>Prayer:</strong> Lord Jesus, thank you for welcoming children and adults alike. Help me come to you honestly and trust your mercy. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p>Read: 1 Corinthians 10:24. Robert Cushman's sermon begins with Paul's call to seek another person's good. The question belongs in ordinary decisions: whose needs do I notice, and whose burdens do I ignore? Choose one act of care today that costs something small but real.</p><p>Prayer: Lord Jesus, turn my attention outward and teach me to love my neighbor as you have loved me. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p>Read: 1 Corinthians 12:25-26. Cushman warned that pride and self-seeking damage the peace of a church. Because believers belong to one body in Christ, another person's hurt deserves our attention. Listen before defending your own place, and consider how to protect someone's dignity.</p><p>Prayer: God of peace, make me attentive to the members of your body who are overlooked. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p>Read: Philippians 2:4. Looking to the interests of others does not erase our own needs; it widens our care. Cushman's central appeal was practical rather than merely sentimental. Ask who might benefit from your time, resources, or patient attention today.</p><p>Prayer: Lord, show me a neighbor I can serve with the gifts you have entrusted to me. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p>Read: 2 Corinthians 13:5. Cushman's sermon turns the warning about self-love toward honest self-examination. We can do a generous thing while still seeking praise or control. Bring your motives into Christ's light without despair, and ask him to renew your love.</p><p>Prayer: Merciful God, uncover what is selfish in me and form the generosity of Christ in its place. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000369",
    "value": "<p><strong>Scripture:</strong> Romans 14:7-9</p><p><strong>Historical context:</strong> James Slade preached this sermon in Bolton after the death of a fellow minister, William Thistlethwaite. He began with Paul's assurance that we belong to the Lord in life and in death.</p><p><strong>From James Slade&#x27;s sermon:</strong> The eternal Son of God stooped down from heaven to earth; the Word, which was in the beginning with God and was God, was made flesh; “humbled Himself and became obedient to death;” “bore our sins in His own body on the tree:” died and rose again, rose as the first fruits of a sleeping world.</p><p><strong>Reflection:</strong> Slade connects that belonging to Jesus' incarnation, death, and resurrection. Our hope rests in what Christ has done, not in a claim to control our future. Where are you trying to carry everything alone today? Name that concern before the risen Lord and ask how belonging to him can shape your next step.</p><p><strong>Prayer:</strong> Risen Lord Jesus, remind me that I belong to you. Turn my attention from self-reliance to your faithful love, and guide my choices today. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000369",
    "value": "<p><strong>Scripture:</strong> Colossians 3:23-24</p><p><strong>Historical context:</strong> Slade moves from hope beyond death to ordinary responsibilities. He does not ask readers to abandon their work, but to bring it under Christ's care.</p><p><strong>From James Slade&#x27;s sermon:</strong> Each of them still, while in the body, attentive to the duties of his own calling: no earthly business or occupation, belonging to their respective conditions, despised or neglected; but all “done heartily as to the Lord, and not as to men:” all earthly desires so regulated, all earthly plans so formed, all earthly objects so pursued, as not to interrupt, much less to stifle, the life of God in the soul.</p><p><strong>Reflection:</strong> Serving the Lord includes the work already before us: earning a living, caring for another person, and keeping a promise. The question is not whether a task looks important, but whether love and integrity guide it. Choose one ordinary duty today and do it attentively for Christ and for the person it serves.</p><p><strong>Prayer:</strong> Lord Jesus, help me serve you in the responsibilities of this day. Give me patience, honesty, and care for the people affected by my work. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000369",
    "value": "<p><strong>Scripture:</strong> Romans 14:8</p><p><strong>Historical context:</strong> Slade reports words spoken by William Thistlethwaite during a painful illness. They describe one person's prayer, not a standard every believer must meet while dying or grieving.</p><p><strong>From James Slade&#x27;s sermon:</strong> I wish you distinctly to understand how I am: I have no ecstasies, no rapturous flights, but a calm composure, a quiet resting, a peaceful waiting for the Lord: and I desire the Lord to deal with me as seems to Him good: to give me patience, to give me his grace that I may endure to the end; and to continue or remove me at His pleasure.</p><p><strong>Reflection:</strong> Thistlethwaite asked for patience and grace, without claiming an extraordinary feeling. Faith can also speak through fear, tears, and questions. If you are grieving, you do not need to manufacture calm for God. Tell him honestly what you need, and receive the care of others when it is offered.</p><p><strong>Prayer:</strong> Merciful Lord, meet me in grief and uncertainty. Give me grace for this day and people who will sit with me in love. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000369",
    "value": "<p><strong>Scripture:</strong> 2 Timothy 2:19</p><p><strong>Historical context:</strong> In the original sermon, Slade addressed a congregation mourning its pastor. His closing words turn from that local loss to the Lord's knowledge of his people.</p><p><strong>From James Slade&#x27;s sermon:</strong> The world knows them not; the earthly shepherd himself may not have known them all: but “the Lord knows them that are His.”</p><p><strong>Reflection:</strong> Human communities remember imperfectly. Some acts of faithfulness go unseen, and even a caring pastor cannot know everyone. Slade points toward a steadier comfort: the Lord knows those who are his. If you feel overlooked, bring that ache to God. If someone else is easily overlooked, offer them your attention today.</p><p><strong>Prayer:</strong> Lord, thank you for knowing your people. Comfort those who feel forgotten, and teach me to notice and care for them. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000381",
    "value": "<p>4th. Immediately upon the Paschal feast followed, during the next seven days, the Feast of Unleavened Bread , during which were to be offered, each day —</p><p>Two young bullocks,</p><p>One ram,</p><p>Seven lambs,</p><p>For a burnt-offering, with flour and oil,</p><p>and one goat daily for a sin-offering (Num. 28. 17–25).</p><p>5th. On presenting the sheaf of First-fruits to the Lord, of which it is said “You shall neither eat bread nor parched corn , nor green ears , until the selfsame day that you have brought an offering to your God” (Lev. 23. 14). On that day was to be offered a male lamb, without blemish, of the first year, for a burnt-offering, with flour, oil, and wine,—“an offering made by fire to the Lord for a sweet savour” (Lev. 23. 13).</p><p>6th. The Feast of Pentecost (called also feast of weeks, Ex. 34. 22), fifty days later, on presenting to the Lord a new food-offering from their habitations (Lev. 23. 16). Two wave loaves of fine flour, baken with leaven, “They are the first-fruits to the Lord” (Lev. 23. 17), and the accompanying offerings were—</p><p>Seven lambs of first year,</p><p>Two young bullocks,</p><p>One ram,</p><p>For a burnt-offering,</p><p>and one kid for a sin-offering (to make atonement—Num. 28. 30), and two lambs for a peace-offering (Lev. 23. 19).</p><p>7th. At the Feast of Trumpets , the first of the seventh month—</p><p>One young bullock,</p><p>One ram,</p><p>Seven lambs,</p><p>With flour and oil.</p><p>for a burnt-offering for a sweet savour to the Lord, and one kid for a sin-offering “to make atonement for you” (Num. 29. 2–5).</p><p>8th. On the annual Day of Atonement , the tenth of the seventh month: One young bullock for a sin-offering, and a ram for a burnt-offering for the high priest and his house (Lev. 16. 6), and two kids of the goats from the congregation for a sin-offering (one for the annual sin-offering, and one for the scape-goat) (Lev. 16. 5). Also—</p><p>One bullock,</p><p>One ram, and</p><p>Seven lambs,</p><p>With food offering of flour and oil,</p><p>for a burnt-offering (Num. 29. 8). And one kid for a sin-offering of atonement (Num. 29. 11).</p><p>This was a day of great solemnity—“It shall be a holy convocation to you, and you shall afflict your souls” (Lev. 23. 27), &amp;c, “You shall do no work; . . . it is a day to make atonement for you before the Lord your God ” (Lev. 23. 28); and whoever among the congregation did not afflict his soul, or whoever did any work in it, was to be cut off from among his people (Lev. 23. 29, 30). “It shall be . . . a sabbath of rest, and you shall afflict your souls: in the ninth day at even, from even to even, shall you celebrate your sabbath” (Lev. 23. 32).</p><p>The high priest was not to enter within the veil to the inner tabernacle, except on this day, “that he die not,” and then only with the blood of the sin-offerings for himself and the congregation, peculiar to this day.</p><p>Before doing so he laid aside his ornamental garments and put on a linen dress (Lev. 16. 2–4). He took in his hands a censer of burning coals from the altar of burnt offerings and put on it a handful of incense, that the cloud of the incense might cover the mercy seat, whereon the Lord appeared in the cloud, “that he die not” (Lev. 16. 12, 13). He then took the blood of the sin-offerings, both for the priest and people, within the veil, and sprinkled it with his finger upon the mercy seat eastward, and before the mercy seat seven times (Lev. 16. 15, 16), to make an atonement for the Holy Place, because of the uncleanness of the children of Israel, and because of their transgressions in all their sins (Lev. 16. 16).</p><p>This is the only sacrifice described in the Law, which corresponds with the words in Hebrews 13. 11:—“The bodies of those beasts whose blood is brought into the sanctuary for sin, are burned without the camp.”</p><p>No other blood was annually brought into the sanctuary (or inner temple) by the high priest on behalf of the people, and sprinkled on and before the mercy seat; and the flesh of these, as well as of some other offerings, was burned without the camp.</p><p>The service of this day required that in addition to a bullock for a sin-offering, and a ram for a burnt-offering, to make atonement for himself and his house (Lev. 16. 3–6), the high priest should take of the congregation of Israel two kids of the goats for a sin-offering (Lev. 16. 5); he was to present the two kids at the door of the tabernacle (ver. 7), and “cast lots,” one for the Lord and one “for the scape-goat” (vers. 8 and 10). He killed the former for a sin-offering for the people, and proceeded as already described ( ).</p><p>In addition to the blood taken within the veil, the high priest was to put some of it upon the horns of the altar, and sprinkle it seven times upon it to hallow it (vers. 18, 19).</p><p>Then, as to the other, or scape-goat, Aaron laid both his hands on the head of the live goat and confessed over him all the iniquities of the children of Israel, and all their transgressions in all their sins; putting them on the head of the goat, and sent him away by the hand of a fit man into the wilderness, and the “goat bore them away to a land not inhabited” (Lev. 16. 21).</p><p>Although every sin-offering had a reference to the Lord Jesus Christ, the kid offered on this day by the masses of the people is treated in Heb. 13. as having a very special application to Him, from the blood having been carried within the veil and sprinkled on the mercy seat, and from the body having been burned without the camp. So Jesus, having suffered without the gate, and having obtained eternal redemption for us, not by the blood of others, but by His own blood, having “given Himself a ransom for all,” entered not into the holy places made with hands, but into Heaven itself, there to appear in the presence of God for us.</p><p>Again, in the scape-goat, which was the complement of the sin-offering, we have a reference to the Lord Jesus bearing away our sins “in His own body on the tree,” so that they should be no more remembered against us (1 Pet. 2. 24).</p><p>9th. There remains one more appointed festival, the Feast of Tabernacles , or ingathering (Exod. 23. 16) on the fifteenth day of the seventh month, when the crops of wine and oil had completed the harvest labours. It lasted seven days, with offerings appointed for each day.</p><p>Over seven days, the number of bulls declined from 13 to 7, while two rams, 14 lambs, and one goat for a sin offering were brought each day, together with food and drink offerings (Num. 29. 12–34).</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000381",
    "value": "<p>On the eighth day, a holy convocation was held, with offerings of one bullock, one ram and seven lambs, with accompaniments, and one ram for a sin-offering . “These things shall you do to the Lord in your set feasts, besides your vows, and your freewill offerings, for your burnt-offerings, and for your food-offerings, and for your drink-offerings, and for your peace-offerings” (Num. 29. 12–39).</p><p>The service of the Tabernacle and its offerings were supplied by contributions of half a shekel per head on all that were numbered, from twenty years old and upwards. The rich were not to give more, nor the poor less. It was offered to the Lord to make an atonement for their souls (Exod. 30. 14–16).</p><p>As indicated in the latter portion of the above quotation (Num. 29. 39), besides these stated daily, monthly, and annual sacrifices, which were of a public or general character, there were—</p><p>1st. Voluntary offerings , which do not seem to have been specially enjoined, nor to have had reference to any particular sins, but arose from the voluntary will and devotion of the person offering, and the priest sprinkled the blood round about upon the altar; “and it was accepted for him to make an atonement for him ” (Lev. 1. 2–5); “an offering made by fire of a sweet savour to the Lord” (ver. 9). It was required to be a male without blemish of the herd or of the flock, two turtle-doves, or two young pigeons (vers. 2 and 10–17).</p><p>2nd. Peace-offerings , also for the most part voluntarily, in which the offerer shared with the priest the offering—a male or female of the herd without blemish, or a lamb or goat (Lev. 3. 1, &amp;c.).</p><p>3rd. The Sin-offering for sins of ignorance afterwards brought to light (Lev. 4. 13, &amp;c.).</p><p>4th. The Trespass-offering .—If any one sinned in hearing swearing and not uttering it, or in any uncleanness, or swearing, he was to take a lamb or a kid (a female), or two turtle-doves, or two young pigeons, or, if too poor for any of them, the tenth part of an ephah of fine flour, “and the priest shall make an atonement for him for the sin which he has sinned, and it shall be forgiven him” (Lev. 5. 1–13).</p><p>In every case the offering was required to be perfect in its kind, and without blemish.</p><p>The sin-offering was more especially for atonement; but the voluntary and other offerings are spoken of as contributing thereto (Lev. 1. 3): coming from the voluntary will of the people, they expressed the heart’s devotion, and bore a “sweet savour to God.”</p><p>But in the days when Isaiah wrote, and when great corruption prevailed, it is said, “Incense is an abomination to Me; the new moons and sabbaths, the calling of assemblies, I cannot away with” (Isa. 1. 13). And Amos says, “I will not smell in your solemn assembly” (Amos 5. 21). The people drew near with the lip, but the heart was far from God (Isa. 29. 13); so the sacrifices bore with them no sweet savour of devotion to Him.</p><p>In contemplating the mass of sacrifices thus noted, we may easily enter into the feeling expressed by Paul (more especially as regarded circumcision)—“which neither we nor our fathers were able to bear;” and we can the more fully appreciate the blessing of the Gospel, which has relieved us from all such burdens, and given us individually a free access (whether Jew or Gentile) to the Father of Mercies, through the one only High Priest, Jesus Christ our Lord.</p><p>But it was not so much to point out the burdens which our forefathers in the faith of Christ had to bear—burdens which, nevertheless, were light compared with the burden of unforgiven sin—that we have traced the requirements of the law; but to point to the testimony they bore to Christ and His Kingdom.</p><p>Under the law no Israelite could obtain pardon for his sin except through the Priest , who was the appointed mediator—to him he brought the prescribed offering, and slew it at the Tabernacle door; the priest received the blood, and some of the internal fat; the former he sprinkled, and the latter he burned, on the altar; and, in the words of the text, “ The priest shall make an atonement for his sin , and it shall be forgiven him .”</p><p>We may not be able to define the extent to which the Holy Spirit was then enjoyed, but we cannot doubt that the testimony of a conscience free of offence towards God was sealed on the mind of the offerer when the atonement was made agreeably to the words, “You shall therefore keep my statutes and my judgments; which if a man do he shall live in them” (Lev. 18. 5).</p><p>The Apostle Paul confirms this language, saying, “The man that does them” (the statutes of the Law) “shall live in them” (Gal. 3. 12); and when we consider the words of the same writer: “The children of Israel could not steadfastly look to the end of that which is abolished” (2 Cor. 3. 13), we need not suppose the offerers had, in general, any understanding that what they did had a special relation to the better Mediator to come. As in the case of the brazen serpent they looked to it and were healed; so here they made their offerings believing in their efficacy, and reaped the fruit of pardon and peace.</p><p>This divinely-instituted law was enjoined on the people under the most solemn assurances of blessings for obedience, and cursings for disobedience, viz.: “See I set before you this day a blessing and a curse; a blessing if you obey the commandments of the Lord your God which I command you this day: and a curse if you will not obey the commandments of the Lord your God, but turn aside after other gods” (Deut. 11. 26–28; 27. 15–26; and ch. 28.). “I call heaven and earth to record this day against you, that I have set before you life and death, blessing and cursing: therefore choose life, that both you and your seed may live, that you may love the Lord your God, and that you may obey His voice, and that you may cleave to Him; for He is your life and the length of your days: that you may dwell in the land which the Lord sware to your fathers, to Abraham, to Isaac, and to Jacob, to give them” (Deut. 30. 19, 20).</p><p>They did what God had provided to enable them to walk with Him, and when they erred or failed to keep His holy law they brought the means of reconciliation He had appointed. In such way a man might do justly, love mercy, and walk humbly with his God, which is the whole duty of man.</p>",
    "day_number": 5
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_plans as target
set total_days = edit.value, updated_at = timestamptz '2026-10-22 14:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "value": 115
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
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 1,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 2,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 3,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 4,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 5,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 6,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 7,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 8,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 9,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 10,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 11,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 12,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 13,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 14,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 15,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 16,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 17,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 18,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 19,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 20,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 21,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 22,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 23,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 24,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000283",
    "day_number": 25,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 1,
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000327",
    "day_number": 1,
    "references": [
      "Mark 10:13-16",
      "Proverbs 15:17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000327",
    "day_number": 2,
    "references": [
      "Psalm 23:4",
      "John 10:27-29"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000327",
    "day_number": 3,
    "references": [
      "Mark 10:14",
      "John 6:37"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 1,
    "references": [
      "1 Corinthians 10:24"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 2,
    "references": [
      "1 Corinthians 12:25-26"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 3,
    "references": [
      "Philippians 2:4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 4,
    "references": [
      "2 Corinthians 13:5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000369",
    "day_number": 1,
    "references": [
      "Romans 14:7-9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000369",
    "day_number": 2,
    "references": [
      "Colossians 3:23-24"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000369",
    "day_number": 4,
    "references": [
      "2 Timothy 2:19"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-22 14:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-22 14:00:00+00', timestamptz '2026-10-22 14:00:00+00');
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
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 2,
    "title": "Morning Prayer 2",
    "content": "<p>The morning bright</p><p>With rosy light</p><p>Has waked me from my sleep;</p><p>Father, I own</p><p>Thy love alone</p><p>Thy little one doth keep.</p><p>All through the day,</p><p>I humbly pray,</p><p>Be Thou my Guard and Guide;</p><p>My sins forgive</p><p>And let me live,</p><p>Blest Jesus, near Thy side. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 3,
    "title": "Morning Prayer 3",
    "content": "<p>Now I raise me up from sleep,</p><p>I thank the Lord who did me keep,</p><p>All through the night; and to Him pray</p><p>That He may keep me through the day.</p><p>All which for Jesus' sake, I say. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 4,
    "title": "Morning Prayer 4",
    "content": "<p>O help me, Lord, this day to be</p><p>Thy own dear child and follow Thee;</p><p>And lead me, Savior, by Thy hand</p><p>Until I reach the heavenly land. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 5,
    "title": "Morning Prayer 5",
    "content": "<p>O Lord, my God, to Thee pray</p><p>While from my bed I rise</p><p>That all I do and all I say</p><p>Be pleasing to Thine eyes. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 6,
    "title": "Morning Prayer 6",
    "content": "<p>Jesus, Lord, to Thee I pray,</p><p>Guide and guard me through this day.</p><p>As the shepherd tends his sheep.</p><p>Lord, me safe from evil keep.</p><p>Keep my feet from every snare,</p><p>Keep me with Thy watchful care.</p><p>All my little wants supply</p><p>If I live or if I die.</p><p>And when life, O Lord, is past,</p><p>Take me to Thyself at last. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 7,
    "title": "Morning Prayer 7",
    "content": "<p>In the early morning,</p><p>With the sun's first rays.</p><p>All God's little children</p><p>Thank and pray and praise.</p><p>I, too, thanks would offer,</p><p>Jesus, Shepherd dear,</p><p>For Thy tender pasture,</p><p>For Thy guiding care.</p><p>And I would implore Thee,</p><p>Be with me this day,</p><p>Lest I from Thee wander,</p><p>Into danger stray. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 8,
    "title": "Morning Prayer 8",
    "content": "<p>For this new morning with its light,</p><p>For rest and shelter of the night,</p><p>For health and food, for love and friends.</p><p>For everything Thy goodness sends,</p><p>We thank Thee, dearest Lord. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 9,
    "title": "Morning Prayer 9",
    "content": "<p>I thank Thee, Lord, for sleep and rest,</p><p>For all the things that I love best,</p><p>Now guide me through another day</p><p>And bless my work and bless my play.</p><p>Lord, make me strong for noble ends,</p><p>Protect and bless my loving friends;</p><p>Of all mankind good Christians make.</p><p>All this I ask for Jesus' sake. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 10,
    "title": "Morning Prayer 10",
    "content": "<p>Jesus, gentle Shepherd,</p><p>Bless Thy lamb to-day;</p><p>Keep me in Thy footsteps,</p><p>Never let me stray.</p><p>Guard me through the daytime.</p><p>Every hour, I pray;</p><p>Keep my feet from straying</p><p>From the narrow way. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 11,
    "title": "Morning Prayer 11",
    "content": "<p>Keep my little tongue to-day,</p><p>Keep it gentle while I play;</p><p>Keep my hands from doing wrong.</p><p>Keep my feet the whole day long;</p><p>Keep me all, O Jesus mild,</p><p>Keep me ever Thy dear child. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 12,
    "title": "Morning Prayer 12",
    "content": "<p>Jesus, keep me all this day.</p><p>When at school and when at play;</p><p>May I do all things I ought,</p><p>May I hate each evil thought;</p><p>Help me love and trust in Thee</p><p>Now and through eternity. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 13,
    "title": "Morning Prayer 13",
    "content": "<p>O blessed Lord, protect Thou me</p><p>And my dear parents graciously;</p><p>With Thy strong arm be ever near</p><p>To brothers and to sisters dear.</p><p>And all our loved ones in the land,</p><p>Protect them with Thine own right hand.</p><p>From sin defend and keep me free;</p><p>Help me a Christlike child to be. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 14,
    "title": "Morning Prayer 14",
    "content": "<p>My Father, for another night</p><p>Of quiet sleep and rest.</p><p>For all the joys of morning light,</p><p>Thy holy name be blest. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 15,
    "title": "Morning Prayer 15",
    "content": "<p>Now with the new-born day I give</p><p>Myself anew to Thee,</p><p>That as Thou willest, I may live,</p><p>And what Thou willest, be. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 16,
    "title": "Morning Prayer 16",
    "content": "<p>Lord, for the mercies of this night</p><p>My humble thanks I pay</p><p>And unto Thee I give myself</p><p>To-day and every day. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 17,
    "title": "Morning Prayer 17",
    "content": "<p>Whate'er I do, things great or small</p><p>Whate'er I speak or frame.</p><p>Thy glory may I seek in all,</p><p>Do all in Jesus' name.</p><p>My Father, for His sake I pray.</p><p>Thy child accept and bless</p><p>And lead me by Thy grace to-day</p><p>In paths of righteousness. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 18,
    "title": "Morning Prayer 18",
    "content": "<p>I thank Thee, my heavenly Father, through Jesus Christ, Thy dear Son, that Thou hast kept me this night from all harm and danger; and I pray Thee that Thou wouldst keep me this day also from sin and every evil, that all my doings and life may please Thee. For into Thy hands I commend myself, my body and soul, and all things. Let Thy holy angel lie with me, that the wicked Foe may have no power over me. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 19,
    "title": "Evening Prayer 19",
    "content": "<p>Savior, lay Thy hand on me,</p><p>Bless me, and remember me. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 20,
    "title": "Evening Prayer 20",
    "content": "<p>Now I lay me down to sleep;</p><p>I pray Thee, Lord, my soul to keep.</p><p>If I should die before I wake.</p><p>I pray Thee, Lord, my soul to take;</p><p>And this I ask for Jesus' sake. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 21,
    "title": "Evening Prayer 21",
    "content": "<p>Dear Father in heaven,</p><p>Look down from above;</p><p>Bless papa and mama,</p><p>And those whom I love.</p><p>May angels guard over</p><p>My slumbers, and when</p><p>The morning is breaking,</p><p>Awake me. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 22,
    "title": "Evening Prayer 22",
    "content": "<p>Now the light has gone away;</p><p>Savior, listen while I pray.</p><p>Asking Thee to watch and keep</p><p>And to send me quiet sleep.</p><p>Jesus, Savior, wash away</p><p>All that has been wrong to-day;</p><p>Help me every day to be</p><p>Good and gentle, more like Thee.</p><p>Let my near and dear ones be</p><p>Always near and dear to Thee.</p><p>O bring me and all I love</p><p>To Thy happy home above. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 23,
    "title": "Evening Prayer 23",
    "content": "<p>In my little bed I lie:</p><p>Heavenly Father, hear my cry;</p><p>Lord, keep Thou me through this night.</p><p>Bring me safe to morning light. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 24,
    "title": "Evening Prayer 24",
    "content": "<p>The day is past and over,</p><p>All thanks, O Lord, to Thee!</p><p>O Jesus, keep me in Thy sight</p><p>And save me through the coming night.</p><p>Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 25,
    "title": "Evening Prayer 25",
    "content": "<p>The day is done;</p><p>O God the Son,</p><p>Look down upon</p><p>Thy little one!</p><p>O Light of Light,</p><p>Keep me this night,</p><p>And shed round me</p><p>Thy presence bright.</p><p>I need not fear</p><p>If Thou art near;</p><p>Thou art my Savior</p><p>Kind and dear. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 26,
    "title": "Evening Prayer 26",
    "content": "<p>Forgive, O Lord, for Thy dear Son</p><p>The ill that I this day have done.</p><p>That with the world, myself, and Thee</p><p>I, ere I sleep, at peace may be. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 27,
    "title": "Evening Prayer 27",
    "content": "<p>Watch o'er a little child to-night,</p><p>Blest Savior from above,</p><p>And keep me till the morning light</p><p>Within Thine arms of love. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 28,
    "title": "Evening Prayer 28",
    "content": "<p>Jesus, tender Shepherd, hear me:</p><p>Bless Thy little child to-night;</p><p>Through the darkness be Thou near me,</p><p>Keep me safe till morning light.</p><p>All this day Thy hand has led me,</p><p>And I thank Thee for Thy care;</p><p>Thou hast warmed me, clothed me, fed me;</p><p>Listen to my evening prayer.</p><p>May my sins be all forgiven;</p><p>Bless the friends I love so well;</p><p>Take me, Lord, at last to heaven.</p><p>Happy there with Thee to dwell. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 29,
    "title": "Evening Prayer 29",
    "content": "<p>Lord, send me sleep that I may live;</p><p>The wrongs I've done this day forgive.</p><p>Bless every deed and thought and word</p><p>I've rightly done, or said, or heard.</p><p>Bless relatives and friends alway;</p><p>Teach all the world to watch and pray.</p><p>My thanks for all my blessings take</p><p>And hear my prayer for Jesus' sake.</p><p>Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 30,
    "title": "Evening Prayer 30",
    "content": "<p>Abide with me! Fast falls the eventide,</p><p>The darkness deepens; Lord, with me abide!</p><p>When other helpers fail and comforts flee,</p><p>Help of the helpless, O abide with me! Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 31,
    "title": "Evening Prayer 31",
    "content": "<p>At the close of every day,</p><p>Lord, to Thee I kneel and pray.</p><p>Look upon Thy little child,</p><p>Look in love and mercy mild.</p><p>O forgive and wash away</p><p>All my naughtiness this day,</p><p>And both when I sleep and wake</p><p>Bless me for my Savior's sake. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 32,
    "title": "Evening Prayer 32",
    "content": "<p>Lord, I have passed another day</p><p>And come to thank Thee for Thy care.</p><p>Forgive my faults in work or play</p><p>And listen to my evening prayer.</p><p>Thy favor gives me daily bread</p><p>And friends, who all my wants supply:</p><p>And safely now I rest my head,</p><p>Preserved and guarded by Thine eye.</p><p>Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 33,
    "title": "Evening Prayer 33",
    "content": "<p>All praise to Thee, my God, this night</p><p>For all the blessings of the light:</p><p>Keep me, O keep me, King of kings,</p><p>Beneath Thine own almighty wings. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 34,
    "title": "Evening Prayer 34",
    "content": "<p>I fall asleep in Jesus' wounds,</p><p>There pardon for my sins abounds;</p><p>Yea, Jesus' blood and righteousness</p><p>My jewels are, my glorious dress,</p><p>Wherein before my God I'll stand</p><p>When I shall reach the heavenly land.</p><p>Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 35,
    "title": "Evening Prayer 35",
    "content": "<p>The toils of day are over;</p><p>I lift my heart to Thee</p><p>And ask that free from peril</p><p>The hours of night may be.</p><p>O Jesus, make their darkness light</p><p>And guard me through the coming night. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 36,
    "title": "Evening Prayer 36",
    "content": "<p>O Lord God, I pray Thee, for Christ's sake, forgive me whatsoever I have done wrong this day and keep me safe all the night while I am asleep. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 37,
    "title": "Evening Prayer 37",
    "content": "<p>I thank Thee, my heavenly Father, through Jesus Christ, Thy dear Son, that Thou hast graciously kept me this day; and I pray Thee that Thou wouldst forgive me all my sins where I have done wrong, and graciously keep me this night. For into Thy hands I commend myself, my body and soul, and all things. Let Thy holy angel be with me, that the wicked Foe may have no power over me. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 38,
    "title": "Prayer Before Meals 38",
    "content": "<p>Abba, Jesus! Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 39,
    "title": "Prayer Before Meals 39",
    "content": "<p>Abba, Father, bless this food</p><p>For our everlasting good. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 40,
    "title": "Prayer Before Meals 40",
    "content": "<p>Come, Lord Jesus, be our Guest</p><p>And let Thy gifts to us be blest. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 41,
    "title": "Prayer Before Meals 41",
    "content": "<p>O Bread of Life, from day to day</p><p>Be Thou our Comfort, Food, and Stay.</p><p>Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 42,
    "title": "Prayer Before Meals 42",
    "content": "<p>Be present at our table, Lord,</p><p>Be here and everywhere adored.</p><p>Thy creatures bless and grant that we</p><p>May feast in paradise with Thee. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 43,
    "title": "Prayer Before Meals 43",
    "content": "<p>Great God, Thou Giver of all good,</p><p>Accept our praise and bless our food.</p><p>Grace, health, and strength to us afford</p><p>Through Jesus Christ, our blessed Lord.</p><p>Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 44,
    "title": "Prayer Before Meals 44",
    "content": "<p>Jesus, bless what Thou hast given,</p><p>Feed our souls with bread from heaven;</p><p>Guide and lead us all the way</p><p>In all that we may do and say. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 45,
    "title": "Prayer Before Meals 45",
    "content": "<p>Lord God, heavenly Father, bless us and these Thy gifts which we receive from Thy bountiful goodness, through Jesus Christ, our Lord. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 46,
    "title": "Prayer Before Meals 46",
    "content": "<p>The eyes of all wait upon Thee, O Lord, and Thou givest them their meat in due season: Thou openest Thine hand and satisfiest the desire of every living thing. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 47,
    "title": "Prayer Before Meals 47",
    "content": "<p>Grant us Thy grace, O Lord, that, whether we eat or drink, or whatsoever we do, we may do it all in Thy name and to Thy glory. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 48,
    "title": "Prayer After Meals 48",
    "content": "<p>Thanks, Lord Jesus! Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 49,
    "title": "Prayer After Meals 49",
    "content": "<p>Thanks be unto Thee, O God! Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 50,
    "title": "Prayer After Meals 50",
    "content": "<p>The Lord is my Shepherd, I shall not want. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 51,
    "title": "Prayer After Meals 51",
    "content": "<p>We thank the Lord</p><p>For meat and drink</p><p>Through Jesus Christ. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 52,
    "title": "Prayer After Meals 52",
    "content": "<p>We thank Thee, dear Lord Jesus.</p><p>That Thou our Guest hast been;</p><p>O be Thou with us ever</p><p>And save us from all sin. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 53,
    "title": "Prayer After Meals 53",
    "content": "<p>We thank Thee for those gifts, O Lord;</p><p>Pray feed our souls, too, with Thy Word.</p><p>Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 54,
    "title": "Prayer After Meals 54",
    "content": "<p>O give thanks unto the Lord, for He is good; for His mercy endureth forever. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 55,
    "title": "Prayer After Meals 55",
    "content": "<p>Bless the Lord, O my soul; and all that is within me bless His holy name. Bless the Lord, O my soul, and forget not all His benefits. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 56,
    "title": "Prayer After Meals 56",
    "content": "<p>Heavenly Father, accept our thanks for this and for all Thy blessings, through Jesus Christ. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 57,
    "title": "Prayer After Meals 57",
    "content": "<p>O God, who givest unto all their food, make us thankful and provide for all the needy, now and evermore. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 58,
    "title": "Prayer After Meals 58",
    "content": "<p>Accept, O Lord, our thankful praises</p><p>For all Thy goodness did bestow;</p><p>May it increase our faith and lead us</p><p>Our praise by godly lives to show,</p><p>That every deed and word may prove</p><p>We trust and own our Father's love.</p><p>Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 59,
    "title": "Prayer After Meals 59",
    "content": "<p>We thank Thee, Lord God, heavenly Father, through Jesus Christ, our Lord, for all Thy benefits, who livest and reignest forever and ever. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 60,
    "title": "Prayer After Meals 60",
    "content": "<p>O Lord, we thank Thee for our daily bread. May it strengthen and refresh our bodies! And we pray Thee, nourish our souls with Thy heavenly grace, through Jesus Christ, our Lord. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 61,
    "title": "Prayer After Meals 61",
    "content": "<p>The Lord is good to all, and His tender mercies are over all His works. Bless the Lord, O my soul, and all that is within me, bless His holy name. Bless the Lord, O my soul, and forget not all His benefits. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 62,
    "title": "Prayer in Sickness 62",
    "content": "<p>Lord, help me! Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 63,
    "title": "Prayer in Sickness 63",
    "content": "<p>Jesus, Redeemer, have mercy upon me! Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 64,
    "title": "Prayer in Sickness 64",
    "content": "<p>Tender Jesus, meek and mild,</p><p>Look on me, a little child;</p><p>Help me, if it is Thy will,</p><p>To recover from all ill. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 65,
    "title": "Prayer in Sickness 65",
    "content": "<p>I am weak, but Thou art mighty.</p><p>Help me, O my God! Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 66,
    "title": "Prayer in Sickness 66",
    "content": "<p>Dear Father, help me believe that all things work together for good to them that love God. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 67,
    "title": "Prayer in Sickness 67",
    "content": "<p>O Thou, from whom all blessings flow,</p><p>I lift my heart to Thee;</p><p>In all my sorrows, conflicts, woes,</p><p>Dear Lord, remember me. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 68,
    "title": "Prayer in Sickness 68",
    "content": "<p>Dear Father, Thy child is sick. Look upon me in tender mercy, and if it be Thy will, raise me up and grant me health and strength. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 69,
    "title": "Prayer in Sickness 69",
    "content": "<p>Heavenly Father, it hath pleased Thee to visit me with sickness, I know that Thou art too kind and good to send me anything but for my blessing. Help me to bear my illness and grant that I may soon recover, through Jesus Christ, my Lord and Savior. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 70,
    "title": "Prayer in Sickness 70",
    "content": "<p>Other refuge have I none;</p><p>Hangs my helpless soul on Thee:</p><p>Leave, ah! leave me not alone,</p><p>Still support and comfort me.</p><p>All my trust on Thee is stayed,</p><p>All my help from Thee I bring;</p><p>Cover my defenseless head</p><p>With the shadow of Thy wing! Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 71,
    "title": "Prayer in Sickness 71",
    "content": "<p>Lord, gracious God, I cry to Thee,</p><p>Still bless me with Thy favor,</p><p>Forgive my sins, and let me live,</p><p>Thy child remain forever.</p><p>Thou hast redeemed me with Thy blood,</p><p>Thou art my only Trust and God</p><p>In every need, my Savior. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 72,
    "title": "Prayer in Sickness 72",
    "content": "<p>Nearer, my God, to Thee,</p><p>Nearer to Thee!</p><p>E'en though it be a cross</p><p>That raiseth me;</p><p>Still all my song shall be,</p><p>Nearer, my God, to Thee,</p><p>Nearer, my God, to Thee,</p><p>Nearer to Thee. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 73,
    "title": "Prayer in Sickness 73",
    "content": "<p>Lord Jesus Christ, my best Physician, I come to Thee in this my sickness. I pray Thee to look upon me in tender mercy. Send Thy guardian angel to watch over me and soon make me well. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 74,
    "title": "Prayer in Sickness 74",
    "content": "<p>Lord Jesus, look down from heaven upon my mama (papa, brother, sister) and soon make her (him) well again. Thou canst do all things; hear my prayer! Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 75,
    "title": "Prayer for a Birthday 75",
    "content": "<p>Holy Jesus, every day</p><p>Keep us in the narrow way,</p><p>And when earthly things are past,</p><p>Bring our ransomed souls at last</p><p>Where they need no star to guide.</p><p>Where no clouds Thy glory hide. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 76,
    "title": "Prayer for a Birthday 76",
    "content": "<p>As a little child relies</p><p>On a care beyond his own;</p><p>Knows he's neither strong nor wise,</p><p>Fears to stir a step alone,--</p><p>Let me thus with Thee abide</p><p>As my Father, Guard, and Guide!</p><p>Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 77,
    "title": "Prayer for a Birthday 77",
    "content": "<p>Faithful Shepherd, feed me</p><p>In the pastures green;</p><p>Faithful Shepherd, lead me</p><p>Where Thy steps are seen.</p><p>Hold me fast and guide me</p><p>In the narrow way;</p><p>So, with Thee beside me,</p><p>I shall never stray.</p><p>Daily bring me nearer</p><p>To the heavenly shore;</p><p>May my faith grow clearer.</p><p>May I love Thee more!</p><p>Hallow every pleasure,</p><p>Every gift and pain;</p><p>Be Thyself my Treasure.</p><p>Though none else I gain. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 78,
    "title": "Prayer for a Birthday 78",
    "content": "<p>We thank Thee, heav'nly Father,</p><p>For ev'ry earthly good,</p><p>For life, and health, and clothing,</p><p>And for our daily food.</p><p>O give us hearts to thank Thee,</p><p>For ev'ry blessing sent,</p><p>And whatsoe'er Thou sendest</p><p>Make us therewith content. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 79,
    "title": "Prayer for a Birthday 79",
    "content": "<p>Holy Jesus, be my Light,</p><p>Shine upon my way;</p><p>Through this tempting, changing life</p><p>Lead me day by day. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 80,
    "title": "Prayer for a Birthday 80",
    "content": "<p>Lord, be Thou my constant Guide,</p><p>Lead me all the way,</p><p>Till I reach Thy home at last,</p><p>Nevermore to stray. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 81,
    "title": "Prayer for a Birthday 81",
    "content": "<p>O God, Thou faithful God,</p><p>Thou Fount that ever flowest,</p><p>Without whom nothing is,</p><p>Who all good gifts bestowest:</p><p>A pure and healthy frame</p><p>O give me and within</p><p>A conscience free from blame,</p><p>A soul unhurt by sin. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 82,
    "title": "Prayer for School and Church 82",
    "content": "<p>Lord Jesus Christ, to us attend.</p><p>Thy Holy Spirit to us send. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 83,
    "title": "Prayer for School and Church 83",
    "content": "<p>Lord, teach us how to keep Thy day</p><p>And lead and bless us all the way. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 84,
    "title": "Prayer for School and Church 84",
    "content": "<p>Lord, open Thou my heart to hear</p><p>And by Thy Word to me draw near;</p><p>Let me Thy Word still pure retain,</p><p>Let me Thy child and heir remain. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 85,
    "title": "Prayer for School and Church 85",
    "content": "<p>Direct me now, O gracious Lord,</p><p>To hear aright Thy holy Word;</p><p>Assist Thy minister to preach,</p><p>And let Thy Holy Spirit teach,</p><p>And let eternal life be found</p><p>By all who hear the joyful sound. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 86,
    "title": "Prayer for School and Church 86",
    "content": "<p>On what has now been sown</p><p>Thy blessing, Lord, bestow;</p><p>The power is Thine alone</p><p>To make it spring and grow. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 87,
    "title": "Prayer for School and Church 87",
    "content": "<p>Blessed Lord, let Thy blessing go with me to-day and grant that I may be obedient to my teachers and may learn with pleasure whatever I am taught, to Thy great honor and glory. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 88,
    "title": "Prayer for School and Church 88",
    "content": "<p>O most gracious God, let me never forget the many good things that I have heard this day; but let them abide in my heart, so that I may amend my life, that I may be able to give a good account of them to Jesus Christ, our Lord and Savior, when He comes to judge the world at the Last Day, for whose sake I ask all blessings, and to whom be glory forever and ever! Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 89,
    "title": "Prayer for School and Church 89",
    "content": "<p>Almighty God, Thy Word is cast</p><p>Like seed into the ground;</p><p>Now let the dew of heaven descend</p><p>And righteous fruits abound. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 90,
    "title": "Prayer for School and Church 90",
    "content": "<p>May the grace of Christ, our Savior,</p><p>And the Father's boundless love,</p><p>With the Holy Spirit's favor,</p><p>Rest upon us from above.</p><p>Thus may we abide in union</p><p>With each other and the Lord</p><p>And possess, in sweet communion,</p><p>Joys which earth cannot afford. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 91,
    "title": "Prayer for School and Church 91",
    "content": "<p>O give me Samuel's ear,</p><p>The open ear, O Lord,</p><p>Alive and quick to hear</p><p>Each whisper of Thy Word,</p><p>Like him to answer at Thy call,</p><p>And to obey Thee first of all. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 92,
    "title": "Prayer for School and Church 92",
    "content": "<p>Abide, O dear Redeemer,</p><p>Among us with Thy Word</p><p>And thus now and hereafter</p><p>True peace and joy afford. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 93,
    "title": "Prayer for School and Church 93",
    "content": "<p>Now our worship sweet is o'er--</p><p>Singing, praying, teaching, hearing:</p><p>Let us gladly God adore</p><p>For His gracious strength and cheering.</p><p>Blest His name, who fain would save us,</p><p>For the rich repast He gave us.</p><p>Let our going out be blest,</p><p>Bless our entrance in like measure;</p><p>Bless, O Lord, our toil and rest,</p><p>Bless our bread, our grief and pleasure;</p><p>Be in death Thy blessing given,</p><p>And make us blest heirs of heaven.</p><p>Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 94,
    "title": "Prayer for School and Church 94",
    "content": "<p>My God, accept my heart this day</p><p>And make it always Thine,</p><p>That I from Thee no more may stray,</p><p>No more from Thee decline.</p><p>Anoint me with Thy heavenly grace,</p><p>Adopt me for Thine own,</p><p>That I may see Thy glorious face</p><p>And worship at Thy throne.</p><p>Let every thought and work and word</p><p>To Thee be ever given;</p><p>Then life shall be Thy service, Lord,</p><p>And death the gate of heaven. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 95,
    "title": "Prayer for School and Church 95",
    "content": "<p>Dismiss us with Thy blessing, Lord;</p><p>Help us to feed upon Thy Word;</p><p>All that has been amiss forgive</p><p>And let Thy truth within us live. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 96,
    "title": "Christmas Prayer 96",
    "content": "<p>Let us all with gladsome voice</p><p>Praise the God of heaven,</p><p>Who, to bid our hearts rejoice,</p><p>His own Son hath given. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 97,
    "title": "Christmas Prayer 97",
    "content": "<p>O Lord Christ, our Savior dear,</p><p>Be Thou ever near us;</p><p>Grant us now a glad New Year.</p><p>Amen, Jesus, hear us! Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 98,
    "title": "Christmas Prayer 98",
    "content": "<p>O holy Child of Bethlehem,</p><p>Descend to us, we pray;</p><p>Cast out our sin and enter in.</p><p>Be born in us to-day. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 99,
    "title": "Christmas Prayer 99",
    "content": "<p>O welcome, little Christmas Guest,</p><p>Dear Jesus, from above;</p><p>Upon Thy face, so pure and mild,</p><p>We see God's smile of love. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 100,
    "title": "Christmas Prayer 100",
    "content": "<p>Precious Babe of Bethlehem,</p><p>Gift of love to sinful men,</p><p>Thou, our Savior, Lord, and King--</p><p>May we all Thy praises sing! Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 101,
    "title": "Christmas Prayer 101",
    "content": "<p>Ah! dearest Jesus, holy Child,</p><p>Make Thee a bed, soft, undefiled,</p><p>Within my heart, that it may be</p><p>A quiet chamber kept for Thee. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 102,
    "title": "General Prayer 102",
    "content": "<p>Come, dearest Savior, take my heart</p><p>And let me ne'er from Thee depart. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 103,
    "title": "General Prayer 103",
    "content": "<p>Jesus, tender Savior,</p><p>Thou hast died for me;</p><p>Make me very thankful</p><p>In my heart to Thee.</p><p>When the sad, sad story</p><p>Of Thy grief I read,</p><p>Make me very sorry</p><p>For my sins indeed.</p><p>Now, I know Thou livest,</p><p>And dost plead for me;</p><p>Make me very thankful</p><p>In my prayers to Thee.</p><p>Soon I hope in glory</p><p>At Thy side to stand;</p><p>Make me fit to meet Thee</p><p>In that happy land! Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 104,
    "title": "General Prayer 104",
    "content": "<p>Lamb of God, I look to Thee;</p><p>Thou shalt my example be;</p><p>Thou art gentle, meek, and mild,</p><p>Thou wast once a little child.</p><p>Fain I would be as Thou art:</p><p>Give me Thy obedient heart.</p><p>Thou art pitiful and kind:</p><p>Let me have Thy loving mind.</p><p>Loving Jesus, gentle Lamb,</p><p>In Thy gracious hands I am;</p><p>Make me, Savior, what Thou art,</p><p>Live Thyself within my heart.</p><p>I shall then show forth Thy praise,</p><p>Serve Thee all my happy days;</p><p>Then the world shall always see</p><p>Christ, the holy Child, in me. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 105,
    "title": "General Prayer 105",
    "content": "<p>Jesus, help my eyes to see</p><p>All the good Thou sendest me.</p><p>Jesus, help my ears to hear</p><p>Calls for help from far and near.</p><p>Jesus, help my feet to go</p><p>In the way that Thou wilt show.</p><p>Jesus, help my hands to do</p><p>All things loving, kind, and true.</p><p>Jesus, may I helpful be,</p><p>Growing every day like Thee. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 106,
    "title": "General Prayer 106",
    "content": "<p>Be near me, Lord Jesus!</p><p>I ask Thee to stay</p><p>Close by me forever</p><p>And love me, I pray.</p><p>Bless all the dear children</p><p>In Thy tender care</p><p>And take us to heaven</p><p>To live with Thee there. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 107,
    "title": "General Prayer 107",
    "content": "<p>Holy Spirit, give us</p><p>Each a lowly mind;</p><p>Make us more like Jesus,</p><p>Gentle, pure, and kind.</p><p>Holy Spirit, brighten</p><p>Little deeds of toil,</p><p>And our playful pastimes</p><p>Let no folly spoil.</p><p>Holy Spirit, help us</p><p>Daily by Thy might</p><p>What is wrong to conquer</p><p>And to choose the right. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 108,
    "title": "General Prayer 108",
    "content": "<p>Jesus, from Thy throne on high,</p><p>Far above the bright blue sky,</p><p>Look on us with loving eye;</p><p>Hear us, holy Jesus!</p><p>Be Thou with us every day,</p><p>In our work and in our play,</p><p>When we learn and when we pray;</p><p>Hear us, holy Jesus!</p><p>May we grow from day to day,</p><p>Glad to learn each holy way,</p><p>Ever ready to obey;</p><p>Hear us, holy Jesus!</p><p>May we ever try to be</p><p>From our sinful tempers free,</p><p>Pure and gentle, Lord, like Thee;</p><p>Hear us, holy Jesus!</p><p>Jesus, Son of God most high,</p><p>Who didst in the manger lie,</p><p>Who upon the cross didst die--</p><p>Hear us, holy Jesus! Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 109,
    "title": "Prayer for Parents 109",
    "content": "<p>Almighty and most merciful God, who in Thy infinite goodness hast committed us unto the charge of loving parents, who are to watch over us and provide for all our wants of body and soul, we pray Thee, protect and prolong their life, that we may continue to enjoy their loving care, and strengthen us that as obedient children we may be subject to their will and hold them in love and esteem; through Jesus Christ, our Lord Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 110,
    "title": "Prayer for a Teacher 110",
    "content": "<p>Dear Father in heaven, who in Thy goodness hast given us teachers that they may instruct and train us in all useful knowledge, we pray Thee, bless them with strength and patience so to guide our feeble footsteps that, being warned, nurtured, comforted, and strengthened, we may do all things well-pleasing to Thee and profitable to us; through Jesus Christ, our Lord. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 111,
    "title": "Prayer for a Pastor 111",
    "content": "<p>O almighty God, who by Thy Son Jesus Christ didst give to Thy holy apostles many excellent gifts and commandedst them faithfully to feed Thy flock, bless, we beseech Thee, our pastor that he may diligently preach Thy holy Word, and grant us grace to believe Thy saving Gospel and obediently to follow the teachings of Thy Word, that we may receive the crown of everlasting glory; through Jesus Christ, our Lord. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 112,
    "title": "Prayer for a Blessed End 112",
    "content": "<p>While life's paths we still are pressing,</p><p>Grant us, Father, steadfast faith</p><p>And for Christ's sake grant the blessing</p><p>Of a peaceful, Christian death. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 113,
    "title": "The Lord's Prayer",
    "content": "<p>Our Father who art in heaven; Hallowed be Thy Name; Thy kingdom come; Thy will be done on earth as it is in heaven; Give us this day our daily bread; And forgive us our trespasses as we forgive those who trespass against us; And lead us not into temptation; But deliver us from evil; For Thine is the kingdom, and the power, and the glory, forever and ever. Amen.</p>",
    "references": []
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 114,
    "title": "Psalm 23",
    "content": "<p>1. The Lord is my Shepherd; I shall not want.</p><p>2. He maketh me to lie down in green pastures; He leadeth me beside the still waters.</p><p>3. He restoreth my soul; He leadeth me in the paths of righteousness for His name's sake.</p><p>4. Yea, though I walk through the valley of the shadow of death, I will fear no evil; for Thou art with me; Thy rod and Thy staff, they comfort me.</p><p>5. Thou preparest a table before me in the presence of mine enemies; Thou anointest my head with oil; my cup runneth over.</p><p>6. Surely goodness and mercy shall follow me all the days of my life, and I will dwell in the house of the Lord forever.</p>",
    "references": [
      "Psalms 23:1-6"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000310",
    "day_number": 115,
    "title": "The Common Doxology",
    "content": "<p>Praise God, from whom all blessings flow;</p><p>Praise Him, all creatures here below;</p><p>Praise Him above, ye heavenly host:</p><p>Praise Father, Son, and Holy Ghost. Amen.</p>",
    "references": []
  }
]
$adapt_new_days$::jsonb) loop
    insert into public.devotional_days (plan_id, day_number, title, content, created_at, updated_at)
    values ((item ->> 'id')::uuid, (item ->> 'day_number')::integer,
            item ->> 'title', item ->> 'content', timestamptz '2026-10-22 14:00:00+00', timestamptz '2026-10-22 14:00:00+00')
    on conflict (plan_id, day_number) do update
      set title = excluded.title, content = excluded.content, updated_at = excluded.updated_at
    returning id into target_day_id;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-22 14:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-22 14:00:00+00', timestamptz '2026-10-22 14:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish two source-checked devotional adaptations.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-22 14:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000327'::uuid,
  '90000000-0000-0000-0000-000000000369'::uuid
);
