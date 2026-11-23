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

## Global (phase 2 screen rebuild)

- [ ] Add `DESIGN_SPEC/<screen>.md` for: Home, Explore, Products List, Product Details,
      Cart, Checkout, Order Success, My Orders, Order Details, Profile, My Address.
- [ ] Replace the remaining raw spacing / radius / size numbers in screens with
      `AppSpacing`, `AppRadius`, `AppSizes`.
- [ ] Replace `Widget _buildSomething()` helpers with `StatelessWidget` classes in their
      own files (one public widget per file).
- [ ] Add `SafeArea` to Login, Register and Welcome; keep forms usable with the keyboard
      open.
- [ ] Move feature widgets to `widgets/<feature>/` and shared ones to `widgets/common/`.
- [ ] Add the per-screen `test/screens/<screen>_test.dart` at 320×640, 360×800, 390×844,
      430×932 with text scale 1.0 and 1.3.

## Screens

- [x] **Home** (Group 2, first pass from DESIGN_NOTES; no promo card / brand pills yet,
      first `mainAxisExtent` product grid; product cards are the overlay design).
- [x] **Explore** (Group 2; first pass).
- [x] **Products List** (Group 2; first pass).
- [ ] **Splash** – logo is still the default icon + text; add the AnimationController
      fade/scale and the exported logo.
- [ ] **Welcome** – replace `FractionallySizedBox(1.3123)` and the absolute offsets with
      `ClipRRect` + `AspectRatio`; verify hero and CTA against the frame.
- [ ] **Login / Register** – first-pass layout, not the Figma frames. Register still
      needs the password helper text and the real API RegExp. Phone field still shows
      the flag instead of the approved "+20".
- [x] **Product Details** (Group 3; structurally complete, overflow-proofed).
- [x] **Cart** (Group 3; overflow-proofed).
- [x] **Checkout** (Group 3; delivery cards replaced with overflow-proof rows,
      `_placeOrder` navigates to Order Success).
- [x] **Order Success** (Group 3; pushed from checkout with the new order id).
- [ ] **Orders** – order cards and status pills are first-pass; bottom sheet needs the
      frame values.
- [ ] **Profile** – header card and menu rows do not match the Figma layout (avatar
      corner, menu rows, section list).
- [ ] **Images** – dummy products still use picsum URLs. Export real product images to
      `assets/images` and reference them through `AppAssets`.

## Approved deviations still to apply

- [ ] Register password helper text (12, muted) + RegExp validator (deviation 2).
- [ ] Phone field: "+20" instead of the flag (deviation 5).
- [ ] "Coming soon" SnackBar for visual-only buttons (deviation 8).

## Done

- [x] Group 1: bugs + core refactor (Group 1 commit).
- [x] Group 2: Home, Explore, Products List.
- [x] Group 3: Product Details, Cart, Checkout, Order Success.
