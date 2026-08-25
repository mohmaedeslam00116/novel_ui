import 'package:flutter/painting.dart';

/// A slice of a chapter assigned to exactly one page.
class WnReaderSegment {
  const WnReaderSegment({required this.paragraphIndex, required this.text});

  /// Index into the original paragraphs list.
  final int paragraphIndex;
  final String text;

  bool get isEmpty => text.isEmpty;
}

/// One laid-out page of the reader.
class WnReaderPage {
  const WnReaderPage(this.segments);

  final List<WnReaderSegment> segments;
}

/// Splits flowing text into fixed-size pages using real text metrics,
/// mirroring what native novel-reader engines do.
///
/// The engine measures every paragraph with [TextPainter] against the live
/// viewport size and font settings, then packs lines into pages — so page
/// breaks land exactly where they will render, even mid-paragraph.
abstract final class WnTextPaginator {
  static List<WnReaderPage> paginate({
    required List<String> paragraphs,
    required double maxWidth,
    required double maxHeight,
    required TextStyle style,
    required double paragraphSpacing,
  }) {
    assert(maxWidth > 0 && maxHeight.isFinite && maxHeight > 0);
    final pages = <WnReaderPage>[];

    var currentPage = <WnReaderSegment>[];
    var usedHeight = 0.0;
    var lastParagraphInPage = -1;

    void flushPage() {
      if (currentPage.isNotEmpty) {
        pages.add(WnReaderPage(List.of(currentPage)));
        currentPage = <WnReaderSegment>[];
        usedHeight = 0;
        lastParagraphInPage = -1;
      }
    }

    for (var p = 0; p < paragraphs.length; p++) {
      var remaining = paragraphs[p];
      // Blank paragraph = scene break spacer.
      if (remaining.trim().isEmpty) {
        final gap = style.fontSize! * (style.height ?? 1.4);
        if (currentPage.isNotEmpty && usedHeight + gap > maxHeight) {
          flushPage();
        }
        currentPage.add(WnReaderSegment(paragraphIndex: p, text: ''));
        usedHeight += gap;
        continue;
      }

      final tp = TextPainter(textDirection: TextDirection.ltr, maxLines: null);
      while (remaining.isNotEmpty) {
        final isFirstOnPage = lastParagraphInPage != p;
        final spacingCost = (isFirstOnPage || lastParagraphInPage == -1)
            ? 0
            : paragraphSpacing;
        final available = maxHeight - usedHeight - spacingCost;

        final lineHeightPx = style.fontSize! * (style.height ?? 1.4);
        if (available < lineHeightPx * 0.9 && currentPage.isNotEmpty) {
          flushPage();
          continue;
        }
        // Degenerate viewport (line taller than the page): allow a single
        // overflowing line rather than looping forever.

        tp.text = TextSpan(text: remaining, style: style);
        tp.layout(maxWidth: maxWidth);

        if (tp.height <= available) {
          currentPage.add(WnReaderSegment(paragraphIndex: p, text: remaining));
          usedHeight += spacingCost + tp.height;
          lastParagraphInPage = p;
          break;
        }

        // Find the character position where the vertical budget runs out.
        final pos = tp.getPositionForOffset(Offset(maxWidth, available)).offset;
        var cut = _wordBoundary(remaining, pos.clamp(1, remaining.length));

        if (cut <= 0) {
          // Degenerate case: not even one word fits — hard split.
          cut = 1;
        }
        if (cut >= remaining.length) {
          currentPage.add(WnReaderSegment(paragraphIndex: p, text: remaining));
          usedHeight += spacingCost + tp.height;
          lastParagraphInPage = p;
          break;
        }
        final head = remaining.substring(0, cut);
        final headPainter = TextPainter(
          text: TextSpan(text: head, style: style),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: maxWidth);

        if (!isFirstOnPage) usedHeight += spacingCost;
        currentPage.add(WnReaderSegment(paragraphIndex: p, text: head));
        usedHeight += headPainter.height;
        lastParagraphInPage = p;
        flushPage();
        remaining = remaining.substring(cut).trimLeft();
      }
      tp.dispose();
    }
    flushPage();
    return pages;
  }

  /// Backs the cut off to the nearest space so words never split across
  /// pages.
  static int _wordBoundary(String text, int pos) {
    if (pos >= text.length) return text.length;
    var i = pos;
    while (i > 0 && !text.codeUnits[i].isSpaceLike) {
      i--;
    }
    return i == 0 ? pos : i;
  }
}

extension _CharCheck on int {
  bool get isSpaceLike =>
      this == 0x20 || this == 0x09 || this == 0x2C || this == 0x2E;
}
