# Brewly – Design TODO

Screens are not Figma-final yet. This file tracks what still differs and what phase 2
must fix.

## Log

- Figma MCP tool-call limit reached on the Starter plan (checked with whoami).
  Frames NOT read: Home 9:1158, Explore 9:1046, Products List 9:847, Product Details
  9:785, Cart 9:639, Checkout 9:478, Order Success 9:427, My Orders 9:214,
  Order Details 9:329, Profile 9:2, My Address 9:123.
- Group 2 (Home, Explore, Products List) built from `DESIGN_NOTES.md` + new tokens
  (no `DESIGN_SPEC/` files for them yet). `ProductCard` structure: the old
  `Expanded(child: Stack(...))` is rejected by the SDK ("Expanded wants FlexParentData,
  Stack accepts StackParentData") — rewritten as `Card > InkWell > Stack(fit: expand)`
  with the name/price overlay at the bottom of the image.
- AppBottomNav 5-tab pill bar: the cart tab is a plain `InkWell` inside an
  `Expanded` (the badge `Stack` around it rejects an `Expanded` child).
- Batch 1: `figma_screens/` is missing from the repository (only `DESIGN_SPEC/*.md`
  exists), so Welcome/Login/Register were built from the spec sheets and checked with
  rendered previews. A pixel diff against the PNGs is still pending.
- Batch 3a: the Product Details PNG (`C:\Users\ra9hdaa\Downloads\Product Details.png`)
  was used as the design source. The screen is built and tested; the golden preview
  cannot show the real coffee photo because it is a network URL and tests block HTTP.

## Global (phase 2 screen rebuild)

- [ ] Add `DESIGN_SPEC/<screen>.md` for: Home, Explore, Products List, Product Details,
      Cart, Checkout, Order Success, My Orders, Order Details, Profile, My Address.
- [ ] Replace the remaining raw spacing / radius / size numbers in screens with
      `AppSpacing`, `AppRadius`, `AppSizes`.
- [ ] Replace `Widget _buildSomething()` helpers with `StatelessWidget` classes in their
      own files (one public widget per file).
- [x] Add `SafeArea` to Login, Register and Welcome; forms scroll with the keyboard open.
- [ ] Move the remaining feature widgets to `widgets/<feature>/`.
- [x] Add the per-screen tests for Welcome, Login and Register at 320×640, 360×800,
      390×844, 430×932 with text scale 1.0 and 1.3 (the other screens already have them).
- [ ] Migrate the remaining local CTA buttons (Cart, Checkout, Address, Order Success)
      to the shared `PrimaryButton` in their own batch. Product Details keeps its own
      pill because the label includes the live total and the bag icon.

## Screens

- [x] **Home** (Batch 2: header, greeting + points, delivery card, promo, category rail,
      brand pills, popular product cards; live API + FutureBuilder).
- [x] **Explore** (Batch 2: 2-column category image grid from the API).
- [x] **Products List** (Batch 2: filters, search, sort, pagination, current-order bar;
      live API).
- [x] **Splash** – explicit `AnimationController` fade + scale, disposed correctly, then navigates to Welcome with a named route (logo is still the Material coffee icon; no logo asset exists yet).
- [x] **Welcome** – rebuilt from `DESIGN_SPEC/welcome.md` with `AspectRatio` hero,
      centered promise, 24 gap and the shared `PrimaryButton`; opens Login by named route.
- [x] **Login** – rebuilt from `DESIGN_SPEC/login.md`: white 52 fields, green email
      check, password eye, loading CTA, API error SnackBar, API success → Home.
- [x] **Register** – rebuilt from `DESIGN_SPEC/register.md`: white form card, four
      fields, flag + "+20", password helper + RegExp, email availability check, loading
      CTA, API success → Home.
- [x] **Product Details** (Batch 3a: rebuilt from the PNG; fixed header and purchase
      bar, 276 hero, favorite animation, live total, auth guard, API add-to-cart).
      Remaining: compare the real photo frame after running the app; the golden preview
      uses the network placeholder.
- [x] **Cart** (Group 3; overflow-proofed).
- [x] **Checkout** (Group 3; delivery cards replaced with overflow-proof rows,
      `_placeOrder` navigates to Order Success).
- [x] **Order Success** (Group 3; pushed from checkout with the new order id).
- [x] **Orders** (Group 4; order cards tap to Order Details).
- [x] **Order Details** (Group 4; new screen, items + address + summary).
- [x] **Profile** (Group 4; "My Address" row navigates to the new Address screen).
- [x] **My Address** (Group 4; new screen with a validated address form).
- [x] **Images** – Home, Explore and Products List use the `pictureUrl` from the API;
      a broken/relative URL falls back to the local cafe placeholder.
- [ ] **Product Details photo** – the hero uses the API `pictureUrl`; verify the crop of
      the real photo on a device (the widget tests show the placeholder).

## Approved deviations still to apply

- [x] Register password helper text (12, muted) + RegExp validator (deviation 2).
- [x] Phone field: 🇪🇬 flag emoji + "+20" (Batch 1 instruction, supersedes deviation 5).
- [x] Shared `AppTextField` used by Login, Register, Checkout and My Address.
- [ ] "Coming soon" SnackBar for the remaining visual-only buttons (deviation 8).

## Done

- [x] Group 1: bugs + core refactor (Group 1 commit).
- [x] Group 2: Home, Explore, Products List.
- [x] Group 3: Product Details, Cart, Checkout, Order Success.
- [x] Group 4: My Orders, Order Details, Profile, My Address.
