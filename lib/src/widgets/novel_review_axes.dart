import 'package:flutter/material.dart';

import 'novel_rating_bar.dart';
import '../theme/novel_theme.dart';

/// The five fixed review axes Webnovel shows above reviews.
enum NovelReviewAxis {
  writingQuality('Writing Quality'),
  stabilityOfUpdates('Stability of Updates'),
  storyDevelopment('Story Development'),
  characterDesign('Character Design'),
  worldBackground('World Background');

  const NovelReviewAxis(this.label);
  final String label;
}

/// Aggregate review block: overall score plus one star row per axis.
class NovelReviewAxes extends StatelessWidget {
  const NovelReviewAxes({
    super.key,
    required this.scores,
    this.overall,
    this.onAxisTap,
  });

  /// A score (0..5) for each axis; missing axes are skipped.
  final Map<NovelReviewAxis, double> scores;

  /// Overall aggregate shown on the left column.
  final double? overall;

  /// Optional per-axis tap (e.g. jump to filtered reviews).
  final ValueChanged<NovelReviewAxis>? onAxisTap;

  @override
  Widget build(BuildContext context) {
    final cs = NovelTheme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (overall != null) ...[
          SizedBox(
            width: 86,
            child: Column(
              children: [
                Text(
                  overall!.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: cs.textPrimary,
                    height: 1.1,
                  ),
                ),
                Text(
                  'out of 5',
                  style: TextStyle(fontSize: 11, color: cs.textTertiary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
        ],
        Expanded(
          child: Column(
            children: [
              for (final axis in NovelReviewAxis.values)
                if (scores.containsKey(axis))
                  GestureDetector(
                    onTap: onAxisTap == null ? null : () => onAxisTap!(axis),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 128,
                            child: Text(
                              axis.label,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: cs.textSecondary,
                              ),
                            ),
                          ),
                          const Spacer(),
                          NovelRatingBar(value: scores[axis]!, size: 12),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
