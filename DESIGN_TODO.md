# Brewly – Design TODO

Screens are not Figma-final yet. This file tracks what still differs and what phase 2
must fix.

## Global (phase 2 screen rebuild)

- [ ] Replace the remaining raw spacing / radius / size numbers in screens with
      `AppSpacing`, `AppRadius`, `AppSizes`.
- [ ] Replace `Widget _buildSomething()` helpers with `StatelessWidget` classes in their
      own files (one public widget per file).
- [ ] Add `SafeArea` to Login, Register and Welcome; keep forms usable with the keyboard
      open.
- [ ] Move feature widgets to `widgets/<feature>/` and shared ones to `widgets/common/`.
- [ ] Bottom nav needs 5 tabs exactly like Figma: Home, Explore, Cart (count badge),
      Orders, Profile. Current code has 4 and no badge.
- [ ] Add the per-screen `DESIGN_SPEC/<screen>.md` files (only `DESIGN_NOTES.md` exists).
- [ ] Add `test/screens/<screen>_test.dart` at 320×640, 360×800, 390×844, 430×932 with
      text scale 1.0 and 1.3.

## Screens

- [ ] **Splash** – logo is still the default icon + text; add the AnimationController
      fade/scale and the exported logo.
- [ ] **Welcome** – replace `FractionallySizedBox(1.3123)` and the absolute offsets with
      `ClipRRect` + `AspectRatio`; verify hero and CTA against the frame.
- [ ] **Login / Register** – first-pass layout, not the Figma frames. Register still
      needs the password helper text and the real API RegExp. Phone field still shows
      the flag instead of the approved "+20".
- [ ] **Home** – missing promo card and brand pills; product grid uses
      `childAspectRatio: 0.70`, switch to `mainAxisExtent`; no Explore tab yet.
- [ ] **Product Details** – structure is close; verify image ratio, quantity stepper and
      sticky bar against the frame.
- [ ] **Cart** – summary is not a Figma card yet; empty state and item cards need the
      frame values.
- [ ] **Checkout** – delivery methods and summary use Material defaults; verify spacing
      and card radii.
- [ ] **Orders** – order cards and status pills are first-pass; bottom sheet needs the
      frame values.
- [ ] **Profile** – header card and menu rows do not match the Figma layout (avatar
      corner, menu rows, section list).
- [ ] **Images** – dummy products still use picsum URLs. Export real product images to
      `assets/images` and reference them through `AppAssets`.

## Approved deviations still to apply

- [ ] Register password helper text (12, muted) + RegExp validator (deviation 2).
- [ ] Phone field: "+20" instead of the flag (deviation 5).
- [ ] Cart badge on the bottom nav (deviation 4).
- [ ] "Coming soon" SnackBar for visual-only buttons (deviation 8).

## Done in phase 1

- [x] Core folders: `theme/`, `routes/`, `constants/`.
- [x] `AppTextStyles`, `AppSpacing`, `AppRadius`, `AppSizes`.
- [x] `constants.dart` removed; all colors, routes and asset paths use tokens.
- [x] Dummy data moved to `lib/services/dummy/dummy_data.dart`.
- [x] Auth switch links (Login ↔ Register) and `Cairo@12` sample password.
- [x] Register brand mark no longer overflows (pill instead of a 40 px circle).
