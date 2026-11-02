-- Consolidated devotional repair migration.
-- Original SQL is preserved byte-for-byte between the source markers below.
-- This consolidation is intended for a database where the replaced source migrations have not been applied.

-- BEGIN CONSOLIDATED SOURCE: 20261022120000_adapt_public_domain_devotional_plans.sql sha256=d046dccb1bb7985fc637f702aa7ea0675c7c1b1461d79b24d7214681695d0066
-- Reviewed repairs to plans flagged for adaptation before daily release.
-- Existing day numbers and UUIDs are preserved. The Words of Jesus gains day 31.
-- Plans needing source-checked curation remain drafts.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-22 12:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "The Little Pavior and Three Other Tales"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-22 12:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000230",
    "value": "A 32-day adaptation of John Macduff's public-domain reflections on God's promises. The opening devotion draws on the source preface's invitation to bring a specific promise into prayer; days 2–32 follow its 31-day sequence."
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Daily quiet-hour selections from a public-domain collection. Day 1 is a new editorial reflection on setting aside time with God; later days retain the adapted historical selections."
  },
  {
    "id": "90000000-0000-0000-0000-000000000279",
    "value": "A 31-day adaptation of John R. Macduff's public-domain reflections on Jesus' words. The source's 30th and 31st readings are presented as separate days."
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Four public-domain Christian tales by Selina Bunbury, selected from Fanny, the Flower-Girl; or, Honesty Rewarded: The Little Pavior, The Silver Knife, The Modern Dorcas, and The Tract Found by the Way-Side."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-22 12:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000230",
    "value": "Begin with God's Promises",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Make Space for the Quiet Hour",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000259",
    "value": "Introduction to Numbers 6–7",
    "day_number": 1
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-22 12:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "value": "<p>Nothing can be of more moment to you, than living virtuously on earth, as the salvation of your souls in future is one of the objects nearest my heart.</p><p>May you practise this friendly admonition contained in this, being assured I wish no harm or evil to any part of the human race, but for the love of my Redeemer, and the certain hopes of mankind zealous in faith and good works being rewarded with perpetual bliss, which the wicked and the negligent in pure religion will not inherit, unless they be reclaimed, and walk in newness of life, like the good and faithful which will produce repentance, and forgiveness from past sins, is the only object of my addressing this small tract of religion for your future private and public conduct.</p><p>It is almost ten years since my late most invaluable friend, John Randolph, late bishop of London, Bangor, and Oxford, in the year 1804, conferred on me an everlasting monument of friendship (which had existed unshaken more than thirty years), in presenting me to the living of Orton on the Hill; and with tributes of gratitude I daily looked upon it my bounden duty to have prayed for him during his life, and for the benefit of his surviving widow and family, for their present and future happiness; knowing you cannot be displeased at my imitating such a great example of Christianity, to invite you to pursue the blessed steps of a merciful Redeemer, who came into the world to save miserable lost sinners.</p><p>It was my first inquiry to know your characters and circumstances individually, and having minutely watched and observed your actions, though not extreme to mark what has been done amiss, I will allow there has been great improvement in general in religious exercises since my first appearance among you. Some exceptions there are, and I am fearful ever will be; there being scarce any flock without some wandering sheep; yet happy should I be, if both my parishes were more exemplary in temperance, integrity, religion, and chastity, than any others in the diocese of Lincoln; but remember, those who have been exceptions, I have gently warned them of their errors and manner of life, privately at home, as well as in the church, to turn from their evil ways, and live; for why should the obstinate sinner practise bad habits, which will ruin both body and soul, instead of being forgiven by a merciful God, on hearty sorrow and repentance?</p><p>In the first place, I shall recommend private prayers, morning and evening, to you in your respective dwellings, that God may bless your industrious, honest endeavours, in this life with prosperity, and patiently to bear adversity.</p><p>In the morning, the first thing you think on, think on your God that made you, and his Son Jesus Christ, who redeemed the whole world from sin, and upon your bended knees offer up these two following prayers, and when finished, rise up and say your belief; and you who are parents, teach them your children before you go to your daily labour.</p><p>Let ( me or us ) pray.</p><p>Our Father in heaven, hallowed be your name: Your kingdom come: Your will be done in earth, as it is in heaven: Give us this day our daily bread, and forgive us our trespasses, as we forgive them that trespass against us; and lead us not into temptation, but deliver us from evil; for yours is the kingdom, the power, and the glory, forever and ever. Amen.</p><p>O Lord, our heavenly Father, almighty and everlasting God, who has safely brought ( us or me ) to the beginning of this day; defend ( us or me ) in the same with your mighty power; and grant that this day ( I or we ) fall into no sin; neither run into any kind of danger; but that all ( my or our ) doings may be ordered by your governance, to do always that is righteous in your sight, through Jesus Christ our Lord. Amen.</p><p>Stand up to repeat your Belief.</p><p>I believe in God the Father almighty, maker of heaven and earth; and in Jesus Christ his only Son our Lord, who was conceived by the Holy Spirit, born of the Virgin Mary, suffered under Pontius Pilate, was crucified, dead, and buried; he descended into hell; the third day he rose again from the dead, he ascended into heaven, and sits on the right hand of God the Father almighty: from thence he shall come to judge the living and the dead.</p><p>I believe in the Holy Spirit; the holy Catholic church; the communion of saints; the forgiveness of sins; the resurrection of the body, and the life everlasting. Amen.</p><p>Evening Prayers before going to bed.</p><p>Our Father in heaven, hallowed be your name: Your kingdom come: Your will be done in earth, as it is in heaven: Give us this day our daily bread, and forgive us our trespasses, as we forgive them that trespass against us: and lead us not into temptation; but deliver us from evil; for yours is the kingdom, the power, and the glory, forever and ever. Amen.</p><p>Almighty God, to whom all hearts be open, all desires known, and from whom no secrets are hid; cleanse the thoughts of our hearts by the inspiration of your Holy Spirit, that we may perfectly love you, and worthily magnify your holy name, through Christ our Lord. Amen.</p><p>Lighten our darkness, we urge you, O Lord; and by your great mercy defend us from all perils and dangers of this night, for the love of your only Son, our Saviour, Jesus Christ. Amen.</p><p>After this private domestic duty to Almighty God, morning and evening, I should hope with such preparations, no one will be deficient in public duty every revolving Sabbath in God's holy church, to enable him to become as perfect a Christian as possible on earth; for private prayer is only one part of a Christian's duty; to which must be added, public devotion, praise, gratitude, and thanksgiving, for daily benefits received from Almighty God, on the sacred Sabbath. Private prayer without public devotion is imperfect, like faith without works of charity, benevolence, and Christian love will not complete the true disciple of our Lord, like to St. John; but an union of faith and good works daily practised will plead for mercy, and a resurrection from the dead to endless happiness.</p><p>Our excellent church requires three necessary offices to be observed, besides public worship, as preparatory to our Saviour's interference for miserable sinners:—Baptism, Confirmation, receiving the holy Sacrament frequently, particularly on the sacred days which have a preface appointed to be read in the communion service, which are on the nativity of Christ, or Christmas-day, Easter-day, Whit-Sunday, Ascension-day, Trinity-Sunday.</p><p>Our blessed Saviour was born in a manger, on Christmas-day, to teach mankind humility; suffered death on the cross, on Good Friday, to teach patience and resignation in affliction, troubles, and death; rose again the third day from the dead on Easter Sunday, convincing all the world he had conquered sin and wickedness.</p><p>On Ascension-day, after his most glorious resurrection from the dead, he manifestly appeared to his Apostles; and in their sight, he ascended up into Heaven to prepare a place for faithful Christians.</p><p>At Pentecost, the risen Christ sent the Holy Spirit upon the apostles, appearing as tongues of fire and empowering them to bear witness to the gospel (Acts 2:1–4, 33).</p><p>On Trinity Sunday, Christians confess one God—Father, Son, and Holy Spirit.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "value": "<p>I hope that every household in these parishes will have a Bible and sound Christian reading for prayer and reflection. Those with the means to share such books can help neighbors who cannot easily obtain them.</p><p>Our blessed Redeemer was no respecter of persons; he came to save the poor as well as the rich, both to be inheritors of the kingdom of heaven; and it is becoming the poor should practise religion, and join in the service on the sacred Sabbath; for which reason, it was my wish a Sunday School might be established in both parishes, which has been done, one of some years, from which great benefit has ensued; the other is in its infancy, but I hope it will flourish, and be as effectual to stop vice as the other; for the beginning of all evil in general proceeds from neglect of early duty on the sacred Sabbath; but the future advantages of this institution must be considered, as well as the present; for after the children have learnt to read, and having no books, their parents being unable to purchase any, what will be the consequence? An oblivion of all their once acquired Christian duty? If some remedy is not prescribed, which I humbly recommend to all my wealthy parishioners to enter into, that the word of God may never be forgotten from infancy to old age, but cherished and nourished till the hour of death, as the most inestimable treasure, meriting the greatest future reward, and will never be forgotten by the almighty Disposer of all human events, when the humane and charitable will appear before him.</p><p>I recommend a Bible in every poor man's house, but this may be too expensive; but the one I shall offer will not; as I am a Member of the Society in London for propagating Christian Knowledge, I shall have an opportunity of purchasing the books at a reasonable rate; so as every poor man's house may have a Testament, Common Prayer, as I have the great satisfaction to assure my parishioners (of Orton), if the parents cannot read, the children can; by which means, whoever comes to church, may bring a prayer book, and join in the service, and the testament read at home.</p><p>I urge you to listen to my entreaties for a subscription for the benefit of religion, and show your permanent gratitude to the Almighty for his bountiful harvest; and likewise for the many great victories gained by our armies and our allies, in foreign countries, compelling the insulting tyrant disgracefully to retreat with irreparable loss to his own country. But think, my parishioners, how this our native country, and united dominions, should excel all others in Europe in religion and gratitude, and give every token of present and future praise to the God of all mercies, who has so favourably defended us with his shield and buckler, never to have permitted the enemy's sword to be drawn in our land during the contest of 20 years.</p><p>Think on the thousands and thousands of innocent men, women, and children, who have fallen sacrifices, and our country has enjoyed inward tranquillity, peace, domestic and public.</p><p>There are thirty poor houses, for which I solicit from the farmers, as a token of gratitude, subscriptions which will enable me to fulfil my most eager desire for every family in the parish among the poor, to have a Testament and Common Prayer, by which means they will learn their duty to God and their neighbour.</p><p>The day is hastening (O my parishioners) when I shall meet you face to face, and our mutual examination will pass before a merciful and impartial Saviour and judge, to give an account of all our actions; when hypocrisy, intemperance, breaking the Sabbath and God's holy commandments, will receive their punishment, and virtue, religion, and charity, their rewards; for I have done my duty as a faithful shepherd, as far as my frail abilities have enabled me, to reclaim the wicked, and exhort the good, having clothed the naked, fed the hungry, visited the sick, and preached the blessed gospel of salvation to every one of you who have observed the sacred sabbath. When you have shut your pew doors, recollect, as many as possible, these verses of the Psalm 19. v. 14, 15. \"Let the words of my mouth, and the meditation of my heart, be always acceptable in your sight, O Lord, my strength and my Redeemer.\"</p><p>When the sermon is finished, before you go out of church, Psalm 139. v. 23, 24. \"Try me, O God, and search the ground of my heart, prove me, and examine my thoughts. Look well if there be any wickedness in me, and lead me in the way everlasting.\"</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000230",
    "value": "<p><strong>Read: 2 Peter 1:4.</strong> God's promises are an invitation to trust the One who speaks them. Rather than trying to carry every worry at once, bring one need to God today. Find a promise in Scripture that speaks to it, read the surrounding passage, and let that word give shape to your prayer.</p><p><strong>Reflect:</strong> Which promise of God do you need to remember today? How might trusting it change your next step?</p><p><strong>Prayer:</strong> Faithful God, teach me to listen to your word and bring my needs to you. Help me trust your goodness through Jesus Christ. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "<p><strong>Read: Exodus 34:2.</strong> Moses was called to meet God in the morning. A quiet hour begins with a deliberate turning of attention: step away from the noise, listen to Scripture, and speak honestly with God. The length of the time matters less than the willingness to return to him day by day.</p><p><strong>Reflect:</strong> When and where can you make room today for prayer and Scripture? What distraction can you set aside for that time?</p><p><strong>Prayer:</strong> Lord, make me attentive to your word and faithful in prayer. Let this time with you shape the way I live today. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000259",
    "value": "<p>For many years these chapters had no special interest to me; but I have never ceased to be thankful that I was early led to read the Word of God in regular course: it was through this habit that these chapters first became specially precious to me. I was travelling on a missionary tour in the province of Cheh-kiang , and had to pass the night in a very wicked town. All the inns were dreadful places; and the people seemed to have their consciences seared, and their hearts sealed against the Truth. My own heart was oppressed, and could find no relief; and I awoke the next morning much cast down, and feeling spiritually hungry and thirsty indeed.</p><p>On opening my Bible at the seventh chapter of Numbers, I felt as though I could not then read that long chapter of repetitions; that I must turn to some chapter that would feed my soul. And yet I was not happy in leaving my regular portion; so after a little conflict I resolved to read it, praying to God to bless me, even through Numb. 7. I fear there was not much faith in the prayer; but oh! how abundantly it was answered, and what a feast God gave me! He revealed to me His own great heart of love, and gave me the key to understand this and the previous chapter as never before. May God make our meditations upon them as helpful to others as they were then and have ever since continued to be to myself. </p><p>Much is revealed in these chapters in germ which is more fully brought out in the New Testament. Under the Old Covenant many blessings were enjoyed in measure and for a season, which in this dispensation are ours in their fulness and permanence. For instance, the atoning sacrifices of the seventh month had to be repeated every year; but Christ , in offering Himself once for all, perfected forever them that are sanctified. The Psalmist needed to pray, \"Take not Your Holy Spirit from me;\" but Christ has given us the Comforter to abide with us forever. In like manner the Israelite might vow the vow of a Nazarite and separate himself to God for a season; but it is the privilege of the Christian believer to know himself as always separated to God . Many other lessons, which are hidden from careless and superficial readers, are suggested by these chapters, which the Holy Spirit will reveal to prayerful students of His most precious and most perfect Book.</p><p>The portions we have selected consist of first a short chapter, and then a very long one, which at first sight appears to have no special connection with it. But on more careful reflection we shall see that the order of the subjects referred to shows that there is really a natural and close connection between them. We shall find that Separation to God is followed by Blessing from God ; and that those who receive large blessing from Him, in turn render to Him acceptable Service: service in which God takes delight, and which He places in everlasting remembrance.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000279",
    "value": "<p>30th Day.</p><p>“I will come again, and receive you to myself; that where I am, there you may be also.”—John 14. 3.</p><p>Another “word of promise” concerning the Church’s “blessed hope.” Orphaned pilgrims, dry your tears! Soon the Morning Hour will strike, and the sighs of a groaning and burdened creation be heard no more. Earth’s six thousand years of toil and sorrow are waning; the Millennial Sabbath is at hand. Jesus will soon be heard to repeat concerning all his sleeping saints, what He said of old regarding one of them: “I go to awake them out of sleep!” Your beloved Lord’s first coming was in humiliation and woe; His name was—the “Man of Sorrows;” He had to travel on, amid darkness and desertion, His blood-stained path; a chaplet of thorns was the only crown He bore. But soon He will come “the second time without a sin-offering to salvation,” never again to leave His Church, but to receive those who followed Him in His cross, to be everlasting partakers with Him in His crown. He may seem to wait. External nature, in her unvarying and undeviating sequences, gives no indication of His approach. Centuries have elapsed since He uttered the promise, and still He lingers; the everlasting hills wear no streak of approaching dawn; we seem to listen in vain for the noise of His chariot wheels. “But the Lord is not slack concerning His promise;” He gives you “this word” in addition to many others as a keepsake —a pledge and guarantee for the certainty of His return,—“ I will come again. ”</p><p>Who can conceive all the surpassing blessedness connected with that advent? The Elder Brother arrived to fetch the younger brethren home!—the true Joseph revealing Himself in unutterable tenderness to the brethren who were once estranged from Him—“receiving them to himself”—not satisfied with apportioning a kingdom for them, but, as if all His own joy and bliss were intermingled with theirs, “Where I am ,” says He, “there you must be also.” “Him that overcomes,” says He again, “will I grant to sit with Me on My Throne.”</p><p>Believer, can you now say with some of the holy transport of the apostle, “Whom having not seen, we love?” What must it be when you come to see Him “face to face,” and that forever and ever! If you can tell of precious hours of communion in a sin-stricken, woe-worn world, with a treacherous heart, and an imperfect or divided love, what must it be when you come, in a sinless, sorrowless state, with purified and renewed affections, to see the King in His beauty! The letter of an absent brother, cheering and consolatory as it is, is a poor compensation for the joys of personal and visible communion. The absent Elder Brother on the Throne speaks to you now only by His Word and Spirit,—soon you shall be admitted to His immediate fellowship, seeing him “as He is”—He Himself unfolding the wondrous chart of His providence and grace—leading you about from fountain to fountain among the living waters, and with his own gentle hand wiping the last lingering tear-drop from your eye. Heaven an everlasting home with Jesus! “Where I am, there you may be also.”—He has appended a cheering postscript to this word, on which He has “caused us to hope:”—</p><p>“HE WHICH TESTIFIES THESE THINGS SAYS, SURELY I COME QUICKLY.”</p>",
    "day_number": 30
  },
  {
    "id": "90000000-0000-0000-0000-000000000350",
    "value": "<p>The great and blessed God that made heaven and earth, the seas and the great fountains of the deep, and rivers of water, the Almighty J ehovah , who is from everlasting to everlasting. He also made man and woman; and his design was to make them eternally happy and blessed. And therefore he made man in his own image; \"in the image of God created he him, male and female created he them:\" He made them after his own likeness holy, wise, merciful, just, patient, and humble, endued them with knowledge, righteousness, and true holiness. But man and woman through their transgressions lost this image of God, and with it lost their happiness and true blessedness, that God made them in a capacity to enjoy.</p><p>Now in this state of misery into which we are fallen, we are come short of the glory of God; and it is out of this wretched woful state we must be brought, else we shall never see the face of God with comfort. This is an eternal truth of God, and recorded in the Holy Scriptures. John 3. 16. That \"God so loved the world, that he gave his only begotten Son, that whoever believes in him, should not perish, but have everlasting life.\" God so loved the world, he gave his Son to be a light to the world, that all might see their way back to God again: For sin has darkened the understanding, and clouded the mind of man and woman, and alienated them from the life of God, and their hearts are hardened through the deceitfulness of sin. But now is the acceptable time, now is the day of salvation, the day of God's grace and favourable visitation, in which he visits men and women, illuminates their minds and spirits with a light from heaven, that they might see the deplorable state and condition in which they are, and what they are doing: It is in this light, that they have a day of grace vouchsafed to them, that it may be well with them, both here and forever. They that receive this light, and come out of that which they are called from, which is sin, they may come to enjoy peace with God. It was sin that first separated between God and man; and it is sin now that hinders man from acquaintance with the Lord, who brings peace to him: It is by this light, that we are to acquaint ourselves with God, that we may be at peace. Thus says the Lord by the prophet, \"It is sin has separated between me and you:\" Sin has made a partition wall between God and us, and God has sent his Son into the world to break down this partition wall that sin has made; that so fallen man might return to God, and come into Paradise again, out of which sin has cast him.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000381",
    "value": "<p>“I am not come to destroy” (the law and the prophets) “but to fulfil. Till heaven and earth pass, one jot or one tittle shall in no wise pass from the law till all be fulfilled” (Matt. 5. 17, 18).</p><p>The above solemn words of our Lord Jesus Christ, being part of His Sermon on the Mount (as related by Matthew), appear to open an interesting field of inquiry into an important portion of Divine Truth as set forth in Holy Scripture.</p><p>In what manner did our Lord so fulfil the law given by Moses that one jot or one tittle should in no wise pass unfulfilled? Was it when He went to the Baptist, and received baptism , because it became Him to fulfil all righteousness? (Matt. 3. 15). Was it when He sent the ten lepers whom He would heal to show themselves to the priests (agreeably to Lev. 14. 2; Luke 17. 14); or in another similar case, when He said, “Go, show yourself to the priest, and offer those things which Moses commanded for a testimony to them”? (Mark 1. 44; Luke 5. 14).</p><p>Was it by attending the appointed feasts at Jerusalem, and generally in other cases, recorded or not recorded, in which He conformed, and was subject to the ritual which had been before appointed? Or are we not to understand the words in a much deeper sense than His personal submission to the Law?—that of fulfilling, perfecting, and giving a living reality to all its foreshadowing types, in themselves dead and profitless; to seal, assure, and make good all its promises to the obedient subjects of that Law; all its threatenings to the disobedient; to open up to mankind that rich inheritance prepared alike for the men of that day and for us, foreshadowed by the land of promise flowing with milk and honey; to perfect that which was lacking in those offerings of atonement which in themselves could never take away sins (Heb. 10. 4)?</p><p>The ministry of our Lord Jesus Christ is revealed to us under the two characters of an Apostle and High Priest (Heb. 3. 1).</p><p>1st. As an Apostle , to declare and teach the principles of that Divine Truth, which distinguished the New Covenant of life and salvation from the covenant of bondage to ordinances then about to be abolished, which had been designed as introductory to it; and to ordain and qualify His Apostles to declare its principles more fully after His death and resurrection.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000393",
    "value": "<p>‘You shall receive power, after that the Holy Spirit is come upon you; and you shall be witnesses to Me.’— Acts , i. 8.</p><p>It is said of the saints of God in the Old Testament, that ‘out of weakness they were made strong,’ and none of us who are called to God’s ministry can think for one moment of our work and our weakness without the deepest sense of our own need of that same gift. We have a work of infinite importance. We are called to be God’s instruments in making known that which God has wrought at no less a price than the most precious blood of His well-beloved Son. We have to encounter the threefold antagonism of the world, the flesh, and the devil; and we ourselves are poor weak creatures, so weak that we are quite unable to stand alone, and so utterly fallen that we cannot preserve ourselves even for an hour. It follows, therefore, that we all stand in need of power from God. And whatever be our position, whether in the ministry or out of it, whether laymen, deacons, presbyters, or bishops, we all require to be strengthened with might by His Spirit in the inner man. If ever the need of this strength was felt it must be felt now, now that we are passing through the perilous times of the latter days; and if there be any office in the whole world which appears to require it more than another, it is the sacred office to which my dear friend is this day admitted, the holy office of a Bishop in the Church of God.</p>",
    "day_number": 1
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_plans as target
set total_days = edit.value, updated_at = timestamptz '2026-10-22 12:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000279",
    "value": 31
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
    "id": "90000000-0000-0000-0000-000000000279",
    "day_number": 30,
    "references": [
      "John 14:3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 1,
    "references": [
      "Proverbs 20:11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 2,
    "references": [
      "Proverbs 20:11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 3,
    "references": [
      "Proverbs 20:11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 4,
    "references": [
      "Luke 10:37"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 5,
    "references": [
      "Luke 10:37"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 6,
    "references": [
      "John 9:4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 7,
    "references": [
      "John 9:4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 8,
    "references": [
      "John 9:4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 9,
    "references": [
      "John 9:4"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-22 12:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-22 12:00:00+00', timestamptz '2026-10-22 12:00:00+00');
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
    "id": "90000000-0000-0000-0000-000000000279",
    "day_number": 31,
    "title": "31st Day of Month",
    "content": "<p>31st Day .</p><p>“Blessed are those servants whom the Lord when He comes shall find watching.”—Luke 12. 37.</p><p>Child of God! is this your attitude, as the expectant of your Lord’s appearing? Are your loins girded, and your lights burning? If the cry were to break upon your ears this day, “See the Bridegroom comes,” could you joyfully respond—“Look, this is my God, I have waited for him?” When He may come, we cannot tell;—ages may elapse before then . It may be centuries before our graves are gilded with the beams of a Millennial sun; but while He may or may not come soon , He must come at some time—ay, and the day of our death is virtually to all of us the day of His coming.</p><p>Reader! put not off the solemn preparation. Be not deceived or deluded with the mocker’s presumptuous challenge, “Where is the promise of His coming?” See to it that the calls of an engrossing world without, do not foster this procrastinating spirit within. It may be now or never with you. Put not off your sowing time till harvest time. Leave nothing for a dying hour, but to die , and calmly to resign your spirit into the hands of Jesus. Of all times, that is the least suitable to have the vessel plenished—to attend to the great business of life when life is ebbing—to trim the lamp when the oil is done and it is flickering in its socket—to begin to watch, when the summons is heard to leave the watch-tower to meet our God!</p><p>Were you never struck how often, amid the many gentle words of Jesus, the summons “to watch,” is over and over repeated, like a succession of alarum-bells breaking ever and soon, amid chimes of heavenly music, to rouse a sleeping Church and a slumbering world?</p><p>Let this last “word” of your Lord’s send you to your knees with the question,—“Am I indeed a servant of Christ?” Have I fled to Him, and am I reposing in Him, as my only Saviour?—or am I still lingering, like Lot, when I should be escaping—sleeping, when I should be waking—neglecting and trifling, when “a long eternity is lying at my door?” He is my last and only refuge; neglect Him— all is lost !</p><p>Believer! you who are standing on your watch-tower, be more faithful than ever at your post. Remember what is implied in watching. It is no dreamy state of inactive torpor: it is a holy jealousy over the heart—wakeful vigilance regarding sin—every avenue and loophole of the soul carefully guarded. Holy living is the best, the only , preparative for holy dying . “Persuade yourself,” says Rutherford, “the King is coming. Read His letter sent before Him, ‘See I come quickly;’ wait with the wearied night-watch for the breaking of the Eastern sky.”</p><p>Let these “ Words of Jesus ” we have now been meditating upon in this little volume, be as the Golden Bells of old, hung on the vestments of the officiating High Priest, emitting sweet sounds to His spiritual Israel—telling that the true High Priest is still living and pleading in “the Holiest of all;” and that soon He will come forth to pour His blessing on His waiting Church. We have been pleasingly employed in gathering up a few “crumbs” falling from “the Master’s table.” Soon we shall have, not the “ Words ” but the presence of Jesus—not the crumbs falling from His table, but everlasting fellowship with the Master Himself.</p><p>“AMEN, EVEN SO, COME LORD JESUS.”</p><p>Therefore Comfort One Another with THESE WORDS. 1 Thess. 4. 18.</p>",
    "references": [
      "Luke 12:37",
      "1 Thessalonians 4:18"
    ]
  }
]
$adapt_new_days$::jsonb) loop
    insert into public.devotional_days (plan_id, day_number, title, content, created_at, updated_at)
    values ((item ->> 'id')::uuid, (item ->> 'day_number')::integer,
            item ->> 'title', item ->> 'content', timestamptz '2026-10-22 12:00:00+00', timestamptz '2026-10-22 12:00:00+00')
    on conflict (plan_id, day_number) do update
      set title = excluded.title, content = excluded.content, updated_at = excluded.updated_at
    returning id into target_day_id;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-22 12:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-22 12:00:00+00', timestamptz '2026-10-22 12:00:00+00');
    end if;
  end loop;
end
$$;

-- Hold devotional plans awaiting source-checked adaptation.
update public.devotional_plans
set status = 'draft', updated_at = timestamptz '2026-10-22 12:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000102'::uuid,
  '90000000-0000-0000-0000-000000000218'::uuid,
  '90000000-0000-0000-0000-000000000219'::uuid,
  '90000000-0000-0000-0000-000000000242'::uuid,
  '90000000-0000-0000-0000-000000000248'::uuid,
  '90000000-0000-0000-0000-000000000253'::uuid,
  '90000000-0000-0000-0000-000000000264'::uuid,
  '90000000-0000-0000-0000-000000000268'::uuid,
  '90000000-0000-0000-0000-000000000282'::uuid,
  '90000000-0000-0000-0000-000000000283'::uuid,
  '90000000-0000-0000-0000-000000000284'::uuid,
  '90000000-0000-0000-0000-000000000285'::uuid,
  '90000000-0000-0000-0000-000000000298'::uuid,
  '90000000-0000-0000-0000-000000000302'::uuid,
  '90000000-0000-0000-0000-000000000305'::uuid,
  '90000000-0000-0000-0000-000000000309'::uuid,
  '90000000-0000-0000-0000-000000000310'::uuid,
  '90000000-0000-0000-0000-000000000311'::uuid,
  '90000000-0000-0000-0000-000000000317'::uuid,
  '90000000-0000-0000-0000-000000000325'::uuid,
  '90000000-0000-0000-0000-000000000326'::uuid,
  '90000000-0000-0000-0000-000000000327'::uuid,
  '90000000-0000-0000-0000-000000000328'::uuid,
  '90000000-0000-0000-0000-000000000329'::uuid,
  '90000000-0000-0000-0000-000000000331'::uuid,
  '90000000-0000-0000-0000-000000000333'::uuid,
  '90000000-0000-0000-0000-000000000338'::uuid,
  '90000000-0000-0000-0000-000000000342'::uuid,
  '90000000-0000-0000-0000-000000000350'::uuid,
  '90000000-0000-0000-0000-000000000355'::uuid,
  '90000000-0000-0000-0000-000000000357'::uuid,
  '90000000-0000-0000-0000-000000000359'::uuid,
  '90000000-0000-0000-0000-000000000362'::uuid,
  '90000000-0000-0000-0000-000000000366'::uuid,
  '90000000-0000-0000-0000-000000000367'::uuid,
  '90000000-0000-0000-0000-000000000369'::uuid,
  '90000000-0000-0000-0000-000000000371'::uuid,
  '90000000-0000-0000-0000-000000000373'::uuid,
  '90000000-0000-0000-0000-000000000374'::uuid,
  '90000000-0000-0000-0000-000000000375'::uuid,
  '90000000-0000-0000-0000-000000000376'::uuid,
  '90000000-0000-0000-0000-000000000379'::uuid,
  '90000000-0000-0000-0000-000000000381'::uuid,
  '90000000-0000-0000-0000-000000000384'::uuid,
  '90000000-0000-0000-0000-000000000387'::uuid,
  '90000000-0000-0000-0000-000000000388'::uuid,
  '90000000-0000-0000-0000-000000000390'::uuid,
  '90000000-0000-0000-0000-000000000392'::uuid,
  '90000000-0000-0000-0000-000000000393'::uuid,
  '90000000-0000-0000-0000-000000000394'::uuid,
  '90000000-0000-0000-0000-000000000395'::uuid,
  '90000000-0000-0000-0000-000000000397'::uuid
);
-- END CONSOLIDATED SOURCE: 20261022120000_adapt_public_domain_devotional_plans.sql

-- BEGIN CONSOLIDATED SOURCE: 20261022140000_repair_draft_devotional_plans_wave_1.sql sha256=5d2aa6502268a360c070588dba4083999743fc39f40a34252468ce236290ed17
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
-- END CONSOLIDATED SOURCE: 20261022140000_repair_draft_devotional_plans_wave_1.sql

-- BEGIN CONSOLIDATED SOURCE: 20261022150000_repair_draft_devotional_plans_wave_2.sql sha256=09fbfb82c003e992104192486890c95b943daff63ad44512564c523a2f6e3f6e
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
-- END CONSOLIDATED SOURCE: 20261022150000_repair_draft_devotional_plans_wave_2.sql

-- BEGIN CONSOLIDATED SOURCE: 20261023120000_repair_draft_devotional_plans_wave_3.sql sha256=5263253068478de9b2f8041ed844f453bf526e747755f47898414b1ff7d12719
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
-- END CONSOLIDATED SOURCE: 20261023120000_repair_draft_devotional_plans_wave_3.sql

-- BEGIN CONSOLIDATED SOURCE: 20261023130000_repair_draft_devotional_plans_wave_4.sql sha256=ea43535b1c83ae1a9a3826eed2ead4250e6e87b1ea36a42851b2cbe4f61c85fc
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
-- END CONSOLIDATED SOURCE: 20261023130000_repair_draft_devotional_plans_wave_4.sql

-- BEGIN CONSOLIDATED SOURCE: 20261023140000_repair_draft_devotional_plans_wave_5.sql sha256=7a6e956714e6ff27dff97f9ebcfd42717a2bbbdda560e2943df2b5122c489083
-- Two funeral-sermon plans reconstructed as Scripture-led daily devotions.
-- The local memorial settings remain explicit; sectarian polemic and claims about
-- individual final states are omitted or framed as historical testimony.
-- Existing day IDs and day numbers are preserved.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-23 14:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "Faith, Love, and Christian Witness: Eight Readings from the Nonington Sermons"
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "Life, Death, and Resurrection Hope: Seven Readings from a 1697 Funeral Sermon"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-23 14:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "Eight Scripture-led readings adapted from two sermons preached after John Pemberton Plumptre's funeral in 1864. The sequence draws out themes of grace, faith, prayer, humility, active love, redemption, and truthful witness while identifying the local memorial setting and omitting sectarian polemic."
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "Seven Scripture-led readings adapted from William Wigan's 1697 sermon after the death of Lady Elizabeth Cutts. The sequence places its reflections on mortality, faithful living, grief, and bodily resurrection in clear historical context and contemporary language."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-23 14:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "Every Believer Can Strengthen Others",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "Faith Rests on Christ",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "Prayer Nourishes Faith",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "Humility and Love Take Action",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "Let Your Life Bear Good Fruit",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "Follow the Lamb",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "Redeemed by Christ",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "Grace Produces Honest Witness",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "Number Our Days",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "Practice the Life You Desire",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "Hope Has a Name",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "Comfort Rooted in God's Love",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "Raised with Christ",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "Faithfulness Is Not Measured by Age",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "Grieve with Hope",
    "day_number": 7
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-23 14:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "<p><strong>Read:</strong> Hebrews 13:7; 1 Peter 4:10.</p><p><strong>Historical context:</strong> Herbert James preached after the 1864 funeral of John Pemberton Plumptre. He used one local Christian life as an example, while directing praise to God's grace rather than to the deceased.</p><p><strong>Source theme, in contemporary language:</strong> God gives gifts to the church for the good of others. A believer may serve through words, example, hospitality, work, or quiet faithfulness; no act of service is too small to matter.</p><p><strong>Reflect:</strong> Think of one gift, skill, or opportunity God has entrusted to you. Who could be strengthened if you used it with humility today?</p><p><strong>Prayer:</strong> God of grace, help me use what you have given me for the good of others and the honor of Jesus Christ. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "<p><strong>Read:</strong> Ephesians 2:8-9; 1 Corinthians 15:3-4.</p><p><strong>Historical context:</strong> James described Plumptre's confidence at the end of life. The sermon presents that confidence as trust in God's mercy through Christ, not as praise for human achievement.</p><p><strong>Source theme, in contemporary language:</strong> Christian hope rests on Jesus Christ, who died for our sins and was raised. Grace gives no room for boasting, yet it gives a firm foundation for trust.</p><p><strong>Reflect:</strong> When you measure your standing with God, do you lean on your record or on Christ's grace? Name one failure or fear that you need to place in his mercy.</p><p><strong>Prayer:</strong> Lord Jesus, keep my confidence in your death and resurrection. Free me from pride and from despair, and teach me to receive your grace with gratitude. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "<p><strong>Read:</strong> Philippians 4:6-7; Hebrews 11:6.</p><p><strong>Historical context:</strong> The first sermon connects sustained faith with private prayer and regular attention to Scripture. Its local memories support a wider invitation to seek God faithfully.</p><p><strong>Source theme, in contemporary language:</strong> Faith needs nourishment. Scripture directs the mind toward God's promises, and prayer brings duties, disappointments, cares, and fears into God's presence.</p><p><strong>Reflect:</strong> Which concern keeps circling in your thoughts? Turn it into a specific prayer, and choose a short passage of Scripture to revisit during the day.</p><p><strong>Prayer:</strong> Faithful God, meet me in Scripture and prayer. Guard my heart with your peace and strengthen me to trust you in what I cannot control. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "<p><strong>Read:</strong> Philippians 2:3-5; 1 John 3:18.</p><p><strong>Historical context:</strong> James remembered humility and practical love as prominent features of Plumptre's life. The sermon says these qualities came from the grace of Christ rather than personal importance.</p><p><strong>Source theme, in contemporary language:</strong> Humility makes room for Christ to be seen, and love becomes real through action. Christian care attends to both bodily needs and spiritual encouragement.</p><p><strong>Reflect:</strong> Whose needs are easy for you to overlook? Choose one concrete act of care that protects the person's dignity and expects no recognition.</p><p><strong>Prayer:</strong> Jesus, form your humility in me. Let my love move beyond kind intentions into patient and practical service. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "<p><strong>Read:</strong> Matthew 5:16; Philippians 2:15-16.</p><p><strong>Historical context:</strong> At the close of the first sermon, James urged his hearers to live faithfully in the places where God had set them. The appeal is separated here from the details of the funeral.</p><p><strong>Source theme, in contemporary language:</strong> A faithful life can leave neighbors stronger, comforted, and more attentive to Christ. Good works do not earn salvation; they bear witness to the grace already received.</p><p><strong>Reflect:</strong> If someone observed your ordinary week, where might they see the light of Christ? What habit of selfishness, delay, or indifference needs to change?</p><p><strong>Prayer:</strong> Father, make my ordinary work fruitful. Help me hold firmly to your word and serve in a way that directs gratitude to you. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "<p><strong>Read:</strong> Revelation 14:4-5; John 10:27.</p><p><strong>Historical context:</strong> Edward Hoare's second sermon begins with the symbolic vision in Revelation 14. He applies it to faithful discipleship; this reading avoids the sermon's nineteenth-century sectarian controversy.</p><p><strong>Source theme, in contemporary language:</strong> Those who belong to Jesus listen for his voice and follow him. Faithfulness includes truthfulness, wholehearted devotion, and refusal to join what draws the heart away from Christ.</p><p><strong>Reflect:</strong> Where are you tempted to follow approval, habit, or fear instead of Jesus? Identify one step of truthful obedience you can take today.</p><p><strong>Prayer:</strong> Lamb of God, keep me near your voice. Give me an undivided heart and make my words truthful and gracious. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "<p><strong>Read:</strong> 1 Peter 1:18-19; Revelation 5:9.</p><p><strong>Historical context:</strong> Hoare emphasizes redemption through Jesus while interpreting the funeral text. This devotion retains the Christ-centered confession without repeating the sermon's polemical comparisons.</p><p><strong>Source theme, in contemporary language:</strong> Jesus gave himself to redeem people for God. His saving work calls believers away from empty ways of life and into grateful worship, holiness, and love.</p><p><strong>Reflect:</strong> What pattern feels empty but familiar? Bring it honestly to Christ, and ask how gratitude for his saving love could reshape your next choice.</p><p><strong>Prayer:</strong> Lord Jesus, thank you for giving yourself for us. Turn me from empty habits and form in me a life of worship, holiness, and love. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "value": "<p><strong>Read:</strong> Ephesians 2:8-10; Colossians 3:9-10.</p><p><strong>Historical context:</strong> The second sermon closes by joining grace, truthful character, and service. Its claims about the deceased are treated as local testimony rather than a guarantee about any person's final state.</p><p><strong>Source theme, in contemporary language:</strong> Salvation is God's gift, and the new life it creates is marked by truth and good work. Honest Christian witness neither hides sin nor pretends that moral effort replaces grace.</p><p><strong>Reflect:</strong> Is there a place where your words and actions do not agree? Ask God for courage to tell the truth, repair harm, and practice the good work prepared for you.</p><p><strong>Prayer:</strong> God of truth and grace, renew me in Christ. Make my speech honest, my repentance sincere, and my service useful to others. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "<p><strong>Read:</strong> Psalm 90:12; Numbers 23:10.</p><p><strong>Historical context:</strong> William Wigan preached in 1697 after the death of Lady Elizabeth Cutts. His opening uses the funeral occasion to remind the living that youth, status, health, and plans cannot make life secure.</p><p><strong>Source theme, in contemporary language:</strong> Awareness of mortality can teach wisdom. Preparing to die is not gloomy speculation; it means learning to live before God with faith, repentance, love, and readiness.</p><p><strong>Reflect:</strong> If you received today as a limited gift, what would deserve more attention? What resentment, neglected duty, or delayed kindness should you address?</p><p><strong>Prayer:</strong> Eternal God, teach me to number my days. Make me ready to meet you by helping me live faithfully and lovingly today. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "<p><strong>Read:</strong> Micah 6:8; James 1:22.</p><p><strong>Historical context:</strong> Wigan reflects on Balaam's wish to share the end of the righteous while warning that a good wish without a changed path is insufficient.</p><p><strong>Source theme, in contemporary language:</strong> A faithful end cannot be separated from a life that hears and obeys God. Hope should take shape in justice, mercy, humility, and steady practice.</p><p><strong>Reflect:</strong> Which Christian conviction do you admire but rarely practice? Choose one action that makes your desire visible today.</p><p><strong>Prayer:</strong> Lord, keep my faith from remaining only a wish. Teach me to do justice, love mercy, and walk humbly with you. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "<p><strong>Read:</strong> John 11:25-26; 2 Corinthians 5:1.</p><p><strong>Historical context:</strong> The sermon surveys human arguments about death, then turns to the Christian hope announced in Scripture. This adaptation centers that hope directly on Jesus.</p><p><strong>Source theme, in contemporary language:</strong> Christian hope is more than a general belief that the soul continues. Jesus is the resurrection and the life, and believers entrust both life and death to him.</p><p><strong>Reflect:</strong> What fear rises when you think about death or loss? Speak that fear plainly to Christ, and answer it with his promise of resurrection life.</p><p><strong>Prayer:</strong> Jesus Christ, resurrection and life, hold me when I am afraid. Keep my hope in you and comfort all who grieve. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "<p><strong>Read:</strong> Romans 8:38-39; Psalm 23:4.</p><p><strong>Historical context:</strong> Wigan contrasts fragile worldly comforts with the promises of Scripture. His sermon addresses a particular congregation, while its call to seek lasting comfort remains useful.</p><p><strong>Source theme, in contemporary language:</strong> Possessions, reputation, and even beloved companions cannot pass through death with us. God's presence and love in Christ remain trustworthy in the darkest valley.</p><p><strong>Reflect:</strong> Which temporary support are you asking to carry more weight than it can bear? Receive it gratefully, but place your deepest confidence in God's lasting love.</p><p><strong>Prayer:</strong> God of all comfort, walk with me through every dark valley. Root my heart in the love from which nothing can separate us. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "<p><strong>Read:</strong> 1 Corinthians 15:20-23; Philippians 3:20-21.</p><p><strong>Historical context:</strong> The sermon speaks of the body resting in hope and points to Jesus as the firstfruits of the resurrection. Its older language is restated here as a clear Christian confession.</p><p><strong>Source theme, in contemporary language:</strong> Because Jesus truly rose from the dead, Christian hope includes the resurrection of the body. Death is an enemy, but it will not have the final word over those who belong to Christ.</p><p><strong>Reflect:</strong> How does bodily resurrection change the way you regard aging, sickness, burial, or care for another person's body? Let hope lead to tenderness rather than denial.</p><p><strong>Prayer:</strong> Risen Lord Jesus, thank you that death will not have the final word. Sustain the sick, comfort the grieving, and keep us faithful in hope. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "<p><strong>Read:</strong> Ecclesiastes 12:1; 1 Timothy 4:12.</p><p><strong>Historical context:</strong> Lady Cutts died at about eighteen, and Wigan remembered the faith and service shown in her short life. This devotion keeps the lesson while avoiding idealized claims about her rank or gender.</p><p><strong>Source theme, in contemporary language:</strong> A life need not be long to bear faithful fruit. Young believers can serve through speech, conduct, love, faith, and purity, while every generation can learn from their example.</p><p><strong>Reflect:</strong> Do you dismiss your own contribution because of age, inexperience, or limited time? What faithful action is possible with the life and opportunity you have now?</p><p><strong>Prayer:</strong> Creator, receive every season of my life. Help me serve without waiting for a more impressive age, role, or opportunity. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "<p><strong>Read:</strong> 1 Thessalonians 4:13-14; Romans 14:8.</p><p><strong>Historical context:</strong> The sermon closes by addressing Lady Cutts's family and congregation. It honors real sorrow while grounding Christian hope in the death and resurrection of Jesus.</p><p><strong>Source theme, in contemporary language:</strong> Christian grief is still grief, yet it is not without hope. Whether we live or die, we belong to the Lord, and those who die in Christ await the resurrection.</p><p><strong>Reflect:</strong> Make room for grief without forcing quick explanations. What memory, loss, or person do you need to entrust to the Lord with both sorrow and hope?</p><p><strong>Prayer:</strong> Lord of the living and the dead, receive our tears. Keep us in Christ, comfort those who mourn, and strengthen our hope in the resurrection. Amen.</p>",
    "day_number": 7
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
    "id": "90000000-0000-0000-0000-000000000387",
    "day_number": 1,
    "references": [
      "Hebrews 13:7",
      "1 Peter 4:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "day_number": 2,
    "references": [
      "Ephesians 2:8-9",
      "1 Corinthians 15:3-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "day_number": 3,
    "references": [
      "Philippians 4:6-7",
      "Hebrews 11:6"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "day_number": 4,
    "references": [
      "Philippians 2:3-5",
      "1 John 3:18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "day_number": 5,
    "references": [
      "Matthew 5:16",
      "Philippians 2:15-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "day_number": 6,
    "references": [
      "Revelation 14:4-5",
      "John 10:27"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "day_number": 7,
    "references": [
      "1 Peter 1:18-19",
      "Revelation 5:9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000387",
    "day_number": 8,
    "references": [
      "Ephesians 2:8-10",
      "Colossians 3:9-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "day_number": 1,
    "references": [
      "Psalm 90:12",
      "Numbers 23:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "day_number": 2,
    "references": [
      "Micah 6:8",
      "James 1:22"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "day_number": 3,
    "references": [
      "John 11:25-26",
      "2 Corinthians 5:1"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "day_number": 4,
    "references": [
      "Romans 8:38-39",
      "Psalm 23:4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "day_number": 5,
    "references": [
      "1 Corinthians 15:20-23",
      "Philippians 3:20-21"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "day_number": 6,
    "references": [
      "Ecclesiastes 12:1",
      "1 Timothy 4:12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "day_number": 7,
    "references": [
      "1 Thessalonians 4:13-14",
      "Romans 14:8"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-23 14:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-23 14:00:00+00', timestamptz '2026-10-23 14:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish two contextualized funeral-sermon adaptations.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-23 14:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000387'::uuid,
  '90000000-0000-0000-0000-000000000395'::uuid
);
-- END CONSOLIDATED SOURCE: 20261023140000_repair_draft_devotional_plans_wave_5.sql

-- BEGIN CONSOLIDATED SOURCE: 20261023150000_repair_draft_devotional_plans_wave_6.sql sha256=81b29161ff8cc4dc964d7998ea895dba18791aed93135e86bd15780ff0c5ad51
-- One 1839 election sermon reconstructed as nine Scripture-led daily devotions.
-- Its civic setting remains explicit; national, partisan, and coercive-religion claims
-- are omitted while themes of conscience, service, justice, and prayer are retained.
-- Existing day IDs and day numbers are preserved.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-23 15:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "value": "Conscience, Justice, and the Common Good: Nine Readings from an 1839 Election Sermon"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-23 15:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "value": "Nine Scripture-led readings adapted from Mark Hopkins's sermon to Massachusetts officials in 1839. The sequence draws out themes of conscience, moral responsibility, neighbor love, courageous witness, servant leadership, justice, and prayer while identifying the civic setting and setting aside national and partisan claims."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-23 15:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "value": "A Higher Allegiance",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "value": "God Sees the Inner Life",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "value": "Freedom for Faithful Living",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "value": "Neighbor Love Builds Common Life",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "value": "Renewal Reaches the Heart",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "value": "Courage Without Contempt",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "value": "Leadership That Resists Flattery",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "value": "Justice Beyond Expediency",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "value": "Pray and Work for the Common Good",
    "day_number": 9
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-23 15:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "value": "<p><strong>Read:</strong> Acts 5:29; Romans 13:1-4.</p><p><strong>Historical context:</strong> Mark Hopkins preached this sermon before Massachusetts officials in January 1839. He began with the apostles' refusal to stop bearing witness to Jesus and considered the limits of human authority.</p><p><strong>Source theme, in contemporary language:</strong> Public authority can serve the common good, but no human command can replace God's authority or possess the conscience. Christian obedience should be lawful and peaceable while remaining faithful to God.</p><p><strong>Reflect:</strong> Where do approval, fear, or institutional pressure compete with your obedience to God? Ask whether your response is both faithful and shaped by the character of Jesus.</p><p><strong>Prayer:</strong> Sovereign God, give me a clear conscience and a humble spirit. Help me respect rightful authority and obey you when faithfulness is costly. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "value": "<p><strong>Read:</strong> 1 Samuel 16:7; Matthew 22:37-39.</p><p><strong>Historical context:</strong> Hopkins contrasted what courts and laws can observe with the motives known to God. His civic address therefore turned from outward compliance to personal character.</p><p><strong>Source theme, in contemporary language:</strong> God cares about the thoughts, loves, purposes, and choices that shape action. A good appearance cannot replace a heart learning to love God and neighbor.</p><p><strong>Reflect:</strong> Which motive beneath your recent actions needs God's light? Bring it into prayer without excuses, and choose one action that expresses honest love.</p><p><strong>Prayer:</strong> God who sees the heart, search me and renew my motives. By your Holy Spirit, teach me to love you fully and my neighbor faithfully. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "value": "<p><strong>Read:</strong> Galatians 5:13-14; Romans 8:1-2.</p><p><strong>Historical context:</strong> The sermon distinguished civic freedom from the deeper freedom of a life directed toward what is good. Its nineteenth-century political argument is reframed here as personal discipleship.</p><p><strong>Source theme, in contemporary language:</strong> Freedom is more than the absence of restraint. In Christ, freedom releases people from slavery to sin so that they may love, serve, and choose what gives life.</p><p><strong>Reflect:</strong> Where have you confused freedom with getting your own way? Consider how Christ's freedom could help you serve someone rather than protect your preference.</p><p><strong>Prayer:</strong> Lord Jesus, thank you for setting us free from sin. Direct my freedom toward love, holiness, and joyful service. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "value": "<p><strong>Read:</strong> Jeremiah 29:7; Romans 12:18.</p><p><strong>Historical context:</strong> Hopkins argued that public structures alone cannot create a healthy community. He stressed the daily influence of families, neighbors, teachers, congregations, and citizens.</p><p><strong>Source theme, in contemporary language:</strong> The common good grows through truthful speech, patient relationships, useful work, and concern for neighbors. Institutions matter, yet ordinary habits also shape whether a community becomes peaceful and just.</p><p><strong>Reflect:</strong> What is one ordinary way you affect the climate of your home, church, workplace, or neighborhood? Choose a practice that makes peace and protects another person's good.</p><p><strong>Prayer:</strong> God of peace, make me a trustworthy neighbor. Use my words, work, and relationships to strengthen the community around me. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "value": "<p><strong>Read:</strong> Romans 12:2; Titus 3:1-2.</p><p><strong>Historical context:</strong> The 1839 sermon observed that laws can restrain harm but cannot by themselves create virtue. Hopkins called his hearers to moral renewal rather than confidence in political systems alone.</p><p><strong>Source theme, in contemporary language:</strong> Rules have a proper role, but lasting change also requires renewed minds, awakened consciences, and practiced goodness. Christians contribute through gentleness, integrity, teaching, and service.</p><p><strong>Reflect:</strong> Where are you demanding change from a system while excusing the same fault in yourself? Begin with repentance and one constructive act within your reach.</p><p><strong>Prayer:</strong> Merciful God, renew my mind and conduct. Make me ready for good work, gentle toward others, and honest about the change I need. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "value": "<p><strong>Read:</strong> Daniel 3:16-18; Acts 4:19-20.</p><p><strong>Historical context:</strong> Hopkins warned that power can try to control conscience and that religion itself can be misused to support oppression. He praised principled resistance rather than ambition or mob violence.</p><p><strong>Source theme, in contemporary language:</strong> Faithful conscience may require a calm refusal to do wrong. Christian courage does not need hatred, contempt, or domination; it bears truthful witness and accepts the cost of obedience.</p><p><strong>Reflect:</strong> Is there a wrong you need to refuse or a truth you need to state? Plan words and actions that are clear, peaceful, and free from the desire to humiliate anyone.</p><p><strong>Prayer:</strong> God of truth, give me courage without contempt. Keep me faithful to Jesus and guard my witness from fear, pride, and hostility. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "value": "<p><strong>Read:</strong> Mark 10:42-45; Proverbs 29:25.</p><p><strong>Historical context:</strong> Addressing officeholders directly, Hopkins warned leaders against trading principle for popularity. His immediate audience was political, but the warning applies to every form of leadership.</p><p><strong>Source theme, in contemporary language:</strong> Leadership becomes unfaithful when approval matters more than truth and service. Jesus defines greatness through service, and responsible leaders use authority for the good of others.</p><p><strong>Reflect:</strong> Whose approval most affects your decisions? If you lead at home, work, church, or in public life, identify one choice that should be guided by service rather than praise.</p><p><strong>Prayer:</strong> Servant King, free me from the fear of people. Teach me to use every responsibility with truth, courage, and care for those I serve. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "value": "<p><strong>Read:</strong> Isaiah 1:17; James 2:1-4.</p><p><strong>Historical context:</strong> The sermon urged leaders to measure policy by justice, benevolence, and moral responsibility rather than short-term advantage. Its examples belong to an 1839 American political setting.</p><p><strong>Source theme, in contemporary language:</strong> Convenience and success cannot turn injustice into faithfulness. God's concern for the vulnerable calls both leaders and neighbors to reject favoritism, correct oppression, and pursue what is right.</p><p><strong>Reflect:</strong> Where might convenience be hiding another person's burden from you? Listen to those affected, examine your partiality, and choose a just response you can sustain.</p><p><strong>Prayer:</strong> Just and merciful God, expose my favoritism and excuses. Help me defend the vulnerable and pursue justice with patience, truth, and love. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "value": "<p><strong>Read:</strong> 1 Timothy 2:1-2; Micah 6:8.</p><p><strong>Historical context:</strong> Hopkins closed an official civic sermon by calling rulers and citizens to responsibility before God. This reading retains the call to prayer and integrity without treating one nation or political system as God's kingdom.</p><p><strong>Source theme, in contemporary language:</strong> Christians can pray for public leaders, seek peaceful conditions, practice justice, and walk humbly with God. Political outcomes never replace the church's hope in Jesus Christ.</p><p><strong>Reflect:</strong> Name one leader or public concern that usually produces anger or anxiety in you. Pray specifically, then identify one peaceful and truthful action that serves your neighbor.</p><p><strong>Prayer:</strong> Father, give wisdom to those who hold public responsibility. Make us people of justice, mercy, humility, and peace, with our lasting hope in Jesus Christ. Amen.</p>",
    "day_number": 9
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
    "id": "90000000-0000-0000-0000-000000000366",
    "day_number": 1,
    "references": [
      "Acts 5:29",
      "Romans 13:1-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "day_number": 2,
    "references": [
      "1 Samuel 16:7",
      "Matthew 22:37-39"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "day_number": 3,
    "references": [
      "Galatians 5:13-14",
      "Romans 8:1-2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "day_number": 4,
    "references": [
      "Jeremiah 29:7",
      "Romans 12:18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "day_number": 5,
    "references": [
      "Romans 12:2",
      "Titus 3:1-2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "day_number": 6,
    "references": [
      "Daniel 3:16-18",
      "Acts 4:19-20"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "day_number": 7,
    "references": [
      "Mark 10:42-45",
      "Proverbs 29:25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "day_number": 8,
    "references": [
      "Isaiah 1:17",
      "James 2:1-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000366",
    "day_number": 9,
    "references": [
      "1 Timothy 2:1-2",
      "Micah 6:8"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-23 15:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-23 15:00:00+00', timestamptz '2026-10-23 15:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish the contextualized 1839 civic-sermon adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-23 15:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000366'::uuid
);
-- END CONSOLIDATED SOURCE: 20261023150000_repair_draft_devotional_plans_wave_6.sql

-- BEGIN CONSOLIDATED SOURCE: 20261023160000_repair_draft_devotional_plans_wave_7.sql sha256=41c18d29031b0231be22d8bf98e498a16df8e501a779c6262999a566c5cc888c
-- The Francis Storr memorial collection reconstructed as eleven Scripture-led devotions.
-- The 1888 memorial setting remains explicit; denominational polemic, claims about an
-- individual's final state, and an invented death scene are omitted or corrected.
-- Existing day IDs and day numbers are preserved.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-23 16:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "Faithful Service and Hope in Christ: Eleven Readings from the Francis Storr Memorials"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-23 16:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "Eleven Scripture-led readings adapted from 1888 memorial notices and sermons for Francis Storr, including notes from his final sermon on John the Baptist. The sequence draws out quiet service, grace in weakness, prayer, the gospel, grief, witness, repentance, and costly faithfulness while identifying the local memorial setting and removing sectarian or speculative claims."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-23 16:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "Quiet Acts of Love",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "Grace in Changed Circumstances",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "Answer the Call Before You",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "Presence, Prayer, and Patient Care",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "The Grace of God in Christ",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "Christ Remains",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "Encourage One Another in Grief",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "A Witness That Points to Jesus",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "Roots Grown in Secret",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "Repentance Bears Practical Fruit",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "Faithful Through Doubt and Cost",
    "day_number": 11
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-23 16:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "<p><strong>Read:</strong> 1 John 3:18; Matthew 6:3-4.</p><p><strong>Historical context:</strong> The 1888 memorial notices describe Francis Storr's long ministry in Brenchley and the practical help he offered neighbors in need. The details belong to one Victorian parish, while the call to active love reaches beyond it.</p><p><strong>Source theme, in contemporary language:</strong> Love becomes visible through ordinary service: welcoming people, making work possible, easing another person's burden, and giving without seeking attention. Quiet kindness can reveal the generosity of Christ.</p><p><strong>Reflect:</strong> Who near you needs practical care rather than a general promise of concern? Choose one useful act you can complete without expecting recognition.</p><p><strong>Prayer:</strong> Generous God, make my love truthful and active. Show me the needs I can meet, and teach me to serve quietly in the name of Jesus. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "<p><strong>Read:</strong> 2 Corinthians 12:9; Psalm 119:11.</p><p><strong>Historical context:</strong> Storr gradually lost his sight during the final decade of his life. The memorial writers admired his continued ministry, his reliance on other people, and his deep memory of Scripture.</p><p><strong>Source theme, in contemporary language:</strong> Loss changes what a person can do, but it does not remove dignity, calling, or the grace of God. Receiving help and storing Scripture in the heart can sustain faithful service through changed circumstances.</p><p><strong>Reflect:</strong> What limitation or change are you resisting? Ask what faithful life can look like now, including the help you may need to receive from others.</p><p><strong>Prayer:</strong> God of sufficient grace, meet me in weakness and change. Plant your word deeply in me, and help me receive and offer care with humility. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "<p><strong>Read:</strong> Ephesians 2:10; Colossians 3:23-24.</p><p><strong>Historical context:</strong> The memorial traces Storr's moves between several parishes and recalls spiritual, charitable, and public-health work during those years. It presents vocation through the choices of a nineteenth-century pastor.</p><p><strong>Source theme, in contemporary language:</strong> God can use faithful work in changing places and roles. Calling is expressed through attention to the people before us, responsible labor, and willingness to enter a new task when love requires it.</p><p><strong>Reflect:</strong> Which responsibility in your present place deserves fuller attention? Consider whether faithfulness means staying, changing course, asking for help, or beginning a neglected task.</p><p><strong>Prayer:</strong> Lord, guide my work and my decisions. Help me recognize the good you have prepared and serve wholeheartedly wherever you place me. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "<p><strong>Read:</strong> Romans 12:12-13; James 5:16.</p><p><strong>Historical context:</strong> Canon Edward Hoare's funeral sermon remembers Storr visiting homes, teaching young people, supporting mission work, praying with others, and preaching in Brenchley. These are local memories rather than a model restricted to clergy.</p><p><strong>Source theme, in contemporary language:</strong> Christian care joins presence with prayer. Listening, visiting, teaching, sharing resources, and bringing needs before God are ways the whole church can strengthen people over time.</p><p><strong>Reflect:</strong> Who would be helped by your steady presence? Choose a person to contact, a need to pray for, and one practical way to remain available.</p><p><strong>Prayer:</strong> God of compassion, make me present to people who need care. Deepen my prayer, patience, and willingness to share. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "<p><strong>Read:</strong> Romans 1:16; Titus 3:4-7.</p><p><strong>Historical context:</strong> Hoare identifies the gospel of grace in Jesus Christ as the center of Storr's preaching. The sermon uses nineteenth-century Evangelical formulas; this reading restates its central confession in shared Christian language.</p><p><strong>Source theme, in contemporary language:</strong> Salvation begins in God's mercy, is accomplished through Jesus Christ, and brings new life through the Holy Spirit. Grace frees believers from boasting and forms them for faithful living and hope.</p><p><strong>Reflect:</strong> Are you treating God's acceptance as something you must earn, or grace as permission to remain unchanged? Receive mercy and ask where renewed life should become visible.</p><p><strong>Prayer:</strong> Father, thank you for saving mercy given through Jesus Christ and renewed in us by the Holy Spirit. Keep me humble, grateful, and ready for good work. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "<p><strong>Read:</strong> Philippians 2:12-13; Hebrews 13:8.</p><p><strong>Historical context:</strong> After Storr's death, Hoare asked how the congregation should continue without its longtime pastor. He directed them beyond the absent leader to the continuing presence and work of Jesus.</p><p><strong>Source theme, in contemporary language:</strong> Trusted leaders may leave, retire, or die, but Jesus Christ remains. Christian maturity receives help from teachers while depending on God, who continues to work within his people.</p><p><strong>Reflect:</strong> Has a change in leadership unsettled your faith or community? Name what you have lost, then identify one practice that keeps your attention on Christ and strengthens others.</p><p><strong>Prayer:</strong> Unchanging Lord Jesus, hold your people through every transition. Work in us, keep us close to you, and help us serve one another faithfully. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "<p><strong>Read:</strong> 1 Thessalonians 4:13-14; Hebrews 10:24-25.</p><p><strong>Historical context:</strong> W. May's memorial sermon speaks to a congregation grieving a pastor who had served it for thirty-four years. Its strongest reusable counsel is to encourage one another and continue bearing witness to Christ.</p><p><strong>Source theme, in contemporary language:</strong> Christian grief is real, yet the death and resurrection of Jesus give hope. A grieving community can make room for tears while gathering, encouraging one another, and continuing works of love.</p><p><strong>Reflect:</strong> Who is carrying grief that others may have stopped noticing? Offer presence without forcing an explanation, and remind the person through patient care that they are not alone.</p><p><strong>Prayer:</strong> Risen Lord Jesus, comfort those who mourn. Make us patient companions and strengthen our shared hope in your resurrection. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "<p><strong>Read:</strong> John 10:41-42; 2 Corinthians 4:5.</p><p><strong>Historical context:</strong> May connected Storr's ministry with the Gospel's description of John the Baptist: John performed no sign, yet his testimony about Jesus proved true. The memorial's claims about Storr are treated here as local testimony.</p><p><strong>Source theme, in contemporary language:</strong> Christian witness does not need spectacle or personal greatness. Its task is to speak truthfully about Jesus and help people trust him, while admitting the witness's own limits and faults.</p><p><strong>Reflect:</strong> Do your words about faith direct attention toward Jesus or toward your own image? Choose one simple and honest way to testify to Christ through speech or service.</p><p><strong>Prayer:</strong> Lord Jesus, keep my witness honest and centered on you. Use ordinary words and actions to help others see your truth and mercy. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "<p><strong>Read:</strong> Matthew 6:6; Psalm 1:1-3.</p><p><strong>Historical context:</strong> The notes from Storr's final sermon turn from the memorial to John the Baptist. They describe hidden preparation through prayer, self-examination, Scripture, and communion with God before public ministry.</p><p><strong>Source theme, in contemporary language:</strong> Visible faithfulness grows from hidden roots. Private prayer and sustained attention to Scripture prepare believers for public responsibility without making spiritual discipline a performance.</p><p><strong>Reflect:</strong> Which hidden practice would deepen your roots: unhurried prayer, Scripture meditation, confession, or silence? Set a realistic time and place to begin.</p><p><strong>Prayer:</strong> Father, meet me in the quiet place. Root me in your word and form a life that bears good fruit in its season. Amen.</p>",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "<p><strong>Read:</strong> Luke 3:10-14; John 1:29.</p><p><strong>Historical context:</strong> Storr's sermon presents John the Baptist as a direct and practical witness. John called different hearers to repent through generosity, honesty, restraint, and justice, and he directed them to Jesus, the Lamb of God.</p><p><strong>Source theme, in contemporary language:</strong> Repentance is more than regret. It changes how people use possessions, power, speech, and work, while forgiveness and new life remain centered on Jesus rather than moral achievement.</p><p><strong>Reflect:</strong> What fruit would make your repentance concrete? Choose one repair, act of generosity, honest decision, or restraint that matches what you are asking God to change.</p><p><strong>Prayer:</strong> Lamb of God, have mercy on me and lead me into a changed life. Make my repentance honest and its fruit useful to others. Amen.</p>",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "value": "<p><strong>Read:</strong> Matthew 11:2-6; Mark 6:27-29.</p><p><strong>Historical context:</strong> The surviving notes end with an imaginative scene about John the Baptist's execution that Scripture does not record. This reading returns to the biblical accounts of John's questions, Jesus' answer, and John's death.</p><p><strong>Source theme, in contemporary language:</strong> A faithful servant may still face questions, confinement, and loss. Jesus receives honest questions and points to the signs of God's kingdom; faithfulness rests in him rather than in invented certainty about a person's final moments.</p><p><strong>Reflect:</strong> What question or cost makes faithfulness difficult today? Bring the question directly to Jesus, attend to his words and works, and ask for courage for the next step.</p><p><strong>Prayer:</strong> Lord Jesus, receive my questions and keep me faithful when obedience is costly. Anchor my hope in your death and resurrection. Amen.</p>",
    "day_number": 11
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
    "id": "90000000-0000-0000-0000-000000000359",
    "day_number": 1,
    "references": [
      "1 John 3:18",
      "Matthew 6:3-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "day_number": 2,
    "references": [
      "2 Corinthians 12:9",
      "Psalm 119:11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "day_number": 3,
    "references": [
      "Ephesians 2:10",
      "Colossians 3:23-24"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "day_number": 4,
    "references": [
      "Romans 12:12-13",
      "James 5:16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "day_number": 5,
    "references": [
      "Romans 1:16",
      "Titus 3:4-7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "day_number": 6,
    "references": [
      "Philippians 2:12-13",
      "Hebrews 13:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "day_number": 7,
    "references": [
      "1 Thessalonians 4:13-14",
      "Hebrews 10:24-25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "day_number": 8,
    "references": [
      "John 10:41-42",
      "2 Corinthians 4:5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "day_number": 9,
    "references": [
      "Matthew 6:6",
      "Psalm 1:1-3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "day_number": 10,
    "references": [
      "Luke 3:10-14",
      "John 1:29"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000359",
    "day_number": 11,
    "references": [
      "Matthew 11:2-6",
      "Mark 6:27-29"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-23 16:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-23 16:00:00+00', timestamptz '2026-10-23 16:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish the contextualized Francis Storr memorial adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-23 16:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000359'::uuid
);
-- END CONSOLIDATED SOURCE: 20261023160000_repair_draft_devotional_plans_wave_7.sql

-- BEGIN CONSOLIDATED SOURCE: 20261025120000_repair_draft_devotional_plans_wave_8.sql sha256=99733ac294bc2cff49b478458d00d695a8150cc0e356e00876524976580e04ab
-- One 1626 funeral sermon reconstructed as fifteen Scripture-led daily devotions.
-- The historical setting remains explicit; degrading gender claims, restrictive social
-- assumptions, and claims about an individual's final state are omitted or corrected.
-- Existing day IDs and day numbers are preserved.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-25 12:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Reverence, Grace, and Faithful Living: Fifteen Readings from a 1626 Funeral Sermon"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-25 12:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Fifteen Scripture-led readings adapted from Hannibal Gamon's 1626 funeral sermon for Lady Frances Roberts. The sequence retains themes of reverence, equal dignity in Christ, practical love, perseverance, repentance, grief, and new life through Jesus while identifying the historical setting and setting aside degrading gender claims, restrictive social assumptions, and speculation about any person's final state."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-25 12:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "God Brings Hearts to Light",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Character Outlasts Appearance",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "One in Christ and One in Need of Grace",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Love Takes Responsibility",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Reverence Rooted in Adoption",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Grace Holds Us as We Persevere",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Reverence Without Anxiety",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Repentance Opens a New Way",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Praise the Grace of God",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Grieve and Remember Truthfully",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Leave Final Praise to God",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Treasures in Ordinary Vessels",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "United with Christ Against Sin",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Repentance Repairs Relationships",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "Hear the Word and Practice It",
    "day_number": 15
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-25 12:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> 1 Corinthians 4:5; Psalm 139:23-24.</p><p><strong>Historical context:</strong> Hannibal Gamon preached this sermon at the 1626 funeral of Lady Frances Roberts in Cornwall. He opened by warning that final judgment belongs to God, even as he prepared to commend her life.</p><p><strong>Source theme, in contemporary language:</strong> Human praise cannot reveal every motive, and a funeral should not pretend to know what only God knows. We can remember visible faithfulness while entrusting hidden hearts and final judgment to the Lord.</p><p><strong>Reflect:</strong> Where are you tempted either to idealize someone or to judge a motive you cannot see? Name what you truly know, release what you do not know, and invite God to search your own heart.</p><p><strong>Prayer:</strong> God of truth, guard me from flattery and harsh judgment. Bring my heart into your light and form integrity within me. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> Proverbs 31:30; 1 Samuel 16:7.</p><p><strong>Historical context:</strong> The sermon contrasts beauty, wealth, rank, and intelligence with a life oriented toward God. Its praise of Lady Frances is tied to seventeenth-century social expectations that this adaptation does not repeat.</p><p><strong>Source theme, in contemporary language:</strong> Appearance and status are temporary measures of worth. God looks at the heart, and reverence for him becomes visible through humble, truthful, and loving character.</p><p><strong>Reflect:</strong> Which outward measure most influences how you value yourself or another person? Choose one way to notice and encourage Christlike character instead.</p><p><strong>Prayer:</strong> Lord, free me from judging by appearance, wealth, influence, or rank. Shape in me the inner beauty of humility and love. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> Galatians 3:27-28; Romans 3:22-24.</p><p><strong>Historical context:</strong> Gamon says women and men alike stand under sin and can receive grace, yet he also repeats old claims about female weakness. This reading retains the equality he acknowledges and rejects those degrading assumptions.</p><p><strong>Source theme, in contemporary language:</strong> Every person bears equal dignity before God, every person needs mercy, and all who belong to Christ share one baptismal identity. No sex, class, or social rank creates spiritual superiority.</p><p><strong>Reflect:</strong> Where might a stereotype be shaping your expectations of another believer? Listen to the person's gifts and experience, and practice the equal honor given in Christ.</p><p><strong>Prayer:</strong> Father, thank you that we are one in Christ Jesus. Forgive my prejudice and teach me to honor the dignity and gifts of every person. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> Romans 12:9-13; Galatians 6:10.</p><p><strong>Historical context:</strong> The sermon describes care for children, relatives, household workers, neighbors, and people in need through the duties assigned to a woman of rank in 1626. This devotion applies the call to every Christian.</p><p><strong>Source theme, in contemporary language:</strong> Reverence for God produces practical love: providing what is needed, teaching by example, honoring others, sharing resources, welcoming people, and refusing contempt.</p><p><strong>Reflect:</strong> Which relationship or responsibility have you treated as beneath your attention? Choose one concrete act of honor, provision, hospitality, or help.</p><p><strong>Prayer:</strong> God of steadfast love, make my care practical and sincere. Help me notice needs, share generously, and honor others without pride. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> Romans 8:15-16; Deuteronomy 10:12-13.</p><p><strong>Historical context:</strong> Gamon distinguishes loving reverence for God from fear based only on punishment. He connects faithful obedience with God's mercy and the Spirit of adoption.</p><p><strong>Source theme, in contemporary language:</strong> The fear of the Lord is not servile terror. God's children approach their holy Father with awe, love, trust, and a desire to walk in ways that give life.</p><p><strong>Reflect:</strong> Does your view of God lead mainly to hiding, or to honest reverence and trust? Bring one failure into the light and receive the Spirit's assurance that calls you back to faithful living.</p><p><strong>Prayer:</strong> Holy Father, free me from fear that drives me away from you. By your Spirit, deepen my trust, reverence, and willing obedience. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> 1 Peter 1:3-5; Hebrews 7:25.</p><p><strong>Historical context:</strong> The sermon gathers many biblical texts about perseverance, Christ's intercession, and God's keeping power. Dense Latin notes and disputed applications obscure that devotional center in the original day.</p><p><strong>Source theme, in contemporary language:</strong> Believers persevere because God's mercy gives new birth, Jesus intercedes, and God's power guards hope. Faith responds through steady trust rather than confidence in personal strength.</p><p><strong>Reflect:</strong> Where are you tired of continuing in faithfulness? Ask for the next measure of grace, and let a trusted believer know where you need prayer and encouragement.</p><p><strong>Prayer:</strong> Faithful God, keep me through weariness and temptation. Thank you that Jesus intercedes for us; strengthen me to continue in hope. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> 1 John 4:18; 2 Timothy 1:7.</p><p><strong>Historical context:</strong> Gamon compares healthy reverence with distorted fear, but his extended argument can blur the difference between devotion and anxiety. This reading states that distinction directly.</p><p><strong>Source theme, in contemporary language:</strong> Godly reverence draws us toward truth, love, and obedience. Fear that traps us in panic, imagined threats, or submission to human control does not reflect the Spirit of power, love, and self-control.</p><p><strong>Reflect:</strong> Which fear is guiding a decision: reverence for God, fear of another person's reaction, or anxious imagination? Seek wise counsel and choose the path shaped by truth and love.</p><p><strong>Prayer:</strong> God of peace, steady my mind and free me from controlling fear. Give me power, love, self-control, and reverence for you. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> Proverbs 14:27; Acts 3:19.</p><p><strong>Historical context:</strong> The sermon calls reverence for God a fountain of life because it turns people from sins already committed and strengthens resistance to temptation. Its older threats are reframed through the biblical invitation to repent.</p><p><strong>Source theme, in contemporary language:</strong> Repentance is a grace-filled turn toward God. It names sin honestly, receives mercy, changes direction, and learns practices that protect new life.</p><p><strong>Reflect:</strong> What pattern needs more than regret? Name the turn you need to make, the repair you owe, and the boundary or practice that could support a changed direction.</p><p><strong>Prayer:</strong> Merciful God, lead me to honest repentance. Blot out my sins, refresh my life in Christ, and strengthen me to resist what draws me away from you. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> 1 Corinthians 15:10; Philippians 2:13.</p><p><strong>Historical context:</strong> Gamon argues that praising a faithful person should ultimately acknowledge God's grace at work. His funeral praise is best read as testimony rather than proof of Lady Frances's final standing before God.</p><p><strong>Source theme, in contemporary language:</strong> We may give thanks for another person's faithful example without turning that person into a hero beyond criticism. Every good fruit depends on grace, and all glory returns to God.</p><p><strong>Reflect:</strong> Think of someone whose example helped you. What specific fruit can you thank God for, and how can you imitate it without idealizing the person?</p><p><strong>Prayer:</strong> God of grace, thank you for faithful examples. Keep my gratitude truthful, and produce in me the good work that honors you. Amen.</p>",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> John 11:33-36; 1 Thessalonians 4:13-14.</p><p><strong>Historical context:</strong> The funeral sermon defends public mourning and remembrance, then lists family roles through the assumptions of its period. This devotion keeps grief and gratitude together without defining a woman's worth by those roles.</p><p><strong>Source theme, in contemporary language:</strong> Jesus made room for tears, and Christian hope does not erase grief. We can remember a whole person with gratitude, sorrow, honesty, and hope grounded in Jesus' death and resurrection.</p><p><strong>Reflect:</strong> Is there a loss you have rushed past or a memory you have simplified? Make room for both gratitude and sorrow, and entrust the person to God's just and merciful care.</p><p><strong>Prayer:</strong> Lord Jesus, receive our tears and memories. Comfort those who mourn and keep our hope anchored in your resurrection. Amen.</p>",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> 1 Corinthians 4:5; Hebrews 10:35-36.</p><p><strong>Historical context:</strong> Gamon cautions against demanding praise too soon and returns to the promise that God will disclose hearts at Christ's coming. The sermon surrounds this point with classical and medieval examples.</p><p><strong>Source theme, in contemporary language:</strong> Faithfulness does not require immediate recognition. God sees work hidden from public praise, and believers can endure without controlling their reputation or issuing final verdicts about others.</p><p><strong>Reflect:</strong> Where has lack of recognition made you bitter or tempted you to advertise yourself? Offer the work to God again and seek the patience to continue doing what is right.</p><p><strong>Prayer:</strong> God who sees in secret, free me from hunger for applause. Give me endurance, honest motives, and peace in leaving final judgment to you. Amen.</p>",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> 2 Corinthians 4:7; Galatians 3:28.</p><p><strong>Historical context:</strong> Before recounting Lady Frances's actions, the sermon says God's grace can be displayed through women as fully as through men. It still speaks through assumptions of rank and gender that this adaptation sets aside.</p><p><strong>Source theme, in contemporary language:</strong> The treasure of the gospel belongs in ordinary and diverse human lives. God's power is not limited by sex, status, weakness, or social expectation, and no believer should be treated as spiritually secondary.</p><p><strong>Reflect:</strong> Whose contribution have you overlooked because of status, gender, weakness, or an unimpressive role? Make space to receive that person's gift and voice.</p><p><strong>Prayer:</strong> Lord, place the light of Christ in us and teach us to honor your treasure in every believer. Let your power be seen through our weakness. Amen.</p>",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> Romans 6:4-6; 2 Corinthians 12:9.</p><p><strong>Historical context:</strong> Gamon remembers Lady Frances struggling against a recurring sin and finding hope in Christ's death and resurrection and the sanctifying work of the Holy Spirit. The personal details remain his testimony, not an independent verdict.</p><p><strong>Source theme, in contemporary language:</strong> Union with the crucified and risen Christ brings pardon and power for change. The Holy Spirit meets weakness with grace and teaches believers to resist sin, rise after failure, and walk in new life.</p><p><strong>Reflect:</strong> Which recurring sin have you begun to treat as permanent? Bring it to Christ, identify its usual trigger, and choose one Spirit-led action that interrupts the pattern.</p><p><strong>Prayer:</strong> Crucified and risen Lord Jesus, unite me to your new life. By the Holy Spirit, meet my weakness with grace and free me from sin's rule. Amen.</p>",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> Ephesians 4:26-27; 2 Corinthians 7:10-11.</p><p><strong>Historical context:</strong> The sermon recalls Lady Frances becoming grieved by her anger and seeking change before describing her painful death. This reading keeps the call to repentance without using suffering as proof of another person's spiritual state.</p><p><strong>Source theme, in contemporary language:</strong> Godly sorrow produces a changed response. Repentance for anger includes ending retaliation, speaking truthfully, repairing harm, and refusing to let resentment settle into the heart.</p><p><strong>Reflect:</strong> Is anger still directing your words or silence toward someone? Name the harm, seek forgiveness where appropriate, and take one safe step toward truth and peace.</p><p><strong>Prayer:</strong> God of reconciliation, turn my sorrow into real change. Restrain harmful anger, help me repair what I have damaged, and lead me in peace. Amen.</p>",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "value": "<p><strong>Read:</strong> James 1:22-25; 2 Corinthians 5:10.</p><p><strong>Historical context:</strong> Gamon closes by urging listeners not to let a long funeral sermon vanish without practice. His conclusion includes severe rhetoric and speculation about judgment that are omitted here.</p><p><strong>Source theme, in contemporary language:</strong> The purpose of hearing Scripture is faithful response. Christ will judge with perfect knowledge, so believers can act now through repentance, mercy, justice, perseverance, and trust in him.</p><p><strong>Reflect:</strong> Which truth in this sequence needs to become action rather than another note? Write one specific practice, person, place, and time for your response.</p><p><strong>Prayer:</strong> Lord Jesus, make me a doer of your word. Lead me in repentance, mercy, justice, and perseverance as I await your righteous judgment. Amen.</p>",
    "day_number": 15
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
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 1,
    "references": [
      "1 Corinthians 4:5",
      "Psalm 139:23-24"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 2,
    "references": [
      "Proverbs 31:30",
      "1 Samuel 16:7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 3,
    "references": [
      "Galatians 3:27-28",
      "Romans 3:22-24"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 4,
    "references": [
      "Romans 12:9-13",
      "Galatians 6:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 5,
    "references": [
      "Romans 8:15-16",
      "Deuteronomy 10:12-13"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 6,
    "references": [
      "1 Peter 1:3-5",
      "Hebrews 7:25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 7,
    "references": [
      "1 John 4:18",
      "2 Timothy 1:7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 8,
    "references": [
      "Proverbs 14:27",
      "Acts 3:19"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 9,
    "references": [
      "1 Corinthians 15:10",
      "Philippians 2:13"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 10,
    "references": [
      "John 11:33-36",
      "1 Thessalonians 4:13-14"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 11,
    "references": [
      "1 Corinthians 4:5",
      "Hebrews 10:35-36"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 12,
    "references": [
      "2 Corinthians 4:7",
      "Galatians 3:28"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 13,
    "references": [
      "Romans 6:4-6",
      "2 Corinthians 12:9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 14,
    "references": [
      "Ephesians 4:26-27",
      "2 Corinthians 7:10-11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000326",
    "day_number": 15,
    "references": [
      "James 1:22-25",
      "2 Corinthians 5:10"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-25 12:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-25 12:00:00+00', timestamptz '2026-10-25 12:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish the contextualized 1626 funeral-sermon adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-25 12:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000326'::uuid
);
-- END CONSOLIDATED SOURCE: 20261025120000_repair_draft_devotional_plans_wave_8.sql

-- BEGIN CONSOLIDATED SOURCE: 20261025130000_repair_draft_devotional_plans_wave_9.sql sha256=a387352cc34521e846fa209c32c6fb59c91e45f9c0c50cda4291d431ad916fd3
-- One 1621 Plymouth sermon reconstructed as thirteen Scripture-led daily devotions.
-- The colonial setting remains explicit; degrading descriptions, severe judgments, and
-- context-bound social prescriptions are omitted, rejected, or reframed.
-- Existing day IDs and day numbers are preserved.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-25 13:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Seeking Another's Good: Thirteen Readings from a 1621 Plymouth Sermon"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-25 13:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Thirteen Scripture-led readings adapted from Robert Cushman's 1621 Plymouth sermon on 1 Corinthians 10:24. The sequence retains its call to examine self-interest, share resources, carry burdens, and follow Christ's self-giving love while identifying the colonial setting and rejecting demeaning labels, degrading descriptions of Indigenous people, severe judgments, and social prescriptions that should not govern a general devotional."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-25 13:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Seek Another's Good",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Invite God to Search the Heart",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Hold Wealth for God's Purposes",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Use Strength to Serve",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Work Without Chasing Applause",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Follow the Self-Giving Christ",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Care for Every Member",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Practice Fair and Generous Sharing",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Love Beyond Reciprocity",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Carry Burdens Together",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Respond to Weakness with Patience",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Let Peace Become a Public Witness",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Put Love into Practice",
    "day_number": 13
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-25 13:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> 1 Corinthians 10:23-24; Philippians 2:3-4.</p><p><strong>Historical context:</strong> Robert Cushman preached this sermon at Plymouth in 1621 to a small colonial community facing scarcity and conflict. His central text calls believers to seek another person's good rather than make private advantage their ruling concern.</p><p><strong>Source theme, in contemporary language:</strong> Christian freedom is guided by love. A choice may be permitted yet still be unhelpful when it wounds a neighbor, weakens the community, or places personal preference above another person's well-being.</p><p><strong>Reflect:</strong> Think about one choice that affects other people. Beyond asking whether you may do it, ask whether it builds them up and reflects the love of Christ.</p><p><strong>Prayer:</strong> Lord Jesus, free me from making myself the center. Teach me to use my freedom for my neighbor's good and your glory. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> Psalm 139:23-24; Romans 12:3.</p><p><strong>Historical context:</strong> Cushman treats self-love as a hidden spiritual illness and urges hearers to examine their motives. His medical imagery is forceful, but its useful question is whether self-interest has distorted our judgment.</p><p><strong>Source theme, in contemporary language:</strong> Self-examination begins with humility before God. We need the Spirit to uncover pride, defensiveness, and the quiet bargains by which service to others becomes a way to secure praise or advantage.</p><p><strong>Reflect:</strong> Recall a recent act of service. What mixed motives were present? Receive God's mercy, give thanks for what was loving, and release your need to be noticed or repaid.</p><p><strong>Prayer:</strong> Search me, God, and know my heart. Expose pride without crushing me, forgive what is false, and make my love sincere. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> Matthew 6:19-21; 1 Timothy 6:17-19.</p><p><strong>Historical context:</strong> The sermon warns settlers against gathering wealth while neighbors lack necessities. Its economic instructions address a particular community, yet its challenge to greed remains relevant.</p><p><strong>Source theme, in contemporary language:</strong> Money is an uncertain foundation and a useful servant. God provides resources so that we may meet responsibilities, enjoy his gifts with gratitude, share readily, and become rich in good works.</p><p><strong>Reflect:</strong> What does your spending reveal about where you seek security? Choose one practical way to loosen your grip and provide something useful for another person.</p><p><strong>Prayer:</strong> Generous God, keep wealth from ruling my heart. Give me contentment, wisdom, and open hands for the needs you place before me. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> Mark 10:42-45; Galatians 5:13.</p><p><strong>Historical context:</strong> Cushman criticizes people who pursue ease while others carry the community's hardest work. Some of his labels for people are demeaning; this reading keeps the call to service without contempt.</p><p><strong>Source theme, in contemporary language:</strong> Jesus turns power away from domination and toward service. Ability, authority, time, and energy become gifts when they help carry necessary work and protect people from being overburdened.</p><p><strong>Reflect:</strong> Where are you benefiting from work that someone else carries unseen? Offer specific help, share the load fairly, and honor the person whose labor you have overlooked.</p><p><strong>Prayer:</strong> Servant King, reshape my use of strength and authority. Make me ready to help, attentive to hidden labor, and faithful in ordinary service. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> Colossians 3:23-24; Romans 12:9-10.</p><p><strong>Historical context:</strong> The sermon names honor and public approval among the ways self-interest can govern religious work. Cushman's rhetoric is severe, but the underlying concern is service performed for reputation.</p><p><strong>Source theme, in contemporary language:</strong> Faithful work is offered to the Lord and joined to sincere love. We may receive encouragement with gratitude while refusing to make praise the price of our service.</p><p><strong>Reflect:</strong> How does recognition affect your willingness to serve? Do one useful act that may remain unseen, and offer both the work and its outcome to God.</p><p><strong>Prayer:</strong> God who sees in secret, purify my desire for recognition. Help me work wholeheartedly and honor others above myself. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> Philippians 2:5-8; John 13:34-35.</p><p><strong>Historical context:</strong> Cushman points to God's generosity and to Jesus Christ laying aside glory for our salvation. This is the theological center of his appeal to seek another's good.</p><p><strong>Source theme, in contemporary language:</strong> Christian love takes its shape from Jesus, the eternal Son who humbled himself, became obedient to death, and commands his disciples to love one another. We give because God first gave himself to us.</p><p><strong>Reflect:</strong> Where is Christ inviting you to lay aside status, comfort, or the need to win? Choose a humble act of love that makes his character visible.</p><p><strong>Prayer:</strong> Lord Jesus Christ, thank you for humbling yourself for us. Form your self-giving love in me and make my life a witness to you. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> 1 Corinthians 12:24-27; Acts 2:44-47.</p><p><strong>Historical context:</strong> The sermon compares the Plymouth congregation to one body whose members must care for one another. Its detailed social arrangement belonged to that early settlement and is not imposed as a universal economic system here.</p><p><strong>Source theme, in contemporary language:</strong> In Christ, another believer's suffering is not someone else's problem. The church becomes a credible community when people notice needs, share resources, receive help without shame, and rejoice together.</p><p><strong>Reflect:</strong> Who in your church or community may be carrying a need alone? Ask respectfully, listen before assuming, and help in a way that protects dignity and agency.</p><p><strong>Prayer:</strong> Holy Spirit, bind us together as Christ's body. Give us compassion to notice, humility to receive, and generosity to share. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> 2 Corinthians 8:13-15; James 2:15-16.</p><p><strong>Historical context:</strong> Cushman preached after illness and deprivation had marked the colony's first year. He urges hearers to provide food, clothing, shelter, and practical relief rather than wait for desperate people to plead.</p><p><strong>Source theme, in contemporary language:</strong> Compassion moves beyond kind wishes. Christian generosity seeks a fair sharing of burdens so that one person's abundance can answer another person's present need.</p><p><strong>Reflect:</strong> What need have you acknowledged only with words? Identify one resource, skill, connection, or portion of time you can share in a practical and respectful way.</p><p><strong>Prayer:</strong> God of provision, make my compassion concrete. Lead me to share wisely, protect dignity, and help meet real needs. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> Matthew 5:43-48; Luke 6:35-36.</p><p><strong>Historical context:</strong> The sermon answers the fear that generosity is unsafe when other people are selfish. Cushman directs hearers away from copying the crowd and toward the teaching of Jesus.</p><p><strong>Source theme, in contemporary language:</strong> Jesus does not limit love to people who can repay us. God's mercy frees believers to seek another's good without making kindness depend on equal treatment or guaranteed return.</p><p><strong>Reflect:</strong> Where have you made another person's response the condition for doing what is right? Set a wise boundary if needed, then choose a loving action that does not depend on repayment.</p><p><strong>Prayer:</strong> Merciful Father, teach me to love as your child. Give me wisdom, safe boundaries, and freedom from keeping score. Amen.</p>",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> Galatians 6:2; Romans 12:15.</p><p><strong>Historical context:</strong> Cushman imagines neighbors treating another person's hunger, sickness, sorrow, and welfare as concerns they share. The examples come from a tightly bound settlement, but the call to compassionate solidarity is wider.</p><p><strong>Source theme, in contemporary language:</strong> Bearing burdens means entering another person's reality with patient presence and suitable help. We neither seize control nor stay distant; we mourn, rejoice, pray, and act together.</p><p><strong>Reflect:</strong> Whose burden do you know about but keep at a distance? Ask what support would actually help, and commit to one action you can sustain.</p><p><strong>Prayer:</strong> God of compassion, keep me present to another's joy and pain. Give me patience, humility, and strength to help carry burdens. Amen.</p>",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> 1 Thessalonians 5:14; Romans 14:1.</p><p><strong>Historical context:</strong> Near the sermon’s close, Cushman warns against hastily calling people lazy because their strength, skill, or courage differs. Elsewhere his language does not always meet this standard, so this reading states the principle consistently.</p><p><strong>Source theme, in contemporary language:</strong> Christian community distinguishes unwillingness from limitation and responds to each person with discernment. We admonish the disruptive, encourage the discouraged, help the weak, and remain patient with everyone.</p><p><strong>Reflect:</strong> Whose capacity have you judged without understanding? Replace the label with a question, listen to the person's circumstances, and offer support suited to the real need.</p><p><strong>Prayer:</strong> Patient God, forgive my hasty judgments. Give me discernment to respond truthfully and compassionately to each person. Amen.</p>",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> Ephesians 4:1-3; Colossians 3:12-15.</p><p><strong>Historical context:</strong> The sermon closes by urging the colonists to live in peace, yet it describes Indigenous neighbors through degrading colonial prejudice. This adaptation rejects that language and applies the call to humility, justice, and peace toward every neighbor.</p><p><strong>Source theme, in contemporary language:</strong> Christian witness is credible when communities practice humility, patience, forgiveness, and just peace. Christ's peace must govern how believers treat people within the church and neighbors beyond it.</p><p><strong>Reflect:</strong> What rivalry, stereotype, or grievance is weakening your witness? Seek truthful understanding and take one step that joins peace with justice and respect.</p><p><strong>Prayer:</strong> Prince of Peace, expose prejudice and heal division. Clothe us with compassion, guide us in justice, and make our common life a faithful witness. Amen.</p>",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> James 1:22-25; 1 Corinthians 10:31-33.</p><p><strong>Historical context:</strong> Cushman's sermon moves from diagnosis to action: examine self-interest, seek another's welfare, and strengthen the community. Its enduring value lies in this practical response rather than in every judgment or social prescription it contains.</p><p><strong>Source theme, in contemporary language:</strong> The word of God calls for embodied obedience. We glorify God when daily choices become less governed by self-protection and more attentive to the salvation, dignity, and good of others.</p><p><strong>Reflect:</strong> Review these readings and choose one practice for the coming week. Name the person, action, and time so that the intention becomes a faithful step.</p><p><strong>Prayer:</strong> God of love, make me a doer of your word. Turn reflection into faithful action and teach me to seek my neighbor's good. Amen.</p>",
    "day_number": 13
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
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 1,
    "references": [
      "1 Corinthians 10:23-24",
      "Philippians 2:3-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 2,
    "references": [
      "Psalm 139:23-24",
      "Romans 12:3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 3,
    "references": [
      "Matthew 6:19-21",
      "1 Timothy 6:17-19"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 4,
    "references": [
      "Mark 10:42-45",
      "Galatians 5:13"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 5,
    "references": [
      "Colossians 3:23-24",
      "Romans 12:9-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 6,
    "references": [
      "Philippians 2:5-8",
      "John 13:34-35"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 7,
    "references": [
      "1 Corinthians 12:24-27",
      "Acts 2:44-47"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 8,
    "references": [
      "2 Corinthians 8:13-15",
      "James 2:15-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 9,
    "references": [
      "Matthew 5:43-48",
      "Luke 6:35-36"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 10,
    "references": [
      "Galatians 6:2",
      "Romans 12:15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 11,
    "references": [
      "1 Thessalonians 5:14",
      "Romans 14:1"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 12,
    "references": [
      "Ephesians 4:1-3",
      "Colossians 3:12-15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 13,
    "references": [
      "James 1:22-25",
      "1 Corinthians 10:31-33"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-25 13:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-25 13:00:00+00', timestamptz '2026-10-25 13:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish the contextualized 1621 Plymouth-sermon adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-25 13:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000333'::uuid
);
-- END CONSOLIDATED SOURCE: 20261025130000_repair_draft_devotional_plans_wave_9.sql

-- BEGIN CONSOLIDATED SOURCE: 20261025140000_repair_draft_devotional_plans_wave_10.sql sha256=73936814303f1c418f898026acd091eae4c3d23a1a13b0c0cf5139d573093d84
-- Four nineteenth-century Christian tales reconstructed as thirteen daily devotions.
-- Story context is retained while moral simplification, child-safety risks, social
-- prejudice, speculation about the dead, and simplistic addiction framing are corrected.
-- Existing day IDs and day numbers are preserved.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-25 14:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Faith in Action: Thirteen Readings from Four Christian Tales"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-25 14:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Thirteen Scripture-led readings adapted from four public-domain Christian tales by Selina Bunbury: The Little Pavior, The Silver Knife, The Modern Dorcas, and The Tract Found by the Way-Side. Story summaries lead into reflection and prayer on practical care, truth, mercy, grief, repentance, encouragement, and patient change while identifying nineteenth-century assumptions and avoiding moral simplification, child-safety risks, social prejudice, speculation about the dead, and simplistic treatment of addiction or family harm."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-25 14:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Notice What Could Help",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Work Carefully and Safely",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Let Gratitude Become Blessing",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Refuse Hasty Suspicion",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Tell the Truth and Make Repair",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Use the Time You Have",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Faith Becomes Practical Care",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Grieve with Resurrection Hope",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Continue the Work of Love",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Let Scripture Interrupt Your Path",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Repentance Begins to Change Habits",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Encourage Change Without Control",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Trust God to Continue His Work",
    "day_number": 13
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-25 14:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> Proverbs 20:11; Philippians 2:4.</p><p><strong>Story and historical context:</strong> In Selina Bunbury's nineteenth-century tale The Little Pavior, Francis sees that his grandfather has slipped on a muddy path. The story presents a child whose careful attention leads him to imagine a practical repair.</p><p><strong>Devotional focus:</strong> Love pays attention. Age does not prevent a person from noticing danger, understanding another person's need, and offering a thoughtful response.</p><p><strong>Reflect:</strong> What repeated difficulty affects someone near you? Before acting, ask what would truly help and whether you need guidance, permission, or another person's skill.</p><p><strong>Prayer:</strong> God of wisdom, open my eyes to the needs around me. Give me compassion, good judgment, and readiness to help. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> Colossians 3:23-24; Proverbs 22:3.</p><p><strong>Story and historical context:</strong> Francis gathers sand and stones and builds a small raised pavement. The original story celebrates his independent effort; contemporary readers should also recognize that children need safe tasks, suitable tools, and adult supervision.</p><p><strong>Devotional focus:</strong> Faithful service joins diligence with wisdom. Good intentions do not remove the need to consider safety, learn from others, and complete work with care.</p><p><strong>Reflect:</strong> Is there a helpful task you have rushed or attempted without enough knowledge? Identify the next careful step and the person whose advice could make the work safer and better.</p><p><strong>Prayer:</strong> Lord, teach me to serve wholeheartedly and wisely. Protect those who work, and help me value care above praise or speed. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> 1 Thessalonians 5:11; Psalm 90:17.</p><p><strong>Story and historical context:</strong> Francis's grandfather discovers the repaired path and responds with gratitude and a prayer for the child's future. The tale ends by connecting practical love with encouragement and blessing.</p><p><strong>Devotional focus:</strong> When another person serves faithfully, gratitude can strengthen that person rather than merely reward an achievement. We recognize the good, thank God, and speak words that encourage continued growth.</p><p><strong>Reflect:</strong> Whose quiet effort has made your path easier? Thank the person specifically and ask God to establish the good work of their hands.</p><p><strong>Prayer:</strong> Gracious God, thank you for people whose care makes life safer and kinder. Teach me to notice their work and encourage them well. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> James 1:19; 1 Corinthians 13:7.</p><p><strong>Story and historical context:</strong> In The Silver Knife, a household searches for Mary's missing knife. Several characters quickly suspect a poor child, a servant, or even a bird before they have reliable evidence.</p><p><strong>Devotional focus:</strong> Love does not turn uncertainty into accusation. Christians listen carefully, resist prejudice, and seek truth without treating social status or a troubled expression as proof of guilt.</p><p><strong>Reflect:</strong> When have you filled a gap in your knowledge with a negative story about someone? Separate what you know from what you assume, and seek the truth with patience.</p><p><strong>Prayer:</strong> God of truth, slow my anger and guard my speech. Free me from prejudice and teach me to listen before I judge. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> Ephesians 4:25; Galatians 6:1.</p><p><strong>Story and historical context:</strong> The knife is found in a cheese, exposing a servant's false explanation and misuse of household food. Bunbury's tale ends with confession, correction, mercy, and the family's refusal to shame her through gossip.</p><p><strong>Devotional focus:</strong> Truth and mercy belong together. Wrongdoing should be named and repaired, while restoration should be gentle, accountable, and protected from humiliating spectacle.</p><p><strong>Reflect:</strong> Do you need to correct a false statement, return something, or repair trust? Take responsibility plainly, and if another person confesses, respond without cruelty or gossip.</p><p><strong>Prayer:</strong> Merciful God, give me courage to tell the truth and repair harm. Make me gentle and wise when another person needs restoration. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> John 9:4; Ephesians 5:15-16.</p><p><strong>Story and historical context:</strong> The Modern Dorcas is written as a young woman's letter after the death of her sixteen-year-old friend Amelia. The story uses an early death to urge readers toward immediate service, a common pattern in nineteenth-century religious literature.</p><p><strong>Devotional focus:</strong> Life's uncertainty invites faithful attention to today. We need not live in fear or prove our worth through constant activity; grace frees us to do the good God places within reach.</p><p><strong>Reflect:</strong> What loving action have you postponed for a more convenient season? Choose one realistic act you can complete today without neglecting rest or responsibility.</p><p><strong>Prayer:</strong> Eternal God, teach me to receive today as your gift. Lead me into the good work prepared for me, with freedom from fear and striving. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> Acts 9:36-39; James 2:15-17.</p><p><strong>Story and historical context:</strong> Neighbors remember Amelia teaching, sewing clothes, visiting sick people, and helping families find work. The tale compares her with Tabitha, also called Dorcas, whose loving deeds were remembered by her community.</p><p><strong>Devotional focus:</strong> Living faith addresses bodies, minds, relationships, and spiritual needs. Practical care may involve making, teaching, visiting, connecting, advocating, or sharing resources.</p><p><strong>Reflect:</strong> Which gift or ordinary skill could become care for someone else? Ask what is needed and offer that gift in a way that respects the person's choices and dignity.</p><p><strong>Prayer:</strong> Lord Jesus, make my faith active in love. Use my hands, knowledge, time, and relationships to serve people with dignity. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> John 11:33-36; 1 Thessalonians 4:13-14.</p><p><strong>Story and historical context:</strong> Amelia's neighbors speak at her grave about the help they received from her. The narrator expresses confidence about Amelia's final state in language typical of a memorial tale; this reading leaves final judgment with God.</p><p><strong>Devotional focus:</strong> Christian hope makes room for tears. We remember visible fruits with gratitude while entrusting the person who died to the just and merciful God revealed in the death and resurrection of Jesus.</p><p><strong>Reflect:</strong> Is there someone you need to remember with both honesty and gratitude? Name the loss, give thanks for specific good, and bring what you cannot know into God's care.</p><p><strong>Prayer:</strong> Risen Lord Jesus, comfort those who mourn. Receive our gratitude and questions, and anchor our hope in your resurrection. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> Hebrews 10:24; 2 Timothy 2:2.</p><p><strong>Story and historical context:</strong> After hearing how Amelia served, Anna and her brother record the names of people she had visited and begin helping them. Her example becomes an invitation to sustained community care rather than admiration alone.</p><p><strong>Devotional focus:</strong> A faithful example bears fruit when others learn, share responsibility, and continue good work. Christian service should grow through communities instead of depending on one admired person.</p><p><strong>Reflect:</strong> What valuable work is too dependent on one person? Consider how you can learn the task, support the worker, or help build a team that can continue serving faithfully.</p><p><strong>Prayer:</strong> God of steadfast love, turn admiration into participation. Help us share knowledge, responsibility, and encouragement as we serve together. Amen.</p>",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> Psalm 119:105; Hebrews 4:12.</p><p><strong>Story and historical context:</strong> In The Tract Found by the Way-Side, Mark finds a small religious pamphlet while planning to disobey his father. He begins reading out of boredom, but the story inside challenges the direction of his life.</p><p><strong>Devotional focus:</strong> God can use Scripture to interrupt settled habits and expose a better path. The power belongs to God's living word, not to a particular format or method of distribution.</p><p><strong>Reflect:</strong> When did a biblical truth last interrupt your plans or assumptions? Return to that passage and identify the response it asks of you now.</p><p><strong>Prayer:</strong> Speaking God, shine your light on my path. Give me humility to hear your word and courage to change direction. Amen.</p>",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> Acts 3:19; Titus 2:11-12.</p><p><strong>Story and historical context:</strong> Mark reconsiders his ridicule of faith, chooses not to attend a harmful gathering, works willingly, and speaks more kindly at home. The tale portrays change beginning through small, observable choices.</p><p><strong>Devotional focus:</strong> Repentance is more than feeling ashamed. God's grace turns us toward him and trains us to replace destructive habits with truthful, loving, and responsible action.</p><p><strong>Reflect:</strong> What small choice would show that your repentance is becoming practice? Make the action specific enough to complete and invite a trustworthy person to encourage you.</p><p><strong>Prayer:</strong> God of grace, turn me from sin and train me in a new way of life. Let changed habits bear witness to your patient work. Amen.</p>",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> 1 Thessalonians 5:11; 2 Timothy 2:24-25.</p><p><strong>Story and historical context:</strong> Mark's sister Josephine listens, answers his questions, and encourages his desire to change. Other family members begin examining their own conduct instead of treating Mark as the only problem.</p><p><strong>Devotional focus:</strong> Lasting change cannot be forced through ridicule or control. We speak truth gently, encourage the next faithful step, and remain willing to repent of the patterns we contribute to a family or community.</p><p><strong>Reflect:</strong> Are you trying to change someone through pressure, or supporting the person's own responsible choices? Adjust your words so they combine truth, patience, and respect.</p><p><strong>Prayer:</strong> Patient Lord, make my words truthful and gentle. Help me encourage growth without controlling others, and show me where I also need to change. Amen.</p>",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "<p><strong>Read:</strong> Philippians 1:6; 2 Corinthians 5:17.</p><p><strong>Story and historical context:</strong> The tale ends as Mark's changing conduct influences the household and his father begins turning away from alcohol. Its rapid resolution reflects the moral-story form and should not imply that addiction or family harm always changes quickly.</p><p><strong>Devotional focus:</strong> New life in Christ may begin in a moment and usually grows through patient truth, support, accountability, and repeated choices. God remains faithful throughout the longer work of restoration.</p><p><strong>Reflect:</strong> Where do you need hope for a change that is still incomplete? Name the next faithful step and seek appropriate pastoral, medical, or community support where it is needed.</p><p><strong>Prayer:</strong> Faithful God, thank you for beginning new life in us. Sustain the long work of healing, guide us to wise support, and complete what reflects Christ. Amen.</p>",
    "day_number": 13
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
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 1,
    "references": [
      "Proverbs 20:11",
      "Philippians 2:4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 2,
    "references": [
      "Colossians 3:23-24",
      "Proverbs 22:3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 3,
    "references": [
      "1 Thessalonians 5:11",
      "Psalm 90:17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 4,
    "references": [
      "James 1:19",
      "1 Corinthians 13:7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 5,
    "references": [
      "Ephesians 4:25",
      "Galatians 6:1"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 6,
    "references": [
      "John 9:4",
      "Ephesians 5:15-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 7,
    "references": [
      "Acts 9:36-39",
      "James 2:15-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 8,
    "references": [
      "John 11:33-36",
      "1 Thessalonians 4:13-14"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 9,
    "references": [
      "Hebrews 10:24",
      "2 Timothy 2:2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 10,
    "references": [
      "Psalm 119:105",
      "Hebrews 4:12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 11,
    "references": [
      "Acts 3:19",
      "Titus 2:11-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 12,
    "references": [
      "1 Thessalonians 5:11",
      "2 Timothy 2:24-25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "day_number": 13,
    "references": [
      "Philippians 1:6",
      "2 Corinthians 5:17"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-25 14:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-25 14:00:00+00', timestamptz '2026-10-25 14:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish the contextualized four-Christian-tales adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-25 14:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000331'::uuid
);
-- END CONSOLIDATED SOURCE: 20261025140000_repair_draft_devotional_plans_wave_10.sql

-- BEGIN CONSOLIDATED SOURCE: 20261025150000_repair_draft_devotional_plans_wave_11.sql sha256=59bff1104006f2891808f8037dda71dd32f352499a851f01c401065beb71e792
-- One 1814 pastoral tract reconstructed as two Scripture-led daily devotions.
-- Daily prayer and access to Scripture are retained; a Pentecost error, sectarian
-- polemic, denominational gatekeeping, and wartime nationalism are omitted.
-- Existing day IDs and day numbers are preserved.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-25 15:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "value": "Prayer and Shared Scripture: Two Readings from an 1814 Pastoral Tract"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-25 15:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "value": "Two Scripture-led readings adapted from Joseph Phillimore's 1814 Anglican pastoral tract. The readings retain its encouragement of daily prayer and access to Scripture while identifying the parish setting and omitting its confusion between Jesus' baptism and Pentecost, anti-dissenter polemic, denominational gatekeeping, and wartime nationalism."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-25 15:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "value": "Begin and End the Day with God",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "value": "Share Scripture Without Favoritism",
    "day_number": 2
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-25 15:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "value": "<p><strong>Read:</strong> Matthew 6:9-13; Philippians 4:6-7.</p><p><strong>Historical context:</strong> Joseph Phillimore addressed two English parishes in an 1814 pastoral tract. He urged households to pray morning and evening, although the complete tract also contains a factual confusion between Jesus' baptism and Pentecost and several claims this adaptation does not repeat.</p><p><strong>Source theme, in contemporary language:</strong> Regular prayer makes room to worship the Father, receive daily provision with gratitude, seek forgiveness, resist temptation, and bring both prosperity and adversity into God's presence through Jesus Christ.</p><p><strong>Reflect:</strong> Which edge of your day most needs an intentional pause with God? Choose a realistic time and place, and let the Lord's Prayer guide both your trust and your responsibilities.</p><p><strong>Prayer:</strong> Our Father, give us daily bread, forgive our sins, and lead us away from temptation. Guard our hearts and minds in Christ Jesus throughout this day. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000218",
    "value": "<p><strong>Read:</strong> James 2:1-5; 2 Timothy 3:14-17.</p><p><strong>Historical context:</strong> Phillimore asked wealthier parishioners to help place Christian books in homes that could not afford them. His proposal assumed Anglican worship, disparaged dissenting Christians, and appealed to British wartime victory; those sectarian and national claims are omitted here.</p><p><strong>Source theme, in contemporary language:</strong> Money and social position should not block a person from learning Scripture or participating in Christian community. Sharing Bibles, teaching, accessible formats, and patient companionship can help neighbors hear and practice God's word.</p><p><strong>Reflect:</strong> What barrier makes Scripture or Christian learning harder for someone near you—cost, language, literacy, disability, technology, or lack of welcome? Ask what would help and support access without controlling the person's conscience.</p><p><strong>Prayer:</strong> Lord Jesus, remove favoritism from your people. Help us share Scripture generously, teach with humility, welcome every neighbor, and honor the conscience of others. Amen.</p>",
    "day_number": 2
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
    "id": "90000000-0000-0000-0000-000000000218",
    "day_number": 2,
    "references": [
      "James 2:1-5",
      "2 Timothy 3:14-17"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-25 15:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-25 15:00:00+00', timestamptz '2026-10-25 15:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish the contextualized 1814 pastoral-tract adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-25 15:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000218'::uuid
);
-- END CONSOLIDATED SOURCE: 20261025150000_repair_draft_devotional_plans_wave_11.sql

-- BEGIN CONSOLIDATED SOURCE: 20261025160000_repair_draft_devotional_plans_wave_12.sql sha256=ba560475391b00d5255f40d6379b1d29efecdbbd027e91e8528bac25ba9f75ea
-- One 1872 children's story reconstructed as eight Scripture-led daily devotions.
-- Disability and class prejudice, romanticized hardship, illness blame, coerced
-- forgiveness, and a dream treated as authority are rejected or corrected.
-- Existing day IDs and day numbers are preserved.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-25 16:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "Compassion, Repair, and Hope: Eight Readings from The One Moss-Rose"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-25 16:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "Eight Scripture-led readings adapted from Philip Bennett Power's 1872 Christian children's story The One Moss-Rose. The sequence retains themes of dignity, contentment, respect, forgiveness, repentance, restitution, and resurrection hope while rejecting outdated disability and class language, romanticized hardship, blame surrounding illness, pressure to forgive without accountability, and the use of a fever dream as doctrinal authority."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-25 16:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "Every Person Bears God's Image",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "Contentment Without Denying Hardship",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "Honor What Another Person Values",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "Name Harm Without Inventing Blame",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "Forgiveness and Accountability Belong Together",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "Let Guilt Lead to Repentance",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "Make Repair Practical",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "Anchor Hope in the Risen Christ",
    "day_number": 8
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-25 16:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "<p><strong>Read:</strong> Genesis 1:27; 1 Corinthians 12:22-26.</p><p><strong>Story and historical context:</strong> Philip Bennett Power's 1872 children's story introduces Jacob Dobbin, a disabled boy in a laborer's family, and James Courtenay, the son of a wealthy landowner. The source uses outdated disability and class language that this adaptation does not repeat.</p><p><strong>Devotional focus:</strong> Human dignity does not depend on health, wealth, productivity, or social rank. Every person bears God's image, and Christ's body honors members whom society may overlook.</p><p><strong>Reflect:</strong> Which person or group is often described mainly by a limitation or social position? Practice speaking about the whole person, listening to their experience, and honoring their gifts.</p><p><strong>Prayer:</strong> Creator God, teach me to recognize your image in every person. Remove condescension and prejudice, and form in me sincere honor and care. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "<p><strong>Read:</strong> Philippians 4:11-13; Romans 12:15.</p><p><strong>Story and historical context:</strong> Jacob treasures a single moss-rose while James has many possessions and remains dissatisfied. The contrast supports the story's lesson about contentment, but poverty, pain, and disability should not be romanticized.</p><p><strong>Devotional focus:</strong> Contentment grows through Christ's strength and grateful attention to God's gifts. It can coexist with grief, advocacy, treatment, and honest efforts to change unjust or painful circumstances.</p><p><strong>Reflect:</strong> What gift can you receive gratefully today, and what hardship still needs truthful lament or practical support? Make room for both without comparing your suffering with someone else's.</p><p><strong>Prayer:</strong> Lord Jesus, teach me contentment rooted in you. Help me give thanks without minimizing pain and stand beside those who need comfort or change. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "<p><strong>Read:</strong> Philippians 2:3-4; Luke 6:31.</p><p><strong>Story and historical context:</strong> James enters the cottage garden and cuts Jacob's only rose despite being asked to stop. The flower is small in monetary value but carries deep meaning for the person who cared for it.</p><p><strong>Devotional focus:</strong> Love does not measure another person's treasure only by our own preferences. Respect listens to a clear boundary and considers the history, labor, memory, or joy attached to what belongs to someone else.</p><p><strong>Reflect:</strong> Have you dismissed something important to another person because it seemed trivial to you? Listen without defending yourself, acknowledge its meaning, and respect the boundary involved.</p><p><strong>Prayer:</strong> God of love, free me from selfish entitlement. Teach me to listen, honor boundaries, and care about what matters to my neighbor. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "<p><strong>Read:</strong> Psalm 34:18; James 3:5-10.</p><p><strong>Story and historical context:</strong> After the rose is taken, Jacob becomes gravely ill and later dies. The moral tale presents a direct dramatic link between the loss and his death; readers should not use that plot device to blame distressed or medically vulnerable people for what happens to their bodies.</p><p><strong>Devotional focus:</strong> Careless actions and words can cause real harm, and suffering people deserve compassion. We can take wrongdoing seriously while speaking responsibly about illness, trauma, and causes we do not fully know.</p><p><strong>Reflect:</strong> Where are you tempted either to minimize harm or to claim more certainty than the facts allow? Name what is known, seek appropriate help, and avoid placing blame on the person who suffered.</p><p><strong>Prayer:</strong> God who is near to the brokenhearted, make my words careful and compassionate. Help me face harm honestly and protect people from false blame. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "<p><strong>Read:</strong> Colossians 3:12-13; Luke 19:8.</p><p><strong>Story and historical context:</strong> Jacob releases resentment toward James, while the adults begin to reckon with what James has done. The story values forgiveness, but forgiveness does not erase consequences or require immediate restored trust.</p><p><strong>Devotional focus:</strong> Christ calls believers away from revenge and toward forgiveness. Repentance still names the wrong, accepts accountability, makes repair where possible, and gives the harmed person freedom to establish safe boundaries.</p><p><strong>Reflect:</strong> Do you need to release revenge, make restitution, or respect a boundary? Identify which responsibility belongs to you instead of demanding that another person resolve the whole situation.</p><p><strong>Prayer:</strong> Merciful Jesus, free me from revenge and lead me in truth. Give me courage to accept consequences, repair harm, and respect wise boundaries. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "<p><strong>Read:</strong> 2 Corinthians 7:10-11; 1 John 1:9.</p><p><strong>Story and historical context:</strong> James becomes physically ill under the weight of fear and guilt. A vivid dream about Jacob contributes to his change, reflecting the devotional storytelling of the period; this adaptation grounds repentance in God's revealed mercy rather than in dreams.</p><p><strong>Devotional focus:</strong> Condemnation traps us in ourselves, while godly sorrow turns toward confession, responsibility, and changed conduct. God is faithful to forgive and cleanse those who come into the light.</p><p><strong>Reflect:</strong> Is guilt leading you to hide, punish yourself, or seek real change? Confess specifically to God, tell the truth to an appropriate person, and choose the next act of repair.</p><p><strong>Prayer:</strong> Faithful God, bring my sin into your light. Forgive me through Christ, free me from self-punishment, and produce earnest repentance in my life. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "<p><strong>Read:</strong> Ephesians 4:28; James 2:14-17.</p><p><strong>Story and historical context:</strong> As James recovers, the story portrays his changed attitude through kindness toward Jacob's father and concern for people whose needs he had ignored. The social hierarchy remains intact in the source, so this reading emphasizes partnership rather than patronage.</p><p><strong>Devotional focus:</strong> Repentance bears practical fruit. Repair may require returning what was taken, replacing a loss, changing how power is used, listening to the harmed person, and supporting what restores dignity.</p><p><strong>Reflect:</strong> What would make your apology concrete? Ask what repair is wanted and possible, then follow through without using generosity to control the other person or purchase quick forgiveness.</p><p><strong>Prayer:</strong> God of justice and mercy, make my repentance visible in faithful action. Teach me to repair harm with humility and without control. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "value": "<p><strong>Read:</strong> John 11:25-26; 1 Peter 1:3-4.</p><p><strong>Story and historical context:</strong> The story closes with images of unfading flowers and confidence about Jacob's life after death. Its dream scene is literary imagination, not a source of Christian doctrine or certainty about an individual's final state.</p><p><strong>Devotional focus:</strong> Christian hope rests on Jesus Christ, crucified and risen, who promises resurrection life. We may remember a person with love while entrusting final judgment to God's justice and mercy.</p><p><strong>Reflect:</strong> What image or memory helps you express hope? Receive its comfort, then return to the gospel foundation: Jesus has risen, and our living hope is held in him.</p><p><strong>Prayer:</strong> Risen Lord Jesus, anchor my hope in your victory over death. Comfort those who grieve and keep our trust in your faithful promise. Amen.</p>",
    "day_number": 8
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
    "id": "90000000-0000-0000-0000-000000000305",
    "day_number": 1,
    "references": [
      "Genesis 1:27",
      "1 Corinthians 12:22-26"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "day_number": 2,
    "references": [
      "Philippians 4:11-13",
      "Romans 12:15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "day_number": 3,
    "references": [
      "Philippians 2:3-4",
      "Luke 6:31"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "day_number": 4,
    "references": [
      "Psalm 34:18",
      "James 3:5-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "day_number": 5,
    "references": [
      "Colossians 3:12-13",
      "Luke 19:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "day_number": 6,
    "references": [
      "2 Corinthians 7:10-11",
      "1 John 1:9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "day_number": 7,
    "references": [
      "Ephesians 4:28",
      "James 2:14-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000305",
    "day_number": 8,
    "references": [
      "John 11:25-26",
      "1 Peter 1:3-4"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-25 16:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-25 16:00:00+00', timestamptz '2026-10-25 16:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish the contextualized Moss-Rose story adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-25 16:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000305'::uuid
);
-- END CONSOLIDATED SOURCE: 20261025160000_repair_draft_devotional_plans_wave_12.sql

-- BEGIN CONSOLIDATED SOURCE: 20261025170000_repair_draft_devotional_plans_wave_13.sql sha256=4ff9f2a3b079cb49750c82d175076aff62c904f9c3e85c3277e3142e49ec0278
-- One 1872 retelling of Joseph reconstructed as eleven Scripture-led devotions.
-- Trafficking, coercion, power, suffering, repentance, and reconciliation receive
-- explicit context; guaranteed prosperity and forced reconciliation are rejected.
-- Existing day IDs and day numbers are preserved.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-25 17:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Providence, Repentance, and Reconciliation: Eleven Readings on Joseph"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-25 17:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Eleven Scripture-led readings adapted from W. K. Tweedie's 1872 retelling of Joseph's story in Genesis. The sequence addresses envy, trafficking, coercion, unjust imprisonment, wisdom, stewardship, power, repentance, reconciliation, reunion, leadership, grief, and providence while avoiding guaranteed-prosperity claims, simplistic explanations of suffering, forced reconciliation, and the use of morally complex narrative actions as universal commands."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-25 17:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Interrupt the Cycle of Envy",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Do Not Profit from Another's Harm",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Faithfulness When Justice Fails",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Receive Wisdom as a Gift",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Prepare in Seasons of Plenty",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Power Can Serve Truth and Mercy",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Repentance Bears Costly Fruit",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Reconciliation Makes Room for Tears",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Receive the Gift of Reunion",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Bless Across Lines of Status",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Trust Providence Without Calling Evil Good",
    "day_number": 11
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-25 17:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "<p><strong>Read:</strong> Genesis 37:3-11; James 3:14-18.</p><p><strong>Source and biblical context:</strong> W. K. Tweedie's 1872 retelling begins with Jacob's favoritism, Joseph's dreams, and his brothers' growing hatred. Genesis shows a family system in which partiality, pride, and envy feed one another.</p><p><strong>Devotional focus:</strong> Envy distorts another person's good into a threat and can turn hurt into cruelty. God's wisdom leads toward honesty, peace, mercy, and responsibility instead of rivalry.</p><p><strong>Reflect:</strong> What comparison is feeding resentment in you? Name the deeper hurt or desire, refuse contempt, and choose one action shaped by peace rather than competition.</p><p><strong>Prayer:</strong> God of wisdom, expose envy and pride in me. Heal what fuels rivalry and teach me to seek peace, truth, and another person's good. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "<p><strong>Read:</strong> Genesis 37:18-28; Proverbs 31:8-9.</p><p><strong>Source and biblical context:</strong> Joseph's brothers throw him into a pit and sell him to traders. Tweedie rightly names their cruelty, while contemporary readers should also name the event as trafficking and the use of profit to disguise violence.</p><p><strong>Devotional focus:</strong> Changing the form of harm does not make it righteous. Love speaks for people in danger, refuses profit built on exploitation, and interrupts group decisions that sacrifice a vulnerable person.</p><p><strong>Reflect:</strong> Where might convenience, silence, or financial benefit connect you to another person's exploitation? Learn the facts and take one responsible step toward protection or fair treatment.</p><p><strong>Prayer:</strong> God of justice, make me courageous when others are endangered. Keep me from benefiting through silence and teach me to defend human dignity. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "<p><strong>Read:</strong> Genesis 39:7-23; Psalm 10:14.</p><p><strong>Source and biblical context:</strong> Joseph resists sexual coercion, is falsely accused, and is imprisoned. The historical commentary emphasizes his later advancement; this reading first acknowledges the injustice and the reality that faithful people are not always vindicated quickly.</p><p><strong>Devotional focus:</strong> God sees people harmed by coercion, lies, and unjust systems. Faithfulness may include resisting wrongdoing, seeking safety, telling the truth, supporting survivors, and enduring without pretending that injustice is good.</p><p><strong>Reflect:</strong> How can you make a relationship, church, or workplace safer for someone reporting coercion or false accusation? Listen carefully and connect the person with appropriate support.</p><p><strong>Prayer:</strong> God who sees the afflicted, protect people facing coercion and injustice. Give us courage to believe truth, pursue safety, and remain faithful. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "<p><strong>Read:</strong> Genesis 41:14-16; James 1:5.</p><p><strong>Source and biblical context:</strong> When Pharaoh asks Joseph to interpret troubling dreams, Joseph says that the answer does not originate in himself. He then combines discernment with practical counsel for the coming famine.</p><p><strong>Devotional focus:</strong> Wisdom is received with humility and used for service. We acknowledge God, examine reality carefully, and translate insight into plans that protect people rather than build our reputation.</p><p><strong>Reflect:</strong> Where are people looking to you for an answer? Admit what you do not know, ask God for wisdom, consult others, and turn sound insight into a practical next step.</p><p><strong>Prayer:</strong> Wise God, give generously as I seek understanding. Keep me humble, attentive, and ready to use insight for the good of others. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "<p><strong>Read:</strong> Genesis 41:33-40; Proverbs 21:5.</p><p><strong>Source and biblical context:</strong> Joseph is entrusted with preparing Egypt for famine. Tweedie presents advancement as providential reward, but Scripture does not promise that diligence always brings position or prosperity.</p><p><strong>Devotional focus:</strong> Responsible leadership plans ahead, stewards abundance, and protects people against foreseeable hardship. Faithfulness is measured by love and integrity, whether or not it receives promotion.</p><p><strong>Reflect:</strong> What future need can you prepare for while resources are available? Make a plan that includes people who are most exposed when scarcity comes.</p><p><strong>Prayer:</strong> Provider God, teach me wise stewardship in times of abundance. Make my planning just, generous, and attentive to vulnerable neighbors. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "<p><strong>Read:</strong> Genesis 42:6-17; Micah 6:8.</p><p><strong>Source and biblical context:</strong> Joseph's brothers arrive seeking food, and he accuses them of spying while concealing his identity. The narrative begins a process that exposes their past, but Joseph's use of power is complex and should not become a simple model for testing people.</p><p><strong>Devotional focus:</strong> Authority must serve justice, mercy, and truth without manipulation or revenge. People with power should use clear processes, proportionate boundaries, and accountable decisions.</p><p><strong>Reflect:</strong> Where do you hold information or authority another person lacks? Choose transparency and accountability, and avoid creating fear merely to test loyalty or control the outcome.</p><p><strong>Prayer:</strong> Just and merciful God, purify my use of power. Lead me in transparent, accountable decisions that protect truth and human dignity. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "<p><strong>Read:</strong> Genesis 44:18-34; 2 Corinthians 7:10-11.</p><p><strong>Source and biblical context:</strong> After a cup is hidden in Benjamin's sack, Judah offers himself in Benjamin's place rather than return home without him. Joseph's test remains ethically difficult, yet Judah's response reveals a striking change from the brother who once helped sell Joseph.</p><p><strong>Devotional focus:</strong> Repentance becomes visible when a person accepts cost to protect someone previously endangered by the same pattern. Changed words matter, and changed action confirms them.</p><p><strong>Reflect:</strong> What present choice would demonstrate change from a past pattern? Consider the cost of protecting another person, keeping your promise, or accepting responsibility yourself.</p><p><strong>Prayer:</strong> Merciful God, produce earnest repentance in me. Give me courage to protect others, accept responsibility, and live differently from my former ways. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "<p><strong>Read:</strong> Genesis 45:1-15; Romans 12:18.</p><p><strong>Source and biblical context:</strong> Joseph reveals his identity, weeps, and embraces Benjamin and his other brothers. His words about God's providence do not call their betrayal good or remove their responsibility.</p><p><strong>Devotional focus:</strong> Reconciliation can hold grief, truth, mercy, and hope together. It should not be forced, and restored relationship may require confession, safety, time, and trustworthy change.</p><p><strong>Reflect:</strong> Are you rushing reconciliation or avoiding a truthful step toward peace? Identify what belongs to you—lament, confession, a boundary, restitution, or a patient invitation.</p><p><strong>Prayer:</strong> God of reconciliation, receive our tears and lead us in truth. Give us mercy without denial, peace without coercion, and wisdom about trust. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "<p><strong>Read:</strong> Genesis 46:28-30; Psalm 126:1-3.</p><p><strong>Source and biblical context:</strong> Jacob travels to Egypt and is reunited with the son he had believed dead. The meeting does not erase the lost years, but it brings an unexpected joy after prolonged grief.</p><p><strong>Devotional focus:</strong> Restoration is a gift, not a repayment that makes every loss disappear. We can receive joy fully while honoring the grief and complexity that came before it.</p><p><strong>Reflect:</strong> What restored relationship, opportunity, or hope can you receive with gratitude? Celebrate it without demanding that anyone deny the pain of the past.</p><p><strong>Prayer:</strong> God who restores, thank you for joys we did not expect. Help us celebrate your gifts while treating old grief with tenderness and truth. Amen.</p>",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "<p><strong>Read:</strong> Genesis 47:7-12; 1 Timothy 2:1-2.</p><p><strong>Source and biblical context:</strong> Joseph presents Jacob to Pharaoh, and the aging migrant blesses the ruler. The scene crosses differences of age, nationality, wealth, and political power without making spiritual dignity depend on rank.</p><p><strong>Devotional focus:</strong> God's people can seek the good of rulers and strangers while remaining truthful about power. Blessing is neither flattery nor domination; it asks for life, justice, and peace under God's authority.</p><p><strong>Reflect:</strong> How can you pray and act for the good of people across a line of status or culture? Refuse both contempt and uncritical praise, and seek a just peace.</p><p><strong>Prayer:</strong> Sovereign God, guide leaders and protect those affected by their decisions. Make me truthful, hospitable, and committed to justice and peace. Amen.</p>",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "<p><strong>Read:</strong> Genesis 50:15-21; Romans 8:28.</p><p><strong>Source and biblical context:</strong> After Jacob's death, Joseph grieves and again assures his brothers that God brought life out of what they intended for evil. Tweedie's conclusion strongly emphasizes providence; this reading preserves the distinction Joseph makes between human evil and God's redeeming purpose.</p><p><strong>Devotional focus:</strong> God can bring saving good from actions he does not approve. Providence does not excuse abuse, silence lament, or remove accountability; it gives hope that evil will not have the final word.</p><p><strong>Reflect:</strong> Where do you need hope without a false explanation for suffering? Name the evil honestly, pursue what is just, and entrust the unfinished story to God's redeeming care.</p><p><strong>Prayer:</strong> Redeeming God, do not let evil have the final word. Hold us in grief, lead us in justice, and bring life through your faithful purposes. Amen.</p>",
    "day_number": 11
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
    "id": "90000000-0000-0000-0000-000000000302",
    "day_number": 1,
    "references": [
      "Genesis 37:3-11",
      "James 3:14-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "day_number": 2,
    "references": [
      "Genesis 37:18-28",
      "Proverbs 31:8-9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "day_number": 3,
    "references": [
      "Genesis 39:7-23",
      "Psalm 10:14"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "day_number": 4,
    "references": [
      "Genesis 41:14-16",
      "James 1:5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "day_number": 5,
    "references": [
      "Genesis 41:33-40",
      "Proverbs 21:5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "day_number": 6,
    "references": [
      "Genesis 42:6-17",
      "Micah 6:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "day_number": 7,
    "references": [
      "Genesis 44:18-34",
      "2 Corinthians 7:10-11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "day_number": 8,
    "references": [
      "Genesis 45:1-15",
      "Romans 12:18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "day_number": 9,
    "references": [
      "Genesis 46:28-30",
      "Psalm 126:1-3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "day_number": 10,
    "references": [
      "Genesis 47:7-12",
      "1 Timothy 2:1-2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "day_number": 11,
    "references": [
      "Genesis 50:15-21",
      "Romans 8:28"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-25 17:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-25 17:00:00+00', timestamptz '2026-10-25 17:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish the contextualized Joseph-story adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-25 17:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000302'::uuid
);
-- END CONSOLIDATED SOURCE: 20261025170000_repair_draft_devotional_plans_wave_13.sql

-- BEGIN CONSOLIDATED SOURCE: 20261025180000_repair_draft_devotional_plans_wave_14.sql sha256=9767c7ecef66d944b7219e627cb8164e1627249c80bbe9b6568b52c08e8d6ee8
-- One 1865 Anglican baptism tract reconstructed as seven Scripture-led devotions.
-- The denominational setting and continuing Christian disagreements are explicit;
-- shared teaching about Christ, grace, repentance, new life, and unity remains central.
-- Existing day IDs and day numbers are preserved.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-25 18:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000388",
    "value": "One Lord, One Faith, One Baptism: Seven Readings"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-25 18:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000388",
    "value": "Seven Scripture-led readings adapted from Edward Hoare's 1865 Anglican tract on baptism. The plan centers on union with the crucified and risen Christ, the Holy Spirit, repentance, grace, new life, Christian formation, and unity while clearly labeling Hoare's denominational setting and leaving disputed questions about baptismal subjects, timing, and sacramental effect open to the reader's church tradition."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-25 18:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000388",
    "value": "Baptized into Christ",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000388",
    "value": "One Spirit, One Body",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000388",
    "value": "An Appeal to God",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000388",
    "value": "Walk in Newness of Life",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000388",
    "value": "Grace Is God's Gift",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000388",
    "value": "Welcome and Teach with Care",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000388",
    "value": "Remember the Shared Confession",
    "day_number": 7
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-25 18:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000388",
    "value": "<p><strong>Read:</strong> Romans 6:3-5; Galatians 3:26-28.</p><p><strong>Source and tradition context:</strong> Edward Hoare's 1865 Anglican tract joins baptism with union with Jesus Christ. Christians differ about how baptism relates to faith and grace, while the historic Nicene confession speaks of one baptism for the forgiveness of sins.</p><p><strong>Devotional focus:</strong> Baptism directs attention to Jesus Christ, who died and rose for us. It calls the church to receive its identity from him and to resist divisions built on status, ethnicity, or power.</p><p><strong>Reflect:</strong> What identity or rivalry competes with your belonging to Christ? Remember that Christian life begins and continues by grace, and practice fellowship across one dividing line today.</p><p><strong>Prayer:</strong> Lord Jesus Christ, join your people more deeply to your death and resurrection. Free us from pride and teach us to live as one in you. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000388",
    "value": "<p><strong>Read:</strong> 1 Corinthians 12:12-13; Ephesians 4:1-6.</p><p><strong>Source and tradition context:</strong> Hoare reads Paul's baptism language as a sign of the Holy Spirit's work of joining believers to Christ's body. His tract argues one Anglican position within a larger Christian conversation.</p><p><strong>Devotional focus:</strong> The Spirit gathers many members into one body under one Lord. Unity does not erase difference; it forms patience, humility, and mutual care around the confession of Jesus Christ.</p><p><strong>Reflect:</strong> Whose gifts or presence have you treated as less valuable? Choose one concrete way to honor another member of Christ's body and protect the bond of peace.</p><p><strong>Prayer:</strong> Holy Spirit, make us one body in Christ. Correct our contempt, deepen our patience, and teach us to receive one another with love. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000388",
    "value": "<p><strong>Read:</strong> 1 Peter 3:18-22; Acts 2:37-39.</p><p><strong>Source and tradition context:</strong> The source argues that an outward sacrament must not be separated from inward grace, repentance, and faith. Christian traditions explain that relationship differently, so this reading leaves the disputed mechanism open.</p><p><strong>Devotional focus:</strong> Peter connects baptism with Christ's resurrection and an appeal to God for a good conscience. The sign points beyond itself to God's saving action and summons a truthful response to grace.</p><p><strong>Reflect:</strong> Where is God calling you from outward observance toward honest repentance and trust? Name one step that brings your public profession and private life into greater agreement.</p><p><strong>Prayer:</strong> Risen Christ, cleanse our consciences and turn us toward you. Let every sign of faith lead to repentance, trust, and a life shaped by your grace. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000388",
    "value": "<p><strong>Read:</strong> Romans 6:4-11; Colossians 3:1-14.</p><p><strong>Source and tradition context:</strong> Hoare repeatedly links baptism with a changed life. His argument addresses debates about regeneration, but Paul's pastoral summons is clear: those who belong to Christ are called to put away sin and put on love.</p><p><strong>Devotional focus:</strong> New life is not a claim of moral superiority. It is daily dependence on the crucified and risen Christ, expressed through truth, mercy, patience, forgiveness, and love.</p><p><strong>Reflect:</strong> What old pattern needs to be put away, and what Christlike practice belongs in its place? Choose a specific replacement rather than a vague intention.</p><p><strong>Prayer:</strong> God of new life, unite me with the risen Christ. Put to death what harms my neighbor and clothe me with compassion, humility, patience, and love. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000388",
    "value": "<p><strong>Read:</strong> Ephesians 2:4-10; Titus 3:4-7.</p><p><strong>Source and tradition context:</strong> The tract distinguishes the outward sign from the inward gift and warns against treating grace as automatic. Other Christian traditions describe sacramental grace differently; this devotion stays with the shared truth that salvation comes from God through Jesus Christ.</p><p><strong>Devotional focus:</strong> No ceremony, achievement, or correct explanation gives us control over God. We receive mercy as a gift and are created in Christ for the good works God prepares for us.</p><p><strong>Reflect:</strong> Are you relying on religious credentials, or dismissing another Christian over a disputed explanation? Return to God's mercy and let gratitude produce a good work today.</p><p><strong>Prayer:</strong> Merciful Father, save us by your grace through Jesus Christ. Deliver us from presumption and contempt, and make our lives fruitful in love. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000388",
    "value": "<p><strong>Read:</strong> Matthew 28:18-20; Acts 8:26-38.</p><p><strong>Source and tradition context:</strong> Hoare discusses infant and adult baptism through the Church of England's services. Churches continue to differ about baptismal candidates and timing, but Jesus' commission holds baptism and lifelong teaching together.</p><p><strong>Devotional focus:</strong> The church welcomes people in Christ's name and teaches them to follow all he commanded. Care surrounding baptism should protect conscience, tell the truth, include patient formation, and avoid pressure or false assurance.</p><p><strong>Reflect:</strong> How can your community accompany children, families, or new believers more faithfully? Identify one practice of clear teaching, patient listening, or continuing care.</p><p><strong>Prayer:</strong> Teacher and Savior, make your church truthful and gentle as we welcome others. Help us baptize, teach, and accompany people with faithful love. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000388",
    "value": "<p><strong>Read:</strong> Ephesians 4:4-6; 1 Corinthians 1:10-13.</p><p><strong>Source and tradition context:</strong> The source tries to resolve a nineteenth-century Anglican dispute by comparing the Bible and Prayer Book. Its denominational conclusion should be read as Hoare's position, not as the only Christian account of baptism.</p><p><strong>Devotional focus:</strong> Christians may discuss baptism seriously without turning one another into enemies. One Lord, one faith, and one baptism call us to speak truth with humility and to keep Jesus Christ at the center.</p><p><strong>Reflect:</strong> How do you respond when another Christian understands baptism differently? State your conviction honestly, listen for what is shared, and refuse ridicule, suspicion, or coercion.</p><p><strong>Prayer:</strong> Triune God, guard your church in truth and love. Give us humility in disagreement and unite us in the confession of Jesus Christ, crucified and risen. Amen.</p>",
    "day_number": 7
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
    "id": "90000000-0000-0000-0000-000000000388",
    "day_number": 1,
    "references": [
      "Romans 6:3-5",
      "Galatians 3:26-28"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000388",
    "day_number": 2,
    "references": [
      "1 Corinthians 12:12-13",
      "Ephesians 4:1-6"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000388",
    "day_number": 3,
    "references": [
      "1 Peter 3:18-22",
      "Acts 2:37-39"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000388",
    "day_number": 4,
    "references": [
      "Romans 6:4-11",
      "Colossians 3:1-14"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000388",
    "day_number": 5,
    "references": [
      "Ephesians 2:4-10",
      "Titus 3:4-7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000388",
    "day_number": 6,
    "references": [
      "Matthew 28:18-20",
      "Acts 8:26-38"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000388",
    "day_number": 7,
    "references": [
      "Ephesians 4:4-6",
      "1 Corinthians 1:10-13"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-25 18:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-25 18:00:00+00', timestamptz '2026-10-25 18:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish the ecumenically framed baptism adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-25 18:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000388'::uuid
);
-- END CONSOLIDATED SOURCE: 20261025180000_repair_draft_devotional_plans_wave_14.sql

-- BEGIN CONSOLIDATED SOURCE: 20261025190000_repair_draft_devotional_plans_wave_15.sql sha256=8418559c43633700829f4676f858273807943bc52c8704a81358f1b022cae7e9
-- Twenty-seven devotional readings newly authored from themes in A. W. Tozer's The Pursuit of God.
-- The source-based editorial paraphrases are attributed and are not verbatim quotations.
-- Existing day IDs, day numbers, total_days, and source URL remain unchanged.
-- Publication is authorized after source, editorial, and distribution review.

begin;

-- Check the existing 27-day sequence before changing any records.
do $$
declare
  present_days integer;
  first_day integer;
  last_day integer;
  source_link text;
  reported_total integer;
begin
  select source_url, total_days into source_link, reported_total
  from public.devotional_plans where id = '90000000-0000-0000-0000-000000000248'::uuid;
  if not found then
    raise exception 'Plan 248 is missing';
  end if;
  if source_link is distinct from 'https://www.gutenberg.org/ebooks/25141' or reported_total <> 27 then
    raise exception 'Plan 248 source URL or total_days differs from the reviewed seed';
  end if;
  select count(*), min(day_number), max(day_number)
  into present_days, first_day, last_day
  from public.devotional_days where plan_id = '90000000-0000-0000-0000-000000000248'::uuid;
  if present_days <> 27 or first_day <> 1 or last_day <> 27 then
    raise exception 'Plan 248 must have exactly 27 numbered days (found %)', present_days;
  end if;
end
$$;

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-25 19:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Seeking God: 27 Devotional Readings Inspired by A. W. Tozer"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-25 19:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Twenty-seven contemporary devotional reflections inspired by themes in A. W. Tozer’s The Pursuit of God (1948). Each reading includes a Scripture focus, a labeled source-based editorial paraphrase, an original reflection, and an original prayer. These are newly written adaptations, not quotations from Tozer. The linked book remains available for reading in full."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-25 19:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "A Heart That Seeks God",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "God Takes the First Step",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Blessed Are the Poor in Spirit",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "The Cross and the Clinging Self",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Trust When the Future Is Unclear",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Receiving Without Possessing",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Created for Communion",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Welcome into God’s Presence",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "An Undivided Heart",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Lay Aside What Separates",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Faith Beyond What We See",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Attend to the Unseen",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "God Is Present Here",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Drawing Near in Relationship",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Recovering the Practice of Listening",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "The God Who Speaks",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Listen with Discernment",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Look to Christ and Live",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Faith Fixes Its Gaze",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Knowing God, Not Only Knowing About Him",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "A Godward Life",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Choosing Whose Approval Matters",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "The Freedom of Meekness",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Rest for the Burdened",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "The Courage to Be Genuine",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "Everyday Work as Worship",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "All of Life Before God",
    "day_number": 27
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-25 19:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Hosea 6:3. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer begins with the conviction that knowing correct ideas about God is not the same as enjoying communion with God. He invites spiritually hungry people to seek God himself.</p><p><strong>Reflect:</strong> Knowledge matters, but information is not the destination of faith. Think about the difference between describing a friendship and actually spending time with a friend. Give God your honest attention today, even if your prayer feels ordinary.</p><p><strong>Prayer:</strong> Lord, awaken a sincere desire to know you. Let what I learn become trust, worship, and love. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Psalm 63:8. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer describes the human longing for God as a response to grace already at work. The soul follows because God has first drawn near.</p><p><strong>Reflect:</strong> Seeking God is not a contest in which we earn his interest. Grace frees us to approach him without pretending that our efforts are impressive. Where have you noticed invitations to return to prayer, Scripture, or love?</p><p><strong>Prayer:</strong> Gracious God, thank you for seeking me before I knew how to seek you. Help me respond with trust and attention. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Matthew 5:3. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Reflecting on Jesus’ beatitude, Tozer argues that a possessive heart can cling to things so tightly that it struggles to receive the kingdom freely.</p><p><strong>Reflect:</strong> Spiritual poverty is not a command to neglect real needs or romanticize material hardship. It is a posture that refuses to make possessions, status, or self-sufficiency the foundation of identity. Name one attachment you can hold more lightly.</p><p><strong>Prayer:</strong> Father, free my heart from the need to own or control everything. Teach me to receive your gifts with gratitude. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Luke 9:23. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer turns from the desire for God to the struggle with self-centeredness. He connects the surrender of self-rule to Jesus’ call to take up the cross.</p><p><strong>Reflect:</strong> Following Jesus can require costly honesty about motives, pride, and control. It does not mean accepting abuse or losing the dignity God gives you. Today, consider one choice where love can take priority over the urge to be right.</p><p><strong>Prayer:</strong> Jesus, expose selfish patterns without crushing my hope. Give me courage to choose your way of humble love. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Genesis 22:1–14. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer uses Abraham and Isaac to consider the painful distinction between receiving a beloved gift and trying to possess it absolutely.</p><p><strong>Reflect:</strong> This difficult biblical narrative must not be used to justify harm to children or obedience to dangerous demands. The Christian lesson here is to bring fear and attachment before God while remembering that God provides. Entrust a worry to him without abandoning responsible care.</p><p><strong>Prayer:</strong> God of mercy, help me trust you while protecting those entrusted to my care. Guide my choices with wisdom and compassion. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read James 1:17. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: After reflecting on Abraham, Tozer emphasizes that surrendered trust does not make ordinary good gifts worthless. It changes how they are held.</p><p><strong>Reflect:</strong> You can cherish family, work, and resources without letting them define your worth. Gratitude notices their goodness; trust remembers that none can carry the weight of being God. Thank him for one gift and consider how to steward it well.</p><p><strong>Prayer:</strong> Generous Father, keep me grateful without becoming possessive. Help me use your gifts for love and service. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Psalm 42:1–2. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer describes humanity as made for God and restless when religious knowledge is separated from fellowship with him.</p><p><strong>Reflect:</strong> The longing for meaning may become especially vivid in success, loneliness, or disappointment. You do not need to manufacture an intense emotion to pray. Begin by naming your actual desire, however faint, and bringing it before God.</p><p><strong>Prayer:</strong> Living God, meet me in my restlessness. Turn my questions and longings toward your faithful presence. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Hebrews 10:19–22. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer moves from the image of the temple veil to the promise of access to God through Jesus Christ. He draws on historic Christian confession in describing the triune God.</p><p><strong>Reflect:</strong> Christian confidence in prayer is grounded in Christ, not in achieving a particular spiritual feeling. Approach God with reverence and freedom. The invitation is to draw near with a sincere heart, not to measure yourself against someone else’s experience.</p><p><strong>Prayer:</strong> Lord Jesus, thank you for opening the way to the Father. Teach me to come near in faith and humility. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Psalm 34:8. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer reflects on worship that engages the whole person and on the difference between merely discussing God and actually responding to him.</p><p><strong>Reflect:</strong> Worship may include joy, silence, grief, or awe. No single emotional expression proves stronger faith. Set aside a few moments to praise God for a concrete kindness you have received or witnessed.</p><p><strong>Prayer:</strong> Holy Spirit, draw my thoughts and affections toward the goodness of God. Make my worship sincere. Amen.</p>",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Hebrews 12:1–2. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Using the image of a veil within the human heart, Tozer identifies habits of self-protection and pride that obstruct attention to God.</p><p><strong>Reflect:</strong> Growth often means releasing resentment, performance, or an insistence on control. This is not a call to erase healthy boundaries; it is an invitation to let God examine what keeps us from loving well. Ask what you need to confess, repair, or release.</p><p><strong>Prayer:</strong> Merciful God, show me what hinders love. Give me courage to repent and receive your forgiveness. Amen.</p>",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read John 14:21–23. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer argues that faith involves living awareness of God, not only agreement with statements about him. He connects this awareness with love and obedience.</p><p><strong>Reflect:</strong> Feelings of closeness can fluctuate, but faithfulness is not measured by constant spiritual sensation. Love of Christ becomes visible in everyday obedience: truthfulness, patience, justice, and mercy. Choose one small act that reflects his teaching.</p><p><strong>Prayer:</strong> Christ, form in me a faithful love that continues even when my feelings change. Amen.</p>",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read 2 Corinthians 4:18. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer contrasts the force of what the senses constantly report with the reality of God, whom faith learns to trust.</p><p><strong>Reflect:</strong> The visible world is real and good; faith does not require denying evidence or daily responsibilities. Instead, Scripture invites us to see more than what appears immediately urgent. Take a moment to assess a worry in the light of God’s enduring promises.</p><p><strong>Prayer:</strong> God of truth, teach me to face the world clearly and to trust what you have promised beyond my sight. Amen.</p>",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Psalm 139:7–10. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer presents divine presence as more than a doctrine about the universe: God is not absent from the places in which his creatures live and act.</p><p><strong>Reflect:</strong> God’s nearness is not limited to sanctuaries or emotionally powerful moments. Even routine work can become a place of gratitude, conscience, and prayer. Pause during one ordinary task today to remember that you are not beyond God’s care.</p><p><strong>Prayer:</strong> Ever-present Lord, help me recognize your care in ordinary places and respond with reverent love. Amen.</p>",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read James 4:8. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer explains that spiritual distance is not measured in miles. Scripture’s language of nearness points to attention, trust, repentance, and relationship.</p><p><strong>Reflect:</strong> Two people can share a room while remaining emotionally distant; relationships require honest engagement. In prayer, you need not hide doubts or failures. Draw near to God with sincerity, and take a concrete step toward reconciliation where it is appropriate and safe.</p><p><strong>Prayer:</strong> Father, teach me to seek you with an open heart. Lead me into truth, repentance, and renewed trust. Amen.</p>",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read John 1:1–5. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer criticizes religious busyness that neglects attentive worship and introduces the theme of God’s living Word.</p><p><strong>Reflect:</strong> Activity can serve God, but activity alone cannot replace listening. Before beginning the next task, read a few verses slowly and ask what they reveal about Christ. Resist treating quiet as a test you must pass.</p><p><strong>Prayer:</strong> Living Word, interrupt my distracted habits. Help me listen carefully and act on what is true. Amen.</p>",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Hebrews 1:1–2. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer emphasizes that God is not a distant author who delivered a message and withdrew. God’s revelation calls for an ongoing response from those who hear it.</p><p><strong>Reflect:</strong> Christians discern God’s guidance through Scripture, prayer, wisdom, and accountable community. Not every spontaneous thought is God’s voice. Receive Scripture with humility, and test your conclusions rather than mistaking certainty for faith.</p><p><strong>Prayer:</strong> God who has spoken through your Son, shape my judgment by your truth and lead me in wisdom. Amen.</p>",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read John 10:27. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer reflects on a divine call that can be overlooked amid noise and preoccupation, and turns toward the discipline of faith.</p><p><strong>Reflect:</strong> Cultivate attention without assuming every beautiful impulse is a divine message. Read Jesus’ words in context, ask wise questions, and notice where love and truth lead. Silence can create space for discernment, but it is not an achievement in itself.</p><p><strong>Prayer:</strong> Good Shepherd, help me recognize what accords with your teaching and follow faithfully. Amen.</p>",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read John 3:14–15. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer links the lifted serpent in Numbers with Jesus’ explanation that the Son of Man would be lifted up. The biblical image becomes an invitation to trust Christ.</p><p><strong>Reflect:</strong> Saving faith is not sustained by obsessively measuring your spiritual progress. Its center is Jesus Christ, crucified and risen. When anxiety turns your attention inward, return to the promises of the gospel and ask for help to trust them.</p><p><strong>Prayer:</strong> Jesus, turn my anxious gaze from myself toward your mercy and saving love. Amen.</p>",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Hebrews 12:2. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer develops the biblical image of looking as a way to describe steady reliance on Christ rather than constant self-inspection.</p><p><strong>Reflect:</strong> Attention shapes what we love. Looking to Jesus means remembering his character and following his teaching, not ignoring circumstances or practical responsibilities. Let one Gospel scene guide your response to a challenge today.</p><p><strong>Prayer:</strong> Lord Jesus, steady my attention on you. Form my actions by your compassion and truth. Amen.</p>",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read John 17:3. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer describes eternal life as knowing God and Jesus Christ, while challenging a faith reduced to ideas or institutional habit.</p><p><strong>Reflect:</strong> Sound teaching and lived communion belong together. Personal experience needs Scripture and the church’s wisdom, while doctrine should lead toward worship and love. Consider one belief you can embody in a concrete act of kindness.</p><p><strong>Prayer:</strong> Father, deepen my knowledge of you through your Son. Let truth become love in action. Amen.</p>",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Psalm 57:5. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer considers what happens when attention to God becomes a settled habit rather than an occasional religious exercise.</p><p><strong>Reflect:</strong> Habits grow through repetition more than dramatic resolutions. Brief prayer before work, gratitude at meals, and examination at day’s end can help orient the heart. Begin with one sustainable practice rather than promising a perfect routine.</p><p><strong>Prayer:</strong> Triune God, become the center of my ordinary days. Help me return to you whenever my attention wanders. Amen.</p>",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Galatians 1:10. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer questions the social pressure to prize public admiration above faithfulness to God.</p><p><strong>Reflect:</strong> Approval is not always wrong: wise correction and community support matter. The danger comes when praise controls our conscience. Before making a decision, ask whether it is truthful and loving even if nobody applauds.</p><p><strong>Prayer:</strong> Lord, free me from living for applause. Make me teachable, courageous, and faithful when choices are difficult. Amen.</p>",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Matthew 5:5. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer turns to Jesus’ blessing on the meek and treats humility as liberation from the constant need to defend one’s importance.</p><p><strong>Reflect:</strong> Meekness is not weakness or permission for others to mistreat you. It is strength that does not need to dominate. Practice responding to disagreement with clarity and calm, while keeping healthy boundaries.</p><p><strong>Prayer:</strong> Gentle Savior, teach me the strength of humility. Make me firm in truth and generous toward others. Amen.</p>",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Matthew 11:28–30. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer connects Christ’s invitation to rest with the exhausting burdens of pride, comparison, and self-importance.</p><p><strong>Reflect:</strong> Jesus does not ask us to deny real pain or avoid necessary work. His invitation gives weary people a different way to carry life’s responsibilities. Name one burden, share it in prayer, and seek trustworthy practical help where needed.</p><p><strong>Prayer:</strong> Jesus, receive what has become too heavy for me. Teach me to walk in your gentleness and find rest. Amen.</p>",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Matthew 6:1–6. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer describes the burden of artificiality: the exhausting attempt to appear spiritually impressive to others.</p><p><strong>Reflect:</strong> We do not have to curate a flawless religious image. Integrity brings private life and public life into closer agreement. Instead of performing holiness, practice one unnoticed act of faithfulness today.</p><p><strong>Prayer:</strong> Father who sees in secret, replace pretence with honesty. Teach me to serve without needing attention. Amen.</p>",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read 1 Corinthians 10:31. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer argues that the distinction between supposedly sacred activities and everyday work can obscure the possibility of honoring God in ordinary duties.</p><p><strong>Reflect:</strong> Preparing food, writing code, repairing a tool, studying, or caring for someone can express love and integrity. Not every task is automatically good; the way we do it matters. Ask whom your work serves and how to do it conscientiously.</p><p><strong>Prayer:</strong> Lord, receive the work of my hands today. Help me act with skill, honesty, and care for others. Amen.</p>",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "value": "<p><strong>Scripture focus:</strong> Read Colossians 3:17. Let the passage guide your prayer today.</p><p><strong>Source-based editorial paraphrase:</strong> In The Pursuit of God, A. W. Tozer develops this theme: Tozer closes by challenging the idea that only certain places, jobs, or moments belong to God. He invites the believer to live every part of life in conscious dedication to him.</p><p><strong>Reflect:</strong> Places of worship have a special communal purpose, but God is not confined to them. Carry prayer into rest, relationships, service, and responsible decision-making. End this plan by naming one practice you will continue after day twenty-seven.</p><p><strong>Prayer:</strong> God of all life, teach me to honor you in every place. May my worship become patience, gratitude, justice, and love. Through Jesus Christ, amen.</p>",
    "day_number": 27
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
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 1,
    "references": [
      "Hosea 6:3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 2,
    "references": [
      "Psalm 63:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 3,
    "references": [
      "Matthew 5:3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 4,
    "references": [
      "Luke 9:23"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 5,
    "references": [
      "Genesis 22:1–14"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 6,
    "references": [
      "James 1:17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 7,
    "references": [
      "Psalm 42:1–2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 8,
    "references": [
      "Hebrews 10:19–22"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 9,
    "references": [
      "Psalm 34:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 10,
    "references": [
      "Hebrews 12:1–2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 11,
    "references": [
      "John 14:21–23"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 12,
    "references": [
      "2 Corinthians 4:18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 13,
    "references": [
      "Psalm 139:7–10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 14,
    "references": [
      "James 4:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 15,
    "references": [
      "John 1:1–5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 16,
    "references": [
      "Hebrews 1:1–2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 17,
    "references": [
      "John 10:27"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 18,
    "references": [
      "John 3:14–15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 19,
    "references": [
      "Hebrews 12:2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 20,
    "references": [
      "John 17:3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 21,
    "references": [
      "Psalm 57:5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 22,
    "references": [
      "Galatians 1:10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 23,
    "references": [
      "Matthew 5:5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 24,
    "references": [
      "Matthew 11:28–30"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 25,
    "references": [
      "Matthew 6:1–6"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 26,
    "references": [
      "1 Corinthians 10:31"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000248",
    "day_number": 27,
    "references": [
      "Colossians 3:17"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-25 19:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-25 19:00:00+00', timestamptz '2026-10-25 19:00:00+00');
    end if;
  end loop;
end
$$;

-- Publish the reviewed Tozer-theme adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-25 19:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000248'::uuid
);

commit;
-- END CONSOLIDATED SOURCE: 20261025190000_repair_draft_devotional_plans_wave_15.sql

-- BEGIN CONSOLIDATED SOURCE: 20261025200000_repair_draft_devotional_plans_wave_16.sql sha256=cde583b67fd2108c38b94cc8a292b631edee7216461fd17b64fcbf23e4dc6823
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
-- END CONSOLIDATED SOURCE: 20261025200000_repair_draft_devotional_plans_wave_16.sql

-- BEGIN CONSOLIDATED SOURCE: 20261025210000_repair_draft_devotional_plans_wave_17.sql sha256=2c46f983b6adffe0285581fad271d41035db2ea396754170568e4b116584d985
-- Adapt sixteen source-checked, Scripture-led readings from J. Manning Potts's
-- Prayers of the Early Church, published as an anthology in 1953.
-- Printed historical attributions are reported as editorial credits, not verified authorship.
-- Replaces long mechanically segmented text with a selected complete-prayer theme per day.
-- Newly written paraphrases, reflections and prayers are clearly distinguished from sources.
-- Existing plan ID, day IDs, day numbers, total_days, source URL and reading progress persist.
-- Publication is authorized after source, editorial, and distribution review.

begin;

-- Fail safely if the target structure differs from the reviewed seeded 16-day plan.
do $$
declare
  present_days integer;
  first_day integer;
  last_day integer;
  source_link text;
  reported_total integer;
begin
  select source_url, total_days into source_link, reported_total
  from public.devotional_plans where id = '90000000-0000-0000-0000-000000000264'::uuid;
  if not found then
    raise exception 'Plan 264 is missing';
  end if;
  if source_link is distinct from 'https://www.gutenberg.org/ebooks/48247' or reported_total <> 16 then
    raise exception 'Plan 264 source URL or total_days differs from the reviewed source';
  end if;
  select count(*), min(day_number), max(day_number) into present_days, first_day, last_day
  from public.devotional_days where plan_id = '90000000-0000-0000-0000-000000000264'::uuid;
  if present_days <> 16 or first_day <> 1 or last_day <> 16 then
    raise exception 'Plan 264 must have exactly 16 numbered days, found %', present_days;
  end if;
end
$$;

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-25 21:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Praying with the Early Church: Sixteen Scripture-Led Readings"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-25 21:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Sixteen Scripture-led devotions drawn from selected prayers in J. Manning Potts's 1953 anthology Prayers of the Early Church. The readings follow the existing seed's order, beginning with Simeon's biblical prayer and continuing through ancient intercessions, liturgical prayers, Augustine, and later collects. Every source-based paraphrase is editorial rather than a quotation and is followed by an original reflection and prayer. Historical attributions are those printed in Potts's anthology and have not all been independently established. The full source remains linked."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-25 21:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Seeing God's Salvation",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Praying for Just Leaders",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Mercy That Leads to Peace",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "A Heart Made Ready",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Grace for Every Stage",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Beginning the Day with Thanks",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Love Without Keeping Score",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Remember Every Neighbor",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Steadfast in God's Love",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Learning to Love and Obey",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "A Peace Deeper Than Circumstances",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Entrusting the Evening to God",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "The Holy Spirit's Guidance",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Doing What Is Right",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "God's Presence in Sorrow",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "Never Beyond God's Care",
    "day_number": 16
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-25 21:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> Luke 2:25-32.</p><p><strong>Source and attribution:</strong> Potts begins his selection of first-century prayers with Simeon's words from Luke's Gospel. This is a biblical prayer, not a quotation authored by the anthology's editor.</p><p><strong>Source-based editorial paraphrase:</strong> Simeon receives the child Jesus with gratitude. His hope rests in God's promise, and he recognizes salvation as light for the nations and glory for Israel.</p><p><strong>Reflect:</strong> Faith can learn to recognize Christ even in an unremarkable moment. Where do you need patient hope while waiting for God's goodness? Give thanks for one sign of grace today.</p><p><strong>Prayer:</strong> Faithful Father, teach me the patient hope of Simeon. Open my eyes to Jesus Christ, your promised salvation, and help me welcome your light with gratitude. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> 1 Timothy 2:1-4.</p><p><strong>Source and attribution:</strong> The anthology attributes this petition for rulers to Clement of Rome. It asks for peace, sound judgment, and gentle exercise of public authority; its historical form reflects an ancient social order.</p><p><strong>Source-based editorial paraphrase:</strong> The prayer seeks rulers whose decisions support stability, peace, and the common good. It brings political power before God instead of treating it as beyond moral judgment.</p><p><strong>Reflect:</strong> Praying for public officials need not mean excusing injustice. Name one decision affecting vulnerable neighbors and consider a peaceful, truthful way to advocate for their welfare.</p><p><strong>Prayer:</strong> God of justice, give leaders wisdom, integrity, and humility. Protect people harmed by abuses of power, and make us willing to seek peace and fairness in our communities. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> Psalm 51:10-12; 1 John 1:9.</p><p><strong>Source and attribution:</strong> Potts prints a prayer titled 'For Forgiveness' under Clement of Rome. It praises the Creator, confesses human wrongs, asks for purification, and seeks peace among people.</p><p><strong>Source-based editorial paraphrase:</strong> The ancient petition does not stop with relief from guilt. It asks God to direct our steps toward a clean heart, just conduct, and relationships marked by peace.</p><p><strong>Reflect:</strong> Confession should lead toward repair where possible. What wrong needs to be acknowledged, and what truthful, safe step could help restore trust?</p><p><strong>Prayer:</strong> Merciful Creator, forgive what I have done wrong and renew my heart. Teach me to accept responsibility, make amends where I can, and walk in your peace. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> James 1:22-25.</p><p><strong>Source and attribution:</strong> The anthology credits the complete prayer 'For a Pure Heart' to the Liturgy of St. James. Its language asks God to examine the conscience and turn people away from envy, anger, and pride.</p><p><strong>Source-based editorial paraphrase:</strong> Purity in this prayer concerns not appearances but the direction of one's inner life. It asks God to shape thoughts, motives, and speech for truthful worship.</p><p><strong>Reflect:</strong> Where is resentment affecting your words or decisions? Pray about its root, then choose one action that combines honesty with gentleness.</p><p><strong>Prayer:</strong> Holy Father, search my heart and free me from envy, arrogance, and needless anger. Make my words sincere and my actions consistent with your love. Through Jesus Christ, amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> Philippians 1:6-11.</p><p><strong>Source and attribution:</strong> The anthology prints a brief prayer 'For Growth in Grace' with the combined attribution 'Irenaeus, Old Gallican Sacramentary.' That credit is reproduced as the editor's attribution, not an authenticated statement of authorship.</p><p><strong>Source-based editorial paraphrase:</strong> The petition remembers people at different stages: beginners, learners, the weary, and those nearing the end of their course. Each needs God's sustaining grace.</p><p><strong>Reflect:</strong> Spiritual growth is not a competition. Who around you needs encouragement rather than comparison? Offer help suited to their situation, and accept help with your own.</p><p><strong>Prayer:</strong> Patient God, strengthen new believers, teach those still learning, restore the discouraged, and keep us faithful through every season of life. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> Lamentations 3:22-23.</p><p><strong>Source and attribution:</strong> Potts labels this morning thanksgiving as a prayer from the Liturgy of St. Mark. It remembers guidance and mercy already received and asks for an honest and faithful day ahead.</p><p><strong>Source-based editorial paraphrase:</strong> Morning prayer can begin with thanks rather than anxiety. The ancient words acknowledge past help while asking for protection from envy, fear, and harmful choices.</p><p><strong>Reflect:</strong> Before checking the day's demands, remember one kindness you have received. Which conversation or decision would benefit from a calmer, more grateful spirit?</p><p><strong>Prayer:</strong> Lord of mercy, thank you for bringing me into this day. Guide my thoughts, guard my speech, forgive my failings, and help me act with peace and integrity. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> John 13:34-35.</p><p><strong>Source and attribution:</strong> The anthology attributes the prayer 'For Charity' to the Coptic Liturgy of St. Cyril. It appeals to Jesus' command to love one another and asks for sincerity instead of lingering hostility.</p><p><strong>Source-based editorial paraphrase:</strong> Christian love is not the denial of harm; it refuses to let bitterness rule the heart. The source asks God to renew conscience and enable love that reflects Christ.</p><p><strong>Reflect:</strong> Is there a resentment you need to surrender, or a boundary you need to keep wisely? Seek love without pretending that injustice did not happen.</p><p><strong>Prayer:</strong> Lord Jesus, you loved us first. Give me a sincere heart, courage to speak truth, and grace to act with kindness without neglecting justice. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> Hebrews 13:1-3.</p><p><strong>Source and attribution:</strong> Potts attributes 'For All People' to Chrysostom. It names cities and countries, travelers, people experiencing illness or bondage, and those who serve the poor.</p><p><strong>Source-based editorial paraphrase:</strong> The prayer widens a congregation's concern beyond its own walls. It calls attention to people far away as well as neighbors who are vulnerable or easily forgotten.</p><p><strong>Reflect:</strong> Who falls outside your usual circle of concern? Pray for that person or community, then consider one concrete form of support or solidarity.</p><p><strong>Prayer:</strong> God of compassion, remember those who travel, suffer illness, face oppression, or lack daily necessities. Help your church respond with generous and practical love. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> Psalm 139:23-24.</p><p><strong>Source and attribution:</strong> The anthology credits this prayer of perseverance to Augustine. It pictures the soul as a house needing God's repair and asks for cleansing from hidden faults.</p><p><strong>Source-based editorial paraphrase:</strong> Steadfastness begins with dependence on grace. The prayer acknowledges imperfection while seeking a heart more open to the life and love of God.</p><p><strong>Reflect:</strong> What habit or motive have you avoided examining? Invite God's light into it, and choose a small, responsible step toward change.</p><p><strong>Prayer:</strong> God of steadfast love, search my motives and repair what is wounded in me. Cleanse my hidden faults and teach me to remain near you through change and difficulty. Amen.</p>",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> John 14:15-21.</p><p><strong>Source and attribution:</strong> Potts credits the prayer 'For Obedience and Love' to Augustine. It turns asking, seeking, and knocking into a request for a life directed toward God.</p><p><strong>Source-based editorial paraphrase:</strong> The ancient petition joins love and obedience. Its aim is not outward performance for approval but a willing life changed by relationship with the Lord.</p><p><strong>Reflect:</strong> What choice today would make love visible in practice? Name one response involving patience, honesty, generosity, or a needed apology.</p><p><strong>Prayer:</strong> Lord Jesus, draw my heart toward you. Shape my desires and guide my actions so that my profession of love becomes faithful care for others. Amen.</p>",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> John 14:27.</p><p><strong>Source and attribution:</strong> The anthology includes Augustine's brief petition for peace and enduring rest. His language looks beyond today's interruptions toward the rest promised in God.</p><p><strong>Source-based editorial paraphrase:</strong> Christian peace is more than the absence of noise or trouble. The prayer turns the soul toward God's enduring presence without claiming that hardship disappears now.</p><p><strong>Reflect:</strong> Where are you treating rest as something you must earn? Make space for a short pause, prayer, and any practical help you need.</p><p><strong>Prayer:</strong> Lord Jesus Christ, giver of peace, quiet my restless heart. Sustain me in what I cannot control and teach me to rest in your faithful love. Amen.</p>",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> Psalm 4:8.</p><p><strong>Source and attribution:</strong> The anthology places this short communal evening petition in the Apostolic Constitutions. It asks for peace, mercy, and a faithful life as the day draws to a close.</p><p><strong>Source-based editorial paraphrase:</strong> Evening prayer can hold gratitude and unresolved burdens together. The historical petition entrusts the night and the whole course of life to the living God through Christ.</p><p><strong>Reflect:</strong> Review one moment of gratitude and one unfinished concern from today. Give thanks for the first and release the second into God's care without neglecting tomorrow's responsibilities.</p><p><strong>Prayer:</strong> Living God, receive my gratitude and forgive my failures today. Grant restful peace, protect those in need, and prepare me to serve you faithfully tomorrow. Through Christ, amen.</p>",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> John 14:25-26.</p><p><strong>Source and attribution:</strong> The anthology attributes the prayer 'For The Holy Spirit' to the Apostolic Constitutions. It asks for an attentive mind, a faithful heart, and understanding of the truth through Christ.</p><p><strong>Source-based editorial paraphrase:</strong> The Spirit guides the church toward truth and holiness, not self-importance. The ancient request joins understanding with a life ready to be corrected and renewed.</p><p><strong>Reflect:</strong> Where do you need to listen more carefully before deciding? Read the passage again and ask for humility as well as clarity.</p><p><strong>Prayer:</strong> Holy Spirit, enlighten my understanding and correct my pride. Form in me a watchful heart, honest discernment, and deeper faith in Jesus Christ. Amen.</p>",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> Micah 6:8.</p><p><strong>Source and attribution:</strong> Potts prints 'For Right Living' as a prayer from the Leonine Sacramentary among his fifth-century selections. It asks for grace to think and act in ways pleasing to God.</p><p><strong>Source-based editorial paraphrase:</strong> Right intention and right action belong together. The prayer recognizes our need for divine help while inviting concrete habits of justice, mercy, and humility.</p><p><strong>Reflect:</strong> What good intention has remained unfinished? Turn it into a manageable step that can benefit another person today.</p><p><strong>Prayer:</strong> Gracious God, guide my thinking and strengthen my actions. Teach me to do justice, love mercy, and walk humbly with you through Jesus Christ. Amen.</p>",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> 2 Corinthians 1:3-5.</p><p><strong>Source and attribution:</strong> The anthology credits 'For the Sorrowing' to the Gelasian Sacramentary. It addresses God as the comfort of the sad and strength of those suffering adversity.</p><p><strong>Source-based editorial paraphrase:</strong> This collect does not demand that suffering people hide their grief. It asks that they may discover God's mercy in affliction, even while difficulty remains real.</p><p><strong>Reflect:</strong> Who is carrying sorrow that needs companionship rather than advice? Offer a listening ear, a visit, or a practical act of help.</p><p><strong>Prayer:</strong> Father of compassion, draw near to those who grieve or suffer. Give them comfort, trustworthy support, and the freedom to speak honestly of their pain. Amen.</p>",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "value": "<p><strong>Read:</strong> Psalm 121:7-8; Matthew 28:20.</p><p><strong>Source and attribution:</strong> Potts attributes this prayer for distant servants and travelers to the Gelasian Sacramentary. It petitions God for guidance and companionship throughout their journeys.</p><p><strong>Source-based editorial paraphrase:</strong> The source reminds worshipers that distance cannot place a person outside God's concern. This is a prayer for care and guidance, not a promise that followers of Christ will never face danger.</p><p><strong>Reflect:</strong> Who is far from your immediate reach today? Pray for their needs, check on them if appropriate, and offer real help within your means.</p><p><strong>Prayer:</strong> Lord Jesus, be near your people wherever they travel or serve. Give them wisdom, companions, and practical protection; keep us united in your love. Amen.</p>",
    "day_number": 16
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

-- Scripture-reference records are updated in place; unrelated user notes are untouched.
do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 1,
    "references": [
      "Luke 2:25-32"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 2,
    "references": [
      "1 Timothy 2:1-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 3,
    "references": [
      "Psalm 51:10-12",
      "1 John 1:9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 4,
    "references": [
      "James 1:22-25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 5,
    "references": [
      "Philippians 1:6-11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 6,
    "references": [
      "Lamentations 3:22-23"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 7,
    "references": [
      "John 13:34-35"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 8,
    "references": [
      "Hebrews 13:1-3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 9,
    "references": [
      "Psalm 139:23-24"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 10,
    "references": [
      "John 14:15-21"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 11,
    "references": [
      "John 14:27"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 12,
    "references": [
      "Psalm 4:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 13,
    "references": [
      "John 14:25-26"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 14,
    "references": [
      "Micah 6:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 15,
    "references": [
      "2 Corinthians 1:3-5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000264",
    "day_number": 16,
    "references": [
      "Psalm 121:7-8",
      "Matthew 28:20"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-25 21:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-25 21:00:00+00', timestamptz '2026-10-25 21:00:00+00');
    end if;
  end loop;
end
$$;

-- Publish the reviewed early-church prayer adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-25 21:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000264'::uuid
);

commit;
-- END CONSOLIDATED SOURCE: 20261025210000_repair_draft_devotional_plans_wave_17.sql

-- BEGIN CONSOLIDATED SOURCE: 20261025220000_repair_draft_devotional_plans_wave_18.sql sha256=0902081eef7dff7558af573dd53bfb577e61abd1dcf414df77116f9d7603d6fa
-- One 1863 Anglican subscription controversy reconstructed as eleven Scripture-led devotions.
-- Institutional polemic is replaced by readings on confession, conscience, unity, reform,
-- servant authority, and truth spoken in love. Existing day IDs and numbers are preserved.

begin;

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-25 22:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "Holding Truth with Love: Eleven Readings on Christian Confession"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-25 22:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "Eleven Scripture-led readings adapted from themes raised by William J. Irons's 1863 Anglican letter about clerical subscription. The historical controversy is clearly labeled and its institutional polemic is not presented as devotion. The readings instead consider Christ-centered confession, Scripture, conscience, inherited prayer, reform, creeds, charitable disagreement, servant authority, Christian unity, and truth spoken in love."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-25 22:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "Christ at the Center",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "Receive Scripture with Humility",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "Confess the Faith We Have Received",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "Speak with an Honest Conscience",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "Receive Inherited Prayer as a Gift",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "Reform with Patience and Courage",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "Let Creeds Serve Worship",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "Disagree without Contempt",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "Use Authority as Service",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "Seek Unity without Coercion",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "Hold Truth in Love",
    "day_number": 11
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-25 22:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "<p><strong>Read:</strong> 1 Corinthians 3:10-11; Colossians 1:15-20.</p><p><strong>Source and historical context:</strong> William J. Irons wrote his 1863 letter during an Anglican dispute about required assent to the Prayer Book and Articles. This adaptation leaves that institutional argument in the linked source and begins with the foundation Christians confess together.</p><p><strong>Devotional focus:</strong> Jesus Christ, crucified and risen, is the church's foundation and head. Statements, customs, and offices serve the church faithfully when they direct worship and obedience toward him.</p><p><strong>Reflect:</strong> What religious preference are you tempted to treat as central? Name what matters, then ask how it bears witness to Christ and forms love for God and neighbor.</p><p><strong>Prayer:</strong> Lord Jesus Christ, keep your church founded on you. Purify our convictions and make them serve worship, truth, and love. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "<p><strong>Read:</strong> 2 Timothy 3:14-17; Acts 17:10-12.</p><p><strong>Source and historical context:</strong> Irons appeals to Scripture while defending inherited Anglican standards. His historical conclusions belong to a particular controversy; every Christian teacher and tradition remains accountable to God's word.</p><p><strong>Devotional focus:</strong> Scripture equips God's people for faithful life. We read it with prayer, careful study, the church's wisdom, and a willingness to have our assumptions corrected.</p><p><strong>Reflect:</strong> Do you read mainly to confirm what you already think? Revisit one passage slowly, attend to its context, and receive a trustworthy correction if one is needed.</p><p><strong>Prayer:</strong> God of truth, open the Scriptures to us by your Spirit. Give us teachable minds and obedient hearts through Jesus Christ. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "<p><strong>Read:</strong> 1 Corinthians 15:1-5; 2 Timothy 1:13-14.</p><p><strong>Source and historical context:</strong> The source argues that churches need public standards of belief. Christians disagree about the authority and wording of later documents, yet the New Testament itself preserves a received proclamation centered on Christ's death and resurrection.</p><p><strong>Devotional focus:</strong> Christian confession remembers the gospel and guards the community from making faith whatever seems convenient. Its purpose is faithful witness, worship, and hope.</p><p><strong>Reflect:</strong> Which part of the gospel do your habits most easily neglect? Recall the good news of Christ and consider how it changes one decision today.</p><p><strong>Prayer:</strong> Faithful God, keep the gospel alive in our memory and practice. Help us confess Jesus Christ with courage, humility, and joy. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "<p><strong>Read:</strong> 2 Corinthians 1:12; 1 Timothy 1:5.</p><p><strong>Source and historical context:</strong> Clerical subscription raised questions about whether a person could honestly affirm words required for office. The historical debate was complex, but it highlights the enduring need for integrity between speech, conviction, and action.</p><p><strong>Devotional focus:</strong> God does not ask for strategic ambiguity or public words we privately deny. A clear conscience seeks truth, welcomes examination, and corrects misleading speech.</p><p><strong>Reflect:</strong> Where are your words and convictions drifting apart? Clarify what you can honestly promise, and repair any impression your speech has falsely created.</p><p><strong>Prayer:</strong> God who knows every heart, make my speech truthful and my commitments sincere. Give me courage to correct what is false. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "<p><strong>Read:</strong> Luke 11:1-4; Psalm 145:4-7.</p><p><strong>Source and historical context:</strong> Irons cherished the Church of England's inherited forms of worship. Set apart from his institutional claims, that gratitude invites reflection on how received prayers can teach later generations to praise, confess, and hope.</p><p><strong>Devotional focus:</strong> Written prayers can lend words when our own fail and connect us with believers across time. They are gifts for worship, not measures by which to despise Christians who pray differently.</p><p><strong>Reflect:</strong> What trusted prayer, hymn, or confession has helped form you? Pray it attentively, then express the same truth in your own words.</p><p><strong>Prayer:</strong> Father, thank you for faithful prayers handed down through your church. Use them to deepen our worship and enlarge our love. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "<p><strong>Read:</strong> Nehemiah 2:17-18; Revelation 2:4-5.</p><p><strong>Source and historical context:</strong> The 1863 letter resists proposed institutional change and sometimes treats opponents too sharply. Christian communities need both continuity and reform, tested through truth, repentance, wisdom, and patient discernment.</p><p><strong>Devotional focus:</strong> Faithfulness does not mean preserving every custom unchanged. The risen Christ calls churches to remember, repent, repair what is harmful, and strengthen what serves the gospel.</p><p><strong>Reflect:</strong> What should your community preserve, and what needs repentance or repair? Seek evidence, listen to people affected, and take one constructive step.</p><p><strong>Prayer:</strong> Risen Lord, give your church wisdom to preserve what is faithful and courage to reform what causes harm. Lead us in patient truth. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "<p><strong>Read:</strong> Matthew 28:18-20; Philippians 2:5-11.</p><p><strong>Source and historical context:</strong> Irons discusses ancient councils while defending formal doctrinal agreement. The Nicene tradition confesses the Triune God and the full identity of Jesus Christ; its words serve the church by directing worship toward the God revealed in the gospel.</p><p><strong>Devotional focus:</strong> A creed is fruitful when it leads beyond argument into praise, faithful teaching, baptismal discipleship, and love. Correct words should form a life that honors the Father, Son, and Holy Spirit.</p><p><strong>Reflect:</strong> Choose one line of the Christian confession and turn it into thanksgiving. How should that truth shape your treatment of another person?</p><p><strong>Prayer:</strong> Triune God, receive our worship. Keep our confession faithful and make our lives reflect the humility and love of Jesus Christ. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "<p><strong>Read:</strong> James 1:19-20; 2 Timothy 2:23-25.</p><p><strong>Source and historical context:</strong> The source belongs to a heated public dispute and includes dismissive judgments about other Christians. This adaptation does not reproduce that polemic; it retains the question of how truth should be defended.</p><p><strong>Devotional focus:</strong> Christian disagreement requires careful listening, accurate representation, gentleness, and readiness to be corrected. Anger and ridicule cannot produce the righteousness of God.</p><p><strong>Reflect:</strong> Think of someone whose view you oppose. Can you describe it fairly before responding? Remove one exaggerated claim and choose language that preserves the person's dignity.</p><p><strong>Prayer:</strong> God of wisdom, restrain anger and contempt in me. Teach me to listen carefully, speak accurately, and correct with gentleness. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "<p><strong>Read:</strong> Mark 10:42-45; 1 Peter 5:1-4.</p><p><strong>Source and historical context:</strong> Irons's controversy involved bishops, clergy, universities, and Parliament. Its institutional setting raises a wider devotional question: how should authority be exercised among people who belong to Christ?</p><p><strong>Devotional focus:</strong> Jesus rejects domination and reveals authority as service. Christian leaders remain accountable to him and should protect conscience, tell the truth, welcome correction, and seek the good of those entrusted to them.</p><p><strong>Reflect:</strong> Where do you hold authority or influence? Identify one way to share information, invite correction, or protect someone with less power.</p><p><strong>Prayer:</strong> Servant King, cleanse our use of authority. Make leaders accountable, courageous, and attentive to the people they serve. Amen.</p>",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "<p><strong>Read:</strong> Ephesians 4:1-6; Romans 14:4-6.</p><p><strong>Source and historical context:</strong> The source assumes that institutional uniformity protects church unity. Shared teaching can support common life, but coerced conformity can hide fear or dishonesty. The New Testament joins unity with humility, patience, and room for some differences.</p><p><strong>Devotional focus:</strong> Christian unity rests in one Lord, one faith, one baptism, and one Spirit. It grows through truth and love rather than pressure, secrecy, or the demand that every secondary practice be identical.</p><p><strong>Reflect:</strong> Where might you confuse unity with control? Clarify what belongs to the shared gospel and where patient difference can be received.</p><p><strong>Prayer:</strong> Holy Spirit, preserve the unity you give. Deliver us from coercion and teach us to walk together in truth, patience, and love. Amen.</p>",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "value": "<p><strong>Read:</strong> Ephesians 4:11-16; John 13:34-35.</p><p><strong>Source and historical context:</strong> Irons closes by urging protection of doctrine and worship as he understood them. Read historically, the letter shows both the seriousness of conviction and the danger of letting controversy overshadow charity.</p><p><strong>Devotional focus:</strong> Truth and love belong together in the mature body of Christ. Love without truth becomes evasive, while truth spoken without love can become a weapon rather than a means of growth.</p><p><strong>Reflect:</strong> In one difficult conversation, what truth needs clarity and what act of love needs visibility? Prepare to offer both without manipulation.</p><p><strong>Prayer:</strong> Lord Jesus, full of grace and truth, mature your church. Make us steadfast in the gospel and recognizable by our love. Amen.</p>",
    "day_number": 11
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
    "id": "90000000-0000-0000-0000-000000000376",
    "day_number": 1,
    "references": [
      "1 Corinthians 3:10-11",
      "Colossians 1:15-20"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "day_number": 2,
    "references": [
      "2 Timothy 3:14-17",
      "Acts 17:10-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "day_number": 3,
    "references": [
      "1 Corinthians 15:1-5",
      "2 Timothy 1:13-14"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "day_number": 4,
    "references": [
      "2 Corinthians 1:12",
      "1 Timothy 1:5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "day_number": 5,
    "references": [
      "Luke 11:1-4",
      "Psalm 145:4-7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "day_number": 6,
    "references": [
      "Nehemiah 2:17-18",
      "Revelation 2:4-5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "day_number": 7,
    "references": [
      "Matthew 28:18-20",
      "Philippians 2:5-11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "day_number": 8,
    "references": [
      "James 1:19-20",
      "2 Timothy 2:23-25"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "day_number": 9,
    "references": [
      "Mark 10:42-45",
      "1 Peter 5:1-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "day_number": 10,
    "references": [
      "Ephesians 4:1-6",
      "Romans 14:4-6"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000376",
    "day_number": 11,
    "references": [
      "Ephesians 4:11-16",
      "John 13:34-35"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-25 22:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-25 22:00:00+00', timestamptz '2026-10-25 22:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish the contextualized Christian-confession adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-25 22:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000376'::uuid
);

commit;
-- END CONSOLIDATED SOURCE: 20261025220000_repair_draft_devotional_plans_wave_18.sql

