import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show Ticker;

/// Controller for feeding comments into a [WnDanmakuOverlay].
///
/// ```dart
/// final danmaku = WnDanmakuController();
/// ...
/// WnDanmakuOverlay(controller: danmaku)
/// ...
/// danmaku.add('This panel!');
/// ```
class WnDanmakuController {
  final _requests = StreamController<String>.broadcast();

  /// Emits every comment added via [add].
  Stream<String> get stream => _requests.stream;

  /// Spawns one flying comment.
  void add(String text) {
    if (text.trim().isEmpty) return;
    if (_requests.isClosed) return;
    _requests.add(text.trim());
  }

  /// Stops listening; the overlay detaches automatically.
  Future<void> close() => _requests.close();
}

/// Comic-style flying-comment overlay (bullet chat) — recovered from the
/// official app's comic reader settings (`SettingComicDanmuGuideView`).
///
/// Layer it above page content with an [IgnorePointer] wrapper (the
/// widget itself never consumes input):
///
/// ```dart
/// Stack(children: [
///   pageContent,
///   Positioned.fill(child: IgnorePointer(child: WnDanmakuOverlay(controller))),
/// ])
/// ```
class WnDanmakuOverlay extends StatefulWidget {
  const WnDanmakuOverlay({
    super.key,
    required this.controller,
    this.laneCount = 5,
    this.laneHeight = 28,
    this.duration = const Duration(seconds: 7),
    this.textStyle,
    this.opacity = 0.9,
  });

  final WnDanmakuController controller;

  /// Horizontal lanes comments travel in; a comment picks the least
  /// recently used free lane.
  final int laneCount;
  final double laneHeight;
  final Duration duration;
  final TextStyle? textStyle;
  final double opacity;

  @override
  State<WnDanmakuOverlay> createState() => _WnDanmakuOverlayState();
}

class _WnDanmakuOverlayState extends State<WnDanmakuOverlay>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final List<_DanmakuItem> _items = [];
  final List<int> _laneLastUsed = [];
  int _spawnCounter = 0;
  Size? _lastSize;
  StreamSubscription<String>? _sub;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _ticker.start();
    _sub = widget.controller.stream.listen(_spawn);
  }

  @override
  void didUpdateWidget(covariant WnDanmakuOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _sub?.cancel();
      _sub = widget.controller.stream.listen(_spawn);
    }
  }

  void _spawn(String text) {
    setState(() {
      while (_laneLastUsed.length < widget.laneCount) {
        _laneLastUsed.add(-1);
      }
      // Least-recently-used lane keeps spacing even without collisions.
      var lane = 0;
      var oldest = _laneLastUsed[0];
      for (var i = 0; i < widget.laneCount; i++) {
        if (_laneLastUsed[i] < oldest) {
          oldest = _laneLastUsed[i];
          lane = i;
        }
      }
      _spawnCounter++;
      _items.add(
        _DanmakuItem(
          id: _spawnCounter,
          text: text,
          lane: lane,
          startedAt: DateTime.now(),
        ),
      );
    });
  }

  void _onTick(Duration elapsed) {
    final cutoff = DateTime.now().subtract(
      widget.duration - const Duration(milliseconds: 1),
    );
    final finished = _items.where((i) => i.startedAt.isBefore(cutoff)).toList();
    if (finished.isEmpty && _lastSize == MediaQuery.sizeOf(context)) return;
    if (mounted) {
      setState(() {
        _items.removeWhere((i) => i.startedAt.isBefore(cutoff));
        _lastSize = MediaQuery.sizeOf(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final style =
        (widget.textStyle ?? TextStyle(fontSize: 13, color: Colors.white))
            .merge(
              const TextStyle(
                shadows: [Shadow(blurRadius: 3, color: Colors.black54)],
              ),
            );

    return ClipRect(
      child: SizedBox.expand(
        child: Stack(
          children: [
            for (final item in _items)
              Positioned(
                top: item.lane * widget.laneHeight + 4,
                left: 0,
                child: Transform.translate(
                  offset: Offset(_xOffset(item, width), 0),
                  child: Opacity(
                    opacity: widget.opacity,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(item.text, style: style),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  double _xOffset(_DanmakuItem item, double screenWidth) {
    final elapsed = DateTime.now().difference(item.startedAt).inMilliseconds;
    final total = widget.duration.inMilliseconds;
    final progress = (elapsed / total).clamp(0.0, 1.0);
    // Start just off the right edge, exit past the left edge. The chip is
    // roughly 120–200px wide; exiting fully at -260 covers the worst case.
    return screenWidth - progress * (screenWidth + 260);
  }

  @override
  void dispose() {
    _sub?.cancel();
    _ticker.dispose();
    super.dispose();
  }
}

class _DanmakuItem {
  const _DanmakuItem({
    required this.id,
    required this.text,
    required this.lane,
    required this.startedAt,
  });

  final int id;
  final String text;
  final int lane;
  final DateTime startedAt;
}
