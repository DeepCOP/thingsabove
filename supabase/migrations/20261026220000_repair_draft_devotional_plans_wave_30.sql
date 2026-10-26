-- Wave 30: Plan 355 — Ritual Conformity (1881 Anglican conference), 27 existing day rows.
-- Original Scripture-led thematic devotions. Not a verbatim reprint or a statement of
-- current Anglican church law. Keep source/cover/tags/IDs/user reading progress intact.
-- Apply AFTER October 21 language modernization, especially part 12 (which updates
-- 10 original day contents for this plan). Never run modernization over this migration.
-- Editorial DRAFT ONLY. Test in staging; review denominational and pastoral nuances.

begin;

do $$
declare
  current_source text;
  current_total integer;
  day_count integer;
  first_day integer;
  last_day integer;
  unique_days integer;
  duplicates integer;
begin
  select source_url, total_days into current_source, current_total
  from public.devotional_plans where id = '90000000-0000-0000-0000-000000000355'::uuid;
  if not found then raise exception 'Plan 355 missing'; end if;
  if current_source is distinct from 'https://www.gutenberg.org/ebooks/31177' or current_total is distinct from 27 then
    raise exception 'Plan 355 source URL or total days differs from Wave 30 review';
  end if;
  select count(*), min(day_number), max(day_number), count(distinct day_number)
  into day_count, first_day, last_day, unique_days
  from public.devotional_days where plan_id = '90000000-0000-0000-0000-000000000355'::uuid;
  if day_count <> 27 or first_day <> 1 or last_day <> 27 or unique_days <> 27 then
    raise exception 'Plan 355 must contain 27 distinct numbered days; found %', day_count;
  end if;
  -- Prevent silent multiple plan-owned reference rows per day.
  select count(*) into duplicates from (
     select sr.day_id
     from public.scripture_references sr
     join public.devotional_days d on d.id = sr.day_id
     where d.plan_id = '90000000-0000-0000-0000-000000000355'::uuid and sr.user_id is null
     group by sr.day_id having count(*) > 1
  ) duplicates_per_day;
  if duplicates > 0 then
    raise exception 'Plan 355 has % days with duplicate plan-level Scripture-reference rows', duplicates;
  end if;
end
$$;

