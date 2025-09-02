-- Create review_replies table for nested comments on reviews
CREATE TABLE IF NOT EXISTS review_replies (
    id SERIAL PRIMARY KEY,
    review_id INTEGER NOT NULL REFERENCES review(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES app_user(auth_user_id) ON DELETE CASCADE,
    parent_reply_id INTEGER REFERENCES review_replies(id) ON DELETE CASCADE, -- For nested replies
    text TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_review_replies_review_id ON review_replies(review_id);
CREATE INDEX IF NOT EXISTS idx_review_replies_user_id ON review_replies(user_id);
CREATE INDEX IF NOT EXISTS idx_review_replies_parent_id ON review_replies(parent_reply_id);
CREATE INDEX IF NOT EXISTS idx_review_replies_created_at ON review_replies(created_at);

-- Add RLS (Row Level Security) policies
ALTER TABLE review_replies ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view all replies
CREATE POLICY "Users can view all review replies" ON review_replies
    FOR SELECT USING (true);

-- Policy: Users can insert their own replies
CREATE POLICY "Users can insert their own review replies" ON review_replies
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Policy: Users can update their own replies
CREATE POLICY "Users can update their own review replies" ON review_replies
    FOR UPDATE USING (auth.uid() = user_id);

-- Policy: Users can delete their own replies
CREATE POLICY "Users can delete their own review replies" ON review_replies
    FOR DELETE USING (auth.uid() = user_id);

-- Grant permissions
GRANT ALL ON review_replies TO authenticated;
GRANT USAGE ON SEQUENCE review_replies_id_seq TO authenticated;

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_review_replies_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update updated_at
CREATE TRIGGER update_review_replies_updated_at
    BEFORE UPDATE ON review_replies
    FOR EACH ROW
    EXECUTE FUNCTION update_review_replies_updated_at();
