-- Remove plans with an effective merged day above 2,500 visible words from publication.
-- Plan/day records and all user progress are retained; only catalog status changes to draft.
-- Generated from the effective post-merge seed by audit_oversized_merged_days.py.
BEGIN;

DO $oversized_merged_days$
DECLARE
  v_payload constant jsonb := $oversized_payload$[
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "title": "To The Work! To The Work! Exhortations to Christians",
    "oversized_days": 1,
    "maximum_words": 41849
  },
  {
    "id": "90000000-0000-0000-0000-000000000232",
    "title": "Gleanings among the Sheaves",
    "oversized_days": 1,
    "maximum_words": 35177
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "title": "Sovereign Grace: Its Source, Its Nature and Its Effects",
    "oversized_days": 1,
    "maximum_words": 33854
  },
  {
    "id": "90000000-0000-0000-0000-000000000364",
    "title": "Matelda and the cloister of Hellfde : extracts from the Book of Matilda of Magdeburg",
    "oversized_days": 1,
    "maximum_words": 33805
  },
  {
    "id": "90000000-0000-0000-0000-000000000215",
    "title": "The Greatest Thing In the World and Other Addresses",
    "oversized_days": 1,
    "maximum_words": 32757
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "title": "Prevailing Prayer: What Hinders It?",
    "oversized_days": 1,
    "maximum_words": 31293
  },
  {
    "id": "90000000-0000-0000-0000-000000000211",
    "title": "Secret Power; or, The Secret of Success in Christian Life and Work",
    "oversized_days": 1,
    "maximum_words": 30826
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "title": "The Overcoming Life, and Other Sermons",
    "oversized_days": 2,
    "maximum_words": 28551
  },
  {
    "id": "90000000-0000-0000-0000-000000000206",
    "title": "The Master's Indwelling",
    "oversized_days": 2,
    "maximum_words": 27620
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "title": "Reuben Roy's temptations",
    "oversized_days": 1,
    "maximum_words": 23340
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "title": "Power Through Prayer",
    "oversized_days": 1,
    "maximum_words": 21264
  },
  {
    "id": "90000000-0000-0000-0000-000000000320",
    "title": "In Answer to Prayer",
    "oversized_days": 1,
    "maximum_words": 19854
  },
  {
    "id": "90000000-0000-0000-0000-000000000289",
    "title": "The Heart-Cry of Jesus",
    "oversized_days": 1,
    "maximum_words": 17100
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "title": "The Trial and Death of Jesus Christ",
    "oversized_days": 14,
    "maximum_words": 15900
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "title": "The Ministry of Intercession",
    "oversized_days": 10,
    "maximum_words": 14859
  },
  {
    "id": "90000000-0000-0000-0000-000000000233",
    "title": "Talks to Farmers",
    "oversized_days": 18,
    "maximum_words": 12321
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "title": "The value of a praying mother",
    "oversized_days": 4,
    "maximum_words": 12063
  },
  {
    "id": "90000000-0000-0000-0000-000000000227",
    "title": "Spiritual Victories Through the Light of Salvation",
    "oversized_days": 1,
    "maximum_words": 11655
  },
  {
    "id": "90000000-0000-0000-0000-000000000336",
    "title": "Five Sermons",
    "oversized_days": 2,
    "maximum_words": 11502
  },
  {
    "id": "90000000-0000-0000-0000-000000000209",
    "title": "The Practice of the Presence of God",
    "oversized_days": 1,
    "maximum_words": 10717
  },
  {
    "id": "90000000-0000-0000-0000-000000000323",
    "title": "The Abiding Presence of the Holy Ghost in the Soul",
    "oversized_days": 2,
    "maximum_words": 10716
  },
  {
    "id": "90000000-0000-0000-0000-000000000304",
    "title": "Parables of the Christ-life",
    "oversized_days": 1,
    "maximum_words": 10683
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "title": "John the Baptist",
    "oversized_days": 10,
    "maximum_words": 10621
  },
  {
    "id": "90000000-0000-0000-0000-000000000202",
    "title": "Holy in Christ",
    "oversized_days": 12,
    "maximum_words": 9967
  },
  {
    "id": "90000000-0000-0000-0000-000000000229",
    "title": "The Character and Happiness of Them That Die in the Lord",
    "oversized_days": 1,
    "maximum_words": 9590
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "title": "Spiritual Torrents",
    "oversized_days": 1,
    "maximum_words": 9498
  },
  {
    "id": "90000000-0000-0000-0000-000000000291",
    "title": "On Union with God",
    "oversized_days": 1,
    "maximum_words": 9218
  },
  {
    "id": "90000000-0000-0000-0000-000000000299",
    "title": "The Peep of Day",
    "oversized_days": 3,
    "maximum_words": 9170
  },
  {
    "id": "90000000-0000-0000-0000-000000000240",
    "title": "Addresses by Henry Drummond",
    "oversized_days": 4,
    "maximum_words": 8893
  },
  {
    "id": "90000000-0000-0000-0000-000000000204",
    "title": "'Jesus Himself'",
    "oversized_days": 1,
    "maximum_words": 8585
  },
  {
    "id": "90000000-0000-0000-0000-000000000228",
    "title": "Consolation in Life and Death, Derived from the Life of Christ",
    "oversized_days": 1,
    "maximum_words": 8038
  },
  {
    "id": "90000000-0000-0000-0000-000000000341",
    "title": "General Catholic Devotions",
    "oversized_days": 1,
    "maximum_words": 8014
  },
  {
    "id": "90000000-0000-0000-0000-000000000377",
    "title": "The Cross: A Tract for the Times",
    "oversized_days": 1,
    "maximum_words": 7958
  },
  {
    "id": "90000000-0000-0000-0000-000000000365",
    "title": "The True Ministers of Christ Accredited by the Holy Spirit: A Sermon",
    "oversized_days": 1,
    "maximum_words": 7758
  },
  {
    "id": "90000000-0000-0000-0000-000000000246",
    "title": "The Glorious Law-Giver, and the Obedient Subject",
    "oversized_days": 1,
    "maximum_words": 7527
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "title": "Kept for the Master's Use",
    "oversized_days": 6,
    "maximum_words": 7513
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "title": "With God in the World: A Series of Papers",
    "oversized_days": 4,
    "maximum_words": 7439
  },
  {
    "id": "90000000-0000-0000-0000-000000000274",
    "title": "Parables of the Cross",
    "oversized_days": 1,
    "maximum_words": 7174
  },
  {
    "id": "90000000-0000-0000-0000-000000000222",
    "title": "The Christian Serving His Own Generation",
    "oversized_days": 1,
    "maximum_words": 7131
  },
  {
    "id": "90000000-0000-0000-0000-000000000238",
    "title": "Pax Vobiscum",
    "oversized_days": 1,
    "maximum_words": 7066
  },
  {
    "id": "90000000-0000-0000-0000-000000000214",
    "title": "The Way to God and How to Find It",
    "oversized_days": 8,
    "maximum_words": 6673
  },
  {
    "id": "90000000-0000-0000-0000-000000000324",
    "title": "The Cities of Refuge: or, The Name of Jesus",
    "oversized_days": 1,
    "maximum_words": 6490
  },
  {
    "id": "90000000-0000-0000-0000-000000000335",
    "title": "Essentials of prayer",
    "oversized_days": 7,
    "maximum_words": 6172
  },
  {
    "id": "90000000-0000-0000-0000-000000000213",
    "title": "Around the Wicket Gate",
    "oversized_days": 3,
    "maximum_words": 5921
  },
  {
    "id": "90000000-0000-0000-0000-000000000239",
    "title": "Eternal Life",
    "oversized_days": 2,
    "maximum_words": 5914
  },
  {
    "id": "90000000-0000-0000-0000-000000000343",
    "title": "David: Five Sermons",
    "oversized_days": 4,
    "maximum_words": 5879
  },
  {
    "id": "90000000-0000-0000-0000-000000000224",
    "title": "The Believer's Confidence in a Faithful God",
    "oversized_days": 1,
    "maximum_words": 5851
  },
  {
    "id": "90000000-0000-0000-0000-000000000301",
    "title": "A Prayer Book for Soldiers and Sailors",
    "oversized_days": 2,
    "maximum_words": 5765
  },
  {
    "id": "90000000-0000-0000-0000-000000000225",
    "title": "The Living Letter, Written with the Pen of Truth",
    "oversized_days": 1,
    "maximum_words": 5618
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "title": "The Spirit-Filled Life",
    "oversized_days": 4,
    "maximum_words": 5539
  },
  {
    "id": "90000000-0000-0000-0000-000000000391",
    "title": "The Sabbath: A Sermon",
    "oversized_days": 1,
    "maximum_words": 5452
  },
  {
    "id": "90000000-0000-0000-0000-000000000247",
    "title": "The Descent of the Branch into the Waters of Sorrow, to Bring up the Election of Grace",
    "oversized_days": 1,
    "maximum_words": 5405
  },
  {
    "id": "90000000-0000-0000-0000-000000000208",
    "title": "Money: Thoughts for God's Stewards",
    "oversized_days": 3,
    "maximum_words": 5008
  },
  {
    "id": "90000000-0000-0000-0000-000000000368",
    "title": "The Atonement, as taught by the Church of England: A Sermon",
    "oversized_days": 2,
    "maximum_words": 4944
  },
  {
    "id": "90000000-0000-0000-0000-000000000221",
    "title": "An Earnest Exhortation to a Frequent Reception of the Holy Sacrament of the Lord's Supper",
    "oversized_days": 1,
    "maximum_words": 4936
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "title": "Love to the Uttermost",
    "oversized_days": 16,
    "maximum_words": 4761
  },
  {
    "id": "90000000-0000-0000-0000-000000000245",
    "title": "Sowing and Reaping",
    "oversized_days": 7,
    "maximum_words": 4686
  },
  {
    "id": "90000000-0000-0000-0000-000000000383",
    "title": "The Believer Not Ashamed of the Gospel",
    "oversized_days": 1,
    "maximum_words": 4546
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "title": "Messages from the Epistle to the Hebrews",
    "oversized_days": 2,
    "maximum_words": 4521
  },
  {
    "id": "90000000-0000-0000-0000-000000000378",
    "title": "Sermons for the Day",
    "oversized_days": 1,
    "maximum_words": 4409
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "title": "How I Know God Answers Prayer: The Personal Testimony of One Life-Time",
    "oversized_days": 2,
    "maximum_words": 4400
  },
  {
    "id": "90000000-0000-0000-0000-000000000300",
    "title": "The Shepherd Psalm: A Meditation",
    "oversized_days": 3,
    "maximum_words": 4389
  },
  {
    "id": "90000000-0000-0000-0000-000000000349",
    "title": "Weighed and Wanting: Addresses on the Ten Commandments",
    "oversized_days": 6,
    "maximum_words": 4340
  },
  {
    "id": "90000000-0000-0000-0000-000000000226",
    "title": "The Speedy Appearance of Christ Desired by the Church",
    "oversized_days": 1,
    "maximum_words": 4334
  },
  {
    "id": "90000000-0000-0000-0000-000000000203",
    "title": "Humility: The Beauty of Holiness",
    "oversized_days": 1,
    "maximum_words": 3473
  },
  {
    "id": "90000000-0000-0000-0000-000000000231",
    "title": "Beside the Still Waters",
    "oversized_days": 1,
    "maximum_words": 3412
  },
  {
    "id": "90000000-0000-0000-0000-000000000294",
    "title": "The Mind of Jesus",
    "oversized_days": 2,
    "maximum_words": 3060
  },
  {
    "id": "90000000-0000-0000-0000-000000000292",
    "title": "Mary, the Help of Christians",
    "oversized_days": 1,
    "maximum_words": 3024
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "title": "Memoranda Sacra",
    "oversized_days": 1,
    "maximum_words": 2669
  },
  {
    "id": "90000000-0000-0000-0000-000000000223",
    "title": "The Worth of the Soul",
    "oversized_days": 1,
    "maximum_words": 2612
  }
]$oversized_payload$::jsonb;
  v_payload_count integer;
  v_matching_count integer;
  v_updated_count integer;
  v_remaining_published integer;
