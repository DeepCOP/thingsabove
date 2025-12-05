-- ===============================================
--  SEED DEVOTIONAL PLANS + DAYS + SCRIPTURE
-- ===============================================

-- using a fixed author id for seed data
-- author id: 61ca76b6-ebc0-47e3-bd3c-d28c950b8576

-- Supabase `auth.users` does not expose a `password` column; remove it from the seed.
-- Insert a user with `raw_user_meta_data` containing `full_name` so the
-- `handle_new_user` trigger can create a profile without violating the
-- NOT NULL constraint on `public.profiles.full_name`.
insert into auth.users (id, email, raw_user_meta_data)
values (
  '61ca76b6-ebc0-47e3-bd3c-d28c950b8576',
  'dem1o@example.com',
  -- raw_user_meta_data is jsonb; include a full_name to satisfy the trigger
  '{"full_name":"Demo User"}'::jsonb
)
on conflict (id) do nothing;

insert into auth.users (id, email, raw_user_meta_data)
values (
  '61ca76b6-ebc0-47e3-bd3c-d28c950b8571',
  'demo2@example.com',
  -- raw_user_meta_data is jsonb; include a full_name to satisfy the trigger
  '{"full_name":"Demo User"}'::jsonb
)
on conflict (id) do nothing;
insert into auth.users (id, email, raw_user_meta_data)
values (
  '61ca76b6-ebc0-47e3-bd3c-d28c950b8572',
  'demo3@example.com',
  -- raw_user_meta_data is jsonb; include a full_name to satisfy the trigger
  '{"full_name":"Demo User"}'::jsonb
)
on conflict (id) do nothing;
insert into auth.users (id, email, raw_user_meta_data)
values (
  '61ca76b6-ebc0-47e3-bd3c-d28c950b8573',
  'demo5@example.com',
  -- raw_user_meta_data is jsonb; include a full_name to satisfy the trigger
  '{"full_name":"Demo User"}'::jsonb
)
on conflict (id) do nothing;
insert into auth.users (id, email, raw_user_meta_data)
values (
  '61ca76b6-ebc0-47e3-bd3c-d28c950b8574',
  'demo0@example.com',
  -- raw_user_meta_data is jsonb; include a full_name to satisfy the trigger
  '{"full_name":"Demo User"}'::jsonb
)
on conflict (id) do nothing;

-- -----------------------------------------------
-- PLAN 1 — Walking in Faith (5 Days)
-- -----------------------------------------------
insert into public.devotional_plans (id, author_id, title, description, tags, total_days,cover_image,completions)
values (
  '11111111-1111-1111-1111-111111111111',
  '61ca76b6-ebc0-47e3-bd3c-d28c950b8576',
  'Walking in Faith',
  'A 5-day devotional to strengthen your walk with God by trusting His Word above your feelings.',
  '{"faith","trust","spiritual_growth"}',
  5,
  'https://tukbozmflvoqvnaxcgmo.supabase.co/storage/v1/object/public/plan_covers/1.jpg',
  100
);

-- Days
insert into public.devotional_days (plan_id, day_number, content)
values
('11111111-1111-1111-1111-111111111111', 1, 'Faith is strengthened when we tune our hearts to God''s voice instead of fear.'),
('11111111-1111-1111-1111-111111111111', 2, 'Trust grows when we surrender what we cannot control into God''s hands.'),
('11111111-1111-1111-1111-111111111111', 3, 'Walking by faith means choosing obedience before understanding.'),
('11111111-1111-1111-1111-111111111111', 4, 'Faith is active—it moves, prays, believes, and surrenders daily.'),
('11111111-1111-1111-1111-111111111111', 5, 'God honors those who rely on Him even when situations look impossible.');

-- Scripture references
-- Scripture references for plan 1 (stored as text[])
insert into public.scripture_references (day_id, reference)
values (null, ARRAY['Hebrews 11:1','Proverbs 3:5','2 Corinthians 5:7','James 2:17','Luke 1:37']::text[]);



-- -----------------------------------------------
-- PLAN 2 — Hope in Difficult Times (3 Days)
-- -----------------------------------------------
insert into public.devotional_plans (id, author_id, title, description, tags, total_days,cover_image,completions)
values (
  '22222222-2222-2222-2222-222222222222',
  '61ca76b6-ebc0-47e3-bd3c-d28c950b8576',
  'Hope in Difficult Times',
  'A 3-day devotional reminding you that God is close to the brokenhearted.',
  '{"hope","comfort","encouragement"}',
  3,
  'https://tukbozmflvoqvnaxcgmo.supabase.co/storage/v1/object/public/plan_covers/2.jpg',
  10
);

