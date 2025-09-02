-- Recompute and maintain aggregated content stats (favorites, consumes, reviews, rating distribution)
CREATE OR REPLACE FUNCTION public.recompute_content_stats(
    content_id_param INTEGER
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_fav_count INTEGER := 0;
    v_consume_count INTEGER := 0;
    v_review_count INTEGER := 0;
    v_rating_dist INTEGER[] := ARRAY[0,0,0,0,0];
    v_content_type_id INTEGER;
BEGIN
    -- Determine content type
    SELECT content_type_id INTO v_content_type_id FROM public.content WHERE id = content_id_param;

    -- Favorite count (based on latest logs per user)
    SELECT COUNT(*) INTO v_fav_count
    FROM public.latest_user_content_log ucl
    WHERE ucl.content_id = content_id_param AND COALESCE(ucl.is_favorite, false) = true;

    -- Consume (watched) count (latest logs)
    SELECT COUNT(*) INTO v_consume_count
    FROM public.latest_user_content_log ucl
    WHERE ucl.content_id = content_id_param AND ucl.content_status_id = 1; -- 1 = CONSUMED

    -- Review count
    SELECT COUNT(*) INTO v_review_count
    FROM public.review r
    WHERE r.content_id = content_id_param;

    -- Rating distribution (round to nearest star 1..5 based on latest logs)
    WITH ratings AS (
        SELECT ROUND(ucl.rating)::INT AS star
        FROM public.latest_user_content_log ucl
        WHERE ucl.content_id = content_id_param AND ucl.rating IS NOT NULL
    )
    SELECT ARRAY[
        COALESCE(SUM(CASE WHEN star = 1 THEN 1 ELSE 0 END),0),
        COALESCE(SUM(CASE WHEN star = 2 THEN 1 ELSE 0 END),0),
        COALESCE(SUM(CASE WHEN star = 3 THEN 1 ELSE 0 END),0),
        COALESCE(SUM(CASE WHEN star = 4 THEN 1 ELSE 0 END),0),
        COALESCE(SUM(CASE WHEN star = 5 THEN 1 ELSE 0 END),0)
    ] INTO v_rating_dist FROM ratings;

    -- Update content table
    UPDATE public.content
    SET favorite_count = COALESCE(v_fav_count, 0),
        consume_count = COALESCE(v_consume_count, 0),
        review_count = COALESCE(v_review_count, 0),
        rating_distribution = COALESCE(v_rating_dist, ARRAY[0,0,0,0,0])
    WHERE id = content_id_param;
END;
$$;

-- Triggers to keep aggregates fresh
CREATE OR REPLACE FUNCTION public.trg_after_user_content_log_update()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    PERFORM public.recompute_content_stats(NEW.content_id);
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS after_ucl_insert ON public.user_content_log;
CREATE TRIGGER after_ucl_insert
AFTER INSERT ON public.user_content_log
FOR EACH ROW EXECUTE FUNCTION public.trg_after_user_content_log_update();

DROP TRIGGER IF EXISTS after_ucl_update ON public.user_content_log;
CREATE TRIGGER after_ucl_update
AFTER UPDATE ON public.user_content_log
FOR EACH ROW EXECUTE FUNCTION public.trg_after_user_content_log_update();

-- Also recompute on review insert/delete to keep review_count accurate
CREATE OR REPLACE FUNCTION public.trg_after_review_change()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    PERFORM public.recompute_content_stats(COALESCE(NEW.content_id, OLD.content_id));
    RETURN COALESCE(NEW, OLD);
END;
$$;

DROP TRIGGER IF EXISTS after_review_insert ON public.review;
CREATE TRIGGER after_review_insert
AFTER INSERT ON public.review
FOR EACH ROW EXECUTE FUNCTION public.trg_after_review_change();

DROP TRIGGER IF EXISTS after_review_delete ON public.review;
CREATE TRIGGER after_review_delete
AFTER DELETE ON public.review
FOR EACH ROW EXECUTE FUNCTION public.trg_after_review_change();
