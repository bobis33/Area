import 'package:flutter/foundation.dart';

import '/config/api_config.dart';

class SettingsProvider with ChangeNotifier {
  final _apiUrl = ApiConfig().apiUrl;

  String get apiAddress => _apiUrl;

  void updateApiAddress(String newAddress) {
    ApiConfig().setApiUrl(_apiUrl);
    notifyListeners();
  }
}