BEGIN
  v_payload_count := jsonb_array_length(v_payload);

  IF EXISTS (
    SELECT 1
    FROM jsonb_to_recordset(v_payload)
      AS item(id uuid, title text, oversized_days integer, maximum_words integer)
    GROUP BY item.id
    HAVING count(*) <> 1
  ) THEN
    RAISE EXCEPTION 'Oversized-day payload contains duplicate plan IDs';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM jsonb_to_recordset(v_payload)
      AS item(id uuid, title text, oversized_days integer, maximum_words integer)
    WHERE item.oversized_days < 1 OR item.maximum_words <= 2500
  ) THEN
    RAISE EXCEPTION 'Oversized-day payload contains an invalid audit result';
  END IF;

  SELECT count(*) INTO v_matching_count
  FROM jsonb_to_recordset(v_payload)
    AS item(id uuid, title text, oversized_days integer, maximum_words integer)
  JOIN public.devotional_plans AS plan
    ON plan.id = item.id AND plan.title = item.title;

  IF v_matching_count <> v_payload_count THEN
    RAISE EXCEPTION 'Oversized-day preflight failed: expected % exact plan matches, found %',
      v_payload_count, v_matching_count;
  END IF;

  UPDATE public.devotional_plans AS plan
  SET status = 'draft',
      updated_at = now()
  FROM jsonb_to_recordset(v_payload)
    AS item(id uuid, title text, oversized_days integer, maximum_words integer)
  WHERE plan.id = item.id;

  GET DIAGNOSTICS v_updated_count = ROW_COUNT;
  IF v_updated_count <> v_payload_count THEN
    RAISE EXCEPTION 'Oversized-day removal count mismatch: expected %, updated %',
      v_payload_count, v_updated_count;
  END IF;

  SELECT count(*) INTO v_remaining_published
  FROM jsonb_to_recordset(v_payload)
    AS item(id uuid, title text, oversized_days integer, maximum_words integer)
  JOIN public.devotional_plans AS plan ON plan.id = item.id
  WHERE plan.status <> 'draft';

  IF v_remaining_published <> 0 THEN
    RAISE EXCEPTION 'Oversized-day postflight failed: % plans remain published',
      v_remaining_published;
  END IF;
END
$oversized_merged_days$;

COMMIT;
