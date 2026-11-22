# Welcome & Onboarding — Figma frame 9:1470 (Welcome & Onboarding)

Screen: 390 × 884. Background: #FDF9F3.

## Element order (top to bottom)
1. Container (w-full, pb-32):
   - Top Brand Navigation / Header (flex column isolate, items-center, justify-center, pb-16, pt-8, w-full):
     - Margin (w 56, h 68):
       - Background (56×56): bg #00513A, radius 9999.
       - Overlay+Shadow (absolute): shadow [0px_4px_6px_-1px rgba(0,81,58,0.2), 0px_2px_4px_-2px rgba(0,81,58,0.2)].
       - Animated / Stylized Steam Accent (18×18, assets/icons/welcome_steam.svg).
       - Two butter dots (8×8, bg #FCCB57) at top-right (right 10, top -4): one with opacity 0.75, one solid.
     - Container: text "Brewly" — Plus Jakarta Sans Bold 24px, letterSpacing -0.6, lineHeight 32px, color #1C1B18; beside it a butter dot (6×6, bg #FCCB57).
   - Section - Hero Visual Card:margin (pb-24, w-full):
     - Section - Hero Visual Card (white, radius 24, shadow [0px_1px_2px_0px rgba(0,0,0,0.05)], pb-20, w-full):
       - Container (h 256, w-full):
         - Welcome photo (assets/images/welcome_hero.png): positioned left -15.61%, width 131.23%, h-full.
         - Gentle ambient tint overlay (gradient-to-t from white, opacity 90).
       - Content Narrative: w 326:
         - Line 1: "Artisanal Coffee & Pastries," — Plus Jakarta Sans Bold 24px, letterSpacing -0.6, lineHeight 30px, color #1C1B18.
         - Line 2: "Delivered Fresh." — Plus Jakarta Sans Bold 24px, letterSpacing -0.48, lineHeight 32px, color #00513A.
   - Bottom Action Buttons (w-full):
     - Button - Primary CTA (bg #00513A, h 56, radius 9999, gap 8, w-full; shadow [0px_4px_6px_-1px rgba(0,81,58,0.25), 0px_2px_4px_-2px rgba(0,81,58,0.25)]): text "Get Started" — Plus Jakarta Sans SemiBold 14px, letterSpacing 0.14, color #FFFFFF; right icon register_cta_arrow (13.333×13.333, white).
4. Bottom overlay pill: h 4, w 128, radius 9999, centered, bg rgba(28,27,24,0.2).

Flow: "Get Started" navigates to Login.
