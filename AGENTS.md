# Brewly: Flutter coffee and food ordering app (university final project)

This is a graded university project, but it must be built like a professional app: clean architecture, small reusable widgets, zero hardcoded values, pixel-faithful UI, no overflow. "Student project" is NEVER a reason to write sloppy code.

## 1. Course requirements (must all be visible in the app)
Allowed techniques only: `StatefulWidget` + `setState`, `FutureBuilder`, named routes, the `http` package. NO state-management packages (no Provider, Bloc, Riverpod, GetX), no code generation, no freezed/json_serializable.
1. At least 4 screens: splash, home, details, plus others. Scaffold + AppBar (or the header from the design) on screens.
2. Row, Column, Stack, Container, Padding, Card, ListView/GridView, Text styles, Icons, Images, Buttons. Same colors and fonts everywhere. No overflow.
3. StatefulWidget + setState. At least one Form with TextFormField + validation (login, register, address, search). A button that changes something on screen (favorite, quantity counter).
4. Named routes. Pass data between screens through route arguments (product to details). BottomNavigationBar. At least one AlertDialog, SnackBar or BottomSheet.
5. API with the `http` package. Model classes with `fromJson`. `FutureBuilder`. Loading indicator. Error message + Retry button.
6. At least 2 implicit animations (AnimatedContainer, AnimatedOpacity, AnimatedSwitcher). A Hero between list and details. Bonus: explicit animation with AnimationController (splash logo).
7. Code split into folders: `screens`, `models`, `widgets`, `services` (these four stay at the top level of lib/ exactly with these names).
8. The app runs without errors.

## 2. Architecture (layers, top-level folders of lib/)
```
lib/
  main.dart                  // runApp only
  app.dart                   // MaterialApp: theme, routes, initialRoute
  core/
    theme/                   // app_colors.dart, app_text_styles.dart, app_spacing.dart (spacing, radius, shadows, sizes), app_theme.dart
    routes/app_routes.dart   // route names + routes map
    constants/               // app_assets.dart, app_config.dart (baseUrl)
    utils/                   // validators.dart, formatters.dart (price, date), extensions
    errors/app_exception.dart
  models/                    // plain Dart classes with fromJson / toJson
  services/                  // api_client.dart (http wrapper) + one service per domain:
                             // auth_service, account_service, product_service, basket_service, order_service
  screens/
    <feature>/               // splash, auth (welcome, login, register), home, explore, products, cart, orders, profile
      <name>_screen.dart     // composes widgets, owns state (setState), calls services
  widgets/
    common/                  // shared: app_button, app_text_field, app_card, status_pill, quantity_stepper,
                             // section_header, app_header, app_bottom_nav, network_image_box,
                             // loading_view, error_retry_view, empty_view
    <feature>/               // widgets used by one feature only (product_card, cart_item_tile, order_card, ...)
```
Rules:
- Screens contain layout composition and state only. No business logic, no http, no hardcoded colors, no raw numbers for spacing.
- Services are the ONLY place that talks to http or returns data. Screens call a service and pass the Future to a `FutureBuilder`. Until the real API is connected, a service returns dummy data with `Future.delayed`, so swapping to http later changes only the service files. Dummy data lives in `lib/services/dummy/`.
- `api_client.dart`: base url, headers (JSON + `Authorization: Bearer <token>`), timeouts, status code handling, mapping every failure (no internet, timeout, 400/401/404, bad JSON) to an `AppException` with a readable message. Services never catch errors themselves.
- Models: immutable (`final` fields, `const` constructor), `fromJson` handling nullable fields and int-or-double numbers safely.
- Validators and formatters (price "95 EGP", dates) live in core/utils and are reused, never rewritten inside screens.

