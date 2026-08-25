import 'package:flutter/material.dart';

import '../models/wn_book.dart';
import '../tokens/wn_dimens.dart';
import '../theme/wn_theme.dart';
import 'wn_cover_view.dart';
import 'wn_rating_bar.dart';

/// Numbered ranking row — the signature look of novel ranking screens:
/// big rank number, cover, title, category tag and score.
class WnRankListItem extends StatelessWidget {
  const WnRankListItem({
    super.key,
    required this.rank,
    required this.book,
    this.onTap,
    this.rankStyle = WnRankStyle.plain,
  });

  /// Medal-styled row for the top three ranks.
  const WnRankListItem.topThree({
    super.key,
    required this.rank,
    required this.book,
    this.onTap,
  }) : rankStyle = WnRankStyle.topThree;

  final int rank;
  final WnBook book;
  final VoidCallback? onTap;
  final WnRankStyle rankStyle;

  @override
  Widget build(BuildContext context) {
    final cs = WnTheme.of(context).colorScheme;
    final t = WnTheme.of(context).components.rankListItem;

    final Color rankColor;
    if (rank <= 3 && rankStyle == WnRankStyle.topThree) {
      rankColor = switch (rank) {
        1 => const Color(0xFFFF4D4F),
        2 => const Color(0xFFFF9F43),
        _ => const Color(0xFFF1C40F),
      };
    } else {
      rankColor = cs.textTertiary;
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: WnDimens.screenPadding,
          vertical: WnDimens.md,
        ),
        child: Row(
          children: [
            SizedBox(
              width: t.rankWidth ?? 34,
              child: Text(
                '$rank',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: rank <= 3 && rankStyle == WnRankStyle.topThree
                      ? 20
                      : 15,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  color: rankColor,
                ),
              ),
            ),
            const SizedBox(width: WnDimens.md),
            WnCoverView(
              url: book.coverUrl,
              title: book.title,
              author: book.author,
              width: t.coverWidth ?? WnDimens.listCoverWidth * 0.86,
            ),
            const SizedBox(width: WnDimens.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: cs.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          book.category ?? book.tags.firstOrNull ?? book.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: cs.textTertiary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.local_fire_department_rounded,
                        size: 13,
                        color: cs.textTertiary,
                      ),
                      Text(
                        _compactCount(book.viewCount),
                        style: TextStyle(fontSize: 11, color: cs.textTertiary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      WnRatingBar(value: book.score, size: 12),
                      const Spacer(),
                      Text(
                        book.score > 0 ? book.score.toStringAsFixed(1) : 'New',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: book.score >= 4.0
                              ? cs.primary
                              : cs.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum WnRankStyle { plain, topThree }

String _compactCount(int n) {
  if (n >= 1000000000) return '${(n / 1000000000).toStringAsFixed(1)}B';
  if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
  return '$n';
}

/// Formats counts (views/collections) compactly; exported for reuse.
String wnCompactCount(int n) => _compactCount(n);
