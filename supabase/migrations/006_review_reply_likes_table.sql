-- Create review_reply_likes table for tracking reply likes
CREATE TABLE review_reply_likes (
    id BIGSERIAL PRIMARY KEY,
    reply_id BIGINT NOT NULL REFERENCES review_replies(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES app_user(auth_user_id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    
    -- Ensure a user can only like a reply once
    UNIQUE(reply_id, user_id)
);

-- Create indexes for better performance
CREATE INDEX idx_review_reply_likes_reply_id ON review_reply_likes(reply_id);
CREATE INDEX idx_review_reply_likes_user_id ON review_reply_likes(user_id);
CREATE INDEX idx_review_reply_likes_created_at ON review_reply_likes(created_at);

-- Disable RLS for development
ALTER TABLE review_reply_likes DISABLE ROW LEVEL SECURITY;

-- Add some comments for documentation
COMMENT ON TABLE review_reply_likes IS 'Tracks which users have liked which review replies';
COMMENT ON COLUMN review_reply_likes.reply_id IS 'Reference to the review reply being liked';
COMMENT ON COLUMN review_reply_likes.user_id IS 'Reference to the user who liked the reply';
