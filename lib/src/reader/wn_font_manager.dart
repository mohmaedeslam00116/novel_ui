import 'package:flutter/services.dart';

import '../theme/wn_reader_theme.dart';

/// Runtime font-loading bridge — wn_design's equivalent of the official
/// app's `FlutterFontManager` (recovered from its Flutter shell).
///
/// Novel apps routinely let readers install reading fonts, including
/// dedicated Arabic content fonts (`SettingArabicContentFont` in the
/// official settings registry). Because fonts must be registered with the
/// engine before first use, load the bytes once, then reference the family
/// name in [WnReaderSettings.fontFamily]:
///
/// ```dart
/// // From bundled assets:
/// await WnFontManager.instance.loadFromAsset(
///   'WN Arabic Book', 'assets/fonts/NotoNaskhArabic.ttf');
///
/// // From bytes you fetched anywhere (network, file picker…):
/// await WnFontManager.instance.load('WN Arabic Book', () => byteData);
///
/// readerSettings = readerSettings.copyWith(fontFamily: 'WN Arabic Book');
/// ```
///
/// The manager deliberately avoids `dart:io`, so it works on every
/// platform including web; fetching from a URL is the caller's job.
class WnFontManager {
  WnFontManager._();

  /// Shared singleton.
  static final WnFontManager instance = WnFontManager._();

  final Set<String> _loaded = {};

  /// Families successfully registered with the engine this session.
  List<String> get loadedFamilies => List.unmodifiable(_loaded);

  /// Whether [family] has been loaded in this session.
  bool isLoaded(String family) => _loaded.contains(family);

  /// Registers font [bytes] under [family] with the Flutter engine.
  ///
  /// Loading the same family twice re-registers it harmlessly; prefer
  /// checking [isLoaded] to skip redundant work.
  Future<void> load(String family, ByteData bytes) async {
    final loader = FontLoader(family)..addFont(Future.value(bytes));
    await loader.load();
    _loaded.add(family);
  }

  /// Convenience for fonts bundled in the app's asset bundle.
  Future<void> loadFromAsset(String family, String assetPath) async {
    if (isLoaded(family)) return;
    final bytes = await rootBundle.load(assetPath);
    await load(family, bytes);
  }

  /// Convenience that accepts a [Future] of bytes (e.g. an in-flight
  /// download) so callers can pipeline fetch + registration.
  Future<void> loadLazy(String family, Future<ByteData> Function() fetch) =>
      orLoad(family, fetch);

  Future<void> orLoad(String family, Future<ByteData> Function() fetch) async {
    if (isLoaded(family)) return;
    await load(family, await fetch());
  }
}
