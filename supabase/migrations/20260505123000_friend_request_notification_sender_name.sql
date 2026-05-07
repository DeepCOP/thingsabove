create or replace function public.send_friend_request(
  p_receiver_id uuid
)
returns void
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_sender_name text;
begin
  if auth.uid() = p_receiver_id then
    raise exception 'Cannot send friend request to yourself';
  end if;

  if exists (
    select 1
    from public.friends
    where (requester_id = auth.uid() and receiver_id = p_receiver_id)
      or (requester_id = p_receiver_id and receiver_id = auth.uid())
  ) then
    raise exception 'Friend request already exists';
  end if;

  insert into public.friends (requester_id, receiver_id, status)
  values (auth.uid(), p_receiver_id, 'pending');

  select nullif(
    trim(
      concat_ws(
        ' ',
        nullif(trim(first_name), ''),
        nullif(trim(last_name), '')
      )
    ),
    ''
  )
    into v_sender_name
  from public.profiles
  where id = auth.uid();

  perform public.create_notification(
    array[p_receiver_id],
    'friend_request',
    'You have a new friend request',
    format('%s sent you friend request', coalesce(v_sender_name, 'Someone')),
    jsonb_build_object(
      'requester_id', auth.uid()
    )
  );
end;
$$;
