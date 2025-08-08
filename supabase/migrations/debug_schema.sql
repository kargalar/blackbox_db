-- Tablo yapısını kontrol etmek için bu sorguları çalıştırın:

-- app_user tablosunun sütun tiplerini kontrol et
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'app_user';

-- Mevcut RLS politikalarını görüntüle
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies 
WHERE tablename = 'app_user';

-- auth.uid() fonksiyonunun dönüş tipini kontrol et
SELECT auth.uid(), pg_typeof(auth.uid());
