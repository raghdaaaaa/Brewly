# Brewly – Architecture

Flutter coffee and food ordering app. Only the course techniques are used:
`StatefulWidget` + `setState`, `FutureBuilder`, named routes and the `http` package.
There are no state-management or code-generation packages.

## Layers (`lib/`)

| Layer | Location | Responsibility |
|---|---|---|
| Entry | `main.dart` | `runApp` + `MaterialApp` (theme, routes, initial route) |
| Core | `core/theme`, `core/routes`, `core/constants` | design tokens, route table, asset paths, base URL |
| Models | `models/` | immutable data classes; `fromJson` is added in the API step |
| Services | `services/` | the only layer that talks to HTTP; dummy data in `services/dummy/` |
| Screens | `screens/` | layout composition + local state (`setState`), calls services |
| Widgets | `widgets/`, `widgets/common/` | reusable UI, no business logic |

Rules:

- A screen never calls `http` and never declares a raw color, font size, route name or
  asset path. It uses `AppColors`, `AppTextStyles`, `AppSpacing`, `AppRoutes`,
  `AppAssets`, `AppConfig`.
- `services/api_client.dart` (API step) owns the base URL, headers, timeouts and maps
  every failure to `AppException` with a readable message. Services do not catch.
- Dummy data sits in `services/dummy/dummy_data.dart`, so replacing it with real calls
  changes only the service files.

## Data flow

```
Splash → Welcome → Login / Register → Home shell (bottom nav)
                                        ├─ Home → Product Details (route argument: Product)
                                        ├─ Cart → Checkout
                                        ├─ Orders → bottom sheet with the order
                                        └─ Profile → address form
```

- Home owns the selected category, the search text, the favorite ids and
  `_productsFuture`. The future comes from the product service (currently
  `Future.delayed` + dummy list) and is passed to `FutureBuilder`, which renders
  `LoadingIndicator`, `ErrorRetry` (with Retry that re-creates the future) or the grid.
- The selected `Product` travels to Product Details as a named-route argument
  (`ModalRoute.of(context)!.settings.arguments`), never through a global variable.
- Cart and Checkout read the shared dummy basket and delivery methods. Every total is
  computed from the item line totals; nothing is hardcoded per screen.
- Profile and Checkout share the same address form widgets and dummy address.

## State of the project (end of phase 1)

- Core is complete: tokens, routes, assets, config, dummy data under `services/dummy/`.
- Screens are still the first working version: some use `_build...` helper methods and
  raw spacing numbers; phase 2 rebuilds them on the tokens and moves shared widgets into
  `widgets/common/`.
- `services/api_service.dart` and `auth_service.dart` are placeholders; models do not
  have `fromJson` yet. The API connection is step 5 of the build order.
