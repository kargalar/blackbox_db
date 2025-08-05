-- BlackBox App Initial Schema for Supabase
-- Based on your existing PostgreSQL database schema

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Drop existing enum types if they exist (to avoid conflicts)
DROP TYPE IF EXISTS content_type_enum CASCADE;
DROP TYPE IF EXISTS content_status_enum CASCADE;

-- Create enum tables (Supabase alternative to enum types)
CREATE TABLE public.content_type_lookup (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE public.content_status_lookup (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- Create main user table with Supabase auth integration
CREATE TABLE public.app_user (
    auth_user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    picture_path TEXT,
    username VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    bio TEXT,
    personality_analyze TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Content table
CREATE TABLE public.content (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content_type_id INTEGER NOT NULL REFERENCES public.content_type_lookup(id),
    release_date DATE,
    description TEXT,
    length INTEGER, -- in minutes for movies, hours for games
    poster_path TEXT,
    consume_count INTEGER DEFAULT 0,
    favorite_count INTEGER DEFAULT 0,
    list_count INTEGER DEFAULT 0,
    review_count INTEGER DEFAULT 0,
    rating_distribution INTEGER[] DEFAULT ARRAY[0,0,0,0,0], -- [1-star, 2-star, 3-star, 4-star, 5-star]
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Genre tables for movies and games
CREATE TABLE public.m_genre (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE public.g_genre (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Director/Creator tables
CREATE TABLE public.m_director (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    profile_path TEXT
);

CREATE TABLE public.g_director (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    profile_path TEXT
);

-- Cast/Actor tables
CREATE TABLE public.m_cast (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    profile_path TEXT
);

-- Platform tables
CREATE TABLE public.m_platform (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    logo_path TEXT
);

CREATE TABLE public.g_platform (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    logo_path TEXT
);

-- Country and Language tables
CREATE TABLE public.m_country (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE public.m_language (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE public.g_country (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE public.g_language (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Theme tables
CREATE TABLE public.m_theme (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE public.g_theme (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Cross-reference tables for movies
CREATE TABLE public.x_movie_genre (
    id SERIAL PRIMARY KEY,
    movie_id INTEGER NOT NULL REFERENCES public.content(id) ON DELETE CASCADE,
    genre_id INTEGER NOT NULL REFERENCES public.m_genre(id) ON DELETE CASCADE,
    UNIQUE(movie_id, genre_id)
);

CREATE TABLE public.x_movie_director (
    id SERIAL PRIMARY KEY,
    movie_id INTEGER NOT NULL REFERENCES public.content(id) ON DELETE CASCADE,
    director_id INTEGER NOT NULL REFERENCES public.m_director(id) ON DELETE CASCADE,
    UNIQUE(movie_id, director_id)
);

CREATE TABLE public.x_movie_cast (
    id SERIAL PRIMARY KEY,
    movie_id INTEGER NOT NULL REFERENCES public.content(id) ON DELETE CASCADE,
    cast_id INTEGER NOT NULL REFERENCES public.m_cast(id) ON DELETE CASCADE,
    character_name VARCHAR(255),
    UNIQUE(movie_id, cast_id)
);

CREATE TABLE public.x_movie_platform (
    id SERIAL PRIMARY KEY,
    movie_id INTEGER NOT NULL REFERENCES public.content(id) ON DELETE CASCADE,
    platform_id INTEGER NOT NULL REFERENCES public.m_platform(id) ON DELETE CASCADE,
    UNIQUE(movie_id, platform_id)
);

CREATE TABLE public.x_movie_country (
    id SERIAL PRIMARY KEY,
    movie_id INTEGER NOT NULL REFERENCES public.content(id) ON DELETE CASCADE,
    country_id INTEGER NOT NULL REFERENCES public.m_country(id) ON DELETE CASCADE,
    UNIQUE(movie_id, country_id)
);

CREATE TABLE public.x_movie_language (
    id SERIAL PRIMARY KEY,
    movie_id INTEGER NOT NULL REFERENCES public.content(id) ON DELETE CASCADE,
    language_id INTEGER NOT NULL REFERENCES public.m_language(id) ON DELETE CASCADE,
    UNIQUE(movie_id, language_id)
);

CREATE TABLE public.x_movie_theme (
    id SERIAL PRIMARY KEY,
    movie_id INTEGER NOT NULL REFERENCES public.content(id) ON DELETE CASCADE,
    theme_id INTEGER NOT NULL REFERENCES public.m_theme(id) ON DELETE CASCADE,
    UNIQUE(movie_id, theme_id)
);

-- Cross-reference tables for games
CREATE TABLE public.x_game_genre (
    id SERIAL PRIMARY KEY,
    game_id INTEGER NOT NULL REFERENCES public.content(id) ON DELETE CASCADE,
    genre_id INTEGER NOT NULL REFERENCES public.g_genre(id) ON DELETE CASCADE,
    UNIQUE(game_id, genre_id)
);

CREATE TABLE public.x_game_director (
    id SERIAL PRIMARY KEY,
    game_id INTEGER NOT NULL REFERENCES public.content(id) ON DELETE CASCADE,
    director_id INTEGER NOT NULL REFERENCES public.g_director(id) ON DELETE CASCADE,
    UNIQUE(game_id, director_id)
);

CREATE TABLE public.x_game_platform (
    id SERIAL PRIMARY KEY,
    game_id INTEGER NOT NULL REFERENCES public.content(id) ON DELETE CASCADE,
    platform_id INTEGER NOT NULL REFERENCES public.g_platform(id) ON DELETE CASCADE,
    UNIQUE(game_id, platform_id)
);

CREATE TABLE public.x_game_country (
    id SERIAL PRIMARY KEY,
    game_id INTEGER NOT NULL REFERENCES public.content(id) ON DELETE CASCADE,
    country_id INTEGER NOT NULL REFERENCES public.g_country(id) ON DELETE CASCADE,
    UNIQUE(game_id, country_id)
);

CREATE TABLE public.x_game_language (
    id SERIAL PRIMARY KEY,
    game_id INTEGER NOT NULL REFERENCES public.content(id) ON DELETE CASCADE,
    language_id INTEGER NOT NULL REFERENCES public.g_language(id) ON DELETE CASCADE,
    UNIQUE(game_id, language_id)
);

CREATE TABLE public.x_game_theme (
    id SERIAL PRIMARY KEY,
    game_id INTEGER NOT NULL REFERENCES public.content(id) ON DELETE CASCADE,
    theme_id INTEGER NOT NULL REFERENCES public.g_theme(id) ON DELETE CASCADE,
    UNIQUE(game_id, theme_id)
);

-- Review table
CREATE TABLE public.review (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES public.app_user(auth_user_id) ON DELETE CASCADE,
    content_id INTEGER NOT NULL REFERENCES public.content(id) ON DELETE CASCADE,
    text TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User content log (tracks user interactions with content)
CREATE TABLE public.user_content_log (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES public.app_user(auth_user_id) ON DELETE CASCADE,
    content_id INTEGER NOT NULL REFERENCES public.content(id) ON DELETE CASCADE,
    content_status_id INTEGER REFERENCES public.content_status_lookup(id),
    rating DECIMAL(3,2) CHECK (rating >= 0 AND rating <= 5),
    is_favorite BOOLEAN DEFAULT FALSE,
    is_consume_later BOOLEAN DEFAULT FALSE,
    review_id INTEGER REFERENCES public.review(id) ON DELETE SET NULL,
    date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    -- Removed UNIQUE(user_id, content_id) to allow multiple logs per user-content pair
);

-- Review interactions
CREATE TABLE public.review_comment (
    id SERIAL PRIMARY KEY,
    review_id INTEGER NOT NULL REFERENCES public.review(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.app_user(auth_user_id) ON DELETE CASCADE,
    text TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE public.review_like (
    id SERIAL PRIMARY KEY,
    review_id INTEGER NOT NULL REFERENCES public.review(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.app_user(auth_user_id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(review_id, user_id)
);

-- User follow system
CREATE TABLE public.user_follow (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES public.app_user(auth_user_id) ON DELETE CASCADE,
    following_user_id UUID NOT NULL REFERENCES public.app_user(auth_user_id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, following_user_id),
    CHECK (user_id != following_user_id)
);

-- Movie lists (for user-created lists)
CREATE TABLE public.list_movie (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES public.app_user(auth_user_id) ON DELETE CASCADE,
    movie_id INTEGER NOT NULL REFERENCES public.content(id) ON DELETE CASCADE,
    list_name VARCHAR(255) NOT NULL,
    added_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, movie_id, list_name)
);

-- Insert initial enum data
INSERT INTO public.content_type_lookup (id, name) VALUES 
    (1, 'MOVIE'),
    (2, 'GAME'),
    (3, 'BOOK');

INSERT INTO public.content_status_lookup (id, name) VALUES 
    (1, 'CONSUMED'),
    (2, 'CONSUMING'),
    (3, 'UNFINISHED'),
    (4, 'ABANDONED');

-- Create indexes for better performance
CREATE INDEX idx_content_type ON public.content(content_type_id);
CREATE INDEX idx_content_release_date ON public.content(release_date);
CREATE INDEX idx_user_content_log_user ON public.user_content_log(user_id);
CREATE INDEX idx_user_content_log_content ON public.user_content_log(content_id);
CREATE INDEX idx_user_content_log_date ON public.user_content_log(date);
-- Additional indexes for multiple logs support
CREATE INDEX idx_user_content_log_user_content ON public.user_content_log(user_id, content_id);
CREATE INDEX idx_user_content_log_date_desc ON public.user_content_log(user_id, content_id, date DESC);
CREATE INDEX idx_review_content ON public.review(content_id);
CREATE INDEX idx_review_user ON public.review(user_id);
CREATE INDEX idx_user_follow_user ON public.user_follow(user_id);
CREATE INDEX idx_user_follow_following ON public.user_follow(following_user_id);

-- Enable Row Level Security (RLS)
ALTER TABLE public.app_user ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_content_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.review ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.review_comment ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.review_like ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_follow ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.list_movie ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
-- Users can only see and modify their own data
CREATE POLICY "Users can view own profile" ON public.app_user
    FOR SELECT USING (auth.uid() = auth_user_id);

CREATE POLICY "Users can update own profile" ON public.app_user
    FOR UPDATE USING (auth.uid() = auth_user_id);

CREATE POLICY "Users can insert own profile" ON public.app_user
    FOR INSERT WITH CHECK (auth.uid() = auth_user_id);

-- User content logs
CREATE POLICY "Users can view own content logs" ON public.user_content_log
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own content logs" ON public.user_content_log
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own content logs" ON public.user_content_log
    FOR UPDATE USING (auth.uid() = user_id);

-- Reviews
CREATE POLICY "Anyone can view reviews" ON public.review
    FOR SELECT USING (true);

CREATE POLICY "Users can insert own reviews" ON public.review
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own reviews" ON public.review
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own reviews" ON public.review
    FOR DELETE USING (auth.uid() = user_id);

-- Review comments
CREATE POLICY "Anyone can view review comments" ON public.review_comment
    FOR SELECT USING (true);

CREATE POLICY "Users can insert own review comments" ON public.review_comment
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Review likes
CREATE POLICY "Anyone can view review likes" ON public.review_like
    FOR SELECT USING (true);

CREATE POLICY "Users can manage own review likes" ON public.review_like
    FOR ALL USING (auth.uid() = user_id);

-- User follows
CREATE POLICY "Anyone can view follows" ON public.user_follow
    FOR SELECT USING (true);

CREATE POLICY "Users can manage own follows" ON public.user_follow
    FOR ALL USING (auth.uid() = user_id);

-- Movie lists
CREATE POLICY "Users can view own lists" ON public.list_movie
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can manage own lists" ON public.list_movie
    FOR ALL USING (auth.uid() = user_id);

-- Create function to handle user creation after signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.app_user (auth_user_id, email, username)
    VALUES (NEW.id, NEW.email, COALESCE(NEW.raw_user_meta_data->>'username', split_part(NEW.email, '@', 1)));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create user profile when auth user is created
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add updated_at triggers
CREATE TRIGGER update_app_user_updated_at BEFORE UPDATE ON public.app_user
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_content_updated_at BEFORE UPDATE ON public.content
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_review_updated_at BEFORE UPDATE ON public.review
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_user_content_log_updated_at BEFORE UPDATE ON public.user_content_log
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- Create a view to get the latest user content log for each user-content pair
-- This is useful when we need only the most recent interaction
CREATE OR REPLACE VIEW latest_user_content_log AS
SELECT DISTINCT ON (user_id, content_id)
    id,
    user_id,
    content_id,
    content_status_id,
    rating,
    is_favorite,
    is_consume_later,
    review_id,
    date,
    updated_at
FROM user_content_log
ORDER BY user_id, content_id, date DESC;
