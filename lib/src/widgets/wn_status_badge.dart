import 'package:flutter/material.dart';

import '../models/wn_book.dart';
import '../tokens/wn_colors.dart';
import '../theme/wn_theme.dart';

/// Small pill badge showing publication status, overlaid on covers.
class WnStatusBadge extends StatelessWidget {
  const WnStatusBadge(this.status, {super.key, this.compact = true});

  /// Full-size badge with the complete status label.
  const WnStatusBadge.full(this.status, {super.key}) : compact = false;

  final WnBookStatus status;

  /// When true renders a dot + short label; otherwise the full label.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final strings = WnTheme.of(context).strings;
    final (label, color) = switch (status) {
      WnBookStatus.ongoing => (strings.ongoing, WnColors.primary),
      WnBookStatus.completed => (strings.completed, WnColors.success),
      WnBookStatus.hiatus => (strings.hiatus, const Color(0xFF8E8E93)),
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 10,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.95),
              fontSize: compact ? 9.5 : 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Genre / category tag chip with optional accent tint.
class WnTagChip extends StatelessWidget {
  const WnTagChip(
    this.label, {
    super.key,
    this.onTap,
    this.selected = false,
    this.accentColor,
    this.dense = false,
  });

  /// Dense chip for tight rows (book tiles, meta lines).
  const WnTagChip.dense(
    this.label, {
    super.key,
    this.onTap,
    this.selected = false,
    this.accentColor,
  }) : dense = true;

  final String label;
  final VoidCallback? onTap;
  final bool selected;
  final Color? accentColor;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final cs = WnTheme.of(context).colorScheme;
    final accent = accentColor ?? cs.primary;
    return Material(
      color: selected ? accent.withValues(alpha: 0.12) : cs.surfaceLow,
      borderRadius: BorderRadius.circular(dense ? 6 : 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(dense ? 6 : 14),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: dense ? 8 : 12,
            vertical: dense ? 3 : 6,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: dense ? 11 : 12.5,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? accent : cs.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
