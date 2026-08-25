import 'package:flutter/material.dart';

import '../models/novel_book.dart';
import '../theme/novel_theme.dart';

/// A row in a book's table of contents.
///
/// Shows word count, and lock/VIP/cost badges for premium chapters.
class NovelChapterTile extends StatelessWidget {
  const NovelChapterTile({
    super.key,
    required this.chapter,
    this.isRead = false,
    this.onTap,
  });

  final NovelChapter chapter;
  final bool isRead;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = NovelTheme.of(context).colorScheme;
    final t = NovelTheme.of(context).components.chapterTile;
    final locked = chapter.isLocked;

    return Semantics(
      button: onTap != null,
      container: true,
      label:
          'Chapter ${chapter.index}: ${chapter.title}'
          '${chapter.isLocked ? ', locked, ${chapter.coinCost} coins' : ''}',
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: t.horizontalPadding ?? 20,
            vertical: t.verticalPadding ?? 13,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${chapter.index}. ${chapter.title}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      (isRead ? t.readTitleStyle : t.titleStyle) ??
                      TextStyle(
                        fontSize: 14.5,
                        color: isRead ? cs.textTertiary : cs.textPrimary,
                      ),
                ),
              ),
              if ((t.showWordCount ?? true) && chapter.wordCount > 0) ...[
                const SizedBox(width: 8),
                Text(
                  '${chapter.wordCount}w',
                  style:
                      t.metaStyle ??
                      TextStyle(fontSize: 11, color: cs.textTertiary),
                ),
              ],
              if (chapter.isVip) ...[
                const SizedBox(width: 6),
                Icon(Icons.workspace_premium_rounded, size: 16, color: cs.vip),
              ],
              if (locked) ...[
                const SizedBox(width: 6),
                Icon(Icons.lock_rounded, size: 14, color: cs.textSecondary),
                if (chapter.coinCost > 0) ...[
                  const SizedBox(width: 3),
                  Text(
                    '${chapter.coinCost}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: cs.coin,
                    ),
                  ),
                ],
              ] else if (isRead) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: 14,
                  color: cs.textTertiary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet prompting the user to unlock one or all chapters with coins.
///
/// ```dart
/// await NovelUnlockSheet.show(context, chapter: ch, coinBalance: 120);
/// ```
class NovelUnlockSheet {
  NovelUnlockSheet._();

  static Future<bool?> show({
    required BuildContext context,
    required NovelChapter chapter,
    required int coinBalance,
    int? autoUnlockCount,
    ValueChanged<int>? onUnlock,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      builder: (sheetContext) {
        final cs = NovelTheme.of(sheetContext).colorScheme;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  NovelTheme.of(sheetContext).strings.lockedChapter,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: cs.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '“${chapter.title}”',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.5, color: cs.textSecondary),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _CoinPill(cost: chapter.coinCost),
                    const SizedBox(width: 10),
                    Text('·', style: TextStyle(color: cs.textTertiary)),
                    const SizedBox(width: 10),
                    Text(
                      '${NovelTheme.of(sheetContext).strings.balance}: ',
                      style: TextStyle(fontSize: 13.5, color: cs.textSecondary),
                    ),
                    Icon(
                      Icons.monetization_on_rounded,
                      size: 16,
                      color: cs.coin,
                    ),
                    Text(
                      '$coinBalance',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: cs.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                FilledButton(
                  onPressed: () => Navigator.of(sheetContext).pop(true),
                  child: Text(
                    '${NovelTheme.of(sheetContext).strings.unlock} · ${chapter.coinCost} ${NovelTheme.of(sheetContext).strings.coins}',
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () => Navigator.of(sheetContext).pop(false),
                  child: Text(NovelTheme.of(sheetContext).strings.maybeLater),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Small inline coin amount indicator.
class NovelCoinBadge extends StatelessWidget {
  const NovelCoinBadge({super.key, required this.amount, this.dense = false});

  final int amount;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final cs = NovelTheme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.monetization_on_rounded,
          size: dense ? 13 : 16,
          color: cs.coin,
        ),
        const SizedBox(width: 3),
        Text(
          '$amount',
          style: TextStyle(
            fontSize: dense ? 12 : 14,
            fontWeight: FontWeight.w800,
            color: cs.coin,
          ),
        ),
      ],
    );
  }
}

class _CoinPill extends StatelessWidget {
  const _CoinPill({required this.cost});

  final int cost;

  @override
  Widget build(BuildContext context) {
    final cs = NovelTheme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.monetization_on_rounded, size: 17, color: cs.coin),
          const SizedBox(width: 5),
          Text(
            '$cost coins',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: cs.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
