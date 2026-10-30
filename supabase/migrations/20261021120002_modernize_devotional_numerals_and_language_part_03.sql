-- Convert Scripture/section Roman numerals to Arabic digits and modernize
-- verified archaic wording in the published public-domain plans.
-- Historical personal names keep their conventional Roman ordinals.
-- Plan and day IDs are unchanged; content updates preserve progress.
-- Part 3 of 13: day_title, 1371 rows.

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-21 12:00:00+00'
from jsonb_to_recordset($language_edits$
[
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 2 The House of Zacharias (1)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 2 The House of Zacharias (2)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 2 The House of Zacharias (3)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 3 His Schools and Schoolmasters (1)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 3 His Schools and Schoolmasters (2)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 3 His Schools and Schoolmasters (3)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 4 The Prophet of the Highest (1)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 4 The Prophet of the Highest (2)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 4 The Prophet of the Highest (3)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 5 The First Ministry of the Baptist (1)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 5 The First Ministry of the Baptist (2)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 5 The First Ministry of the Baptist (3)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 5 The First Ministry of the Baptist (4)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 5 The First Ministry of the Baptist (5)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 5 The First Ministry of the Baptist (6)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 7 The Manifestation of the Messiah (1)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 7 The Manifestation of the Messiah (2)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 7 The Manifestation of the Messiah (3)",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 7 The Manifestation of the Messiah (4)",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 7 The Manifestation of the Messiah (5)",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 7 The Manifestation of the Messiah (6)",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 7 The Manifestation of the Messiah (7)",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 7 The Manifestation of the Messiah (8)",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 10 The King's Courts (1)",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 10 The King's Courts (2)",
    "day_number": 27
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 10 The King's Courts (3)",
    "day_number": 28
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 11 \"Are You the One?\" (1)",
    "day_number": 29
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 11 \"Are You the One?\" (2)",
    "day_number": 30
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 11 \"Are You the One?\" (3)",
    "day_number": 31
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 11 \"Are You the One?\" (4)",
    "day_number": 32
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 11 \"Are You the One?\" (5)",
    "day_number": 33
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 11 \"Are You the One?\" (6)",
    "day_number": 34
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 13 A Burning and Shining Lamp (1)",
    "day_number": 35
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 13 A Burning and Shining Lamp (2)",
    "day_number": 36
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 13 A Burning and Shining Lamp (3)",
    "day_number": 37
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 14 Set at Liberty (1)",
    "day_number": 38
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 14 Set at Liberty (2)",
    "day_number": 39
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 14 Set at Liberty (3)",
    "day_number": 40
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 15 The Grave of John, and Another Grave (1)",
    "day_number": 41
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 15 The Grave of John, and Another Grave (2)",
    "day_number": 42
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 15 The Grave of John, and Another Grave (3)",
    "day_number": 43
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 16 Yet Speaking (1)",
    "day_number": 44
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 16 Yet Speaking (2)",
    "day_number": 45
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 16 Yet Speaking (3)",
    "day_number": 46
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 17 The Spirit and Power of Elias (1)",
    "day_number": 47
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 17 The Spirit and Power of Elias (2)",
    "day_number": 48
  },
  {
    "id": "90000000-0000-0000-0000-000000000234",
    "value": "Chapter 17 The Spirit and Power of Elias (3)",
    "day_number": 49
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 2 Thrice Bidden to Love (1)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 2 Thrice Bidden to Love (2)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 3 Heaven Delayed, but Guaranteed (1)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 3 Heaven Delayed, but Guaranteed (2)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 4 \"Many Mansions\"",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 5 The Reality of which Jacob's Dream was the Shadow (1)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 5 The Reality of which Jacob's Dream was the Shadow (2)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 6 Christ Revealing the Father (1)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 6 Christ Revealing the Father (2)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 7 The Great Deeds of Prayer (1)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 7 The Great Deeds of Prayer (2)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 8 How to Secure More and Better Prayer (1)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 8 How to Secure More and Better Prayer (2)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 9 The Other Paraclete (1)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 9 The Other Paraclete (2)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 10 The Three Dispensations (1)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 10 The Three Dispensations (2)",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 11 Three Paradoxes (1)",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 11 Three Paradoxes (2)",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 12 Many Mansions for God (1)",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 12 Many Mansions for God (2)",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 13 Christ's Legacy and Gift of Peace (1)",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 13 Christ's Legacy and Gift of Peace (2)",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 14 The Story of the Vine (1)",
    "day_number": 27
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 14 The Story of the Vine (2)",
    "day_number": 28
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 15 \"Abide in Me, and I in you\" (1)",
    "day_number": 29
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 15 \"Abide in Me, and I in you\" (2)",
    "day_number": 30
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 15 \"Abide in Me, and I in you\" (3)",
    "day_number": 31
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 15 \"Abide in Me, and I in you\" (4)",
    "day_number": 32
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 17 The hatred of the World (1)",
    "day_number": 33
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 17 The hatred of the World (2)",
    "day_number": 34
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 18 The Work of the Holy Spirit on the World (1)",
    "day_number": 35
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 18 The Work of the Holy Spirit on the World (2)",
    "day_number": 36
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 19 Christ's Reticence Supplemented by the Spirit's Advent (1)",
    "day_number": 37
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 19 Christ's Reticence Supplemented by the Spirit's Advent (2)",
    "day_number": 38
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 20 The Conqueror of the World (1)",
    "day_number": 39
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 20 The Conqueror of the World (2)",
    "day_number": 40
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 21 Consecrated to Consecrate (1)",
    "day_number": 41
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 21 Consecrated to Consecrate (2)",
    "day_number": 42
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 22 The Lord's Prayer for His People's Oneness (1)",
    "day_number": 43
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 22 The Lord's Prayer for His People's Oneness (2)",
    "day_number": 44
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 22 The Lord's Prayer for His People's Oneness (3)",
    "day_number": 45
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 23 The Love that Bound Christ to the Cross (1)",
    "day_number": 46
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 23 The Love that Bound Christ to the Cross (2)",
    "day_number": 47
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 24 Drinking the Cup (1)",
    "day_number": 48
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 24 Drinking the Cup (2)",
    "day_number": 49
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 25 The Hall of Annas (1)",
    "day_number": 50
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 25 The Hall of Annas (2)",
    "day_number": 51
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 25 The Hall of Annas (3)",
    "day_number": 52
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 27 The Trial before Caiaphas (1)",
    "day_number": 53
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 27 The Trial before Caiaphas (2)",
    "day_number": 54
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 28 \"Judas, which Betrayed Him\" (1)",
    "day_number": 55
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 28 \"Judas, which Betrayed Him\" (2)",
    "day_number": 56
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 29 The First Trial before Pilate (1)",
    "day_number": 57
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 29 The First Trial before Pilate (2)",
    "day_number": 58
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 30 The Second Trial before Pilate (1)",
    "day_number": 59
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 30 The Second Trial before Pilate (2)",
    "day_number": 60
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 31 The Seven Sayings of the Cross (1)",
    "day_number": 61
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 31 The Seven Sayings of the Cross (2)",
    "day_number": 62
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 31 The Seven Sayings of the Cross (3)",
    "day_number": 63
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 32 Christ's Burial (1)",
    "day_number": 64
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 32 Christ's Burial (2)",
    "day_number": 65
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 33 The Day of Resurrection (1)",
    "day_number": 66
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 33 The Day of Resurrection (2)",
    "day_number": 67
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 33 The Day of Resurrection (3)",
    "day_number": 68
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 34 The Lake of Galilee (1)",
    "day_number": 69
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 34 The Lake of Galilee (2)",
    "day_number": 70
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 35 Peter's Love and Work (1)",
    "day_number": 71
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 35 Peter's Love and Work (2)",
    "day_number": 72
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 36 The Life-Plan of Peter and John (1)",
    "day_number": 73
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 36 The Life-Plan of Peter and John (2)",
    "day_number": 74
  },
  {
    "id": "90000000-0000-0000-0000-000000000235",
    "value": "Chapter 37 Back to the Father",
    "day_number": 75
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "CHAPTER 1. Our Lives kept for Jesus (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "CHAPTER 1. Our Lives kept for Jesus (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "CHAPTER 1. Our Lives kept for Jesus (3)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "CHAPTER 1. Our Lives kept for Jesus (4)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "CHAPTER 2. Our Moments kept for Jesus (1)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "CHAPTER 2. Our Moments kept for Jesus (2)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 3. Our Hands Kept for Jesus (1)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 3. Our Hands Kept for Jesus (2)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 3. Our Hands Kept for Jesus (3)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 4. Our Feet kept for Jesus",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 5. Our Voices kept for Jesus (1)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 5. Our Voices kept for Jesus (2)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 5. Our Voices kept for Jesus (3)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 6. Our Lips kept for Jesus (1)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 6. Our Lips kept for Jesus (2)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 6. Our Lips kept for Jesus (3)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 7. Our Silver and Gold Kept for Jesus (1)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 7. Our Silver and Gold Kept for Jesus (2)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 7. Our Silver and Gold Kept for Jesus (3)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 8. Our Intellects kept for Jesus",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 9. Our Wills kept for Jesus (1)",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 9. Our Wills kept for Jesus (2)",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 10. Our hearts kept for Jesus",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 11. Our love kept for Jesus (1)",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 11. Our love kept for Jesus (2)",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 12. Our Selves kept for Jesus (1)",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 12. Our Selves kept for Jesus (2)",
    "day_number": 27
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 13. Christ for Us (1)",
    "day_number": 28
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 13. Christ for Us (2)",
    "day_number": 29
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 13. Christ for Us (3)",
    "day_number": 30
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 13. Christ for Us (4)",
    "day_number": 31
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 13. Christ for Us (5)",
    "day_number": 32
  },
  {
    "id": "90000000-0000-0000-0000-000000000236",
    "value": "Chapter 13. Christ for Us (6)",
    "day_number": 33
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Come up in the morning . . . and present yourself . . . to me on top of the mountain. Ex. 34. 2.",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "My reward is with me. Rev. 22. 12.",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Where are you? Gen. 3. 9.",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Many are the afflictions of the righteous, but the Lord delivereth him out of them all. Psa. 34. 19.",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The Lord is my . . . song. Psa. 118. 14.",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Do not be afraid; stand still and see the Lord's salvation. Ex. 14. 13.",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Now you are light in the Lord: walk as children of light. Eph. 5. 8.",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Take great care of your souls. Josh. 23. 11. ( Margin. )",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "He that is faithful in that which is least, is faithful also in much. Luke 16. 10.",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "My God shall supply all your need according to His riches in glory by Christ Jesus. Phil. 4. 19.",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Count it all joy when you face various trials. James 1. 2.",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Blessed are they that have not seen, and yet have believed. John 20. 29.",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "My Father is glorified when you bear much fruit. John 15. 8.",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Every day I will bless you and praise your name forever. Psa. 145. 2.",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "They shall mount up with wings as eagles; they shall run, and not be weary; they shall walk, and not faint.—Isa. 40. 31.",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "And Moses was in the mount forty days and forty nights. Ex. 24. 18.",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Elisha said, Lord, please open his eyes so that he may see. 2 Kings 6. 17.",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "All things work together for good to them that love God. Rom. 8. 28.",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Make holy garments for Aaron. Ex. 28. 2.",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Lord, you will hear my voice in the morning; I will pray to you and look up. Psa 5. 3.",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Show me your ways, O Lord; teach me your paths. Psa. 25. 4.",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "There remaineth therefore a rest to the people of God. Heb. 4. 9.",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Under His shadow. Song of Sol. 2. 3.",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "He made as though He would have gone further. Luke 24. 28.",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "My God shall be my strength. Isa. 49. 5.",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Despising the shame. Heb. 12. 2.",
    "day_number": 27
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Are there not twelve hours in the day? John 11. 9.",
    "day_number": 28
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Not as I will, but as you will. Matt. 26. 39.",
    "day_number": 29
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The living God. Dan. 6. 20.",
    "day_number": 30
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Christ is all, and in all. Col. 3. 11.",
    "day_number": 31
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Continue in prayer. Col. 4. 2.",
    "day_number": 32
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "In Him the whole building, joined together, grows into a holy temple in the Lord. Eph. 2. 21.",
    "day_number": 33
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Love not the world. 1 John 2. 15.",
    "day_number": 34
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "You open your hand and satisfy the desire of every living thing. Psa. 145. 16.",
    "day_number": 35
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Anyone who says they remain in Christ should walk as Christ walked. 1 John 2. 6.",
    "day_number": 36
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Then shall we know, if we follow on to know the Lord. Hosea 6. 3.",
    "day_number": 37
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Leave your country, your relatives, and your father's house. Gen. 12. 1.",
    "day_number": 38
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Abraham . . . was gathered to his people. Gen. 25. 8.",
    "day_number": 39
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Therefore the Lord will wait so that He may be gracious to you. Isa. 30. 18.",
    "day_number": 40
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "He loves our nation and has built us a synagogue. Luke 7. 5.",
    "day_number": 41
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "As many as I love I . . . chasten. Rev. 3. 19.",
    "day_number": 42
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "What means these stones? Josh. 4. 21.",
    "day_number": 43
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "You also, as living stones. 1 Pet. 2. 5. (R. V.)",
    "day_number": 44
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "All . . . saw his face as it had been the face of an angel Acts 6. 15.",
    "day_number": 45
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "At the commandment of the Lord they rested in the tents, and at the commandment of the Lord they journeyed. Num. 9. 23.",
    "day_number": 46
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "In Him, after you believed, you were sealed with the promised Holy Spirit. Eph. 1. 13.",
    "day_number": 47
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Do not boast about tomorrow. Prov. 27. 1.",
    "day_number": 48
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "I will help you, says the Lord. Isa. 41. 14.",
    "day_number": 49
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "To every man his work. Mark 13. 34.",
    "day_number": 50
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Bring some of the fish you have just caught. John 21. 10.",
    "day_number": 51
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "By faith Abraham, when he was called to go out into a place which he should after receive for an inheritance, obeyed. Heb. 11. 8.",
    "day_number": 52
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The Lord is a God of knowledge, and by Him actions are weighed. 1 Sam. 2. 3.",
    "day_number": 53
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "After you were enlightened, you endured a hard struggle with suffering. Heb. 10. 32.",
    "day_number": 54
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Your gentleness has made me great. 2 Sam. 22. 36.",
    "day_number": 55
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Jacob went on his way, and the angels of God met him. Gen. 32. 1.",
    "day_number": 56
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "I am the way, the truth, and the life: no one comes to the Father except through me. John 14. 6.",
    "day_number": 57
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Forgetting those things which are behind . . . I press toward the mark for the prize of the high calling of God in Christ Jesus. Phil. 3. 13, 14.",
    "day_number": 58
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Come up in the morning . . . and present yourself to me on top of the mountain. Ex. 34. 2.",
    "day_number": 59
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Whatsoever a man soweth, that shall he also reap. Gal. 6. 7.",
    "day_number": 60
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "It is an eleven-day journey from Horeb by way of Mount Seir to Kadesh-barnea. Deut. 1. 2.",
    "day_number": 61
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "If we confess our sins, He is faithful and just to forgive us our sins, and to cleanse us from all unrighteousness. 1 John 1. 9.",
    "day_number": 62
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "As captain of the host of the Lord am I now come. Josh. 5. 14.",
    "day_number": 63
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "To me to live is Christ, and to die is gain. Phil. 1. 21.",
    "day_number": 64
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The one who sent me is with me; the Father has not left me alone, for I always do what pleases Him. John 8. 29.",
    "day_number": 65
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Quench not the Spirit. 1 Thess. 5. 19.",
    "day_number": 66
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "When He comes into the world, He says, . . . You have prepared a body for me. Heb. 10. 5.",
    "day_number": 67
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Full of [satisfied with] years. Gen. 25. 8.",
    "day_number": 68
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "You will receive power when the Holy Spirit comes upon you, and you will be my witnesses. Acts 1. 8.",
    "day_number": 69
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Those who remain in Me, and I in them, bear much fruit; apart from Me you can do nothing. John 15. 5.",
    "day_number": 70
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "He that eateth Me, even he shall live by Me. John 6. 57.",
    "day_number": 71
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "I sought Him, but I found Him not. Song of Sol. 3. 1.",
    "day_number": 72
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Come behind in no gift. 1 Cor. 1. 7.",
    "day_number": 73
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "They rest not day and night. Rev. 4. 8.",
    "day_number": 74
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Their eyes were holden. Luke 24. 16.",
    "day_number": 75
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Their eyes were opened. Luke 24. 31.",
    "day_number": 76
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "All things work together for good to them that love God. Rom. 8. 28.",
    "day_number": 77
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "He leadeth me in the paths of righteousness for His name's sake. Ps. 23. 3.",
    "day_number": 78
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "And he said, O my Lord, please send someone else. Ex. 4. 13.",
    "day_number": 79
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Be careful how you live. Eph. 5. 15.",
    "day_number": 80
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "She took for him an ark of bulrushes . . . and she laid it in the flags by the river's brink. Ex. 2. 3.",
    "day_number": 81
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Carry one another's burdens, and so fulfill the law of Christ. Gal. 6. 2.",
    "day_number": 82
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "I have finished the work you gave Me to do. John 17. 4.",
    "day_number": 83
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "A great multitude . . . stood before the throne. Rev. 7. 9.",
    "day_number": 84
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "God saw the light, that it was good: and God divided the light from the darkness. Gen. 1. 4.",
    "day_number": 85
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The path of the righteous is like the rising light that shines brighter and brighter until full daylight. Prov. 4. 18.",
    "day_number": 86
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Take us the foxes, the little foxes, that spoil the vineyards; for our vineyards are in blossom. Song of Sol. 2. 15. (R. V.)",
    "day_number": 87
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The children of your Father which is in heaven. Matt. 5. 45.",
    "day_number": 88
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "In the morning the word of the Lord came to me. Ezek. 12. 8.",
    "day_number": 89
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The Lord God formed man out of the dust of the ground, and breathed into his nostrils the breath of life; and man became a living soul. Gen. 2. 7.",
    "day_number": 90
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Always rejoicing. 2 Cor. 6. 10.",
    "day_number": 91
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "All the land you see I will give to you and your descendants forever. Gen. 13. 15.",
    "day_number": 92
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "That night they caught nothing. John 21. 3.",
    "day_number": 93
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "We came to the land where you sent us . . . we saw the descendants of Anak there. Num. 13. 27, 28.",
    "day_number": 95
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Each one resembled the children of a king. Judg. 8. 18.",
    "day_number": 96
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "He maketh me to lie down in green pastures: He leadeth me beside the still waters. Psa. 23. 2.",
    "day_number": 97
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "A daily rate for every day. 2 Kings 25. 30.",
    "day_number": 98
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Carry one another's burdens, and so fulfill the law of Christ. Gal. 6. 2.",
    "day_number": 99
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Work out your own salvation with fear and trembling: for it is God which worketh in you both to will and to do of His good pleasure. Phil. 2. 12, 13.",
    "day_number": 100
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "God . . . has shone in our hearts, giving us the light of the knowledge of God's glory in the face of Jesus Christ. 2 Cor. 4. 6.",
    "day_number": 101
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "My soul, wait only for God. Psa. 62. 5.",
    "day_number": 102
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Could you not stay awake with me for one hour? Matt. 26. 40.",
    "day_number": 103
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "My meat is to do the will of Him that sent me. John 4. 34.",
    "day_number": 104
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "It is God which worketh in you, both to will and to do of His good pleasure. Phil. 2. 13.",
    "day_number": 105
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Having . . . boldness to enter into the holiest by the blood of Jesus . . . let us draw near with a true heart. Heb. 10. 19, 22.",
    "day_number": 106
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "They that wait upon the Lord shall . . . mount up with wings as eagles. Isa. 40. 31.",
    "day_number": 107
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Perfect love casteth out fear. 1 John 4. 18.",
    "day_number": 108
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The love of Christ constraineth us. 2 Cor. 5. 14.",
    "day_number": 109
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "I, the Lord your God, will hold your right hand, saying to you, Do not fear; I will help you. Isa. 41. 13.",
    "day_number": 110
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Consider the great things He has done for you. 1 Sam. 12. 24.",
    "day_number": 111
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "To Him be glory both now and forever. 2 Pet. 3. 18.",
    "day_number": 112
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "You will know that I am the Lord, for those who wait for me will not be ashamed. Isa. 49. 23.",
    "day_number": 113
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Let it be for you as you wish. Matt. 15. 28.",
    "day_number": 114
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "You are my God; I will seek you early. Psa. 63. 1.",
    "day_number": 115
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "In Him was life; and the life was the light of men. John 1. 4. You are the light of the world. Matt. 5. 14.",
    "day_number": 116
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Be steadfast, immovable, always doing the Lord's work abundantly. 1 Cor. 15. 58.",
    "day_number": 117
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Looking up to heaven He sighed. Mark 7. 34.",
    "day_number": 118
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "We glory in tribulations. Rom. 5. 3.",
    "day_number": 119
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Set your affection on things above, not on things on the earth. Col. 3. 2.",
    "day_number": 120
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The Lord has indeed risen and has appeared to Simon. Luke 24. 34.",
    "day_number": 121
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "They . . . gladly received Peter's word; about three thousand people joined them that day. Acts 2. 41.",
    "day_number": 122
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The righteous eateth to the satisfying of his soul. Prov. 13. 25.",
    "day_number": 123
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The Lord disciplines those He loves. Heb. 12. 6.",
    "day_number": 124
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The blood of Jesus Christ, His Son, cleanseth us from all sin. 1 John 1. 7.",
    "day_number": 125
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Do whatever He tells you. John 2. 5.",
    "day_number": 126
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "I know how to abound. Phil. 4. 12.",
    "day_number": 127
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Whosoever exalteth himself shall be abased; and he that humbleth himself shall be exalted. Luke 14. 11.",
    "day_number": 128
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "For their sakes I sanctify myself, that they also might be sanctified through the truth. John 17. 19.",
    "day_number": 129
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "He that is slow to anger is better than the mighty; and he that ruleth his spirit than he that taketh a city. Prov. 16. 32.",
    "day_number": 130
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Seek God's kingdom and His righteousness first, and all these things will be given to you. Matt. 6. 33.",
    "day_number": 131
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "His praise shall continually be in my mouth. Psa. 34. 1.",
    "day_number": 132
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "I am not able to bear all this people alone, because it is too heavy for me. Num. 11. 14.",
    "day_number": 133
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "While I was musing the fire burned. Psa. 39. 3.",
    "day_number": 134
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Hide yourself by the brook. 1 Kings 17. 3.",
    "day_number": 135
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "His kingdom ruleth over all. Psa. 103. 19.",
    "day_number": 136
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "If we suffer we shall also reign with Him. 2 Tim. 2. 12.",
    "day_number": 137
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Guard your heart carefully, for life flows from it. Prov. 4. 23.",
    "day_number": 138
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Whatever you do, . . . do everything in the name of the Lord Jesus. Col. 3. 17.",
    "day_number": 139
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Him they compelled to bear His cross. Matt. 27. 32.",
    "day_number": 140
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Our Lord Jesus Christ . . . gave Himself for our sins that He might deliver us from this present evil world. Gal. 1. 4.",
    "day_number": 141
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "You are the light of the world. A city that is set on an hill cannot be hid. Matt. 5. 14.",
    "day_number": 142
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Without me you can do nothing. John 15. 5.",
    "day_number": 143
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "I can do all things, through Christ which strengtheneth me. Phil. 4. 13.",
    "day_number": 144
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "As my Father has sent me, so I send you. John 20. 21.",
    "day_number": 145
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "A fountain . . . for sin and for uncleanness. Zech. 13. 1.",
    "day_number": 146
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "I am my beloved's, and his desire is toward me. Song of Sol. 7. 10.",
    "day_number": 148
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "David enquired of the Lord. 2 Sam. 5. 19.",
    "day_number": 149
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "As many of you as have been baptized into Christ have put on Christ. Gal. 3. 27.",
    "day_number": 150
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "You will never wash my feet. John 13. 8.",
    "day_number": 151
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Cast your burden on the Lord, and He will sustain you. Psa. 55. 22.",
    "day_number": 152
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Well done, good and faithful servant. . . . You wicked and lazy servant. Matt. 25. 21, 26.",
    "day_number": 153
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Jesus constrained His disciples to get into a ship. Matt. 14. 22.",
    "day_number": 154
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Work to show yourself approved by God, a worker who need not be ashamed and who handles the word of truth rightly. 2 Tim. 2. 15.",
    "day_number": 155
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Come out from among them and be separate. 2 Cor. 6. 17.",
    "day_number": 156
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "I am with you and will keep you wherever you go, and I will bring you back to this land. Gen. 28. 15.",
    "day_number": 157
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "I have appointed you . . . to bring salvation to the ends of the earth. Acts 13. 47.",
    "day_number": 158
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "You will be my witnesses . . . to the ends of the earth. Acts 1. 8.",
    "day_number": 159
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "I know whom I have believed. 2 Tim. 1. 12.",
    "day_number": 160
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Wait for the promise of the Father. Acts 1. 4.",
    "day_number": 161
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "We have come to know and believe the love God has for us. 1 John 4. 16.",
    "day_number": 162
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Endure . . . as a good soldier of Jesus Christ. 2 Tim. 2. 3.",
    "day_number": 163
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Whoever does not carry their cross and follow me cannot be my disciple. Luke 14. 27.",
    "day_number": 164
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "These . . . have turned the world upside down. Acts 17. 6.",
    "day_number": 165
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "You do not understand what I am doing now, but you will understand later. John 13. 7.",
    "day_number": 166
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Your strength will match your days. Deut. 33. 25.",
    "day_number": 167
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "I can do all things through Christ which strengtheneth me. Phil. 4. 13.",
    "day_number": 168
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Your heart is not right in God's sight. Acts 8. 21.",
    "day_number": 169
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The Holy Ghost said, Separate me Barnabas and Saul for the work whereunto I have called them. Acts 13. 2.",
    "day_number": 170
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Small things. Zech. 4. 10.",
    "day_number": 171
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Be perfect, be of good comfort. 2 Cor. 13. 11.",
    "day_number": 172
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Therefore, be perfect, as your Father in heaven is perfect. Matt. 5. 48.",
    "day_number": 173
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Sleep on now, and take your rest. Mark 14. 41.",
    "day_number": 174
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Let us not sleep, as do others. 1 Thess. 5. 6.",
    "day_number": 175
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "He placed His right hand on me and said, Do not be afraid. Rev. 1. 17.",
    "day_number": 176
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Being seen of them forty days, and speaking of the things pertaining to the kingdom of God. Acts 1. 3.",
    "day_number": 177
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "I leave you peace; I give you my peace . . . do not let your hearts be troubled or afraid. John 14. 27.",
    "day_number": 178
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Isaac dwelt by the well Lahai-roi. Gen. 25. 11.",
    "day_number": 179
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Judas Iscariot . . . was a thief, and had the bag, and bore what was put therein. John 12. 4, 6.",
    "day_number": 180
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "You have received freely; give freely. Matt. 10. 8.",
    "day_number": 181
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Let every man take heed how he buildeth. 1 Cor. 3. 10.",
    "day_number": 182
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Your strength will match your days. Deut. 33. 25.",
    "day_number": 183
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Surely the Lord is in this place, and I knew it not. Gen. 28. 16.",
    "day_number": 184
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "My meat is to do the will of Him that sent me. John 4. 34.",
    "day_number": 185
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Giving all diligence, add to your faith virtue. 2 Pet. 1. 5.",
    "day_number": 186
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Awake, north wind; come, south wind; blow upon my garden so its spices may flow out. Song of Sol. 4. 16.",
    "day_number": 187
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Awake, north wind; come, south wind; blow upon my garden so its spices may flow out. Song of Sol. 4. 16.",
    "day_number": 188
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Look at the man! John 19. 5.",
    "day_number": 189
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "John said, Look, the Lamb of God! The two disciples heard him and followed Jesus. John 1. 36, 37.",
    "day_number": 190
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "You must not eat from it. Gen. 3. 3.",
    "day_number": 191
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Let patience finish its work so that you may be complete and lack nothing. James 1. 4.",
    "day_number": 192
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Sow beside all waters. Isa. 32. 20.",
    "day_number": 193
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Hold me up, and I will be safe. Psa. 119. 117.",
    "day_number": 194
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Lord, my servant lieth at home sick of the palsy. Matt. 8. 6.",
    "day_number": 195
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Blessed is the man . . . that keepeth the Sabbath. Isa. 56. 2.",
    "day_number": 196
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Cleanse me from hidden faults. Psa. 19. 12.",
    "day_number": 197
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Do what is good. 2 Kings 10. 5.",
    "day_number": 198
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Grow in grace, and in the knowledge of our Lord and Savior, Jesus Christ. 2 Pet. 3. 18.",
    "day_number": 199
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Sin, taking occasion by the commandment, deceived, and by it slew me. Rom. 7. 11.",
    "day_number": 200
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Your heavenly Father knows. Matt. 6. 32.",
    "day_number": 201
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "You have died, and your life is hidden with Christ in God. Col. 3. 3.",
    "day_number": 202
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Let him that thinketh he standeth take heed lest he fall. 1 Cor 10. 12.",
    "day_number": 203
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Continue in prayer. Col. 4. 2.",
    "day_number": 204
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Now you are light in the Lord: walk as children of light. Eph. 5. 8.",
    "day_number": 205
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Created in Christ Jesus for good works. Eph. 2. 10.",
    "day_number": 206
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Go in this strength of yours . . . have I not sent you? Judges 6. 14.",
    "day_number": 207
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Set your affection on things above, not on things on the earth. Col. 3. 2.",
    "day_number": 208
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "They took knowledge of them, that they had been with Jesus. Acts 4. 13.",
    "day_number": 209
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "You call me Teacher and Lord, and you are right, for that is what I am. John 13. 13. (R. V. margin).",
    "day_number": 210
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The Father sent the Son to be the Savior of the world. 1 John 4. 14.",
    "day_number": 211
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "They that wait upon the Lord shall change their strength. Isa. 40. 31. (R. V.)",
    "day_number": 212
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "As for you, the Lord your God has not allowed you to do this. Deut. 18. 14.",
    "day_number": 213
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Leaving you an example for you to follow in His steps. 1 Pet. 2. 21. (R. V.)",
    "day_number": 214
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "You must have no other gods before me. Ex. 20. 3.",
    "day_number": 215
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Follow my example, as I follow Christ. 1 Cor. 11. 1.",
    "day_number": 216
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Serving the Lord with all humility of mind. Acts 20. 19.",
    "day_number": 217
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "My grace is enough for you, for my strength is made perfect in weakness. 2 Cor. 12. 9.",
    "day_number": 218
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Remain in me, and I in you. Just as a branch cannot bear fruit unless it remains in the vine, neither can you unless you remain in me. John 15. 4.",
    "day_number": 219
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "By faith Noah . . . prepared an ark to the saving of his house. Heb. 11. 7.",
    "day_number": 220
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "We are His workmanship, created in Christ Jesus for good works that God prepared beforehand for us to do. Eph. 2. 10.",
    "day_number": 221
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "He . . . began to wash the disciples' feet. John 13. 5.",
    "day_number": 222
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "I am the Lord, I change not. Mal. 3. 6.",
    "day_number": 223
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "I will cause the shower to come down in his season; there shall be showers of blessing. Ezek. 34. 26.",
    "day_number": 224
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Nevertheless, at your word. Luke 5. 5.",
    "day_number": 225
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "If we suffer, we shall also reign with Him. 2 Tim. 2. 12.",
    "day_number": 226
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The word of God, which lives and remains forever. 1 Pet. 1. 23.",
    "day_number": 227
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Let the peace of God rule in your hearts. Col. 3. 15.",
    "day_number": 228
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "You serve the Lord Christ. Col. 3. 24.",
    "day_number": 229
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Love not the world, neither the things that are in the world. 1 John 2. 15.",
    "day_number": 230
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "I would have you without carefulness. 1 Cor. 7. 32.",
    "day_number": 231
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The Lord God says: I will let the house of Israel ask me to do this for them. Ezek. 36. 37.",
    "day_number": 232
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Let us not be weary in well doing, for in due season we shall reap if we faint not. Gal. 6. 9.",
    "day_number": 233
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "My presence will go with you. Ex. 33. 14.",
    "day_number": 234
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "To the Lord our God belong mercies and forgiveness. Dan. 9. 9.",
    "day_number": 235
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "It is high time to awake out of sleep. Rom. 13. 11.",
    "day_number": 236
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The church of God, which He purchased with His own blood. Acts 20. 28.",
    "day_number": 237
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "May the God of hope fill you with all joy and peace as you believe, so that you may overflow with hope by the power of the Holy Spirit. Rom. 15. 13.",
    "day_number": 238
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "He asked you for life, and you gave it to him, length of days forever and ever. Psa. 21. 4.",
    "day_number": 239
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "This beginning of miracles did Jesus. John 2. 11.",
    "day_number": 240
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "In the daytime . . . He led them with a cloud, and all the night with a light of fire. Psa. 78. 14.",
    "day_number": 241
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Look, we are going up to Jerusalem. Matt. 20. 18.",
    "day_number": 242
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "These were the potters, and those that dwelt among plants and hedges: there they dwelt with the king for his work. 1 Chron. 4. 23.",
    "day_number": 243
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "I will instruct you and teach you the way to go; I will guide you while watching over you. Psa. 32. 8.",
    "day_number": 244
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The Son of Man came not to be served but to serve, and to give His life as a ransom for many. Matt. 20. 28.",
    "day_number": 245
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Jesus . . . went about doing good. Acts 10. 38.",
    "day_number": 246
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The angel of the Lord said to her [Hagar], Return to your mistress and submit to her authority. Gen. 16. 9.",
    "day_number": 247
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Then Solomon spoke . . . I have built you a house to dwell in. 1 Kings 8. 12, 13.",
    "day_number": 248
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "I have chosen you in the furnace of affliction. Isa. 48. 10.",
    "day_number": 249
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "God has chosen what the world considers lowly and despised. 1 Cor. 1. 28.",
    "day_number": 250
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Serve the Lord with gladness; come before His presence with singing. Psa. 100. 2.",
    "day_number": 251
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "When you pray, go into your room, shut the door, and pray to your Father in secret. Matt. 6. 6.",
    "day_number": 252
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Be holy, for I am holy. 1 Pet. 1. 16.",
    "day_number": 253
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "And the Lord said, Shall I hide from Abraham that thing which I do? Gen. 18. 17.",
    "day_number": 254
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The life which I now live in the flesh. Gal. 2. 20.",
    "day_number": 255
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Teach us to number our days so that we may gain wisdom. Psa. 90. 12.",
    "day_number": 256
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Christ in you the hope of glory. Col. 1. 27.",
    "day_number": 257
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Wait for the promise of the Father. Acts 1. 4.",
    "day_number": 258
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "This is the victory that overcometh the world, even our faith. 1 John 5. 4.",
    "day_number": 259
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "He will command His angels to watch over you in all your ways. Psa. 91. 11.",
    "day_number": 260
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "At Jesus' feet. Luke 10. 39.",
    "day_number": 261
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "God is love; and he that dwelleth in love dwelleth in God, and God in him. 1 John 4. 16.",
    "day_number": 262
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "They took knowledge of them that they had been with Jesus. Acts 4. 13.",
    "day_number": 263
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Be not afraid, only believe. Mark 5. 36.",
    "day_number": 264
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Happy is the man whom God correcteth. Job 5. 17.",
    "day_number": 265
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "When they saw the star they rejoiced with exceeding great joy. Matt. 2. 10.",
    "day_number": 266
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "When I sit in darkness, the Lord will be my light. Micah 7. 8.",
    "day_number": 267
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "I (Daniel) was left alone, and saw this great vision. Dan. 10. 8.",
    "day_number": 268
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Come and dine. John 21. 12.",
    "day_number": 269
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "O Lord God, you know! Ezek. 37. 3.",
    "day_number": 270
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "There was a ladder set up on the earth, with its top reaching heaven. Gen. 28. 12.",
    "day_number": 271
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Surely God is in this place, and I knew it not. Gen. 28. 16.",
    "day_number": 272
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Let us who are of the day be sober, putting on the breastplate of faith and love, and for a helmet, the hope of salvation. 1 Thess. 5. 8.",
    "day_number": 273
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The word of our God shall stand forever. Isa. 40. 8.",
    "day_number": 274
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "I spoke to you in your prosperity. Jer. 22. 21.",
    "day_number": 275
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Surely He will deliver you from the fowler's snare. Psa. 91. 3.",
    "day_number": 276
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The Lord set a mark upon Cain. Gen. 4. 15.",
    "day_number": 277
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Be faithful until death, and I will give you a crown of life. Rev. 2. 10.",
    "day_number": 278
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Flee into Egypt. Matt. 2. 13.",
    "day_number": 279
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Your servant will do as my lord the king has said. 1 Kings 2. 38.",
    "day_number": 280
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Let your light so shine before men, that they may see your good works, and glorify your Father which is in heaven. Matt. 5. 16.",
    "day_number": 281
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Listen, I bring you good news of great joy for all people. Luke 2. 10.",
    "day_number": 282
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The Lord disciplines those He loves. Heb. 12. 6.",
    "day_number": 283
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Whatever you ask the Father in my name, He will give you. John 16. 23.",
    "day_number": 284
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "He placed . . . cherubims, and a flaming sword . . . to keep the way of the tree of life. Gen. 3. 24.",
    "day_number": 285
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Blessed are they that do His commandments, that they may have right to the tree of life. Rev. 22. 14.",
    "day_number": 286
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Jesus was left alone, and the woman standing in the midst. John 8. 9.",
    "day_number": 287
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "You will show me the path of life; in your presence is fullness of joy; at your right hand are pleasures forever. Psa. 16. 11.",
    "day_number": 288
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Be clothed with humility. 1 Pet. 5. 5.",
    "day_number": 289
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Jacob looked up and saw Esau coming with four hundred men. Gen. 33. 1.",
    "day_number": 290
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Let us cleanse ourselves from all filthiness of the flesh and spirit, perfecting holiness in the fear of God. 2 Cor. 7. 1.",
    "day_number": 291
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The pillar of the cloud went from before their face, and stood behind them. Ex. 14. 19.",
    "day_number": 292
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Iniquities overwhelm me; you will forgive our transgressions. Psa. 65. 3.",
    "day_number": 293
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Speaking the truth in love. Eph. 4. 15.",
    "day_number": 294
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "So he arose, and went to Zarephath. 1 Kings 17. 10.",
    "day_number": 295
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "A daily rate for every day. 2 Kings 25. 30.",
    "day_number": 296
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Examine yourselves. 2 Cor. 13. 5.",
    "day_number": 297
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Choose today whom you will serve. Josh. 24. 15.",
    "day_number": 298
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Lord, you have been our dwelling place through all generations. Psa. 90. 1.",
    "day_number": 299
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "He has said. Heb. 13. 5.",
    "day_number": 300
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Not I, but Christ liveth in me. Gal. 2. 20.",
    "day_number": 301
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Who is my neighbor? Luke 10. 29.",
    "day_number": 302
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "They shall rejoice, and shall see the plummet in the hand of Zerubbabel. Zech. 4. 10.",
    "day_number": 303
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "In the world you will have trouble; but take heart, for I have overcome the world. John 16. 33.",
    "day_number": 304
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "I . . . heard behind me a great voice, as of a trumpet, saying . . . Write. Rev. 1. 10, 11.",
    "day_number": 305
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The Lord disciplines those He loves. Heb. 12. 6.",
    "day_number": 306
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Faithful is He that calleth you, who also will do it. 1 Thess. 5. 24.",
    "day_number": 307
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Singing with grace in your hearts to the Lord. Col. 3. 16.",
    "day_number": 308
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Call to remembrance the former days. Heb. 10. 32.",
    "day_number": 309
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The Lord . . . your dwelling place. Psa. 91. 9.",
    "day_number": 310
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "These have turned the world upside down. Acts 17. 6.",
    "day_number": 311
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "None of these things move me. Acts 20. 24.",
    "day_number": 312
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "He touched the hollow of Jacob's thigh in the sinew that shrank. Gen. 32. 32.",
    "day_number": 313
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "With God all things are possible. Mark 10. 27.",
    "day_number": 314
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "You are the temple of the living God; as God has said, I will dwell among them and walk among them. 2 Cor. 6. 16.",
    "day_number": 315
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Without Christ. Eph. 2. 12.",
    "day_number": 316
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "When I am weak, then am I strong. 2 Cor. 12. 10.",
    "day_number": 317
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Holy men of God spoke as they were moved by the Holy Spirit. 2 Pet. 1. 21.",
    "day_number": 318
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "They all forsook Him, and fled. Mark 14. 50.",
    "day_number": 319
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Belshazzar the king made a great feast. Dan. 5. 1.",
    "day_number": 320
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "He that watereth shall be watered also himself. Prov. 11. 25.",
    "day_number": 321
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "They came to Him, bringing a man who was paralyzed. Mark 2. 3.",
    "day_number": 322
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Bless the Lord, O my soul, and do not forget His benefits . . . He crowns you with loving kindness and tender mercies. Ps. 103. 2, 4.",
    "day_number": 323
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Then you will discern between the righteous and the wicked. Mal. 3. 18.",
    "day_number": 324
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "What is your life? It is even a vapor, that appeared for a little time, and then vanisheth away. James 4. 14.",
    "day_number": 325
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "He (Jesus) . . . looked up to heaven. Mark 6. 41.",
    "day_number": 326
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The disciples were called Christians first in Antioch. Acts 11. 26.",
    "day_number": 327
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Having therefore these promises. 2 Cor. 7. 1.",
    "day_number": 328
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Faith, hope, and love remain, these three; but the greatest of these is love. 1 Cor. 13. 13. (R. V.)",
    "day_number": 329
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "He (Thomas) . . . said, Except I shall see . . . I will not believe. . . . Jesus . . . said . . . Be not faithless, but believing. John 20. 25, 27.",
    "day_number": 330
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Lot . . . pitched his tent toward Sodom. Gen. 13. 12.",
    "day_number": 331
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Cleanse me from hidden faults. Psa. 19. 12.",
    "day_number": 332
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "A hearer of the word . . . a doer of the work. Jas. 1. 23, 25.",
    "day_number": 333
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "You do not know what tomorrow will bring. James 4. 14.",
    "day_number": 334
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The sea wrought, and was tempestuous. Jonah 1. 11.",
    "day_number": 335
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Be not doubtful, but followers of them also, through faith and patience, inherit the promises. Heb. 6. 12.",
    "day_number": 336
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Go and sit down in the lowest room. Luke 14. 10.",
    "day_number": 337
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Continue in prayer. Col. 4. 2.",
    "day_number": 338
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "A multitude of the heavenly host praising God, and saying, Glory to God in the highest. Luke 2. 13, 14.",
    "day_number": 339
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "God forbid that I should glory save in the cross of our Lord Jesus Christ. Gal. 6. 14.",
    "day_number": 340
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "He ever liveth. Heb. 7. 25.",
    "day_number": 341
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "The friendship of the world is enmity with God. James 4. 4.",
    "day_number": 342
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Hannah . . . prayed to the Lord and wept bitterly . . . she spoke in her heart. 1 Sam. 1. 10, 13.",
    "day_number": 343
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Noah found grace in the eyes of the Lord. Gen. 6. 8.",
    "day_number": 344
  },
  {
    "id": "90000000-0000-0000-0000-000000000242",
    "value": "Which hope we have as an anchor to the soul. Heb. 6. 19.",
    "day_number": 346
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 1. THE CHRISTIAN'S WARFARE (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 1. THE CHRISTIAN'S WARFARE (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 2. INTERNAL FOES (1)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 2. INTERNAL FOES (2)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 2. INTERNAL FOES (3)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 3. EXTERNAL FOES (1)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 3. EXTERNAL FOES (2)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 3. EXTERNAL FOES (3)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 3. EXTERNAL FOES (4)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 3. EXTERNAL FOES (5)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 3. EXTERNAL FOES (6)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 3. EXTERNAL FOES (7)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 3. EXTERNAL FOES (8)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 3. EXTERNAL FOES (9)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 3. EXTERNAL FOES (10)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 3. EXTERNAL FOES (11)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 3. EXTERNAL FOES (12)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 3. EXTERNAL FOES (13)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 3. EXTERNAL FOES (14)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 3. EXTERNAL FOES (15)",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 3. EXTERNAL FOES (16)",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 3. EXTERNAL FOES (17)",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 3. EXTERNAL FOES (18)",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000243",
    "value": "Part 3. EXTERNAL FOES (19)",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 1. TAKE AWAY THE STONE (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 1. TAKE AWAY THE STONE (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 1. TAKE AWAY THE STONE (3)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 2. LOVE, THE MOTIVE POWER FOR SERVICE (1)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 2. LOVE, THE MOTIVE POWER FOR SERVICE (2)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 2. LOVE, THE MOTIVE POWER FOR SERVICE (3)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 2. LOVE, THE MOTIVE POWER FOR SERVICE (4)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 3. FAITH AND COURAGE (1)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 3. FAITH AND COURAGE (2)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 3. FAITH AND COURAGE (3)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 3. FAITH AND COURAGE (4)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 4. FAITH REWARDED (1)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 4. FAITH REWARDED (2)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 5. ENTHUSIASM (1)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 5. ENTHUSIASM (2)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 5. ENTHUSIASM (3)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 6. THE POWER OF LITTLE THINGS (1)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 6. THE POWER OF LITTLE THINGS (2)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 6. THE POWER OF LITTLE THINGS (3)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 6. THE POWER OF LITTLE THINGS (4)",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 7. \"SHE HAS DONE WHAT SHE COULD.\" (1)",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 7. \"SHE HAS DONE WHAT SHE COULD.\" (2)",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 7. \"SHE HAS DONE WHAT SHE COULD.\" (3)",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 8. \"WHO IS MY NEIGHBOR?\" (1)",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 8. \"WHO IS MY NEIGHBOR?\" (2)",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 8. \"WHO IS MY NEIGHBOR?\" (3)",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 8. \"WHO IS MY NEIGHBOR?\" (4)",
    "day_number": 27
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 9. \"YOU ARE THE LIGHT OF THE WORLD.\" (1)",
    "day_number": 28
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 9. \"YOU ARE THE LIGHT OF THE WORLD.\" (2)",
    "day_number": 29
  },
  {
    "id": "90000000-0000-0000-0000-000000000244",
    "value": "Chapter 9. \"YOU ARE THE LIGHT OF THE WORLD.\" (3)",
    "day_number": 30
  },
  {
    "id": "90000000-0000-0000-0000-000000000245",
    "value": "Chapter 1 (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000245",
    "value": "Chapter 1 (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000245",
    "value": "Chapter 1 (3)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000245",
    "value": "Chapter 2. B e Not Deceived : G od Is Not Mocked  (1)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000245",
    "value": "Chapter 2. B e Not Deceived : G od Is Not Mocked  (2)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000245",
    "value": "Chapter 3. W hen a Man Sows, He Expects to Reap  (1)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000245",
    "value": "Chapter 3. W hen a Man Sows, He Expects to Reap  (2)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000245",
    "value": "Chapter 3. W hen a Man Sows, He Expects to Reap  (3)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000245",
    "value": "Chapter 4. A M an Expects to Reap the Same Kind as He Sows  (1)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000245",
    "value": "Chapter 4. A M an Expects to Reap the Same Kind as He Sows  (2)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000245",
    "value": "Chapter 5. A M an Reaps More Than He Sows ",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000245",
    "value": "Chapter 6. I gnorance of the Seed Makes no Difference  (1)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000245",
    "value": "Chapter 6. I gnorance of the Seed Makes no Difference  (2)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000245",
    "value": "Chapter 7. F orgiveness and Retribution (1)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000245",
    "value": "Chapter 7. F orgiveness and Retribution (2)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000245",
    "value": "Chapter 8. WARNING (1)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000245",
    "value": "Chapter 8. WARNING (2)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000245",
    "value": "Chapter 8. WARNING (3)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000245",
    "value": "Chapter 8. WARNING (4)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 1. THE OLD ORGAN (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 1. THE OLD ORGAN (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 2. CHRISTIE'S IMPORTANT CHARGE (1)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 2. CHRISTIE'S IMPORTANT CHARGE (2)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 3. ONLY ANOTHER MONTH (1)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 3. ONLY ANOTHER MONTH (2)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 3. ONLY ANOTHER MONTH (3)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 4. MABEL'S FIRST LESSON IN ORGAN-GRINDING (1)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 4. MABEL'S FIRST LESSON IN ORGAN-GRINDING (2)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 5. NO SIN IN THE CITY BRIGHT (1)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 5. NO SIN IN THE CITY BRIGHT (2)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 6. THE ONLY WAY INTO \"HOME, SWEET HOME.\" (1)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 6. THE ONLY WAY INTO \"HOME, SWEET HOME.\" (2)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 7. LITTLE MABEL'S SNOWDROPS (1)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 7. LITTLE MABEL'S SNOWDROPS (2)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 8. MADE MEET FOR HOME (1)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 8. MADE MEET FOR HOME (2)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 9. TREFFY ENTERS THE CITY (1)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 9. TREFFY ENTERS THE CITY (2)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 10. \"NO PLACE LIKE HOME.\" (1)",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 10. \"NO PLACE LIKE HOME.\" (2)",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 11. ALONE IN THE WORLD (1)",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 11. ALONE IN THE WORLD (2)",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 12. CHRISTIE WELL CARED FOR (1)",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 12. CHRISTIE WELL CARED FOR (2)",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 13. CHRISTIE'S WORK FOR THE MASTER (1)",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 13. CHRISTIE'S WORK FOR THE MASTER (2)",
    "day_number": 27
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 13. CHRISTIE'S WORK FOR THE MASTER (3)",
    "day_number": 28
  },
  {
    "id": "90000000-0000-0000-0000-000000000253",
    "value": "Chapter 14. \"HOME, SWEET HOME, AT LAST.\"",
    "day_number": 29
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 1",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 2 (1)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 2 (2)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 3 (1)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 3 (2)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 4 (1)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 4 (2)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 4 (3)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 5 (1)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 5 (2)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 5 (3)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 6 (1)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 6 (2)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 6 (3)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 7. Section 1  (1)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 7. Section 1  (2)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 7. Section 1  (3)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 7. Section 1  (4)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 7. Section 1  (5)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 7. Section 1  (6)",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 8 (1)",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 8 (2)",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 9 (1)",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 9 (2)",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 9 (3)",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 9 (4)",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 1 (1)",
    "day_number": 27
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 1 (2)",
    "day_number": 28
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 2 (1)",
    "day_number": 29
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 2 (2)",
    "day_number": 30
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 3 (1)",
    "day_number": 31
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 3 (2)",
    "day_number": 32
  },
  {
    "id": "90000000-0000-0000-0000-000000000255",
    "value": "Chapter 4",
    "day_number": 33
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 1. \"GETTING THINGS FROM GOD\"",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 2. EARLY LESSONS IN THE LIFE OF FAITH (1)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 2. EARLY LESSONS IN THE LIFE OF FAITH (2)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 3. \"GO FORWARD ON YOUR KNEES\" 1887-1894 (1)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 3. \"GO FORWARD ON YOUR KNEES\" 1887-1894 (2)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 3. \"GO FORWARD ON YOUR KNEES\" 1887-1894 (3)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 4. A GOD-GIVEN FIELD (1894-1900) (1)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 4. A GOD-GIVEN FIELD (1894-1900) (2)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 4. A GOD-GIVEN FIELD (1894-1900) (3)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 5. OUR DELIVERANCE FROM THE BOXERS (1900) (1)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 5. OUR DELIVERANCE FROM THE BOXERS (1900) (2)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 5. OUR DELIVERANCE FROM THE BOXERS (1900) (3)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 5. OUR DELIVERANCE FROM THE BOXERS (1900) (4)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 5. OUR DELIVERANCE FROM THE BOXERS (1900) (5)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 6. PROVING GOD'S FAITHFULNESS (1902-1908) (1)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 6. PROVING GOD'S FAITHFULNESS (1902-1908) (2)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 6. PROVING GOD'S FAITHFULNESS (1902-1908) (3)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 6. PROVING GOD'S FAITHFULNESS (1902-1908) (4)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 7. THE STORY OF ONE FURLOUGH (1908-1910) (1)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 7. THE STORY OF ONE FURLOUGH (1908-1910) (2)",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 7. THE STORY OF ONE FURLOUGH (1908-1910) (3)",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 8. OUR GOD OF THE IMPOSSIBLE (1)",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 8. OUR GOD OF THE IMPOSSIBLE (2)",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 8. OUR GOD OF THE IMPOSSIBLE (3)",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 8. OUR GOD OF THE IMPOSSIBLE (4)",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 9. TO HIS PRAISE!",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 10. VICTORY FOUND (1)",
    "day_number": 27
  },
  {
    "id": "90000000-0000-0000-0000-000000000256",
    "value": "Part 10. VICTORY FOUND (2)",
    "day_number": 28
  },
  {
    "id": "90000000-0000-0000-0000-000000000259",
    "value": "Part 3. PRINCELY SERVICE: Numbers 7",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000259",
    "value": "Part 1. Separation to God  (1)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000259",
    "value": "Part 1. Separation to God  (2)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000259",
    "value": "Part 1. Separation to God  (3)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000259",
    "value": "Part 1. Separation to God  (4)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000259",
    "value": "Part 1. Separation to God  (5)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000259",
    "value": "Part 2. The Blessing of God  (1)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000259",
    "value": "Part 2. The Blessing of God  (2)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000259",
    "value": "Part 2. The Blessing of God  (3)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000259",
    "value": "Part 2. The Blessing of God  (4)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000259",
    "value": "Part 2. The Blessing of God  (5)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000259",
    "value": "Part 2. The Blessing of God  (6)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000259",
    "value": "Part 3. Princely Service (1)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000259",
    "value": "Part 3. Princely Service (2)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000259",
    "value": "Part 3. Princely Service (3)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000259",
    "value": "Part 3. Princely Service (4)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000259",
    "value": "Part 3. Princely Service (5)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000260",
    "value": "Chapter 1. ALL ARE COMMANDED TO PRAY—PRAYER THE GREAT MEANS OF SALVATION, AND POSSIBLE AT ALL TIMES BY THE MOST SIMPLE",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000260",
    "value": "Chapter 2",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000260",
    "value": "Chapter 3. SECOND DEGREE OF PRAYER, CALLED HERE “THE PRAYER OF SIMPLICITY.”",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000260",
    "value": "Chapter 4. ON SPIRITUAL DRYNESS",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000260",
    "value": "Chapter 5. ABANDONMENT TO GOD—ITS FRUIT AND ITS IRREVOCABILITY—IN WHAT IT CONSISTS—GOD EXHORTS US TO IT",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000260",
    "value": "Chapter 6. OF SUFFERING WHICH MUST BE ACCEPTED AS FROM GOD—ITS FRUITS",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000260",
    "value": "Chapter 7. ON MYSTERIES—GOD GIVES THEM HERE IN REALITY",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000260",
    "value": "Chapter 8. ON VIRTUE—ALL VIRTUES GIVEN WITH GOD IN THIS DEGREE OF THE PRAYER OF THE HEART",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000260",
    "value": "Chapter 9",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000260",
    "value": "Chapter 10. HIGHER DEGREE OF PRAYER, WHICH IS THAT OF THE SIMPLE PRESENCE OF GOD, OR ACTIVE CONTEMPLATION",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000260",
    "value": "Chapter 11. OF REST IN THE PRESENCE OF GOD—ITS FRUITS—INWARD SILENCE—GOD COMMANDS IT—OUTWARD SILENCE",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000260",
    "value": "Chapter 12. SELF-EXAMINATION AND CONFESSION",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000260",
    "value": "Chapter 13. ON READING—VOCAL PRAYER—REQUESTS",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000260",
    "value": "Chapter 14. THE FAULTS COMMITTED IN THIS DEGREE—DISTRACTIONS, TEMPTATIONS—THE COURSE TO BE PURSUED RESPECTING THEM",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000260",
    "value": "Chapter 15",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000260",
    "value": "Chapter 16 (1)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000260",
    "value": "Chapter 16 (2)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000260",
    "value": "Chapter 17",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000260",
    "value": "Chapter 18",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000260",
    "value": "Chapter 19 (1)",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000260",
    "value": "Chapter 19 (2)",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 1. CONSIDER HIM",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 2. A HEART OF FAITH",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 3. TO PERFECTION (1)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 3. TO PERFECTION (2)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 4. OUR GREAT MELCHIZEDEK (1)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 4. OUR GREAT MELCHIZEDEK (2)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 4. OUR GREAT MELCHIZEDEK (3)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 5. THE BETTER COVENANT (1)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 5. THE BETTER COVENANT (2)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 6. SANCTUARY AND SACRIFICE (1)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 6. SANCTUARY AND SACRIFICE (2)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 6. SANCTUARY AND SACRIFICE (3)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 7. FULL, PERFECT, AND SUFFICIENT (1)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 7. FULL, PERFECT, AND SUFFICIENT (2)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 8. FAITH AND ITS POWER (1)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 8. FAITH AND ITS POWER (2)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 9. FAITH AND ITS ANNALS (1)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 9. FAITH AND ITS ANNALS (2)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 10. FOLLOWERS OF THEM (1)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 10. FOLLOWERS OF THEM (2)",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 11. SINAI AND SION (1)",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 11. SINAI AND SION (2)",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 11. SINAI AND SION (3)",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 12. APPEALS AND INSTRUCTIONS (1)",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 12. APPEALS AND INSTRUCTIONS (2)",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 13. LAST WORDS (1)",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 13. LAST WORDS (2)",
    "day_number": 27
  },
  {
    "id": "90000000-0000-0000-0000-000000000261",
    "value": "Chapter 13. LAST WORDS (3)",
    "day_number": 28
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 1. THE GENERAL CONDITIONS OF SUCCESS IN BRINGING MEN TO CHRIST",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 2. HOW TO BEGIN",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 3. DEALING WITH THE INDIFFERENT OR CARELESS (1)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 3. DEALING WITH THE INDIFFERENT OR CARELESS (2)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 4. DEALING WITH THOSE WHO ARE ANXIOUS TO BE SAVED BUT DO NOT KNOW HOW (1)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 4. DEALING WITH THOSE WHO ARE ANXIOUS TO BE SAVED BUT DO NOT KNOW HOW (2)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 5. DEALING WITH THOSE WHO ARE ANXIOUS TO BE SAVED AND KNOW HOW, BUT WHO HAVE DIFFICULTIES (1)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 5. DEALING WITH THOSE WHO ARE ANXIOUS TO BE SAVED AND KNOW HOW, BUT WHO HAVE DIFFICULTIES (2)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 5. DEALING WITH THOSE WHO ARE ANXIOUS TO BE SAVED AND KNOW HOW, BUT WHO HAVE DIFFICULTIES (3)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 6. DEALING WITH THOSE WHO ENTERTAIN FALSE HOPES (1)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 6. DEALING WITH THOSE WHO ENTERTAIN FALSE HOPES (2)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 7. Dealing with those who Lack Assurance and with Back–sliders (1)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 7. Dealing with those who Lack Assurance and with Back–sliders (2)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 8. DEALING WITH PROFESSED SKEPTICS AND INFIDELS (1)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 8. DEALING WITH PROFESSED SKEPTICS AND INFIDELS (2)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 8. DEALING WITH PROFESSED SKEPTICS AND INFIDELS (3)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 9. DEALING WITH THE COMPLAINING",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 10. DEALING WITH THOSE WHO WISH TO PUT OFF A DECISION UNTIL SOME OTHER TIME",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 11. DEALING WITH THE WILLFUL AND THE DELUDED",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 12. SOME HINTS AND SUGGESTIONS (1)",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 12. SOME HINTS AND SUGGESTIONS (2)",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 13. THE BAPTISM OF THE HOLY SPIRIT (1)",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 13. THE BAPTISM OF THE HOLY SPIRIT (2)",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 13. THE BAPTISM OF THE HOLY SPIRIT (3)",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 13. THE BAPTISM OF THE HOLY SPIRIT (4)",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000275",
    "value": "Chapter 13. THE BAPTISM OF THE HOLY SPIRIT (5)",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000289",
    "value": "Chapter 1. A WORD IN THE PRAYER (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000289",
    "value": "Chapter 1. A WORD IN THE PRAYER (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000289",
    "value": "Chapter 2. SOME ERRORS",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000289",
    "value": "Chapter 3. THOSE FOR WHOM CHRIST PRAYED—\"SANCTIFY THEM.\"",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000289",
    "value": "Chapter 4. CHRIST'S PRAYER ANSWERED",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000289",
    "value": "Chapter 5. CHRISTIAN UNITY",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000289",
    "value": "Chapter 6. FEARLESSNESS (1)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000289",
    "value": "Chapter 6. FEARLESSNESS (2)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000289",
    "value": "Chapter 7. RESPONSIVENESS TO CHRIST",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000289",
    "value": "Chapter 8. SOUL-REST",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000289",
    "value": "Chapter 9. PRAYERFULNESS",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000289",
    "value": "Chapter 10. SUCCESS",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000289",
    "value": "Chapter 11. VISITS OF ANGELS (1)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000289",
    "value": "Chapter 11. VISITS OF ANGELS (2)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000289",
    "value": "Chapter 12. GROWTH IN CHRISTLINESS OF LIFE (1)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000289",
    "value": "Chapter 12. GROWTH IN CHRISTLINESS OF LIFE (2)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000289",
    "value": "Chapter 12. GROWTH IN CHRISTLINESS OF LIFE (3)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000291",
    "value": "Chapter 1. OF THE HIGHEST PERFECTION WHICH MAN CAN ATTAIN TO IN THIS LIFE",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000291",
    "value": "Chapter 2. HOW A MAN MAY DESPISE ALL THINGS AND CLEAVE TO CHRIST ALONE",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000291",
    "value": "Chapter 3. THE LAW OF MAN'S PERFECTION IN THIS LIFE",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000291",
    "value": "Chapter 4. THAT OUR LABOUR MUST BE WITH THE UNDERSTANDING AND NOT WITH THE SENSES",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000291",
    "value": "Chapter 5. OF PURITY OF HEART, WHICH IS TO BE SOUGHT ABOVE ALL ELSE",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000291",
    "value": "Chapter 6. THAT A MAN TRULY DEVOUT MUST SEEK GOD IN PURITY OF MIND AND HEART",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000291",
    "value": "Chapter 7. ON THE PRACTICE OF INTERIOR RECOLLECTION",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000291",
    "value": "Chapter 8. THAT A TRULY DEVOUT MAN SHOULD COMMIT HIMSELF TO GOD IN ALL THAT BEFALLS HIM",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000291",
    "value": "Chapter 9. THE CONTEMPLATION OF GOD IS TO BE PREFERRED ABOVE ALL OTHER EXERCISES",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000291",
    "value": "Chapter 10",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000291",
    "value": "Chapter 11. IN WHAT MANNER WE SHOULD RESIST TEMPTATION AND ENDURE TRIALS",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000291",
    "value": "Chapter 12. THE POWER OF THE LOVE OF GOD",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000291",
    "value": "Chapter 13. OF THE NATURE AND ADVANTAGES OF PRAYER—OF INTERIOR RECOLLECTION",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000291",
    "value": "Chapter 14. THAT EVERYTHING SHOULD BE JUDGED ACCORDING TO THE TESTIMONY OF OUR CONSCIENCE",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000291",
    "value": "Chapter 15. ON THE CONTEMPT OF SELF: HOW IT IS ACQUIRED: ITS PROFIT TO THE SOUL",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000291",
    "value": "Chapter 16. OF THE PROVIDENCE OF GOD, WHICH WATCHES OVER ALL THINGS (1)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 1. THE FOUNTAIN OF GRACE (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 1. THE FOUNTAIN OF GRACE (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 2. SAVED BY GRACE ALONE (1)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 2. SAVED BY GRACE ALONE (2)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 2. SAVED BY GRACE ALONE (3)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 3. POSSESSING, AND “WORKING OUT.” (1)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 3. POSSESSING, AND “WORKING OUT.” (2)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 4. GRACE ABOUNDING TO THE CHIEF OF SINNERS (1)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 4. GRACE ABOUNDING TO THE CHIEF OF SINNERS (2)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 4. GRACE ABOUNDING TO THE CHIEF OF SINNERS (3)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 4. GRACE ABOUNDING TO THE CHIEF OF SINNERS (4)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 5. LAW AND GRACE (1)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 5. LAW AND GRACE (2)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 5. LAW AND GRACE (3)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 6. GRACE FOR LIVING (1)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 6. GRACE FOR LIVING (2)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 7. GRACE FOR SERVICE (1)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 7. GRACE FOR SERVICE (2)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 7. GRACE FOR SERVICE (3)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 8. A CHIME OF GOSPEL BELLS (1)",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 8. A CHIME OF GOSPEL BELLS (2)",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 8. A CHIME OF GOSPEL BELLS (3)",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 8. A CHIME OF GOSPEL BELLS (4)",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 8. A CHIME OF GOSPEL BELLS (5)",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 8. A CHIME OF GOSPEL BELLS (6)",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 8. A CHIME OF GOSPEL BELLS (7)",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 8. A CHIME OF GOSPEL BELLS (8)",
    "day_number": 27
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 8. A CHIME OF GOSPEL BELLS (9)",
    "day_number": 28
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 8. A CHIME OF GOSPEL BELLS (10)",
    "day_number": 29
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 8. A CHIME OF GOSPEL BELLS (11)",
    "day_number": 30
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 8. A CHIME OF GOSPEL BELLS (12)",
    "day_number": 31
  },
  {
    "id": "90000000-0000-0000-0000-000000000295",
    "value": "Chapter 8. A CHIME OF GOSPEL BELLS (13)",
    "day_number": 32
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Chapter 1. JOSEPH CAST INTO THE PIT",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Chapter 2. JOSEPH SOLD TO THE ISHMAELITES",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Chapter 3. JOSEPH IN PRISON",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Chapter 4. JOSEPH INTERPRETING PHARAOH’s DREAMS",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Chapter 5. JOSEPH’S ADVANCEMENT",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Chapter 6. “YOU ARE SPIES.”",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Chapter 7. THE CUP IN BENJAMIN’S SACK",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Chapter 8. THE MEETING OF JOSEPH AND BENJAMIN",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Chapter 9. THE MEETING OF JACOB AND JOSEPH",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Chapter 10. JACOB IN THE PRESENCE OF PHARAOH",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Chapter 11. THE DEATH OF JACOB",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000306",
    "value": "Part 1. GRACE AND HOLINESS (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000306",
    "value": "Part 1. GRACE AND HOLINESS (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000306",
    "value": "Part 2. CONSECRATION AND PRESERVATION (1)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000306",
    "value": "Part 2. CONSECRATION AND PRESERVATION (2)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000306",
    "value": "Part 3. APPROBATION AND BLESSING (1)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000306",
    "value": "Part 3. APPROBATION AND BLESSING (2)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000306",
    "value": "Part 4. LOVE AND PEACE (1)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000306",
    "value": "Part 4. LOVE AND PEACE (2)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000306",
    "value": "Part 4. LOVE AND PEACE (3)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000306",
    "value": "Part 5. KNOWLEDGE AND OBEDIENCE (1)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000306",
    "value": "Part 5. KNOWLEDGE AND OBEDIENCE (2)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000306",
    "value": "Part 5. KNOWLEDGE AND OBEDIENCE (3)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000306",
    "value": "Part 6. CONFLICT AND COMFORT (1)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000306",
    "value": "Part 6. CONFLICT AND COMFORT (2)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000306",
    "value": "Part 6. CONFLICT AND COMFORT (3)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000306",
    "value": "Part 7. WISDOM AND REVELATION (1)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000306",
    "value": "Part 7. WISDOM AND REVELATION (2)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000306",
    "value": "Part 7. WISDOM AND REVELATION (3)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000306",
    "value": "Part 8. STRENGTH AND INDWELLING (1)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000306",
    "value": "Part 8. STRENGTH AND INDWELLING (2)",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000306",
    "value": "Part 9. LOVE AND DISCERNMENT (1)",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000306",
    "value": "Part 9. LOVE AND DISCERNMENT (2)",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "value": "A Coal From The Altar, To Kindle The Holy Fire of Zeal (Part 1) (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "value": "A Coal From The Altar, To Kindle The Holy Fire of Zeal (Part 1) (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "value": "A Coal From The Altar, To Kindle The Holy Fire of Zeal (Part 2) (1)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "value": "A Coal From The Altar, To Kindle The Holy Fire of Zeal (Part 2) (2)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "value": "A Coal From The Altar, To Kindle The Holy Fire of Zeal (Part 3) (1)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "value": "A Coal From The Altar, To Kindle The Holy Fire of Zeal (Part 3) (2)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "value": "A Coal From The Altar, To Kindle The Holy Fire of Zeal (Part 4) (1)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "value": "A Coal From The Altar, To Kindle The Holy Fire of Zeal (Part 4) (2)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "value": "A Coal From The Altar, To Kindle The Holy Fire of Zeal (Part 5) (1)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "value": "A Coal From The Altar, To Kindle The Holy Fire of Zeal (Part 5) (2)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "value": "A Coal From The Altar, To Kindle The Holy Fire of Zeal (Part 6) (1)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "value": "A Coal From The Altar, To Kindle The Holy Fire of Zeal (Part 6) (2)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "value": "A Coal From The Altar, To Kindle The Holy Fire of Zeal (Part 7)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "value": "A Coal From The Altar, To Kindle The Holy Fire of Zeal (Part 8) (1)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000311",
    "value": "A Coal From The Altar, To Kindle The Holy Fire of Zeal (Part 8) (2)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000320",
    "value": "Part 1. By the Right Rev. W. BOYD CARPENTER, D.D. Lord Bishop of Ripon",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000320",
    "value": "Part 2. By the Rev. THEODORE L. CUYLER, D.D. of New York",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000320",
    "value": "Part 3. By the Rev. JOHN WATSON, M.A., D.D. (\" Ian Maclaren \") (1)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000320",
    "value": "Part 3. By the Rev. JOHN WATSON, M.A., D.D. (\" Ian Maclaren \") (2)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000320",
    "value": "Part 4. By the Rev. W. KNOX LITTLE, M. A. Canon of Worcester (1)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000320",
    "value": "Part 4. By the Rev. W. KNOX LITTLE, M. A. Canon of Worcester (2)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000320",
    "value": "Part 5. By Mr. WILLIAM QUARRIER of Glasgow (1)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000320",
    "value": "Part 5. By Mr. WILLIAM QUARRIER of Glasgow (2)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000320",
    "value": "Part 5. By Mr. WILLIAM QUARRIER of Glasgow (3)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000320",
    "value": "Part 6. By Mr. LEONARD K. SHAW of Manchester",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000320",
    "value": "Part 7. By the Rev. R. F. HORTON, M.A., D.D (1)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000320",
    "value": "Part 7. By the Rev. R. F. HORTON, M.A., D.D (2)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000320",
    "value": "Part 7. By the Rev. R. F. HORTON, M.A., D.D (3)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000320",
    "value": "Part 8. By the Rev. HUGH PRICE HUGHES, M.A (1)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000320",
    "value": "Part 8. By the Rev. HUGH PRICE HUGHES, M.A (2)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000320",
    "value": "Part 9. By the Rev. J. CLIFFORD, M.A., D.D (1)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000320",
    "value": "Part 9. By the Rev. J. CLIFFORD, M.A., D.D (2)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000320",
    "value": "Part 9. By the Rev. J. CLIFFORD, M.A., D.D (3)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000320",
    "value": "Part 10. By the Very Rev. G. D. BOYLE, M.A. Dean of Salisbury",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 1",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 2",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 3",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 4",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 5 (1)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 5 (2)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 5 (3)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 6",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 7",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 8",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 9",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 10",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 11",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 12",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 13",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 14",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 15",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 16 (1)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 16 (2)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 17. At Christmas time Bessie received the following letter from one of her friends:",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 18",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 19",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 20",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 21",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 22",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 23 (1)",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 23 (2)",
    "day_number": 27
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 24",
    "day_number": 28
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 25",
    "day_number": 29
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 26 (1)",
    "day_number": 30
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 26 (2)",
    "day_number": 31
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 27 (1)",
    "day_number": 32
  },
  {
    "id": "90000000-0000-0000-0000-000000000322",
    "value": "Chapter 27 (2)",
    "day_number": 33
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 1. BOYHOOD DAYS (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 1. BOYHOOD DAYS (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 1. BOYHOOD DAYS (3)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 2. FIRST STEPS IN CRIME (1)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 2. FIRST STEPS IN CRIME (2)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 2. FIRST STEPS IN CRIME (3)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 2. FIRST STEPS IN CRIME (4)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 3. INTO THE DEPTHS (1)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 3. INTO THE DEPTHS (2)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 4. \"SAVED BY GRACE\" (1)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 4. \"SAVED BY GRACE\" (2)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 4. \"SAVED BY GRACE\" (3)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 5. ON THE UP GRADE (1)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 5. ON THE UP GRADE (2)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 5. ON THE UP GRADE (3)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 6. PROMOTED (1)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 6. PROMOTED (2)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 6. PROMOTED (3)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 6. PROMOTED (4)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 7. THE MISSION IN CHINATOWN (1)",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 7. THE MISSION IN CHINATOWN (2)",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 7. THE MISSION IN CHINATOWN (3)",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 7. THE MISSION IN CHINATOWN (4)",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 8. BOWERY WORK (1)",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 8. BOWERY WORK (2)",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 8. BOWERY WORK (3)",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 8. BOWERY WORK (4)",
    "day_number": 27
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 8. BOWERY WORK (5)",
    "day_number": 28
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 9. PRODIGAL SONS (1)",
    "day_number": 29
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 9. PRODIGAL SONS (2)",
    "day_number": 30
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 9. PRODIGAL SONS (3)",
    "day_number": 31
  },
  {
    "id": "90000000-0000-0000-0000-000000000328",
    "value": "Chapter 9. PRODIGAL SONS (4)",
    "day_number": 32
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 1. Childhood (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 1. Childhood (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 2. Conversion and Soul Struggles (1)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 2. Conversion and Soul Struggles (2)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 3. A Three-Years Engagement (1)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 3. A Three-Years Engagement (2)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 3. A Three-Years Engagement (3)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 4. A Life of Sacrifice (1)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 4. A Life of Sacrifice (2)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 4. A Life of Sacrifice (3)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 5. The Speaker (1)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 5. The Speaker (2)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 5. The Speaker (3)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 6. The Mother (1)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 6. The Mother (2)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 6. The Mother (3)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 6. The Mother (4)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 7. The Worker",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 8. Goodness (1)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 8. Goodness (2)",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 9. Love (1)",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 9. Love (2)",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 10. The Warrior (1)",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 10. The Warrior (2)",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 11. Last Days (1)",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 11. Last Days (2)",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000329",
    "value": "Part 11. Last Days (3)",
    "day_number": 27
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Part 1. The Little Pavior (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Part 1. The Little Pavior (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Part 1. The Little Pavior (3)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Part 2. The Silver Knife (1)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Part 2. The Silver Knife (2)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Part 3. The Modern Dorcas (1)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Part 3. The Modern Dorcas (2)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Part 3. The Modern Dorcas (3)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Part 3. The Modern Dorcas (4)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Part 4. The Tract found by the Way-Side (1)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Part 4. The Tract found by the Way-Side (2)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Part 4. The Tract found by the Way-Side (3)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000331",
    "value": "Part 4. The Tract found by the Way-Side (4)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 1. The Universal Art (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 1. The Universal Art (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 2. Friendship with God—Looking (1)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 2. Friendship with God—Looking (2)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 2. Friendship with God—Looking (3)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 3. Friendship with God—Speaking (1)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 3. Friendship with God—Speaking (2)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 4. Friendship with God—The Response (1)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 4. Friendship with God—The Response (2)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 4. Friendship with God—The Response (3)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 5. The Testing of Friendship (1)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 5. The Testing of Friendship (2)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 5. The Testing of Friendship (3)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 6. Knitting Broken Friendship (1)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 6. Knitting Broken Friendship (2)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 7. Friendship in God (1)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 7. Friendship in God (2)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 8. Friendship in God (continued) (1)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 8. Friendship in God (continued) (2)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 8. Friendship in God (continued) (3)",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 9. The Church in Prayer (1)",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 9. The Church in Prayer (2)",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 9. The Church in Prayer (3)",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 10. The Great Act of Worship (1)",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 10. The Great Act of Worship (2)",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 10. The Great Act of Worship (3)",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 10. The Great Act of Worship (4)",
    "day_number": 27
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 11. Witnesses to the Uttermost Part of the Earth (1)",
    "day_number": 28
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 11. Witnesses to the Uttermost Part of the Earth (2)",
    "day_number": 29
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 11. Witnesses to the Uttermost Part of the Earth (3)",
    "day_number": 30
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 12. The Inspiration of Responsibility (1)",
    "day_number": 31
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 12. The Inspiration of Responsibility (2)",
    "day_number": 32
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 12. The Inspiration of Responsibility (3)",
    "day_number": 33
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 12. The Inspiration of Responsibility (4)",
    "day_number": 34
  },
  {
    "id": "90000000-0000-0000-0000-000000000332",
    "value": "Chapter 12. The Inspiration of Responsibility (5)",
    "day_number": 35
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 1. WHY THE BELLS SANG (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 1. WHY THE BELLS SANG (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 2. A WALK IN THE WOOD (1)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 2. A WALK IN THE WOOD (2)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 3. A RAINBOW IN THE NURSERY (1)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 3. A RAINBOW IN THE NURSERY (2)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 4. FATHER CHRISTMAS (1)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 4. FATHER CHRISTMAS (2)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 5. THE GARDENER'S LESSON (1)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 5. THE GARDENER'S LESSON (2)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 6. A TEMPTING BAIT (1)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 6. A TEMPTING BAIT (2)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 6. A TEMPTING BAIT (3)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 7. THE BROKEN VASE (1)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 7. THE BROKEN VASE (2)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 7. THE BROKEN VASE (3)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 8. THE BIRTHDAY QUEEN (1)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 8. THE BIRTHDAY QUEEN (2)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 8. THE BIRTHDAY QUEEN (3)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 9. CAUGHT! (1)",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 9. CAUGHT! (2)",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 10. SET FREE! (1)",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 10. SET FREE! (2)",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 11. FOREST LODGE (1)",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 11. FOREST LODGE (2)",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 12. CONCLUSION (1)",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000342",
    "value": "Chapter 12. CONCLUSION (2)",
    "day_number": 27
  },
  {
    "id": "90000000-0000-0000-0000-000000000343",
    "value": "Sermon 1. DAVID’S WEAKNESS (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000343",
    "value": "Sermon 1. DAVID’S WEAKNESS (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000343",
    "value": "Sermon 1. DAVID’S WEAKNESS (3)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000343",
    "value": "Sermon 2. DAVID’S STRENGTH (1)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000343",
    "value": "Sermon 2. DAVID’S STRENGTH (2)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000343",
    "value": "Sermon 2. DAVID’S STRENGTH (3)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000343",
    "value": "Sermon 3. DAVID’S ANGER (1)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000343",
    "value": "Sermon 3. DAVID’S ANGER (2)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000343",
    "value": "Sermon 3. DAVID’S ANGER (3)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000343",
    "value": "Sermon 4. DAVID’S DESERTS (1)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000343",
    "value": "Sermon 4. DAVID’S DESERTS (2)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000343",
    "value": "Sermon 4. DAVID’S DESERTS (3)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000343",
    "value": "Sermon 5. FRIENDSHIP; OR, DAVID AND JONATHAN (1)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000343",
    "value": "Sermon 5. FRIENDSHIP; OR, DAVID AND JONATHAN (2)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000343",
    "value": "Sermon 5. FRIENDSHIP; OR, DAVID AND JONATHAN (3)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000101",
    "value": "WHY CAN I NOT FOLLOW YOU NOW?",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000101",
    "value": "DO YOU NOW BELIEVE?",
    "day_number": 59
  },
  {
    "id": "90000000-0000-0000-0000-000000000101",
    "value": "IF YOU HAD KNOWN!",
    "day_number": 94
  },
  {
    "id": "90000000-0000-0000-0000-000000000101",
    "value": "HOW WILL I KNOW?",
    "day_number": 284
  },
  {
    "id": "90000000-0000-0000-0000-000000000101",
    "value": "YOU ARE NOT YOUR OWN",
    "day_number": 306
  },
  {
    "id": "90000000-0000-0000-0000-000000000101",
    "value": "WHAT IS THAT TO YOU?",
    "day_number": 320
  },
  {
    "id": "90000000-0000-0000-0000-000000000101",
    "value": "APPROVED TO GOD",
    "day_number": 350
  },
  {
    "id": "90000000-0000-0000-0000-000000000103",
    "value": "Your Rod and Your Staff",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000103",
    "value": "By Your Spirit",
    "day_number": 111
  },
  {
    "id": "90000000-0000-0000-0000-000000000103",
    "value": "You Will Revive Me",
    "day_number": 114
  },
  {
    "id": "90000000-0000-0000-0000-000000000103",
    "value": "Can Your Heart Endure",
    "day_number": 134
  },
  {
    "id": "90000000-0000-0000-0000-000000000103",
    "value": "He Works",
    "day_number": 143
  },
  {
    "id": "90000000-0000-0000-0000-000000000103",
    "value": "Why Do You Worry Yourself?",
    "day_number": 153
  },
  {
    "id": "90000000-0000-0000-0000-000000000103",
    "value": "God Meant It To Good",
    "day_number": 162
  },
  {
    "id": "90000000-0000-0000-0000-000000000103",
    "value": "Watch Your Faith Carefully",
    "day_number": 166
  },
  {
    "id": "90000000-0000-0000-0000-000000000103",
    "value": "Challenge Your Mountain in the Lord",
    "day_number": 176
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 1",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 2",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 3",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 4",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 5",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 6",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 7",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 8 (1)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 8 (2)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 9",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 10",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 11 (1)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 11 (2)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 11 (3)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 11 (4)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 12 (1)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 12 (2)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 13 (1)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 13 (2)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 14 (1)",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 14 (2)",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 15 (1)",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 15 (2)",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 16",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 17",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000201",
    "value": "CHAPTER 18",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000204",
    "value": "Part 1 (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000204",
    "value": "Part 1 (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000204",
    "value": "Part 1 (3)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000204",
    "value": "Part 2 (1)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000204",
    "value": "Part 2 (2)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000204",
    "value": "Part 2 (3)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000205",
    "value": "PRAY TO YOUR FATHER WHO IS IN SECRET ALONE WITH GOD (1)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000205",
    "value": "PRAY TO YOUR FATHER WHO IS IN SECRET ALONE WITH GOD (2)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 1 (1)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 1 (2)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 2 (1)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 2 (2)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 3 (1)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 3 (2)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 4 (1)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 4 (2)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 5 (1)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 5 (2)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 6 (1)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 6 (2)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 7 (1)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 7 (2)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 8 (1)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 8 (2)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 9 (1)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 9 (2)",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 10 (1)",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 10 (2)",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 11 (1)",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 11 (2)",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 12 (1)",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 12 (2)",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 13 (1)",
    "day_number": 27
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 13 (2)",
    "day_number": 28
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 14 (1)",
    "day_number": 29
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 14 (2)",
    "day_number": 30
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 15 (1)",
    "day_number": 31
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 15 (2)",
    "day_number": 32
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 15 (3)",
    "day_number": 33
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 15 (4)",
    "day_number": 34
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 15 (5)",
    "day_number": 35
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 15 (6)",
    "day_number": 36
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 15 (7)",
    "day_number": 37
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 15 (8)",
    "day_number": 38
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 15 (9)",
    "day_number": 39
  },
  {
    "id": "90000000-0000-0000-0000-000000000207",
    "value": "CHAPTER 15 (10)",
    "day_number": 40
  },
  {
    "id": "90000000-0000-0000-0000-000000000208",
    "value": "2 THE HOLY SPIRIT AND MONEY (1)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000208",
    "value": "2 THE HOLY SPIRIT AND MONEY (2)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000208",
    "value": "3 THE GRACE OF GOD AND MONEY (1)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000208",
    "value": "3 THE GRACE OF GOD AND MONEY (2)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000208",
    "value": "4 THE POVERTY OF CHRIST. (1)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000208",
    "value": "4 THE POVERTY OF CHRIST. (2)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000208",
    "value": "4 THE POVERTY OF CHRIST. (3)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000208",
    "value": "4 THE POVERTY OF CHRIST. (4)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "value": "Chapter 1 (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "value": "Chapter 1 (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "value": "Chapter 2",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "value": "Chapter 3",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "value": "Chapter 4",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "value": "Chapter 5",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "value": "Chapter 6",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "value": "Chapter 7",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "value": "Chapter 8",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "value": "Chapter 9",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "value": "Chapter 10",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "value": "Chapter 11",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "value": "Chapter 12",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "value": "Chapter 13",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "value": "Chapter 14",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "value": "Chapter 15",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "value": "Chapter 16",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "value": "Chapter 17",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "value": "Chapter 18",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "value": "Chapter 19",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000210",
    "value": "Chapter 20",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 1 (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 1 (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 2 (1)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 2 (2)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 2 (3)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 3 (1)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 3 (2)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 3 (3)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 4 (1)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 4 (2)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 4 (3)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 5 (1)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 5 (2)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 5 (3)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 6 (1)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 6 (2)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 7 (1)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 7 (2)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 8 (1)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 8 (2)",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 9 (1)",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 9 (2)",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 9 (3)",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 10 (1)",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 10 (2)",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 11 (1)",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 11 (2)",
    "day_number": 27
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 12 (1)",
    "day_number": 28
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 12 (2)",
    "day_number": 29
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 12 (3)",
    "day_number": 30
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 13 (1)",
    "day_number": 31
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 13 (2)",
    "day_number": 32
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 14 (1)",
    "day_number": 33
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 14 (2)",
    "day_number": 34
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 15 (1)",
    "day_number": 35
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 15 (2)",
    "day_number": 36
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 15 (3)",
    "day_number": 37
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 16 (1)",
    "day_number": 38
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 16 (2)",
    "day_number": 39
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 17 (1)",
    "day_number": 40
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 17 (2)",
    "day_number": 41
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 17 (3)",
    "day_number": 42
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 18 (1)",
    "day_number": 43
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 18 (2)",
    "day_number": 44
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 19 (1)",
    "day_number": 45
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 19 (2)",
    "day_number": 46
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 20 (1)",
    "day_number": 47
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 20 (2)",
    "day_number": 48
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 20 (3)",
    "day_number": 49
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 21 (1)",
    "day_number": 50
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 21 (2)",
    "day_number": 51
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 21 (3)",
    "day_number": 52
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 22 (1)",
    "day_number": 53
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 22 (2)",
    "day_number": 54
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 22 (3)",
    "day_number": 55
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 23 (1)",
    "day_number": 56
  },
  {
    "id": "90000000-0000-0000-0000-000000000212",
    "value": "CHAPTER 23 (2)",
    "day_number": 57
  },
  {
    "id": "90000000-0000-0000-0000-000000000216",
    "value": "31. Thirty-first Day. I will love You",
    "day_number": 31
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 1 THE PRAYERS OF THE BIBLE. (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 1 THE PRAYERS OF THE BIBLE. (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 2 ADORATION.",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 3 CONFESSION. (1)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 3 CONFESSION. (2)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 3 CONFESSION. (3)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 4 RESTITUTION. (1)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 4 RESTITUTION. (2)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 5 THANKSGIVING. (1)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 5 THANKSGIVING. (2)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 6 FORGIVENESS. (1)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 6 FORGIVENESS. (2)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 7 UNITY. (1)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 7 UNITY. (2)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 8 FAITH. (1)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 8 FAITH. (2)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 9 PETITION. (1)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 9 PETITION. (2)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 9 PETITION. (3)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 10 SUBMISSION. (1)",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 10 SUBMISSION. (2)",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 11 ANSWERED PRAYERS. (1)",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 11 ANSWERED PRAYERS. (2)",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000217",
    "value": "CHAPTER 11 ANSWERED PRAYERS. (3)",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 1. GOD THE GOD OF THE LIVING (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 1. GOD THE GOD OF THE LIVING (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 2. BELIEVING AND BECOMING (1)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 2. BELIEVING AND BECOMING (2)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 3. GLEAMING AS CRYSTAL (1)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 3. GLEAMING AS CRYSTAL (2)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 4. HEART ENLARGEMENT (1)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 4. HEART ENLARGEMENT (2)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 4. HEART ENLARGEMENT (3)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 5. HE RESTORES MY SOUL (1)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 5. HE RESTORES MY SOUL (2)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 6. ADDITION AND MULTIPLICATION (1)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 6. ADDITION AND MULTIPLICATION (2)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 7. A CONFERENCE ON DEATH (1)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 7. A CONFERENCE ON DEATH (2)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 8. CHRIST WILL TAKE ALL (1)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 8. CHRIST WILL TAKE ALL (2)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 9. STRONG CRYING (1)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 9. STRONG CRYING (2)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 10. THE SENTINEL OF THE HEART (1)",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 10. THE SENTINEL OF THE HEART (2)",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 11. YOUR FATHER IN SECRET (1)",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 11. YOUR FATHER IN SECRET (2)",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 12. TESTS OF FAITH, LOVE, AND RIGHTNESS (1)",
    "day_number": 24
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 12. TESTS OF FAITH, LOVE, AND RIGHTNESS (2)",
    "day_number": 25
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 13. THE ETERNAL IDEA (1)",
    "day_number": 26
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 13. THE ETERNAL IDEA (2)",
    "day_number": 27
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 13. THE ETERNAL IDEA (3)",
    "day_number": 28
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 14. MORE LIGHT (1)",
    "day_number": 29
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 14. MORE LIGHT (2)",
    "day_number": 30
  },
  {
    "id": "90000000-0000-0000-0000-000000000351",
    "value": "Part 15. OVER-OVERCOMING",
    "day_number": 31
  },
  {
    "id": "90000000-0000-0000-0000-000000000352",
    "value": "Part 1. The Discipline of the Will ASH WEDNESDAY (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000352",
    "value": "Part 1. The Discipline of the Will ASH WEDNESDAY (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000352",
    "value": "Part 2. The Discipline of the Body FIRST SUNDAY IN LENT (1)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000352",
    "value": "Part 2. The Discipline of the Body FIRST SUNDAY IN LENT (2)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000352",
    "value": "Part 3. The Discipline of the Soul SECOND SUNDAY IN LENT (1)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000352",
    "value": "Part 3. The Discipline of the Soul SECOND SUNDAY IN LENT (2)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000352",
    "value": "Part 4. The Discipline of the Spirit THIRD SUNDAY IN LENT (1)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000352",
    "value": "Part 4. The Discipline of the Spirit THIRD SUNDAY IN LENT (2)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000352",
    "value": "Part 5. Discipline through Obedience FOURTH SUNDAY IN LENT (1)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000352",
    "value": "Part 5. Discipline through Obedience FOURTH SUNDAY IN LENT (2)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000352",
    "value": "Part 6. The Discipline of Sorrow FIFTH SUNDAY IN LENT (1)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000352",
    "value": "Part 6. The Discipline of Sorrow FIFTH SUNDAY IN LENT (2)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000352",
    "value": "Part 7. Discipline through Bereavement SIXTH SUNDAY IN LENT (1)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000352",
    "value": "Part 7. Discipline through Bereavement SIXTH SUNDAY IN LENT (2)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000352",
    "value": "Part 7. Discipline through Bereavement SIXTH SUNDAY IN LENT (3)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000352",
    "value": "Part 8. Discipline through Self-sacrifice GOOD FRIDAY (1)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000352",
    "value": "Part 8. Discipline through Self-sacrifice GOOD FRIDAY (2)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000352",
    "value": "Part 9. Discipline through Victory EASTER DAY (1)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000352",
    "value": "Part 9. Discipline through Victory EASTER DAY (2)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 1. REUBEN WINS RENOWN (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 1. REUBEN WINS RENOWN (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 2. PARTINGS (1)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 2. PARTINGS (2)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 3. THE WAYS OF TOWN (1)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 3. THE WAYS OF TOWN (2)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 4. AN ENEMY (1)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 4. AN ENEMY (2)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 5. REUBEN SEES MORE OF OWEN GRANT (1)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 5. REUBEN SEES MORE OF OWEN GRANT (2)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 6. REUBEN HAS THRILLING EXPERIENCES (1)",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 6. REUBEN HAS THRILLING EXPERIENCES (2)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 7. REUBEN'S STORY IS DISCREDITED (1)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 7. REUBEN'S STORY IS DISCREDITED (2)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 8. A TIME OF TRIAL (1)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 8. A TIME OF TRIAL (2)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 9. THE CLOUD IS LIFTED (1)",
    "day_number": 17
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 9. THE CLOUD IS LIFTED (2)",
    "day_number": 18
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 10. A SON THAT CAUSETH SHAME (1)",
    "day_number": 19
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 10. A SON THAT CAUSETH SHAME (2)",
    "day_number": 20
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 11. A CHANGE FOR KATE",
    "day_number": 21
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 12. A RETURN (1)",
    "day_number": 22
  },
  {
    "id": "90000000-0000-0000-0000-000000000358",
    "value": "Chapter 12. A RETURN (2)",
    "day_number": 23
  },
  {
    "id": "90000000-0000-0000-0000-000000000382",
    "value": "The Scriptures able to make us wise for salvation : or the Bible a sufficient creed (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000382",
    "value": "The Scriptures able to make us wise for salvation : or the Bible a sufficient creed (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000382",
    "value": "The Scriptures able to make us wise for salvation : or the Bible a sufficient creed (3)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000382",
    "value": "The Scriptures able to make us wise for salvation : or the Bible a sufficient creed (4)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000382",
    "value": "The Scriptures able to make us wise for salvation : or the Bible a sufficient creed (5)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000382",
    "value": "The Scriptures able to make us wise for salvation : or the Bible a sufficient creed (6)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000382",
    "value": "The Scriptures able to make us wise for salvation : or the Bible a sufficient creed (7)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000386",
    "value": "Part 1. The Lord shall keep your going out and your coming in, from now on and forever (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000386",
    "value": "Part 1. The Lord shall keep your going out and your coming in, from now on and forever (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000386",
    "value": "Part 2. Trust in Him at all times, all you people. Pour out your heart before Him. God is a refuge for us (1)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000386",
    "value": "Part 2. Trust in Him at all times, all you people. Pour out your heart before Him. God is a refuge for us (2)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000386",
    "value": "Part 2. Trust in Him at all times, all you people. Pour out your heart before Him. God is a refuge for us (3)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000386",
    "value": "Part 4. My eyes are always toward the Lord, for He will free my feet from the net",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000386",
    "value": "Part 5. The Lord shall keep you from all evil; He shall keep your soul (1)",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000386",
    "value": "Part 5. The Lord shall keep you from all evil; He shall keep your soul (2)",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000386",
    "value": "Part 5. The Lord shall keep you from all evil; He shall keep your soul (3)",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000386",
    "value": "Part 5. The Lord shall keep you from all evil; He shall keep your soul (4)",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000386",
    "value": "Part 8. Answer me quickly, O Lord…. Let me hear … For I lift up my soul to You",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000386",
    "value": "Part 9. Why should I fear in troubled days, when evil closes in around me? (1)",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000386",
    "value": "Part 9. Why should I fear in troubled days, when evil closes in around me? (2)",
    "day_number": 13
  },
  {
    "id": "90000000-0000-0000-0000-000000000386",
    "value": "Part 9. Why should I fear in troubled days, when evil closes in around me? (3)",
    "day_number": 14
  },
  {
    "id": "90000000-0000-0000-0000-000000000386",
    "value": "Part 11. Sing a new song to the Lord (1)",
    "day_number": 15
  },
  {
    "id": "90000000-0000-0000-0000-000000000386",
    "value": "Part 11. Sing a new song to the Lord (2)",
    "day_number": 16
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "value": "A sermon preached before the Right Honourable the Lord-Mayor : the aldermen and citizens of London (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "value": "A sermon preached before the Right Honourable the Lord-Mayor : the aldermen and citizens of London (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "value": "A sermon preached before the Right Honourable the Lord-Mayor : the aldermen and citizens of London (3)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "value": "A sermon preached before the Right Honourable the Lord-Mayor : the aldermen and citizens of London (4)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "value": "A sermon preached before the Right Honourable the Lord-Mayor : the aldermen and citizens of London (5)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000390",
    "value": "A sermon preached before the Right Honourable the Lord-Mayor : the aldermen and citizens of London (6)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "A Funeral Sermon Preached on the Decease of the Right Honourable the Lady Elizabeth Cutts (1)",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "A Funeral Sermon Preached on the Decease of the Right Honourable the Lady Elizabeth Cutts (2)",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "A Funeral Sermon Preached on the Decease of the Right Honourable the Lady Elizabeth Cutts (3)",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "A Funeral Sermon Preached on the Decease of the Right Honourable the Lady Elizabeth Cutts (4)",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "A Funeral Sermon Preached on the Decease of the Right Honourable the Lady Elizabeth Cutts (5)",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "A Funeral Sermon Preached on the Decease of the Right Honourable the Lady Elizabeth Cutts (6)",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000395",
    "value": "A Funeral Sermon Preached on the Decease of the Right Honourable the Lady Elizabeth Cutts (7)",
    "day_number": 7
  }
]
$language_edits$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;