update public.devotional_plans as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "value": "Worship with Understanding: 27 Readings Inspired by Ritual Conformity"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "value": "Twenty-seven original, Scripture-led reflections adapted from the 1881 Anglican conference text Ritual Conformity. Explore shared prayer, Scripture, liturgical seasons, Communion, baptism, marriage, pastoral care, and Christian hope through historical context, accessible reflection, an action, and prayer. The source discusses Church of England rubrics and disputed nineteenth-century interpretations; its ceremonial rules are historical positions, not commands for all churches. Every reading connects reverent worship with mercy, inclusion, and the life of faith."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 1,
    "value": "Seeking Unity without Erasing Difference"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 2,
    "value": "Faithful Discernment Takes Patient Study"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 3,
    "value": "Let Seasons Teach Us to Remember"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 4,
    "value": "A Place Prepared for People"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 5,
    "value": "Let the Word Be Heard Clearly"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 6,
    "value": "Confession Is Something We Share"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 7,
    "value": "A Community That Listens to Scripture"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 8,
    "value": "Songs of Hope at the Close of Day"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 9,
    "value": "Thanksgiving That Leads to Repair"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 10,
    "value": "Sacred Space Is for Shared Worship"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 11,
    "value": "Worship Leaders Serve the Congregation"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 12,
    "value": "Preaching and Giving Belong Together"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 13,
    "value": "Prepare the Table with Gratitude"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 14,
    "value": "Mercy at the Heart of the Table"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 15,
    "value": "One Bread, Many People"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 16,
    "value": "Prayer Is the Work of the Whole Body"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 17,
    "value": "The Table Should Not Forget the Poor"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 18,
    "value": "A Welcome Marked with Water"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 19,
    "value": "Make Room for the Vulnerable"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 20,
    "value": "A Faithful Welcome, Not a Repeated Test"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 21,
    "value": "Teach the Faith with Patience"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 22,
    "value": "Marriage Promises Deserve Care"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 23,
    "value": "Be Present with the Sick and Troubled"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 24,
    "value": "God Is Near When Communion Is Difficult"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 25,
    "value": "Mourning with Dignity and Hope"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 26,
    "value": "Prayer Holds Gratitude and Lament Together"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 27,
    "value": "Let Careful Practice Lead to Love"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = now()
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 1,
    "value": "<p><strong>Read:</strong> Ephesians 4:1-6; 1 Corinthians 14:40</p><p><strong>Source and historical context:</strong> In 1880, English clergy and liturgical scholars gathered to address the growing differences among churches in their worship practices. Their discussions became the 1881 guide Ritual Conformity, which argued for responsible interpretation of the Book of Common Prayer rather than unthinking novelty.</p><p><strong>Devotional focus:</strong> Order can serve love when it helps a congregation pray together. Yet sameness is not the same as unity, and Christians may worship faithfully through different traditions. Paul urges patience, gentleness, and a common commitment to peace. The goal of any discussion about worship is not winning a contest over details but making room for the whole body to honor God.</p><p><strong>Reflect:</strong> When have I confused my preferred way of worship with the measure of another person’s faith?</p><p><strong>Practice:</strong> Listen to someone from a different church tradition. Ask what helps them pray, without starting a debate.</p><p><strong>Prayer:</strong> God of peace, teach us to cherish truth with humility and to seek unity without contempt. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 2,
    "value": "<p><strong>Read:</strong> Proverbs 15:22; Colossians 3:16-17</p><p><strong>Source and historical context:</strong> The conference explained that its interpretations came from research, experience in parish ministry, and discussions requiring broad agreement. It then traced the prayer book through revisions in 1549, 1552, and 1662, noting that words must be understood in their historical setting.</p><p><strong>Devotional focus:</strong> No one participant knows everything. When questions about worship become difficult, we need careful listening, knowledge of the past, and attention to the needs of present congregations. Scripture invites believers to teach and admonish one another with wisdom. Patience protects us both from careless change and from using tradition as an excuse to stop learning.</p><p><strong>Reflect:</strong> Whose experience should I seek before deciding what is best for a community?</p><p><strong>Practice:</strong> Before arguing about a church practice, read its background and invite a thoughtful question from someone affected by it.</p><p><strong>Prayer:</strong> Lord, give me wisdom that welcomes correction and counsel that serves others well. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 3,
    "value": "<p><strong>Read:</strong> Ecclesiastes 3:1-8; Romans 14:5-6</p><p><strong>Source and historical context:</strong> This segment lists the precedence of church festivals when holy days overlap. It also distinguishes periods of fasting and abstinence within a historical Anglican calendar, including Lent, Ember days, Rogation days, and Fridays.</p><p><strong>Devotional focus:</strong> A church calendar can slow our busy lives so that we remember Christ’s coming, suffering, resurrection, and continuing call. Yet Paul cautions believers not to turn differences over days into mutual judgment. The value of a season lies in the gratitude, repentance, and care it nurtures, not in perfect mastery of a complicated timetable.</p><p><strong>Reflect:</strong> What season or sacred moment could help me attend more carefully to God?</p><p><strong>Practice:</strong> Choose one upcoming Christian observance and learn its meaning. Consider one simple act of prayer or generosity connected to it.</p><p><strong>Prayer:</strong> God of all our days, help the rhythms of worship direct our hearts toward you and our neighbors. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 4,
    "value": "<p><strong>Read:</strong> 1 Peter 2:4-5; James 2:1-4</p><p><strong>Source and historical context:</strong> The guide discusses where morning and evening prayer should be offered, the architecture of chancels, and church ornaments linked to sixteenth-century Anglican law. It also admits that restoring a practice abruptly can be unwise when worshippers do not desire it.</p><p><strong>Devotional focus:</strong> Buildings, furnishings, and vestments can carry memory and beauty, but they are not the living heart of the church. Peter calls believers living stones, and James warns against allowing visible status to determine whom we honor. A well-prepared worship space should serve prayer, welcome, and participation rather than distract from the people gathered there.</p><p><strong>Reflect:</strong> Do our worship spaces make visitors, people with disabilities, and those with little money feel welcome?</p><p><strong>Practice:</strong> Notice one barrier to participation in a worship space and suggest a practical, respectful improvement.</p><p><strong>Prayer:</strong> Lord Jesus, build us into a welcoming people whose reverence makes room for everyone. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 5,
    "value": "<p><strong>Read:</strong> Nehemiah 8:1-8; 1 Corinthians 14:9</p><p><strong>Source and historical context:</strong> After discussing the colors of historic church vestments, the authors turn to Morning Prayer. They distinguish between reading, saying, and singing Scripture, and ask how the congregation will best hear and understand the opening sentences.</p><p><strong>Devotional focus:</strong> Music and ceremony can deepen attention, but clarity matters more than display. At the public reading of the Law in Nehemiah, the people were helped to understand what they heard. Paul likewise values speech that benefits listeners. Whether a passage is spoken or sung, love asks that it be audible, intelligible, and accessible to the community.</p><p><strong>Reflect:</strong> Could someone unfamiliar with our worship actually understand the words being spoken?</p><p><strong>Practice:</strong> Read a short Bible passage aloud at a comfortable pace, then share its meaning in plain language.</p><p><strong>Prayer:</strong> Speaking God, let your word reach our ears and shape our actions. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 6,
    "value": "<p><strong>Read:</strong> 1 John 1:8-9; Psalm 51:10-12</p><p><strong>Source and historical context:</strong> The rubrical notes explain why the congregation repeats a general confession after the minister and discusses the shared response “Amen.” The authors also describe how the Lord’s Prayer, psalms, and other responses are voiced by the worshipping assembly.</p><p><strong>Devotional focus:</strong> Shared confession is not meant to single out the most vulnerable or invite public humiliation. It tells the truth that everyone needs grace. When we say “Amen” to a prayer, we take part rather than leaving worship to a leader. Forgiveness opens a path toward honesty and repair; it should not become pressure to disclose private experiences without consent or safety.</p><p><strong>Reflect:</strong> Where do I need to exchange defensiveness for truthful, humble prayer?</p><p><strong>Practice:</strong> Pray Psalm 51 slowly. If you have harmed someone, consider a safe and specific step toward making amends.</p><p><strong>Prayer:</strong> Merciful God, meet our confession with grace and help our words become changed lives. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 7,
    "value": "<p><strong>Read:</strong> 2 Timothy 3:16-17; Luke 24:27-32</p><p><strong>Source and historical context:</strong> The guide sets out when the appointed psalms and Bible lessons may be changed and explains how Scripture readings, responses, and the Lord’s Prayer fit together in Morning Prayer. It treats regular listening to the full range of Scripture as a communal discipline.</p><p><strong>Devotional focus:</strong> It is easy to return only to the verses we already enjoy. A regular pattern of reading can introduce voices, questions, and promises we might otherwise miss. Scripture forms us over time as we hear Christ’s story and learn to respond. The practice should lead toward understanding, not merely the completion of a reading schedule.</p><p><strong>Reflect:</strong> Which part of Scripture have I avoided because it seems unfamiliar or difficult?</p><p><strong>Practice:</strong> Read a passage outside your usual favorites, then write one honest question you would like to explore.</p><p><strong>Prayer:</strong> Lord, open our minds to your word and make us willing listeners. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 8,
    "value": "<p><strong>Read:</strong> Luke 1:46-55; Luke 2:25-32</p><p><strong>Source and historical context:</strong> The notes on Evening Prayer recommend retaining the Magnificat and the Nunc Dimittis whenever possible. They also discuss litanies, set prayers, and how congregations may remember specific people in common intercession.</p><p><strong>Devotional focus:</strong> Mary’s song announces a God who notices the lowly, and Simeon’s song welcomes the promised light. These biblical prayers can teach us how to end a day: not by pretending all is well, but by remembering what God has done and holding the world in hope. Shared intercession makes space for needs beyond our own.</p><p><strong>Reflect:</strong> What part of today needs to be entrusted to God in gratitude or sorrow?</p><p><strong>Practice:</strong> Pray the Magnificat or Nunc Dimittis this evening. Include one neighbor or community concern in your prayer.</p><p><strong>Prayer:</strong> Faithful God, gather our joys and griefs into the light of Christ. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 9,
    "value": "<p><strong>Read:</strong> Psalm 100:1-5; Matthew 5:23-24</p><p><strong>Source and historical context:</strong> The guide describes the General Thanksgiving and prayers used when people return thanks. It then turns to preparation for Holy Communion, including the expectation that those who have seriously harmed others should seek reconciliation and make restitution where possible.</p><p><strong>Devotional focus:</strong> Gratitude is more than a pleasant feeling. Remembering God’s goodness can lead us to notice what we owe one another in honesty and care. Jesus connects worship with the work of reconciliation. Restoration cannot always be immediate, and it must not demand unsafe contact or ignore serious harm, but truthful repentance seeks concrete change.</p><p><strong>Reflect:</strong> Is there a relationship or obligation I have avoided while asking God to bless my worship?</p><p><strong>Practice:</strong> Give thanks for one mercy today, then take one safe, proportionate action to correct a wrong or honor a neglected commitment.</p><p><strong>Prayer:</strong> God of mercy, make our thanks sincere and our repentance practical. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 10,
    "value": "<p><strong>Read:</strong> Hebrews 10:24-25; Luke 22:24-27</p><p><strong>Source and historical context:</strong> The writers compare church customs for positioning the communion table, the minister, and attendants. Their discussion engages historic English practice, the north side of the altar, and legal disputes about the physical arrangement of worship.</p><p><strong>Devotional focus:</strong> Different traditions understand these arrangements differently. What every Christian community can ask is whether its space helps people gather, remember Jesus, and care for one another. The Lord placed service, not ceremonial prestige, at the center of leadership. Reverence should strengthen fellowship rather than make worshippers feel that they are merely an audience.</p><p><strong>Reflect:</strong> In our gatherings, whose needs are considered when arrangements are made?</p><p><strong>Practice:</strong> Ask a fellow worshipper what helps them feel able to participate, and carry one suggestion to a responsible leader.</p><p><strong>Prayer:</strong> Servant King, keep our worship centered on your welcome and teach us to serve rather than seek importance. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 11,
    "value": "<p><strong>Read:</strong> 1 Corinthians 14:26; Mark 10:42-45</p><p><strong>Source and historical context:</strong> The guide expressly reminds clergy that the Communion service is meant for the congregation and should not be delayed by the priest’s private devotions. It goes on to discuss public prayers, Bible readings, the Gospel, and church announcements.</p><p><strong>Devotional focus:</strong> Christian leadership carries responsibility for other people’s time, attention, and access to worship. Jesus defined greatness through service. Thoughtful preparation can make worship more welcoming, while a leader’s humility allows others to hear Scripture and respond without unnecessary obstacles. This applies beyond churches whenever one person guides a group.</p><p><strong>Reflect:</strong> Does my role in a group make participation easier for others or revolve around my preferences?</p><p><strong>Practice:</strong> If you lead, prepare one activity with participants’ needs in mind. If you attend, thank a person who quietly makes space for others.</p><p><strong>Prayer:</strong> Jesus, shape our leadership after your generosity and patience. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 12,
    "value": "<p><strong>Read:</strong> James 2:14-17; 2 Corinthians 9:6-8</p><p><strong>Source and historical context:</strong> The guide describes the sermon, the collection of alms, and the preparation of bread and wine for Communion. It recalls that offerings were once brought to a single basin and notes the practical needs of larger congregations.</p><p><strong>Devotional focus:</strong> The word proclaimed in worship should shape what a congregation does with its resources. James asks what faith means when a neighbor lacks food or clothing; Paul emphasizes giving freely, not under compulsion. Worshipful generosity protects dignity by serving actual needs rather than seeking attention or controlling recipients.</p><p><strong>Reflect:</strong> How does the faith I hear on Sunday influence my choices about time and money?</p><p><strong>Practice:</strong> Offer a modest contribution or practical help to a trustworthy effort meeting real needs, without expecting praise.</p><p><strong>Prayer:</strong> Generous Lord, join our listening to loving action. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 13,
    "value": "<p><strong>Read:</strong> 1 Corinthians 11:23-26; Luke 22:19-20</p><p><strong>Source and historical context:</strong> The authors discuss the historical practice of mixing a little water with Eucharistic wine, preparing the elements, and allowing sufficient time for a communal confession. These are directions within a particular Anglican liturgical debate, not universal Christian requirements.</p><p><strong>Devotional focus:</strong> The heart of Communion is the remembrance of Jesus and the grace he shares with his people. Careful preparation can invite attention to that gift, but small ritual details should not obscure the story of Christ’s self-giving love. We approach the table neither to display expertise nor to prove ourselves worthy, but to remember him together.</p><p><strong>Reflect:</strong> What could help me approach Communion with attentiveness instead of habit or anxiety?</p><p><strong>Practice:</strong> Before your next Communion, read 1 Corinthians 11:23–26 and thank Christ for his generosity.</p><p><strong>Prayer:</strong> Lord Jesus, turn our attention from performance to your love, remembered and shared. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 14,
    "value": "<p><strong>Read:</strong> Hebrews 4:14-16; 1 Corinthians 11:28-29</p><p><strong>Source and historical context:</strong> The notes discuss who may lead the confession, how a minister offers words of forgiveness, and where to stand during the prayer of consecration. They also compare historic customs for lifting the bread and chalice.</p><p><strong>Devotional focus:</strong> The setting may vary across churches, yet the deeper invitation remains: examine ourselves with sincerity and come before Christ with trust in his mercy. Self-examination is not an excuse for public shaming or endless fear. When the church speaks of forgiveness, it should make room for repentance, healing, and faithful care.</p><p><strong>Reflect:</strong> Do I approach God mainly with fear of failure, or with honest trust in his grace?</p><p><strong>Practice:</strong> Read Hebrews 4:14–16 slowly; name one place where you need both accountability and mercy.</p><p><strong>Prayer:</strong> Compassionate Savior, receive us truthfully and lead us toward your healing grace. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 15,
    "value": "<p><strong>Read:</strong> 1 Corinthians 10:16-17; Romans 14:19</p><p><strong>Source and historical context:</strong> This section explains gestures at the words of institution and the way people receive Communion. It urges the celebrant not to enforce needless uniformity in the manner of reception when people act reverently.</p><p><strong>Devotional focus:</strong> Paul’s image of one bread points beyond individual technique to shared participation in Christ. Respectful practices can differ, and a community need not insist on every physical detail as a test of belonging. What matters pastorally is that worshippers are treated with patience, the sacraments are handled responsibly, and people are not turned into spectacles over minor differences.</p><p><strong>Reflect:</strong> When have I focused on another worshipper’s gesture more than on our shared faith?</p><p><strong>Practice:</strong> At your next gathering, choose to encourage one another’s participation rather than critique harmless differences.</p><p><strong>Prayer:</strong> Christ, unite us in gratitude and help us honor one another at your table. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 16,
    "value": "<p><strong>Read:</strong> Acts 2:42-47; 1 Corinthians 12:12-13</p><p><strong>Source and historical context:</strong> After discussing Communion gestures, the guide moves through prayers following Communion, the Gloria, and the number of people needed for a celebration. Its detailed requirements reflect a particular historical discipline.</p><p><strong>Devotional focus:</strong> The early believers prayed, broke bread, and shared life as a community. Public worship is more than a service performed by one expert while everyone else observes. It is the shared response of people with different gifts and needs. We can make room for active participation while respecting how various traditions order their services.</p><p><strong>Reflect:</strong> In what way could I help someone experience worship as belonging rather than observing?</p><p><strong>Practice:</strong> Invite another person to join a prayer, song, reading, or act of service, without pressuring them to participate.</p><p><strong>Prayer:</strong> Holy Spirit, make us attentive members of one body, generous in our welcome. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 17,
    "value": "<p><strong>Read:</strong> 1 Corinthians 11:20-22; James 2:1-5</p><p><strong>Source and historical context:</strong> This segment considers minimum numbers of communicants, the practice of receiving Communion through the church year, and the suitability of bread and wine. The authors also note that church authorities lack grounds to dismiss people merely for not receiving that day.</p><p><strong>Devotional focus:</strong> Paul rebuked the Corinthian church when its shared meal humiliated those with little. Reverence includes the way people are treated, not only the quality of vessels or ingredients. Whatever a denomination’s Communion discipline, communities should resist favoritism and offer patient pastoral care to people whose circumstances affect their participation.</p><p><strong>Reflect:</strong> Who might feel left out or ashamed in the way our community practices worship?</p><p><strong>Practice:</strong> Speak with a church leader about one respectful way to support the participation of a person who is overlooked.</p><p><strong>Prayer:</strong> God of the shared table, keep us from dishonoring those whom you love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 18,
    "value": "<p><strong>Read:</strong> Matthew 28:18-20; Ephesians 4:4-6</p><p><strong>Source and historical context:</strong> The authors describe the reverent consumption of consecrated elements after Communion and then turn to the public baptism of children. They discuss the font, ministers’ clothing, and the value of baptisms taking place when the congregation can gather.</p><p><strong>Devotional focus:</strong> Water is an ordinary gift, and Christian baptism gives it a place in the church’s account of belonging to Christ. Traditions differ about its recipients and meaning, but all can recognize a call to treat persons with dignity and to take promises of care seriously. Public worship can become a setting where a community commits to accompany people in faith.</p><p><strong>Reflect:</strong> What does it mean for my community to welcome and support someone beyond the day of a ceremony?</p><p><strong>Practice:</strong> Offer practical support to a new member, parent, or person exploring faith; ask what would actually be helpful.</p><p><strong>Prayer:</strong> Jesus, make our promises of welcome visible in patient, everyday love. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 19,
    "value": "<p><strong>Read:</strong> Mark 10:13-16; Isaiah 43:1-3</p><p><strong>Source and historical context:</strong> The guide gives detailed rubrics for baptism using water and discusses both public ceremonies and the private baptism of infants who are unwell. Its instructions reflect an Anglican sacramental framework and the medical uncertainties of its time.</p><p><strong>Devotional focus:</strong> Jesus welcomed children who were being kept away from him. Churches can honor that welcome by taking vulnerability seriously and not treating someone’s illness as a reason for neglect or exclusion. Spiritual care should complement appropriate medical care, not replace it. The child and family deserve respect rather than an argument about ceremonial perfection.</p><p><strong>Reflect:</strong> Who needs gentle and practical attention in my community right now?</p><p><strong>Practice:</strong> Ask a parent, caregiver, or person facing illness what support would make their next week more manageable.</p><p><strong>Prayer:</strong> Welcoming Lord, help us protect the vulnerable and make room for their full dignity. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 20,
    "value": "<p><strong>Read:</strong> Acts 8:26-39; Ephesians 2:19-22</p><p><strong>Source and historical context:</strong> These pages explain how clergy assessed whether a child had previously been baptized, followed by ceremonies for children and adults. The writers emphasize valid administration according to the rules of their historical church.</p><p><strong>Devotional focus:</strong> Rules about baptism differ among Christian traditions, and the historical authors spoke from within one of them. Beneath the procedural questions is a human one: how do we receive and accompany someone seeking to belong? In Acts, the Ethiopian official asks about baptism, and the story centers on welcome to the good news of Jesus. A church’s care should extend to understanding, discipleship, and ongoing community.</p><p><strong>Reflect:</strong> Have I made another person feel that belonging depends on passing my private test?</p><p><strong>Practice:</strong> Welcome someone who is exploring faith. Offer to listen to their questions without pressing for a premature commitment.</p><p><strong>Prayer:</strong> Lord Jesus, guide seekers toward truth and give our communities generous hearts. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 21,
    "value": "<p><strong>Read:</strong> Deuteronomy 6:6-7; 1 Peter 3:15-16</p><p><strong>Source and historical context:</strong> The guide moves from adult baptism to confirmation, catechism, and the preparation of candidates. It then introduces the public notice given before marriage. The authors expect church leaders to take teaching and communal responsibilities seriously.</p><p><strong>Devotional focus:</strong> Faith formation takes time, questions, and relationships. Deuteronomy imagines teaching woven into ordinary life, and Peter urges gentleness when explaining hope. Preparation for major commitments is not simply a checklist of correct answers; it is an opportunity for informed, willing participation and care from the people surrounding us.</p><p><strong>Reflect:</strong> When I teach or advise, do I leave room for honest questions?</p><p><strong>Practice:</strong> Ask a younger believer or new member what they find confusing, and look for an answer together without embarrassment.</p><p><strong>Prayer:</strong> Patient God, help our communities teach faithfully and listen with gentleness. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 22,
    "value": "<p><strong>Read:</strong> Ephesians 5:21; 1 Corinthians 13:4-7</p><p><strong>Source and historical context:</strong> The marriage section describes where the couple stands, the officiant’s role, vows, the ring, prayers, and other ceremonial details. Some recommendations assume Victorian gender roles and the Church of England’s legal arrangements.</p><p><strong>Devotional focus:</strong> A wedding service should direct attention beyond its beauty to the responsibility of love. Paul calls Christians to mutual care, and 1 Corinthians describes love as patient and kind. A meaningful promise requires free consent, honesty, respect, and safety; no ritual detail should be used to justify coercion, unequal dignity, or the concealment of abuse.</p><p><strong>Reflect:</strong> What qualities matter most in the commitments I make to people I love?</p><p><strong>Practice:</strong> Talk with someone you trust about how kindness, consent, and faithful accountability appear in real relationships.</p><p><strong>Prayer:</strong> God of faithful love, teach us to honor promises without diminishing another person’s freedom or worth. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 23,
    "value": "<p><strong>Read:</strong> James 5:13-16; Psalm 34:17-18</p><p><strong>Source and historical context:</strong> The guide concludes its notes on marriage and introduces prayers for visiting people who are ill, including a prayer for those troubled in mind or conscience. It discusses pastoral advice, personal prayer, and practical choices about the service.</p><p><strong>Devotional focus:</strong> Illness and distress are not failures of faith. James describes prayer and care around the sick, while the psalmist says the Lord is near to the brokenhearted. Religious visitors should bring listening, comfort, and practical help—not pressure, speculation about blame, or promises of a specific outcome. Pastoral prayer belongs alongside sound medical and mental-health support.</p><p><strong>Reflect:</strong> How can I accompany someone who is unwell without assuming I know what they need?</p><p><strong>Practice:</strong> Send a gentle check-in to someone facing illness or anxiety. Offer one specific, optional form of help.</p><p><strong>Prayer:</strong> God of compassion, strengthen the weary and guide us to care with wisdom. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 24,
    "value": "<p><strong>Read:</strong> Romans 8:38-39; 2 Corinthians 4:16-18</p><p><strong>Source and historical context:</strong> The Communion of the Sick section addresses serious illness, epidemics, and practical difficulty swallowing bread or wine. One rubric recognizes that physical incapacity does not separate someone from the benefits of Communion.</p><p><strong>Devotional focus:</strong> The bodily limitations of illness can interrupt familiar religious practices. They do not erase a person’s dignity or place in God’s love. Paul writes that nothing can separate believers from Christ. We can offer prayer and pastoral care with sensitivity to health, personal consent, and denominational practice rather than making fragile bodies carry spiritual guilt.</p><p><strong>Reflect:</strong> Have I unintentionally treated physical limitation as a failure of devotion?</p><p><strong>Practice:</strong> Ask how to include an ill or homebound member in community prayer or fellowship while respecting their health and choices.</p><p><strong>Prayer:</strong> God who stays near, hold us in love when ordinary practices become difficult. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 25,
    "value": "<p><strong>Read:</strong> John 11:25-26; Romans 12:15</p><p><strong>Source and historical context:</strong> The guide discusses visits during contagious illness and the burial service. Some historical restrictions concern people who died without baptism, under excommunication, or by suicide; these reflect the church rules and social assumptions of the period.</p><p><strong>Devotional focus:</strong> At Lazarus’s grave, Jesus spoke of resurrection and also wept. Christian hope does not require families to hide grief, and a person’s death should never be used as an occasion for speculation or shame. Those bereaved by suicide or other painful circumstances deserve especially tender care, practical support, and freedom to lament. The historical exclusions described here should not be mistaken for universal judgments about a person’s eternal fate.</p><p><strong>Reflect:</strong> How can I respond to bereavement without rushing to explain or correct someone’s sorrow?</p><p><strong>Practice:</strong> Reach out to a grieving person with a simple message of remembrance or an offer of practical support.</p><p><strong>Prayer:</strong> Christ of resurrection, meet mourners with compassion and sustain hope without silencing grief. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 26,
    "value": "<p><strong>Read:</strong> Psalm 116:1-9; Luke 18:9-14</p><p><strong>Source and historical context:</strong> This segment finishes the historical Thanksgiving of Women after Childbirth and proceeds to the Commination prayers for repentance. It even discusses what psalm to use when a newborn child has died, acknowledging joy and profound sorrow near the same service.</p><p><strong>Devotional focus:</strong> Human life is not tidy enough to fit one emotion at a time. Gratitude, exhaustion, relief, guilt, and grief may exist together. The psalms give language for being heard by God, and Jesus warns against prayer that congratulates itself by despising others. We can come as we are, asking for mercy without pretending that pain or repentance follows a schedule.</p><p><strong>Reflect:</strong> What feeling have I been told to hide in a moment when I needed prayer?</p><p><strong>Practice:</strong> Pray Psalm 116 thoughtfully, leaving space to name one gratitude and one grief without trying to resolve both today.</p><p><strong>Prayer:</strong> Merciful God, welcome our thanks and our tears, and teach us humility without humiliation. Amen.</p>"
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 27,
    "value": "<p><strong>Read:</strong> Micah 6:8; 1 Corinthians 14:40</p><p><strong>Source and historical context:</strong> The closing notes revisit old legal interpretations of vestments and marriage rubrics and even the proper cleansing of Communion vessels. The authors sought practical consistency across disputes about worship that mattered deeply in their Anglican context.</p><p><strong>Devotional focus:</strong> Details can carry reverence and history. They can also become an endless argument that forgets the people worship is meant to serve. Micah describes the life God seeks as justice, mercy, and humble walking. Thoughtful practice has its place when it supports these ends. Let us take care with traditions while refusing to measure another believer only by ceremonial precision.</p><p><strong>Reflect:</strong> Has attention to religious detail strengthened my love, or displaced it?</p><p><strong>Practice:</strong> Identify one meaningful tradition worth understanding better, and one act of mercy you can put into practice this week.</p><p><strong>Prayer:</strong> God of truth and mercy, let the care we give to worship bear fruit in justice and love. Amen.</p>"
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

