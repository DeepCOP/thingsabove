import { Database } from './supabase.gen.types';

export type DevotionalPlan = Database['public']['Tables']['devotional_plans']['Row'];

export type DevotionalPlanInsert = Database['public']['Tables']['devotional_plans']['Insert'];

export type DevotionalPlanUpdate = Database['public']['Tables']['devotional_plans']['Update'];

export type Profiles = Database['public']['Tables']['profiles']['Row'];

export type ProfilesInsert = Database['public']['Tables']['profiles']['Insert'];

export type ProfilesUpdate = Database['public']['Tables']['profiles']['Update'];

export type Church = Database['public']['Tables']['churches']['Row'];

export type ChurchInsert = Database['public']['Tables']['churches']['Insert'];

export type ChurchUpdate = Database['public']['Tables']['churches']['Update'];

export type ProfileChurch = Pick<Church, 'id' | 'name' | 'address' | 'website_url'>;

export type ProfileLocationSource = 'device' | 'ip';

export type ProfileLocation = {
  source: ProfileLocationSource;
  latitude: number | null;
  longitude: number | null;
  accuracy_meters: number | null;
  city: string | null;
  region: string | null;
  country: string | null;
  country_code: string | null;
  timezone: string | null;
  captured_at: string;
};

type ProfileWithChurchBase = Pick<
  Profiles,
  | 'id'
  | 'email'
  | 'first_name'
  | 'last_name'
  | 'avatar_url'
  | 'bio'
  | 'year_believed'
  | 'year_baptized'
  | 'location'
>;

export type ProfileWithChurch = Omit<ProfileWithChurchBase, 'location'> & {
  location: ProfileLocation | null;
  church: ProfileChurch | null;
};

export type ChurchStats = {
  memberCount: number;
  activePlansCount: number;
  completedPlansCount: number;
  topPlan: { id: string; title: string; starters: number } | null;
  activeMembersThisWeek: number;
  joinedThisMonth: number;
};

export type ChurchMemberPreview = {
  id: string;
  first_name: string | null;
  last_name: string | null;
  avatar_url: string | null;
};

export type ChurchMember = Database['public']['Functions']['get_church_members']['Returns'][number];

export type ChurchTopPlan = {
  id: string;
  title: string;
  cover_image: string | null;
  starters: number;
  completions: number;
};

export type ChurchAnalytics = {
  stats: ChurchStats;
  topPlans: ChurchTopPlan[];
};

export type UpdateProfileInput = {
  first_name?: string;
  last_name?: string;
  avatar_url?: string;
  bio?: string;
  year_believed?: number | null;
  year_baptized?: number | null;
  church_id?: string | null;
  church_name?: string | null;
  church_address?: string | null;
  church_website_url?: string | null;
  clear_church?: boolean;
};

export type SignUpAboutDetailsInput = {
  user_id: string;
  email: string;
  year_believed?: number | null;
  year_baptized?: number | null;
  church_id?: string | null;
  church_name?: string | null;
  church_address?: string | null;
  church_website_url?: string | null;
  clear_church?: boolean;
};

export type ProfileDeviceMetadataInput = {
  appVersion?: string | null;
  deviceOs?: string | null;
  deviceOsVersion?: string | null;
  deviceLanguageTag?: string | null;
  deviceLanguageCode?: string | null;
};

export type SignUpProfileInput = ProfileDeviceMetadataInput & {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  yearBelieved?: number | null;
  yearBaptized?: number | null;
  churchName?: string | null;
  churchAddress?: string | null;
  churchWebsiteUrl?: string | null;
};

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

export type PlanDayComment =
  Database['public']['Functions']['get_plan_day_comments']['Returns'][number];

export type PlanProgress = Database['public']['Tables']['plan_progress']['Row'];
export type PlanProgressInsert = Database['public']['Tables']['plan_progress']['Insert'];
export type PlanProgressUpdate = Database['public']['Tables']['plan_progress']['Update'];

export type DevotionalPlanView = Database['public']['Views']['devotional_plans_view']['Row'];
export type MyPlanProgressPlan =
  Database['public']['Functions']['get_my_plan_progress_plans']['Returns'][number];

