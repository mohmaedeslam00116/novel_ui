import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'novel_color_scheme.dart';

/// Colors for the reading surface, decoupled from the app theme so the
/// reader can be sepia while the rest of the app is dark.
@immutable
class NovelReaderColors with Diagnosticable {
  const NovelReaderColors({
    required this.paper,
    required this.text,
    this.secondaryText = const Color(0xFF8C8C8C),
    this.controlBackground = const Color(0xFFF2F2F2),
    this.link = const Color(0xFF0984E3),
  });

  /// Page background.
  final Color paper;
  final Color text;
  final Color secondaryText;

  /// Background of sliders / controls overlaid on the reader.
  final Color controlBackground;
  final Color link;

  NovelReaderColors copyWith({
    Color? paper,
    Color? text,
    Color? secondaryText,
    Color? controlBackground,
    Color? link,
  }) {
    return NovelReaderColors(
      paper: paper ?? this.paper,
      text: text ?? this.text,
      secondaryText: secondaryText ?? this.secondaryText,
      controlBackground: controlBackground ?? this.controlBackground,
      link: link ?? this.link,
    );
  }

  static NovelReaderColors lerp(NovelReaderColors a, NovelReaderColors b, double t) {
    return NovelReaderColors(
      paper: Color.lerp(a.paper, b.paper, t)!,
      text: Color.lerp(a.text, b.text, t)!,
      secondaryText: Color.lerp(a.secondaryText, b.secondaryText, t)!,
      controlBackground: Color.lerp(
        a.controlBackground,
        b.controlBackground,
        t,
      )!,
      link: Color.lerp(a.link, b.link, t)!,
    );
  }
}

/// User-tunable reading preferences held inside [NovelThemeData] as defaults
/// and overridable per-reader via `NovelReaderView.settings`.
@immutable
class NovelReaderSettings {
  const NovelReaderSettings({
    this.fontSize = 18,
    this.lineHeight = 1.7,
    this.paragraphSpacing = 14,
    this.fontFamily,
    this.paper = NovelReaderPaper.sepia,
    this.pageMode = false,
    this.keepScreenOn = true,
    this.autoScroll = false,
    this.autoScrollSpeed = 60,
    this.pageFlip = NovelPageFlip.slide,
    this.backImage,
    this.backImageDim = 0.35,
  });

  static const List<String> recommendedFontFamilies = [
    'Serif',
    'SansSerif',
    'monospace',
  ];

  /// Body font size in logical pixels (12–32).
  final double fontSize;

  /// Line height multiplier (1.0–2.4).
  final double lineHeight;

  /// Extra vertical gap between paragraphs in logical pixels.
  final double paragraphSpacing;

  /// Optional custom font family for the chapter body. Load custom fonts
  /// (e.g. an Arabic reading font) at runtime with [NovelFontManager], then
  /// reference the family name here.
  final String? fontFamily;
  final NovelReaderPaper paper;

  /// False = continuous vertical scroll; true = paginated pages.
  final bool pageMode;
  final bool keepScreenOn;

  /// Continuous automatic scrolling in scroll mode
  /// (the official app's `SettingAutoScroll`).
  final bool autoScroll;

  /// Auto-scroll speed in logical pixels per second (20–200).
  final double autoScrollSpeed;

  /// Page-turn animation style in page mode
  /// (the official app's `SettingFancyWay`).
  final NovelPageFlip pageFlip;

  /// Custom reading-background image — the official app's
  /// `SettingBackImage`. Network URLs (http/https) render via
  /// [Image.network]; anything else is treated as an asset-bundle path.
  /// When null the plain paper color is used.
  final String? backImage;

  /// Darkening scrim over [backImage] (0–1) so body text stays legible on
  /// busy artwork. Ignored without [backImage].
  final double backImageDim;

  NovelReaderSettings copyWith({
    double? fontSize,
    double? lineHeight,
    double? paragraphSpacing,
    String? fontFamily,
    bool clearFontFamily = false,
    NovelReaderPaper? paper,
    bool? pageMode,
    bool? keepScreenOn,
    bool? autoScroll,
    double? autoScrollSpeed,
    NovelPageFlip? pageFlip,
    String? backImage,
    bool clearBackImage = false,
    double? backImageDim,
  }) {
    return NovelReaderSettings(
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      paragraphSpacing: paragraphSpacing ?? this.paragraphSpacing,
      fontFamily: clearFontFamily ? null : (fontFamily ?? this.fontFamily),
      paper: paper ?? this.paper,
      pageMode: pageMode ?? this.pageMode,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      autoScroll: autoScroll ?? this.autoScroll,
      autoScrollSpeed: autoScrollSpeed ?? this.autoScrollSpeed,
      pageFlip: pageFlip ?? this.pageFlip,
      backImage: clearBackImage ? null : (backImage ?? this.backImage),
      backImageDim: backImageDim ?? this.backImageDim,
    );
  }
}

/// Page-turn transition styles for paginated mode.
enum NovelPageFlip {
  /// Horizontal slide — the platform default.
  slide,

  /// Depth/cover rotation with perspective, evoking a physical book.
  cover,

  /// No turn animation; taps jump straight to the target page.
  instant,
}
