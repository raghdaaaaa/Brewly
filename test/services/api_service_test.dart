import 'dart:convert';

import 'package:brewly/core/errors/app_exception.dart';
import 'package:brewly/services/api_client.dart';
import 'package:brewly/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('ApiService', () {
    test('login sends JSON and parses the user', () async {
      final mock = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/Account/Login');
        expect(request.headers['Content-Type'], contains('application/json'));

        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['email'], 'omar@example.com');
        expect(body['password'], 'Cairo@12');

        return http.Response(
          jsonEncode({
            'displayName': 'Omar',
            'email': 'omar@example.com',
            'token': 'token-123',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = ApiService(
        client: ApiClient(
          httpClient: mock,
          baseUrl: 'https://example.test',
        ),
      );

      final user = await service.login(
        email: ' omar@example.com ',
        password: 'Cairo@12',
      );

      expect(user.displayName, 'Omar');
      expect(user.email, 'omar@example.com');
      expect(user.token, 'token-123');
    });

    test('register sends the +20 phone number and password', () async {
      final mock = MockClient((request) async {
        expect(request.url.path, '/api/Account/Register');

        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['displayName'], 'Omar El-Sayed');
        expect(body['phoneNumber'], '+201023456789');
        expect(body['password'], 'Cairo@12');

        return http.Response(
          jsonEncode({
            'displayName': 'Omar El-Sayed',
            'email': 'omar@example.com',
            'token': 'token-456',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = ApiService(
        client: ApiClient(
          httpClient: mock,
          baseUrl: 'https://example.test',
        ),
      );

      final user = await service.register(
        displayName: 'Omar El-Sayed',
        email: 'omar@example.com',
        phoneNumber: '+201023456789',
        password: 'Cairo@12',
      );

      expect(user.token, 'token-456');
    });

    test('emailExists sends the email query and reads a boolean', () async {
      final mock = MockClient((request) async {
        expect(request.url.path, '/api/Account/emailExisits');
        expect(request.url.queryParameters['email'], 'omar@example.com');
        return http.Response('true', 200, headers: {
          'content-type': 'text/plain',
        });
      });

      final service = ApiService(
        client: ApiClient(
          httpClient: mock,
          baseUrl: 'https://example.test',
        ),
      );

      expect(await service.emailExists('omar@example.com'), isTrue);
    });

    test('server validation details win over the generic message', () async {
      final mock = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'errors': [
              'Password must have 1 uppercase, 1 lowercase, 1 number, '
                  '1 non alphanumeric, and at least 6 characters',
            ],
            'statusCode': 400,
            'message': 'Bad Request',
          }),
          400,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = ApiService(
        client: ApiClient(
          httpClient: mock,
          baseUrl: 'https://example.test',
        ),
      );

      await expectLater(
        service.register(
          displayName: 'Omar',
          email: 'omar@example.com',
          phoneNumber: '+201023456789',
          password: 'wrong',
        ),
        throwsA(
          isA<AppException>().having(
            (error) => error.message,
            'message',
            contains('Password must have'),
          ),
        ),
      );
    });

    test('401 shows a clear login message', () async {
      final mock = MockClient((request) async {
        return http.Response(
          jsonEncode({'statusCode': 401, 'message': 'Not Authorized'}),
          401,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = ApiService(
        client: ApiClient(
          httpClient: mock,
          baseUrl: 'https://example.test',
        ),
      );

      await expectLater(
        service.login(email: 'omar@example.com', password: 'wrong'),
        throwsA(
          isA<AppException>().having(
            (error) => error.message,
            'message',
            'The email or password is incorrect.',
          ),
        ),
      );
    });
  });
}
