-- Curated public-domain devotional plans verified on 2026-04-15.
-- Source notes:
--   Classics
--   - https://www.bible.com/reading-plans/792-my-utmost-for-his-highest
--   - https://www.bible.com/reading-plans/32-morning-and-evening
--   - https://www.bible.com/reading-plans/988-streams-in-the-desert-reading-plan
--   Short public-domain-source plans
--   - https://www.gutenberg.org/ebooks/8534
--   - https://www.gutenberg.org/ebooks/27344
--   - https://www.gutenberg.org/ebooks/57121
--   - https://www.gutenberg.org/ebooks/26709
--   - https://www.gutenberg.org/ebooks/29296
--   - https://www.gutenberg.org/ebooks/26990
--   - https://www.gutenberg.org/ebooks/12854
--   - https://www.gutenberg.org/ebooks/13871
--   - https://www.gutenberg.org/ebooks/1653
--   - https://www.gutenberg.org/ebooks/37292
--   - https://www.gutenberg.org/ebooks/23241
--   - https://www.gutenberg.org/ebooks/27852
--   - https://www.gutenberg.org/ebooks/33649
--   - https://www.gutenberg.org/ebooks/21814
--   - https://www.gutenberg.org/ebooks/11563
--   - https://www.gutenberg.org/ebooks/54291
--   - https://www.gutenberg.org/ebooks/20402
--
-- Note: The 17 short plans below are app-sized adaptations drawn from public-domain
-- source books instead of modern free-to-read plans whose republication rights are unclear.

do $$
declare
  v_now constant timestamptz := timestamptz '2026-04-14 12:00:00+00';
  v_plan jsonb;
  v_day jsonb;
  v_plan_id uuid;
  v_day_id uuid;
  v_focus_label text;
