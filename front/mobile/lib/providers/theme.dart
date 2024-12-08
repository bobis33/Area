import 'package:flutter/material.dart';

import '/config/themes/themes.dart';
import '/models/common.dart';
import '/services/storage.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    _themeData = _themeData.brightness == Brightness.dark
        ? lightTheme
        : darkTheme;
    StorageService().storeItem(StorageKeyEnum.theme.name, _themeData.brightness == Brightness.dark ? 'dark' : 'light');
    notifyListeners();
  }
}