insert into public.devotional_days (plan_id, day_number, content)
values
('22222222-2222-2222-2222-222222222222', 1, 'God meets us in the valleys with His comforting presence.'),
('22222222-2222-2222-2222-222222222222', 2, 'Hope comes alive when we remember God''s promises, not our pain.'),
('22222222-2222-2222-2222-222222222222', 3, 'Your suffering is not wasted—God is shaping something new in you.');

insert into public.scripture_references (day_id, reference)
values (null, ARRAY['Psalm 34:18','Romans 15:13','Isaiah 43:2']::text[]);



-- -----------------------------------------------
-- PLAN 3 — Learning to Pray (4 Days)
-- -----------------------------------------------
insert into public.devotional_plans (id, author_id, title, description, tags, total_days,cover_image,completions)
values (
  '33333333-3333-3333-3333-333333333333',
  '61ca76b6-ebc0-47e3-bd3c-d28c950b8576',
  'Learning to Pray',
  'A simple 4-day guide to help you grow a consistent prayer life.',
  '{"prayer","discipline","spiritual"}',
  4,
  'https://tukbozmflvoqvnaxcgmo.supabase.co/storage/v1/object/public/plan_covers/3.jpg',
  300
);

insert into public.devotional_days (plan_id, day_number, content)
values
('33333333-3333-3333-3333-333333333333', 1, 'Prayer begins with the posture of the heart—humble and sincere.'),
('33333333-3333-3333-3333-333333333333', 2, 'God hears even the quietest prayer spoken in faith.'),
('33333333-3333-3333-3333-333333333333', 3, 'Consistency in prayer shapes your desires to match God''s will.'),
('33333333-3333-3333-3333-333333333333', 4, 'Powerful prayer is rooted in Scripture and surrender.');

insert into public.scripture_references (day_id, reference)
values (null, ARRAY['Matthew 6:6','1 John 5:14','Psalm 37:4','Philippians 4:6']::text[]);



-- -----------------------------------------------
-- PLAN 4 — Living with Purpose (7 Days)
-- -----------------------------------------------
insert into public.devotional_plans (id, author_id, title, description, tags, total_days,cover_image,completions)
values (
  '44444444-4444-4444-4444-444444444444',
  '61ca76b6-ebc0-47e3-bd3c-d28c950b8576',
  'Living with Purpose',
  'A 7-day devotional to help you discover and pursue God''s purpose for your life.',
  '{"purpose","calling","identity"}',
  7,
  'https://tukbozmflvoqvnaxcgmo.supabase.co/storage/v1/object/public/plan_covers/4.jpg',
  45
);

insert into public.devotional_days (plan_id, day_number, content)
values
('44444444-4444-4444-4444-444444444444',1,'God created you intentionally and with purpose.'),
('44444444-4444-4444-4444-444444444444',2,'Your purpose begins with knowing who you are in Christ.'),
('44444444-4444-4444-4444-444444444444',3,'Purpose grows through obedience in small things.'),
('44444444-4444-4444-4444-444444444444',4,'God uses your gifts as tools for His glory.'),
('44444444-4444-4444-4444-444444444444',5,'Your weaknesses can become part of your purpose.'),
('44444444-4444-4444-4444-444444444444',6,'Purpose unfolds step-by-step, not all at once.'),
('44444444-4444-4444-4444-444444444444',7,'Walk confidently—God is writing your story.');

insert into public.scripture_references (day_id, reference)
values (null, ARRAY['Jeremiah 29:11','2 Corinthians 5:17','Luke 16:10','1 Peter 4:10','2 Corinthians 12:9','Psalm 37:23','Proverbs 3:6']::text[]);



-- -----------------------------------------------
-- PLAN 5 — Overcoming Anxiety (5 Days)
-- -----------------------------------------------
insert into public.devotional_plans (id, author_id, title, description, tags, total_days,cover_image,completions)
values (
  '55555555-5555-5555-5555-555555555555',
  '61ca76b6-ebc0-47e3-bd3c-d28c950b8576',
  'Overcoming Anxiety',
  'A 5-day devotional helping you surrender anxiety and find rest in Christ.',
  '{"anxiety","peace","mental_health","trust"}',
  5,
  'https://tukbozmflvoqvnaxcgmo.supabase.co/storage/v1/object/public/plan_covers/5.jpg',
  67
);

