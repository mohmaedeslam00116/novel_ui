import 'package:flutter_test/flutter_test.dart';
import 'package:novel_ui/novel_ui.dart';

void main() {
  group('NovelReaderSettings new fields', () {
    test('defaults are off and slide', () {
      const s = NovelReaderSettings();
      expect(s.autoScroll, isFalse);
      expect(s.autoScrollSpeed, 60);
      expect(s.pageFlip, NovelPageFlip.slide);
    });

    test('copyWith toggles autoScroll without touching speed', () {
      const s = NovelReaderSettings();
      final on = s.copyWith(autoScroll: true);
      expect(on.autoScroll, isTrue);
      expect(on.autoScrollSpeed, 60);

      final faster = on.copyWith(autoScrollSpeed: 120);
      expect(faster.autoScroll, isTrue);
      expect(faster.autoScrollSpeed, 120);
    });

    test('pageFlip switches styles', () {
      const s = NovelReaderSettings();
      expect(s.copyWith(pageFlip: NovelPageFlip.cover).pageFlip, NovelPageFlip.cover);
    });
  });

  group('NovelFontManager registry', () {
    test('starts empty and reports unknown families as unloaded', () {
      final manager = NovelFontManager.instance;
      expect(manager.isLoaded('DefinitelyNotLoadedFont'), isFalse);
      expect(manager.loadedFamilies, isA<List<String>>());
    });
  });
}
