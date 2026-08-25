import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:novel_ui/novel_ui.dart';

Widget _app(Widget child) => NovelTheme(
  data: NovelThemeData.light(),
  child: MaterialApp(
    theme: NovelThemeData.light().toMaterialTheme(),
    home: Scaffold(body: Center(child: child)),
  ),
);

void main() {
  group('NovelThemeData', () {
    test('light and dark presets differ in brightness', () {
      final light = NovelThemeData.light();
      final dark = NovelThemeData.dark();
      expect(light.colorScheme.isDark, isFalse);
      expect(dark.colorScheme.isDark, isTrue);
    });

    test('copyWith overrides only given fields', () {
      final base = NovelThemeData.light();
      final custom = base.copyWith(
        colorScheme: base.colorScheme.copyWith(primary: Colors.purple),
      );
      expect(custom.colorScheme.primary, Colors.purple);
      expect(custom.readerSettings, base.readerSettings);
    });

    test('lerp between light and dark keeps valid scheme', () {
      final mid = NovelThemeData.light().lerp(NovelThemeData.dark(), 0.5);
      expect(mid.colorScheme.background, isNotNull);
    });

    test('ThemeExtension registration survives toMaterialTheme', () {
      final material = NovelThemeData.light().toMaterialTheme();
      final carried = material.extension<NovelThemeData>();
      expect(carried, isA<NovelThemeData>());
    });

    testWidgets('toMaterialTheme produces usable ThemeData', (tester) async {
      await tester.pumpWidget(_app(const SizedBox()));
      final context = tester.element(find.byType(Scaffold));
      expect(Theme.of(context).scaffoldBackgroundColor, isNotNull);
    });
  });

  testWidgets('NovelRatingBar interactive taps update value', (tester) async {
    double? picked;
    await tester.pumpWidget(
      _app(NovelRatingBar(value: 2, size: 24, onChanged: (v) => picked = v)),
    );
    // Tap near the middle of the 5-star row → should pick ~3 stars.
    await tester.tap(find.byType(NovelRatingBar));
    await tester.pump();
    expect(picked, isNotNull);
    expect(picked, greaterThan(0));
    expect(picked, lessThanOrEqualTo(5));
  });

  testWidgets('NovelBookCard renders generated cover when no URL', (tester) async {
    await tester.pumpWidget(
      _app(
        const NovelBookCard(
          book: NovelBook(id: '1', title: 'Test Novel', author: 'A'),
        ),
      ),
    );
    await tester.pump();
    // Title renders twice: once on the generated cover, once below it.
    expect(find.text('Test Novel'), findsNWidgets(2));
    expect(find.byType(NovelCoverView), findsOneWidget);
  });

  testWidgets('NovelChapterTile shows lock + coin cost for locked chapter', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const NovelChapterTile(
          chapter: NovelChapter(
            id: 'c1',
            index: 9,
            title: 'Locked One',
            isLocked: true,
            coinCost: 8,
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('9. Locked One'), findsOneWidget);
    expect(find.byIcon(Icons.lock_rounded), findsOneWidget);
    expect(find.text('8'), findsOneWidget);
  });
}
