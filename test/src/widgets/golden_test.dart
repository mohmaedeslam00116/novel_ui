import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:wn_design/wn_design.dart';

import '../helpers/golden_helpers.dart';

void main() {
  goldenTest(
    'WnBookCard renders in all theme directions',
    fileName: 'book_card',
    builder: () => wnMatrix(
      builder: (theme) => WnBookCard(book: fakeBook, updateCount: 12),
    ),
  );

  goldenTest(
    'WnChapterTile states in all theme directions',
    fileName: 'chapter_tile',
    builder: () => wnMatrix(
      builder: (theme) => const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          WnChapterTile(
            chapter: WnChapter(
              id: 'c1',
              index: 1,
              title: 'The Beginning',
              wordCount: 2100,
            ),
            isRead: true,
          ),
          WnChapterTile(
            chapter: WnChapter(
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
    'WnRatingBar + badges in all theme directions',
    fileName: 'rating_badges',
    builder: () => wnMatrix(
      builder: (theme) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const WnRatingBar(value: 4.3, showValueLabel: true),
          const SizedBox(height: 10),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              WnTagChip('Eastern Fantasy', selected: true),
              WnTagChip('Cultivation'),
              WnUpdateBadge(count: 12),
              WnFansRankBadge(rank: 1),
              WnLevelBadge(level: 15),
            ],
          ),
        ],
      ),
    ),
  );
}
