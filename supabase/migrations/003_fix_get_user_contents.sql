-- Fix get_user_contents function: remove invalid top-level ORDER BY with aggregate
-- and add SECURITY DEFINER so it can read target user's logs (adjust if undesired).

CREATE OR REPLACE FUNCTION public.get_user_contents(
    user_id_param UUID,
    log_user_id_param UUID,
    content_type_param INTEGER,
    page_param INTEGER,
    limit_param INTEGER DEFAULT 20
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    offset_param INTEGER;
    total_count INTEGER;
    total_pages INTEGER;
    contents JSON;
BEGIN
    offset_param := (page_param - 1) * limit_param;

    -- Total count of logs for the target user & content type
    SELECT COUNT(*) INTO total_count
    FROM user_content_log ucl_log
    JOIN content c ON c.id = ucl_log.content_id
    WHERE ucl_log.user_id = log_user_id_param
      AND c.content_type_id = content_type_param;

    total_pages := CEIL(GREATEST(total_count,0)::DECIMAL / NULLIF(limit_param,0));

    -- Build rows first (ordered + paginated), then aggregate to avoid ORDER BY + aggregate error
    WITH rows AS (
        SELECT 
            ucl_log.id AS log_id,
            ucl_log.user_id AS log_user_id,
            ucl_log.content_id,
            ucl_log.content_status_id AS log_content_status_id,
            ucl_log.is_favorite AS log_is_favorite,
            ucl_log.is_consume_later AS log_is_consume_later,
            ucl_log.rating AS log_rating,
            ucl_log.date AS log_date,
            r.text AS review_text,
            c.id AS c_id,
            c.poster_path,
            c.content_type_id,
            au.picture_path,
            ucl_user.content_status_id AS viewer_content_status_id,
            ucl_user.is_favorite AS viewer_is_favorite,
            ucl_user.is_consume_later AS viewer_is_consume_later,
            ucl_user.rating AS viewer_rating
        FROM user_content_log ucl_log
        JOIN content c ON c.id = ucl_log.content_id
        JOIN app_user au ON au.auth_user_id = ucl_log.user_id
        LEFT JOIN review r ON r.id = ucl_log.review_id
        LEFT JOIN user_content_log ucl_user ON ucl_user.content_id = ucl_log.content_id AND ucl_user.user_id = user_id_param
        WHERE ucl_log.user_id = log_user_id_param
          AND c.content_type_id = content_type_param
        ORDER BY ucl_log.date DESC
        LIMIT limit_param OFFSET offset_param
    )
    SELECT json_agg(
        json_build_object(
            'user_id', user_id_param,
            'content_id', c_id,
            'poster_path', poster_path,
            'content_type_id', content_type_id,
            'content_status_id', COALESCE(viewer_content_status_id, log_content_status_id),
            'is_favorite', COALESCE(viewer_is_favorite, false),
            'is_consume_later', COALESCE(viewer_is_consume_later, false),
            'rating', viewer_rating,
            'userLog', json_build_object(
                'id', log_id,
                'picture_path', picture_path,
                'content_id', content_id,
                'content_type_id', content_type_id,
                'user_id', log_user_id,
                'date', log_date,
                'content_status_id', log_content_status_id,
                'is_favorite', log_is_favorite,
                'is_consume_later', log_is_consume_later,
                'rating', log_rating,
                'review_text', review_text
            )
        )
    ) INTO contents
    FROM rows;

    RETURN json_build_object(
        'contents', COALESCE(contents, '[]'::json),
        'total_pages', COALESCE(total_pages,1),
        'current_page', page_param,
        'total_count', total_count
    );
END;
$$;

-- Optional: grant execute to authenticated users
GRANT EXECUTE ON FUNCTION public.get_user_contents(UUID,UUID,INTEGER,INTEGER,INTEGER) TO authenticated;
