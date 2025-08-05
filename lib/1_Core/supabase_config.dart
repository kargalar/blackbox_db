import 'package:blackbox_db/2_General/accessible.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    await dotenv.load();

    String? supabaseUrl = dotenv.env['SUPABASE_URL'];
    String? supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

    await Supabase.initialize(
      url: supabaseUrl!,
      anonKey: supabaseAnonKey!,
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
