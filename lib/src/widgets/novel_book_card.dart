import 'package:flutter/material.dart';

import '../models/novel_book.dart';
import '../tokens/novel_dimens.dart';
import '../theme/novel_theme.dart';
import 'novel_badges.dart';
import 'novel_cover_view.dart';
import 'novel_status_badge.dart';

/// Compact vertical card used in library grids: cover, title, status badge.
///
/// ```dart
/// NovelBookCard(book: book, onTap: () => openDetail(book))
/// ```
class NovelBookCard extends StatelessWidget {
  /// Grid card — the library-shelf default (3:4 cover over title).
  const NovelBookCard({
    super.key,
    required this.book,
    this.onTap,
    this.onLongPress,
    this.width,
    this.showStatusBadge,
    this.subtitle,
    this.updateCount,
  });

  /// Rail card for horizontal discovery strips — slightly narrower cover.
  const NovelBookCard.rail({
    super.key,
    required this.book,
    this.onTap,
    this.onLongPress,
    this.subtitle,
    this.updateCount,
  }) : width = 88,
       showStatusBadge = true;

  /// Row card for dense vertical lists (cover left, text right).
  ///
  /// Shorthand that returns a [NovelBookListTile] so call sites stay uniform:
  /// ```dart
  /// NovelBookCard.row(book: b, onTap: open)
  /// ```
  static Widget row({
    Key? key,
    required NovelBook book,
    VoidCallback? onTap,
    Widget? trailing,
    double coverWidth = NovelDimens.listCoverWidth,
  }) {
    return NovelBookListTile(
      key: key,
      book: book,
      onTap: onTap,
      trailing: trailing,
      coverWidth: coverWidth,
    );
  }

  final NovelBook book;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double? width;
  final bool? showStatusBadge;

  /// Optional line under the title (e.g. latest chapter name).
  final String? subtitle;

  /// Unread chapter count — renders the red update dot on the cover
  /// (library/shelf pattern from the official app).
  final int? updateCount;

  @override
  Widget build(BuildContext context) {
    final cs = NovelTheme.of(context).colorScheme;
    final t = NovelTheme.of(context).components.bookCard;
    final effectiveWidth = width ?? t.coverWidth ?? NovelDimens.gridCoverWidth;
    final effectiveRadius = t.coverRadius ?? NovelDimens.coverRadius;
    return Semantics(
      button: onTap != null,
      container: true,
      label: '${book.title} by ${book.author}',
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(NovelDimens.radiusMd),
        child: SizedBox(
          width: effectiveWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  NovelCoverView(
                    url: book.coverUrl,
                    title: book.title,
                    author: book.author,
                    width: effectiveWidth,
                    borderRadius: effectiveRadius,
                  ),
                  if ((showStatusBadge ?? t.showStatusBadge) ?? true)
                    Positioned(
                      top: 6,
                      left: 0,
                      child: NovelStatusBadge(book.status),
                    ),
                  if ((updateCount ?? 0) > 0)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: NovelUpdateBadge(count: updateCount),
                    ),
                ],
              ),
              SizedBox(height: t.spacing ?? NovelDimens.sm),
              Text(
                book.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    t.titleStyle ??
                    TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: cs.textPrimary,
                      height: 1.2,
                    ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.5, color: cs.textSecondary),
                ),
              ] else ...[
                const SizedBox(height: 3),
                Text(
                  book.author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.5, color: cs.textTertiary),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Horizontal row used in lists: cover, title + author + tags + stats.
class NovelBookListTile extends StatelessWidget {
  const NovelBookListTile({
    super.key,
    required this.book,
    this.onTap,
    this.trailing,
    this.coverWidth = NovelDimens.listCoverWidth,
    this.maxTagLines = 1,
  });

  final NovelBook book;
  final VoidCallback? onTap;

  /// Right-side widget (e.g. rank number or "Collect" button).
  final Widget? trailing;
  final double coverWidth;

  /// How many tag rows to show before truncation.
  final int maxTagLines;

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
              width: coverWidth,
            ),
            const SizedBox(width: NovelDimens.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          book.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: cs.textPrimary,
                          ),
                        ),
                      ),
                      ?trailing,
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 14,
                        color: cs.textTertiary,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          '${book.author} · ${_statusLabel(context, book.status)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: cs.textTertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.summary.isEmpty ? '—' : book.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.35,
                      color: cs.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: NovelDimens.sm,
                    runSpacing: NovelDimens.xs,
                    children: book.tags
                        .take(maxTagLines == 1 ? 3 : 6)
                        .map((t) => _MiniTag(label: t))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(BuildContext context, NovelBookStatus status) {
    final strings = NovelTheme.of(context).strings;
    return switch (status) {
      NovelBookStatus.ongoing => strings.ongoing,
      NovelBookStatus.completed => strings.completed,
      NovelBookStatus.hiatus => strings.hiatus,
    };
  }
}

class _MiniTag extends StatelessWidget {
  const _MiniTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = NovelTheme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: BoxDecoration(
        color: cs.surfaceLow,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          color: cs.textTertiary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