export type ParsedVerse = {
  book: string; // "Song of Solomon"
  scope: 'book' | 'chapter' | 'verse';
  chapter?: number; // 2
  verseStart?: number; // 1
  verseEnd?: number; // 4
};

export type Notifications = Database['public']['Tables']['notifications']['Row'];
export type NotificationsInsert = Database['public']['Tables']['notifications']['Insert'];
export type NotificationsUpdate = Database['public']['Tables']['notifications']['Update'];
export type GetMyNotifications = Database['public']['Functions']['get_my_notifications']['Returns'];

export type PlanGroupMembers = Database['public']['Tables']['plan_group_members']['Row'];
export type PlanGroupMembersInsert = Database['public']['Tables']['plan_group_members']['Insert'];
export type PlanGroupMembersUpdate = Database['public']['Tables']['plan_group_members']['Update'];
export type PlanGroupMember = {
  id: string;
  status: string | null;
  joined_at: string | null;
  user_id: string;
  profiles: Pick<Profiles, 'id' | 'first_name' | 'last_name' | 'avatar_url'>;
};

export type DayItemType = 'devotional' | 'scripture' | 'comment';

export type DayItemTemplate = {
  day_number: number;
  devotional_content: string | null;
  item_key: string;
  item_type: DayItemType;
  title: string | null;
};

export type DayItemsProgress = Database['public']['Tables']['day_items_progress']['Row'] & {
  title?: string | null;
};
export type DayItemsProgressInsert = Database['public']['Tables']['day_items_progress']['Insert'];
export type DayItemsProgressUpdate = Database['public']['Tables']['day_items_progress']['Update'];

export type GetPendingFriendRequests =
  Database['public']['Functions']['get_pending_friend_requests']['Returns'];

export type GetPlanReactionSummary =
  Database['public']['Functions']['get_plan_reaction_summary']['Returns'];

export type GetMyDevotionalPlans =
  Database['public']['Functions']['get_my_devotional_plans']['Returns'];

export type NotificationPreferences =
  Database['public']['Tables']['notification_preferences']['Row'];

export type ScriptureNoteType = 'verse' | 'section' | 'chapter' | 'book';

export type ScriptureNoteContext = {
  noteType: ScriptureNoteType;
  scopeKey: string;
  bookId: string;
  book: string;
  chapter: number | null;
  verseStart: number | null;
  verseEnd: number | null;
};

export type ScriptureNote = {
  id: string;
  user_id: string;
  note_type: ScriptureNoteType;
  scope_key: string;
  book: string;
  chapter: number | null;
  verse_start: number | null;
  verse_end: number | null;
  parent_note_id: string | null;
  content: string;
  created_at: string;
  updated_at: string;
  first_name: string;
  last_name: string;
  avatar_url: string | null;
  helpful_count: number;
  is_helpful: boolean;
};

export type SavedPlanListItem = DevotionalPlanView & {
  saved_at: string | null;
};

export type PrayerRequest = Database['public']['Tables']['prayer_requests']['Row'];

export type PrayerRequestInsert = Database['public']['Tables']['prayer_requests']['Insert'];

export type PrayerRequestUpdate = Database['public']['Tables']['prayer_requests']['Update'];

export type PrayerRequestEncouragement =
  Database['public']['Tables']['prayer_request_encouragements']['Row'];

export type PrayerRequestPrayer = Database['public']['Tables']['prayer_request_prayers']['Row'];

export type PrayerScope = 'public' | 'church';

export type PrayerFilter = 'all' | 'urgent' | 'answered' | 'mine';

export type PrayerCategory = 'Health' | 'Family' | 'Work' | 'Spiritual' | 'Other';

export type PrayerRequestFeedItem =
  Database['public']['Functions']['get_prayer_requests']['Returns'][number];

export type PrayerRequestDetail =
  Database['public']['Functions']['get_prayer_request_detail']['Returns'][number];

export type PrayerRequestCursor = {
  beforeCreatedAt: string;
  beforeId: string;
  beforeIsUrgent: boolean;
};

export type PrayerRequestPage = {
  items: PrayerRequestFeedItem[];
  nextCursor?: PrayerRequestCursor;
};

export type PrayerEncouragementListItem = PrayerRequestEncouragement & {
  author: Pick<Profiles, 'id' | 'first_name' | 'last_name' | 'avatar_url'> | null;
};
