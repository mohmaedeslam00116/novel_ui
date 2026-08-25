import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../tokens/novel_colors.dart';
import 'novel_reader_theme.dart';

/// Semantic color roles resolved for one brightness.
///
/// Every novel_ui widget reads from this instead of hard-coded colors,
/// so a custom [NovelThemeData] re-skins the whole library.
@immutable
class NovelColorScheme with Diagnosticable {
  const NovelColorScheme({
    required this.brightness,
    this.primary = NovelColors.primary,
    this.onPrimary = Colors.black,
    this.primaryContainer = NovelColors.primaryContainer,
    this.onPrimaryContainer = NovelColors.onPrimaryContainer,
    this.secondary = NovelColors.secondary,
    this.background = NovelColors.lightBackground,
    this.surface = NovelColors.lightSurface,
    this.surfaceLow = NovelColors.lightSurfaceLow,
    this.textPrimary = NovelColors.lightTextPrimary,
    this.textSecondary = NovelColors.lightTextSecondary,
    this.textTertiary = NovelColors.lightTextTertiary,
    this.border = NovelColors.lightBorder,
    this.updateDot = NovelColors.updateDot,
    this.coin = NovelColors.coin,
    this.vip = NovelColors.vip,
    this.error = NovelColors.error,
    this.success = NovelColors.success,
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
  static const NovelColorScheme light = NovelColorScheme(
    brightness: Brightness.light,
  );

  /// The default dark scheme — near-black surfaces tuned for reading apps.
  static const NovelColorScheme dark = NovelColorScheme(
    brightness: Brightness.dark,
    primary: NovelColors.primary,
    onPrimary: Colors.black,
    primaryContainer: Color(0xFF3D2E00),
    onPrimaryContainer: Color(0xFFFFD98A),
    background: NovelColors.darkBackground,
    surface: NovelColors.darkSurface,
    surfaceLow: NovelColors.darkSurfaceLow,
    textPrimary: NovelColors.darkTextPrimary,
    textSecondary: NovelColors.darkTextSecondary,
    textTertiary: NovelColors.darkTextTertiary,
    border: NovelColors.darkBorder,
  );

  /// Colors recovered from the official Webnovel design system — the
  /// production CSS token values (`--primary-base` #4147E3 and the neutral
  /// scale), cross-confirmed against the shipped APK's own icon set.
  static const NovelColorScheme webnovel = NovelColorScheme(
    brightness: Brightness.light,
    primary: NovelColors.wnPrimaryBase,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFE3E6FE),
    onPrimaryContainer: Color(0xFF1B2A9C),
    secondary: NovelColors.wnPrimaryEmphasis,
    background: Color(0xFFF5F6F8),
    surface: NovelColors.wnSurfaceMedium,
    surfaceLow: Color(0xFFEEEFF9),
    textPrimary: Color(0xFF121217),
    textSecondary: Color(0xFF6B7080),
    textTertiary: Color(0xFF9CA1B0),
    border: NovelColors.wnBorderOpaque,
    coin: Color(0xFF23C394),
    vip: Color(0xFFAB56AF),
  );

  NovelColorScheme copyWith({
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
    return NovelColorScheme(
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

  static NovelColorScheme lerp(NovelColorScheme a, NovelColorScheme b, double t) {
    return NovelColorScheme(
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
const Map<NovelReaderPaper, NovelReaderColors> kNovelReaderPapers = {
  NovelReaderPaper.light: NovelReaderColors(
    paper: NovelColors.paperLight,
    text: Color(0xFF262626),
    secondaryText: Color(0xFF767676),
    controlBackground: Color(0xFFF2F2F2),
  ),
  NovelReaderPaper.sepia: NovelReaderColors(
    paper: NovelColors.paperSepia,
    text: Color(0xFF3D3729),
    secondaryText: Color(0xFF776D55),
    controlBackground: Color(0xFFEAE2CE),
  ),
  NovelReaderPaper.green: NovelReaderColors(
    paper: NovelColors.paperGreen,
    text: Color(0xFF2C3A34),
    secondaryText: Color(0xFF566961),
    controlBackground: Color(0xFFC9D6D0),
  ),
  NovelReaderPaper.gray: NovelReaderColors(
    paper: Color(0xFF6A6E72),
    text: Colors.white,
    secondaryText: Color(0xFFEDF1F6),
    controlBackground: Color(0xFF5A5E62),
  ),
  NovelReaderPaper.kraft: NovelReaderColors(
    paper: NovelColors.paperKraft,
    text: Color(0xFF4A3E1E),
    secondaryText: Color(0xFF68582B),
    controlBackground: Color(0xFFD8C288),
  ),
  NovelReaderPaper.night: NovelReaderColors(
    paper: NovelColors.paperNight,
    text: Color(0xFFA6A6AD),
    secondaryText: Color(0xFF7E7E88),
    controlBackground: Color(0xFF232329),
  ),
};

/// Which built-in reader paper preset to use.
enum NovelReaderPaper { light, sepia, green, gray, kraft, night }
