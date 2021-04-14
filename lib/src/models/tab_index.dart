import 'package:flutter/material.dart';

class TabIndex extends ChangeNotifier {
  int currentIndex = 0;

  void updateIndex(int currIdx){
    currentIndex = currIdx;
    notifyListeners();
  }
}