-- Synchronize catalog cover_image URLs with devotional-plan-catalog-updated-image-links.csv.
-- Updates only the 140 changed URLs among the 144 included repository plans.
-- The expected old URL is checked so this fails safely if the catalog has drifted.
BEGIN;

DO $cover_image_sync$
DECLARE
  v_payload constant jsonb := $cover_image_payload$[
  {
    "title": "\"He was buried.\" A Sermon for Easter Even",
    "expected_cover_image": "https://images.unsplash.com/photo-1433086966358-54859d0ed716?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1706003259572-5c2473a5642a?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "\"Jesus Says So\"",
    "expected_cover_image": "https://images.unsplash.com/photo-1507842217343-583bb7270b66?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1745162829464-c3487261f90d?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "'Jesus Himself'",
    "expected_cover_image": "https://images.unsplash.com/photo-1531988042231-d39a9cc12a9a?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1470686164816-830d3688f62c?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "A Life of Wisdom and Kindness: 20 Readings Inspired by Helen Ekin Starrett",
    "expected_cover_image": "https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1645927011343-65b4d884fb86?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "A Prayer Book for Soldiers and Sailors",
    "expected_cover_image": "https://images.unsplash.com/photo-1518837695005-2083093ee35b?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1681174025588-a2e090c771c1?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "A Short Method of Prayer",
    "expected_cover_image": "https://images.unsplash.com/photo-1455390582262-044cdead277a?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1437603568260-1950d3ca6eab?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Addresses by Henry Drummond",
    "expected_cover_image": "https://images.unsplash.com/photo-1521587760476-6c12a4b040da?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1645927011343-65b4d884fb86?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "An Earnest Exhortation to a Frequent Reception of the Holy Sacrament of the Lord's Supper",
    "expected_cover_image": "https://images.unsplash.com/photo-1507692049790-de58290a4334?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1531627467965-e9c3dd19209c?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "An Exhortation to Peace and Unity",
    "expected_cover_image": "https://images.unsplash.com/photo-1577222512383-ed8bb23c0f2d?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1710168410077-b0343f8f34fc?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Around the Wicket Gate",
    "expected_cover_image": "https://images.unsplash.com/photo-1418065460487-3e41a6c84dc5?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1720534256762-59e251d1ec1b?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Beside the Still Waters",
    "expected_cover_image": "https://images.unsplash.com/photo-1433086966358-54859d0ed716?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Christian Devotedness",
    "expected_cover_image": "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1650979465192-13c3faf42e57?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Christian Freedom and Neighborly Love: Eighteen Readings from Martin Luther",
    "expected_cover_image": "https://images.unsplash.com/photo-1495446815901-a7297e633e8d?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Coming to the King",
    "expected_cover_image": "https://images.unsplash.com/photo-1505506874110-6a7a69069a08?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1706003259572-5c2473a5642a?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Compassion, Repair, and Hope: Eight Readings from The One Moss-Rose",
    "expected_cover_image": "https://images.unsplash.com/photo-1508610048659-a06b669e3321?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1663162550932-f67b561e656f?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Conscience, Justice, and Peace: Six Readings from a 1710 Civic Sermon",
    "expected_cover_image": "https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1650979465192-13c3faf42e57?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Conscience, Justice, and the Common Good: Nine Readings from an 1839 Election Sermon",
    "expected_cover_image": "https://images.unsplash.com/photo-1749487699158-8a5332fc09a2?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1663162550932-f67b561e656f?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Consolation in Life and Death, Derived from the Life of Christ",
    "expected_cover_image": "https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1681174025588-a2e090c771c1?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Corrie: Twenty-Seven Readings on Compassion, Courage, and Grace",
    "expected_cover_image": "https://images.unsplash.com/photo-1543342384-1f1350e27861?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1663162550932-f67b561e656f?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Courage, Compassion, and Calling: 27 Readings from Catherine Booth’s Life",
    "expected_cover_image": "https://images.unsplash.com/photo-1520854221256-17451cc331bf?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1650979465192-13c3faf42e57?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Daily Wisdom of the Saints: Eleven Scripture-Led Reflections",
    "expected_cover_image": "https://images.unsplash.com/photo-1506784983877-45594efa4cbe?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1641491664780-cd5b022c2f3a?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "David: Five Sermons",
    "expected_cover_image": "https://images.unsplash.com/photo-1472396961693-142e6e269027?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1720534256762-59e251d1ec1b?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Essentials of prayer",
    "expected_cover_image": "https://images.unsplash.com/photo-1507692049790-de58290a4334?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1437603568260-1950d3ca6eab?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Eternal Life",
    "expected_cover_image": "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1681174025588-a2e090c771c1?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Everyday Objects, Living Faith: 24 Scripture-Led Readings for Families",
    "expected_cover_image": "https://images.unsplash.com/photo-1473773508845-188df298d2d1?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1745162829464-c3487261f90d?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Faith Beyond the Census: Four Readings on Christian Witness",
    "expected_cover_image": "https://images.unsplash.com/photo-1521587760476-6c12a4b040da?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Faith in Action: Thirteen Readings from Four Christian Tales",
    "expected_cover_image": "https://images.unsplash.com/photo-1468327768560-75b778cbb551?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1663162550932-f67b561e656f?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Faith, Grace, and Courage: 32 Readings from the Reformation Pulpit",
    "expected_cover_image": "https://images.unsplash.com/photo-1532012197267-da84d127e765?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1673322882205-add3ff85764b?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Faith, Love, and Christian Witness: Eight Readings from the Nonington Sermons",
    "expected_cover_image": "https://images.unsplash.com/photo-1448375240586-882707db888b?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1681174025588-a2e090c771c1?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Faithful Discernment: 25 Readings on Scripture, Humility, and Christian Love",
    "expected_cover_image": "https://images.unsplash.com/photo-1483728642387-6c3bdd6c93e5?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1673322882205-add3ff85764b?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Faithful Service and Hope in Christ: Eleven Readings from the Francis Storr Memorials",
    "expected_cover_image": "https://images.unsplash.com/photo-1495446815901-a7297e633e8d?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1531627467965-e9c3dd19209c?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Five Sermons",
    "expected_cover_image": "https://images.unsplash.com/photo-1529070538774-1843cb3265df?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1645927011343-65b4d884fb86?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Following Christ: Five Readings from William Penn",
    "expected_cover_image": "https://images.unsplash.com/photo-1739486899893-bc07aca7b5df?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1710168410077-b0343f8f34fc?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Food for the Lambs; or, Helps for Young Christians",
    "expected_cover_image": "https://images.unsplash.com/photo-1472214103451-9374bd1c798e?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1745162829464-c3487261f90d?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "From the Bowery to a Life of Service: 32 Readings from Dave Ranney",
    "expected_cover_image": "https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1663162550932-f67b561e656f?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "General Catholic Devotions",
    "expected_cover_image": "https://images.unsplash.com/photo-1513001900722-370f803f498d?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1437603568260-1950d3ca6eab?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Gleanings among the Sheaves",
    "expected_cover_image": "https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1416879595882-3373a0480b5b?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Gratitude and the Common Good: Six Readings from an 1855 Sermon",
    "expected_cover_image": "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://commons.wikimedia.org/wiki/Special:FilePath/Bible_study_at_a_table.jpg?width=1200"
  },
  {
    "title": "Holding Truth with Love: Eleven Readings on Christian Confession",
    "expected_cover_image": "https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1470686164816-830d3688f62c?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Holy in Christ",
    "expected_cover_image": "https://images.unsplash.com/photo-1516410529446-2c777cb7366d?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1706003259572-5c2473a5642a?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Home, Belonging, and Hope: 29 Readings from Christie’s Old Organ",
    "expected_cover_image": "https://images.unsplash.com/photo-1739486899893-bc07aca7b5df?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1745162829464-c3487261f90d?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "How I Know God Answers Prayer: The Personal Testimony of One Life-Time",
    "expected_cover_image": "https://images.unsplash.com/photo-1516979187457-637abb4f9353?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1437603568260-1950d3ca6eab?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "How to bring men to Christ",
    "expected_cover_image": "https://images.unsplash.com/photo-1518495973542-4542c06a5843?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1710168410077-b0343f8f34fc?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "How to Succeed in the Christian Life",
    "expected_cover_image": "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1645927011343-65b4d884fb86?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Humility: The Beauty of Holiness",
    "expected_cover_image": "https://images.unsplash.com/photo-1465146344425-f00d5f5c8f07?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1641491664780-cd5b022c2f3a?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "I'm Greatly Concerned About Your Soul.",
    "expected_cover_image": "https://images.unsplash.com/photo-1518495973542-4542c06a5843?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1607098263775-e2cc11657839?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "In Answer to Prayer",
    "expected_cover_image": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1607098263775-e2cc11657839?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Jesus Fulfils the Law: 14 Readings on Grace, Scripture, and Neighborly Love",
    "expected_cover_image": "https://images.unsplash.com/photo-1507692049790-de58290a4334?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1720534256762-59e251d1ec1b?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "John the Baptist",
    "expected_cover_image": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Kept for the Master's Use",
    "expected_cover_image": "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1681174025588-a2e090c771c1?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Let Every Breath Praise: Three Readings from Psalm 150",
    "expected_cover_image": "https://images.unsplash.com/photo-1506784983877-45594efa4cbe?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://commons.wikimedia.org/wiki/Special:FilePath/Bible_study_at_a_table.jpg?width=1200"
  },
  {
    "title": "Life, Death, and Resurrection Hope: Seven Readings from a 1697 Funeral Sermon",
    "expected_cover_image": "https://images.unsplash.com/photo-1520854221256-17451cc331bf?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1681174025588-a2e090c771c1?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Light On the Child's Path",
    "expected_cover_image": "https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1745162829464-c3487261f90d?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Light, Truth, and the Holy Spirit: Five Readings from a Chapel Guide",
    "expected_cover_image": "https://images.unsplash.com/photo-1513001900722-370f803f498d?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1673322882205-add3ff85764b?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Little Folded Hands",
    "expected_cover_image": "https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1745162829464-c3487261f90d?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Living and Dying to the Lord: Four Readings from an 1838 Sermon",
    "expected_cover_image": "https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1706003259572-5c2473a5642a?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Living with Mercy and Truth: 17 Readings from Edith and Her Ayah",
    "expected_cover_image": "https://images.unsplash.com/photo-1523413651479-597eb2da0ad6?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1663162550932-f67b561e656f?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Lord, Teach Us To Pray",
    "expected_cover_image": "https://images.unsplash.com/photo-1503437313881-503a91226402?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1437603568260-1950d3ca6eab?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Love to the Uttermost",
    "expected_cover_image": "https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1706003259572-5c2473a5642a?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Mary, the Help of Christians",
    "expected_cover_image": "https://images.unsplash.com/photo-1719433031030-08e252ebd7fb?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1437603568260-1950d3ca6eab?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Matelda and the cloister of Hellfde : extracts from the Book of Matilda of Magdeburg",
    "expected_cover_image": "https://images.unsplash.com/photo-1712237791790-c99e52100e11?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1641491664780-cd5b022c2f3a?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Memoranda Sacra",
    "expected_cover_image": "https://images.unsplash.com/photo-1455390582262-044cdead277a?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1470686164816-830d3688f62c?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Messages from the Epistle to the Hebrews",
    "expected_cover_image": "https://images.unsplash.com/photo-1593485552030-019bfbf6ee1d?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1470686164816-830d3688f62c?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Miscellaneous Pieces",
    "expected_cover_image": "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1645927011343-65b4d884fb86?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Money: Thoughts for God's Stewards",
    "expected_cover_image": "https://images.unsplash.com/photo-1497215728101-856f4ea42174?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1663162550932-f67b561e656f?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Morning and Evening Prayers for All Days of the Week",
    "expected_cover_image": "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1607098263775-e2cc11657839?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Morning and Evening: 366 Scripture-Guided Devotions",
    "expected_cover_image": "https://images.unsplash.com/photo-1499346030926-9a72daac6c63?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1645927011343-65b4d884fb86?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Morning Bells; Or, Waking Thoughts for Little Ones",
    "expected_cover_image": "https://images.unsplash.com/photo-1487700160041-babef9c3cb55?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1745162829464-c3487261f90d?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "My Utmost for His Highest",
    "expected_cover_image": "https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1706003259572-5c2473a5642a?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "On Union with God",
    "expected_cover_image": "https://images.unsplash.com/photo-1470770841072-f978cf4d019e?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1437603568260-1950d3ca6eab?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "One Lord, One Faith, One Baptism: Seven Readings",
    "expected_cover_image": "https://images.unsplash.com/photo-1439066615861-d1af74d74000?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Pax Vobiscum",
    "expected_cover_image": "https://images.unsplash.com/photo-1577222512383-ed8bb23c0f2d?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1641491664780-cd5b022c2f3a?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Power Through Prayer",
    "expected_cover_image": "https://images.unsplash.com/photo-1519682577862-22b62b24e493?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1607098263775-e2cc11657839?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Prayer and Shared Scripture: Two Readings from an 1814 Pastoral Tract",
    "expected_cover_image": "https://images.unsplash.com/photo-1495446815901-a7297e633e8d?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1663162550932-f67b561e656f?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Prayer, Humility, and Wise Living: 12 Readings from Jonathan Swift",
    "expected_cover_image": "https://images.unsplash.com/photo-1708870665587-833fcffe20d2?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1645927011343-65b4d884fb86?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Praying for Freedom: Nine Readings from an Antislavery Tract",
    "expected_cover_image": "https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1650979465192-13c3faf42e57?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Praying with the Early Church: Sixteen Scripture-Led Readings",
    "expected_cover_image": "https://images.unsplash.com/photo-1712237791790-c99e52100e11?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1710168410077-b0343f8f34fc?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Prevailing Prayer: What Hinders It?",
    "expected_cover_image": "https://images.unsplash.com/photo-1511632765486-a01980e01a18?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1729714625765-6ad07c70038e?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Providence, Repentance, and Reconciliation: Eleven Readings on Joseph",
    "expected_cover_image": "https://images.unsplash.com/photo-1482192505345-5655af888cc4?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1663162550932-f67b561e656f?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Remembering Christ in Grief: Seven Readings from an 1832 Sermon",
    "expected_cover_image": "https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1437603568260-1950d3ca6eab?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Resurrection and Reason: 29 Readings on Testimony, Faith, and Hope",
    "expected_cover_image": "https://images.unsplash.com/photo-1500534623283-312aade485b7?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1681174025588-a2e090c771c1?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Reuben Roy's temptations",
    "expected_cover_image": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1745162829464-c3487261f90d?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Reverence, Grace, and Faithful Living: Fifteen Readings from a 1626 Funeral Sermon",
    "expected_cover_image": "https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1470686164816-830d3688f62c?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Secret Power; or, The Secret of Success in Christian Life and Work",
    "expected_cover_image": "https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1437603568260-1950d3ca6eab?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Seeing Faith Through Art: Eleven Scripture-Led Readings for Families",
    "expected_cover_image": "https://images.unsplash.com/photo-1513364776144-60967b0f800f?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1470686164816-830d3688f62c?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Seeking Another's Good: Thirteen Readings from a 1621 Plymouth Sermon",
    "expected_cover_image": "https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1650979465192-13c3faf42e57?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Separation and Service; or, Thoughts on Numbers 6, 7.",
    "expected_cover_image": "https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1673322882205-add3ff85764b?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Sermons for the Day",
    "expected_cover_image": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1645927011343-65b4d884fb86?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Sharing Scripture with Love: Five Readings from an 1815 Sermon",
    "expected_cover_image": "https://images.unsplash.com/photo-1504052434569-70ad5836ab65?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1710168410077-b0343f8f34fc?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Signs of Life: 22 Readings on Grace, Growth, and Spiritual Care",
    "expected_cover_image": "https://images.unsplash.com/photo-1493246507139-91e8fad9978e?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1416879595882-3373a0480b5b?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Small Acts, Great Love: 27 Readings Inspired by Small Means and Great Ends",
    "expected_cover_image": "https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1650979465192-13c3faf42e57?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Sovereign Grace: Its Source, Its Nature and Its Effects",
    "expected_cover_image": "https://images.unsplash.com/photo-1516542076529-1ea3854896f2?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1706003259572-5c2473a5642a?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Sowing and Reaping",
    "expected_cover_image": "https://images.unsplash.com/photo-1487700160041-babef9c3cb55?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1416879595882-3373a0480b5b?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Spiritual Torrents",
    "expected_cover_image": "https://images.unsplash.com/photo-1433086966358-54859d0ed716?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Spiritual Victories Through the Light of Salvation",
    "expected_cover_image": "https://images.unsplash.com/photo-1483728642387-6c3bdd6c93e5?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1706003259572-5c2473a5642a?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Streams in the Desert",
    "expected_cover_image": "https://images.unsplash.com/photo-1509316785289-025f5b846b35?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Abiding Presence of the Holy Ghost in the Soul",
    "expected_cover_image": "https://images.unsplash.com/photo-1577222512383-ed8bb23c0f2d?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1437603568260-1950d3ca6eab?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Atonement, as taught by the Church of England: A Sermon",
    "expected_cover_image": "https://images.unsplash.com/photo-1505506874110-6a7a69069a08?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1531627467965-e9c3dd19209c?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Believer Not Ashamed of the Gospel",
    "expected_cover_image": "https://images.unsplash.com/photo-1507842217343-583bb7270b66?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1645927011343-65b4d884fb86?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Believer's Confidence in a Faithful God",
    "expected_cover_image": "https://images.unsplash.com/photo-1470770841072-f978cf4d019e?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Breadth, Freeness, and Yet Exclusiveness of the Gospel",
    "expected_cover_image": "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1706003259572-5c2473a5642a?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Character and Happiness of Them That Die in the Lord",
    "expected_cover_image": "https://images.unsplash.com/photo-1523712999610-f77fbcfc3843?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1437603568260-1950d3ca6eab?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Children's Six Minutes",
    "expected_cover_image": "https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1745162829464-c3487261f90d?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Christian Serving His Own Generation",
    "expected_cover_image": "https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1650979465192-13c3faf42e57?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Cities of Refuge: or, The Name of Jesus",
    "expected_cover_image": "https://images.unsplash.com/photo-1521587760476-6c12a4b040da?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1706003259572-5c2473a5642a?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Cross: A Tract for the Times",
    "expected_cover_image": "https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1681174025588-a2e090c771c1?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Descent of the Branch into the Waters of Sorrow, to Bring up the Election of Grace",
    "expected_cover_image": "https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1681174025588-a2e090c771c1?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Discipline of War",
    "expected_cover_image": "https://images.unsplash.com/photo-1706003259572-5c2473a5642a?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1681174025588-a2e090c771c1?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Faithful Promiser",
    "expected_cover_image": "https://images.unsplash.com/photo-1516979187457-637abb4f9353?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1681174025588-a2e090c771c1?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Glorious Law-Giver, and the Obedient Subject",
    "expected_cover_image": "https://images.unsplash.com/photo-1593485552030-019bfbf6ee1d?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1673322882205-add3ff85764b?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Glory of the Cross: 30 Readings on Love, Repentance, and Hope",
    "expected_cover_image": "https://images.unsplash.com/photo-1472396961693-142e6e269027?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1681174025588-a2e090c771c1?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Greatest Thing In the World and Other Addresses",
    "expected_cover_image": "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1650979465192-13c3faf42e57?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Heart-Cry of Jesus",
    "expected_cover_image": "https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1681174025588-a2e090c771c1?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Living Letter, Written with the Pen of Truth",
    "expected_cover_image": "https://images.unsplash.com/photo-1455390582262-044cdead277a?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1720534256762-59e251d1ec1b?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Master's Indwelling",
    "expected_cover_image": "https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1706003259572-5c2473a5642a?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Mind of Jesus",
    "expected_cover_image": "https://images.unsplash.com/photo-1504052434569-70ad5836ab65?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1720534256762-59e251d1ec1b?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Ministry of Intercession",
    "expected_cover_image": "https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1437603568260-1950d3ca6eab?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Overcoming Life, and Other Sermons",
    "expected_cover_image": "https://images.unsplash.com/photo-1482192505345-5655af888cc4?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1650979465192-13c3faf42e57?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Peep of Day",
    "expected_cover_image": "https://images.unsplash.com/photo-1494548162494-384bba4ab999?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1745162829464-c3487261f90d?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Practice of the Presence of God",
    "expected_cover_image": "https://images.unsplash.com/photo-1483794344563-d27a8d18014e?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1729714625765-6ad07c70038e?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Prayers of St. Paul",
    "expected_cover_image": "https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1729714625765-6ad07c70038e?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Sabbath: A Sermon",
    "expected_cover_image": "https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1673322882205-add3ff85764b?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Shepherd Psalm: A Meditation",
    "expected_cover_image": "https://images.unsplash.com/photo-1500534623283-312aade485b7?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Speedy Appearance of Christ Desired by the Church",
    "expected_cover_image": "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1706003259572-5c2473a5642a?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Spirit-Filled Life",
    "expected_cover_image": "https://images.unsplash.com/photo-1523712999610-f77fbcfc3843?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1641491664780-cd5b022c2f3a?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Threshold Grace: Meditations in the Psalms",
    "expected_cover_image": "https://images.unsplash.com/photo-1516979187457-637abb4f9353?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1437603568260-1950d3ca6eab?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Trial and Death of Jesus Christ",
    "expected_cover_image": "https://images.unsplash.com/photo-1534447677768-be436bb09401?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1706003259572-5c2473a5642a?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The True Ministers of Christ Accredited by the Holy Spirit: A Sermon",
    "expected_cover_image": "https://images.unsplash.com/photo-1719433031030-08e252ebd7fb?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1720534256762-59e251d1ec1b?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The value of a praying mother",
    "expected_cover_image": "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1729714625765-6ad07c70038e?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Way to God and How to Find It",
    "expected_cover_image": "https://images.unsplash.com/photo-1488190211105-8b0e65b80b4e?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1706003259572-5c2473a5642a?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Words of Jesus",
    "expected_cover_image": "https://images.unsplash.com/photo-1749487699158-8a5332fc09a2?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1470686164816-830d3688f62c?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "The Worth of the Soul",
    "expected_cover_image": "https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1673322882205-add3ff85764b?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Thoughts for the Quiet Hour",
    "expected_cover_image": "https://images.unsplash.com/photo-1500534623283-312aade485b7?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1607098263775-e2cc11657839?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "To The Work! To The Work! Exhortations to Christians",
    "expected_cover_image": "https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1650979465192-13c3faf42e57?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Weighed and Wanting: Addresses on the Ten Commandments",
    "expected_cover_image": "https://images.unsplash.com/photo-1593485552030-019bfbf6ee1d?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1645927011343-65b4d884fb86?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "With God in the World: A Series of Papers",
    "expected_cover_image": "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1710168410077-b0343f8f34fc?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Witnesses to Christ: Three Readings from an 1877 Sermon",
    "expected_cover_image": "https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1706003259572-5c2473a5642a?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Worship with Understanding: 27 Readings Inspired by Ritual Conformity",
    "expected_cover_image": "https://images.unsplash.com/photo-1708870665587-833fcffe20d2?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1531627467965-e9c3dd19209c?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Worship, Conscience, and Christian Unity: 19 Readings from a Victorian Debate",
    "expected_cover_image": "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1720534256762-59e251d1ec1b?auto=format&fit=crop&w=1200&q=80"
  },
  {
    "title": "Zeal Tempered by Love: Fifteen Readings from Samuel Ward",
    "expected_cover_image": "https://images.unsplash.com/photo-1505506874110-6a7a69069a08?auto=format&fit=crop&w=1200&q=80",
    "new_cover_image": "https://images.unsplash.com/photo-1650979465192-13c3faf42e57?auto=format&fit=crop&w=1200&q=80"
  }
]$cover_image_payload$::jsonb;
  v_payload_count integer;
  v_matched_count integer;
  v_updated_count integer;
  v_unresolved_count integer;