insert into public.devotional_days (plan_id, day_number, content)
values
('55555555-5555-5555-5555-555555555555',1,'God invites you to cast every burden on Him.'),
('55555555-5555-5555-5555-555555555555',2,'Peace grows when we meditate on God''s truths, not our fears.'),
('55555555-5555-5555-5555-555555555555',3,'Gratitude weakens anxiety''s grip on our hearts.'),
('55555555-5555-5555-5555-555555555555',4,'You don’t fight anxiety alone—God walks with you.'),
('55555555-5555-5555-5555-555555555555',5,'Even in anxious moments, God will sustain you.');

insert into public.scripture_references (day_id, reference)
values (null, ARRAY['1 Peter 5:7','Isaiah 26:3','Philippians 4:6-7','Psalm 23:4','Psalm 55:22']::text[]);



-- -----------------------------------------------
-- PLAN 6 — Strength in Weakness (3 Days)
-- -----------------------------------------------
insert into public.devotional_plans (id, author_id, title, description, tags, total_days,cover_image,completions)
values (
  '66666666-6666-6666-6666-666666666666',
  '61ca76b6-ebc0-47e3-bd3c-d28c950b8576',
  'Strength in Weakness',
  'A 3-day devotional on how God''s strength is revealed in our weakness.',
  '{"strength","grace","encouragement"}',
  3,
  'https://tukbozmflvoqvnaxcgmo.supabase.co/storage/v1/object/public/plan_covers/6.jpg',
  56
);

insert into public.devotional_days (plan_id, day_number, content)
values
('66666666-6666-6666-6666-666666666666',1,'God is strongest in the areas where you feel weakest.'),
('66666666-6666-6666-6666-666666666666',2,'Your weakness invites God''s grace to work deeply in you.'),
('66666666-6666-6666-6666-666666666666',3,'God uses broken vessels to display His glory.');

insert into public.scripture_references (day_id, reference)
values (null, ARRAY['2 Corinthians 12:9','Psalm 73:26','Isaiah 40:29']::text[]);



-- -----------------------------------------------
-- PLAN 7 — Gratitude Every Day (7 Days)
-- -----------------------------------------------
insert into public.devotional_plans (id, author_id, title, description, tags, total_days,cover_image,completions)
values (
  '77777777-7777-7777-7777-777777777777',
  '61ca76b6-ebc0-47e3-bd3c-d28c950b8576',
  'Gratitude Every Day',
  'A 7-day devotional to cultivate a grateful heart.',
  '{"gratitude","joy","discipline"}',
  7,
  'https://tukbozmflvoqvnaxcgmo.supabase.co/storage/v1/object/public/plan_covers/7.jpg',
  454
);

insert into public.devotional_days (plan_id, day_number, content)
values
('77777777-7777-7777-7777-777777777777',1,'Gratitude shifts your focus from lack to abundance.'),
('77777777-7777-7777-7777-777777777777',2,'Thankfulness opens your heart to experience God''s joy.'),
('77777777-7777-7777-7777-777777777777',3,'God''s blessings are often found in small, unnoticed moments.'),
('77777777-7777-7777-7777-777777777777',4,'A grateful heart is a worshipful heart.'),
('77777777-7777-7777-7777-777777777777',5,'Practicing gratitude strengthens your faith.'),
('77777777-7777-7777-7777-777777777777',6,'Gratitude is a choice—even in difficult circumstances.'),
('77777777-7777-7777-7777-777777777777',7,'A life of gratitude brings peace and contentment.');

insert into public.scripture_references (day_id, reference)
values (null, ARRAY['1 Thessalonians 5:18','Psalm 100:4','James 1:17','Colossians 3:15','Psalm 9:1','Habakkuk 3:17-18','Philippians 4:11']::text[]);



-- -----------------------------------------------
-- PLAN 8 — The Holy Spirit's Guidance (4 Days)
-- -----------------------------------------------
insert into public.devotional_plans (id, author_id, title, description, tags, total_days,cover_image,completions)
values (
  '88888888-8888-8888-8888-888888888888',
  '61ca76b6-ebc0-47e3-bd3c-d28c950b8576',
  'The Holy Spirit''s Guidance',
  'A 4-day devotional on walking with the Holy Spirit daily.',
  '{"Holy Spirit","guidance","spiritual"}',
  4,
  'https://tukbozmflvoqvnaxcgmo.supabase.co/storage/v1/object/public/plan_covers/8.jpg',
  343
);

