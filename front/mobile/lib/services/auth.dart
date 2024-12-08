import 'dart:convert';

import '/models/common.dart';
import '/models/data.dart';
import '/services/request.dart';
import '/services/storage.dart';

class AuthService {
  AuthService();
  final StorageService _storageService = StorageService();

  Future<bool> isLoggedIn() async {
    final String? token = await _storageService.getItem(StorageKeyEnum.authToken.name);
    final DataState<bool> result = await RequestService().makeRequest<bool>(
      endpoint: '/auth/protected',
      method: 'GET',
      headers: {'Authorization': 'Bearer $token'},
      parse: (response) => response.statusCode == 200,
    );
    return result.data ?? false;
  }

  Future<DataState<String>> loginUser(String email, String password) {
    return RequestService().makeRequest<String>(
      endpoint: '/auth/login',
      method: 'POST',
      body: {'email': email, 'password': password},
      parse: (response) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final token = data['token'] as String;
        _storageService.storeItem(StorageKeyEnum.authToken.name, token);
        return token;
      },
    );
  }

  Future<DataState<String>> registerUser(String email, String password) {
    return RequestService().makeRequest<String>(
      endpoint: '/auth/register',
      method: 'POST',
      body: {'email': email, 'password': password},
      parse: (response) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final token = data['token'] as String;
        _storageService.storeItem(StorageKeyEnum.authToken.name, token);
        return token;
      },
    );
  }
}
