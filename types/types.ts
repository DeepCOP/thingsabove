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
