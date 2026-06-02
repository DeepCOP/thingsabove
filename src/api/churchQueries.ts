import { supabase } from '../lib/supabaseClient';
import { Church, ChurchAnalytics, ChurchMember } from '../types/types';

export const CHURCH_MEMBERS_PAGE_SIZE = 20;

type ChurchMembersPage = {
  items: ChurchMember[];
  nextOffset: number | null;
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

export const fetchChurch = async (churchId: string) => {
  const { data, error } = await supabase.from('churches').select('*').eq('id', churchId).single();

  if (error) throw error;
  return data as Church;
};

export const fetchChurchMembers = async ({
  churchId,
  offset,
  search,
}: {
  churchId: string;
  offset: number;
  search?: string;
}): Promise<ChurchMembersPage> => {
  const { data, error } = await supabase.rpc('get_church_members', {
    p_church_id: churchId,
    p_limit: CHURCH_MEMBERS_PAGE_SIZE + 1,
    p_offset: offset,
    p_search: search?.trim() || undefined,
  });

  if (error) {
    throw error;
  }
  const rows = (data ?? []) as ChurchMember[];
  const hasNextPage = rows.length > CHURCH_MEMBERS_PAGE_SIZE;
  const pageRows = hasNextPage ? rows.slice(0, CHURCH_MEMBERS_PAGE_SIZE) : rows;

  return {
    items: pageRows,
    nextOffset: hasNextPage ? offset + CHURCH_MEMBERS_PAGE_SIZE : null,
  };
};

export const fetchChurchAnalytics = async (churchId: string): Promise<ChurchAnalytics> => {
  const { data, error } = await supabase.rpc('get_church_analytics', {
    p_church_id: churchId,
  });

  if (error) throw error;
  return (data ?? emptyAnalytics) as ChurchAnalytics;
};

export const getOrCreateChurchInviteCode = async ({ churchId }: { churchId: string }) => {
  const { data, error } = await supabase.rpc('get_or_create_church_invite_code', {
    p_church_id: churchId,
  });

  if (error) {
    throw error;
  }

  if (!data) {
    throw new Error('Church invite code not found');
  }

  return data as string;
};
