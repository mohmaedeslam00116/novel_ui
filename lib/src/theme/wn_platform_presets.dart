import 'package:flutter/material.dart';

import 'wn_color_scheme.dart';

/// Ready-made color schemes modeled on famous novel platforms — useful for
/// demos, white-labeling, or matching a familiar look instantly.
///
/// Every value is taken from each platform's public design tokens
/// (production CSS) as of 2026-08.
abstract final class WnPlatformPresets {
  /// Wattpad — "Hero Orange" `#FF500A` on the official `--ds-*` token
  /// system (light ramp).
  static WnColorScheme wattpad(BuildContext context) => const WnColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFFF500A),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFFFD9CA),
    onPrimaryContainer: Color(0xFF602B1C),
    secondary: Color(0xFF5C10FF),
    background: Color(0xFFF6F6F6),
    surface: Colors.white,
    surfaceLow: Color(0xFFF6F6F6),
    textPrimary: Color(0xFF121212),
    textSecondary: Color(0xFF686868),
    textTertiary: Color(0xFFB3B3B3),
    border: Color(0xFFE2E2E2),
    error: Color(0xFFE00000),
    success: Color(0xFF00854E),
  );

  /// GoodNovel — pink brand `#EE3799` with the Element-UI neutral scale
  /// their web app is built on.
  static WnColorScheme goodNovel(BuildContext context) => const WnColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFEE3799),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFFFC8CB),
    onPrimaryContainer: Color(0xFF5A1D30),
    secondary: Color(0xFF409EFF),
    background: Color(0xFFF5F7FA),
    surface: Colors.white,
    surfaceLow: Color(0xFFEBEEF5),
    textPrimary: Color(0xFF303133),
    textSecondary: Color(0xFF606266),
    textTertiary: Color(0xFF909399),
    border: Color(0xFFDCDFE6),
    error: Color(0xFFF56C6C),
    success: Color(0xFF67C23A),
  );

  /// Royal Road — classic blue `#1976D2` with cool gray surfaces.
  static WnColorScheme royalRoad(BuildContext context) => const WnColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1976D2),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFD6E7FA),
    onPrimaryContainer: Color(0xFF0D3C66),
    secondary: Color(0xFF6366F1),
    background: Color(0xFFFAFAFA),
    surface: Colors.white,
    surfaceLow: Color(0xFFEFF3F8),
    textPrimary: Color(0xFF2C393F),
    textSecondary: Color(0xFF5A5A5A),
    textTertiary: Color(0xFFB7B7B7),
    border: Color(0xFFEAEAEA),
    error: Color(0xFFF56C6C),
    success: Color(0xFF67C23A),
  );
}
