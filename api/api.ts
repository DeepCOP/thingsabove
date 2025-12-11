import { supabase } from './supabase';

export const searchRelatedPlans = async (currentPlanId: string, tags: string) => {
  const { data, error } = await supabase
    .from('devotional_plans')
    .select('id, title, cover_image, total_days, tags, description')
    .neq('id', currentPlanId)
    .textSearch('tags', tags, { type: 'websearch' })
    .limit(10);
  if (error) throw error;
  // console.log("data",data)

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
    }

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
        query = query.or(
          `created_at.lt.${created_at},and(created_at.eq.${created_at},id.lt.${id})`,
        );
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
      let { data, error } = await supabase
        .from('devotional_plans')
        .select('*')
        .eq('id', id)
        .single();

      if (error) throw error;

      return data;
    }