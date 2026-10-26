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
