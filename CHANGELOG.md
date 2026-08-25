## 0.4.0

- **FEAT**: Custom reading backgrounds (`SettingBackImage`) —
  `NovelReaderSettings.backImage` renders a network or asset image under the
  chapter body with a legibility scrim (`backImageDim`).
- **FEAT**: Comic danmaku overlay (`NovelDanmakuOverlay` +
  `NovelDanmakuController`) — lane-managed flying comments recovered from the
  official comic reader settings.
- **FEAT**: Listening screen `NovelTtsPanel` — plays chapter paragraphs with
  the current one highlighted, transport controls and speed; apps plug any
  engine through the `NovelTtsDriver` interface (`NovelSimulatedTtsDriver`
  included for demos/tests).
- **FEAT**: `NovelStrings.listen` label (EN/AR).
- **CHORE**: pub.dev publishing prep — package `screenshots:` field,
  zero `dart doc` warnings, formatting verified with
  `dart format --set-exit-if-changed`, dependency-downgrade analyze clean.

## 0.3.0

- **FEAT**: Auto-scroll reading (`SettingAutoScroll`) — toggle from the
  reader chrome ("Auto" button highlights while running) with an adjustable
  speed slider (20–200 px/s) in the settings sheet; stops at chapter end.
- **FEAT**: Page-turn styles (`SettingFancyWay`) — `NovelPageFlip.slide`
  (default), `.cover` (perspective leaf rotation via `_PageFlipEffect`),
  and `.instant` (tap jumps without animating). Selector appears in the
  settings sheet when page mode is on.
- **FEAT**: Runtime font bridge `NovelFontManager`
  (`SettingArabicContentFont`) — register downloaded or bundled fonts (e.g.
  Arabic reading fonts) and reference them via
  `NovelReaderSettings.fontFamily`. No `dart:io`, works on web too.
- **FEAT**: Named variant constructors per the shadcn convention:
  `NovelStatusBadge.full`, `NovelTagChip.dense`, `NovelRankListItem.topThree`,
  `NovelComment.paragraph`.

## 0.2.1

- **FIX**: WCAG AA contrast across the whole system — `textTertiary`
  (light `#71717A` / dark `#82828C`) and every reader paper's secondary ink
  now meet ≥4.5:1; the slate-gray paper darkened to `#6A6E72` so white body
  text passes at 5.1:1. Verified programmatically over all app schemes and
  all six papers.
- **FIX**: Reader page transitions now respect
  `MediaQuery.disableAnimations` (reduced-motion accessibility).
- **FEAT**: Named variant constructors on `NovelBookCard` — `.rail()` for
  horizontal discovery strips and static `NovelBookCard.row(...)` for dense
  lists (shadcn-style single-class variants).

## 0.2.0

- **FEAT**: Per-component themes (`NovelBookCardTheme`, `NovelChapterTileTheme`,
  `NovelCommentTileTheme`, `NovelRankListItemTheme`, `NovelSectionHeaderTheme`) with
  the shadcn-style resolution chain `widget.field ?? componentTheme ?? default`.
- **FEAT**: `NovelThemeData` is now a real `ThemeExtension` — registered inside
  `toMaterialTheme()` so Material animates light/dark transitions and
  `Theme.of(context).extension<NovelThemeData>()` works anywhere.
- **FEAT**: Phase-1 components from the cross-platform gap matrix:
  `NovelPowerRankPodium` (GoodNovel), `NovelWaitOrPayTile` countdown unlock
  (Tapas), `NovelLatestUpdateTile` feed row (ScribbleHub),
  `NovelReadingListPicker` sheet (Wattpad), `NovelAchievementRow` medals
  (RoyalRoad).
- **FEAT**: Platform color presets `NovelPlatformPresets` (Wattpad #FF500A,
  GoodNovel #EE3799, RoyalRoad #1976D2) recovered from each platform's
  production CSS.
- **FEAT**: `NovelBannerCarousel` (16:9 auto-advancing promo strip) and
  `NovelSearchSuggestions` (hot searches + history chips).
- **FEAT**: Paragraph comments in the reader (`paragraphCommentCounts`,
  `onParagraphComments`, `NovelParagraphCommentsSheet`) matching the official
  app's Flutter paragraph-comment surface.
- **FEAT**: Arabic & RTL support via theme-level `NovelStrings` presets
  (`NovelStrings.ar()`), no codegen; every widget label is theme-resolved.
- **FEAT**: Six reader paper themes recovered from the shipped app's
  `ReaderColorUtil` (white/#F6F1E5/#DCE5E2/#808489/#E5CF9C/night).
- **FEAT**: Tiered rank coloring (red/orange/green) from webnovel.com's
  Power Ranking tokens.
- **FIX**: Accessibility — Semantics on rating bars (adjustable role),
  book cards, chapter tiles, power-stone vote toggle.

## 0.1.0

- Initial release.
- Design tokens + `NovelThemeData` light/dark themes with Material bridge.
- Book components: cards, list tiles, auto-generated covers, badges, ratings.
- Ranking list items, section headers, search field, power-stone vote button.
- Chapter tiles with lock/VIP/coin states and unlock bottom sheet.
- Full reader experience: scroll & paginated modes, paper themes, settings sheet.
