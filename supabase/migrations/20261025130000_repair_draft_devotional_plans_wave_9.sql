-- One 1621 Plymouth sermon reconstructed as thirteen Scripture-led daily devotions.
-- The colonial setting remains explicit; degrading descriptions, severe judgments, and
-- context-bound social prescriptions are omitted, rejected, or reframed.
-- Existing day IDs and day numbers are preserved.

update public.devotional_plans as target
set title = edit.value, updated_at = timestamptz '2026-10-25 13:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Seeking Another's Good: Thirteen Readings from a 1621 Plymouth Sermon"
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_plans as target
set description = edit.value, updated_at = timestamptz '2026-10-25 13:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Thirteen Scripture-led readings adapted from Robert Cushman's 1621 Plymouth sermon on 1 Corinthians 10:24. The sequence retains its call to examine self-interest, share resources, carry burdens, and follow Christ's self-giving love while identifying the colonial setting and rejecting demeaning labels, degrading descriptions of Indigenous people, severe judgments, and social prescriptions that should not govern a general devotional."
  }
]
$adapt_text$::jsonb) as edit(id uuid, value text)
where target.id = edit.id;

update public.devotional_days as target
set title = edit.value, updated_at = timestamptz '2026-10-25 13:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Seek Another's Good",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Invite God to Search the Heart",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Hold Wealth for God's Purposes",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Use Strength to Serve",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Work Without Chasing Applause",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Follow the Self-Giving Christ",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Care for Every Member",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Practice Fair and Generous Sharing",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Love Beyond Reciprocity",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Carry Burdens Together",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Respond to Weakness with Patience",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Let Peace Become a Public Witness",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "Put Love into Practice",
    "day_number": 13
  }
]
$adapt_text$::jsonb) as edit(id uuid, day_number integer, value text)
where target.plan_id = edit.id and target.day_number = edit.day_number;

