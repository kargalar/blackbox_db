-- Basit RLS Politikaları - Type Casting Sorunu Çözümü
-- Bu SQL komutlarını Supabase Dashboard > SQL Editor'da çalıştırın

-- Önce tüm mevcut politikaları temizle
DROP POLICY IF EXISTS "Users can insert their own profile" ON app_user;
DROP POLICY IF EXISTS "Users can read all profiles" ON app_user;
DROP POLICY IF EXISTS "Users can update their own profile" ON app_user;
DROP POLICY IF EXISTS "Anyone can read profiles" ON app_user;
DROP POLICY IF EXISTS "Authenticated users can create profiles" ON app_user;
DROP POLICY IF EXISTS "Users can update own profiles" ON app_user;

-- app_user tablosu için EN BASİT politikalar (type casting yok)
ALTER TABLE app_user ENABLE ROW LEVEL SECURITY;

-- Herkes her şeyi yapabilir (sadece test için)
CREATE POLICY "Full access for everyone" ON app_user FOR ALL USING (true) WITH CHECK (true);

-- Diğer tablolar için de tam erişim (sadece test için)
ALTER TABLE content ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Full access to content" ON content FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE user_content_log ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Full access to logs" ON user_content_log FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE review ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Full access to reviews" ON review FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE user_follow ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Full access to follows" ON user_follow FOR ALL USING (true) WITH CHECK (true);

-- Lookup tabloları
ALTER TABLE content_type_lookup ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Full access to content types" ON content_type_lookup FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE content_status_lookup ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Full access to content statuses" ON content_status_lookup FOR ALL USING (true) WITH CHECK (true);

-- Eğer hala sorun yaşıyorsanız, test için RLS'yi tamamen kapatabilirsiniz:
-- ALTER TABLE app_user DISABLE ROW LEVEL SECURITY;
-- ALTER TABLE content DISABLE ROW LEVEL SECURITY;
-- ALTER TABLE user_content_log DISABLE ROW LEVEL SECURITY;
-- ALTER TABLE review DISABLE ROW LEVEL SECURITY;
-- ALTER TABLE user_follow DISABLE ROW LEVEL SECURITY;
