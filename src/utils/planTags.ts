const normalizeTag = (tag: string) => tag.trim().toLowerCase();

export const planMatchesSelectedTags = (
  plan: { tags?: string[] | null },
  selectedTags: string[],
) => {
  if (selectedTags.length === 0) return true;

  const planTags = new Set((plan.tags ?? []).map(normalizeTag).filter(Boolean));

  return selectedTags.some((tag) => planTags.has(normalizeTag(tag)));
};
