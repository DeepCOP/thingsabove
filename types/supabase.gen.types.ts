export type Json = string | number | boolean | null | { [key: string]: Json | undefined } | Json[];

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: '13.0.5';
  };
  public: {
    Tables: {
      comments: {
        Row: {
          content: string;
          created_at: string | null;
          entity_id: string;
          entity_type: string | null;
          id: string;
          updated_at: string | null;
          user_id: string | null;
        };
        Insert: {
          content: string;
          created_at?: string | null;
          entity_id: string;
          entity_type?: string | null;
          id?: string;
          updated_at?: string | null;
          user_id?: string | null;
        };
        Update: {
          content?: string;
          created_at?: string | null;
          entity_id?: string;
          entity_type?: string | null;
          id?: string;
          updated_at?: string | null;
          user_id?: string | null;
        };
        Relationships: [];
      };
      day_items_progress: {
        Row: {
          completed: boolean | null;
          created_at: string | null;
          day_id: string | null;
          id: string;
          item_key: string | null;
          item_type: string | null;
          plan_id: string | null;
          updated_at: string | null;
          user_id: string | null;
        };
        Insert: {
          completed?: boolean | null;
          created_at?: string | null;
          day_id?: string | null;
          id?: string;
          item_key?: string | null;
          item_type?: string | null;
          plan_id?: string | null;
          updated_at?: string | null;
          user_id?: string | null;
        };
        Update: {
          completed?: boolean | null;
          created_at?: string | null;
          day_id?: string | null;
          id?: string;
          item_key?: string | null;
          item_type?: string | null;
          plan_id?: string | null;
          updated_at?: string | null;
          user_id?: string | null;
        };
        Relationships: [
          {
            foreignKeyName: 'day_items_progress_day_id_fkey';
            columns: ['day_id'];
            isOneToOne: false;
            referencedRelation: 'devotional_days';
            referencedColumns: ['id'];
          },
          {
            foreignKeyName: 'day_items_progress_day_id_fkey';
            columns: ['day_id'];
            isOneToOne: false;
            referencedRelation: 'plan_day_view';
            referencedColumns: ['day_id'];
          },
          {
            foreignKeyName: 'day_items_progress_plan_id_fkey';
            columns: ['plan_id'];
            isOneToOne: false;
            referencedRelation: 'devotional_plans';
            referencedColumns: ['id'];
          },
          {
            foreignKeyName: 'day_items_progress_plan_id_fkey';
            columns: ['plan_id'];
            isOneToOne: false;
            referencedRelation: 'devotional_plans_view';
            referencedColumns: ['id'];
          },
        ];
      };
      devotional_days: {
        Row: {
          content: string;
          created_at: string | null;
          day_number: number;
          id: string;
          plan_id: string | null;
          updated_at: string | null;
        };
        Insert: {
          content: string;
          created_at?: string | null;
          day_number: number;
          id?: string;
          plan_id?: string | null;
          updated_at?: string | null;
        };
        Update: {
          content?: string;
          created_at?: string | null;
          day_number?: number;
          id?: string;
          plan_id?: string | null;
          updated_at?: string | null;
        };
        Relationships: [
          {
            foreignKeyName: 'devotional_days_plan_id_fkey';
            columns: ['plan_id'];
            isOneToOne: false;
            referencedRelation: 'devotional_plans';
            referencedColumns: ['id'];
          },
          {
            foreignKeyName: 'devotional_days_plan_id_fkey';
            columns: ['plan_id'];
            isOneToOne: false;
            referencedRelation: 'devotional_plans_view';
            referencedColumns: ['id'];
          },
        ];
      };
      devotional_plans: {
        Row: {
          author_id: string | null;
          completions: number | null;
          cover_image: string | null;
          created_at: string | null;
          description: string;
          id: string;
          tags: string | null;
          title: string;
          total_days: number;
          updated_at: string | null;
        };
        Insert: {
          author_id?: string | null;
          completions?: number | null;
          cover_image?: string | null;
          created_at?: string | null;
          description: string;
          id?: string;
          tags?: string | null;
          title: string;
          total_days?: number;
          updated_at?: string | null;
        };
        Update: {
          author_id?: string | null;
          completions?: number | null;
          cover_image?: string | null;
          created_at?: string | null;
          description?: string;
          id?: string;
          tags?: string | null;
          title?: string;
          total_days?: number;
          updated_at?: string | null;
        };
        Relationships: [];
      };
      plan_progress: {
        Row: {
          completed_days: number[] | null;
          created_at: string | null;
          current_day: number;
          id: string;
          plan_id: string | null;
          updated_at: string | null;
          user_id: string | null;
        };
        Insert: {
          completed_days?: number[] | null;
          created_at?: string | null;
          current_day?: number;
          id?: string;
          plan_id?: string | null;
          updated_at?: string | null;
          user_id?: string | null;
        };
        Update: {
          completed_days?: number[] | null;
          created_at?: string | null;
          current_day?: number;
          id?: string;
          plan_id?: string | null;
          updated_at?: string | null;
          user_id?: string | null;
        };
        Relationships: [
          {
            foreignKeyName: 'plan_progress_plan_id_fkey';
            columns: ['plan_id'];
            isOneToOne: false;
            referencedRelation: 'devotional_plans';
            referencedColumns: ['id'];
          },
          {
            foreignKeyName: 'plan_progress_plan_id_fkey';
            columns: ['plan_id'];
            isOneToOne: false;
            referencedRelation: 'devotional_plans_view';
            referencedColumns: ['id'];
          },
        ];
      };
      plan_reactions: {
        Row: {
          created_at: string | null;
          id: string;
          plan_id: string | null;
          reaction_type: string | null;
          user_id: string | null;
        };
        Insert: {
          created_at?: string | null;
          id?: string;
          plan_id?: string | null;
          reaction_type?: string | null;
          user_id?: string | null;
        };
        Update: {
          created_at?: string | null;
          id?: string;
          plan_id?: string | null;
          reaction_type?: string | null;
          user_id?: string | null;
        };
        Relationships: [
          {
            foreignKeyName: 'plan_reactions_plan_id_fkey';
            columns: ['plan_id'];
            isOneToOne: false;
            referencedRelation: 'devotional_plans';
            referencedColumns: ['id'];
          },
          {
            foreignKeyName: 'plan_reactions_plan_id_fkey';
            columns: ['plan_id'];
            isOneToOne: false;
            referencedRelation: 'devotional_plans_view';
            referencedColumns: ['id'];
          },
        ];
      };
      profiles: {
        Row: {
          avatar_url: string | null;
          bio: string | null;
          created_at: string | null;
          email: string;
          first_name: string;
          id: string;
          last_name: string;
          updated_at: string | null;
        };
        Insert: {
          avatar_url?: string | null;
          bio?: string | null;
          created_at?: string | null;
          email: string;
          first_name: string;
          id: string;
          last_name: string;
          updated_at?: string | null;
        };
        Update: {
          avatar_url?: string | null;
          bio?: string | null;
          created_at?: string | null;
          email?: string;
          first_name?: string;
          id?: string;
          last_name?: string;
          updated_at?: string | null;
        };
        Relationships: [];
      };
      reports: {
        Row: {
          created_at: string | null;
          id: string;
          plan_id: string | null;
          reason: string;
          user_id: string | null;
        };
        Insert: {
          created_at?: string | null;
          id?: string;
          plan_id?: string | null;
          reason: string;
          user_id?: string | null;
        };
        Update: {
          created_at?: string | null;
          id?: string;
          plan_id?: string | null;
          reason?: string;
          user_id?: string | null;
        };
        Relationships: [
          {
            foreignKeyName: 'reports_plan_id_fkey';
            columns: ['plan_id'];
            isOneToOne: false;
            referencedRelation: 'devotional_plans';
            referencedColumns: ['id'];
          },
          {
            foreignKeyName: 'reports_plan_id_fkey';
            columns: ['plan_id'];
            isOneToOne: false;
            referencedRelation: 'devotional_plans_view';
            referencedColumns: ['id'];
          },
        ];
      };
      scripture_references: {
        Row: {
          created_at: string | null;
          day_id: string | null;
          id: string;
          reference: string[] | null;
          updated_at: string | null;
          user_id: string | null;
        };
        Insert: {
          created_at?: string | null;
          day_id?: string | null;
          id?: string;
          reference?: string[] | null;
          updated_at?: string | null;
          user_id?: string | null;
        };
        Update: {
          created_at?: string | null;
          day_id?: string | null;
          id?: string;
          reference?: string[] | null;
          updated_at?: string | null;
          user_id?: string | null;
        };
        Relationships: [
          {
            foreignKeyName: 'scripture_references_day_id_fkey';
            columns: ['day_id'];
            isOneToOne: false;
            referencedRelation: 'devotional_days';
            referencedColumns: ['id'];
          },
          {
            foreignKeyName: 'scripture_references_day_id_fkey';
            columns: ['day_id'];
            isOneToOne: false;
            referencedRelation: 'plan_day_view';
            referencedColumns: ['day_id'];
          },
        ];
      };
    };
    Views: {
      devotional_plans_view: {
        Row: {
          author_id: string | null;
          comments_count: number | null;
          completions: number | null;
          cover_image: string | null;
          created_at: string | null;
          description: string | null;
          dislikes_count: number | null;
          id: string | null;
          likes_count: number | null;
          tags: string | null;
          title: string | null;
          total_days: number | null;
          updated_at: string | null;
        };
        Insert: {
          author_id?: string | null;
          comments_count?: never;
          completions?: number | null;
          cover_image?: string | null;
          created_at?: string | null;
          description?: string | null;
          dislikes_count?: never;
          id?: string | null;
          likes_count?: never;
          tags?: string | null;
          title?: string | null;
          total_days?: number | null;
          updated_at?: string | null;
        };
        Update: {
          author_id?: string | null;
          comments_count?: never;
          completions?: number | null;
          cover_image?: string | null;
          created_at?: string | null;
          description?: string | null;
          dislikes_count?: never;
          id?: string | null;
          likes_count?: never;
          tags?: string | null;
          title?: string | null;
          total_days?: number | null;
          updated_at?: string | null;
        };
        Relationships: [];
      };
      plan_day_view: {
        Row: {
          day_id: string | null;
          day_number: number | null;
          devotional_content: string | null;
          plan_id: string | null;
          scripture_refs: string[] | null;
        };
        Insert: {
          day_id?: string | null;
          day_number?: number | null;
          devotional_content?: string | null;
          plan_id?: string | null;
          scripture_refs?: never;
        };
        Update: {
          day_id?: string | null;
          day_number?: number | null;
          devotional_content?: string | null;
          plan_id?: string | null;
          scripture_refs?: never;
        };
        Relationships: [
          {
            foreignKeyName: 'devotional_days_plan_id_fkey';
            columns: ['plan_id'];
            isOneToOne: false;
            referencedRelation: 'devotional_plans';
            referencedColumns: ['id'];
          },
          {
            foreignKeyName: 'devotional_days_plan_id_fkey';
            columns: ['plan_id'];
            isOneToOne: false;
            referencedRelation: 'devotional_plans_view';
            referencedColumns: ['id'];
          },
        ];
      };
    };
    Functions: {
      ensure_day_items_exist: {
        Args: { p_day_id: string; p_plan_id: string; p_user_id: string };
        Returns: undefined;
      };
      mark_day_complete: {
        Args: { p_day: number; p_plan: string; p_user: string };
        Returns: undefined;
      };
      search_plans: {
        Args: {
          cursor_created_at?: string;
          cursor_id?: string;
          limit_count?: number;
          search_query: string;
        };
        Returns: {
          author_id: string | null;
          comments_count: number | null;
          completions: number | null;
          cover_image: string | null;
          created_at: string | null;
          description: string | null;
          dislikes_count: number | null;
          id: string | null;
          likes_count: number | null;
          tags: string | null;
          title: string | null;
          total_days: number | null;
          updated_at: string | null;
        }[];
        SetofOptions: {
          from: '*';
          to: 'devotional_plans_view';
          isOneToOne: false;
          isSetofReturn: true;
        };
      };
      show_limit: { Args: never; Returns: number };
      show_trgm: { Args: { '': string }; Returns: string[] };
      toggle_day_completion: {
        Args: {
          p_completed: boolean;
          p_day_id: string;
          p_plan_id: string;
          p_user_id: string;
        };
        Returns: undefined;
      };
      toggle_item_completion: {
        Args: {
          p_completed: boolean;
          p_day_id: string;
          p_item_key: string;
          p_item_type: string;
          p_plan_id: string;
          p_user_id: string;
        };
        Returns: undefined;
      };
      toggle_reaction: {
        Args: { p_plan_id: string; p_reaction_type: string; p_user_id: string };
        Returns: string;
      };
      unmark_day_complete: {
        Args: { p_day: number; p_plan: string; p_user: string };
        Returns: undefined;
      };
    };
    Enums: {
      [_ in never]: never;
    };
    CompositeTypes: {
      [_ in never]: never;
    };
  };
};

