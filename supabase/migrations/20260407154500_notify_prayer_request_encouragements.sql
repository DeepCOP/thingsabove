create or replace function public.add_prayer_request_encouragement(
  p_request_id uuid,
  p_content text
)
returns uuid
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_user_id uuid := auth.uid();
  v_content text := btrim(coalesce(p_content, ''));
  v_encouragement_id uuid;
  v_request_owner_id uuid;
  v_sender_first_name text;
begin
  if v_user_id is null then
    raise exception 'Authentication required';
  end if;

  if v_content = '' then
    raise exception 'Encouragement cannot be empty';
  end if;

  if char_length(v_content) > 300 then
    raise exception 'Encouragement must be 300 characters or fewer';
  end if;

  select pr.user_id
    into v_request_owner_id
  from public.prayer_requests pr
  where pr.id = p_request_id
    and pr.allow_comments
    and public.can_access_prayer_scope(pr.scope, pr.church_id);

  if v_request_owner_id is null then
    raise exception 'Prayer request not found';
  end if;

  insert into public.prayer_request_encouragements (request_id, user_id, content)
  values (p_request_id, v_user_id, v_content)
  returning id into v_encouragement_id;

  if v_request_owner_id <> v_user_id then
    select nullif(trim(first_name), '')
      into v_sender_first_name
    from public.profiles
    where id = v_user_id;

    perform public.create_notification(
      array[v_request_owner_id],
      'prayer_encouragement',
      'New Encouragement',
      format(
        '%s sent encouragement on your prayer request.',
        coalesce(v_sender_first_name, 'Someone')
      ),
      jsonb_build_object(
        'request_id', p_request_id,
        'encouraged_by', v_user_id
      )
    );
  end if;

  return v_encouragement_id;
end;
$$;
