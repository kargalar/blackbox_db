# BlackBox App Supabase Migration Guide

Bu rehber, mevcut BlackBox uygulamanızı Supabase ile çalışacak şekilde geçiş yapmanız için hazırlanmıştır.

## 1. Gerekli Bağımlılıklar

`pubspec.yaml` dosyanıza aşağıdaki bağımlılığı ekleyin:

```yaml
dependencies:
  supabase_flutter: ^2.8.0
```

## 2. Supabase Projesini Kurma

1. [Supabase](https://supabase.com) hesabı oluşturun
2. Yeni bir proje oluşturun
3. SQL Editor'de `supabase/migrations/001_initial_schema.sql` dosyasındaki SQL kodlarını çalıştırın
4. Ardından `supabase/migrations/002_functions.sql` dosyasındaki fonksiyonları çalıştırın

## 3. Çevre Değişkenleri (.env)

`.env` dosyanızı `.env.example` dosyasından oluşturun ve gerekli anahtarları doldurun:

```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
TMDB_Authorization=Bearer your_tmdb_api_key
IGDB_Client_id=your_igdb_client_id
IGDB_Authorization=Bearer your_igdb_auth_token
```

## 4. Kod Değişiklikleri

### 4.1 Ana Değişiklikler

1. `ServerManager` yerine `SupabaseService` kullanın
2. `UserModel` yerine `UserModel` (Supabase versiyonu) kullanın
3. `ContentModel` yerine `ContentModel` (Supabase versiyonu) kullanın

### 4.2 Servis Kullanımı

Eski kod:
```dart
final user = await ServerManager().login(email: email, password: password);
```

Yeni kod:
```dart
final user = await SupabaseService().signIn(email: email, password: password);
```

### 4.3 Model Değişiklikleri

- `UserModel.id` artık `String` (UUID)
- `ContentModel.toSupabaseJson()` metodu eklendi
- RLS (Row Level Security) desteği

## 5. Kimlik Doğrulama

Supabase otomatik olarak kimlik doğrulama işlemini yönetir:

```dart
// Giriş yapma
final user = await SupabaseService().signIn(email: email, password: password);

// Kayıt olma
final user = await SupabaseService().signUp(email: email, password: password, username: username);

// Çıkış yapma
await SupabaseService().signOut();
```

## 6. Veritabanı İşlemleri

### 6.1 İçerik İşlemleri

```dart
// İçerik detayı alma
final content = await SupabaseService().getContentDetail(
  contentId: contentId,
  contentType: ContentTypeEnum.MOVIE,
);

// İçerik arama
final searchResult = await SupabaseService().searchContent(
  query: "The Matrix",
  contentType: ContentTypeEnum.MOVIE,
  page: 1,
);
```

### 6.2 Kullanıcı İçerik Etkileşimleri

```dart
// Kullanıcı eylem kaydı
await SupabaseService().contentUserAction(
  contentLogModel: ContentLogModel(
    userID: currentUserId,
    contentID: contentId,
    contentType: ContentTypeEnum.MOVIE,
    rating: 4.5,
    isFavorite: true,
  ),
);
```

## 7. Real-time Özellikler

Supabase real-time veritabanı değişikliklerini dinleme imkanı sunar:

```dart
// Real-time değişiklikleri dinleme
final subscription = SupabaseService().client
    .from('user_content_log')
    .stream(primaryKey: ['id'])
    .listen((data) {
      // Değişiklikleri işle
    });
```

## 8. Güvenlik (RLS)

Supabase Row Level Security (RLS) kullanır:
- Kullanıcılar sadece kendi verilerini görebilir/düzenleyebilir
- Public veriler (filmler, oyunlar) herkes tarafından görülebilir
- Takip sistemi ve yorumlar uygun izinlerle korunmuştur

## 9. Performans Optimizasyonları

- Veritabanı indeksleri eklendi
- Optimized SQL fonksiyonları
- Sayfalama (pagination) desteği
- Önbellek (cache) stratejileri

## 10. Geçiş Süreci

1. Mevcut veritabanından verileri export edin
2. Supabase'e verileri import edin
3. Kademeli olarak servisleri güncelleyin
4. Test edin ve deploy edin

## 11. Örnek Kullanım

```dart
class ExampleUsage {
  final supabaseService = SupabaseService();

  Future<void> exampleOperations() async {
    // Giriş yapma
    final user = await supabaseService.signIn(
      email: 'user@example.com',
      password: 'password123',
    );

    if (user != null) {
      // Trend içerikleri alma
      final trendMovies = await supabaseService.getTrendContents(
        contentType: ContentTypeEnum.MOVIE,
      );

      // Arkadaş aktivitelerini alma
      final friendActivities = await supabaseService.getFriendActivities(
        contentType: ContentTypeEnum.MOVIE,
      );

      // İçerik arama
      final searchResults = await supabaseService.searchContent(
        query: 'The Matrix',
        contentType: ContentTypeEnum.MOVIE,
        page: 1,
      );
    }
  }
}
```

## 12. Faydalı Kaynaklar

- [Supabase Dart Dokumentasyonu](https://supabase.com/docs/reference/dart)
- [Flutter Supabase Paketi](https://pub.dev/packages/supabase_flutter)
- [Supabase Dashboard](https://app.supabase.com)

## 13. Sorun Giderme

Yaygın sorunlar ve çözümleri:

1. **RLS Politika Hatası**: Kullanıcının gerekli izinlere sahip olduğundan emin olun
2. **Bağlantı Sorunu**: `.env` dosyasındaki URL ve anahtar doğruluğunu kontrol edin
3. **Kimlik Doğrulama**: Session durumunu kontrol edin

## 14. Destek

Sorularınız için:
- Supabase Discord topluluğu
- GitHub Issues
- Supabase Dokumentasyonu
