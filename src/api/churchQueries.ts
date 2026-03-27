import { supabase } from '../lib/supabaseClient';
import { Church, ChurchAnalytics, ChurchMember } from '../types/types';

type PlanProgressRow = {
  user_id: string | null;
  plan_id: string | null;
  completed_once: boolean | null;
};

const emptyAnalytics: ChurchAnalytics = {
  stats: {
    memberCount: 0,
    activePlansCount: 0,
    completedPlansCount: 0,
    topPlan: null,
    activeMembersThisWeek: 0,
    joinedThisMonth: 0,
  },
  topPlans: [],
};

const fetchChurchMemberRows = async (churchId: string) => {
  const { data, error } = await supabase
    .from('profiles')
    .select('id, first_name, last_name, avatar_url, created_at, last_seen')
    .eq('church_id', churchId)
    .order('first_name')
    .order('last_name');

  if (error) throw error;
  return data ?? [];
};

const fetchChurchProgressRows = async (memberIds: string[]) => {
  if (!memberIds.length) return [] as PlanProgressRow[];

  const { data, error } = await supabase
    .from('plan_progress')
    .select('user_id, plan_id, completed_once, updated_at, created_at')
    .in('user_id', memberIds)
    .not('plan_id', 'is', null);

  if (error) throw error;
  return (data ?? []) as PlanProgressRow[];
};

export const fetchChurch = async (churchId: string) => {
  const { data, error } = await supabase.from('churches').select('*').eq('id', churchId).single();

  if (error) throw error;
  return data as Church;
};

export const fetchChurchMembers = async (churchId: string) => {
  const members = await fetchChurchMemberRows(churchId);
  if (!members.length) return [] as ChurchMember[];

  const progressRows = await fetchChurchProgressRows(members.map((member) => member.id));
  const activePlansByUserId = new Map<string, Set<string>>();

  for (const row of progressRows) {
    if (!row.user_id || !row.plan_id || row.completed_once) continue;
    const current = activePlansByUserId.get(row.user_id) ?? new Set<string>();
    current.add(row.plan_id);
    activePlansByUserId.set(row.user_id, current);
  }

  return members.map((member) => ({
    ...member,
    activePlansCount: activePlansByUserId.get(member.id)?.size ?? 0,
  }));
};

export const fetchChurchAnalytics = async (churchId: string): Promise<ChurchAnalytics> => {
  const { data, error } = await supabase.rpc('get_church_analytics', {
    p_church_id: churchId,
  });

  if (error) throw error;
  return (data ?? emptyAnalytics) as ChurchAnalytics;
};
