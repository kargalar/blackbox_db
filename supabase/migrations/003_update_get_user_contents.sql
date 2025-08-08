-- Migration 003: Update get_user_contents function with SECURITY DEFINER and robust JSON structure
-- Drops previous version and recreates with safer logic

DROP FUNCTION IF EXISTS get_user_contents(UUID, UUID, INTEGER, INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION get_user_contents(
    user_id_param UUID,          -- viewing user (current session user)
    log_user_id_param UUID,      -- whose logs are listed
    content_type_param INTEGER,  -- content type id
    page_param INTEGER,
    limit_param INTEGER DEFAULT 20
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    offset_param INTEGER;
    total_count INTEGER;
    total_pages INTEGER;
    contents JSON;
BEGIN
    IF page_param < 1 THEN
        RAISE EXCEPTION 'page_param must be >= 1';
    END IF;
    IF limit_param < 1 THEN
        RAISE EXCEPTION 'limit_param must be >= 1';
    END IF;

    offset_param := (page_param - 1) * limit_param;

    -- Count total logs for that user & content type
    SELECT COUNT(*) INTO total_count
    FROM user_content_log ucl_log
    INNER JOIN content ON content.id = ucl_log.content_id
    WHERE ucl_log.user_id = log_user_id_param
      AND content.content_type_id = content_type_param;

    total_pages := CASE WHEN total_count = 0 THEN 0 ELSE CEIL(total_count::DECIMAL / limit_param) END;

    -- Collect page data
    SELECT json_agg(
        json_build_object(
            'content_id', content.id,
            'content_type_id', content.content_type_id,
            'poster_path', content.poster_path,
            'title', content.title,
            'userLog', json_build_object(
                'user_id', ucl_log.user_id,
                'content_id', ucl_log.content_id,
                'date', ucl_log.date,
                'content_status_id', ucl_log.content_status_id,
                'is_favorite', ucl_log.is_favorite,
                'is_consume_later', ucl_log.is_consume_later,
                'rating', ucl_log.rating,
                'review_id', ucl_log.review_id
            ),
            'viewerInteraction', json_build_object(
                'content_status_id', ucl_viewer.content_status_id,
                'is_favorite', COALESCE(ucl_viewer.is_favorite, false),
                'is_consume_later', COALESCE(ucl_viewer.is_consume_later, false),
                'rating', ucl_viewer.rating
            )
        )
    ) INTO contents
    FROM user_content_log ucl_log
    INNER JOIN content ON content.id = ucl_log.content_id
    LEFT JOIN user_content_log ucl_viewer ON ucl_viewer.content_id = ucl_log.content_id AND ucl_viewer.user_id = user_id_param
    WHERE ucl_log.user_id = log_user_id_param
      AND content.content_type_id = content_type_param
    ORDER BY ucl_log.date DESC NULLS LAST
    LIMIT limit_param OFFSET offset_param;

    RETURN json_build_object(
        'contents', COALESCE(contents, '[]'::json),
        'total_pages', total_pages,
        'current_page', page_param,
        'total_count', total_count,
        'limit', limit_param
    );
END;
$$;

-- (Optional) Policy suggestion if broader SELECT needed (commented out)
-- CREATE POLICY "View followed logs" ON public.user_content_log
--     FOR SELECT USING (
--         user_id = auth.uid() OR user_id IN (
--             SELECT following_user_id FROM user_follow WHERE user_follow.user_id = auth.uid()
--         )
--     );
