import 'package:flutter/material.dart';

/// Webnovel-style brand palette.
///
/// The brand identity is built around a golden-orange primary (used for
/// CTAs, highlights and premium accents) with semantic colors for
/// statuses, coins and VIP content.
abstract final class WnColors {
  // ── Brand ──────────────────────────────────────────────────────────────
  /// Primary brand gold — buttons, active tabs, highlights.
  static const Color primary = Color(0xFFFFB100);
  static const Color primaryDark = Color(0xFFE89B00);
  static const Color primaryContainer = Color(0xFFFFF1D0);
  static const Color onPrimaryContainer = Color(0xFF5C4200);

  /// Deep orange used for gradients and pressed states.
  static const Color secondary = Color(0xFFFF7A00);
  static const Color tertiary = Color(0xFFFF5A3C);

  // ── Semantic ───────────────────────────────────────────────────────────
  static const Color error = Color(0xFFE5484D);
  static const Color success = Color(0xFF30A46C);
  static const Color info = Color(0xFF3B82F6);
  static const Color warning = Color(0xFFF5A623);

  /// Red update badge / notification dot.
  static const Color updateDot = Color(0xFFFF4D4F);

  /// Coin currency gold.
  static const Color coin = Color(0xFFFFC53D);

  /// VIP / premium purple-gold.
  static const Color vip = Color(0xFFB8860B);

  /// Violet power-stone gem (Webnovel's vote currency).
  static const Color powerStone = Color(0xFF8B7CF6);

  /// Fast Pass ticket blue.
  static const Color fastPass = Color(0xFF4D9EF8);

  // ── Light surfaces ─────────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF7F7F8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceLow = Color(0xFFF1F1F3);
  static const Color lightTextPrimary = Color(0xFF1F1F24);
  static const Color lightTextSecondary = Color(0xFF6E6E77);
  // WCAG AA: >=4.5:1 on background & surface.
  static const Color lightTextTertiary = Color(0xFF71717A);
  static const Color lightBorder = Color(0xFFE4E4E8);

  // ── Dark surfaces ──────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF101012);
  static const Color darkSurface = Color(0xFF1A1A1E);
  static const Color darkSurfaceLow = Color(0xFF242428);
  static const Color darkTextPrimary = Color(0xFFF2F2F5);
  static const Color darkTextSecondary = Color(0xFFA2A2AC);
  static const Color darkTextTertiary = Color(0xFF82828C);
  static const Color darkBorder = Color(0xFF2E2E34);

  // ── Reader paper themes ────────────────────────────────────────────────
  // Values recovered from the official app's ReaderColorUtil (v8.22.5):
  // white / #F6F1E5 / #DCE5E2 / #808489 / #E5CF9C / night.

  /// Classic white paper.
  static const Color paperLight = Color(0xFFFFFFFF);

  /// Parchment — the app's "F6F1E5" scheme.
  static const Color paperSepia = Color(0xFFF6F1E5);

  /// Mint green — the app's "DCE5E2" eye-protection scheme.
  static const Color paperGreen = Color(0xFFDCE5E2);

  /// Slate gray — the app's "808489" scheme (light-on-dark ink).
  static const Color paperGray = Color(0xFF808489);

  /// Golden kraft — the app's "E5CF9C" scheme.
  static const Color paperKraft = Color(0xFFE5CF9C);

  /// Night reading paper.
  static const Color paperNight = Color(0xFF15151A);

  // ── Official Webnovel token system (recovered from webnovel.com CSS) ───
  /// `--primary-base` — the true 2024+ brand primary.
  static const Color wnPrimaryBase = Color(0xFF4147E3);

  /// `--secondary-surface-emphasis`.
  static const Color wnPrimaryEmphasis = Color(0xFF5564FF);

  /// `--primary-brand` cyan accent.
  static const Color wnBrandCyan = Color(0xFF28FFF2);

  /// `--primary-content` teal ink used on cyan surfaces.
  static const Color wnTealInk = Color(0xFF006A62);

  /// `--neutral-surface-medium`.
  static const Color wnSurfaceMedium = Color(0xFFF5F5F5);

  /// `--neutral-surface-strong`.
  static const Color wnSurfaceStrong = Color(0xFFE2E2E2);

  /// `--neutral-opaque-border`.
  static const Color wnBorderOpaque = Color(0xFFEDEDED);

  /// Inverse (dark) surfaces: `--neutral-surface-inverse{,-medium,-strong}`.
  static const Color wnDarkSurface = Color(0xFF212121);
  static const Color wnDarkSurfaceMedium = Color(0xFF171717);
  static const Color wnDarkSurfaceStrong = Color(0xFF0E0E0E);

  /// `--negative-content`.
  static const Color wnNegative = Color(0xFFB02C23);

  /// `--special-golden-ticket-gradient-default` (#FFE413 → #FFA100).
  static const List<Color> goldenTicketGradient = [
    Color(0xFFFFE413),
    Color(0xFFFFA100),
  ];

  /// `--gradient-purchase` (#ACECFA → #D3EF26).
  static const List<Color> purchaseGradient = [
    Color(0xFFACECFA),
    Color(0xFFD3EF26),
  ];

  static const List<Color> coverGradientPool = [
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
    Color(0xFFFFB100),
    Color(0xFF6C5CE7),
    Color(0xFF00B894),
    Color(0xFF0984E3),
    Color(0xFFE17055),
    Color(0xFFFD79A8),
    Color(0xFF00CEC9),
    Color(0xFF636E72),
  ];
}
