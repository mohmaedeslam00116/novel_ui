import 'dart:async';

import 'package:flutter/material.dart';

import '../models/novel_book.dart';
import '../tokens/novel_colors.dart';
import '../tokens/novel_dimens.dart';
import '../theme/novel_theme.dart';
import 'novel_cover_view.dart';

/// ─────────────────────────────────────────────────────────────────────────
/// Phase-1 components from the cross-platform gap matrix (ROADMAP.md):
/// podium ranking, wait-or-pay unlock countdown, latest-updates feed,
/// reading-list picker and the achievements row.
/// ─────────────────────────────────────────────────────────────────────────

/// GoodNovel-style Power Ranking podium: #1 enlarged in the middle with
/// #2 and #3 flanking, on a rounded panel.
class NovelPowerRankPodium extends StatelessWidget {
  const NovelPowerRankPodium({
    super.key,
    required this.topThree,
    this.onTap,
    this.title,
  });

  /// Books ranked 1–3 (index 0 = #1).
  final List<NovelBook> topThree;

  /// Called with the 0-based index of the tapped book.
  final ValueChanged<int>? onTap;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final cs = NovelTheme.of(context).colorScheme;
    assert(topThree.length <= 3);
    final books = topThree;
    Widget slot(int index, double coverWidth) {
      if (index >= books.length) return const Spacer();
      final book = books[index];
      return Expanded(
        child: GestureDetector(
          onTap: onTap == null ? null : () => onTap!(index),
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              NovelCoverView(
                url: book.coverUrl,
                title: book.title,
                author: book.author,
                width: coverWidth,
              ),
              const SizedBox(height: 6),
              Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: index == 0 ? 22 : 16,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  color: switch (index) {
                    0 => const Color(0xFFEB1551),
                    1 => const Color(0xFFFF8D29),
                    _ => const Color(0xFF39CCA0),
                  },
                ),
              ),
              const SizedBox(height: 2),
              Text(
                book.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: index == 0 ? 13 : 11.5,
                  fontWeight: FontWeight.w700,
                  color: cs.textPrimary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: NovelDimens.screenPadding),
      padding: const EdgeInsets.all(NovelDimens.lg),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(NovelDimens.radiusLg),
        border: Border.all(color: cs.border),
      ),
      child: Column(
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: NovelDimens.lg),
              child: Text(
                title!,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: cs.textPrimary,
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [slot(1, 64), slot(0, 96), slot(2, 64)],
          ),
        ],
      ),
    );
  }
}

/// Tapas-style "wait-or-pay" chapter tile: shows a live countdown until the
/// chapter unlocks free, or an immediate unlock action.
class NovelWaitOrPayTile extends StatefulWidget {
  const NovelWaitOrPayTile({
    super.key,
    required this.chapterTitle,
    required this.unlockAt,
    this.coinCost = 2,
    this.onUnlock,
    this.onWait,
  });

  final String chapterTitle;

  /// When the chapter becomes free.
  final DateTime unlockAt;
  final int coinCost;
  final VoidCallback? onUnlock;

  /// Fired when the user chooses to wait (dismiss the countdown).
  final VoidCallback? onWait;

  @override
  State<NovelWaitOrPayTile> createState() => _NovelWaitOrPayTileState();
}

class _NovelWaitOrPayTileState extends State<NovelWaitOrPayTile> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final remaining = widget.unlockAt.difference(DateTime.now());
    if (remaining.isNegative) {
      _timer?.cancel();
      _timer = null;
    }
    if (mounted) setState(() => _remaining = remaining);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _countdownLabel {
    final h = _remaining.inHours;
    final m = _remaining.inMinutes.remainder(60);
    final s = _remaining.inSeconds.remainder(60);
    if (h > 0) return '${h}h ${m}m';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  @override
  Widget build(BuildContext context) {
    final cs = NovelTheme.of(context).colorScheme;
    final free = _remaining.isNegative;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(bottom: BorderSide(color: cs.border)),
      ),
      child: Row(
        children: [
          Icon(
            free ? Icons.lock_open_rounded : Icons.lock_clock_rounded,
            size: 18,
            color: free ? cs.success : cs.textTertiary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.chapterTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: cs.textPrimary),
            ),
          ),
          const SizedBox(width: 10),
          free
              ? Text(
                  'Free',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: cs.success,
                  ),
                )
              : TextButton(
                  onPressed: widget.onWait,
                  child: Text('Free in $_countdownLabel'),
                ),
          const SizedBox(width: 6),
          FilledButton.tonal(
            onPressed: widget.onUnlock,
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 34),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.monetization_on_rounded, size: 14, color: cs.coin),
                const SizedBox(width: 4),
                Text('${widget.coinCost}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ScribbleHub-style latest-updates feed row: cover + title + genre chips +
/// newest chapter + author/time — the live firehose of new chapters.
class NovelLatestUpdateTile extends StatelessWidget {
  const NovelLatestUpdateTile({
    super.key,
    required this.book,
    required this.latestChapterTitle,
    this.timeLabel,
    this.onTap,
    this.maxChips = 4,
  });

  final NovelBook book;
  final String latestChapterTitle;
  final String? timeLabel;
  final VoidCallback? onTap;
  final int maxChips;

  @override
  Widget build(BuildContext context) {
    final cs = NovelTheme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: NovelDimens.screenPadding,
          vertical: NovelDimens.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NovelCoverView(
              url: book.coverUrl,
              title: book.title,
              author: book.author,
              width: 56,
            ),
            const SizedBox(width: NovelDimens.lg),
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
                      fontWeight: FontWeight.w800,
                      color: cs.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      for (final tag in book.tags.take(maxChips))
                        _TinyChip(label: tag, color: cs.primary),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_right_rounded,
                        size: 16,
                        color: cs.primary,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          latestChapterTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: cs.textSecondary,
                          ),
                        ),
                      ),
                      if (timeLabel != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '· ${timeLabel!}',
                          style: TextStyle(
                            fontSize: 11,
                            color: cs.textTertiary,
                          ),
                        ),
                      ],
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

