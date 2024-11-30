import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginResponse {
  final String? token;
  final String? error;

  LoginResponse({this.token, this.error});
}

class AuthService {
  final String baseUrl;

  AuthService({required this.baseUrl});

  Future<LoginResponse> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return LoginResponse(token: data['token']);
      } else if (response.statusCode == 401) {
        return LoginResponse(error: 'Invalid email or password');
      } else {
        return LoginResponse(error: 'Login failed: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
      return LoginResponse(error: 'An unexpected error occurred');
    }
  }

  Future<String?> registerUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(<String, String>{
          'username': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return null;
      } else {
        final errorMessage = _parseError(response);
        print('Registration failed: $errorMessage');
        return errorMessage;
      }
    } catch (e) {
      print('An error occurred during registration: $e');
      return 'An unexpected error occurred';
    }
  }

  String _parseError(http.Response response) {
    try {
      final Map<String, dynamic> errorData = json.decode(response.body);
      return errorData['detail'] ?? 'An error occurred';
    } catch (e) {
      print('Error parsing error message: $e');
      return 'An error occurred';
    }
  }
}
