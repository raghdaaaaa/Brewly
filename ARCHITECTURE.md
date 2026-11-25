# Brewly – Architecture

Flutter coffee and food ordering app. Only the course techniques are used:
`StatefulWidget` + `setState`, `FutureBuilder`, named routes and the `http` package.
There are no state-management or code-generation packages.

## Layers (`lib/`)

| Layer | Location | Responsibility |
|---|---|---|
| Entry | `main.dart` | `runApp` + `MaterialApp` (theme, routes, initial route) |
| Core | `core/theme`, `core/routes`, `core/constants`, `core/utils`, `core/errors` | tokens, route table, asset paths, base URL, validators/formatters, `AppException` |
| Models | `models/` | immutable data classes with `fromJson` / `toJson` |
| Services | `services/` | the only layer that talks to HTTP; dummy data in `services/dummy/` |
| Screens | `screens/` | layout composition + local state (`setState`), calls services |
| Widgets | `widgets/common/`, `widgets/<feature>/` | reusable UI, no business logic |

Rules:

- A screen never calls `http` and never declares a raw color, font size, route name or
  asset path. It uses `AppColors`, `AppTextStyles`, `AppSpacing`, `AppRoutes`,
  `AppAssets`, `AppConfig`.
- `services/api_client.dart` owns the base URL, JSON headers, bearer token, timeout and
  maps every failure (network, timeout, 4xx/5xx, bad JSON) to `AppException` with a
  readable message. Endpoint services do not catch.
- `ApiClient.shared` is used by `ApiService`, `ProductService` and `BasketService`, so
  the token set by `AuthService` reaches every request.
- `AuthService` persists and restores the signed-in user and token with
  `shared_preferences`; `ApiClient.shared` adds the bearer token to protected requests.
- `BasketService` exposes shared `ValueNotifier`s for the item count and total; the
  floating nav badge and the current-order bar listen to the same values.

## Data flow

```
Splash → Welcome → Login ⇄ Register → Home shell (bottom nav)
                                       ├─ Home → Products List (filter/search)
                                       ├─ Home / Products List → Product Details
                                       ├─ Explore → Products List (category)
                                       ├─ Cart → Checkout → Order Success
                                       ├─ Orders → Order Details
                                       └─ Profile → My Address
```

- Login calls `AuthService.login`; Register calls `AuthService.emailExists` and then
  `AuthService.register`. Both show the loading state inside `PrimaryButton`, show the
  `AppException` message in a SnackBar, and on success replace the stack with Home.
- Home, Explore and Products List get categories, brands and products from
  `ProductService` (live API) and pass the `Future` to `FutureBuilder`, which renders a
  skeleton/spinner, `ErrorRetry` (Retry re-creates the future) or the data. Search,
  category and brand filters go to the API; Products List appends the next page with
  Load More.
- Products List passes the tapped `Product` to Product Details through the named route
  as `{'product': Product, 'heroPrefix': String}`. The same `heroPrefix` keeps the Hero
  tags unique across tabs that stay alive in `MainScreen`'s `IndexedStack`.
- Product Details accepts that map, a `Product`, or an `int` product id. With only an
  id it calls `ProductService.getProduct(id)` and shows `FutureBuilder` loading/error
  states. The Add to cart button sends `POST /api/Basket` with
  `{productId, quantity}`. The live API **sets** the quantity of an existing line (it
  does not add to it); the screen sends the selected quantity as the new value.
- Cart reads the live basket from `BasketService`; Checkout loads delivery methods and
  submits orders through its services. Totals are computed from the line items and the
  selected delivery method.
- Orders passes the `Order` to Order Details; Profile and Checkout share the same address
  form widgets and `AppTextField`.
- Order Success is pushed after checkout clears the cart and shows the new order id
  passed as a route argument.

## State of the project

- Core is complete: tokens, routes, assets, config, validators, formatters, errors.
- Batches 1–2 are complete: auth screens, Home, Explore and Products List are connected
  to the live API and have 4-size × 2-text-scale widget tests.
- Batch 3a: Product Details is rebuilt from the PNG with the Hero image, local favorite,
  quantity stepper, live total, auth guard and `POST /api/Basket`.
- Cart, Checkout, Orders, Order Details, Profile and My Address use their domain
  services for live API data. Order Success displays the result passed from Checkout.
