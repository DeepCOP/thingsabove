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
