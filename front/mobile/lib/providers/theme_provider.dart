import 'package:area_front_mobile/models/common.dart';
import 'package:flutter/material.dart';

import '/services/storage.dart';
import '/styles/color_schemes.g.dart';
import '/styles/text_themes.g.dart';


class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    _themeData = _themeData.brightness == Brightness.dark
        ? ThemeData(useMaterial3: true, colorScheme: lightColorScheme, textTheme: textTheme)
        : ThemeData(useMaterial3: true, colorScheme: darkColorScheme, textTheme: textTheme);
    StorageService().storeItem(StorageKeyEnum.theme.name, _themeData.brightness == Brightness.dark ? 'dark' : 'light');
    notifyListeners();
  }
}