BEGIN
  v_payload_count := jsonb_array_length(v_payload);
  IF v_payload_count <> 140 THEN
    RAISE EXCEPTION 'Cover image payload count mismatch: expected 140, found %', v_payload_count;
  END IF;

  IF EXISTS (
    SELECT 1
    FROM jsonb_to_recordset(v_payload) AS item(title text, expected_cover_image text, new_cover_image text)
    GROUP BY item.title
    HAVING count(*) <> 1
  ) THEN
    RAISE EXCEPTION 'Cover image payload contains duplicate plan titles';
  END IF;

  IF EXISTS (
    SELECT plan.title
    FROM public.devotional_plans AS plan
    JOIN jsonb_to_recordset(v_payload) AS item(title text, expected_cover_image text, new_cover_image text)
      ON item.title = plan.title
    WHERE plan.id::text LIKE '90000000-0000-0000-0000-%'
    GROUP BY plan.title
    HAVING count(*) <> 1
  ) THEN
    RAISE EXCEPTION 'A catalog plan title matches more than one seeded plan';
  END IF;

  SELECT count(*) INTO v_matched_count
  FROM jsonb_to_recordset(v_payload) AS item(title text, expected_cover_image text, new_cover_image text)
  JOIN public.devotional_plans AS plan
    ON plan.title = item.title
   AND plan.cover_image IS NOT DISTINCT FROM item.expected_cover_image
   AND plan.id::text LIKE '90000000-0000-0000-0000-%';

  IF v_matched_count <> v_payload_count THEN
    RAISE EXCEPTION 'Cover image preflight failed: expected % exact title/current-URL matches, found %',
      v_payload_count, v_matched_count;
  END IF;

  UPDATE public.devotional_plans AS plan
  SET cover_image = item.new_cover_image,
      updated_at = now()
  FROM jsonb_to_recordset(v_payload) AS item(title text, expected_cover_image text, new_cover_image text)
  WHERE plan.id::text LIKE '90000000-0000-0000-0000-%'
    AND plan.title = item.title
    AND plan.cover_image IS NOT DISTINCT FROM item.expected_cover_image
    AND plan.cover_image IS DISTINCT FROM item.new_cover_image;

  GET DIAGNOSTICS v_updated_count = ROW_COUNT;
  IF v_updated_count <> 140 THEN
    RAISE EXCEPTION 'Cover image update count mismatch: expected 140, updated %', v_updated_count;
  END IF;

  SELECT count(*) INTO v_unresolved_count
  FROM jsonb_to_recordset(v_payload) AS item(title text, expected_cover_image text, new_cover_image text)
  WHERE NOT EXISTS (
    SELECT 1 FROM public.devotional_plans AS plan
    WHERE plan.id::text LIKE '90000000-0000-0000-0000-%'
      AND plan.title = item.title
      AND plan.cover_image IS NOT DISTINCT FROM item.new_cover_image
  );

  IF v_unresolved_count <> 0 THEN
    RAISE EXCEPTION 'Cover image postflight failed for % plans', v_unresolved_count;
  END IF;
END
$cover_image_sync$;

COMMIT;
