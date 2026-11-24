import 'dart:convert';

import 'package:brewly/core/errors/app_exception.dart';
import 'package:brewly/models/address.dart';
import 'package:brewly/services/api_client.dart';
import 'package:brewly/services/api_service.dart';
import 'package:brewly/services/auth_service.dart';
import 'package:brewly/services/basket_service.dart';
import 'package:brewly/services/order_service.dart';
import 'package:brewly/services/product_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    test('ProductService parses Swagger array pagination response', () async {
      final mock = MockClient((request) async {
        expect(request.url.path, '/api/Products');
        return http.Response(
          jsonEncode([
            {
              'page_Index': 1,
              'page_Size': 10,
              'count': 1,
              'data': [
                {
                  'id': 7,
                  'name': 'Spanish Iced Latte',
                  'description': 'Cold espresso',
                  'pictureUrl': 'https://example.test/latte.png',
                  'price': 95,
                  'brandId': 1,
                  'brand': 'Brewly',
                  'categoryId': 2,
                  'category': 'Cold Brew',
                },
              ],
            },
          ]),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = ProductService(
        client: ApiClient(
          httpClient: mock,
          baseUrl: 'https://example.test',
        ),
      );

      final page = await service.getProducts();
      expect(page.pageIndex, 1);
      expect(page.pageSize, 10);
      expect(page.count, 1);
      expect(page.products.length, 1);
      expect(page.products.first.id, 7);
      expect(page.products.first.name, 'Spanish Iced Latte');
    });

    test('BasketService sends productId and quantity to POST /api/Basket', () async {
      final mock = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/Basket');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['productId'], 7);
        expect(body['quantity'], 3);

        return http.Response(
          jsonEncode({
            'id': 'basket-1',
            'items': [
              {
                'id': 7,
                'productName': 'Spanish Iced Latte',
                'price': 95,
                'pictureUrl': 'https://example.test/latte.png',
                'quantity': 3,
              },
            ],
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = BasketService(
        client: ApiClient(
          httpClient: mock,
          baseUrl: 'https://example.test',
        ),
      );

      final basket = await service.addItem(productId: 7, quantity: 3);
      expect(basket.items.single.id, 7);
      expect(basket.items.single.productId, 7);
      expect(basket.items.single.quantity, 3);
    });

    test('BasketService.clearBasket rethrows DELETE error without publishing empty', () async {
      BasketService.itemCount.value = 2;
      BasketService.total.value = 190;

      final mock = MockClient((request) async {
        expect(request.method, 'DELETE');
        expect(request.url.path, '/api/Basket');
        return http.Response(
          jsonEncode({'statusCode': 500, 'message': 'Could not delete basket'}),
          500,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = BasketService(
        client: ApiClient(
          httpClient: mock,
          baseUrl: 'https://example.test',
        ),
      );

      await expectLater(
        service.clearBasket(),
        throwsA(
          isA<AppException>().having(
            (e) => e.message,
            'message',
            'Could not delete basket',
          ),
        ),
      );
      expect(BasketService.itemCount.value, 2);
      expect(BasketService.total.value, 190);
    });

    test('BasketService.clearBasket publishes empty only after 200 DELETE', () async {
      BasketService.itemCount.value = 2;
      BasketService.total.value = 190;

      final mock = MockClient((request) async {
        expect(request.method, 'DELETE');
        expect(request.url.path, '/api/Basket');
        return http.Response('', 200);
      });

      final service = BasketService(
        client: ApiClient(
          httpClient: mock,
          baseUrl: 'https://example.test',
        ),
      );

      await service.clearBasket();
      expect(BasketService.itemCount.value, 0);
      expect(BasketService.total.value, 0);
    });

    test('BasketService.getBasket only treats API empty-basket 500 as empty', () async {
      final empty500Mock = MockClient((request) async {
        return http.Response(
          jsonEncode({'details': null, 'statusCode': 500, 'message': 'Internal Server Error'}),
          500,
          headers: {'content-type': 'application/json'},
        );
      });

      final emptyService = BasketService(
        client: ApiClient(
          httpClient: empty500Mock,
          baseUrl: 'https://example.test',
        ),
      );
      final emptyBasket = await emptyService.getBasket();
      expect(emptyBasket.items, isEmpty);

      final realErrorMock = MockClient((request) async {
        return http.Response(
          jsonEncode({'statusCode': 500, 'message': 'Database connection failed'}),
          500,
          headers: {'content-type': 'application/json'},
        );
      });

      final failingService = BasketService(
        client: ApiClient(
          httpClient: realErrorMock,
          baseUrl: 'https://example.test',
        ),
      );
      await expectLater(
        failingService.getBasket(),
        throwsA(
          isA<AppException>().having(
            (e) => e.message,
            'message',
            'Database connection failed',
          ),
        ),
      );
    });

    test('OrderService sends deliverMethodID and shippingAddress', () async {
      final mock = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/Orders');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['deliverMethodID'], 2);
        expect(body['shippingAddress']['city'], 'Cairo');

        return http.Response(
          jsonEncode({
            'id': 42,
            'orderDate': '2026-11-24T12:00:00Z',
            'status': 'Pending',
            'deliveryMethod': 'Express',
            'deliveryCost': 60,
            'subTotal': 190,
            'total': 250,
            'items': [],
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = OrderService(
        client: ApiClient(
          httpClient: mock,
          baseUrl: 'https://example.test',
        ),
      );

      final order = await service.createOrder(
        deliveryMethodId: 2,
        shippingAddress: const Address(
          firstName: 'Omar',
          lastName: 'El-Sayed',
          street: '14 Gezira St',
          city: 'Cairo',
          country: 'Egypt',
        ),
      );
      expect(order.id, '42');
      expect(order.total, 250);
    });

    test('AuthService persists session, restores valid token, clears on 401/404, and clears on logout', () async {
      SharedPreferences.setMockInitialValues({});

      final mock = MockClient((request) async {
        if (request.url.path == '/api/Account/Login') {
          return http.Response(
            jsonEncode({
              'displayName': 'Nour Hassan',
              'email': 'nour@example.com',
              'token': 'valid-jwt-token',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.url.path == '/api/Account') {
          if (request.headers['Authorization'] == 'Bearer valid-jwt-token') {
            return http.Response(
              jsonEncode({
                'displayName': 'Nour Hassan',
                'email': 'nour@example.com',
                'token': 'valid-jwt-token',
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          return http.Response('', 404);
        }
        if (request.url.path == '/api/Account/Address' && request.method == 'PUT') {
          return http.Response(
            request.body,
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.url.path == '/api/Account/Address' && request.method == 'GET') {
          return http.Response(
            jsonEncode({
              'firstName': 'Nour',
              'lastName': 'Hassan',
              'street': '22 Nile St',
              'city': 'Giza',
              'country': 'Egypt',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('', 200);
      });

      final client = ApiClient(httpClient: mock, baseUrl: 'https://example.test');
      final apiService = ApiService(client: client);
      final auth1 = AuthService(apiService: apiService);

      await auth1.login(email: 'nour@example.com', password: 'Password@1');
      expect(auth1.isLoggedIn, isTrue);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('auth_token'), 'valid-jwt-token');

      final updated = await auth1.updateAddress(
        const Address(
          firstName: 'Nour',
          lastName: 'Hassan',
          street: '22 Nile St',
          city: 'Giza',
          country: 'Egypt',
        ),
      );
      expect(updated.street, '22 Nile St');
      expect(AuthService.savedAddress.value?.city, 'Giza');

      final auth2 = AuthService(apiService: ApiService(client: client));
      final restored = await auth2.restoreSession();
      expect(restored, isTrue);
      expect(auth2.currentUser?.displayName, 'Nour Hassan');
      expect(AuthService.savedAddress.value?.street, '22 Nile St');

      await auth2.logout();
      expect(auth2.isLoggedIn, isFalse);
      expect(AuthService.savedAddress.value, isNull);
      expect(prefs.getString('auth_token'), isNull);

      await prefs.setString('auth_token', 'expired-token');
      final auth3 = AuthService(apiService: ApiService(client: client));
      final restoredExpired = await auth3.restoreSession();
      expect(restoredExpired, isFalse);
      expect(prefs.getString('auth_token'), isNull);
    });
  });
}
