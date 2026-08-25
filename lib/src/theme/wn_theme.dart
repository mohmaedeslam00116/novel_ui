import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../tokens/wn_dimens.dart';
import 'wn_color_scheme.dart';
import 'wn_component_themes.dart';
import 'wn_reader_theme.dart';
import 'wn_strings.dart';

/// Root configuration object for the wn_design library.
///
/// Provide it above your app with [WnTheme] (usually wrapping
/// `MaterialApp`) and access it anywhere via `WnTheme.of(context)`.
@immutable
class WnThemeData with Diagnosticable implements ThemeExtension<WnThemeData> {
  WnThemeData({
    WnColorScheme? colorScheme,
    Brightness brightness = Brightness.light,
    WnReaderSettings? readerSettings,
    WnStrings? strings,
    WnComponentsTheme? components,
    this.visualDensity,
    this.fontFamily,
    this.materialTapTargetSize,
  }) : colorScheme =
           colorScheme ??
           (brightness == Brightness.dark
               ? WnColorScheme.dark
               : WnColorScheme.light),
       readerSettings = readerSettings ?? const WnReaderSettings(),
       strings = strings ?? WnStrings.en(),
       components = components ?? WnComponentsTheme();

  /// Semantic colors for the current brightness.
  final WnColorScheme colorScheme;

  /// Library-wide default reader preferences.
  final WnReaderSettings readerSettings;

  /// User-facing labels for all wn_design widgets.
  final WnStrings strings;

  /// Per-component themes (book cards, chapter tiles, comments, ranks,
  /// section headers). All their fields are nullable — widgets resolve
  /// `widget.field ?? componentTheme.field ?? default`.
  final WnComponentsTheme components;

  /// Optional app-wide font family override.
  final String? fontFamily;
  final VisualDensity? visualDensity;
  final MaterialTapTargetSize? materialTapTargetSize;

  static WnThemeData light() => WnThemeData(brightness: Brightness.light);
  static WnThemeData dark() => WnThemeData(brightness: Brightness.dark);

  /// Preset matching the real Webnovel app's 2024+ blue rebrand — colors
  /// extracted from the shipped APK's own icon set (see
  /// webnovel_design_reference/DESIGN_REPORT.md).
  static WnThemeData webnovel() =>
      WnThemeData(colorScheme: WnColorScheme.webnovel);

  /// Builds a ready-to-use Material [ThemeData] so a
  /// wn_design theme also drives Material widgets (app bars, buttons,
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
          borderRadius: BorderRadius.circular(WnDimens.radiusLg),
          side: BorderSide(color: cs.border),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: DividerThemeData(color: cs.border, thickness: 1, space: 1),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: cs.surfaceLow,
        labelStyle: TextStyle(color: cs.textSecondary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WnDimens.radiusSm + 2),
        ),
        side: BorderSide.none,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cs.surface,
        indicatorColor: cs.primaryContainer,
        height: WnDimens.bottomNavHeight,
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
          minimumSize: const Size(64, WnDimens.buttonHeightMd),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WnDimens.buttonHeightMd / 2),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: cs.textPrimary,
          side: BorderSide(color: cs.border),
          minimumSize: const Size(64, WnDimens.buttonHeightMd),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WnDimens.buttonHeightMd / 2),
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
  WnThemeData copyWith({
    WnColorScheme? colorScheme,
    WnReaderSettings? readerSettings,
    WnStrings? strings,
    WnComponentsTheme? components,
    String? fontFamily,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? materialTapTargetSize,
  }) {
    return WnThemeData(
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
  WnThemeData lerp(covariant WnThemeData? other, double t) =>
      other == null ? this : _lerpStatic(this, other, t);

  @override
  Type get type => WnThemeData;

  static WnThemeData _lerpStatic(WnThemeData a, WnThemeData b, double t) {
    return WnThemeData(
      colorScheme: WnColorScheme.lerp(a.colorScheme, b.colorScheme, t),
      readerSettings: t < 0.5 ? a.readerSettings : b.readerSettings,
      strings: WnStrings.lerp(a.strings, b.strings, t),
      components: WnComponentsTheme.lerp(a.components, b.components, t),
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

/// Provides [WnThemeData] down the tree.
class WnTheme extends InheritedTheme {
  const WnTheme({super.key, required this.data, required super.child});

  final WnThemeData data;

  static WnThemeData of(BuildContext context) {
    final theme = context
        .dependOnInheritedWidgetOfExactType<_WnInheritedTheme>();
    return theme?.theme.data ?? WnThemeData.light();
  }

  /// Like [of] but returns null when no [WnTheme] ancestor exists and does
  /// not establish a dependency when [listen] is false.
  static WnThemeData? maybeOf(BuildContext context, {bool listen = true}) {
    if (listen) {
      final theme = context
          .dependOnInheritedWidgetOfExactType<_WnInheritedTheme>();
      return theme?.theme.data;
    }
    final theme = context.getInheritedWidgetOfExactType<_WnInheritedTheme>();
    return theme?.theme.data;
  }

  @override
  bool updateShouldNotify(WnTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return _WnInheritedTheme(theme: this, child: child);
  }
}

class _WnInheritedTheme extends InheritedWidget {
  const _WnInheritedTheme({required this.theme, required super.child});

  final WnTheme theme;

  @override
  bool updateShouldNotify(_WnInheritedTheme oldWidget) =>
      theme.data != oldWidget.theme.data;
}
