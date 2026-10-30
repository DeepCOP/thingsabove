-- One 1872 retelling of Joseph reconstructed as eleven Scripture-led devotions.
-- Trafficking, coercion, power, suffering, repentance, and reconciliation receive
-- explicit context; guaranteed prosperity and forced reconciliation are rejected.
-- Existing day IDs and day numbers are preserved.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-25 17:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Providence, Repentance, and Reconciliation: Eleven Readings on Joseph"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-25 17:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Eleven Scripture-led readings adapted from W. K. Tweedie's 1872 retelling of Joseph's story in Genesis. The sequence addresses envy, trafficking, coercion, unjust imprisonment, wisdom, stewardship, power, repentance, reconciliation, reunion, leadership, grief, and providence while avoiding guaranteed-prosperity claims, simplistic explanations of suffering, forced reconciliation, and the use of morally complex narrative actions as universal commands."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-25 17:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Interrupt the Cycle of Envy",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Do Not Profit from Another's Harm",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Faithfulness When Justice Fails",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Receive Wisdom as a Gift",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Prepare in Seasons of Plenty",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Power Can Serve Truth and Mercy",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Repentance Bears Costly Fruit",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Reconciliation Makes Room for Tears",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Receive the Gift of Reunion",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Bless Across Lines of Status",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "Trust Providence Without Calling Evil Good",
    "day_number": 11
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-25 17:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "<p><strong>Read:</strong> Genesis 37:3-11; James 3:14-18.</p><p><strong>Source and biblical context:</strong> W. K. Tweedie's 1872 retelling begins with Jacob's favoritism, Joseph's dreams, and his brothers' growing hatred. Genesis shows a family system in which partiality, pride, and envy feed one another.</p><p><strong>Devotional focus:</strong> Envy distorts another person's good into a threat and can turn hurt into cruelty. God's wisdom leads toward honesty, peace, mercy, and responsibility instead of rivalry.</p><p><strong>Reflect:</strong> What comparison is feeding resentment in you? Name the deeper hurt or desire, refuse contempt, and choose one action shaped by peace rather than competition.</p><p><strong>Prayer:</strong> God of wisdom, expose envy and pride in me. Heal what fuels rivalry and teach me to seek peace, truth, and another person's good. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "<p><strong>Read:</strong> Genesis 37:18-28; Proverbs 31:8-9.</p><p><strong>Source and biblical context:</strong> Joseph's brothers throw him into a pit and sell him to traders. Tweedie rightly names their cruelty, while contemporary readers should also name the event as trafficking and the use of profit to disguise violence.</p><p><strong>Devotional focus:</strong> Changing the form of harm does not make it righteous. Love speaks for people in danger, refuses profit built on exploitation, and interrupts group decisions that sacrifice a vulnerable person.</p><p><strong>Reflect:</strong> Where might convenience, silence, or financial benefit connect you to another person's exploitation? Learn the facts and take one responsible step toward protection or fair treatment.</p><p><strong>Prayer:</strong> God of justice, make me courageous when others are endangered. Keep me from benefiting through silence and teach me to defend human dignity. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "<p><strong>Read:</strong> Genesis 39:7-23; Psalm 10:14.</p><p><strong>Source and biblical context:</strong> Joseph resists sexual coercion, is falsely accused, and is imprisoned. The historical commentary emphasizes his later advancement; this reading first acknowledges the injustice and the reality that faithful people are not always vindicated quickly.</p><p><strong>Devotional focus:</strong> God sees people harmed by coercion, lies, and unjust systems. Faithfulness may include resisting wrongdoing, seeking safety, telling the truth, supporting survivors, and enduring without pretending that injustice is good.</p><p><strong>Reflect:</strong> How can you make a relationship, church, or workplace safer for someone reporting coercion or false accusation? Listen carefully and connect the person with appropriate support.</p><p><strong>Prayer:</strong> God who sees the afflicted, protect people facing coercion and injustice. Give us courage to believe truth, pursue safety, and remain faithful. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "<p><strong>Read:</strong> Genesis 41:14-16; James 1:5.</p><p><strong>Source and biblical context:</strong> When Pharaoh asks Joseph to interpret troubling dreams, Joseph says that the answer does not originate in himself. He then combines discernment with practical counsel for the coming famine.</p><p><strong>Devotional focus:</strong> Wisdom is received with humility and used for service. We acknowledge God, examine reality carefully, and translate insight into plans that protect people rather than build our reputation.</p><p><strong>Reflect:</strong> Where are people looking to you for an answer? Admit what you do not know, ask God for wisdom, consult others, and turn sound insight into a practical next step.</p><p><strong>Prayer:</strong> Wise God, give generously as I seek understanding. Keep me humble, attentive, and ready to use insight for the good of others. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "<p><strong>Read:</strong> Genesis 41:33-40; Proverbs 21:5.</p><p><strong>Source and biblical context:</strong> Joseph is entrusted with preparing Egypt for famine. Tweedie presents advancement as providential reward, but Scripture does not promise that diligence always brings position or prosperity.</p><p><strong>Devotional focus:</strong> Responsible leadership plans ahead, stewards abundance, and protects people against foreseeable hardship. Faithfulness is measured by love and integrity, whether or not it receives promotion.</p><p><strong>Reflect:</strong> What future need can you prepare for while resources are available? Make a plan that includes people who are most exposed when scarcity comes.</p><p><strong>Prayer:</strong> Provider God, teach me wise stewardship in times of abundance. Make my planning just, generous, and attentive to vulnerable neighbors. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "<p><strong>Read:</strong> Genesis 42:6-17; Micah 6:8.</p><p><strong>Source and biblical context:</strong> Joseph's brothers arrive seeking food, and he accuses them of spying while concealing his identity. The narrative begins a process that exposes their past, but Joseph's use of power is complex and should not become a simple model for testing people.</p><p><strong>Devotional focus:</strong> Authority must serve justice, mercy, and truth without manipulation or revenge. People with power should use clear processes, proportionate boundaries, and accountable decisions.</p><p><strong>Reflect:</strong> Where do you hold information or authority another person lacks? Choose transparency and accountability, and avoid creating fear merely to test loyalty or control the outcome.</p><p><strong>Prayer:</strong> Just and merciful God, purify my use of power. Lead me in transparent, accountable decisions that protect truth and human dignity. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "<p><strong>Read:</strong> Genesis 44:18-34; 2 Corinthians 7:10-11.</p><p><strong>Source and biblical context:</strong> After a cup is hidden in Benjamin's sack, Judah offers himself in Benjamin's place rather than return home without him. Joseph's test remains ethically difficult, yet Judah's response reveals a striking change from the brother who once helped sell Joseph.</p><p><strong>Devotional focus:</strong> Repentance becomes visible when a person accepts cost to protect someone previously endangered by the same pattern. Changed words matter, and changed action confirms them.</p><p><strong>Reflect:</strong> What present choice would demonstrate change from a past pattern? Consider the cost of protecting another person, keeping your promise, or accepting responsibility yourself.</p><p><strong>Prayer:</strong> Merciful God, produce earnest repentance in me. Give me courage to protect others, accept responsibility, and live differently from my former ways. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "<p><strong>Read:</strong> Genesis 45:1-15; Romans 12:18.</p><p><strong>Source and biblical context:</strong> Joseph reveals his identity, weeps, and embraces Benjamin and his other brothers. His words about God's providence do not call their betrayal good or remove their responsibility.</p><p><strong>Devotional focus:</strong> Reconciliation can hold grief, truth, mercy, and hope together. It should not be forced, and restored relationship may require confession, safety, time, and trustworthy change.</p><p><strong>Reflect:</strong> Are you rushing reconciliation or avoiding a truthful step toward peace? Identify what belongs to you—lament, confession, a boundary, restitution, or a patient invitation.</p><p><strong>Prayer:</strong> God of reconciliation, receive our tears and lead us in truth. Give us mercy without denial, peace without coercion, and wisdom about trust. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "<p><strong>Read:</strong> Genesis 46:28-30; Psalm 126:1-3.</p><p><strong>Source and biblical context:</strong> Jacob travels to Egypt and is reunited with the son he had believed dead. The meeting does not erase the lost years, but it brings an unexpected joy after prolonged grief.</p><p><strong>Devotional focus:</strong> Restoration is a gift, not a repayment that makes every loss disappear. We can receive joy fully while honoring the grief and complexity that came before it.</p><p><strong>Reflect:</strong> What restored relationship, opportunity, or hope can you receive with gratitude? Celebrate it without demanding that anyone deny the pain of the past.</p><p><strong>Prayer:</strong> God who restores, thank you for joys we did not expect. Help us celebrate your gifts while treating old grief with tenderness and truth. Amen.</p>",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "<p><strong>Read:</strong> Genesis 47:7-12; 1 Timothy 2:1-2.</p><p><strong>Source and biblical context:</strong> Joseph presents Jacob to Pharaoh, and the aging migrant blesses the ruler. The scene crosses differences of age, nationality, wealth, and political power without making spiritual dignity depend on rank.</p><p><strong>Devotional focus:</strong> God's people can seek the good of rulers and strangers while remaining truthful about power. Blessing is neither flattery nor domination; it asks for life, justice, and peace under God's authority.</p><p><strong>Reflect:</strong> How can you pray and act for the good of people across a line of status or culture? Refuse both contempt and uncritical praise, and seek a just peace.</p><p><strong>Prayer:</strong> Sovereign God, guide leaders and protect those affected by their decisions. Make me truthful, hospitable, and committed to justice and peace. Amen.</p>",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "value": "<p><strong>Read:</strong> Genesis 50:15-21; Romans 8:28.</p><p><strong>Source and biblical context:</strong> After Jacob's death, Joseph grieves and again assures his brothers that God brought life out of what they intended for evil. Tweedie's conclusion strongly emphasizes providence; this reading preserves the distinction Joseph makes between human evil and God's redeeming purpose.</p><p><strong>Devotional focus:</strong> God can bring saving good from actions he does not approve. Providence does not excuse abuse, silence lament, or remove accountability; it gives hope that evil will not have the final word.</p><p><strong>Reflect:</strong> Where do you need hope without a false explanation for suffering? Name the evil honestly, pursue what is just, and entrust the unfinished story to God's redeeming care.</p><p><strong>Prayer:</strong> Redeeming God, do not let evil have the final word. Hold us in grief, lead us in justice, and bring life through your faithful purposes. Amen.</p>",
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
    "id": "90000000-0000-0000-0000-000000000302",
    "day_number": 1,
    "references": [
      "Genesis 37:3-11",
      "James 3:14-18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "day_number": 2,
    "references": [
      "Genesis 37:18-28",
      "Proverbs 31:8-9"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "day_number": 3,
    "references": [
      "Genesis 39:7-23",
      "Psalm 10:14"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "day_number": 4,
    "references": [
      "Genesis 41:14-16",
      "James 1:5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "day_number": 5,
    "references": [
      "Genesis 41:33-40",
      "Proverbs 21:5"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "day_number": 6,
    "references": [
      "Genesis 42:6-17",
      "Micah 6:8"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "day_number": 7,
    "references": [
      "Genesis 44:18-34",
      "2 Corinthians 7:10-11"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "day_number": 8,
    "references": [
      "Genesis 45:1-15",
      "Romans 12:18"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "day_number": 9,
    "references": [
      "Genesis 46:28-30",
      "Psalm 126:1-3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "day_number": 10,
    "references": [
      "Genesis 47:7-12",
      "1 Timothy 2:1-2"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000302",
    "day_number": 11,
    "references": [
      "Genesis 50:15-21",
      "Romans 8:28"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-25 17:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-25 17:00:00+00', timestamptz '2026-10-25 17:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish the contextualized Joseph-story adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-25 17:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000302'::uuid
);
