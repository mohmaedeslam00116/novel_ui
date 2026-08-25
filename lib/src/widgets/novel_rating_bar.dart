import 'package:flutter/material.dart';

import '../theme/novel_theme.dart';

/// Star rating display and input.
///
/// ```dart
/// NovelRatingBar(value: 4.2, size: 14)               // read-only
/// NovelRatingBar(value: score, onChanged: setScore)   // interactive
/// ```
class NovelRatingBar extends StatelessWidget {
  const NovelRatingBar({
    super.key,
    required this.value,
    this.maxValue = 5,
    this.size = 14,
    this.spacing = 2,
    this.onChanged,
    this.showValueLabel = false,
    this.activeColor,
    this.inactiveColor,
  });

  final double value;
  final int maxValue;
  final double size;
  final double spacing;

  /// When non-null the bar is interactive.
  final ValueChanged<double>? onChanged;
  final bool showValueLabel;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final cs = NovelTheme.of(context).colorScheme;
    final active = activeColor ?? const Color(0xFFFFB100);
    final inactive =
        inactiveColor ??
        (cs.isDark ? const Color(0xFF3A3A40) : const Color(0xFFE4E4E8));

    final stars = List.generate(maxValue, (i) {
      final fill = (value - i).clamp(0.0, 1.0);
      return _Star(fill: fill, size: size, color: active, emptyColor: inactive);
    });

    return Semantics(
      container: true,
      label: 'Rating: ${value.toStringAsFixed(1)} of $maxValue stars',
      value: value.toStringAsFixed(1),
      increasedValue: onChanged == null
          ? null
          : (value + 1).clamp(0, maxValue).toStringAsFixed(1),
      decreasedValue: onChanged == null
          ? null
          : (value - 1).clamp(0, maxValue).toStringAsFixed(1),
      onIncrease: onChanged == null
          ? null
          : () => onChanged!((value + 1).clamp(0, maxValue).toDouble()),
      onDecrease: onChanged == null
          ? null
          : () => onChanged!((value - 1).clamp(0, maxValue).toDouble()),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < stars.length; i++) ...[
            if (i > 0) SizedBox(width: spacing),
            if (onChanged == null)
              stars[i]
            else
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged!(i + 1.0),
                child: Semantics(
                  button: true,
                  label: 'Rate ${i + 1} stars',
                  excludeSemantics: true,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: spacing / 2),
                    child: stars[i],
                  ),
                ),
              ),
          ],
          if (showValueLabel) ...[
            SizedBox(width: spacing + 4),
            Text(
              value.toStringAsFixed(1),
              style: TextStyle(
                fontSize: size * 0.85,
                fontWeight: FontWeight.w700,
                color: active,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Star extends StatelessWidget {
  const _Star({
    required this.fill,
    required this.size,
    required this.color,
    required this.emptyColor,
  });

  /// 0..1 partial fill.
  final double fill;
  final double size;
  final Color color;
  final Color emptyColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Icon(Icons.star_rounded, size: size, color: emptyColor),
          ClipRect(
            clipper: _HalfClipper(widthFactor: fill),
            child: Icon(Icons.star_rounded, size: size, color: color),
          ),
        ],
      ),
    );
  }
}

class _HalfClipper extends CustomClipper<Rect> {
  _HalfClipper({required this.widthFactor});

  final double widthFactor;

  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, 0, size.width * widthFactor, size.height);

  @override
  bool shouldReclip(_HalfClipper oldClipper) =>
      oldClipper.widthFactor != widthFactor;
}
