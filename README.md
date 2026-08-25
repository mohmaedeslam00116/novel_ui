# wn_design

A **Webnovel-grade design system for Flutter** — everything you need to build
novel-reading apps (think Webnovel / Wattpad quality): book grids, rankings,
chapter catalogs, coin-unlock monetization widgets and a complete reading
experience with paginated & scroll readers.

Pure Flutter. No third-party dependencies. Works on Android, iOS, web,
Windows, macOS and Linux.

## ✨ What's inside

| Area | Components |
|---|---|
| **Theme** | `WnThemeData` (light/dark presets), `WnColorScheme`, `toMaterialTheme()` bridge, `WnReaderSettings` |
| **Books** | `WnBookCard`, `WnBookListTile`, `WnCoverView` (auto-generated covers), `WnContinueReadingCard`, `WnStatusBadge`, `WnTagChip`, `WnRatingBar` |
| **Rankings** | `WnRankListItem` with top-3 medal styling |
| **Catalog** | `WnChapterTile` (read/locked/VIP states), `WnUnlockSheet` (coin unlock), `WnCoinBadge` |
| **Engagement** | `WnPowerStoneButton` (violet vote button), `WnSectionHeader`, `WnSearchField`, `WnReviewAxes` (the five Webnovel review axes), `WnUpdateBadge`, `WnCornerRibbon` (ORIGINAL/HOT/NEW), `WnLevelBadge` |
| **Reader** | `WnReaderView` — scroll & true paginated modes, **6 paper themes recovered from the official app** (white/parchment/mint/gray/kraft/night), tap zones, progress slider, settings sheet, **paragraph comments** (`paragraphCommentCounts` + `WnParagraphCommentsSheet`) |
| **Comments** | `WnCommentTile`, `WnParagraphCommentsSheet`, `WnFansRankBadge` — built to the recovered comment-module specs (48dp avatar, LV badge, like/reply rows) |
| **Platform patterns** | `WnPowerRankPodium`, `WnWaitOrPayTile` (24h countdown unlock), `WnLatestUpdateTile` feed row, `WnReadingListPicker` sheet, `WnAchievementRow` medals |
| **Theming API** | Per-component themes (`theme.components.bookCard.titleStyle…`) with the shadcn-style resolution chain; `WnThemeData` is a real `ThemeExtension` carried by `Theme.of(context)` |

## 🚀 Getting started

Add to your `pubspec.yaml`:

```yaml
dependencies:
  wn_design:
    path: ../wn_design   # or git/pub.dev when published
```

Wrap your app once:

```dart
MaterialApp(
  theme: WnThemeData.light().toMaterialTheme(),
  darkTheme: WnThemeData.dark().toMaterialTheme(),
  builder: (context, child) => WnTheme(
    data: Theme.of(context).brightness == Brightness.dark
        ? WnThemeData.dark()
        : WnThemeData.light(),
    child: child!,
  ),
)
```

Access the scheme anywhere: `WnTheme.of(context).colorScheme`.

## 📖 Building a book grid

```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 130,
    childAspectRatio: 0.52,
  ),
  itemCount: books.length,
  itemBuilder: (_, i) => WnBookCard(
    book: books[i],
    subtitle: 'Latest: Chapter 128',
    onTap: () => openDetail(books[i]),
  ),
)
```

## 🔤 The reader — flagship feature

`WnReaderView` ships a real reading engine:

- **True pagination** — text is measured with `TextPainter` against the live
  viewport, so page breaks land exactly where they render, even mid-paragraph.
- **Scroll mode** for continuous vertical reading.
- **4 paper themes** (white, sepia, green "eye-protection", night) that are
  independent from the app theme.
- **Settings sheet** — font size, line height, paragraph spacing, page mode.
- Tap zones (<30% prev · center chrome · >70% next), chapter navigation,
  progress slider and progress callbacks for save/resume.

```dart
WnReaderView(
  chapter: currentChapter,
  totalChapters: chapters.length,
  settings: readerSettings,
  onSettingsChanged: saveSettings,
  onProgressChanged: (p) => repo.saveProgress(bookId, p),
  onPrevChapter: loadPrev,
  onNextChapter: loadNext,
)
```

## 💰 Monetization widgets

Locked/VIP chapters show lock + crown + cost badges in `WnChapterTile`, and
`WnUnlockSheet.show(...)` gives users a Webnovel-style unlock dialog.

## 🎨 Platform presets — look like the famous apps instantly

```dart
MaterialApp(
  theme: WnThemeData(colorScheme: WnColorScheme.webnovel).toMaterialTheme(), // official blue
  // or:
  theme: WnThemeData(colorScheme: WnPlatformPresets.wattpad(context)).toMaterialTheme(),
)
```

## 🧱 Component theming

Every core widget reads `widget.field ?? componentTheme.field ?? default`,
so you can restyle app-wide without touching call sites:

```dart
WnThemeData.light().copyWith(
  components: WnComponentsTheme().copyWith(
    bookCard: const WnBookCardTheme(titleStyle: TextStyle(fontSize: 15)),
  ),
)
```

## 🌍 Arabic & RTL — one line

All labels ship through `WnStrings` on the theme (no codegen):

```dart
final theme = WnThemeData.webnovel().copyWith(strings: WnStrings.ar());
// wrap with Directionality(textDirection: TextDirection.rtl, ...)
```

## 🧪 Testing

19 tests: paginator engine (incl. degenerate viewports), theme system, and
**golden screenshot suites (alchemist)** covering light/dark × LTR/RTL for
book cards, chapter tiles and badges. Regenerate with
`flutter test --tags golden --update-goldens`.

## Example app

Run the showcase under [`example/`](example/lib/main.dart): a full demo app
with library, rankings, book detail, catalog sheet, unlock flow, reader and a
component gallery.

```bash
cd example && flutter run -d chrome
```
