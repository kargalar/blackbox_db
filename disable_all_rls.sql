-- TÜM TABLOLAR İÇİN RLS'Yİ KALDIRMA
-- Bu SQL komutlarını Supabase Dashboard > SQL Editor'da çalıştırın
-- UYARI: Bu üretim ortamı için güvenli değildir, sadece geliştirme/test için

-- Önce tüm mevcut politikaları temizle
DO $$
DECLARE
    rec RECORD;
BEGIN
    -- Tüm RLS politikalarını sil
    FOR rec IN 
        SELECT schemaname, tablename, policyname 
        FROM pg_policies 
        WHERE schemaname = 'public'
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I', rec.policyname, rec.schemaname, rec.tablename);
    END LOOP;
END $$;

-- Ana tablolar için RLS'yi kapat
ALTER TABLE IF EXISTS app_user DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS content DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS user_content_log DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS review DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS user_follow DISABLE ROW LEVEL SECURITY;

-- Lookup tabloları
ALTER TABLE IF EXISTS content_type_lookup DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS content_status_lookup DISABLE ROW LEVEL SECURITY;

-- Film/dizi tabloları
ALTER TABLE IF EXISTS m_cast DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS m_crew DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS m_genre DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS m_keyword DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS m_production_company DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS m_production_country DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS m_spoken_language DISABLE ROW LEVEL SECURITY;

-- Oyun tabloları (eğer varsa)
ALTER TABLE IF EXISTS g_genre DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS g_platform DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS g_company DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS g_theme DISABLE ROW LEVEL SECURITY;

-- Diğer olası tablolar
ALTER TABLE IF EXISTS user_notification DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS content_recommendation DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS user_activity DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS content_statistics DISABLE ROW LEVEL SECURITY;

-- Tüm public şemasındaki tabloları kontrol et ve RLS'yi kapat
DO $$
DECLARE
    table_record RECORD;
BEGIN
    FOR table_record IN 
        SELECT tablename 
        FROM pg_tables 
        WHERE schemaname = 'public'
    LOOP
        BEGIN
            EXECUTE format('ALTER TABLE %I DISABLE ROW LEVEL SECURITY', table_record.tablename);
            RAISE NOTICE 'RLS disabled for table: %', table_record.tablename;
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Could not disable RLS for table: % (Error: %)', table_record.tablename, SQLERRM;
        END;
    END LOOP;
END $$;

-- Kontrol: Hangi tablolarda RLS etkin olduğunu görüntüle
SELECT 
    schemaname,
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables 
WHERE schemaname = 'public' 
AND rowsecurity = true
ORDER BY tablename;
