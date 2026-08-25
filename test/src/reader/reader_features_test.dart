import 'package:flutter_test/flutter_test.dart';
import 'package:wn_design/wn_design.dart';

void main() {
  group('WnReaderSettings new fields', () {
    test('defaults are off and slide', () {
      const s = WnReaderSettings();
      expect(s.autoScroll, isFalse);
      expect(s.autoScrollSpeed, 60);
      expect(s.pageFlip, WnPageFlip.slide);
    });

    test('copyWith toggles autoScroll without touching speed', () {
      const s = WnReaderSettings();
      final on = s.copyWith(autoScroll: true);
      expect(on.autoScroll, isTrue);
      expect(on.autoScrollSpeed, 60);

      final faster = on.copyWith(autoScrollSpeed: 120);
      expect(faster.autoScroll, isTrue);
      expect(faster.autoScrollSpeed, 120);
    });

    test('pageFlip switches styles', () {
      const s = WnReaderSettings();
      expect(s.copyWith(pageFlip: WnPageFlip.cover).pageFlip, WnPageFlip.cover);
    });
  });

  group('WnFontManager registry', () {
    test('starts empty and reports unknown families as unloaded', () {
      final manager = WnFontManager.instance;
      expect(manager.isLoaded('DefinitelyNotLoadedFont'), isFalse);
      expect(manager.loadedFamilies, isA<List<String>>());
    });
  });
}
