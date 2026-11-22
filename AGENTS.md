# Flutter Final Project: "Brewly" (coffee and food ordering app)

This is a COLLEGE project for a beginner Flutter student. Keep everything simple and easy to explain in an oral exam.

## Golden rules (very important)
- Student level only. NO advanced stuff: no Provider, Bloc, Riverpod, GetX, no clean architecture, no dependency injection, no code generation, no freezed/json_serializable.
- Allowed packages: `http` only. (Optional: `shared_preferences` to save the login token. If unsure, keep the token in a simple static variable.)
- State management = `StatefulWidget` + `setState` only.
- Write short, readable code with simple comments (English). Clear names. One widget per file when reasonable.
- The app must run with no errors and no overflow. After EACH step run `flutter analyze` and fix problems.
- Do the work step by step. Stop after each step and tell me what you did. Do not build everything at once.

## Requirements checklist (from the course, all must be satisfied)
1. Screens (at least 4): Splash, Home, Details, + Cart/Orders/Profile.
2. UI: Scaffold + AppBar, Row, Column, Stack, Container, Padding, Card, ListView/GridView, Text styles, Icons, Images, Buttons. Same colors and fonts everywhere (use one theme in main.dart).
3. Interaction: StatefulWidget + setState, a Form with TextFormField + validation (Login, Register, Address, Search), and a button that changes something on screen (favorite heart, quantity counter).
4. Navigation: named routes (routes map in main.dart), pass data between screens (product id/object to Details via arguments), BottomNavigationBar, and at least one AlertDialog / SnackBar / BottomSheet.
5. API: `http` package, model classes with `fromJson`, `FutureBuilder`, loading indicator, error message + Retry button.
6. Animations: at least 2 implicit (AnimatedContainer for selected category chip, AnimatedSwitcher for quantity or heart icon, AnimatedOpacity), a Hero between product list and details, and BONUS an AnimationController on the Splash logo (fade/scale).
7. Code structure: `lib/screens`, `lib/models`, `lib/widgets`, `lib/services`.

## Folder structure
```
lib/
  main.dart               // MaterialApp, theme, named routes
  constants.dart          // baseUrl, colors, route names
  models/
    user.dart             // UserDto: displayName, email, token
    product.dart          // ProductToReturnDTO
    product_page.dart     // pagination: page_Index, page_Size, count, data
    category.dart         // id, name, pictureUrl
    brand.dart            // id, name
    basket.dart           // CustomerBasket + BasketItem
    address.dart
    delivery_method.dart
    order.dart            // OrderToReturnDto + OrderItemDto
  services/
    api_service.dart      // all http calls in one class (simple)
    auth_service.dart     // stores token + current user
  screens/
    splash_screen.dart
    login_screen.dart
    register_screen.dart
    main_screen.dart      // holds BottomNavigationBar + the 4 tabs
    home_screen.dart
    product_details_screen.dart
    cart_screen.dart
    checkout_screen.dart
    orders_screen.dart
    profile_screen.dart   // includes address form
  widgets/
    product_card.dart
    category_chip.dart
    error_retry.dart      // message + Retry button (reused everywhere)
    loading_indicator.dart
```

## Design (simple but not a copy of any app)
- Palette: primary emerald `#0E6B4F`, accent butter yellow `#F5C451`, background cream `#F7F4EE`, cards white, text `#1C1B18`, error `#D64545`.
- Font: default Roboto is fine (no custom fonts needed).
- Cards with rounded corners (16-20), pill-shaped buttons, products shown as a GridView (2 columns) on Home and as a list inside the cart/orders.
- Define everything once in `ThemeData` in main.dart (colorScheme, appBarTheme, elevatedButtonTheme, inputDecorationTheme).

## API
Base URL: set in `constants.dart` as `const String baseUrl = 'PUT_BASE_URL_HERE';` (ask me if it is missing). On Android emulator, localhost is `10.0.2.2`.
Protected endpoints need header: `Authorization: Bearer <token>` and `Content-Type: application/json`.

| Purpose | Method + Path | Notes |
|---|---|---|
| Register | POST /api/Account/Register | body: displayName, email, phoneNumber, password. Password: 6-10 chars, 1 digit, 1 lowercase, 1 uppercase, 1 special char. Returns UserDto (displayName, email, token) |
| Login | POST /api/Account/Login | body: email, password. Returns UserDto |
| Check email | GET /api/Account/emailExisits?email= | returns true/false (the spelling "Exisits" is correct, do not fix it) |
| Current user | GET /api/Account | |
| Get address | GET /api/Account/Address | |
| Save address | PUT /api/Account/Address | body: firstName, lastName, street, city, country (all required) |
| Categories | GET /api/Products/categories | id, name, pictureUrl |
| Brands | GET /api/Products/brands | id, name (NO image) |
| Products | GET /api/Products | query: PageSize, PageIndex, Search, sort, brandId, categoryId. Response has page_Index, page_Size, count, data[] |
| Product | GET /api/Products/{id} | 404 if not found |
| Basket | GET /api/Basket | returns id + items[] |
| Add to basket | POST /api/Basket | body: productId, quantity (min 1) |
| Clear basket | DELETE /api/Basket | |
| Delivery methods | GET /api/Orders/DeliverMethods | id, shortName, description, cost, deliveryTime |
| Create order | POST /api/Orders | body: deliverMethodID, shippingAddress {firstName,lastName,street,city,country} |
| My orders | GET /api/Orders | list |
| Order by id | GET /api/Orders/{orderId} | |

Notes:
- The OpenAPI file says /api/Products returns an array, but it is most likely a single object with `data`. Print the real response once and match the model to it.
- Error responses look like `{ "statusCode": 400, "message": "..." }`. Show `message` in a SnackBar or in the error widget.
- Wrap every http call in try/catch so "no internet" shows the error message + Retry button.

## Screens (keep each one simple)
1. Splash: logo with an AnimationController (fade + scale), after 2-3 seconds go to Login (or Main if a token exists).
2. Login: Form with email + password, validation, error SnackBar, link to Register.
3. Register: Form with name, email, phone, password. Validate the password with a RegExp. No social login.
4. Main: Scaffold with BottomNavigationBar: Home, Cart, Orders, Profile.
5. Home: greeting with displayName, search TextFormField (validation: not empty), horizontal category chips (AnimatedContainer when selected), GridView of products via FutureBuilder, favorite heart button on each card (local only, setState + AnimatedSwitcher). Tap on product -> Details with Hero image.
6. Details: Hero image, name, brand, category, price, description, quantity counter, "Add to cart" button -> POST /api/Basket -> SnackBar.
7. Cart: FutureBuilder on GET /api/Basket, list of items, subtotal, "Clear cart" with AlertDialog confirm, "Checkout" button, empty state.
8. Checkout: address form (prefilled), delivery method choice (RadioListTile), total, "Place order" -> SnackBar -> go to Orders.
9. Orders: FutureBuilder list of orders (id, date, status, total). Tap shows a BottomSheet with order details (no extra screen needed).
10. Profile: avatar with initials, name, email, edit address form (PUT), Log out with AlertDialog.

## Build order (I will ask for these one at a time)
1. Create the project structure, theme, constants, named routes with empty placeholder screens.
2. Models with fromJson for everything above.
3. api_service.dart + auth_service.dart.
4. Splash (AnimationController) + Login + Register with validation.
5. Main screen with BottomNavigationBar.
6. Home (categories + products + search + favorites).
7. Product details with Hero and add to cart.
8. Cart + Checkout.
9. Orders + Profile.
10. Final pass: check every requirement in the checklist, fix overflow, run `flutter analyze`, run the app.
