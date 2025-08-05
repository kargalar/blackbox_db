-- SQL Functions for BlackBox App Supabase Backend

-- Function to get user info with statistics
CREATE OR REPLACE FUNCTION get_user_info_with_stats(
    user_uuid UUID,
    profile_user_uuid UUID
)
RETURNS TABLE (
    auth_user_id UUID,
    picture_path TEXT,
    username VARCHAR,
    bio TEXT,
    email VARCHAR,
    created_at TIMESTAMPTZ,
    is_followed BOOLEAN,
    total_watched_movies BIGINT,
    total_watch_time BIGINT,
    total_played_games BIGINT,
    total_game_time BIGINT
) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    WITH user_stats AS (
        SELECT 
            COUNT(CASE WHEN c.content_type_id = 1 THEN 1 END) as total_watched_movies,
            COALESCE(SUM(CASE WHEN c.content_type_id = 1 THEN c.length ELSE 0 END), 0) as total_watch_time,
            COUNT(CASE WHEN c.content_type_id = 2 THEN 1 END) as total_played_games,
            COALESCE(SUM(CASE WHEN c.content_type_id = 2 THEN c.length ELSE 0 END), 0) as total_game_time
        FROM user_content_log ucl
        JOIN content c ON ucl.content_id = c.id
        WHERE ucl.user_id = profile_user_uuid
    ),
    follow_status AS (
        SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END as is_followed
        FROM user_follow uf
        WHERE uf.user_id = user_uuid AND uf.following_user_id = profile_user_uuid
    )
    SELECT
        u.auth_user_id,
        u.picture_path,
        u.username,
        u.bio,
        u.email,
        u.created_at,
        fs.is_followed,
        us.total_watched_movies,
        us.total_watch_time,
        us.total_played_games,
        us.total_game_time
    FROM app_user u
    LEFT JOIN user_stats us ON true
    LEFT JOIN follow_status fs ON true
    WHERE u.auth_user_id = profile_user_uuid;
END;
$$;

-- Function to get content detail with user interactions
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
        'content_id', c.id,
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