## 3. Code quality rules (non-negotiable)
- One public widget per file. File names in snake_case, classes in PascalCase, clear names.
- A screen file is at most about 150 lines, a widget file at most about 120. If it grows, split it into widgets.
- Do NOT build UI blocks with `Widget _buildSomething()` helper methods. Extract them as `StatelessWidget` classes in their own files with `const` constructors.
- Never hardcode a color, font size, spacing, radius, shadow, route name, asset path or API path in a screen or widget. Use `AppColors`, `AppTextStyles`, `AppSpacing`, `AppRoutes`, `AppAssets`, `AppConfig`.
- Every tappable element has a real handler. Use Material buttons (`FilledButton`, `TextButton`, `IconButton`, `InkWell` with proper `borderRadius`) with a minimum 44x44 touch area. Never an inert `Container`.
- Always dispose controllers, focus nodes, animation controllers and timers. Check `mounted` after every `await` that precedes using the context.
- Prefer `const` everywhere possible. No `print`, no dead code, no commented-out code, no TODO left without a note in DESIGN_TODO.md.
- Comments are short and only explain why, in English.
- `analysis_options.yaml`: keep `flutter_lints` and add `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`, `avoid_print`, `use_build_context_synchronously`, `unused_import`.
- Allowed packages: `http`, `flutter_svg`, `shared_preferences`. Nothing else without asking the user.
- The font Plus Jakarta Sans is bundled in `assets/fonts` and declared in pubspec (no runtime download).

## 4. Design: Figma is the source of truth
Figma file: https://www.figma.com/design/j1m1xT6YPYTgTzvZwvYl9U/brewly?node-id=10-1632 (fileKey j1m1xT6YPYTgTzvZwvYl9U)
Frame ids: Profile 9:2, My Address 9:123, My Orders 9:214, Order Details 9:329, Order Success 9:427, Checkout 9:478, Cart 9:639, Product Details 9:785, Products List 9:847, Welcome 9:1470, Login 9:1502, Register 9:1554. Find Home and Explore with get_metadata (top-level frames only).

### How to translate Figma into Flutter
`get_design_context` returns React/Tailwind with absolute positions. It is a reference for VALUES, never a layout to copy.
- Translate Figma Auto Layout into `Column`/`Row`/`Wrap`/`Expanded`/`Flexible`, with spacing from the design tokens. Never copy absolute x/y coordinates, negative offsets, fractional width factors (like `widthFactor: 1.31`) or magic `Alignment` numbers. For cropped images use `ClipRRect` + `Image.asset(fit: BoxFit.cover)` inside a fixed-aspect box (`AspectRatio`).
- Extract tokens first into `core/theme`: colors, text styles (size, weight, height, letterSpacing), spacing scale (4, 8, 12, 16, 24, 32), radii (12, 16, 20, 24, pill), shadows, component sizes (input height 52, button height 56, nav bar height 64). Then use only tokens.
- Read each frame with the Figma MCP ONCE (the plan has a small quota) and save the values to `DESIGN_SPEC/<screen>.md`. Build from that file, never call Figma twice for the same frame. Also save `get_screenshot` of the frame as reference if you can view images.
- Fixed pixel heights are allowed only for things that are fixed in the design (inputs, buttons, avatars, nav bar, images). Text containers never get a fixed height or width.
- Export real images, avatars and icons from Figma (download_assets) to `assets/images` and `assets/icons`. Never use random placeholder photos or web URLs for dummy data. Ignore the fake phone chrome in the frames (status bar "9:41", battery icons, home indicator).

### Approved deviations from the Figma design (it has real flaws; these are the only allowed changes)
1. Login has a "Don't have an account? Create account" link, Register has "Already have an account? Login" (the design has no way to reach Register).
2. Sample passwords must satisfy the API rule: 6-10 chars with upper, lower, digit and symbol (example `Cairo@12`). Register shows a small helper text (12, muted) under the password field with the rule and validates with the real RegExp.
3. No discount code, strikethrough price, service fee or taxes (the API has none). Cart summary = Subtotal and Total. Checkout summary = Subtotal + Delivery (from the selected delivery method) = Total. Totals are computed from the items, never hardcoded, and match on every screen.
4. Bottom nav has 5 tabs exactly like Figma: Home, Explore, Cart (count badge), Orders, Profile. Active tab = emerald circle.
5. Country flag in the phone field is replaced by the text "+20".
6. Header titles are never cut: title in `Expanded` with ellipsis; drop the share button on Checkout; the location text uses `maxLines: 1` and ellipsis.
7. One input style everywhere (the beige filled style).
8. Elements with no real feature (notification bell, share, "more", Settings, Help & Support) are visual only and show a SnackBar "Coming soon".
Add any new deviation to this list and to DESIGN_NOTES.md before applying it.

