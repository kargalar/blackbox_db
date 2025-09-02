-- Create review_likes table for handling likes on reviews
CREATE TABLE IF NOT EXISTS review_likes (
    id SERIAL PRIMARY KEY,
    review_id INTEGER NOT NULL REFERENCES review(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES app_user(auth_user_id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Ensure a user can only like a review once
    UNIQUE(review_id, user_id)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_review_likes_review_id ON review_likes(review_id);
CREATE INDEX IF NOT EXISTS idx_review_likes_user_id ON review_likes(user_id);
CREATE INDEX IF NOT EXISTS idx_review_likes_created_at ON review_likes(created_at);

-- Add RLS (Row Level Security) policies
ALTER TABLE review_likes ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view all likes
CREATE POLICY "Users can view all review likes" ON review_likes
    FOR SELECT USING (true);

-- Policy: Users can insert their own likes
CREATE POLICY "Users can insert their own review likes" ON review_likes
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Policy: Users can delete their own likes
CREATE POLICY "Users can delete their own review likes" ON review_likes
    FOR DELETE USING (auth.uid() = user_id);

-- Grant permissions
GRANT ALL ON review_likes TO authenticated;
GRANT USAGE ON SEQUENCE review_likes_id_seq TO authenticated;
