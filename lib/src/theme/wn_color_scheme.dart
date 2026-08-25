import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../tokens/wn_colors.dart';
import 'wn_reader_theme.dart';

/// Semantic color roles resolved for one brightness.
///
/// Every wn_design widget reads from this instead of hard-coded colors,
/// so a custom [WnThemeData] re-skins the whole library.
@immutable
class WnColorScheme with Diagnosticable {
  const WnColorScheme({
    required this.brightness,
    this.primary = WnColors.primary,
    this.onPrimary = Colors.black,
    this.primaryContainer = WnColors.primaryContainer,
    this.onPrimaryContainer = WnColors.onPrimaryContainer,
    this.secondary = WnColors.secondary,
    this.background = WnColors.lightBackground,
    this.surface = WnColors.lightSurface,
    this.surfaceLow = WnColors.lightSurfaceLow,
    this.textPrimary = WnColors.lightTextPrimary,
    this.textSecondary = WnColors.lightTextSecondary,
    this.textTertiary = WnColors.lightTextTertiary,
    this.border = WnColors.lightBorder,
    this.updateDot = WnColors.updateDot,
    this.coin = WnColors.coin,
    this.vip = WnColors.vip,
    this.error = WnColors.error,
    this.success = WnColors.success,
  });

  final Brightness brightness;
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;

  /// Screen scaffold background.
  final Color background;

  /// Card / sheet surface.
  final Color surface;

  /// Subtle inset surfaces (chips, dividers, skeletons).
  final Color surfaceLow;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color border;
  final Color updateDot;
  final Color coin;
  final Color vip;
  final Color error;
  final Color success;

  bool get isDark => brightness == Brightness.dark;

  /// The default light scheme.
  static const WnColorScheme light = WnColorScheme(
    brightness: Brightness.light,
  );

  /// The default dark scheme — near-black surfaces tuned for reading apps.
  static const WnColorScheme dark = WnColorScheme(
    brightness: Brightness.dark,
    primary: WnColors.primary,
    onPrimary: Colors.black,
    primaryContainer: Color(0xFF3D2E00),
    onPrimaryContainer: Color(0xFFFFD98A),
    background: WnColors.darkBackground,
    surface: WnColors.darkSurface,
    surfaceLow: WnColors.darkSurfaceLow,
    textPrimary: WnColors.darkTextPrimary,
    textSecondary: WnColors.darkTextSecondary,
    textTertiary: WnColors.darkTextTertiary,
    border: WnColors.darkBorder,
  );

  /// Colors recovered from the official Webnovel design system — the
  /// production CSS token values (`--primary-base` #4147E3 and the neutral
  /// scale), cross-confirmed against the shipped APK's own icon set.
  static const WnColorScheme webnovel = WnColorScheme(
    brightness: Brightness.light,
    primary: WnColors.wnPrimaryBase,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFE3E6FE),
    onPrimaryContainer: Color(0xFF1B2A9C),
    secondary: WnColors.wnPrimaryEmphasis,
    background: Color(0xFFF5F6F8),
    surface: WnColors.wnSurfaceMedium,
    surfaceLow: Color(0xFFEEEFF9),
    textPrimary: Color(0xFF121217),
    textSecondary: Color(0xFF6B7080),
    textTertiary: Color(0xFF9CA1B0),
    border: WnColors.wnBorderOpaque,
    coin: Color(0xFF23C394),
    vip: Color(0xFFAB56AF),
  );

  WnColorScheme copyWith({
    Brightness? brightness,
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? secondary,
    Color? background,
    Color? surface,
    Color? surfaceLow,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? border,
    Color? updateDot,
    Color? coin,
    Color? vip,
    Color? error,
    Color? success,
  }) {
    return WnColorScheme(
      brightness: brightness ?? this.brightness,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      secondary: secondary ?? this.secondary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceLow: surfaceLow ?? this.surfaceLow,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      border: border ?? this.border,
      updateDot: updateDot ?? this.updateDot,
      coin: coin ?? this.coin,
      vip: vip ?? this.vip,
      error: error ?? this.error,
      success: success ?? this.success,
    );
  }

  static WnColorScheme lerp(WnColorScheme a, WnColorScheme b, double t) {
    return WnColorScheme(
      brightness: t < 0.5 ? a.brightness : b.brightness,
      primary: Color.lerp(a.primary, b.primary, t)!,
      onPrimary: Color.lerp(a.onPrimary, b.onPrimary, t)!,
      primaryContainer: Color.lerp(a.primaryContainer, b.primaryContainer, t)!,
      onPrimaryContainer: Color.lerp(
        a.onPrimaryContainer,
        b.onPrimaryContainer,
        t,
      )!,
      secondary: Color.lerp(a.secondary, b.secondary, t)!,
      background: Color.lerp(a.background, b.background, t)!,
      surface: Color.lerp(a.surface, b.surface, t)!,
      surfaceLow: Color.lerp(a.surfaceLow, b.surfaceLow, t)!,
      textPrimary: Color.lerp(a.textPrimary, b.textPrimary, t)!,
      textSecondary: Color.lerp(a.textSecondary, b.textSecondary, t)!,
      textTertiary: Color.lerp(a.textTertiary, b.textTertiary, t)!,
      border: Color.lerp(a.border, b.border, t)!,
      updateDot: Color.lerp(a.updateDot, b.updateDot, t)!,
      coin: Color.lerp(a.coin, b.coin, t)!,
      vip: Color.lerp(a.vip, b.vip, t)!,
      error: Color.lerp(a.error, b.error, t)!,
      success: Color.lerp(a.success, b.success, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty('brightness', brightness));
    properties.add(ColorProperty('primary', primary));
    properties.add(ColorProperty('background', background));
    properties.add(ColorProperty('surface', surface));
    properties.add(ColorProperty('textPrimary', textPrimary));
  }
}

/// Reader paper presets — the six schemes recovered from the official
/// app's `ReaderColorUtil`: white, #F6F1E5, #DCE5E2, #808489, #E5CF9C, night.
const Map<WnReaderPaper, WnReaderColors> kWnReaderPapers = {
  WnReaderPaper.light: WnReaderColors(
    paper: WnColors.paperLight,
    text: Color(0xFF262626),
    secondaryText: Color(0xFF767676),
    controlBackground: Color(0xFFF2F2F2),
  ),
  WnReaderPaper.sepia: WnReaderColors(
    paper: WnColors.paperSepia,
    text: Color(0xFF3D3729),
    secondaryText: Color(0xFF776D55),
    controlBackground: Color(0xFFEAE2CE),
  ),
  WnReaderPaper.green: WnReaderColors(
    paper: WnColors.paperGreen,
    text: Color(0xFF2C3A34),
    secondaryText: Color(0xFF566961),
    controlBackground: Color(0xFFC9D6D0),
  ),
  WnReaderPaper.gray: WnReaderColors(
    paper: Color(0xFF6A6E72),
    text: Colors.white,
    secondaryText: Color(0xFFEDF1F6),
    controlBackground: Color(0xFF5A5E62),
  ),
  WnReaderPaper.kraft: WnReaderColors(
    paper: WnColors.paperKraft,
    text: Color(0xFF4A3E1E),
    secondaryText: Color(0xFF68582B),
    controlBackground: Color(0xFFD8C288),
  ),
  WnReaderPaper.night: WnReaderColors(
    paper: WnColors.paperNight,
    text: Color(0xFFA6A6AD),
    secondaryText: Color(0xFF7E7E88),
    controlBackground: Color(0xFF232329),
  ),
};

/// Which built-in reader paper preset to use.
enum WnReaderPaper { light, sepia, green, gray, kraft, night }
