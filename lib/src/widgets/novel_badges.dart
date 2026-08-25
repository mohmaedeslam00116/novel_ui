import 'package:flutter/material.dart';

import '../tokens/novel_colors.dart';

/// Red update dot with an optional count — the "new chapters available"
/// badge on library covers.
class NovelUpdateBadge extends StatelessWidget {
  const NovelUpdateBadge({super.key, this.count, this.size = 16});

  /// Chapter count; when null renders a plain dot.
  final int? count;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: size),
      height: size,
      padding: EdgeInsets.symmetric(horizontal: count == null ? 0 : 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: NovelColors.updateDot,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: count == null
          ? null
          : Text(
              '$count',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.56,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
    );
  }
}

enum NovelRibbonStyle { original, hot, fresh }

/// Corner flag for covers — "ORIGINAL", "HOT", "NEW".
class NovelCornerRibbon extends StatelessWidget {
  const NovelCornerRibbon(
    this.label, {
    super.key,
    this.style = NovelRibbonStyle.original,
  });

  final String label;
  final NovelRibbonStyle style;

  @override
  Widget build(BuildContext context) {
    final color = switch (style) {
      NovelRibbonStyle.original => const Color(0xFFD4A24C),
      NovelRibbonStyle.hot => NovelColors.updateDot,
      NovelRibbonStyle.fresh => NovelColors.success,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, Color.lerp(color, Colors.black, 0.15)!],
        ),
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 8.5,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.6,
          height: 1,
        ),
      ),
    );
  }
}

/// Reader level badge ("LV 12") with the blue→purple gradient users earn
/// by reviewing and commenting.
class NovelLevelBadge extends StatelessWidget {
  const NovelLevelBadge({super.key, required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4D9EF8), Color(0xFF8B7CF6)],
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'LV $level',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          height: 1.2,
        ),
      ),
    );
  }
}
