/// wn_design — a Webnovel-grade design system for Flutter.
///
/// Build novel-reading apps with book grids, rankings, chapter catalogs and
/// a complete reading experience (paginated & scroll readers, paper themes,
/// typography controls).
///
/// Start by wrapping your app:
///
/// ```dart
/// MaterialApp(
///   theme: WnThemeData.light().toMaterialTheme(),
///   darkTheme: WnThemeData.dark().toMaterialTheme(),
///   builder: (context, child) => WnTheme(
///     data: Theme.of(context).brightness == Brightness.dark
///         ? WnThemeData.dark()
///         : WnThemeData.light(),
///     child: child!,
///   ),
/// )
/// ```
library;

// ── Tokens ───────────────────────────────────────────────────────────────
export 'src/tokens/wn_colors.dart';
export 'src/tokens/wn_dimens.dart';

// ── Models ───────────────────────────────────────────────────────────────
export 'src/models/wn_book.dart';

// ── Theme ────────────────────────────────────────────────────────────────
export 'src/theme/wn_color_scheme.dart';
export 'src/theme/wn_component_themes.dart';
export 'src/theme/wn_reader_theme.dart';
export 'src/theme/wn_platform_presets.dart';
export 'src/theme/wn_strings.dart';
export 'src/theme/wn_theme.dart';

// ── Reader ───────────────────────────────────────────────────────────────
export 'src/reader/wn_font_manager.dart';
export 'src/reader/wn_tts_panel.dart';
export 'src/reader/wn_paragraph_comments_sheet.dart';
export 'src/reader/wn_reader_settings_sheet.dart';
export 'src/reader/wn_text_paginator.dart';
export 'src/reader/wn_reader_view.dart';

// ── Widgets ──────────────────────────────────────────────────────────────
export 'src/widgets/wn_badges.dart';
export 'src/widgets/wn_banner_carousel.dart';
export 'src/widgets/wn_book_card.dart';
export 'src/widgets/wn_review_axes.dart';
export 'src/widgets/wn_chapter_tile.dart';
export 'src/widgets/wn_comment_tile.dart';
export 'src/widgets/wn_continue_reading_card.dart';
export 'src/widgets/wn_cover_view.dart';
export 'src/widgets/wn_danmaku_overlay.dart';
export 'src/widgets/wn_phase1_components.dart';
export 'src/widgets/wn_rank_list_item.dart';
export 'src/widgets/wn_rating_bar.dart';
export 'src/widgets/wn_search_suggestions.dart';
export 'src/widgets/wn_section_header.dart';
export 'src/widgets/wn_status_badge.dart';