insert into public.devotional_days (plan_id, day_number, content)
values
('88888888-8888-8888-8888-888888888888',1,'The Holy Spirit comforts and strengthens you.'),
('88888888-8888-8888-8888-888888888888',2,'He leads you into all truth through God''s Word.'),
('88888888-8888-8888-8888-888888888888',3,'Walking in the Spirit means surrendering your will.'),
('88888888-8888-8888-8888-888888888888',4,'The Spirit empowers you to live a transformed life.');

insert into public.scripture_references (day_id, reference)
values (null, ARRAY['John 14:26','John 16:13','Galatians 5:16','Acts 1:8']::text[]);



-- -----------------------------------------------
-- PLAN 9 — The Love of God (5 Days)
-- -----------------------------------------------
insert into public.devotional_plans (id, author_id, title, description, tags, total_days,cover_image,completions)
values (
  '99999999-9999-9999-9999-999999999999',
  '61ca76b6-ebc0-47e3-bd3c-d28c950b8576',
  'The Love of God',
  'A 5-day devotional exploring the depth of God''s love.',
  '{"love","identity","grace"}',
  5,
  'https://tukbozmflvoqvnaxcgmo.supabase.co/storage/v1/object/public/plan_covers/9.jpg',
  434
);

insert into public.devotional_days (plan_id, day_number, content)
values
('99999999-9999-9999-9999-999999999999',1,'God’s love is unconditional and relentless.'),
('99999999-9999-9999-9999-999999999999',2,'You are fully known and completely loved by God.'),
('99999999-9999-9999-9999-999999999999',3,'God''s love transforms hearts and minds.'),
('99999999-9999-9999-9999-999999999999',4,'His love restores what was broken.'),
('99999999-9999-9999-9999-999999999999',5,'Live each day anchored in God''s never-failing love.');

insert into public.scripture_references (day_id, reference)
values (null, ARRAY['Romans 8:38-39','Psalm 139:1','1 John 4:19','Joel 2:25','Jeremiah 31:3']::text[]);



-- -----------------------------------------------
-- PLAN 10 — Spiritual Discipline (6 Days)
-- -----------------------------------------------
insert into public.devotional_plans (id, author_id, title, description, tags, total_days,cover_image,completions)
values (
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  '61ca76b6-ebc0-47e3-bd3c-d28c950b8576',
  'Spiritual Discipline',
  'A 6-day devotional to help you grow spiritual habits that strengthen your faith.',
  '{"discipline","growth","habits"}',
  6,
  'https://tukbozmflvoqvnaxcgmo.supabase.co/storage/v1/object/public/plan_covers/a.jpg',
  98
);

insert into public.devotional_days (plan_id, day_number, content)
values
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',1,'Spiritual discipline starts with desire: wanting to grow with God.'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',2,'Reading the Word daily feeds your soul.'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',3,'Prayer builds intimacy with God.'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',4,'Fasting sharpens your spiritual focus.'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',5,'Serving others reflects Christ''s love.'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',6,'Consistency leads to spiritual maturity.');

insert into public.scripture_references (day_id, reference)
values (null, ARRAY['Psalm 42:1','Matthew 4:4','Luke 11:1','Isaiah 58:6','Mark 10:45','Hebrews 5:14']::text[]);



-- -- =========================================================
-- -- USERS (Replace with your real user IDs above)
-- -- =========================================================
-- \set user1 '61ca76b6-ebc0-47e3-bd3c-d28c950b8574'
-- \set user2 '61ca76b6-ebc0-47e3-bd3c-d28c950b8573'
-- \set user3 '61ca76b6-ebc0-47e3-bd3c-d28c950b8572'
-- \set user4 '61ca76b6-ebc0-47e3-bd3c-d28c950b8571'
-- \set user5 '61ca76b6-ebc0-47e3-bd3c-d28c950b8576'

