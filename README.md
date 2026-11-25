# Brewly

Brewly is a Flutter app for browsing coffee and bakery products, managing a basket,
and placing and tracking orders.

## Features

- Welcome, login, and account registration
- Product discovery by category, brand, search, sort, and paginated results
- Product details with favorites, quantity selection, and Hero image transitions
- Basket quantity controls, checkout, delivery methods, and order confirmation
- Order history and order details
- Profile, saved address management, and locally selected profile photo
- Loading, retry, empty, and error states for API-backed content

## Technologies

- Flutter and Dart
- `http` for REST requests
- `flutter_svg` for SVG assets
- `shared_preferences` for persisted session, basket, and profile data
- `image_picker` and `path_provider` for selecting and storing a profile photo
- `flutter_test` and `flutter_lints` for tests and static analysis
- Bundled Plus Jakarta Sans font and local image/icon assets

## Project structure

```text
lib/
  main.dart             App entry point
  app.dart              Theme and named routes
  core/                 Theme, configuration, routes, utilities, and errors
  models/               API data models and JSON parsing
  screens/              Screen composition and local UI state
  services/             API client and feature services
  widgets/              Shared and feature-specific widgets
test/
  fakes/                In-memory service fakes and test data
  screens/              Screen behavior and layout tests
  services/              API and service tests
  widgets/              Shared widget tests
assets/
  fonts/                Bundled fonts
  icons/                SVG icons
  images/               Local app images
```

Screens call feature services; `ApiClient` is the HTTP boundary. Models parse API
responses, and screens render asynchronous results and errors.

## API and authentication

The API base URL is configured in
[`lib/core/constants/app_config.dart`](lib/core/constants/app_config.dart).
`ApiService`, `ProductService`, and `OrderService` use the shared HTTP client.
`BasketService` reads and writes local basket data through `shared_preferences`.

Login and registration return a user token. `AuthService` persists the session with
`shared_preferences` and sets the token on the shared client; requests include a
Bearer authorization header when a token is available. The client sends JSON for
requests with bodies and maps HTTP failures to readable application errors.

The app uses the account, products, and orders API areas. Basket contents are stored
locally with `shared_preferences`; selected API products, quantities, and price
snapshots persist across app restarts. Basket operations do not call the remote
Basket API.

## Setup and run

Install Flutter with a Dart SDK compatible with the constraint in `pubspec.yaml`,
then run:

```sh
flutter pub get
flutter run
```

The app currently uses the API URL in `AppConfig.baseUrl`. Change that value when
using a different API deployment.

## Analyze and test

```sh
flutter analyze --no-pub
flutter test --no-pub
```

## Screenshots

No app screenshots are currently committed to this repository.
