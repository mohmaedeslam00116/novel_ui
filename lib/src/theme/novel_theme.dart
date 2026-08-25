import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../tokens/novel_dimens.dart';
import 'novel_color_scheme.dart';
import 'novel_component_themes.dart';
import 'novel_reader_theme.dart';
import 'novel_strings.dart';

/// Root configuration object for the novel_ui library.
///
/// Provide it above your app with [NovelTheme] (usually wrapping
/// `MaterialApp`) and access it anywhere via `NovelTheme.of(context)`.
@immutable
class NovelThemeData with Diagnosticable implements ThemeExtension<NovelThemeData> {
  NovelThemeData({
    NovelColorScheme? colorScheme,
    Brightness brightness = Brightness.light,
    NovelReaderSettings? readerSettings,
    NovelStrings? strings,
    NovelComponentsTheme? components,
    this.visualDensity,
    this.fontFamily,
    this.materialTapTargetSize,
  }) : colorScheme =
           colorScheme ??
           (brightness == Brightness.dark
               ? NovelColorScheme.dark
               : NovelColorScheme.light),
       readerSettings = readerSettings ?? const NovelReaderSettings(),
       strings = strings ?? NovelStrings.en(),
       components = components ?? NovelComponentsTheme();

  /// Semantic colors for the current brightness.
  final NovelColorScheme colorScheme;

  /// Library-wide default reader preferences.
  final NovelReaderSettings readerSettings;

  /// User-facing labels for all novel_ui widgets.
  final NovelStrings strings;

  /// Per-component themes (book cards, chapter tiles, comments, ranks,
  /// section headers). All their fields are nullable — widgets resolve
  /// `widget.field ?? componentTheme.field ?? default`.
  final NovelComponentsTheme components;

  /// Optional app-wide font family override.
  final String? fontFamily;
  final VisualDensity? visualDensity;
  final MaterialTapTargetSize? materialTapTargetSize;

  static NovelThemeData light() => NovelThemeData(brightness: Brightness.light);
  static NovelThemeData dark() => NovelThemeData(brightness: Brightness.dark);

  /// Preset matching the real Webnovel app's 2024+ blue rebrand — colors
  /// extracted from the shipped APK's own icon set (see
  /// webnovel_design_reference/DESIGN_REPORT.md).
  static NovelThemeData webnovel() =>
      NovelThemeData(colorScheme: NovelColorScheme.webnovel);

