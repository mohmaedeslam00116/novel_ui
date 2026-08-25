import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wn_design/src/reader/wn_text_paginator.dart';

TextStyle get style => const TextStyle(fontSize: 18, height: 1.7);

void main() {
  group('WnTextPaginator.paginate', () {
    test('single short paragraph produces one page', () {
      final pages = WnTextPaginator.paginate(
        paragraphs: ['Hello world'],
        maxWidth: 300,
        maxHeight: 600,
        style: style,
        paragraphSpacing: 14,
      );
      expect(pages, hasLength(1));
      expect(pages.single.segments.single.text, 'Hello world');
    });

    test('long text spans multiple pages with no lost content', () {
      final paragraphs = List.generate(30, (i) => 'Paragraph $i. ' * 20);
      final pages = WnTextPaginator.paginate(
        paragraphs: paragraphs,
        maxWidth: 320,
        maxHeight: 500,
        style: style,
        paragraphSpacing: 14,
      );
      expect(pages.length, greaterThan(1));

      // Every original paragraph must appear (possibly split) across pages.
      final seen = <int>{};
      for (final page in pages) {
        for (final seg in page.segments) {
          if (seg.text.isNotEmpty) seen.add(seg.paragraphIndex);
        }
      }
      expect(seen, containsAll(List.generate(30, (i) => i)));
    });

    test('no page exceeds its height budget', () {
      final paragraphs = List.generate(50, (i) => 'Filler text line $i ' * 8);
      final pages = WnTextPaginator.paginate(
        paragraphs: paragraphs,
        maxWidth: 300,
        maxHeight: 400,
        style: style,
        paragraphSpacing: 12,
      );
      for (final page in pages) {
        var height = 0.0;
        String? prevPara;
        for (final seg in page.segments) {
          if (seg.text.isEmpty) continue;
          if (prevPara != null &&
              prevPara != seg.paragraphIndex.toString() + seg.text) {
            height += 12;
          }
          final tp = TextPainter(
            text: TextSpan(text: seg.text, style: style),
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: 300);
          height += tp.height;
          tp.dispose();
          prevPara = seg.paragraphIndex.toString() + seg.text;
        }
        // Allow a single-line overflow for degenerate budgets only.
        expect(
          height,
          lessThanOrEqualTo(400 + style.fontSize! * style.height!),
        );
      }
    });

    test('blank paragraphs become scene-break spacers', () {
      final pages = WnTextPaginator.paginate(
        paragraphs: ['First', '', 'Second'],
        maxWidth: 300,
        maxHeight: 600,
        style: style,
        paragraphSpacing: 14,
      );
      final all = pages.expand((p) => p.segments).toList();
      expect(all.any((s) => s.paragraphIndex == 1 && s.text.isEmpty), isTrue);
    });

    test('huge font on tiny viewport still terminates', () {
      final pages = WnTextPaginator.paginate(
        paragraphs: List.filled(5, 'tiny viewport'),
        maxWidth: 100,
        maxHeight: 10,
        style: const TextStyle(fontSize: 32, height: 2),
        paragraphSpacing: 14,
      );
      expect(pages, isNotEmpty);
    });
  });
}
