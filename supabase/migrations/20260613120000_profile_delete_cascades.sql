alter table public.friends
  drop constraint if exists friends_requester_id_fkey,
  drop constraint if exists friends_receiver_id_fkey;

alter table public.friends
  add constraint friends_requester_id_fkey
    foreign key (requester_id)
    references public.profiles(id)
    on delete cascade,
  add constraint friends_receiver_id_fkey
    foreign key (receiver_id)
    references public.profiles(id)
    on delete cascade;

alter table public.plan_groups
  drop constraint if exists plan_groups_created_by_fkey;

alter table public.plan_groups
  add constraint plan_groups_created_by_fkey
    foreign key (created_by)
    references public.profiles(id)
    on delete cascade;

alter table public.plan_group_members
  drop constraint if exists plan_group_members_user_id_fkey;

alter table public.plan_group_members
  add constraint plan_group_members_user_id_fkey
    foreign key (user_id)
    references public.profiles(id)
    on delete cascade;
