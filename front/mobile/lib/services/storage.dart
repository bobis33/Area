import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  StorageService._internal();

  factory StorageService() => _instance;

  Future<void> storeToken(String token) async {
    await _secureStorage.write(key: 'authToken', value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'authToken');
  }

  Future<void> clearToken() async {
    await _secureStorage.delete(key: 'authToken');
  }

  Future<void> storeLang(String lang) async {
    await _secureStorage.write(key: 'lang', value: lang);
  }

  Future<String?> loadLang() async {
    return await _secureStorage.read(key: 'lang');
  }

  Future<void> clearLang() async {
    await _secureStorage.delete(key: 'lang');
  }

  Future<void> storeTheme(ThemeData themeData) async {
    await _secureStorage.write(key: 'theme', value: themeData.brightness == Brightness.dark ? 'dark' : 'light');
  }

  Future<String?> loadTheme() async {
    return await _secureStorage.read(key: 'theme');
  }

  Future<void> clearTheme() async {
    await _secureStorage.delete(key: 'theme');
  }
}


