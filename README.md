<div align="center">

# wn_design

**A novel-app design system for Flutter** — build reading apps with
Webnovel-grade UI: book grids, rankings, chapter catalogs with coin
unlocks, and a complete reading engine.

[![pub version](https://img.shields.io/pub/v/wn_design?logo=dart&labelColor=1F1F24&color=FFB100)](https://pub.dev/packages/wn_design)
[![pub points](https://img.shields.io/pub/points/wn_design?logo=flutter&labelColor=1F1F24&color=3B66F5)](https://pub.dev/packages/wn_design/score)
[![pub likes](https://img.shields.io/pub/likes/wn_design?labelColor=1F1F24&color=E85D75)](https://pub.dev/packages/wn_design)
[![license](https://img.shields.io/badge/license-MIT-30A46C?labelColor=1F1F24)](LICENSE)

[Library](#-screenshots) · [Quick start](#-quick-start) · [Reader](#-the-reader) · [Theming](#-theming) · [Arabic / RTL](#-arabic--rtl)

<img src="screenshots/library.png" width="280" alt="Library home">
<img src="screenshots/book_detail.png" width="280" alt="Book detail">
<img src="screenshots/reader.png" width="280" alt="Night reader">

</div>

---

## ✨ Why wn_design

- **A reading engine, not just widgets** — true pagination measured with
  `TextPainter` (page breaks land exactly where they render), scroll mode,
  auto-scroll, three page-turn styles, six paper themes.
- **Recovered from the real thing** — reader papers, unlock flows, podium
  rankings, review axes and comment specs follow the official Webnovel
  app's own values (extracted from its shipped resources).
- **Monetization built in** — locked/VIP chapter tiles, coin unlock sheet,
  wait-or-pay countdown, power-stone votes.
- **Arabic & RTL are first-class** — every label ships in EN + AR through
  the theme; one line flips the whole app.
- **Zero dependencies** — pure Flutter, all six platforms, WCAG-AA contrast
  verified programmatically across every theme.

## 🚀 Quick start

```yaml
dependencies:
  wn_design: ^0.4.0
```

```dart
import 'package:wn_design/wn_design.dart';

MaterialApp(
  theme: WnThemeData.webnovel().toMaterialTheme(),      // official blue
  darkTheme: WnThemeData.dark().toMaterialTheme(),
  builder: (context, child) => WnTheme(
    data: WnTheme.of(context),
    child: child!,
  ),
)
```

## 📸 Screenshots

| | | |
|---|---|---|
| ![](screenshots/rankings.png) | ![](screenshots/gallery.png) | ![](screenshots/library_dark.png) |
| *Rankings* | *Component gallery* | *Dark mode* |

## 📚 What's inside

| Area | Components |
|---|---|
| **Books** | `WnBookCard` (grid / `.rail` / `.row`), `WnCoverView` (auto-generated covers), `WnContinueReadingCard`, `WnStatusBadge`, `WnTagChip` |
| **Discovery** | `WnBannerCarousel`, `WnSearchField`, `WnSearchSuggestions`, `WnRankListItem`, `WnPowerRankPodium`, `WnLatestUpdateTile`, `WnSectionHeader` |
| **Catalog & coins** | `WnChapterTile`, `WnUnlockSheet`, `WnCoinBadge`, `WnWaitOrPayTile`, `WnPowerStoneButton`, `WnReadingListPicker` |
| **Engagement** | `WnRatingBar`, `WnReviewAxes`, `WnCommentTile`, `WnFansRankBadge`, `WnAchievementRow`, `WnLevelBadge` |
| **Reader** | `WnReaderView`, `WnTextPaginator`, `WnParagraphCommentsSheet`, `WnFontManager`, `WnTtsPanel`, `WnDanmakuOverlay` |

## 🔤 The reader

```dart
WnReaderView(
  chapter: chapter,
  totalChapters: chapters.length,
  settings: const WnReaderSettings(paper: WnReaderPaper.sepia),
  paragraphCommentCounts: {2: 12, 7: 3},          // numbered bubbles
  onParagraphComments: (i) => WnParagraphCommentsSheet.show(
    context, paragraphIndex: i,
    paragraphText: chapter.paragraphs[i],
    comments: repo.commentsFor(chapter, i),
  ),
  onProgressChanged: (p) => repo.saveProgress(book.id, p),
  onPrevChapter: loadPrev,
  onNextChapter: loadNext,
)
```

Six paper themes (white · parchment · mint · gray · kraft · night), font
size 12–32, line-height and paragraph-gap sliders, auto-scroll, and three
page-turn animations — all user-tunable from the built-in settings sheet.

## 🎨 Theming

Every visual value resolves `widget.field ?? componentTheme.field ??
default`, so restyling is one place:

```dart
WnThemeData.webnovel().copyWith(
  components: WnComponentsTheme().copyWith(
    bookCard: const WnBookCardTheme(titleStyle: TextStyle(fontSize: 15)),
  ),
)
```

Or match a famous platform instantly:

```dart
WnThemeData(colorScheme: WnPlatformPresets.wattpad(context))
```

## 🌍 Arabic & RTL

```dart
WnThemeData.webnovel().copyWith(strings: WnStrings.ar())
// + Directionality(textDirection: TextDirection.rtl)
```

## 🧪 Quality

28 tests including alchemist golden suites (light/dark × LTR/RTL),
paginator engine edge cases, and programmatic WCAG-AA contrast checks over
every theme. `dart doc` clean; pub.dev score **160/160**.

## 📄 License

MIT — see [LICENSE](LICENSE).
