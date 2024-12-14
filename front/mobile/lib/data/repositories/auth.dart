import 'dart:convert';

import '/config/constants.dart';
import '/data/models/data.dart';
import '/data/models/user.dart';
import '/data/sources/request_service.dart';
import '/data/sources/storage_service.dart';
import '/domain/repositories/auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl();
  
  final StorageService _storageService = StorageService();
  final RequestService _requestService = RequestService();
  
  @override
  Future<bool> isAuthenticated() async {
    final token = await _storageService.getItem(StorageKeyEnum.authToken.name);
    final result = await _requestService.makeRequest<bool>(
      endpoint: '/auth/me',
      method: 'GET',
      headers: {'Authorization': 'Bearer $token'},
      parse: (response) => response.statusCode == 200,
    );
    return result.data ?? false;
  }

  @override
  Future<DataState<String>> loginUser(User user) async {
    return await _requestService.makeRequest<String>(
      endpoint: '/auth/login',
      method: 'POST',
      body: {'email': user.username, 'password': user.password},
      parse: (response) {
        final data = json.decode(response.body);
        final token = data['token'];
        _storageService.storeItem(StorageKeyEnum.authToken.name, token);
        return token;
      },
    );
  }

  @override
  Future<DataState<String>> registerUser(User user) async {
    return await _requestService.makeRequest<String>(
      endpoint: '/auth/register',
      method: 'POST',
      body: {'email': user.username, 'password': user.password},
      parse: (response) {
        final data = json.decode(response.body);
        final token = data['token'];
        _storageService.storeItem(StorageKeyEnum.authToken.name, token);
        return token;
      },
    );
  }
}
