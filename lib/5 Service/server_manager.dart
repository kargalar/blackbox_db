import 'package:http/http.dart' as http;

class ServerManager {
  static const String _baseUrl = 'https://api.example.com';

  // void addUser() {

  // }

  void getUser() {
    http.get(Uri.parse('$_baseUrl/user'));
  }
}
