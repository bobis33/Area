import 'dart:convert';

import '/config/constants.dart';
import '/data/models/data.dart';
import '/data/models/user.dart';
import '/data/sources/request_service.dart';
import '/data/sources/storage_service.dart';
import '/domain/repositories/user.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl();
  
  final StorageService _storageService = StorageService();
  final RequestService _requestService = RequestService();
  
  @override

  @override
  Future<DataState<User>> getUser() async {
    final token = await _storageService.getItem(StorageKeyEnum.authToken.name);
    return await _requestService.makeRequest<User>(
      endpoint: '/users/get/self',
      method: 'GET',
      headers: {'Authorization': 'Bearer $token'},
      parse: (response) {
        final data = json.decode(response.body);
        return User.fromJson(data['user']);
      },
    );
  }

  @override
  Future<DataState<String>> updateUsername(String username) async {
    final token = await _storageService.getItem(StorageKeyEnum.authToken.name);
    return await _requestService.makeRequest<String>(
      endpoint: '/users/update/username?username=$username',
      method: 'PATCH',
      headers: {'Authorization': 'Bearer $token'},
      parse: (response) {
        final data = json.decode(response.body);
        return data['detail'];
      },
    );
  }

  @override
  Future<DataState<String>> updatePassword(String password) async {
    final token = await _storageService.getItem(StorageKeyEnum.authToken.name);
    return await _requestService.makeRequest<String>(
      endpoint: '/users/update/password?password=$password',
      method: 'PATCH',
      headers: {'Authorization': 'Bearer $token'},
      parse: (response) {
        final data = json.decode(response.body);
        return data['detail'];
      },
    );
  }

  @override
  Future<DataState<String>> updateEmail(String email) async {
    final token = await _storageService.getItem(StorageKeyEnum.authToken.name);
    return await _requestService.makeRequest<String>(
      endpoint: '/users/update/email?email=$email',
      method: 'PATCH',
      headers: {'Authorization': 'Bearer $token'},
      parse: (response) {
        final data = json.decode(response.body);
        return data['detail'];
      },
    );

  }
}
