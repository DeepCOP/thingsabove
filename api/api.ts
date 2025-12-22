import { PlanProgressInsert } from '@/types/types';
import { sortByItemKey } from '@/utils/utils';
import { supabase } from './supabase';
export const searchRelatedPlans = async (currentPlanId: string, tags: string) => {
  const { data, error } = await supabase
    .from('devotional_plans')
    .select('id, title, cover_image, total_days, tags, description')
    .neq('id', currentPlanId)
    .textSearch('tags', tags, { type: 'websearch' })
    .limit(10);
  if (error) throw error;

  return data;
};

export const searchPlans = async ({
  pageParam,
  query,
}: {
  pageParam: { created_at: string | null; id: string | null };
  query: string;
}) => {
  const PAGE_SIZE = 10;

  const { data, error } = await supabase.rpc('search_plans', {
    search_query: query,
    limit_count: PAGE_SIZE,
    cursor_created_at: pageParam?.created_at ?? undefined,
    cursor_id: pageParam?.id ?? undefined,
  });

  if (error) throw error;
  const last = data?.[data.length - 1] ?? null;

  return {
    items: data,
    nextCursor: last ? { created_at: last.created_at, id: last.id } : null,
  };
};

export const fetchPlans = async ({
  pageParam,
}: {
  pageParam: { created_at: string | null; id: string | null };
}) => {
  const PAGE_SIZE = 10;
  const { created_at, id } = pageParam ?? {};

  let query = supabase
    .from('devotional_plans_view')
    .select('*')
    .order('created_at', { ascending: false })
    .order('id', { ascending: false }) // secondary key for stable ordering
    .limit(PAGE_SIZE);

  if (created_at && id) {
    query = query.or(`created_at.lt.${created_at},and(created_at.eq.${created_at},id.lt.${id})`);
  }

  const { data, error } = await query;
  if (error) throw error;

  // last item becomes the new cursor
  const last = data[data.length - 1];

  return {
    items: data,
    nextCursor: last ? { created_at: last.created_at, id: last.id } : null,
  };
};

export const fetchPlanById = async (id: string) => {
  let { data, error } = await supabase.from('devotional_plans').select('*').eq('id', id).single();

  if (error) throw error;

  return data;
};

export const fetchDayItems = async ({
  user_id,
  plan_id,
  day_id,
  scripture_refs,
}: {
  user_id: string;
  plan_id: string;
  day_id: string;
  scripture_refs: string[];
}) => {
  const { data, error } = await supabase
    .from('day_items_progress')
    .select('*')
    .eq('user_id', user_id)
    .eq('plan_id', plan_id)
    .eq('day_id', day_id);

  if (error) throw error;
  // Return mapped progress
  return {
    items: [...data].sort((a, b) => {
      const getNumericPrefix = (key?: string | null) => {
        if (!key) return 0;
        const match = key.match(/^(\d+)/); // Match numerical prefix at the beginning
        return match ? Number(match[0]) : 0;
      };

      const numericA = getNumericPrefix(a.item_key);
      const numericB = getNumericPrefix(b.item_key);

      // If the numeric prefixes are the same, fall back to lexicographical comparison
      if (numericA === numericB) {
        return (a.item_key ?? '').localeCompare(b.item_key ?? '');
      }

      return numericA - numericB;
    }),
    devotional: {
      completed: data.find((i) => i.item_type === 'devotional' && i.item_key === 'main')?.completed,
      id: data.find((i) => i.item_type === 'devotional' && i.item_key === 'main')?.id,
    },
    scriptures: [...scripture_refs]
      .sort((a, b) => sortByItemKey(a, b))
      .map((ref) => ({
        ref,
        completed: data.find((i) => i.item_type === 'scripture' && i.item_key === ref)?.completed,
        id: data.find((i) => i.item_type === 'scripture' && i.item_key === ref)?.id,
      })),
  };
};

export const toggleItemCompletion = async ({
  item_type,
  item_key,
  completed,
  user_id,
  plan_id,
  day_id,
}: {
  item_type: 'devotional' | 'scripture';
  item_key: string;
  completed: boolean;
  user_id: string;
  plan_id: string;
  day_id: string;
}) => {
  const { error } = await supabase.rpc('toggle_item_completion', {
    p_user_id: user_id,
    p_plan_id: plan_id,
    p_day_id: day_id,
    p_item_type: item_type,
    p_item_key: item_key,
    p_completed: completed,
  });

  if (error) throw error;
};

export const toggleDayCompletion = async ({
  completed,
  user_id,
  plan_id,
  day_id,
}: {
  completed: boolean;
  user_id: string;
  plan_id: string;
  day_id: string;
}) => {
  const { error } = await supabase.rpc('toggle_day_completion', {
    p_user_id: user_id,
    p_plan_id: plan_id,
    p_day_id: day_id,
    p_completed: completed,
  });
  ``;

  if (error) throw error;
};

export const loadDayItems = async ({
  user_id,
  plan_id,
  day_id,
}: {
  user_id: string;
  plan_id: string;
  day_id: string;
}) => {
  const { error } = await supabase.rpc('ensure_day_items_exist', {
    p_user_id: user_id,
    p_plan_id: plan_id,
    p_day_id: day_id,
  });

  if (error) throw error;
};

export const fetchPlanProgress = async ({
  plan_id,
  user_id,
}: {
  plan_id: string;
  user_id: string;
}) => {
  const { data, error } = await supabase
    .from('plan_progress')
    .select('id, current_day, completed_days,created_at')
    .eq('plan_id', plan_id)
    .eq('user_id', user_id)
    .single();

  if (error && error.code !== 'PGRST116') throw error;
  return data;
};

export const fetchPlanDays = async ({ plan_id }: { plan_id: string }) => {
  const { data, error } = await supabase
    .from('devotional_days')
    .select('*')
    .eq('plan_id', plan_id)
    .order('day_number');

  if (error) throw error;
  return data;
};

export const insertToPlanProgress = async (payload: PlanProgressInsert) => {
  const { data, error } = await supabase.from('plan_progress').insert(payload).select('*').single();

  if (error) throw error;
  return data;
};

export const fetchPlanDayView = async (day_id: string) => {
  const { data, error } = await supabase
    .from('plan_day_view')
    .select('*')
    .eq('day_id', day_id ?? '')
    .single();

  if (error) throw error;
  return data;
};
