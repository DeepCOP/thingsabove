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
