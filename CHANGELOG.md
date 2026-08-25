## 0.4.0

- **FEAT**: Custom reading backgrounds (`SettingBackImage`) —
  `WnReaderSettings.backImage` renders a network or asset image under the
  chapter body with a legibility scrim (`backImageDim`).
- **FEAT**: Comic danmaku overlay (`WnDanmakuOverlay` +
  `WnDanmakuController`) — lane-managed flying comments recovered from the
  official comic reader settings.
- **FEAT**: Listening screen `WnTtsPanel` — plays chapter paragraphs with
  the current one highlighted, transport controls and speed; apps plug any
  engine through the `WnTtsDriver` interface (`WnSimulatedTtsDriver`
  included for demos/tests).
- **FEAT**: `WnStrings.listen` label (EN/AR).
- **CHORE**: pub.dev publishing prep — package `screenshots:` field,
  zero `dart doc` warnings, formatting verified with
  `dart format --set-exit-if-changed`, dependency-downgrade analyze clean.

## 0.3.0

- **FEAT**: Auto-scroll reading (`SettingAutoScroll`) — toggle from the
  reader chrome ("Auto" button highlights while running) with an adjustable
  speed slider (20–200 px/s) in the settings sheet; stops at chapter end.
- **FEAT**: Page-turn styles (`SettingFancyWay`) — `WnPageFlip.slide`
  (default), `.cover` (perspective leaf rotation via `_PageFlipEffect`),
  and `.instant` (tap jumps without animating). Selector appears in the
  settings sheet when page mode is on.
- **FEAT**: Runtime font bridge `WnFontManager`
  (`SettingArabicContentFont`) — register downloaded or bundled fonts (e.g.
  Arabic reading fonts) and reference them via
  `WnReaderSettings.fontFamily`. No `dart:io`, works on web too.
- **FEAT**: Named variant constructors per the shadcn convention:
  `WnStatusBadge.full`, `WnTagChip.dense`, `WnRankListItem.topThree`,
  `WnComment.paragraph`.

## 0.2.1

- **FIX**: WCAG AA contrast across the whole system — `textTertiary`
  (light `#71717A` / dark `#82828C`) and every reader paper's secondary ink
  now meet ≥4.5:1; the slate-gray paper darkened to `#6A6E72` so white body
  text passes at 5.1:1. Verified programmatically over all app schemes and
  all six papers.
- **FIX**: Reader page transitions now respect
  `MediaQuery.disableAnimations` (reduced-motion accessibility).
- **FEAT**: Named variant constructors on `WnBookCard` — `.rail()` for
  horizontal discovery strips and static `WnBookCard.row(...)` for dense
  lists (shadcn-style single-class variants).

## 0.2.0

- **FEAT**: Per-component themes (`WnBookCardTheme`, `WnChapterTileTheme`,
  `WnCommentTileTheme`, `WnRankListItemTheme`, `WnSectionHeaderTheme`) with
  the shadcn-style resolution chain `widget.field ?? componentTheme ?? default`.
- **FEAT**: `WnThemeData` is now a real `ThemeExtension` — registered inside
  `toMaterialTheme()` so Material animates light/dark transitions and
  `Theme.of(context).extension<WnThemeData>()` works anywhere.
- **FEAT**: Phase-1 components from the cross-platform gap matrix:
  `WnPowerRankPodium` (GoodNovel), `WnWaitOrPayTile` countdown unlock
  (Tapas), `WnLatestUpdateTile` feed row (ScribbleHub),
  `WnReadingListPicker` sheet (Wattpad), `WnAchievementRow` medals
  (RoyalRoad).
- **FEAT**: Platform color presets `WnPlatformPresets` (Wattpad #FF500A,
  GoodNovel #EE3799, RoyalRoad #1976D2) recovered from each platform's
  production CSS.
- **FEAT**: `WnBannerCarousel` (16:9 auto-advancing promo strip) and
  `WnSearchSuggestions` (hot searches + history chips).
- **FEAT**: Paragraph comments in the reader (`paragraphCommentCounts`,
  `onParagraphComments`, `WnParagraphCommentsSheet`) matching the official
  app's Flutter paragraph-comment surface.
- **FEAT**: Arabic & RTL support via theme-level `WnStrings` presets
  (`WnStrings.ar()`), no codegen; every widget label is theme-resolved.
- **FEAT**: Six reader paper themes recovered from the shipped app's
  `ReaderColorUtil` (white/#F6F1E5/#DCE5E2/#808489/#E5CF9C/night).
- **FEAT**: Tiered rank coloring (red/orange/green) from webnovel.com's
  Power Ranking tokens.
- **FIX**: Accessibility — Semantics on rating bars (adjustable role),
  book cards, chapter tiles, power-stone vote toggle.

## 0.1.0

- Initial release.
- Design tokens + `WnThemeData` light/dark themes with Material bridge.
- Book components: cards, list tiles, auto-generated covers, badges, ratings.
- Ranking list items, section headers, search field, power-stone vote button.
- Chapter tiles with lock/VIP/coin states and unlock bottom sheet.
- Full reader experience: scroll & paginated modes, paper themes, settings sheet.
