# Register — Figma frame 9:1554 (Register)

Screen: 390 × 884. Background: #FDF9F3.

## Element order (top to bottom)
1. Top App Navigation / Brand Mark (Row, justify-between, py-8, w-full):
   - Button - Go back: Container 40×40, bg #F8F3ED, radius 9999, drop-shadow [0px_1px_1px rgba(0,0,0,0.05)], contains register_back_arrow (13.333×13.333, #1C1B18).
   - Brand Chip: white circle 24×24 (radius 9999) with drop-shadow [0px_1px_1px rgba(0,0,0,0.05)], bg #00513A, contains register_brand_icon (11.25×11.25 white); beside it text "BREWLY" — Plus Jakarta Sans Bold 12px, letterSpacing 0.6, lineHeight 16px, color #00513A, uppercase.
   - Rectangle: 40×40 empty placeholder.
2. Screen Header: "Create Account" — Plus Jakarta Sans Bold 30px, letterSpacing -0.6, lineHeight 38px, color #1C1B18, w-full.
3. Registration Form Card (white, drop-shadow [0px_1px_1px rgba(0,0,0,0.05)], radius 16, gap 16, p 16, w-full):
   - 1. Display Name Field (gap 6):
     - Label "Display Name": Plus Jakarta Sans SemiBold 12px, letterSpacing 0.24, lineHeight 16px, color #1C1B18.
     - Input (h 52, bg #F8F3ED, radius 12, px 16, py 17): text "Omar El-Sayed" — Regular 14px, lineHeight normal, color #1C1B18; right icon register_input_right (16.667×16.667, #00513A) at right 14px, top 16px.
   - 2. Email Field with Live Availability check (gap 6):
     - Label "Email Address": SemiBold 12px, letterSpacing 0.24, lineHeight 16px, color #1C1B18.
     - Input (same style): text "omar.sayed@cairobrew.com".
   - 3. Phone Number Field (Egyptian mobile) (gap 6):
     - Label "Egyptian Phone Number": SemiBold 12px, letterSpacing 0.24, lineHeight 16px, color #1C1B18.
     - Row (gap 8):
       - Country prefix pill: bg #F8F3ED, gap 6, h 52, px 14, radius 12: text "🇪🇬" (16px, #1C1B18); text "+20" — Plus Jakarta Sans SemiBold 12px, letterSpacing 0.24, color #00513A; register_phone_prefix icon (8×4.933, #6F7A73).
       - Input area (h 52, bg #F8F3ED, radius 12, px 16, py 17): text "10 2345 6789" — Regular 14px, lineHeight normal, color #1C1B18; right icon register_phone_right (11.25×16.5, #BEC9C2) at right ~14px.
   - 4. Password Field with Show/Hide Toggle (gap 6):
     - Label "Password": SemiBold 12px, letterSpacing 0.24, lineHeight 16px, color #1C1B18.
     - Input (h 52, bg #F8F3ED, radius 12, px 16, pr 48, py 17): text "CairoBrew!9" — Regular 14px, letterSpacing 0.7, color #1C1B18; toggle button Container 32×32, radius 8, with register_toggle_eye (18.333×12.5, #6F7A73).
   - Action Button (h 56, w-full, radius 9999, gap 8): bg #00513A, shadow [0px_4px_6px_-1px rgba(0,0,0,0.1), 0px_2px_4px_-2px rgba(0,0,0,0.1)]; text "Create account" — Plus Jakarta Sans Bold 14px, letterSpacing 0.14, lineHeight 20px, color #FFFFFF; right icon register_cta_arrow (13.333×13.333, white).
4. Bottom overlay pill: h 4, w 128, radius 9999, centered, bg rgba(28,27,24,0.2).

Dummy text: displayName "Omar El-Sayed", email "omar.sayed@cairobrew.com", phone "10 2345 6789", password "CairoBrew!9".
On success: navigate to homeRoute (after account creation).
