import 'package:flutter/material.dart';

import '../tokens/wn_dimens.dart';
import '../theme/wn_theme.dart';

/// The standard search-landing screen body used by every novel platform:
/// ranked **Hot Searches** (top 3 accented) and removable **History** chips.
///
/// ```dart
/// WnSearchSuggestions(
///   hotSearches: ['Solo Leveling', 'Rebirth', ...],
///   history: ['cultivation', 'system'],
///   onQueryTap: (q) => openResults(q),
///   onHistoryClear: () => clearHistory(),
/// )
/// ```
class WnSearchSuggestions extends StatelessWidget {
  const WnSearchSuggestions({
    super.key,
    this.hotSearches = const [],
    this.history = const [],
    this.onQueryTap,
    this.onHistoryClear,
    this.hotTitle,
    this.historyTitle,
  });

  final List<String> hotSearches;

  /// Most recent first; rendered as removable chips.
  final List<String> history;
  final ValueChanged<String>? onQueryTap;
  final VoidCallback? onHistoryClear;
  final String? hotTitle;
  final String? historyTitle;

  @override
  Widget build(BuildContext context) {
    final cs = WnTheme.of(context).colorScheme;
    final strings = WnTheme.of(context).strings;
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: WnDimens.screenPadding,
        vertical: WnDimens.lg,
      ),
      children: [
        if (hotSearches.isNotEmpty) ...[
          _RowTitle(
            icon: Icons.local_fire_department_rounded,
            label: hotTitle ?? strings.searchHint,
          ),
          const SizedBox(height: WnDimens.md),
          Wrap(
            spacing: WnDimens.sm,
            runSpacing: WnDimens.sm,
            children: [
              for (var i = 0; i < hotSearches.length; i++)
                _HotChip(
                  rank: i + 1,
                  label: hotSearches[i],
                  onTap: onQueryTap == null
                      ? null
                      : () => onQueryTap!(hotSearches[i]),
                ),
            ],
          ),
          const SizedBox(height: WnDimens.xxl),
        ],
        if (history.isNotEmpty) ...[
          Row(
            children: [
              Icon(Icons.history_rounded, size: 17, color: cs.textTertiary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  historyTitle ?? 'History',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: cs.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onHistoryClear,
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: cs.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: WnDimens.md),
          Wrap(
            spacing: WnDimens.sm,
            runSpacing: WnDimens.sm,
            children: [
              for (final q in history)
                GestureDetector(
                  onTap: onQueryTap == null ? null : () => onQueryTap!(q),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: cs.surfaceLow,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      q,
                      style: TextStyle(fontSize: 12.5, color: cs.textSecondary),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _RowTitle extends StatelessWidget {
  const _RowTitle({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = WnTheme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 17, color: cs.primary),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
            color: cs.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _HotChip extends StatelessWidget {
  const _HotChip({required this.rank, required this.label, this.onTap});

  final int rank;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = WnTheme.of(context).colorScheme;
    final hot = rank <= 3;
    final rankColor = switch (rank) {
      1 => const Color(0xFFEB1551),
      2 => const Color(0xFFFF8D29),
      3 => const Color(0xFFFFC152),
      _ => cs.textTertiary,
    };
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: hot ? cs.primary.withValues(alpha: 0.06) : cs.surfaceLow,
          borderRadius: BorderRadius.circular(999),
          border: hot
              ? Border.all(color: cs.primary.withValues(alpha: 0.25))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$rank',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                color: rankColor,
              ),
            ),
            const SizedBox(width: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 180),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: hot ? FontWeight.w700 : FontWeight.w500,
                  color: cs.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