-- -- =========================================================
-- -- PLANS (IDs already created earlier)
-- -- =========================================================
-- \set plan1  '11111111-1111-1111-1111-111111111111'
-- \set plan2  '22222222-2222-2222-2222-222222222222'
-- \set plan3  '33333333-3333-3333-3333-333333333333'
-- \set plan4  '44444444-4444-4444-4444-444444444444'
-- \set plan5  '55555555-5555-5555-5555-555555555555'
-- \set plan6  '66666666-6666-6666-6666-666666666666'
-- \set plan7  '77777777-7777-7777-7777-777777777777'
-- \set plan8  '88888888-8888-8888-8888-888888888888'
-- \set plan9  '99999999-9999-9999-9999-999999999999'
-- \set plan10 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'


-- =========================================================
-- COMMENTS FOR ALL PLANS
-- (Each plan gets 3 realistic sample comments)
-- =========================================================

insert into public.comments (user_id, content, entity_type, entity_id)
values
-- PLAN 1: Walking in Faith
('61ca76b6-ebc0-47e3-bd3c-d28c950b8574', 'This really helped me refocus on trusting God—thank you!', 'plan', '11111111-1111-1111-1111-111111111111'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8573', 'Day 3 hit me deeply. Walking by faith isn’t easy but worth it.', 'plan', '11111111-1111-1111-1111-111111111111'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8572', 'Beautiful devotional. Very uplifting.', 'plan', '11111111-1111-1111-1111-111111111111'),

-- PLAN 2: Hope in Difficult Times
('61ca76b6-ebc0-47e3-bd3c-d28c950b8573', 'Exactly what I needed today. God is close even when life is heavy.', 'plan', '22222222-2222-2222-2222-222222222222'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8571', 'Short but powerful. Thank you for sharing this.', 'plan', '22222222-2222-2222-2222-222222222222'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8574', 'Day 2 encouraged me so much. Hope is alive!', 'plan', '22222222-2222-2222-2222-222222222222'),

-- PLAN 3: Learning to Pray
('61ca76b6-ebc0-47e3-bd3c-d28c950b8572', 'These prayer insights are so practical. Loved every day.', 'plan', '33333333-3333-3333-3333-333333333333'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8576', 'This devotional strengthened my prayer life.', 'plan', '33333333-3333-3333-3333-333333333333'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8574', 'Clear, simple, and powerful. Thank you!', 'plan', '33333333-3333-3333-3333-333333333333'),

-- PLAN 4: Living with Purpose
('61ca76b6-ebc0-47e3-bd3c-d28c950b8571', 'Day 5 reminded me that my weaknesses can be used by God.', 'plan', '44444444-4444-4444-4444-444444444444'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8573', 'This devotional helped me rediscover my purpose.', 'plan', '44444444-4444-4444-4444-444444444444'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8572', 'One of the best devotionals I have read.', 'plan', '44444444-4444-4444-4444-444444444444'),

-- PLAN 5: Overcoming Anxiety
('61ca76b6-ebc0-47e3-bd3c-d28c950b8576', 'So comforting. God truly gives peace.', 'plan', '55555555-5555-5555-5555-555555555555'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8574', 'This devotional helped me calm my anxious thoughts.', 'plan', '55555555-5555-5555-5555-555555555555'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8572', 'Day 3 on gratitude really helped me today.', 'plan', '55555555-5555-5555-5555-555555555555'),

-- PLAN 6: Strength in Weakness
('61ca76b6-ebc0-47e3-bd3c-d28c950b8573', 'Perfect reminder that God is strong when I feel weak.', 'plan', '66666666-6666-6666-6666-666666666666'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8576', 'Simple but powerful devotional.', 'plan', '66666666-6666-6666-6666-666666666666'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8571', 'This blessed me so much today.', 'plan', '66666666-6666-6666-6666-666666666666'),

-- PLAN 7: Gratitude Every Day
('61ca76b6-ebc0-47e3-bd3c-d28c950b8574', 'I feel so encouraged to practice daily gratitude now.', 'plan', '77777777-7777-7777-7777-777777777777'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8572', 'Day 6 was exactly what I needed.', 'plan', '77777777-7777-7777-7777-777777777777'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8573', 'Very uplifting devotional!', 'plan', '77777777-7777-7777-7777-777777777777'),

-- PLAN 8: The Holy Spirit''s Guidance
('61ca76b6-ebc0-47e3-bd3c-d28c950b8571', 'Such a great devotional on the Holy Spirit.', 'plan', '88888888-8888-8888-8888-888888888888'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8576', 'I learned so much from day 2!', 'plan', '88888888-8888-8888-8888-888888888888'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8574', 'Very deep but easy to understand.', 'plan', '88888888-8888-8888-8888-888888888888'),

