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
