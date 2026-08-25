# Design System — novel_ui

Captured from `lib/src/tokens/`, `lib/src/theme/`, and the recovered
official-app references (see `../webnovel_design_reference/`).

## Theme

Two app-level brightnesses plus **six reader paper themes** that decouple
the reading surface from the app theme. Reader papers: white, parchment,
mint, slate-gray, kraft, night. App chrome follows the platform light/dark
switch; the reader can be sepia while the shell is dark.

## Color Palette

Semantic roles live on `NovelColorScheme`; presets: default gold,
`webnovel` (official 2024 blue), and `NovelPlatformPresets` (Wattpad /
GoodNovel / RoyalRoad).

| Role | Light | Dark |
|---|---|---|
| primary | #FFB100 gold | #FFB100 |
| onPrimary | #000 | #000 |
| background | #F7F7F8 | #101012 |
| surface | #FFFFFF | #1A1A1E |
| surfaceLow | #F1F1F3 | #242428 |
| textPrimary | #1F1F24 | #F2F2F5 |
| textSecondary | #6E6E77 | #A2A2AC |
| textTertiary | #9B9BA4 | #6E6E78 |
| border | #E4E4E8 | #2E2E34 |
| updateDot / error | #FF4D4F / #E5484D | same |
| success | #30A46C | same |
| coin | #FFC53D | same |
| vip | #B8860B | same |

Reader inks are tuned per paper (e.g. parchment ink `#3D3729` on
`#F6F1E5`; night ink `#A6A6AD` on `#15151A`) — see
`lib/src/theme/novel_color_scheme.dart`.

## Typography

System stack; optional app-wide override via `NovelThemeData.fontFamily`.
UI scale: display 21/w900 · section title 17/w800 · card title
14–16/w700–800 · body 13.5–14/w400–500 h1.4–1.6 · meta 11–12.
Reader body defaults 18sp, line-height 1.7, user-adjustable 12–32.

## Spacing & Shape

Scale (NovelDimens): xs 4 · sm 8 · md 12 · lg 16 · xl 20 · xxl 24 · xxxl 32.
Screen padding 16. Radii: chips 6–8 · cards 12–16 · sheets 20 · pills 999.
Cover aspect 3:4, grid width 104, list width 76.

## Components

Book cards (grid/rail/list), rank rows with tier-colored numerals,
podium ranking, chapter tiles (read/locked/VIP), unlock sheet, coin badge,
power-stone vote, rating bar (adjustable), review axes, comment tiles +
paragraph-comment sheet, banner carousel, search suggestions, achievement
medals, wait-or-pay countdown tile, reading-list picker, full reader.

## Motion

150ms micro / 250ms standard / 400ms scene. Easing: easeOutCubic for page
slides, easeOutBack only on the vote-button pop. No bounce elsewhere;
respect reduced-motion settings when animating the reader.

## Voice & Copy

Short verb-first labels ("Read Now", "Resume", "Unlock"). Monetization copy
states facts (cost, balance) without pressure language. Arabic strings are
first-class, not translations of last resort.
