/// novel_ui — a Webnovel-grade design system for Flutter.
///
/// Build novel-reading apps with book grids, rankings, chapter catalogs and
/// a complete reading experience (paginated & scroll readers, paper themes,
/// typography controls).
///
/// Start by wrapping your app:
///
/// ```dart
/// MaterialApp(
///   theme: NovelThemeData.light().toMaterialTheme(),
///   darkTheme: NovelThemeData.dark().toMaterialTheme(),
///   builder: (context, child) => NovelTheme(
///     data: Theme.of(context).brightness == Brightness.dark
///         ? NovelThemeData.dark()
///         : NovelThemeData.light(),
///     child: child!,
///   ),
/// )
/// ```
library;

// ── Tokens ───────────────────────────────────────────────────────────────
export 'src/tokens/novel_colors.dart';
export 'src/tokens/novel_dimens.dart';

// ── Models ───────────────────────────────────────────────────────────────
export 'src/models/novel_book.dart';

// ── Theme ────────────────────────────────────────────────────────────────
export 'src/theme/novel_color_scheme.dart';
export 'src/theme/novel_component_themes.dart';
export 'src/theme/novel_reader_theme.dart';
export 'src/theme/novel_platform_presets.dart';
export 'src/theme/novel_strings.dart';
export 'src/theme/novel_theme.dart';

// ── Reader ───────────────────────────────────────────────────────────────
export 'src/reader/novel_font_manager.dart';
export 'src/reader/novel_tts_panel.dart';
export 'src/reader/novel_paragraph_comments_sheet.dart';
export 'src/reader/novel_reader_settings_sheet.dart';
export 'src/reader/novel_text_paginator.dart';
export 'src/reader/novel_reader_view.dart';

// ── Widgets ──────────────────────────────────────────────────────────────
export 'src/widgets/novel_badges.dart';
export 'src/widgets/novel_banner_carousel.dart';
export 'src/widgets/novel_book_card.dart';
export 'src/widgets/novel_review_axes.dart';
export 'src/widgets/novel_chapter_tile.dart';
export 'src/widgets/novel_comment_tile.dart';
export 'src/widgets/novel_continue_reading_card.dart';
export 'src/widgets/novel_cover_view.dart';
export 'src/widgets/novel_danmaku_overlay.dart';
export 'src/widgets/novel_phase1_components.dart';
export 'src/widgets/novel_rank_list_item.dart';
export 'src/widgets/novel_rating_bar.dart';
export 'src/widgets/novel_search_suggestions.dart';
export 'src/widgets/novel_section_header.dart';
export 'src/widgets/novel_status_badge.dart';
