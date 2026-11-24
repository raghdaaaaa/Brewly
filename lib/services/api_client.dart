import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/app_config.dart';
import '../core/errors/app_exception.dart';

class ApiClient {
  ApiClient({http.Client? httpClient, String? baseUrl})
      : _httpClient = httpClient ?? http.Client(),
        _baseUrl = _cleanBaseUrl(baseUrl ?? AppConfig.baseUrl);

  static final ApiClient shared = ApiClient();

  final http.Client _httpClient;
  final String _baseUrl;

  String? authToken;

  Future<dynamic> get(
    String path, {
    Map<String, String>? query,
  }) {
    return _send('GET', path, query: query);
  }

  Future<dynamic> post(String path, {Object? body}) {
    return _send('POST', path, body: body);
  }

  Future<dynamic> put(String path, {Object? body}) {
    return _send('PUT', path, body: body);
  }

  Future<dynamic> delete(String path, {Object? body}) {
    return _send('DELETE', path, body: body);
  }

  Future<dynamic> _send(
    String method,
    String path, {
    Map<String, String>? query,
    Object? body,
  }) async {
    if (_baseUrl.isEmpty || _baseUrl == AppConfig.missingBaseUrl) {
      throw const AppException(
        'The API address is missing. Set AppConfig.baseUrl first.',
      );
    }

    final uri = _buildUri(path, query);
    final headers = <String, String>{
      'Accept': 'application/json',
      if (body != null) 'Content-Type': 'application/json',
      if (authToken != null && authToken!.isNotEmpty)
        'Authorization': 'Bearer $authToken',
    };

    try {
      final response = await _perform(
        method,
        uri,
        headers,
        body == null ? null : jsonEncode(body),
      ).timeout(AppConfig.requestTimeout);

      return _decode(response);
    } on TimeoutException {
      throw const AppException(
        'The request took too long. Check your connection and try again.',
      );
    } on http.ClientException {
      throw const AppException(
        'No internet connection. Check your network and try again.',
      );
    } on FormatException {
      throw const AppException(
        'The server returned an unexpected response. Please try again.',
      );
    }
  }

  Future<http.Response> _perform(
    String method,
    Uri uri,
    Map<String, String> headers,
    String? body,
  ) async {
    final request = http.Request(method, uri)..headers.addAll(headers);
    if (body != null) {
      request.body = body;
    }
    final streamed = await _httpClient.send(request);
    return http.Response.fromStream(streamed);
  }

  Uri _buildUri(String path, Map<String, String>? query) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final uri = Uri.parse('$_baseUrl$normalizedPath');
    if (query == null || query.isEmpty) {
      return uri;
    }
    return uri.replace(queryParameters: query);
  }

  dynamic _decode(http.Response response) {
    final hasBody = response.body.trim().isNotEmpty;
    dynamic decoded;

    if (hasBody) {
      try {
        decoded = jsonDecode(response.body);
      } on FormatException {
        decoded = response.body;
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    throw AppException(
      _errorMessage(response.statusCode, decoded),
      statusCode: response.statusCode,
    );
  }

  String _errorMessage(int statusCode, dynamic body) {
    if (body is Map) {
      final message = body['message'];
      final messageText = message is String && message.trim().isNotEmpty
          ? message.trim()
          : null;
      final errorText = _firstError(body['errors']);

      if (statusCode == 401 &&
          (messageText == null ||
              messageText.toLowerCase() == 'not authorized')) {
        return 'The email or password is incorrect.';
      }
      if (errorText != null &&
          (messageText == null ||
              messageText.toLowerCase() == 'bad request' ||
              messageText.toLowerCase() ==
                  'one or more validation errors occurred.')) {
        return errorText;
      }
      if (messageText != null) {
        return messageText;
      }
      if (errorText != null) {
        return errorText;
      }
    }

    if (body is String && body.trim().isNotEmpty && !body.startsWith('<')) {
      return body.trim();
    }

    switch (statusCode) {
      case 400:
        return 'Please check your details and try again.';
      case 401:
        return 'The email or password is incorrect.';
      case 403:
        return 'You are not allowed to do that.';
      case 404:
        return 'The requested item was not found.';
      case 409:
        return 'This account already exists.';
      case 500:
      case 502:
      case 503:
        return 'The server had a problem. Please try again later.';
      default:
        return 'Something went wrong (error $statusCode). Please try again.';
    }
  }

  String? _firstError(dynamic errors) {
    if (errors is List) {
      for (final value in errors) {
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString().trim();
        }
      }
    }
    if (errors is Map) {
      for (final value in errors.values) {
        if (value is List) {
          final nested = _firstError(value);
          if (nested != null) {
            return nested;
          }
        }
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
    }
    return null;
  }

  static String _cleanBaseUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.endsWith('/')) {
      return trimmed.substring(0, trimmed.length - 1);
    }
    return trimmed;
  }
}