## 5. Layout robustness (no overflow, ever)
- Every screen is wrapped in `SafeArea`; scrollable content uses `SingleChildScrollView`/`ListView`/`CustomScrollView`; forms stay usable with the keyboard open.
- Use `Expanded`/`Flexible` inside Rows with text; `maxLines` + `TextOverflow.ellipsis` on names, addresses and titles; `Wrap` for chips and pills.
- Product grids use `SliverGridDelegateWithFixedCrossAxisCount` with `mainAxisExtent` (not a guessed `childAspectRatio`).
- Bottom fixed elements (sticky buttons, the floating nav) must not cover the last item: add bottom padding equal to their height.
- Screens must work at widths 320, 360, 390, 430 and with text scale 1.3.

## 6. Verification (a screen is not done until all of this passes)
1. `flutter analyze` reports zero issues.
2. `flutter test` passes. For every screen there is a widget test in `test/screens/` that pumps it at 320x640, 360x800, 390x844 and 430x932, with text scale 1.0 and 1.3, and asserts `tester.takeException()` is null (overflow check). Use long names and long addresses in the test data.
3. Compare the result with the Figma screenshot of the frame (render a golden or run the app, if you can view images). Check the order of elements, spacing, font sizes, colors, radii and shadows. Fix every difference. If you cannot view images, check each value against `DESIGN_SPEC/<screen>.md` one by one.
4. Check the course requirements affected by the screen (form validation, setState, route arguments, FutureBuilder with loading and retry, animations).

## 7. API
Base URL: `AppConfig.baseUrl` (ask the user if it is missing). Android emulator reaches the PC at `10.0.2.2`. Protected endpoints need `Authorization: Bearer <token>` and `Content-Type: application/json`. Error body: `{ "statusCode": 400, "message": "..." }`: show `message` to the user.

| Purpose | Method + Path | Notes |
|---|---|---|
| Register | POST /api/Account/Register | displayName, email, phoneNumber, password. Password regex `^(?=.{6,10}$)(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^A-Za-z0-9]).*$`. Returns displayName, email, token |
| Login | POST /api/Account/Login | email, password. Returns displayName, email, token |
| Email exists | GET /api/Account/emailExisits?email= | boolean (the spelling is correct) |
| Current user | GET /api/Account | |
| Address | GET + PUT /api/Account/Address | firstName, lastName, street, city, country (all required) |
| Categories | GET /api/Products/categories | id, name, pictureUrl |
| Brands | GET /api/Products/brands | id, name (no image) |
| Products | GET /api/Products | PageSize, PageIndex, Search, sort, brandId, categoryId. Response: page_Index, page_Size, count, data[] (verify the real shape; the OpenAPI says array) |
| Product | GET /api/Products/{id} | 404 if missing |
| Basket | GET / POST / DELETE /api/Basket | POST body: productId, quantity (min 1). Returns id, items[] |
| Delivery methods | GET /api/Orders/DeliverMethods | id, shortName, description, cost, deliveryTime |
| Create order | POST /api/Orders | deliverMethodID, shippingAddress {firstName, lastName, street, city, country} |
| Orders | GET /api/Orders, GET /api/Orders/{orderId} | id, buyerEmail, shippingAddress, status, orderDate, items[], deliveryMethod, deliveryCost, subTotal, total, paymentIntentId |

## 8. Working method
- Work in small steps (one group of 2-3 screens, or one layer, at a time). Before the first step of a task: run `git status` and `flutter analyze` and tell me the state; never assume what is already done.
- After each step: analyze + tests clean, update the docs, then `git add .` and `git commit -m "<step>"`. Never `git push`, never `git reset --hard`, never delete files outside lib/, test/ and assets/.
- Keep `ARCHITECTURE.md` (max 1 page: folders, layers, data flow, how a screen gets its data) and `DESIGN_NOTES.md` (tokens and approved deviations) up to date. They help the student explain the project in the oral exam.
- Keep `DESIGN_TODO.md` with the screens that still differ from Figma.
- If the same error survives 3 attempts, undo that change, log it in DESIGN_TODO.md and move on.
- Build order: (1) core: tokens, theme, routes, assets, utils, errors; (2) shared widgets in widgets/common; (3) models + api_client + services (dummy data first); (4) screens group by group: auth (welcome, login, register, splash), home + explore + products list, product details + cart + checkout + order success, orders + order details, profile + address; (5) connect the real API one service at a time; (6) final pass over section 1 and section 6.