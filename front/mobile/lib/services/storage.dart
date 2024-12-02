import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  StorageService._internal();

  factory StorageService() => _instance;

  Future<void> storeItem(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> getItem(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> clearItem(String key) async {
    await _secureStorage.delete(key: key);
  }
}
