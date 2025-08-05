import 'package:blackbox_db/2_General/accessible.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    await dotenv.load();

    // Test için geçici - gerçek Supabase bilgilerinizi buraya ekleyin
    const String supabaseUrl = 'https://oxqbvdienivjgkferaxh.supabase.co'; // https://xxx.supabase.co
    const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94cWJ2ZGllbml2amdrZmVyYXhoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQyMzk5NjMsImV4cCI6MjA2OTgxNTk2M30.OzQPYe-3qm1eK-uvY2HlQd9HJw-Ujv-FvJeAp3-0Uas'; // eyJ... ile başlayan uzun key

    await Supabase.initialize(
      url: supabaseUrl.isNotEmpty ? supabaseUrl : dotenv.env['SUPABASE_URL']!,
      anonKey: supabaseAnonKey.isNotEmpty ? supabaseAnonKey : dotenv.env['SUPABASE_ANON_KEY']!,
      debug: kDebugMode,
    );

    // Listen to auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        if (kDebugMode) {
          print('User signed in: ${session.user.email}');
        }
      } else {
        if (kDebugMode) {
          print('User signed out');
        }
        loginUser = null;
      }
    });
  }

  static SupabaseClient get client => Supabase.instance.client;
}
