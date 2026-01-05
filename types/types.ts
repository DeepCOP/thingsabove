import { Database } from './supabase.gen.types';

export type DevotionalPlan = Database['public']['Tables']['devotional_plans']['Row'];

export type DevotionalPlanInsert = Database['public']['Tables']['devotional_plans']['Insert'];

export type DevotionalPlanUpdate = Database['public']['Tables']['devotional_plans']['Update'];

export type Profiles = Database['public']['Tables']['profiles']['Row'];

export type ProfilesInsert = Database['public']['Tables']['profiles']['Insert'];

export type ProfilesUpdate = Database['public']['Tables']['profiles']['Update'];

export type DevotionalDays = Database['public']['Tables']['devotional_days']['Row'];

export type DevotionalDaysInsert = Database['public']['Tables']['devotional_days']['Insert'];

export type DevotionalDaysUpdate = Database['public']['Tables']['devotional_days']['Update'];

export type ScriptureReferences = Database['public']['Tables']['scripture_references']['Row'];

export type ScriptureReferencesInsert =
  Database['public']['Tables']['scripture_references']['Insert'];

export type ScriptureReferencesUpdate =
  Database['public']['Tables']['scripture_references']['Update'];

export type Comments = Database['public']['Tables']['comments']['Row'];

export type CommentsInsert = Database['public']['Tables']['comments']['Insert'];

export type CommentsUpdate = Database['public']['Tables']['comments']['Update'];

export type PlanProgress = Database['public']['Tables']['plan_progress']['Row'];
export type PlanProgressInsert = Database['public']['Tables']['plan_progress']['Insert'];
export type PlanProgressUpdate = Database['public']['Tables']['plan_progress']['Update'];

export type PlanDayView = Database['public']['Views']['plan_day_view']['Row'];

export type DevotionalPlanView = Database['public']['Views']['devotional_plans_view']['Row'];

export type ParsedVerse = {
  book: string; // "Song of Solomon"
  chapter: number; // 2
  verseStart: number; // 1
  verseEnd?: number; // 4
};

export type Notifications = Database['public']['Tables']['notifications']['Row'];
export type NotificationsInsert = Database['public']['Tables']['notifications']['Insert'];
export type NotificationsUpdate = Database['public']['Tables']['notifications']['Update'];