-- PLAN 9: The Love of God
('61ca76b6-ebc0-47e3-bd3c-d28c950b8572', 'God’s love is truly amazing. Day 1 blessed me.', 'plan', '99999999-9999-9999-9999-999999999999'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8573', 'Such a beautiful reminder of His unfailing love.', 'plan', '99999999-9999-9999-9999-999999999999'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8571', 'I really enjoyed reading this.', 'plan', '99999999-9999-9999-9999-999999999999'),

-- PLAN 10: Spiritual Discipline
('61ca76b6-ebc0-47e3-bd3c-d28c950b8576', 'This devotional challenged me to be more consistent.', 'plan', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8574', 'Day 4 on fasting was powerful.', 'plan', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8572', 'Great structure and very Biblical.', 'plan', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa')
;


-- =========================================================
-- PLAN REACTIONS (Likes & Dislikes)
-- 3 likes per plan + 1 dislike
-- =========================================================

insert into public.plan_reactions (user_id, plan_id, reaction_type)
values
-- PLAN 1
('61ca76b6-ebc0-47e3-bd3c-d28c950b8574', '11111111-1111-1111-1111-111111111111', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8573', '11111111-1111-1111-1111-111111111111', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8572', '11111111-1111-1111-1111-111111111111', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8571', '11111111-1111-1111-1111-111111111111', 'dislike'),

-- PLAN 2
('61ca76b6-ebc0-47e3-bd3c-d28c950b8572', '22222222-2222-2222-2222-222222222222', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8571', '22222222-2222-2222-2222-222222222222', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8574', '22222222-2222-2222-2222-222222222222', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8576', '22222222-2222-2222-2222-222222222222', 'dislike'),

-- PLAN 3
('61ca76b6-ebc0-47e3-bd3c-d28c950b8573', '33333333-3333-3333-3333-333333333333', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8574', '33333333-3333-3333-3333-333333333333', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8571', '33333333-3333-3333-3333-333333333333', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8572', '33333333-3333-3333-3333-333333333333', 'dislike'),

-- PLAN 4
('61ca76b6-ebc0-47e3-bd3c-d28c950b8576', '44444444-4444-4444-4444-444444444444', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8572', '44444444-4444-4444-4444-444444444444', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8573', '44444444-4444-4444-4444-444444444444', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8574', '44444444-4444-4444-4444-444444444444', 'dislike'),

-- PLAN 5
('61ca76b6-ebc0-47e3-bd3c-d28c950b8574', '55555555-5555-5555-5555-555555555555', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8571', '55555555-5555-5555-5555-555555555555', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8572', '55555555-5555-5555-5555-555555555555', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8573', '55555555-5555-5555-5555-555555555555', 'dislike'),

-- PLAN 6
('61ca76b6-ebc0-47e3-bd3c-d28c950b8574', '66666666-6666-6666-6666-666666666666', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8573', '66666666-6666-6666-6666-666666666666', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8576', '66666666-6666-6666-6666-666666666666', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8572', '66666666-6666-6666-6666-666666666666', 'dislike'),

-- PLAN 7
('61ca76b6-ebc0-47e3-bd3c-d28c950b8572', '77777777-7777-7777-7777-777777777777', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8571', '77777777-7777-7777-7777-777777777777', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8573', '77777777-7777-7777-7777-777777777777', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8576', '77777777-7777-7777-7777-777777777777', 'dislike'),

-- PLAN 8
('61ca76b6-ebc0-47e3-bd3c-d28c950b8574', '88888888-8888-8888-8888-888888888888', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8576', '88888888-8888-8888-8888-888888888888', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8571', '88888888-8888-8888-8888-888888888888', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8573', '88888888-8888-8888-8888-888888888888', 'dislike'),

-- PLAN 9
('61ca76b6-ebc0-47e3-bd3c-d28c950b8573', '99999999-9999-9999-9999-999999999999', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8574', '99999999-9999-9999-9999-999999999999', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8576', '99999999-9999-9999-9999-999999999999', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8572', '99999999-9999-9999-9999-999999999999', 'dislike'),

-- PLAN 10
('61ca76b6-ebc0-47e3-bd3c-d28c950b8571', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8574', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8572', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'like'),
('61ca76b6-ebc0-47e3-bd3c-d28c950b8573', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'dislike')
;