type DatabaseWithoutInternals = Omit<Database, '__InternalSupabase'>;

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, 'public'>];

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema['Tables'] & DefaultSchema['Views'])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Tables'] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Views'])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Tables'] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Views'])[TableName] extends {
      Row: infer R;
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema['Tables'] & DefaultSchema['Views'])
    ? (DefaultSchema['Tables'] & DefaultSchema['Views'])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R;
      }
      ? R
      : never
    : never;

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema['Tables']
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Tables']
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Tables'][TableName] extends {
      Insert: infer I;
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema['Tables']
    ? DefaultSchema['Tables'][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I;
      }
      ? I
      : never
    : never;

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema['Tables']
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Tables']
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions['schema']]['Tables'][TableName] extends {
      Update: infer U;
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema['Tables']
    ? DefaultSchema['Tables'][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U;
      }
      ? U
      : never
    : never;

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema['Enums']
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions['schema']]['Enums']
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions['schema']]['Enums'][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema['Enums']
    ? DefaultSchema['Enums'][DefaultSchemaEnumNameOrOptions]
    : never;

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema['CompositeTypes']
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals;
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions['schema']]['CompositeTypes']
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals;
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions['schema']]['CompositeTypes'][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema['CompositeTypes']
    ? DefaultSchema['CompositeTypes'][PublicCompositeTypeNameOrOptions]
    : never;

export const Constants = {
  public: {
    Enums: {},
  },
} as const;
