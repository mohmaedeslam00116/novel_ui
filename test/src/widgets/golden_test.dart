import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:novel_ui/novel_ui.dart';

import '../helpers/golden_helpers.dart';

void main() {
  goldenTest(
    'NovelBookCard renders in all theme directions',
    fileName: 'book_card',
    builder: () => wnMatrix(
      builder: (theme) => NovelBookCard(book: fakeBook, updateCount: 12),
    ),
  );

  goldenTest(
    'NovelChapterTile states in all theme directions',
    fileName: 'chapter_tile',
    builder: () => wnMatrix(
      builder: (theme) => const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NovelChapterTile(
            chapter: NovelChapter(
              id: 'c1',
              index: 1,
              title: 'The Beginning',
              wordCount: 2100,
            ),
            isRead: true,
          ),
          NovelChapterTile(
            chapter: NovelChapter(
              id: 'c2',
              index: 2,
              title: 'Locked Gate',
              isLocked: true,
              isVip: true,
              coinCost: 8,
            ),
          ),
        ],
      ),
    ),
  );

  goldenTest(
    'NovelRatingBar + badges in all theme directions',
    fileName: 'rating_badges',
    builder: () => wnMatrix(
      builder: (theme) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const NovelRatingBar(value: 4.3, showValueLabel: true),
          const SizedBox(height: 10),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              NovelTagChip('Eastern Fantasy', selected: true),
              NovelTagChip('Cultivation'),
              NovelUpdateBadge(count: 12),
              NovelFansRankBadge(rank: 1),
              NovelLevelBadge(level: 15),
            ],
          ),
        ],
      ),
    ),
  );
}
