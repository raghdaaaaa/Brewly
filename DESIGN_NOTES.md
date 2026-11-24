# Brewly – Design Notes

Source: Figma file `j1m1xT6YPYTgTzvZwvYl9U`, node `10:1632` ("Section 4").
Read once with the Figma MCP and written down here. **This file is the only design
reference used from now on – Figma is not called again.**

Canvas width of every screen: **390 px**.

---

## 1. Frames found in the section (14)

| # | Frame name | Size | Used for |
|---|---|---|---|
| 1 | Profile | 390×884 | `profile_screen.dart` |
| 2 | My Address | 390×884 | form **inside** Profile (no separate screen) |
| 3 | My Orders | 390×884 | `orders_screen.dart` |
| 4 | Order Details | 390×884 | **skipped** → BottomSheet in Orders |
| 5 | Order Success | 390×884 | **skipped** → AlertDialog + go to Orders |
| 6 | Checkout | 390×1149 | `checkout_screen.dart` |
| 7 | Cart | 390×884 | `cart_screen.dart` |
| 8 | Product Details | 390×884 | `product_details_screen.dart` |
| 9 | Products List | 390×1074 | grid/list pattern reused in Home |
| 10 | Explore | 390×884 | **skipped** → categories + products live in Home |
| 11 | Home | 390×1533 | `home_screen.dart` |
| 12 | Welcome & Onboarding | 390×884 | **skipped** |
| 13 | Login | 390×884 | `login_screen.dart` |
| 14 | Register | 390×884 | `register_screen.dart` |

There is no Splash frame – the splash is logo only (fade + scale, 2 s).

---

## 2. Colors (exact, from the file)

| Token | Hex | Where it is used |
|---|---|---|
| Background / cream | `#FDF9F3` | every screen background, header background (90 % opacity) |
| Card / white | `#FFFFFF` | cards, input fields, bottom nav pill (95 % opacity) |
| Text / ink | `#1C1B18` | headings, prices, body text |
| Muted text | `#3F4944` | labels, helper text, secondary lines |
| Primary / deep emerald | `#00513A` | primary buttons, active nav icon, brand mark |
| Accent / butter | `#FCCB57` | promo card, badges, highlight |
| Accent dark text | `#251A00` | text on the yellow promo card |
| Soft surface | `#F8F3ED` | inner cards, chips background |
| Soft surface 2 | `#F2EDE8` | quantity stepper background |
| Border / hairline | `#ECE7E2` | dividers, input borders |
| Emerald tint | `#A1F3CF` | "in preparation" chip, success accents |
| Warning text | `#785A00` | warning chip text |
| Error | `#BA1A1A` | validation errors, cancel |

Shadows: very soft – `#000000` 5 % `y1 blur2` on cards, `#0E6B4F` 6 % `y4 blur20` on
floating elements, `#1C1B18` 8 % `y12 blur32` on the bottom nav.

> These values live in `lib/core/theme/app_colors.dart` (`AppColors`). No screen
> declares a raw color.

---

## 3. Typography

The design uses **Plus Jakarta Sans**, bundled in `assets/fonts` and declared in
`pubspec.yaml` (no runtime download). The sizes / weights / line heights below are the
`AppTextStyles` tokens in `lib/core/theme/app_text_styles.dart`.

| Role | Size | Weight | Line height | Example |
|---|---|---|---|---|
| Display | 30 | 700 | 38 | "Welcome Back", "Create Account" |
| Heading 1 | 24 | 700 | 32 | "My Orders", "Good evening, Omar" |
| Heading 2 | 20 | 600 | 26 | "Estimated Total", "Popular Right Now" |
| Price / title | 18 | 700 | 22 | "275 EGP", "Total Paid" |
| Section title | 18 | 600 | 24 | "Product Detail", "Delivery Address" |
| Body strong | 16 | 600 | 22 | menu rows, button labels |
| Body | 16 | 400 | 24 | paragraphs |
| Body small | 14 | 400 | 20 | "Subtotal", email |
| Body small strong | 14 | 600 | 20 | "Save address", "−60 EGP" |
| Field label | 12 | 600 | 16 | "First name *", "City *" |
| Tag / uppercase | 11 | 700 | 14 | "IN PREPARATION", "BREWLY ROASTERS" |
| Micro | 10 | 600 | 15 | "Bestseller", "V60" |

