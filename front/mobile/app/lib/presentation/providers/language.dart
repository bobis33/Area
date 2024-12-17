import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {

  LanguageProvider();

  void rebuild() async {
    notifyListeners();
  }
}