  /// Builds a ready-to-use Material [ThemeData] so a
  /// novel_ui theme also drives Material widgets (app bars, buttons,
  /// dialogs, navigation) consistently.
  ThemeData toMaterialTheme() {
    final cs = colorScheme;
    final base = ThemeData(
      useMaterial3: true,
      brightness: cs.brightness,
      visualDensity: visualDensity,
      materialTapTargetSize: materialTapTargetSize,
      fontFamily: fontFamily,
    );
    final colorScheme3 = base.colorScheme.copyWith(
      primary: cs.primary,
      onPrimary: cs.onPrimary,
      secondary: cs.secondary,
      surface: cs.surface,
      surfaceContainerLowest: cs.background,
      error: cs.error,
    );
    final scaffoldBackground = cs.background;

    return base.copyWith(
      extensions: [this],
      colorScheme: colorScheme3,
      scaffoldBackgroundColor: scaffoldBackground,
      canvasColor: cs.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        foregroundColor: cs.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: cs.textPrimary,
          fontFamily: fontFamily,
        ),
      ),
      cardTheme: CardThemeData(
        color: cs.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NovelDimens.radiusLg),
          side: BorderSide(color: cs.border),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: DividerThemeData(color: cs.border, thickness: 1, space: 1),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: cs.surfaceLow,
        labelStyle: TextStyle(color: cs.textSecondary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NovelDimens.radiusSm + 2),
        ),
        side: BorderSide.none,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cs.surface,
        indicatorColor: cs.primaryContainer,
        height: NovelDimens.bottomNavHeight,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            color: states.contains(WidgetState.selected)
                ? cs.primary
                : cs.textSecondary,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return TextStyle(
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? cs.primary
                : cs.textSecondary,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          minimumSize: const Size(64, NovelDimens.buttonHeightMd),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NovelDimens.buttonHeightMd / 2),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: cs.textPrimary,
          side: BorderSide(color: cs.border),
          minimumSize: const Size(64, NovelDimens.buttonHeightMd),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NovelDimens.buttonHeightMd / 2),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cs.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cs.surface,
        modalBackgroundColor: cs.surface,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: cs.primary,
        inactiveTrackColor: cs.surfaceLow,
        thumbColor: cs.primary,
        overlayColor: cs.primary.withValues(alpha: 0.12),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: cs.primary,
        unselectedLabelColor: cs.textSecondary,
        indicatorColor: cs.primary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: cs.primary),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? cs.onPrimary : cs.border,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? cs.primary : cs.surfaceLow,
        ),
      ),
    );
  }

  @override
  NovelThemeData copyWith({
    NovelColorScheme? colorScheme,
    NovelReaderSettings? readerSettings,
    NovelStrings? strings,
    NovelComponentsTheme? components,
    String? fontFamily,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? materialTapTargetSize,
  }) {
    return NovelThemeData(
      colorScheme: colorScheme ?? this.colorScheme,
      readerSettings: readerSettings ?? this.readerSettings,
      strings: strings ?? this.strings,
      components: components ?? this.components,
      fontFamily: fontFamily ?? this.fontFamily,
      visualDensity: visualDensity ?? this.visualDensity,
      materialTapTargetSize:
          materialTapTargetSize ?? this.materialTapTargetSize,
    );
  }

  /// Instance-level lerp required by [ThemeExtension]; animates every
  /// color role when Material interpolates light↔dark.
  @override
  NovelThemeData lerp(covariant NovelThemeData? other, double t) =>
      other == null ? this : _lerpStatic(this, other, t);

  @override
  Type get type => NovelThemeData;

  static NovelThemeData _lerpStatic(NovelThemeData a, NovelThemeData b, double t) {
    return NovelThemeData(
      colorScheme: NovelColorScheme.lerp(a.colorScheme, b.colorScheme, t),
      readerSettings: t < 0.5 ? a.readerSettings : b.readerSettings,
      strings: NovelStrings.lerp(a.strings, b.strings, t),
      components: NovelComponentsTheme.lerp(a.components, b.components, t),
      fontFamily: t < 0.5 ? a.fontFamily : b.fontFamily,
      visualDensity: t < 0.5 ? a.visualDensity : b.visualDensity,
      materialTapTargetSize: t < 0.5
          ? a.materialTapTargetSize
          : b.materialTapTargetSize,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('colorScheme', colorScheme));
    properties.add(DiagnosticsProperty('readerSettings', readerSettings));
    properties.add(DiagnosticsProperty('strings', strings));
    properties.add(DiagnosticsProperty('components', components));
    properties.add(DiagnosticsProperty('components', components));
  }
}

/// Provides [NovelThemeData] down the tree.
class NovelTheme extends InheritedTheme {
  const NovelTheme({super.key, required this.data, required super.child});

  final NovelThemeData data;

  static NovelThemeData of(BuildContext context) {
    final theme = context
        .dependOnInheritedWidgetOfExactType<_NovelInheritedTheme>();
    return theme?.theme.data ?? NovelThemeData.light();
  }

  /// Like [of] but returns null when no [NovelTheme] ancestor exists and does
  /// not establish a dependency when [listen] is false.
  static NovelThemeData? maybeOf(BuildContext context, {bool listen = true}) {
    if (listen) {
      final theme = context
          .dependOnInheritedWidgetOfExactType<_NovelInheritedTheme>();
      return theme?.theme.data;
    }
    final theme = context.getInheritedWidgetOfExactType<_NovelInheritedTheme>();
    return theme?.theme.data;
  }

  @override
  bool updateShouldNotify(NovelTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return _NovelInheritedTheme(theme: this, child: child);
  }
}

class _NovelInheritedTheme extends InheritedWidget {
  const _NovelInheritedTheme({required this.theme, required super.child});

  final NovelTheme theme;

  @override
  bool updateShouldNotify(_NovelInheritedTheme oldWidget) =>
      theme.data != oldWidget.theme.data;
}
