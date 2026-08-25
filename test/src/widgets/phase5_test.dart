import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novel_ui/novel_ui.dart';

class _CapturingDriver extends NovelTtsDriver {
  final List<String> spoken = [];
  int stopCount = 0;

  @override
  Future<void> speak(String text) async => spoken.add(text);

  @override
  Future<void> stop() async => stopCount++;
}

void main() {
  group('NovelReaderSettings.backImage', () {
    test('defaults to null paper', () {
      const s = NovelReaderSettings();
      expect(s.backImage, isNull);
      expect(s.backImageDim, 0.35);
    });

    test('set and clear backImage', () {
      const s = NovelReaderSettings();
      final withBg = s.copyWith(backImage: 'assets/bg_paper.jpg');
      expect(withBg.backImage, 'assets/bg_paper.jpg');

      final cleared = withBg.copyWith(clearBackImage: true);
      expect(cleared.backImage, isNull);

      // Dim only affects legibility, not presence.
      expect(withBg.copyWith(backImageDim: 0.6).backImage, isNotNull);
    });
  });

  group('NovelDanmakuController', () {
    test('emits added comments on the stream', () async {
      final controller = NovelDanmakuController();
      final received = <String>[];
      final sub = controller.stream.listen(received.add);
      await Future<void>.delayed(Duration.zero);

      controller.add('Hello panel!');
      controller.add('   '); // blank comments are dropped
      await Future<void>.delayed(Duration.zero);

      expect(received, ['Hello panel!']);
      await sub.cancel();
      await controller.close();
    });
  });

  group('NovelTtsPanel', () {
    testWidgets('speaks current paragraph and advances on completion', (
      tester,
    ) async {
      final driver = _CapturingDriver();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovelTtsPanel(
              paragraphs: const ['One', 'Two', 'Three'],
              driver: driver,
            ),
          ),
        ),
      );

      // Not playing yet — nothing spoken.
      expect(driver.spoken, isEmpty);

      // Press play → speaks paragraph 1.
      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      expect(driver.spoken, ['One']);

      // Engine reports completion → advances to paragraph 2.
      driver.onUtteranceComplete!();
      await tester.pump();
      expect(driver.spoken, ['One', 'Two']);
      expect(find.textContaining('2 / 3'), findsOneWidget);

      // Pause stops the driver.
      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      expect(driver.stopCount, greaterThanOrEqualTo(1));
    });

    testWidgets('tapping a paragraph jumps playback to it', (tester) async {
      final driver = _CapturingDriver();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovelTtsPanel(
              paragraphs: const ['One', 'Two', 'Three'],
              driver: driver,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Three'));
      await tester.pump();
      // Tap only selects; play starts speech at the selected index.
      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      expect(driver.spoken.last, 'Three');
    });
  });
}