-- Function to search content with pagination
CREATE OR REPLACE FUNCTION search_content(
    search_query TEXT,
    content_type_param INTEGER,
    page_param INTEGER,
    limit_param INTEGER DEFAULT 20
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
    offset_param INTEGER;
    total_count INTEGER;
    total_pages INTEGER;
    contents JSON;
BEGIN
    offset_param := (page_param - 1) * limit_param;
    
    -- Get total count
    SELECT COUNT(*) INTO total_count
    FROM content
    WHERE content_type_id = content_type_param
    AND (title ILIKE '%' || search_query || '%' OR description ILIKE '%' || search_query || '%');
    
    total_pages := CEIL(total_count::DECIMAL / limit_param);
    
    -- Get contents
    SELECT json_agg(
        json_build_object(
            'content_id', c.id,
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
            'created_at', c.created_at
        )
    ) INTO contents
    FROM content c
    WHERE c.content_type_id = content_type_param
    AND (c.title ILIKE '%' || search_query || '%' OR c.description ILIKE '%' || search_query || '%')
    ORDER BY c.created_at DESC
    LIMIT limit_param OFFSET offset_param;
    
    RETURN json_build_object(
        'contents', COALESCE(contents, '[]'::json),
        'total_pages', total_pages,
        'current_page', page_param,
        'total_count', total_count
    );
END;
$$;

-- Function to get trending content (DÜZELTME)
CREATE OR REPLACE FUNCTION get_trend_contents(
    content_type_param INTEGER,
    user_id_param UUID
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
    result JSON;
BEGIN
    WITH trending_data AS (
        SELECT 
            user_id_param as user_id,
            c.id as content_id,
            c.poster_path,
            c.content_type_id,
            ucl.content_status_id,
            COALESCE(ucl.is_favorite, false) as is_favorite,
            COALESCE(ucl.is_consume_later, false) as is_consume_later,
            ucl.rating,
            c.consume_count,
            c.favorite_count
        FROM content c
        LEFT JOIN latest_user_content_log ucl ON c.id = ucl.content_id AND ucl.user_id = user_id_param
        WHERE c.content_type_id = content_type_param
        ORDER BY c.consume_count DESC, c.favorite_count DESC
        LIMIT 20
    )
    SELECT COALESCE(json_agg(
        json_build_object(
            'user_id', td.user_id,
            'content_id', td.content_id,
            'poster_path', td.poster_path,
            'content_type_id', td.content_type_id,
            'content_status_id', td.content_status_id,
            'is_favorite', td.is_favorite,
            'is_consume_later', td.is_consume_later,
            'rating', td.rating,
            'userLog', NULL
        )
    ), '[]'::json) INTO result
    FROM trending_data td;
    
    RETURN result;
END;
$$;

-- Function to get recommended content
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

-- Function to get friend activities (DÜZELTME)
CREATE OR REPLACE FUNCTION get_friend_activities(
    content_type_param INTEGER,
    user_id_param UUID
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
    result JSON;
BEGIN
    WITH friend_activity_data AS (
        SELECT 
            ucl.user_id,
            c.id as content_id,
            c.poster_path,
            c.content_type_id,
            my_ucl.content_status_id,
            COALESCE(my_ucl.is_favorite, false) as is_favorite,
            COALESCE(my_ucl.is_consume_later, false) as is_consume_later,
            my_ucl.rating,
            ucl.id as ucl_id,
            u.picture_path,
            ucl.content_id as ucl_content_id,
            ucl.date,
            ucl.content_status_id as ucl_content_status_id,
            ucl.is_favorite as ucl_is_favorite,
            ucl.is_consume_later as ucl_is_consume_later,
            ucl.rating as ucl_rating,
            r.text as review_text
        FROM user_content_log ucl
        INNER JOIN content c ON c.id = ucl.content_id
        INNER JOIN app_user u ON u.auth_user_id = ucl.user_id
        LEFT JOIN review r ON r.id = ucl.review_id
        LEFT JOIN latest_user_content_log my_ucl ON my_ucl.content_id = ucl.content_id AND my_ucl.user_id = user_id_param
        WHERE ucl.user_id IN (
            SELECT following_user_id 
            FROM user_follow 
            WHERE user_id = user_id_param
        )
        AND c.content_type_id = content_type_param
        ORDER BY ucl.date DESC
        LIMIT 20
    )
    SELECT COALESCE(json_agg(
        json_build_object(
            'user_id', fad.user_id,
            'content_id', fad.content_id,
            'poster_path', fad.poster_path,
            'content_type_id', fad.content_type_id,
            'content_status_id', fad.content_status_id,
            'is_favorite', fad.is_favorite,
            'is_consume_later', fad.is_consume_later,
            'rating', fad.rating,
            'userLog', json_build_object(
                'id', fad.ucl_id,
                'picture_path', fad.picture_path,
                'content_id', fad.ucl_content_id,
                'content_type_id', fad.content_type_id,
                'user_id', fad.user_id,
                'date', fad.date,
                'content_status_id', fad.ucl_content_status_id,
                'is_favorite', fad.ucl_is_favorite,
                'is_consume_later', fad.ucl_is_consume_later,
                'rating', fad.ucl_rating,
                'review_text', fad.review_text
            )
        )
    ), '[]'::json) INTO result
    FROM friend_activity_data fad;
    
    RETURN result;
END;
$$;

-- Function to get user contents with pagination
CREATE OR REPLACE FUNCTION get_user_contents(
    user_id_param UUID,
    log_user_id_param UUID,
    content_type_param INTEGER,
    page_param INTEGER,
    limit_param INTEGER DEFAULT 20
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
    offset_param INTEGER;
    total_count INTEGER;
    total_pages INTEGER;
    contents JSON;
BEGIN
    offset_param := (page_param - 1) * limit_param;
    
    -- Get total count
    SELECT COUNT(*) INTO total_count
    FROM user_content_log ucl_log
    INNER JOIN content ON content.id = ucl_log.content_id
    WHERE ucl_log.user_id = log_user_id_param
    AND content.content_type_id = content_type_param;
    
    total_pages := CEIL(total_count::DECIMAL / limit_param);
    
    -- Get contents
    SELECT json_agg(
        json_build_object(
            'user_id', user_id_param,
            'content_id', content.id,
            'poster_path', content.poster_path,
            'content_type_id', content.content_type_id,
            'content_status_id', COALESCE(ucl_user.content_status_id, ucl_log.content_status_id),
            'is_favorite', COALESCE(ucl_user.is_favorite, false),
            'is_consume_later', COALESCE(ucl_user.is_consume_later, false),
            'rating', ucl_user.rating,
            'userLog', json_build_object(
                'id', ucl_log.id,
                'picture_path', app_user.picture_path,
                'content_id', ucl_log.content_id,
                'content_type_id', content.content_type_id,
                'user_id', ucl_log.user_id,
                'date', ucl_log.date,
                'content_status_id', ucl_log.content_status_id,
                'is_favorite', ucl_log.is_favorite,
                'is_consume_later', ucl_log.is_consume_later,
                'rating', ucl_log.rating,
                'review_text', r.text
            )
        )
    ) INTO contents
    FROM user_content_log ucl_log
    INNER JOIN content ON content.id = ucl_log.content_id
    INNER JOIN app_user ON app_user.auth_user_id = ucl_log.user_id
    LEFT JOIN review r ON r.id = ucl_log.review_id
    LEFT JOIN user_content_log ucl_user ON ucl_user.content_id = ucl_log.content_id AND ucl_user.user_id = user_id_param
    WHERE ucl_log.user_id = log_user_id_param
    AND content.content_type_id = content_type_param
    ORDER BY ucl_log.date DESC
    LIMIT limit_param OFFSET offset_param;
    
    RETURN json_build_object(
        'contents', COALESCE(contents, '[]'::json),
        'total_pages', total_pages,
        'current_page', page_param,
        'total_count', total_count
    );
END;
$$;

-- Function to get top reviews (DÜZELTME)
CREATE OR REPLACE FUNCTION get_top_reviews(
    content_type_param INTEGER DEFAULT NULL,
    limit_param INTEGER DEFAULT 5
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
    result JSON;
BEGIN
    WITH review_data AS (
        SELECT 
            r.id,
            r.text,
            r.created_at,
            c.id as content_id,
            c.content_type_id,
            c.title,
            c.poster_path,
            u.auth_user_id as user_id,
            u.username,
            u.picture_path
        FROM review r
        INNER JOIN content c ON c.id = r.content_id
        INNER JOIN app_user u ON u.auth_user_id = r.user_id
        WHERE (content_type_param IS NULL OR c.content_type_id = content_type_param)
        ORDER BY r.created_at DESC
        LIMIT limit_param
    )
    SELECT COALESCE(json_agg(
        json_build_object(
            'id', rd.id,
            'text', rd.text,
            'created_at', rd.created_at,
            'content_id', rd.content_id,
            'content_type_id', rd.content_type_id,
            'title', rd.title,
            'poster_path', rd.poster_path,
            'user_id', rd.user_id,
            'username', rd.username,
            'picture_path', rd.picture_path
        )
    ), '[]'::json) INTO result
    FROM review_data rd;
    
    RETURN result;
END;
$$;

-- Function to get top actors by movie count
CREATE OR REPLACE FUNCTION get_top_actors_by_movie_count(
    page_param INTEGER,
    limit_param INTEGER,
    interval_param TEXT
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
    offset_param INTEGER;
    actors JSON;
BEGIN
    offset_param := (page_param - 1) * limit_param;
    
    SELECT json_agg(
        json_build_object(
            'name', mc.name,
            'profile_path', mc.profile_path,
            'movie_count', COUNT(xmc.movie_id)
        )
    ) INTO actors
    FROM m_cast mc
    INNER JOIN x_movie_cast xmc ON mc.id = xmc.cast_id
    INNER JOIN content c ON c.id = xmc.movie_id
    WHERE c.created_at >= NOW() - INTERVAL '1' || ' ' || interval_param
    GROUP BY mc.id, mc.name, mc.profile_path
    ORDER BY COUNT(xmc.movie_id) DESC
    LIMIT limit_param OFFSET offset_param;
    
    RETURN COALESCE(actors, '[]'::json);
END;
$$;

-- Function to get most watched movies
CREATE OR REPLACE FUNCTION get_most_watched_movies(
    page_param INTEGER,
    limit_param INTEGER,
    interval_param TEXT
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
    offset_param INTEGER;
    movies JSON;
BEGIN
    offset_param := (page_param - 1) * limit_param;
    
    SELECT json_agg(
        json_build_object(
            'content_id', c.id,
            'title', c.title,
            'poster_path', c.poster_path,
            'watch_count', c.consume_count
        )
    ) INTO movies
    FROM content c
    WHERE c.content_type_id = 1
    AND c.created_at >= NOW() - INTERVAL '1' || ' ' || interval_param
    ORDER BY c.consume_count DESC
    LIMIT limit_param OFFSET offset_param;
    
    RETURN COALESCE(movies, '[]'::json);
END;
$$;
