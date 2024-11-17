import 'package:blackbox_db/8%20Model/content_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServerManager {
  static const String _baseUrl = 'http://localhost:3000';

  // void addUser() {
  // }

  void getUser() {
    http.get(Uri.parse('$_baseUrl/user'));
  }

  Future<dynamic> getGenres() async {
    final response = await http.get(Uri.parse("$_baseUrl/genre"));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      debugPrint(data);
      return data;
    } else {
      debugPrint("Error: ${response.statusCode}");
      throw response.statusCode;
    }
  }

  Future<List<ContentModel>> getContentList() async {
    final response = await http.get(Uri.parse("$_baseUrl/content"));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return ContentModel.fromJsonList(data);
    } else {
      debugPrint("Error: ${response.statusCode}");
      throw response.statusCode;
    }
  }
}
