-- Supabase RLS Policies Setup
-- Bu SQL komutlarını Supabase Dashboard > SQL Editor'da çalıştırın

-- 1. app_user tablosu için RLS politikalarını oluştur
DROP POLICY IF EXISTS "Users can insert their own profile" ON app_user;
DROP POLICY IF EXISTS "Users can read all profiles" ON app_user;
DROP POLICY IF EXISTS "Users can update their own profile" ON app_user;

-- RLS'yi etkinleştir
ALTER TABLE app_user ENABLE ROW LEVEL SECURITY;

-- Kullanıcı kayıt politikası - kullanıcılar kendi profillerini oluşturabilir
CREATE POLICY "Users can insert their own profile" ON app_user
FOR INSERT WITH CHECK (auth.uid()::text = auth_user_id::text);

-- Okuma politikası - tüm profiller okunabilir
CREATE POLICY "Users can read all profiles" ON app_user
FOR SELECT USING (true);

-- Güncelleme politikası - kullanıcılar sadece kendi profillerini güncelleyebilir
CREATE POLICY "Users can update their own profile" ON app_user
FOR UPDATE USING (auth.uid()::text = auth_user_id::text);

-- 2. Diğer tablolar için temel RLS politikaları

-- content tablosu
ALTER TABLE content ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Everyone can read content" ON content FOR SELECT USING (true);
CREATE POLICY "Authenticated users can insert content" ON content FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- user_content_log tablosu
ALTER TABLE user_content_log ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage their own logs" ON user_content_log
FOR ALL USING (auth.uid()::text = user_id);

-- review tablosu  
ALTER TABLE review ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Everyone can read reviews" ON review FOR SELECT USING (true);
CREATE POLICY "Users can insert their own reviews" ON review 
FOR INSERT WITH CHECK (auth.uid()::text = user_id);
CREATE POLICY "Users can update their own reviews" ON review
FOR UPDATE USING (auth.uid()::text = user_id);

-- user_follow tablosu
ALTER TABLE user_follow ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage their own follows" ON user_follow
FOR ALL USING (auth.uid()::text = user_id OR auth.uid()::text = following_user_id);

-- Lookup tablolarını herkese açık yap
ALTER TABLE content_type_lookup ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Everyone can read content types" ON content_type_lookup FOR SELECT USING (true);

ALTER TABLE content_status_lookup ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Everyone can read content statuses" ON content_status_lookup FOR SELECT USING (true);

-- Helper function for enabling RLS
CREATE OR REPLACE FUNCTION enable_rls_app_user()
RETURNS void AS $$
BEGIN
  -- This function is called from the app to ensure RLS is enabled
  -- No operation needed as policies are already created above
  RETURN;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
