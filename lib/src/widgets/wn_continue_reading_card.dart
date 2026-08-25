import 'package:flutter/material.dart';

import '../models/wn_book.dart';
import '../tokens/wn_dimens.dart';
import '../theme/wn_theme.dart';
import 'wn_cover_view.dart';

/// "Continue reading" banner for the library screen: cover, progress bar,
/// last-read chapter and a resume button.
class WnContinueReadingCard extends StatelessWidget {
  const WnContinueReadingCard({
    super.key,
    required this.book,
    required this.lastChapterTitle,
    required this.progress,
    this.chapterIndex,
    this.coverUrl,
    this.onTap,
    this.onRemove,
  });

  final WnBook book;
  final String lastChapterTitle;

  /// 0..1 reading progress through the book.
  final double progress;
  final int? chapterIndex;
  final String? coverUrl;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final cs = WnTheme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: WnDimens.screenPadding),
      child: Material(
        color: cs.surface,
        borderRadius: BorderRadius.circular(WnDimens.radiusLg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(WnDimens.radiusLg),
          child: Container(
            padding: const EdgeInsets.all(WnDimens.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(WnDimens.radiusLg),
              border: Border.all(color: cs.border),
            ),
            child: Row(
              children: [
                WnCoverView(
                  url: coverUrl ?? book.coverUrl,
                  title: book.title,
                  author: book.author,
                  width: 56,
                ),
                const SizedBox(width: WnDimens.lg),
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
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                color: cs.textPrimary,
                              ),
                            ),
                          ),
                          if (onRemove != null)
                            GestureDetector(
                              onTap: onRemove,
                              child: Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: cs.textTertiary,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Ch.${chapterIndex ?? '?'} · $lastChapterTitle',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: cs.textSecondary),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: progress.clamp(0.0, 1.0),
                                minHeight: 5,
                                backgroundColor: cs.surfaceLow,
                                valueColor: AlwaysStoppedAnimation(cs.primary),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${(progress * 100).clamp(0, 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: cs.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: WnDimens.sm),
                FilledButton(
                  onPressed: onTap,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(72, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    textStyle: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  child: Text(WnTheme.of(context).strings.resume),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Search field styled like novel apps' home search bar with an optional
/// hint text and voice/camera trailing icons.
class WnSearchField extends StatelessWidget {
  const WnSearchField({
    super.key,
    this.hintText,
    this.controller,
    this.focusNode,
    this.onSubmit,
    this.onTap,
    this.readOnly = false,
    this.suffixIcons = const [],
    this.leading,
  });

  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmit;
  final VoidCallback? onTap;

  /// Typically set when the field opens the real search page on tap.
  final bool readOnly;
  final List<IconData> suffixIcons;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final cs = WnTheme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: cs.surfaceLow,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: cs.border.withValues(alpha: 0.6)),
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 8),
            ] else ...[
              Icon(Icons.search_rounded, size: 20, color: cs.textTertiary),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                readOnly: readOnly,
                onSubmitted: onSubmit,
                style: TextStyle(fontSize: 14, color: cs.textPrimary),
                decoration: InputDecoration(
                  hintText: hintText ?? WnTheme.of(context).strings.searchHint,
                  hintStyle: TextStyle(fontSize: 13.5, color: cs.textTertiary),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            ...suffixIcons.map(
              (i) => Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(i, size: 19, color: cs.textTertiary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Power-stone / vote button used on book detail pages.
class WnPowerStoneButton extends StatefulWidget {
  const WnPowerStoneButton({
    super.key,
    required this.count,
    this.voted = false,
    this.onVoted,
  });

  final int count;
  final bool voted;

  /// Called after the short animation completes with the new state.
  final ValueChanged<bool>? onVoted;

  @override
  State<WnPowerStoneButton> createState() => _WnPowerStoneButtonState();
}

class _WnPowerStoneButtonState extends State<WnPowerStoneButton>
    with SingleTickerProviderStateMixin {
  late bool _voted = widget.voted;
  late int _count = widget.count;
  late final AnimationController _pop = AnimationController(
    vsync: this,
    duration: WnDimens.normal,
    value: 1,
  );

  @override
  void dispose() {
    _pop.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _voted = !_voted;
      _count += _voted ? 1 : -1;
      _pop.forward(from: 0);
    });
    widget.onVoted?.call(_voted);
  }

  @override
  Widget build(BuildContext context) {
    final cs = WnTheme.of(context).colorScheme;
    final accent = _voted ? const Color(0xFF8B7CF6) : cs.textSecondary;
    return Semantics(
      button: true,
      toggled: _voted,
      label: 'Power stone vote, $_count',
      child: InkWell(
        onTap: _toggle,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _voted ? const Color(0xFF8B7CF6) : cs.border,
            ),
            color: _voted
                ? const Color(0xFF8B7CF6).withValues(alpha: 0.08)
                : null,
          ),
          child: ScaleTransition(
            scale: Tween(
              begin: 0.85,
              end: 1.0,
            ).animate(CurvedAnimation(parent: _pop, curve: Curves.easeOutBack)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.rocket_launch_rounded, size: 17, color: accent),
                const SizedBox(width: 6),
                Text(
                  '$_count',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: accent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
