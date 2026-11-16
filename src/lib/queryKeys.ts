export const planDetailKey = (planId: string, userId?: string) =>
  ['plan', planId, userId || 'guest'] as const;

export const groupProgressKey = (groupId: string) => ['users_plans_progresses', groupId] as const;

export const groupProgressMembersKey = (
  groupId: string,
  userId: string | undefined,
  members: string[],
) => [...groupProgressKey(groupId), userId || 'guest', [...new Set(members)].sort()] as const;