---

## 4. Spacing, sizes and radii

- Screen horizontal padding: **16**.
- Gap between sections: **24**. Gap between form fields: **16**.
- Card padding: **16**.
- Field: label 16 high + **6** gap + input **52** high (radius **16**).
- Primary button: height **56**, full width, radius **9999** (pill).
- Header: status 29 + **64** tall bar = 93.
- Bottom navigation: floating white pill, height **64**, radius **9999**, 10 px from the bottom.
- Avatar: 96 circle.

Corner radius usage (count in file):

| Radius | Use |
|---|---|
| `9999` | buttons, chips, pills, bottom nav, search bar |
| `20` | product cards, order cards, promo card |
| `16` | form card, inputs, summary card |
| `14` / `12` | small inner cards, quantity stepper, images |
| `8` | badges |

---

## 5. Layout per screen (short)

**Login** – back arrow, 64 circular brand emblem, "Welcome Back" (30/700),
email field, password field, pill "Sign in" button, "Create account" text button.
Everything in one column, 16 padding, no AppBar, form gap 16.

**Register** – back arrow + brand pill on top, "Create Account" (30/700), white card
(radius 16, padding 16, gap 16) with 4 fields: Display name, Email, Phone, Password
(show/hide eye), then pill "Create account" button.

**Home** – greeting row ("Good evening, Omar" 24/700) + delivery address line,
pill search field (44 high) with filter icon, yellow promo card (radius 20),
horizontal category rail (pill chips, selected = emerald filled), brand pills row,
"Popular Right Now" 20/600 and a **2-column grid** of product cards
(white, radius 20, image on top, heart top-right, name 14/600, price 16/700).
Bottom navigation: Home · Cart · Orders · Profile.

**Product Details** – back circle + "Product Detail" 22/600 + share circle + avatar,
hero image 370×276 radius 24 with a white 41 favorite circle, name 28/700 + price
30/700 with a 14 EGP, description 16/24, fixed bottom bar with a 128×58 white quantity
stepper and a 58 green "Add to cart · total EGP" pill.

**Cart** – header "Your Cart", list of items (white card radius 16, 72 image,
name 14/600, unit price 12/400, quantity stepper), order summary card
(Subtotal / Delivery / Total), "Clear cart" text button, "Checkout" pill button.
Empty state: icon + text + "Browse menu".

**Checkout** – section 1 address form (First name + Last name in a row, Street,
City + Country in a row), section 2 delivery methods as RadioListTile rows in a card,
section 3 cost summary, "Place order" pill button.

**Orders** – header "My Orders", order cards (radius 20, padding 14):
order number 16/700 + status chip (emerald tint / grey / red), date 12/400,
item count + total 18/700. Tap → BottomSheet with details.

**Profile** – header card (radius 20, emerald tint corner, 96 avatar with initials,
name 24/700, email 14/400), menu rows 76 high with 44 icon square + label 16/600 +
chevron, "My Address" opens the address form (4 fields + "Save address"),
"Log out" row in error color with confirm AlertDialog.

---

## 6. Rules applied when translating to Flutter

- Design is a **reference for colors, spacing and layout only** – built with plain
  `Scaffold / AppBar / Column / Row / Stack / Container / Card / ListView / GridView`.
- Secondary text, promo badges, status timelines, copyable IDs and checklists from
  the Figma file are skipped to keep every screen beginner-level and uncluttered.
- All dummy data lives in `lib/services/dummy/dummy_data.dart` until the API step.

---

## 7. Core tokens implemented in phase 1

| File | Contents |
|---|---|
| `lib/core/theme/app_colors.dart` | `AppColors`: every color above, plus shadow and hero-fade tints |
| `lib/core/theme/app_text_styles.dart` | `AppTextStyles`: display, headings, body, form, buttons, chips, avatar |
| `lib/core/theme/app_spacing.dart` | `AppSpacing` (4/8/12/16/24/32), `AppRadius` (12/16/20/24/pill), `AppSizes` (input 52, button 56, nav bar 64) |
| `lib/core/constants/app_assets.dart` | `AppAssets`: every icon and image path |
| `lib/core/constants/app_config.dart` | `AppConfig.baseUrl` |
| `lib/core/routes/app_routes.dart` | `AppRoutes`: route names + route table |

