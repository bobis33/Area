import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static final ApiConfig _instance = ApiConfig._internal();
  factory ApiConfig() => _instance;

  ApiConfig._internal();

  String _apiUrl = dotenv.env['API_URL']!;

  String get apiUrl => _apiUrl;

  void setApiUrl(String newUrl) {
    _apiUrl = newUrl;
  }
}
