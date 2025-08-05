-- EN BASİT ÇÖZÜM: RLS'yi tamamen devre dışı bırak (SADECE TEST İÇİN)
-- Bu SQL komutlarını Supabase Dashboard > SQL Editor'da çalıştırın

-- Tüm politikaları temizle
DROP POLICY IF EXISTS "Users can insert their own profile" ON app_user;
DROP POLICY IF EXISTS "Users can read all profiles" ON app_user;
DROP POLICY IF EXISTS "Users can update their own profile" ON app_user;
DROP POLICY IF EXISTS "Anyone can read profiles" ON app_user;
DROP POLICY IF EXISTS "Authenticated users can create profiles" ON app_user;
DROP POLICY IF EXISTS "Users can update own profiles" ON app_user;
DROP POLICY IF EXISTS "Full access for everyone" ON app_user;
DROP POLICY IF EXISTS "Everyone can read content" ON content;
DROP POLICY IF EXISTS "Authenticated users can manage content" ON content;
DROP POLICY IF EXISTS "Full access to content" ON content;

-- RLS'yi tamamen kapat (TEST İÇİN)
ALTER TABLE app_user DISABLE ROW LEVEL SECURITY;
ALTER TABLE content DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_content_log DISABLE ROW LEVEL SECURITY;
ALTER TABLE review DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_follow DISABLE ROW LEVEL SECURITY;
ALTER TABLE content_type_lookup DISABLE ROW LEVEL SECURITY;
ALTER TABLE content_status_lookup DISABLE ROW LEVEL SECURITY;