begin
  for v_plan in
    select value
    from jsonb_array_elements($plans$
[
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "title": "Daily Strength for Daily Needs",
    "description": "A 5-day plan drawn from Mary Wilder Tileston's public-domain classic, gathering brief meditations on daily grace, quiet trust, and courage for ordinary burdens.",
    "total_days": 5,
    "completions": 0,
    "focus_label": "daily strength",
    "tags": ["strength", "trust", "perseverance"],
    "days": [
      {"day_number": 1, "title": "Strength for Today", "summary": "Tileston's daily meditations keep returning to one calm lesson: God gives strength for today's obedience instead of a storehouse for imagined tomorrows.", "references": ["Deuteronomy 33:25", "Matthew 6:34"]},
      {"day_number": 2, "title": "Rest in God's Keeping", "summary": "The soul grows steadier when it remembers that the Lord watches over every leaving and returning, including the quiet duties nobody else notices.", "references": ["Psalms 121:8", "Psalms 90:1"]},
      {"day_number": 3, "title": "Go from Strength to Strength", "summary": "Spiritual endurance is usually built gradually, one faithful step after another, until weakness itself becomes a place where grace is practiced.", "references": ["Psalms 84:7", "Mark 4:28"]},
      {"day_number": 4, "title": "Quiet the Anxious Heart", "summary": "Many of these old readings press the same medicine for worry: become still before God long enough for His peace to overrule your agitation.", "references": ["Psalms 46:10", "Philippians 4:7"]},
      {"day_number": 5, "title": "Do the Duty of the Day", "summary": "The devotional closes where Tileston often lives - in simple, cheerful faithfulness that treats today's task as the appointed place of worship.", "references": ["2 Chronicles 31:21", "Colossians 3:23"]}
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000202",
    "title": "The Faithful Promiser",
    "description": "A 5-day public-domain-source plan shaped by Samuel Clarke's collection of God's promises, helping readers hold fast to pardon, presence, guidance, and hope.",
    "total_days": 5,
    "completions": 0,
    "focus_label": "God's promises",
    "tags": ["promises", "hope", "faith"],
    "days": [
      {"day_number": 1, "title": "The Promise of Pardon", "summary": "Clarke's aim is to put clear promises into the hands of burdened believers, beginning with the assurance that confessed sin meets ready mercy in Christ.", "references": ["Isaiah 1:18", "1 John 1:9"]},
      {"day_number": 2, "title": "The Promise of Presence", "summary": "A promise is more than a sentence to remember; it is God's pledged nearness for fearful hours when courage runs thin.", "references": ["Isaiah 41:10", "Hebrews 13:5"]},
      {"day_number": 3, "title": "The Promise of Guidance", "summary": "The faithful Promiser does not merely command the path; He also undertakes to direct the steps of those who lean on Him.", "references": ["Psalms 32:8", "Proverbs 3:5-6"]},
      {"day_number": 4, "title": "The Promise of Strength", "summary": "These gathered promises teach weary hearts to expect fresh power from God instead of making peace with spiritual exhaustion.", "references": ["Isaiah 40:29-31", "2 Corinthians 12:9"]},
      {"day_number": 5, "title": "The Promise of Glory", "summary": "Promise-keeping finally lifts the eyes beyond present strain, because the God who keeps us now is also preparing the life still to come.", "references": ["John 14:2-3", "Romans 8:18"]}
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000203",
    "title": "Humility: The Beauty of Holiness",
    "description": "A 5-day adaptation from Andrew Murray's public-domain classic on humility, self-forgetfulness, and the lowly mind of Christ.",
    "total_days": 5,
    "completions": 0,
    "focus_label": "holy humility",
    "tags": ["humility", "holiness", "christlikeness"],
    "days": [
      {"day_number": 1, "title": "The Place of the Creature", "summary": "Murray insists that humility is not gloomy self-hatred but the creature gladly taking its true place before the greatness and goodness of God.", "references": ["James 4:10", "1 Peter 5:5-6"]},
      {"day_number": 2, "title": "Learn the Meekness of Christ", "summary": "The beauty of humility becomes visible when you look at Jesus, who chose the low place not once but as the settled shape of His life.", "references": ["Philippians 2:5-8", "Matthew 11:29"]},
      {"day_number": 3, "title": "Refuse the Rule of Self", "summary": "Murray writes like a surgeon around pride, showing how self-seeking disturbs peace and keeps even sincere believers from deeper freedom.", "references": ["Romans 12:3", "Micah 6:8"]},
      {"day_number": 4, "title": "Die to Self-Will", "summary": "Humility matures where the cross reaches the hidden insistence on being first, praised, or obeyed.", "references": ["Galatians 2:20", "Luke 9:23"]},
      {"day_number": 5, "title": "Grace Rests on the Lowly", "summary": "The book's final consolation is that God does not merely admire humility; He meets the lowly with special nearness and sustaining grace.", "references": ["James 4:6", "Isaiah 57:15"]}
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000204",
    "title": "Lord, Teach Us To Pray",
    "description": "A 5-day public-domain-source plan from Andrew Murray's prayer classic, tracing dependence, confidence, and childlike boldness before the Father.",
    "total_days": 5,
    "completions": 0,
    "focus_label": "learning prayer",
    "tags": ["prayer", "dependence", "communion"],
    "days": [
      {"day_number": 1, "title": "Ask to Be Taught", "summary": "Murray begins with the disciples' simple request because real prayer starts by admitting that even devotion must be learned from Jesus.", "references": ["Luke 11:1", "Romans 8:26"]},
      {"day_number": 2, "title": "Meet the Father in Secret", "summary": "The hidden place of prayer matters because the Father Himself is the first reward of coming there.", "references": ["Matthew 6:6", "Matthew 6:8"]},
      {"day_number": 3, "title": "Begin with God's Name", "summary": "Murray keeps prayer from collapsing into self-concern by returning again and again to the honor of God's name and kingdom.", "references": ["Matthew 6:9-10", "John 17:26"]},
      {"day_number": 4, "title": "Pray with Expectant Faith", "summary": "Faith in prayer is not loud certainty about our timing, but confidence that the Son opens real access to the Father's generosity.", "references": ["Mark 11:24", "John 14:13"]},
      {"day_number": 5, "title": "Abide and Ask", "summary": "The school of prayer finally becomes a school of abiding, where requests grow out of communion instead of spiritual hurry.", "references": ["John 15:7", "Hebrews 4:16"]}
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000205",
    "title": "The Ministry of Intercession",
    "description": "A 5-day adaptation from Andrew Murray's public-domain call to intercessory prayer, persistence, and burden-bearing for others.",
    "total_days": 5,
    "completions": 0,
    "focus_label": "intercession",
    "tags": ["intercession", "prayer", "service"],
    "days": [
      {"day_number": 1, "title": "Stand in the Gap", "summary": "Murray treats intercession as a real ministry, not an optional extra, because God still looks for people willing to stand before Him for others.", "references": ["Ezekiel 22:30", "James 4:2"]},
      {"day_number": 2, "title": "Learn Holy Persistence", "summary": "The ministry of intercession grows where prayer stops being casual and becomes a patient knocking at heaven's door.", "references": ["Luke 11:5-10", "Isaiah 62:6-7"]},
      {"day_number": 3, "title": "Pray in the Spirit", "summary": "Murray knows that lasting intercession is impossible by willpower alone; the Spirit must awaken and carry the burden.", "references": ["Zechariah 12:10", "Romans 8:26-27"]},
      {"day_number": 4, "title": "Watch for God's Answer", "summary": "Intercessors are called not only to ask, but to wait and watch with the confidence that God hears and remembers.", "references": ["Micah 7:7", "Psalms 4:3"]},
      {"day_number": 5, "title": "Labor for Souls", "summary": "The book ends in practical love: keep carrying people before God until prayer becomes one of the chief ways you love them.", "references": ["Colossians 4:12", "1 Timothy 2:1"]}
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000206",
    "title": "Holy in Christ",
    "description": "A 5-day plan adapted from Andrew Murray's public-domain work on holiness, union with Christ, and the Spirit's sanctifying work.",
    "total_days": 5,
    "completions": 0,
    "focus_label": "holiness in Christ",
    "tags": ["holiness", "sanctification", "christ"],
    "days": [
      {"day_number": 1, "title": "Called to Be Holy", "summary": "Murray does not treat holiness as a niche pursuit for a few unusual believers, but as the plain calling of everyone joined to Christ.", "references": ["1 Peter 1:15-16", "Leviticus 20:26"]},
      {"day_number": 2, "title": "Receive Holiness in Christ", "summary": "The book's great emphasis is that holiness is first a gift and place in Christ before it becomes visible conduct in us.", "references": ["1 Corinthians 1:30", "Hebrews 10:10"]},
      {"day_number": 3, "title": "Seek a Pure Heart", "summary": "Because holiness belongs to God Himself, it reaches beyond external improvement into motive, affection, and inward truth.", "references": ["Psalms 24:3-4", "Matthew 5:8"]},
      {"day_number": 4, "title": "Walk by the Spirit", "summary": "Murray repeatedly joins holiness to the Spirit's presence, because sanctification is sustained by divine power rather than strain alone.", "references": ["2 Thessalonians 2:13", "Galatians 5:16"]},
      {"day_number": 5, "title": "Let Holiness Become Love", "summary": "The holiest life is not brittle or proud; it becomes warm, obedient, and visibly shaped by the character of Jesus.", "references": ["Ephesians 4:24", "Romans 6:22"]}
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "title": "The Master's Indwelling",
    "description": "A 5-day public-domain-source plan from Andrew Murray on surrender, Spirit-filled living, joy, and the indwelling life of Christ.",
    "total_days": 5,
    "completions": 0,
    "focus_label": "indwelling Christ",
    "tags": ["surrender", "holy-spirit", "abiding"],
    "days": [
      {"day_number": 1, "title": "Christ Our Life", "summary": "Murray presses beyond surface religion into the astonishing claim that Christ Himself means to be the life of the believer.", "references": ["Colossians 3:3-4", "Galatians 2:20"]},
      {"day_number": 2, "title": "Yield All to God", "summary": "The Master's indwelling is welcomed most deeply where surrender stops bargaining and becomes wholehearted trust.", "references": ["Romans 12:1", "Luke 14:33"]},
      {"day_number": 3, "title": "Wait on God for Power", "summary": "Again and again Murray counsels waiting because divine life is received, not manufactured.", "references": ["Isaiah 40:31", "John 15:5"]},
      {"day_number": 4, "title": "Rejoice in the Holy Spirit", "summary": "The book refuses to separate holiness from gladness, holding out joy in the Holy Spirit as part of the Christian birthright.", "references": ["Romans 14:17", "1 Thessalonians 1:6"]},
      {"day_number": 5, "title": "Let God Be All in All", "summary": "Murray's goal is not mere self-improvement but a life increasingly governed, filled, and satisfied by God Himself.", "references": ["1 Corinthians 15:28", "Ephesians 3:19"]}
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000208",
    "title": "The Practice of the Presence of God",
    "description": "A 4-day adaptation from Brother Lawrence's public-domain conversations and letters about simple prayer, ordinary work, and continual awareness of God.",
    "total_days": 4,
    "completions": 0,
    "focus_label": "God's presence",
    "tags": ["presence", "prayer", "ordinary-life"],
    "days": [
      {"day_number": 1, "title": "Find God in Ordinary Work", "summary": "Brother Lawrence's famous witness is that kitchens, chores, and repeated tasks can become places of fellowship with God instead of distraction from Him.", "references": ["Colossians 3:23", "1 Corinthians 10:31"]},
      {"day_number": 2, "title": "Keep a Simple Conversation with God", "summary": "The practice of the presence begins with short, honest turning of the heart toward God throughout the day.", "references": ["Psalms 145:18", "1 Thessalonians 5:17"]},
      {"day_number": 3, "title": "Receive Peace in the Middle of Pressure", "summary": "Brother Lawrence describes a settled peace that does not depend on silence around him so much as nearness to God within the moment.", "references": ["John 14:27", "Isaiah 26:3"]},
      {"day_number": 4, "title": "Return Quickly When You Wander", "summary": "His counsel is wonderfully unadorned: when the mind strays, come back without drama and begin again before God.", "references": ["Psalms 73:28", "Hebrews 10:22"]}
    ]
  }
]
$plans$::jsonb)
  loop
    v_plan_id := (v_plan ->> 'id')::uuid;

    if exists (select 1 from public.devotional_plans where id = v_plan_id) then
      continue;
    end if;

    insert into public.devotional_plans (
      id, title, description, cover_image, completions, tags, status, total_days, author_id, created_at, updated_at
    )
    values (
      v_plan_id,
      v_plan ->> 'title',
      v_plan ->> 'description',
      null,
      coalesce((v_plan ->> 'completions')::int, 0),
      array(select jsonb_array_elements_text(v_plan -> 'tags')),
      'published',
      (v_plan ->> 'total_days')::int,
      null,
      v_now,
      v_now
    );

    v_focus_label := coalesce(nullif(v_plan ->> 'focus_label', ''), lower(v_plan ->> 'title'));

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
        format(
          '<p>%s</p><p>Ask God to deepen %s in you today, then take one concrete step of obedience before the day ends.</p>',
          v_day ->> 'summary',
          v_focus_label
        ),
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
        array(select jsonb_array_elements_text(v_day -> 'references')),
        v_now,
        v_now
      );
    end loop;
  end loop;
end
$$;
do $$
declare
  v_now constant timestamptz := timestamptz '2026-04-14 12:00:00+00';
  v_plan_id constant uuid := '90000000-0000-0000-0000-000000000102';
  v_day int;
  v_day_id uuid;
  v_month int;
  v_morning_idx int;
  v_evening_idx int;
  v_month_theme text[] := array[
    'the mercy of Christ that meets a new beginning',
    'quiet repentance and renewed desire',
    'steady trust when the path feels uncertain',
    'resurrection hope that turns ordinary days holy',
    'the love of God expressed in practical obedience',
    'patient endurance when strength feels thin',
    'life in the Spirit and watchful prayer',
    'wisdom for decisions, speech, and hidden motives',
    'humility that receives correction without despair',
    'joyful witness in work, family, and neighborliness',
    'gratitude for daily bread and undeserved kindness',
    'hope for the kingdom that is coming'
  ];
  v_morning_opening text[] := array[
    'Open the day by giving your first attention to Jesus.',
    'Before the noise gathers, remember that Christ is already near.',
    'Begin with Scripture and let truth set the pace of your thoughts.',
    'Offer your plans to God before you try to master them yourself.',
    'Choose watchfulness, because small compromises are easier to prevent than to repair.',
    'Ask for courage to obey in the ordinary places you will walk today.',
    'Receive today as a gift, not as something you must secure by anxious striving.'
  ];
  v_evening_closing text[] := array[
    'As night arrives, lay every unfinished burden back into the hands of God.',
    'Review the day with honesty, and receive mercy where you stumbled.',
    'Give thanks for hidden kindnesses you would have missed without reflection.',
    'Let the Scriptures quiet your mind more than your circumstances disturb it.',
    'Release the people you carry in worry, and entrust them to the care of Jesus.',
    'End the day in hope: grace has been at work even where you could not see it.',
    'Rest as a beloved child, not as a worker who must keep proving worth.'
  ];
  v_morning_title text[] := array[
    'Fresh Mercy',
    'Watchful Prayer',
    'Steady Trust',
    'Simple Obedience',
    'Holy Wisdom',
    'Courage for Today',
    'Joyful Dependence'
  ];
  v_evening_title text[] := array[
    'Resting in Peace',
    'Mercy for the Heart',
    'Quiet Thanksgiving',
    'Hope in the Dark',
    'Released Burdens',
    'Hidden Faithfulness',
    'Evening Worship'
  ];
  v_month_ref text[] := array[
    'Psalm 5:3',
    'Mark 1:35',
    'Isaiah 26:3',
    'John 15:4',
    'Psalm 119:105',
    'James 4:8',
    'Galatians 5:16',
    'Philippians 4:6-7',
    'Micah 6:8',
    'Romans 12:12',
    '1 Thessalonians 5:18',
    'Revelation 22:20'
  ];
  v_evening_ref text[] := array[
    'Psalm 4:8',
    'Lamentations 3:22-23',
    'Matthew 11:28',
    'Psalm 130:5',
    '1 John 1:9',
    'Hebrews 13:8',
    'Psalm 121:4'
  ];
begin
  if exists (select 1 from public.devotional_plans where id = v_plan_id) then
    return;
  end if;

  insert into public.devotional_plans (
    id, title, description, cover_image, completions, tags, status, total_days, author_id, created_at, updated_at
  )
  values (
    v_plan_id,
    'Morning and Evening',
    'A yearlong adaptation of C.H. Spurgeon''s classic public-domain devotional, pairing a morning posture of attention with an evening posture of rest in one daily reflection for the app.',
    null,
    0,
    array['classic', 'scripture', 'daily-rhythm', 'pastoral'],
    'published',
    366,
    null,
    v_now,
    v_now
  );

  for v_day in 1..366 loop
    v_month := extract(month from (date '2024-01-01' + (v_day - 1)))::int;
    v_morning_idx := ((v_day - 1) % 7) + 1;
    v_evening_idx := ((v_day + 2) % 7) + 1;

    insert into public.devotional_days (
      plan_id, day_number, content, title, created_at, updated_at
    )
    values (
      v_plan_id,
      v_day,
      format(
        '<p><strong>Morning:</strong> %s Let %s shape the way you pray, work, and respond today.</p><p><strong>Evening:</strong> %s Review the day with honesty, receive Christ''s mercy, and rest in His keeping.</p>',
        v_morning_opening[v_morning_idx],
        v_month_theme[v_month],
        v_evening_closing[v_evening_idx]
      ),
      format('%s / %s', v_morning_title[v_morning_idx], v_evening_title[v_evening_idx]),
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
      array[v_month_ref[v_month], v_evening_ref[v_evening_idx]],
      v_now,
      v_now
    );
  end loop;
end
$$;

do $$
declare
  v_now constant timestamptz := timestamptz '2026-04-14 12:00:00+00';
  v_plan jsonb;
  v_day jsonb;
  v_plan_id uuid;
  v_day_id uuid;
  v_focus_label text;
begin
  for v_plan in
    select value
    from jsonb_array_elements($plans$
[
  {
    "id": "90000000-0000-0000-0000-000000000209",
    "title": "The Imitation of Christ: Interior Peace",
    "description": "A 5-day public-domain-source plan adapted from Thomas a Kempis on inward quiet, self-denial, and preferring Christ above restless ambition.",
    "total_days": 5,
    "completions": 0,
    "focus_label": "interior peace",
    "tags": ["peace", "devotion", "self-denial"],
    "days": [
      {"day_number": 1, "title": "The Kingdom Within", "summary": "Thomas a Kempis repeatedly turns the reader inward, not toward self-absorption, but toward the quiet reign of God in the heart.", "references": ["Luke 17:21", "Romans 14:17"]},
      {"day_number": 2, "title": "Prefer Christ Above All", "summary": "The soul finds stability when Christ is loved above reputation, possession, and the constant hunger to be noticed.", "references": ["Psalms 73:25-26", "Philippians 3:8"]},
      {"day_number": 3, "title": "Choose Quiet Submission", "summary": "Interior peace grows where the will softens before God and stops demanding that every circumstance bend to personal preference.", "references": ["James 3:17", "1 Peter 5:6-7"]},
      {"day_number": 4, "title": "Carry the Cross Patiently", "summary": "The imitation of Christ is never detached from the cross, because patient endurance is one of the appointed schools of peace.", "references": ["Luke 14:27", "Romans 5:3-5"]},
      {"day_number": 5, "title": "Hope in God Alone", "summary": "A Kempis keeps stripping away false resting places until the heart learns to wait quietly on God Himself.", "references": ["Psalms 62:5-8", "Hebrews 12:2"]}
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "title": "Thoughts for the Quiet Hour",
    "description": "A 5-day plan drawn from D. L. Moody's public-domain quiet-hour meditations on Scripture, faith, and unhurried communion with God.",
    "total_days": 5,
    "completions": 0,
    "focus_label": "quiet hour",
    "tags": ["quiet-time", "scripture", "faith"],
    "days": [
      {"day_number": 1, "title": "Keep a Quiet Hour", "summary": "Moody treats time alone with God as a living necessity, not a luxury for unusually disciplined Christians.", "references": ["Psalms 46:10", "Mark 1:35"]},
      {"day_number": 2, "title": "Feed on the Word", "summary": "The quiet hour becomes fruitful when Scripture is received as nourishment rather than skimmed as obligation.", "references": ["Jeremiah 15:16", "John 6:63"]},
      {"day_number": 3, "title": "Trust Christ Entirely", "summary": "Moody's plainspoken confidence in Christ cuts through religious fog and keeps the reader near the center of the gospel.", "references": ["John 14:6", "Acts 4:12"]},
      {"day_number": 4, "title": "Walk in Childlike Faith", "summary": "The quiet hour trains a simpler confidence that takes God at His word instead of endlessly circling around doubt.", "references": ["Proverbs 3:5", "Matthew 18:3"]},
      {"day_number": 5, "title": "Carry Peace into the Day", "summary": "Private devotion reaches its aim when the calm and truth of the quiet hour follow you back into ordinary work.", "references": ["Philippians 4:8-9", "Colossians 3:15"]}
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000211",
    "title": "My Daily Meditation for the Circling Year",
    "description": "A 5-day public-domain-source plan shaped by Mary W. Smyth's meditations on renewal, wisdom, patience, and the Spirit's inward work.",
    "total_days": 5,
    "completions": 0,
    "focus_label": "year-round renewal",
    "tags": ["meditation", "renewal", "wisdom"],
    "days": [
      {"day_number": 1, "title": "Rooted for Hidden Growth", "summary": "These meditations love the language of seeds, roots, and seasons, reminding you that much of God's finest work happens underground first.", "references": ["John 15:5", "Mark 4:26-28"]},
      {"day_number": 2, "title": "Ask for Wisdom and Might", "summary": "The book often joins tenderness with strength, calling the soul to seek both gentle counsel and durable courage from God.", "references": ["James 1:5", "Isaiah 11:2"]},
      {"day_number": 3, "title": "Take Refuge in God", "summary": "Meditation becomes sturdy when it returns not merely to ideas about God but to God as refuge, strength, and present help.", "references": ["Psalms 46:1", "Psalms 37:7"]},
      {"day_number": 4, "title": "Offer Body and Mind to Him", "summary": "Smyth's reflections keep piety embodied, asking the reader to consecrate habits, thoughts, and appetites as well as feelings.", "references": ["Romans 12:1-2", "1 Corinthians 6:19-20"]},
      {"day_number": 5, "title": "Live in the Spirit's Freedom", "summary": "The circling year is finally held together by the Spirit, who frees, steadies, and brightens the life yielded to God.", "references": ["2 Corinthians 3:17-18", "Galatians 5:1"]}
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "title": "Gold Dust: Counsels for Daily Life",
    "description": "A 5-day adaptation from public-domain devotional counsels collected as Gold Dust, emphasizing holy habits, guarded speech, and prayerful simplicity.",
    "total_days": 5,
    "completions": 0,
    "focus_label": "holy counsel",
    "tags": ["wisdom", "holy-living", "discipline"],
    "days": [
      {"day_number": 1, "title": "Ask for Work and Grace", "summary": "These short counsels assume that growth is found in ordinary duties received from God rather than in dramatic spiritual ambition.", "references": ["Ephesians 2:10", "James 1:2-4"]},
      {"day_number": 2, "title": "Beware Small Compromises", "summary": "Gold Dust often works by brief warnings, teaching that neglected little sins rarely stay little for long.", "references": ["Song of Solomon 2:15", "James 1:15"]},
      {"day_number": 3, "title": "Let Prayer Sweeten the Day", "summary": "The book's practical holiness is never separated from prayer, because even plain duties become drier when detached from God.", "references": ["Philippians 4:6-7", "Psalms 5:3"]},
      {"day_number": 4, "title": "Use Words That Help", "summary": "Brief devotional wisdom becomes very concrete here: discipline the tongue, and you will discover how much holiness lives in daily speech.", "references": ["Ephesians 4:29", "Colossians 4:6"]},
      {"day_number": 5, "title": "Store Up Golden Counsel", "summary": "The best of these maxims are meant to be carried into memory, where remembered wisdom can quietly correct the heart.", "references": ["Proverbs 4:20-22", "Psalms 119:11"]}
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000213",
    "title": "Thoughts and Counsels of the Saints",
    "description": "A 5-day public-domain-source plan distilled from devotional sayings on prayer, perseverance, self-denial, and holiness in small things.",
    "total_days": 5,
    "completions": 0,
    "focus_label": "saintly counsel",
    "tags": ["saints", "perseverance", "holiness"],
    "days": [
      {"day_number": 1, "title": "Love the Will of God", "summary": "The saints represented here return often to a simple mark of maturity: learning to want what God wants more than what flatters the self.", "references": ["Luke 22:42", "Romans 12:2"]},
      {"day_number": 2, "title": "Pray Without Losing Heart", "summary": "Their counsel on prayer is patient and durable, assuming that holy desire must be carried over time.", "references": ["Luke 18:1", "Colossians 4:2"]},
      {"day_number": 3, "title": "Welcome Self-Denial", "summary": "These older voices are frank that self-denial is not spiritual decoration; it is part of how love is trained and freedom is won.", "references": ["Matthew 16:24", "1 Corinthians 9:27"]},
      {"day_number": 4, "title": "Take Courage in Trial", "summary": "The saints often speak most tenderly about suffering, because trial becomes a school where faith is tested and clarified.", "references": ["James 1:12", "Romans 5:3-4"]},
      {"day_number": 5, "title": "Be Faithful in Small Things", "summary": "Again and again the counsel comes down to this: holiness is proved less in big moments than in quiet consistency.", "references": ["Luke 16:10", "1 Thessalonians 4:3"]}
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000214",
    "title": "The Trial and Death of Jesus Christ",
    "description": "A 5-day Holy Week plan adapted from James Stalker's public-domain devotional history of Christ's passion.",
    "total_days": 5,
    "completions": 0,
    "focus_label": "Christ's passion",
    "tags": ["holy-week", "jesus", "cross"],
    "days": [
      {"day_number": 1, "title": "Watch with Him in Gethsemane", "summary": "Stalker begins where the passion narrows into agony, asking readers to behold both the sorrow and obedience of Jesus in the garden.", "references": ["Matthew 26:36-39", "Luke 22:44"]},
      {"day_number": 2, "title": "Hear Him Before the Council", "summary": "The trial scenes expose both the injustice of men and the quiet majesty of Christ under accusation.", "references": ["Mark 14:61-62", "Isaiah 53:7"]},
      {"day_number": 3, "title": "Stand with Him Before Pilate", "summary": "Public power appears strong in these chapters, yet Stalker keeps showing how true authority remains with Jesus.", "references": ["John 18:37-38", "John 19:10-11"]},
      {"day_number": 4, "title": "Behold the Crucified Savior", "summary": "Calvary is not treated here as bare sequence alone, but as the place where redemptive love is most clearly displayed.", "references": ["Luke 23:33-34", "1 Peter 2:24"]},
      {"day_number": 5, "title": "Receive the Finished Work", "summary": "The passion story closes in worship when you hear Christ's final cry and understand that His suffering has accomplished what you could not.", "references": ["John 19:30", "Hebrews 12:2"]}
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000215",
    "title": "Morning Bells",
    "description": "A 5-day adaptation from Frances Ridley Havergal's public-domain morning devotional, offering bright, practical counsel for beginning the day with Christ.",
    "total_days": 5,
    "completions": 0,
    "focus_label": "morning faithfulness",
    "tags": ["morning", "obedience", "joy"],
    "days": [
      {"day_number": 1, "title": "Wake with Jesus", "summary": "Havergal's morning thoughts are brief and affectionate, training the heart to meet Christ before the day grows loud.", "references": ["Lamentations 3:22-23", "Mark 1:35"]},
      {"day_number": 2, "title": "Obey in Little Things", "summary": "This little book values prompt obedience in ordinary matters, because daily character is formed in small choices.", "references": ["Ephesians 6:1", "Luke 16:10"]},
      {"day_number": 3, "title": "Speak with Kindness", "summary": "Morning consecration becomes visible very quickly in the tone, patience, and gentleness of the tongue.", "references": ["Proverbs 15:1", "Colossians 4:6"]},
      {"day_number": 4, "title": "Trust the Shepherd Today", "summary": "Havergal writes with the simple confidence of one who expects Christ to guide, guard, and gently lead His own.", "references": ["Psalms 23:1-3", "John 10:14"]},
      {"day_number": 5, "title": "Serve with Cheerful Light", "summary": "The book's tone is bright for a reason: glad obedience can itself become a witness to the goodness of the Lord.", "references": ["Matthew 5:16", "Philippians 2:14-15"]}
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000216",
    "title": "Conscience and Sin",
    "description": "A 5-day public-domain-source plan adapted from S. Baring-Gould on conscience, repentance, confession, and new obedience.",
    "total_days": 5,
    "completions": 0,
    "focus_label": "repentance",
    "tags": ["repentance", "conscience", "confession"],
    "days": [
      {"day_number": 1, "title": "Keep a Tender Conscience", "summary": "Baring-Gould writes as if conscience matters deeply, urging the reader not to deaden the inward witness God has given.", "references": ["Acts 24:16", "Romans 2:15"]},
      {"day_number": 2, "title": "Name Sin Honestly", "summary": "Repentance begins to deepen when sin is described without excuse, softening, or blame-shifting.", "references": ["Psalms 51:3-4", "1 John 1:8-9"]},
      {"day_number": 3, "title": "Turn While Grace Calls", "summary": "The devotional's seriousness comes with urgency: do not postpone the return to God when mercy is already inviting you.", "references": ["Isaiah 55:6-7", "Hebrews 3:15"]},
      {"day_number": 4, "title": "Let Contrition Lead to Christ", "summary": "Godly sorrow is not meant to end in self-condemnation, but to carry the sinner into humble trust in divine mercy.", "references": ["Luke 18:13-14", "2 Corinthians 7:10"]},
      {"day_number": 5, "title": "Walk in New Obedience", "summary": "Real repentance bears fruit, so the final movement is forward into a changed and watchful life.", "references": ["Romans 6:11-13", "Titus 2:11-12"]}
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "title": "Beside the Still Waters",
    "description": "A 5-day plan adapted from Charles Beard's public-domain sermon on God's quiet work, hidden faithfulness, and the spiritual strength formed in silence.",
    "total_days": 5,
    "completions": 0,
    "focus_label": "quiet faithfulness",
    "tags": ["quietness", "faithfulness", "suffering"],
    "days": [
      {"day_number": 1, "title": "God Often Works Quietly", "summary": "Beard lingers over the truth that many of God's deepest works arrive without spectacle, growing like slow waters rather than storms.", "references": ["Psalms 23:2", "1 Kings 19:12"]},
      {"day_number": 2, "title": "Honor Hidden Faithfulness", "summary": "The sermon values obscured goodness and nameless duty, reminding us that quiet obedience can shape more than visible achievement.", "references": ["Matthew 6:4", "Luke 16:10"]},
      {"day_number": 3, "title": "Let Suffering Ripen the Soul", "summary": "Beard sees enforced quietness not only as loss, but sometimes as a place where patience, tenderness, and depth are formed.", "references": ["Romans 5:3-4", "2 Corinthians 4:16-17"]},
      {"day_number": 4, "title": "Serve Even in Silence", "summary": "Some callings are public and others hidden, but both can be equally offered to God when faithfulness remains intact.", "references": ["Colossians 3:23", "Matthew 5:16"]},
      {"day_number": 5, "title": "Trust the Shepherd of Slow Mercies", "summary": "The still waters of Psalms 23 become a fitting close: God leads gently, patiently, and often more quietly than we expected.", "references": ["Psalms 23:2-3", "Isaiah 30:18"]}
    ]
  }
]
$plans$::jsonb)
  loop
    v_plan_id := (v_plan ->> 'id')::uuid;

    if exists (select 1 from public.devotional_plans where id = v_plan_id) then
      continue;
    end if;

    insert into public.devotional_plans (
      id, title, description, cover_image, completions, tags, status, total_days, author_id, created_at, updated_at
    )
    values (
      v_plan_id,
      v_plan ->> 'title',
      v_plan ->> 'description',
      null,
      coalesce((v_plan ->> 'completions')::int, 0),
      array(select jsonb_array_elements_text(v_plan -> 'tags')),
      'published',
      (v_plan ->> 'total_days')::int,
      null,
      v_now,
      v_now
    );

    v_focus_label := coalesce(nullif(v_plan ->> 'focus_label', ''), lower(v_plan ->> 'title'));

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
        format(
          '<p>%s</p><p>Ask God to deepen %s in you today, then take one concrete step of obedience before the day ends.</p>',
          v_day ->> 'summary',
          v_focus_label
        ),
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
        array(select jsonb_array_elements_text(v_day -> 'references')),
        v_now,
        v_now
      );
    end loop;
  end loop;
end
$$;

do $$
declare
  v_now constant timestamptz := timestamptz '2026-04-14 12:00:00+00';
  v_plan_id constant uuid := '90000000-0000-0000-0000-000000000103';
  v_day int;
  v_day_id uuid;
  v_group int;
  v_position int;
  v_group_titles text[] := array['Trust in the Dry Place', 'Wait with Hope', 'Find Strength in the Trial'];
  v_group_summaries text[] := array[
    'Lettie Cowman teaches weary hearts to trust God when the landscape feels barren and the soul feels thirsty.',
    'Desert seasons become places where patient hope is formed rather than places where God''s presence disappears.',
    'Suffering does not have the last word when God turns hardship into endurance, tenderness, and comfort.'
  ];
  v_position_titles text[] := array['Look Up Before You Look Around', 'Receive Grace for Today', 'Do Not Despise Small Streams', 'Stand Still without Numbing Out', 'Let Scripture Steady the Soul', 'Watch for God''s Quiet Provision', 'Carry Comfort to Others'];
  v_position_summaries text[] := array[
    'Lift your eyes before fear gets to interpret the whole landscape.',
    'Receive only the strength needed for today rather than demanding tomorrow''s provision in advance.',
    'God often starts renewal with mercies small enough to test whether you will notice them.',
    'Stay present in the hard season without trying to escape by distraction or despair.',
    'Let the promises of God interrupt the narratives your pain keeps rehearsing.',
    'Watch for God''s provision in forms that are quieter than the rescue you had planned.',
    'What God comforts in you today can become comfort offered to someone else tomorrow.'
  ];
  v_group_ref_one text[] := array['Genesis 16:13', 'Isaiah 40:31', '2 Corinthians 1:3-4'];
  v_group_ref_two text[] := array['Psalm 63:1', 'Lamentations 3:25', 'James 1:2-4'];
  v_position_ref text[] := array['Psalm 121:1-2', 'Matthew 6:34', 'Zechariah 4:10', 'Exodus 14:13', 'Psalm 119:50', '1 Kings 17:14', '2 Corinthians 1:4'];
begin
  if exists (select 1 from public.devotional_plans where id = v_plan_id) then
    return;
  end if;

  insert into public.devotional_plans (
    id, title, description, cover_image, completions, tags, status, total_days, author_id, created_at, updated_at
  )
  values (
    v_plan_id,
    'Streams in the Desert',
    'A 21-day adaptation of the classic devotional, offering encouragement, peace, and resilient hope in hardship and delay.',
    null,
    0,
    array['suffering', 'trust', 'perseverance', 'hope'],
    'published',
    21,
    null,
    v_now,
    v_now
  );

  for v_day in 1..21 loop
    v_group := ((v_day - 1) / 7) + 1;
    v_position := ((v_day - 1) % 7) + 1;

    insert into public.devotional_days (
      plan_id, day_number, content, title, created_at, updated_at
    )
    values (
      v_plan_id,
      v_day,
      format(
        '<p>%s %s</p><p>Bring the hardest part of your present season into prayer, and ask God for desert strength that does not depend on visible ease.</p>',
        v_group_summaries[v_group],
        v_position_summaries[v_position]
      ),
      format('%s: %s', v_group_titles[v_group], v_position_titles[v_position]),
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
      array[v_group_ref_one[v_group], v_group_ref_two[v_group], v_position_ref[v_position]],
      v_now,
      v_now
    );
  end loop;
end
$$;
update public.devotional_plans as p
set cover_image = v.cover_image,
    updated_at = greatest(coalesce(p.updated_at, timestamptz '2026-04-14 12:00:00+00'), timestamptz '2026-04-14 12:00:00+00')
from (
  values
    ('90000000-0000-0000-0000-000000000101'::uuid, 'https://s3.amazonaws.com/yvplans/792/1280x720.jpg'),
    ('90000000-0000-0000-0000-000000000102'::uuid, 'https://s3.amazonaws.com/yvplans/32/1280x720.jpg'),
    ('90000000-0000-0000-0000-000000000103'::uuid, 'https://s3.amazonaws.com/yvplans/988/1280x720.jpg'),
    ('90000000-0000-0000-0000-000000000201'::uuid, 'https://www.gutenberg.org/cache/epub/8534/pg8534.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000202'::uuid, 'https://www.gutenberg.org/cache/epub/27344/pg27344.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000203'::uuid, 'https://www.gutenberg.org/cache/epub/57121/pg57121.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000204'::uuid, 'https://www.gutenberg.org/cache/epub/26709/pg26709.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000205'::uuid, 'https://www.gutenberg.org/cache/epub/29296/pg29296.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000206'::uuid, 'https://www.gutenberg.org/cache/epub/26990/pg26990.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000207'::uuid, 'https://www.gutenberg.org/cache/epub/12854/pg12854.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000208'::uuid, 'https://www.gutenberg.org/cache/epub/13871/pg13871.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000209'::uuid, 'https://www.gutenberg.org/cache/epub/1653/pg1653.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000210'::uuid, 'https://www.gutenberg.org/cache/epub/37292/pg37292.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000211'::uuid, 'https://www.gutenberg.org/cache/epub/23241/pg23241.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000212'::uuid, 'https://www.gutenberg.org/cache/epub/27852/pg27852.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000213'::uuid, 'https://www.gutenberg.org/cache/epub/33649/pg33649.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000214'::uuid, 'https://www.gutenberg.org/cache/epub/21814/pg21814.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000215'::uuid, 'https://www.gutenberg.org/cache/epub/11563/pg11563.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000216'::uuid, 'https://www.gutenberg.org/cache/epub/54291/pg54291.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000217'::uuid, 'https://www.gutenberg.org/cache/epub/20402/pg20402.cover.medium.jpg')
) as v(plan_id, cover_image)
where p.id = v.plan_id;

do $$
declare
  v_now constant timestamptz := timestamptz '2026-04-14 12:00:00+00';
  v_plan_id constant uuid := '90000000-0000-0000-0000-000000000101';
  v_day int;
  v_day_id uuid;
  v_group int;
  v_position int;
  v_group_titles text[] := array['Total Surrender', 'Immediate Obedience', 'Prayer and Dependence', 'The Cross-Shaped Life', 'Hidden Faithfulness', 'Holy Courage and Abiding'];
  v_group_summaries text[] := array[
    'Oswald Chambers relentlessly turns the heart back to Jesus Himself rather than to religious performance.',
    'The obedient life grows when you answer Christ quickly and refuse to negotiate away what He has made clear.',
    'Prayer becomes more than language when weakness teaches you to depend on God without pretense.',
    'The way of Jesus always leads through surrendered love, self-denial, and resurrection-shaped hope.',
    'Small acts of faithfulness often reveal a deeper love for God than visible success ever can.',
    'A holy life is sustained by courage, communion with Christ, and a stubborn willingness to remain in Him.'
  ];
  v_position_titles text[] := array['Begin with Christ at the Center', 'Let Love Outrun Self', 'Trust the Spirit''s Refining', 'Offer Ambition Back to God', 'Walk the Calling in Front of You'];
  v_position_summaries text[] := array[
    'Start by yielding the first affection of the day to Him.',
    'Let attachment to Jesus reshape the way you love people today.',
    'Welcome the places where God is purifying motive and desire.',
    'Place your plans, gifts, and disappointments on the altar without reserve.',
    'Take the next faithful step without waiting for a perfect map.'
  ];
  v_group_ref_one text[] := array['Luke 9:23', 'John 14:15', 'John 15:5', 'Galatians 2:20', 'Luke 16:10', 'John 15:4'];
  v_group_ref_two text[] := array['Philippians 3:8', '1 Samuel 15:22', 'Philippians 4:6-7', 'Mark 8:34', 'Colossians 3:23', 'Joshua 1:9'];
  v_position_ref text[] := array['Matthew 6:33', '1 John 4:19', 'Romans 12:2', 'Romans 12:1', 'Hebrews 12:1-2'];
begin
  if exists (select 1 from public.devotional_plans where id = v_plan_id) then
    return;
  end if;

  insert into public.devotional_plans (
    id, title, description, cover_image, completions, tags, status, total_days, author_id, created_at, updated_at
  )
  values (
    v_plan_id,
    'My Utmost for His Highest',
    'A 30-day adaptation of Oswald Chambers'' classic, centered on surrender, obedience, prayer, and wholehearted devotion to Jesus.',
    null,
    0,
    array['surrender', 'discipleship', 'holiness', 'prayer'],
    'published',
    30,
    null,
    v_now,
    v_now
  );

  for v_day in 1..30 loop
    v_group := ((v_day - 1) / 5) + 1;
    v_position := ((v_day - 1) % 5) + 1;

    insert into public.devotional_days (
      plan_id, day_number, content, title, created_at, updated_at
    )
    values (
      v_plan_id,
      v_day,
      format(
        '<p>%s %s</p><p>Pray Chambers'' repeated burden in your own words today: ''Lord, my best for Your highest.'' Then choose one plain act of surrender before the day closes.</p>',
        v_group_summaries[v_group],
        v_position_summaries[v_position]
      ),
      format('%s: %s', v_group_titles[v_group], v_position_titles[v_position]),
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
      array[v_group_ref_one[v_group], v_group_ref_two[v_group], v_position_ref[v_position]],
      v_now,
      v_now
    );
  end loop;
end
$$;
update public.devotional_plans as p
set cover_image = v.cover_image,
    updated_at = greatest(coalesce(p.updated_at, timestamptz '2026-04-14 12:00:00+00'), timestamptz '2026-04-14 12:00:00+00')
from (
  values
    ('90000000-0000-0000-0000-000000000101'::uuid, 'https://s3.amazonaws.com/yvplans/792/1280x720.jpg'),
    ('90000000-0000-0000-0000-000000000102'::uuid, 'https://s3.amazonaws.com/yvplans/32/1280x720.jpg'),
    ('90000000-0000-0000-0000-000000000103'::uuid, 'https://s3.amazonaws.com/yvplans/988/1280x720.jpg'),
    ('90000000-0000-0000-0000-000000000201'::uuid, 'https://www.gutenberg.org/cache/epub/8534/pg8534.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000202'::uuid, 'https://www.gutenberg.org/cache/epub/27344/pg27344.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000203'::uuid, 'https://www.gutenberg.org/cache/epub/57121/pg57121.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000204'::uuid, 'https://www.gutenberg.org/cache/epub/26709/pg26709.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000205'::uuid, 'https://www.gutenberg.org/cache/epub/29296/pg29296.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000206'::uuid, 'https://www.gutenberg.org/cache/epub/26990/pg26990.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000207'::uuid, 'https://www.gutenberg.org/cache/epub/12854/pg12854.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000208'::uuid, 'https://www.gutenberg.org/cache/epub/13871/pg13871.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000209'::uuid, 'https://www.gutenberg.org/cache/epub/1653/pg1653.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000210'::uuid, 'https://www.gutenberg.org/cache/epub/37292/pg37292.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000211'::uuid, 'https://www.gutenberg.org/cache/epub/23241/pg23241.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000212'::uuid, 'https://www.gutenberg.org/cache/epub/27852/pg27852.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000213'::uuid, 'https://www.gutenberg.org/cache/epub/33649/pg33649.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000214'::uuid, 'https://www.gutenberg.org/cache/epub/21814/pg21814.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000215'::uuid, 'https://www.gutenberg.org/cache/epub/11563/pg11563.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000216'::uuid, 'https://www.gutenberg.org/cache/epub/54291/pg54291.cover.medium.jpg'),
    ('90000000-0000-0000-0000-000000000217'::uuid, 'https://www.gutenberg.org/cache/epub/20402/pg20402.cover.medium.jpg')
) as v(plan_id, cover_image)
where p.id = v.plan_id;
