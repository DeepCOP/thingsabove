create policy "users can delete their own progress"
  on public.plan_progress
  for delete
  using (auth.uid() = user_id);
