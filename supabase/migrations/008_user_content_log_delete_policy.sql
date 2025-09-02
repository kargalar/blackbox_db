-- Allow users to delete their own content logs (RLS policy)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'user_content_log'
      AND policyname = 'Users can delete own content logs'
  ) THEN
    CREATE POLICY "Users can delete own content logs" ON public.user_content_log
      FOR DELETE USING (auth.uid() = user_id);
  END IF;
END
$$;
