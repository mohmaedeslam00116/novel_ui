import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wn_design/wn_design.dart';

Widget _app(Widget child) => WnTheme(
  data: WnThemeData.light(),
  child: MaterialApp(
    theme: WnThemeData.light().toMaterialTheme(),
    home: Scaffold(body: Center(child: child)),
  ),
);

void main() {
  group('WnThemeData', () {
    test('light and dark presets differ in brightness', () {
      final light = WnThemeData.light();
      final dark = WnThemeData.dark();
      expect(light.colorScheme.isDark, isFalse);
      expect(dark.colorScheme.isDark, isTrue);
    });

    test('copyWith overrides only given fields', () {
      final base = WnThemeData.light();
      final custom = base.copyWith(
        colorScheme: base.colorScheme.copyWith(primary: Colors.purple),
      );
      expect(custom.colorScheme.primary, Colors.purple);
      expect(custom.readerSettings, base.readerSettings);
    });

    test('lerp between light and dark keeps valid scheme', () {
      final mid = WnThemeData.light().lerp(WnThemeData.dark(), 0.5);
      expect(mid.colorScheme.background, isNotNull);
    });

    test('ThemeExtension registration survives toMaterialTheme', () {
      final material = WnThemeData.light().toMaterialTheme();
      final carried = material.extension<WnThemeData>();
      expect(carried, isA<WnThemeData>());
    });

    testWidgets('toMaterialTheme produces usable ThemeData', (tester) async {
      await tester.pumpWidget(_app(const SizedBox()));
      final context = tester.element(find.byType(Scaffold));
      expect(Theme.of(context).scaffoldBackgroundColor, isNotNull);
    });
  });

  testWidgets('WnRatingBar interactive taps update value', (tester) async {
    double? picked;
    await tester.pumpWidget(
      _app(WnRatingBar(value: 2, size: 24, onChanged: (v) => picked = v)),
    );
    // Tap near the middle of the 5-star row → should pick ~3 stars.
    await tester.tap(find.byType(WnRatingBar));
    await tester.pump();
    expect(picked, isNotNull);
    expect(picked, greaterThan(0));
    expect(picked, lessThanOrEqualTo(5));
  });

  testWidgets('WnBookCard renders generated cover when no URL', (tester) async {
    await tester.pumpWidget(
      _app(
        const WnBookCard(
          book: WnBook(id: '1', title: 'Test Novel', author: 'A'),
        ),
      ),
    );
    await tester.pump();
    // Title renders twice: once on the generated cover, once below it.
    expect(find.text('Test Novel'), findsNWidgets(2));
    expect(find.byType(WnCoverView), findsOneWidget);
  });

  testWidgets('WnChapterTile shows lock + coin cost for locked chapter', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const WnChapterTile(
          chapter: WnChapter(
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
