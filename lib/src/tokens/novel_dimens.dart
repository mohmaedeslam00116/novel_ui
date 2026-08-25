/// Spacing, radius, sizing and duration constants used across novel_ui.
abstract final class NovelDimens {
  // ── Spacing scale ──────────────────────────────────────────────────────
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// Default horizontal screen padding.
  static const double screenPadding = 16;

  // ── Radii ──────────────────────────────────────────────────────────────
  static const double radiusSm = 6;
  static const double radiusMd = 10;
  static const double radiusLg = 14;
  static const double radiusXl = 20;

  /// Book covers use a slightly rounded rectangle, like print editions.
  static const double coverRadius = 8;

  // ── Covers & thumbnails ────────────────────────────────────────────────
  /// Standard web-novel cover aspect ratio (width : height).
  static const double coverAspectRatio = 3 / 4;

  /// Grid book card cover width.
  static const double gridCoverWidth = 104;

  /// List tile cover width (book detail "related" lists etc.).
  static const double listCoverWidth = 76;

  // ── Components ─────────────────────────────────────────────────────────
  static const double appBarHeight = 56;
  static const double bottomNavHeight = 64;
  static const double chipHeight = 26;
  static const double buttonHeightMd = 44;
  static const double buttonHeightLg = 52;

  // ── Reader ─────────────────────────────────────────────────────────────
  static const double readerPageInsetH = 20;
  static const double readerPageInsetV = 28;
  static const double readerMinFontSize = 12;
  static const double readerMaxFontSize = 32;
  static const double readerDefaultFontSize = 18;
  static const double readerDefaultLineHeight = 1.7;
  static const double readerDefaultParagraphSpacing = 14;

  // ── Motion ─────────────────────────────────────────────────────────────
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
}
