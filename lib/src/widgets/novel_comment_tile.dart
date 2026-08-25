import 'package:flutter/material.dart';

import '../tokens/novel_dimens.dart';
import '../theme/novel_theme.dart';
import 'novel_badges.dart';

/// A fan-leaderboard rank medal — mirrors the app's `fans_rank_i_0..2`
/// icons (gold / silver / bronze).
class NovelFansRankBadge extends StatelessWidget {
  const NovelFansRankBadge({super.key, required this.rank});

  /// 1-based rank; ranks 1–3 get medal colors, others render plain.
  final int rank;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (rank) {
      1 => (const Color(0xFFFFC152), '1'),
      2 => (const Color(0xFFB8C0CC), '2'),
      3 => (const Color(0xFFCE8A5B), '3'),
      _ => (null, '$rank'),
    };
    if (color == null) {
      return Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.italic,
          color: NovelTheme.of(context).colorScheme.textTertiary,
        ),
      );
    }
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color, Color.lerp(color, Colors.black, 0.18)!],
        ),
        shape: BoxShape.circle,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

/// A single comment row — book / chapter / paragraph comment, built to the
/// recovered specs of the official comment UI: 40dp avatar, 4/8/16dp
/// rhythm, level badge, like & reply actions.
///
/// ```dart
/// NovelCommentTile(
///   comment: NovelComment(
///     userName: 'Jerome Bell',
///     content: 'Your time is limited…',
///     likes: 324,
///     replyCount: 12,
///     level: 15,
///   ),
/// )
/// ```
class NovelComment {
  /// Paragraph-comment constructor — quotes the chapter it belongs to
  /// (the official app's paragraph-level interaction).
  const NovelComment.paragraph({
    required this.userName,
    required this.content,
    required this.chapterLabel,
    this.avatarUrl,
    this.level,
    this.likes = 0,
    this.replyCount = 0,
    this.timeLabel,
    this.onLike,
    this.onReply,
    this.onTap,
  }) : isParagraphComment = true;

  const NovelComment({
    required this.userName,
    required this.content,
    this.avatarUrl,
    this.level,
    this.likes = 0,
    this.replyCount = 0,
    this.timeLabel,
    this.isParagraphComment = false,
    this.chapterLabel,
    this.onLike,
    this.onReply,
    this.onTap,
  });

  final String userName;
  final String content;
  final String? avatarUrl;

  /// Reader level shown as the LV badge next to the name.
  final int? level;
  final int likes;
  final int replyCount;
  final String? timeLabel;

  /// Paragraph comments quote the chapter they belong to.
  final bool isParagraphComment;
  final String? chapterLabel;
  final VoidCallback? onLike;
  final VoidCallback? onReply;
  final VoidCallback? onTap;
}

class NovelCommentTile extends StatelessWidget {
  const NovelCommentTile({super.key, required NovelComment comment})
    : _comment = comment;

  final NovelComment _comment;

  @override
  Widget build(BuildContext context) {
    final cs = NovelTheme.of(context).colorScheme;
    final t = NovelTheme.of(context).components.commentTile;
    return InkWell(
      onTap: _comment.onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: t.horizontalPadding ?? NovelDimens.screenPadding,
          vertical: NovelDimens.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Avatar(
              url: _comment.avatarUrl,
              name: _comment.userName,
              size: t.avatarSize ?? 40,
            ),
            const SizedBox(width: NovelDimens.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          _comment.userName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              t.nameStyle ??
                              TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: cs.textPrimary,
                              ),
                        ),
                      ),
                      if (_comment.level != null) ...[
                        const SizedBox(width: 6),
                        NovelLevelBadge(level: _comment.level!),
                      ],
                      if (_comment.timeLabel != null) ...[
                        const Spacer(),
                        Text(
                          _comment.timeLabel!,
                          style: TextStyle(
                            fontSize: 11,
                            color: cs.textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (_comment.isParagraphComment &&
                      _comment.chapterLabel != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: cs.surfaceLow,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Ch. ${_comment.chapterLabel}',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: cs.textTertiary,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    _comment.content,
                    style:
                        t.contentStyle ??
                        TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: cs.textPrimary.withValues(alpha: 0.88),
                        ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _Action(
                        icon: Icons.thumb_up_alt_rounded,
                        label: '${_comment.likes}',
                        onTap: _comment.onLike,
                      ),
                      const SizedBox(width: NovelDimens.xl),
                      _Action(
                        icon: Icons.chat_bubble_outline_rounded,
                        label: '${_comment.replyCount}',
                        onTap: _comment.onReply,
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

class _Avatar extends StatelessWidget {
  const _Avatar({this.url, required this.name, this.size = 40});

  final String? url;
  final String name;
  final double size; // 48dp incl. padding ring, per recovered spec

  @override
  Widget build(BuildContext context) {
    final cs = NovelTheme.of(context).colorScheme;
    if (url != null && url!.isNotEmpty) {
      return ClipOval(
        child: SizedBox(
          width: size,
          height: size,
          child: Image.network(url!, fit: BoxFit.cover),
        ),
      );
    }
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary.withValues(alpha: 0.75), cs.vip],
        ),
        shape: BoxShape.circle,
      ),
      child: Text(
        name.isEmpty ? '?' : name.characters.first.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = NovelTheme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: cs.textTertiary),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 12, color: cs.textTertiary)),
          ],
        ),
      ),
    );
  }
}