update public.devotional_days as target
set content = edit.value, updated_at = timestamptz '2026-10-25 13:00:00+00'
from jsonb_to_recordset($adapt_text$
[
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> 1 Corinthians 10:23-24; Philippians 2:3-4.</p><p><strong>Historical context:</strong> Robert Cushman preached this sermon at Plymouth in 1621 to a small colonial community facing scarcity and conflict. His central text calls believers to seek another person's good rather than make private advantage their ruling concern.</p><p><strong>Source theme, in contemporary language:</strong> Christian freedom is guided by love. A choice may be permitted yet still be unhelpful when it wounds a neighbor, weakens the community, or places personal preference above another person's well-being.</p><p><strong>Reflect:</strong> Think about one choice that affects other people. Beyond asking whether you may do it, ask whether it builds them up and reflects the love of Christ.</p><p><strong>Prayer:</strong> Lord Jesus, free me from making myself the center. Teach me to use my freedom for my neighbor's good and your glory. Amen.</p>",
    "day_number": 1
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> Psalm 139:23-24; Romans 12:3.</p><p><strong>Historical context:</strong> Cushman treats self-love as a hidden spiritual illness and urges hearers to examine their motives. His medical imagery is forceful, but its useful question is whether self-interest has distorted our judgment.</p><p><strong>Source theme, in contemporary language:</strong> Self-examination begins with humility before God. We need the Spirit to uncover pride, defensiveness, and the quiet bargains by which service to others becomes a way to secure praise or advantage.</p><p><strong>Reflect:</strong> Recall a recent act of service. What mixed motives were present? Receive God's mercy, give thanks for what was loving, and release your need to be noticed or repaid.</p><p><strong>Prayer:</strong> Search me, God, and know my heart. Expose pride without crushing me, forgive what is false, and make my love sincere. Amen.</p>",
    "day_number": 2
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> Matthew 6:19-21; 1 Timothy 6:17-19.</p><p><strong>Historical context:</strong> The sermon warns settlers against gathering wealth while neighbors lack necessities. Its economic instructions address a particular community, yet its challenge to greed remains relevant.</p><p><strong>Source theme, in contemporary language:</strong> Money is an uncertain foundation and a useful servant. God provides resources so that we may meet responsibilities, enjoy his gifts with gratitude, share readily, and become rich in good works.</p><p><strong>Reflect:</strong> What does your spending reveal about where you seek security? Choose one practical way to loosen your grip and provide something useful for another person.</p><p><strong>Prayer:</strong> Generous God, keep wealth from ruling my heart. Give me contentment, wisdom, and open hands for the needs you place before me. Amen.</p>",
    "day_number": 3
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> Mark 10:42-45; Galatians 5:13.</p><p><strong>Historical context:</strong> Cushman criticizes people who pursue ease while others carry the community's hardest work. Some of his labels for people are demeaning; this reading keeps the call to service without contempt.</p><p><strong>Source theme, in contemporary language:</strong> Jesus turns power away from domination and toward service. Ability, authority, time, and energy become gifts when they help carry necessary work and protect people from being overburdened.</p><p><strong>Reflect:</strong> Where are you benefiting from work that someone else carries unseen? Offer specific help, share the load fairly, and honor the person whose labor you have overlooked.</p><p><strong>Prayer:</strong> Servant King, reshape my use of strength and authority. Make me ready to help, attentive to hidden labor, and faithful in ordinary service. Amen.</p>",
    "day_number": 4
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> Colossians 3:23-24; Romans 12:9-10.</p><p><strong>Historical context:</strong> The sermon names honor and public approval among the ways self-interest can govern religious work. Cushman's rhetoric is severe, but the underlying concern is service performed for reputation.</p><p><strong>Source theme, in contemporary language:</strong> Faithful work is offered to the Lord and joined to sincere love. We may receive encouragement with gratitude while refusing to make praise the price of our service.</p><p><strong>Reflect:</strong> How does recognition affect your willingness to serve? Do one useful act that may remain unseen, and offer both the work and its outcome to God.</p><p><strong>Prayer:</strong> God who sees in secret, purify my desire for recognition. Help me work wholeheartedly and honor others above myself. Amen.</p>",
    "day_number": 5
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> Philippians 2:5-8; John 13:34-35.</p><p><strong>Historical context:</strong> Cushman points to God's generosity and to Jesus Christ laying aside glory for our salvation. This is the theological center of his appeal to seek another's good.</p><p><strong>Source theme, in contemporary language:</strong> Christian love takes its shape from Jesus, the eternal Son who humbled himself, became obedient to death, and commands his disciples to love one another. We give because God first gave himself to us.</p><p><strong>Reflect:</strong> Where is Christ inviting you to lay aside status, comfort, or the need to win? Choose a humble act of love that makes his character visible.</p><p><strong>Prayer:</strong> Lord Jesus Christ, thank you for humbling yourself for us. Form your self-giving love in me and make my life a witness to you. Amen.</p>",
    "day_number": 6
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> 1 Corinthians 12:24-27; Acts 2:44-47.</p><p><strong>Historical context:</strong> The sermon compares the Plymouth congregation to one body whose members must care for one another. Its detailed social arrangement belonged to that early settlement and is not imposed as a universal economic system here.</p><p><strong>Source theme, in contemporary language:</strong> In Christ, another believer's suffering is not someone else's problem. The church becomes a credible community when people notice needs, share resources, receive help without shame, and rejoice together.</p><p><strong>Reflect:</strong> Who in your church or community may be carrying a need alone? Ask respectfully, listen before assuming, and help in a way that protects dignity and agency.</p><p><strong>Prayer:</strong> Holy Spirit, bind us together as Christ's body. Give us compassion to notice, humility to receive, and generosity to share. Amen.</p>",
    "day_number": 7
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> 2 Corinthians 8:13-15; James 2:15-16.</p><p><strong>Historical context:</strong> Cushman preached after illness and deprivation had marked the colony's first year. He urges hearers to provide food, clothing, shelter, and practical relief rather than wait for desperate people to plead.</p><p><strong>Source theme, in contemporary language:</strong> Compassion moves beyond kind wishes. Christian generosity seeks a fair sharing of burdens so that one person's abundance can answer another person's present need.</p><p><strong>Reflect:</strong> What need have you acknowledged only with words? Identify one resource, skill, connection, or portion of time you can share in a practical and respectful way.</p><p><strong>Prayer:</strong> God of provision, make my compassion concrete. Lead me to share wisely, protect dignity, and help meet real needs. Amen.</p>",
    "day_number": 8
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> Matthew 5:43-48; Luke 6:35-36.</p><p><strong>Historical context:</strong> The sermon answers the fear that generosity is unsafe when other people are selfish. Cushman directs hearers away from copying the crowd and toward the teaching of Jesus.</p><p><strong>Source theme, in contemporary language:</strong> Jesus does not limit love to people who can repay us. God's mercy frees believers to seek another's good without making kindness depend on equal treatment or guaranteed return.</p><p><strong>Reflect:</strong> Where have you made another person's response the condition for doing what is right? Set a wise boundary if needed, then choose a loving action that does not depend on repayment.</p><p><strong>Prayer:</strong> Merciful Father, teach me to love as your child. Give me wisdom, safe boundaries, and freedom from keeping score. Amen.</p>",
    "day_number": 9
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> Galatians 6:2; Romans 12:15.</p><p><strong>Historical context:</strong> Cushman imagines neighbors treating another person's hunger, sickness, sorrow, and welfare as concerns they share. The examples come from a tightly bound settlement, but the call to compassionate solidarity is wider.</p><p><strong>Source theme, in contemporary language:</strong> Bearing burdens means entering another person's reality with patient presence and suitable help. We neither seize control nor stay distant; we mourn, rejoice, pray, and act together.</p><p><strong>Reflect:</strong> Whose burden do you know about but keep at a distance? Ask what support would actually help, and commit to one action you can sustain.</p><p><strong>Prayer:</strong> God of compassion, keep me present to another's joy and pain. Give me patience, humility, and strength to help carry burdens. Amen.</p>",
    "day_number": 10
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> 1 Thessalonians 5:14; Romans 14:1.</p><p><strong>Historical context:</strong> Near the sermon’s close, Cushman warns against hastily calling people lazy because their strength, skill, or courage differs. Elsewhere his language does not always meet this standard, so this reading states the principle consistently.</p><p><strong>Source theme, in contemporary language:</strong> Christian community distinguishes unwillingness from limitation and responds to each person with discernment. We admonish the disruptive, encourage the discouraged, help the weak, and remain patient with everyone.</p><p><strong>Reflect:</strong> Whose capacity have you judged without understanding? Replace the label with a question, listen to the person's circumstances, and offer support suited to the real need.</p><p><strong>Prayer:</strong> Patient God, forgive my hasty judgments. Give me discernment to respond truthfully and compassionately to each person. Amen.</p>",
    "day_number": 11
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> Ephesians 4:1-3; Colossians 3:12-15.</p><p><strong>Historical context:</strong> The sermon closes by urging the colonists to live in peace, yet it describes Indigenous neighbors through degrading colonial prejudice. This adaptation rejects that language and applies the call to humility, justice, and peace toward every neighbor.</p><p><strong>Source theme, in contemporary language:</strong> Christian witness is credible when communities practice humility, patience, forgiveness, and just peace. Christ's peace must govern how believers treat people within the church and neighbors beyond it.</p><p><strong>Reflect:</strong> What rivalry, stereotype, or grievance is weakening your witness? Seek truthful understanding and take one step that joins peace with justice and respect.</p><p><strong>Prayer:</strong> Prince of Peace, expose prejudice and heal division. Clothe us with compassion, guide us in justice, and make our common life a faithful witness. Amen.</p>",
    "day_number": 12
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "value": "<p><strong>Read:</strong> James 1:22-25; 1 Corinthians 10:31-33.</p><p><strong>Historical context:</strong> Cushman's sermon moves from diagnosis to action: examine self-interest, seek another's welfare, and strengthen the community. Its enduring value lies in this practical response rather than in every judgment or social prescription it contains.</p><p><strong>Source theme, in contemporary language:</strong> The word of God calls for embodied obedience. We glorify God when daily choices become less governed by self-protection and more attentive to the salvation, dignity, and good of others.</p><p><strong>Reflect:</strong> Review these readings and choose one practice for the coming week. Name the person, action, and time so that the intention becomes a faithful step.</p><p><strong>Prayer:</strong> God of love, make me a doer of your word. Turn reflection into faithful action and teach me to seek my neighbor's good. Amen.</p>",
    "day_number": 13
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
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 1,
    "references": [
      "1 Corinthians 10:23-24",
      "Philippians 2:3-4"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 2,
    "references": [
      "Psalm 139:23-24",
      "Romans 12:3"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 3,
    "references": [
      "Matthew 6:19-21",
      "1 Timothy 6:17-19"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 4,
    "references": [
      "Mark 10:42-45",
      "Galatians 5:13"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 5,
    "references": [
      "Colossians 3:23-24",
      "Romans 12:9-10"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 6,
    "references": [
      "Philippians 2:5-8",
      "John 13:34-35"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 7,
    "references": [
      "1 Corinthians 12:24-27",
      "Acts 2:44-47"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 8,
    "references": [
      "2 Corinthians 8:13-15",
      "James 2:15-16"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 9,
    "references": [
      "Matthew 5:43-48",
      "Luke 6:35-36"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 10,
    "references": [
      "Galatians 6:2",
      "Romans 12:15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 11,
    "references": [
      "1 Thessalonians 5:14",
      "Romans 14:1"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 12,
    "references": [
      "Ephesians 4:1-3",
      "Colossians 3:12-15"
    ]
  },
  {
    "id": "90000000-0000-0000-0000-000000000333",
    "day_number": 13,
    "references": [
      "James 1:22-25",
      "1 Corinthians 10:31-33"
    ]
  }
]
$adapt_refs$::jsonb) loop
    select id into strict target_day_id from public.devotional_days
    where plan_id = (item ->> 'id')::uuid and day_number = (item ->> 'day_number')::integer;
    update public.scripture_references
    set reference = array(select jsonb_array_elements_text(item -> 'references')),
        updated_at = timestamptz '2026-10-25 13:00:00+00'
    where day_id = target_day_id and user_id is null;
    if not found then
      insert into public.scripture_references (user_id, day_id, reference, created_at, updated_at)
      values (null, target_day_id, array(select jsonb_array_elements_text(item -> 'references')),
              timestamptz '2026-10-25 13:00:00+00', timestamptz '2026-10-25 13:00:00+00');
    end if;
  end loop;
end
$$;

-- Republish the contextualized 1621 Plymouth-sermon adaptation.
update public.devotional_plans
set status = 'published', updated_at = timestamptz '2026-10-25 13:00:00+00'
where id in (
  '90000000-0000-0000-0000-000000000333'::uuid
);
