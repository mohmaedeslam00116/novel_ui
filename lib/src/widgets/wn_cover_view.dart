import 'package:flutter/material.dart';

import '../tokens/wn_colors.dart';
import '../tokens/wn_dimens.dart';

/// Displays a book cover.
///
/// When [url] is null or fails to load, a deterministic gradient cover is
/// generated from [title] so grids always look intentional — useful for
/// demos, tests and offline states.
class WnCoverView extends StatelessWidget {
  const WnCoverView({
    super.key,
    this.url,
    required this.title,
    this.author,
    this.width = WnDimens.gridCoverWidth,
    this.aspectRatio = WnDimens.coverAspectRatio,
    this.borderRadius = WnDimens.coverRadius,
    this.fit = BoxFit.cover,
  });

  final String? url;
  final String title;
  final String? author;
  final double? width;
  final double aspectRatio;
  final double borderRadius;
  final BoxFit fit;

  static (Color, Color) _gradientFor(String seedText) {
    final pool = WnColors.coverGradientPool;
    var hash = 0;
    for (final code in seedText.codeUnits) {
      hash = (hash * 31 + code) & 0x7FFFFFFF;
    }
    return (pool[hash % pool.length], pool[(hash ~/ 7 + 3) % pool.length]);
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    final colors = _gradientFor(title);

    Widget child;
    if (url != null && url!.isNotEmpty) {
      child = Image.network(
        url!,
        fit: fit,
        frameBuilder: (context, image, frame, wasSync) => frame == null
            ? ColoredBox(color: colors.$1.withValues(alpha: 0.25), child: image)
            : image,
        errorBuilder: (_, _, _) =>
            _GeneratedCover(title: title, author: author, colors: colors),
      );
    } else {
      child = _GeneratedCover(title: title, author: author, colors: colors);
    }

    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: AspectRatio(aspectRatio: aspectRatio, child: child),
      ),
    );
  }
}

class _GeneratedCover extends StatelessWidget {
  const _GeneratedCover({
    required this.title,
    this.author,
    required this.colors,
  });

  final String title;
  final String? author;
  final (Color, Color) colors;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.$1, colors.$2],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.25,
                fontWeight: FontWeight.w800,
                shadows: [Shadow(blurRadius: 6, color: Colors.black38)],
              ),
            ),
            if (author != null) ...[
              const SizedBox(height: 6),
              Text(
                author!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
