-- Remove unique constraint from user_content_log to allow multiple logs per user-content pair
-- This allows users to change their rating, status, etc. multiple times

-- Drop the existing unique constraint
ALTER TABLE public.user_content_log 
DROP CONSTRAINT IF EXISTS user_content_log_user_id_content_id_key;

-- Add index for better performance (without uniqueness)
CREATE INDEX IF NOT EXISTS idx_user_content_log_user_content 
ON public.user_content_log(user_id, content_id);

-- Add index for date-based queries (most recent log)
CREATE INDEX IF NOT EXISTS idx_user_content_log_date_desc 
ON public.user_content_log(user_id, content_id, date DESC);

-- Create a view to get the latest user content log for each user-content pair
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

-- Update get_content_detail function to use latest log only
CREATE OR REPLACE FUNCTION get_content_detail(
    content_id_param INTEGER,
    content_type_param INTEGER,
    user_id_param UUID
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_build_object(
        'id', c.id,
        'title', c.title,
        'content_type_id', c.content_type_id,
        'release_date', c.release_date,
        'description', c.description,
        'length', c.length,
        'poster_path', c.poster_path,
        'consume_count', c.consume_count,
        'favorite_count', c.favorite_count,
        'list_count', c.list_count,
        'review_count', c.review_count,
        'rating_distribution', c.rating_distribution,
        'created_at', c.created_at,
        'content_status_id', ucl.content_status_id,
        'rating', ucl.rating,
        'is_favorite', COALESCE(ucl.is_favorite, false),
        'is_consume_later', COALESCE(ucl.is_consume_later, false),
        'genre_list', COALESCE(genre_array.genres, '[]'::json),
        'creator_list', COALESCE(creator_array.creators, '[]'::json),
        'cast_list', COALESCE(cast_array.cast, '[]'::json)
    ) INTO result
    FROM content c
    LEFT JOIN latest_user_content_log ucl ON c.id = ucl.content_id AND ucl.user_id = user_id_param
    LEFT JOIN LATERAL (
        SELECT json_agg(json_build_object('id', g.id, 'name', g.name)) as genres
        FROM (
            SELECT DISTINCT ON (mg.id) mg.id, mg.name
            FROM x_movie_genre xmg
            JOIN m_genre mg ON xmg.genre_id = mg.id
            WHERE xmg.movie_id = c.id AND c.content_type_id = 1
            UNION ALL
            SELECT DISTINCT ON (gg.id) gg.id, gg.name
            FROM x_game_genre xgg
            JOIN g_genre gg ON xgg.genre_id = gg.id
            WHERE xgg.game_id = c.id AND c.content_type_id = 2
        ) g
    ) genre_array ON true
    LEFT JOIN LATERAL (
        SELECT json_agg(json_build_object('id', d.id, 'name', d.name, 'profile_path', d.profile_path)) as creators
        FROM (
            SELECT DISTINCT ON (md.id) md.id, md.name, md.profile_path
            FROM x_movie_director xmd
            JOIN m_director md ON xmd.director_id = md.id
            WHERE xmd.movie_id = c.id AND c.content_type_id = 1
            UNION ALL
            SELECT DISTINCT ON (gd.id) gd.id, gd.name, gd.profile_path
            FROM x_game_director xgd
            JOIN g_director gd ON xgd.director_id = gd.id
            WHERE xgd.game_id = c.id AND c.content_type_id = 2
        ) d
    ) creator_array ON true
    LEFT JOIN LATERAL (
        SELECT json_agg(json_build_object('id', mc.id, 'name', mc.name, 'profile_path', mc.profile_path, 'character_name', xmc.character_name)) as cast
        FROM x_movie_cast xmc
        JOIN m_cast mc ON xmc.cast_id = mc.id
        WHERE xmc.movie_id = c.id AND c.content_type_id = 1
    ) cast_array ON true
    WHERE c.id = content_id_param AND c.content_type_id = content_type_param;
    
    RETURN result;
END;
$$;

-- Update other functions that need latest user logs

-- Update get_trend_contents function  
CREATE OR REPLACE FUNCTION get_trend_contents(
    content_type_param INTEGER,
    user_id_param UUID
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
    contents JSON;
BEGIN
    SELECT json_agg(
        json_build_object(
            'user_id', user_id_param,
            'content_id', c.id,
            'poster_path', c.poster_path,
            'content_type_id', c.content_type_id,
            'content_status_id', ucl.content_status_id,
            'is_favorite', COALESCE(ucl.is_favorite, false),
            'is_consume_later', COALESCE(ucl.is_consume_later, false),
            'rating', ucl.rating,
            'userLog', NULL
        )
    ) INTO contents
    FROM content c
    LEFT JOIN latest_user_content_log ucl ON c.id = ucl.content_id AND ucl.user_id = user_id_param
    WHERE c.content_type_id = content_type_param
    ORDER BY c.consume_count DESC, c.favorite_count DESC
    LIMIT 20;
    
    RETURN COALESCE(contents, '[]'::json);
END;
$$;

-- Update get_recommended_contents function
CREATE OR REPLACE FUNCTION get_recommended_contents(
    user_id_param UUID,
    content_type_param INTEGER
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
    contents JSON;
BEGIN
    -- Simple recommendation based on genres of liked content
    SELECT json_agg(
        json_build_object(
            'user_id', user_id_param,
            'content_id', c.id,
            'poster_path', c.poster_path,
            'content_type_id', c.content_type_id,
            'content_status_id', ucl.content_status_id,
            'is_favorite', COALESCE(ucl.is_favorite, false),
            'is_consume_later', COALESCE(ucl.is_consume_later, false),
            'rating', ucl.rating,
            'userLog', NULL
        )
    ) INTO contents
    FROM content c
    LEFT JOIN latest_user_content_log ucl ON c.id = ucl.content_id AND ucl.user_id = user_id_param
    WHERE c.content_type_id = content_type_param
    AND c.id NOT IN (
        SELECT DISTINCT content_id 
        FROM latest_user_content_log 
        WHERE user_id = user_id_param
    )
    ORDER BY c.favorite_count DESC, c.consume_count DESC
    LIMIT 20;
    
    RETURN COALESCE(contents, '[]'::json);
END;
$$;