class _TinyChip extends StatelessWidget {
  const _TinyChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

/// Wattpad's signature reading-list picker — circular "+" on the detail
/// page opens this sheet; check lists to file the book, or create one.
class NovelReadingListPicker {
  NovelReadingListPicker._();

  static Future<Set<String>?> show({
    required BuildContext context,
    required List<({String id, String name, int bookCount})> lists,
    Set<String> initialSelected = const {},
    required ValueChanged<Set<String>> onSaved,
    VoidCallback? onCreateNew,
  }) {
    return showModalBottomSheet<Set<String>>(
      context: context,
      builder: (sheetContext) => _ReadingListSheet(
        lists: lists,
        initialSelected: initialSelected,
        onSaved: onSaved,
        onCreateNew: onCreateNew,
      ),
    );
  }
}

class _ReadingListSheet extends StatefulWidget {
  const _ReadingListSheet({
    required this.lists,
    required this.initialSelected,
    required this.onSaved,
    this.onCreateNew,
  });

  final List<({String id, String name, int bookCount})> lists;
  final Set<String> initialSelected;
  final ValueChanged<Set<String>> onSaved;
  final VoidCallback? onCreateNew;

  @override
  State<_ReadingListSheet> createState() => _ReadingListSheetState();
}

class _ReadingListSheetState extends State<_ReadingListSheet> {
  late final Set<String> _selected = {...widget.initialSelected};

  @override
  Widget build(BuildContext context) {
    final cs = NovelTheme.of(context).colorScheme;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Row(
              children: [
                Text(
                  'Add to list',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: cs.textPrimary,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    widget.onSaved(_selected);
                    Navigator.of(context).pop(_selected);
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.lists.length,
              itemBuilder: (context, i) {
                final list = widget.lists[i];
                final checked = _selected.contains(list.id);
                return CheckboxListTile(
                  value: checked,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: cs.primary,
                  title: Text(
                    list.name,
                    style: TextStyle(fontSize: 14.5, color: cs.textPrimary),
                  ),
                  subtitle: Text(
                    '${list.bookCount} books',
                    style: TextStyle(fontSize: 12, color: cs.textTertiary),
                  ),
                  onChanged: (v) => setState(() {
                    v == true
                        ? _selected.add(list.id)
                        : _selected.remove(list.id);
                  }),
                );
              },
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: CircleAvatar(
              radius: 16,
              backgroundColor: cs.primary.withValues(alpha: 0.12),
              child: Icon(Icons.add_rounded, size: 18, color: cs.primary),
            ),
            title: Text(
              'Create new list',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: cs.primary,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              widget.onCreateNew?.call();
            },
          ),
        ],
      ),
    );
  }
}

/// RoyalRoad-style achievements strip: 38×38 medal icons with labels and
/// hover/tooltips.
class NovelAchievementRow extends StatelessWidget {
  const NovelAchievementRow({super.key, required this.achievements});

  final List<NovelAchievement> achievements;

  @override
  Widget build(BuildContext context) {
    final cs = NovelTheme.of(context).colorScheme;
    return SizedBox(
      height: 74,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: NovelDimens.screenPadding),
        itemCount: achievements.length,
        separatorBuilder: (_, _) => const SizedBox(width: NovelDimens.lg),
        itemBuilder: (context, i) {
          final a = achievements[i];
          return Tooltip(
            message: a.label,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: a.locked
                        ? null
                        : const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: NovelColors.goldenTicketGradient,
                          ),
                    color: a.locked ? cs.surfaceLow : null,
                    border: Border.all(
                      color: a.locked ? cs.border : NovelColors.primary,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    a.icon,
                    size: 19,
                    color: a.locked ? cs.textTertiary : Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 72),
                  child: Text(
                    a.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: a.locked ? cs.textTertiary : cs.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// One achievement medal.
class NovelAchievement {
  const NovelAchievement({
    required this.label,
    required this.icon,
    this.locked = false,
  });

  final String label;
  final IconData icon;

  /// Locked medals render grayed out.
  final bool locked;
}
