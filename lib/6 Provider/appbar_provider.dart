import 'package:flutter/material.dart';

class AppbarProvider with ChangeNotifier {
  int currentIndex = 0;
  String searchText = '';

  void updatePage(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void search(String text) {
    searchText = text;
    currentIndex = 1;
    notifyListeners();
  }
}