-- Modify only plan-owned Scripture references. Never touch user-owned notes/references.
do $$
declare
  item jsonb;
  target_day_id uuid;
begin
  for item in select value from jsonb_array_elements($adapt_refs$
[
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 1,
    "references": [
      "Ephesians 4:1-6",
      "1 Corinthians 14:40"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 2,
    "references": [
      "Proverbs 15:22",
      "Colossians 3:16-17"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 3,
    "references": [
      "Ecclesiastes 3:1-8",
      "Romans 14:5-6"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 4,
    "references": [
      "1 Peter 2:4-5",
      "James 2:1-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 5,
    "references": [
      "Nehemiah 8:1-8",
      "1 Corinthians 14:9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 6,
    "references": [
      "1 John 1:8-9",
      "Psalm 51:10-12"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 7,
    "references": [
      "2 Timothy 3:16-17",
      "Luke 24:27-32"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 8,
    "references": [
      "Luke 1:46-55",
      "Luke 2:25-32"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 9,
    "references": [
      "Psalm 100:1-5",
      "Matthew 5:23-24"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 10,
    "references": [
      "Hebrews 10:24-25",
      "Luke 22:24-27"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 11,
    "references": [
      "1 Corinthians 14:26",
      "Mark 10:42-45"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 12,
    "references": [
      "James 2:14-17",
      "2 Corinthians 9:6-8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 13,
    "references": [
      "1 Corinthians 11:23-26",
      "Luke 22:19-20"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 14,
    "references": [
      "Hebrews 4:14-16",
      "1 Corinthians 11:28-29"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 15,
    "references": [
      "1 Corinthians 10:16-17",
      "Romans 14:19"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 16,
    "references": [
      "Acts 2:42-47",
      "1 Corinthians 12:12-13"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 17,
    "references": [
      "1 Corinthians 11:20-22",
      "James 2:1-5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 18,
    "references": [
      "Matthew 28:18-20",
      "Ephesians 4:4-6"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 19,
    "references": [
      "Mark 10:13-16",
      "Isaiah 43:1-3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 20,
    "references": [
      "Acts 8:26-39",
      "Ephesians 2:19-22"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 21,
    "references": [
      "Deuteronomy 6:6-7",
      "1 Peter 3:15-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 22,
    "references": [
      "Ephesians 5:21",
      "1 Corinthians 13:4-7"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 23,
    "references": [
      "James 5:13-16",
      "Psalm 34:17-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 24,
    "references": [
      "Romans 8:38-39",
      "2 Corinthians 4:16-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 25,
    "references": [
      "John 11:25-26",
      "Romans 12:15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 26,
    "references": [
      "Psalm 116:1-9",
      "Luke 18:9-14"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000355",
    "day_number": 27,
    "references": [
      "Micah 6:8",
      "1 Corinthians 14:40"
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
where id = '90000000-0000-0000-0000-000000000355'::uuid;

commit;
