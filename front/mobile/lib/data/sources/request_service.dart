import 'dart:convert';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart' as http;

import '/data/models/data.dart';

class RequestService {
  const RequestService();
  static const String _baseUrl = 'http://10.0.2.2:5000';
  static const _headers = {'Content-Type': 'application/json'};

  Future<DataState<T>> makeRequest<T>({
    required String endpoint,
    required String method,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    required T Function(http.Response response) parse,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      http.Response response;

      switch (method) {
        case 'POST':
          response = await http.post(
            url,
            headers: {..._headers, ...?headers},
            body: json.encode(body),
          );
          break;
        case 'GET':
        default:
          response = await http.get(
            url,
            headers: {..._headers, ...?headers},
          );
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return DataSuccess(parse(response));
      } else {
        return DataError(_parseError(response));
      }
    } catch (e) {
      return DataError('An unexpected error occurred: $e');
    }
  }

  String _parseError(http.Response response) {
    try {
      final Map<String, dynamic> errorData = json.decode(response.body);
      return errorData['detail'] ?? translate('anErrorOccurred');
    } catch (e) {
      return translate('anErrorOccurred');
    }
  }
}
