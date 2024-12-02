import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart' as http;

import '/services/storage.dart';

class LoginResponse {
  final String? token;
  final String? error;

  LoginResponse({this.token, this.error});
}

class AuthService {
  final String baseUrl = 'http://10.0.2.2:5000';
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  AuthService();

  Future<bool> isLoggedIn() async {
    final token = await StorageService().getToken();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/protected'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
      } catch (e) {
      print('An error occurred: $e');
    }
    return false;
  }

  Future<LoginResponse> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return LoginResponse(token: data['token']);
      } else {
        final Map<String, dynamic> data = json.decode(response.body);
        return LoginResponse(error: 'Login failed: ${data['detail']}');
      }
    } catch (e) {
      print('An error occurred: $e');
      return LoginResponse(error: 'An unexpected error occurred');
    }
  }

  Future<LoginResponse> registerUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return LoginResponse(token: data['token']);
      } else {
        final errorMessage = _parseError(response);
        print('Registration failed: $errorMessage');
        return LoginResponse(error: errorMessage);
      }
    } catch (e) {
      print('An error occurred during registration: $e');
      return LoginResponse(error: 'An unexpected error occurred: $e');
    }
  }

  String _parseError(http.Response response) {
    try {
      final Map<String, dynamic> errorData = json.decode(response.body);
      return errorData['detail'] ?? 'An error occurred';
    } catch (e) {
      print('Error parsing error message: $e');
      return translate('anErrorOccurred');
    }
  }
}
