import 'package:flutter/material.dart';

class AppbarProvider with ChangeNotifier {
  int currentIndex = 0;

  void updatePage(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
