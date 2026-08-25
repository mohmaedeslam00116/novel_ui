import 'dart:async';

import 'package:flutter/material.dart';

import '../tokens/wn_dimens.dart';
import '../theme/wn_theme.dart';

/// Auto-advancing home banner carousel — the 16:9 promo strip every novel
/// platform leads its discover page with.
///
/// ```dart
/// WnBannerCarousel(
///   banners: [
///     WnBanner(title: 'New Season!', imageUrl: url, onTap: ...),
///   ],
/// )
/// ```
class WnBannerCarousel extends StatefulWidget {
  const WnBannerCarousel({
    super.key,
    required this.banners,
    this.height = 150,
    this.autoAdvance = true,
    this.autoAdvanceInterval = const Duration(seconds: 4),
    this.borderRadius = WnDimens.radiusLg,
    this.aspectRatio = 16 / 9,
  });

  final List<WnBanner> banners;
  final double height;
  final bool autoAdvance;
  final Duration autoAdvanceInterval;
  final double borderRadius;

  /// Used when [height] is null; defaults to the standard 16:9 promo ratio.
  final double aspectRatio;

  @override
  State<WnBannerCarousel> createState() => _WnBannerCarouselState();
}

class _WnBannerCarouselState extends State<WnBannerCarousel> {
  late final PageController _controller = PageController();
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _scheduleAutoAdvance();
  }

  void _scheduleAutoAdvance() {
    if (!widget.autoAdvance || widget.banners.length < 2) return;
    _timer?.cancel();
    _timer = Timer.periodic(widget.autoAdvanceInterval, (_) {
      if (!_controller.hasClients) return;
      final next = (_index + 1) % widget.banners.length;
      _controller.animateToPage(
        next,
        duration: WnDimens.slow,
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void didUpdateWidget(covariant WnBannerCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scheduleAutoAdvance();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = WnTheme.of(context).colorScheme;
    if (widget.banners.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: SizedBox(
            height: widget.height,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.banners.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) {
                final banner = widget.banners[i];
                return GestureDetector(
                  onTap: banner.onTap,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (banner.imageUrl != null)
                        Image.network(
                          banner.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              _Fallback(colors: [cs.primary, cs.secondary]),
                        )
                      else
                        _Fallback(colors: [cs.primary, cs.secondary]),
                      // Bottom scrim for text legibility.
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.45, 1],
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.55),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 14,
                        right: 14,
                        bottom: 12,
                        child: Text(
                          banner.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                          ),
                        ),
                      ),
                      if (banner.tag != null)
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primary,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              banner.tag!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        if (widget.banners.length > 1) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.banners.length, (i) {
              final active = i == _index;
              return AnimatedContainer(
                duration: WnDimens.fast,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active ? cs.primary : cs.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
    );
  }
}

/// One carousel slide.
class WnBanner {
  const WnBanner({required this.title, this.imageUrl, this.tag, this.onTap});

  final String title;
  final String? imageUrl;

  /// Small pill label (e.g. "NEW", "EVENT").
  final String? tag;
  final VoidCallback? onTap;
}