Approved deviations already applied:

1. Login has "Don't have an account? Create account" under the button (opens Register);
   Register has "Already have an account? Login" under the button (opens Login).
2. Login and Register are prefilled with `Cairo@12`, a password that satisfies the API
   rule. Register shows the helper text and the real RegExp validator. All forms use the
   shared `AppTextField` (no fixed height, so errors push the next field down).
3. The Welcome "Get Started" button is unchanged.
4. The country flag in the phone field is replaced by the text "+20" (the design has no
   flag asset and the API only needs the dialling code).
5. The shared `AppTextField` has two surfaces from the two frames: `card` (white with a
   soft shadow, Login) and `filled` (beige, Register and the other forms). Labels,
   radius, error/helper layout, touch targets and focus state are identical.
6. `MaterialApp.builder` clamps the system text scale to 1.0 so the phone font setting
   cannot enlarge the design.

## 8. Batch 1 – Welcome / Login / Register

Values come from `DESIGN_SPEC/welcome.md`, `login.md` and `register.md` (the
`figma_screens/` PNGs are not in the repository, so the pixel diff against them is still
pending).

- Type scale: screen title 30/38 bold, body 14, field label 12/16, button 14. Nothing
  is above the requested caps (32 title, 14 body, 16 button).
- Screen padding 16. Auth input 52 high, radius 12 (the Login/Register frames), 6 gap
  label→field, 16 between fields. Cards are white, radius 16 (form) / 24 (Welcome hero),
  padding 16.
- Welcome: 56 brand circle with steam + butter dots, 24 wordmark, white hero card radius
  24 with a 256-high illustration, centered 24/30 title in ink and emerald, 24 gap, then
  the 56-high pill CTA.
- Login: 44 back button, 64 emblem, 30 title, white 52 fields with soft shadow, green
  check when the email is valid, eye toggle, 56 CTA, Register switch link.
- Register: 44 back button + BREWLY chip, 30 title, white form card radius 16 p16, four
  fields, 100×52 country pill with 🇪🇬 + "+20", helper text under the password, 56 CTA.
- `PrimaryButton` is the single CTA everywhere in this batch: 56 high, pill, emerald,
  white 14 label + arrow, and a spinner inside the same pill while a request runs.

## 9. Batch 3a – Product Details (from `Product Details.png`)

The PNG is 1752 px wide for a **402 dp** frame (scale 4.36); side padding is 16. The
screen keeps the fixed top bar and purchase bar while only the middle scrolls.

| Element | Value |
|---|---|
| Top bar | back circle 46, title 22/28 w600, share circle 45, avatar 34, gaps 16/8 |
| Hero | width 370 (16 side padding), height 276, radius 24, `BoxFit.cover` |
| Favorite | white circle 41, 12 from the top-right of the image, heart 21 |
| Summary gap | 19 between image and name row; 20 between name row and description |
| Name | 28/33 w700, max 2 lines, ellipsis |
| Price | 30/36 w700 emerald number + 14/18 w500 muted "EGP", baseline aligned |
| Description | 16/24 w400 muted, scrolls with the page |
| Bottom bar | 16 side padding, 12 gap, two 58-high pills, bottom `SafeArea` |
| Stepper | white 128×58 pill, 44-wide minus/number/plus, 22/28 w700 number, min 1 / max 99 |
| CTA | emerald pill fills the rest, bag icon 20 + 17/22 w600 white label, spinner while posting |

The PNG has no brand chip, category pill or "About this item" heading, so the rebuilt
screen does not add them. Tokens: `detailsTopBarTitle`, `detailsProductName`,
`detailsPrice`, `detailsPriceCurrency`, `detailsDescription`, `detailsQuantity`,
`detailsAddToCart`; `AppSizes.details*` and `AppSizes.purchaseBarHeight`.

Behavior: the heart is local-only with an `AnimatedSwitcher` scale, the quantity number
uses a fade switcher and the total updates live, share shows a SnackBar, and Add to cart
asks the user to log in when there is no session. `POST /api/Basket` was verified live:
it **replaces** the quantity of an existing line (`qty 1 → 2 → 1` came back as 1, 2, 1).
