import 'dart:async';

import 'package:flutter/material.dart';

import '../tokens/wn_dimens.dart';
import '../theme/wn_theme.dart';

/// Drives text-to-speech for a [WnTtsPanel]. The library ships no TTS
/// engine (that needs platform plugins); apps adapt their engine of choice
/// (flutter_tts, cloud TTS, …) to this interface.
abstract class WnTtsDriver {
  /// Speaks [text]; resolves when playback of this utterance finishes or
  /// is superseded.
  Future<void> speak(String text);

  /// Stops current speech immediately.
  Future<void> stop();

  /// Notifies the panel when an utterance completes on its own (engine
  /// callbacks). Optional — without it the panel advances only via
  /// [WnSimulatedTtsDriver]-style timing or user taps.
  void Function()? onUtteranceComplete;
}

/// Timer-paced driver used for demos, tests and preview builds: "speaks"
/// each paragraph for roughly [millisecondsPerParagraph] then reports
/// completion through [WnTtsDriver.onUtteranceComplete].
class WnSimulatedTtsDriver extends WnTtsDriver {
  WnSimulatedTtsDriver({this.millisecondsPerParagraph = 2600});

  final int millisecondsPerParagraph;
  Timer? _timer;

  @override
  Future<void> speak(String text) async {
    await stop();
    _timer = Timer(Duration(milliseconds: millisecondsPerParagraph), () {
      onUtteranceComplete?.call();
    });
  }

  @override
  Future<void> stop() async {
    _timer?.cancel();
    _timer = null;
  }
}

/// Listening screen (the official app's TTS surface): plays chapter
/// paragraphs in order with the **current paragraph highlighted**, plus
/// transport controls and speed.
///
/// ```dart
/// WnTtsPanel(
///   paragraphs: chapter.paragraphs,
///   driver: myFlutterTtsAdapter,
///   onExit: () => Navigator.pop(context),
/// )
/// ```
class WnTtsPanel extends StatefulWidget {
  const WnTtsPanel({
    super.key,
    required this.paragraphs,
    required this.driver,
    this.initialIndex = 0,
    this.speed = 1.0,
    this.onSpeedChanged,
    this.onExit,
    this.title,
  });

  final List<String> paragraphs;
  final WnTtsDriver driver;
  final int initialIndex;
  final double speed;
  final ValueChanged<double>? onSpeedChanged;
  final VoidCallback? onExit;
  final String? title;

  @override
  State<WnTtsPanel> createState() => _WnTtsPanelState();
}

class _WnTtsPanelState extends State<WnTtsPanel> {
  late int _index = widget.initialIndex.clamp(0, widget.paragraphs.length - 1);
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    widget.driver.onUtteranceComplete = _advance;
  }

  @override
  void didUpdateWidget(covariant WnTtsPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.driver != widget.driver) {
      oldWidget.driver.onUtteranceComplete = null;
      widget.driver.onUtteranceComplete = _advance;
    }
  }

  @override
  void dispose() {
    widget.driver.onUtteranceComplete = null;
    unawaited(widget.driver.stop());
    super.dispose();
  }

  void _advance() {
    if (!mounted || !_playing) return;
    if (_index >= widget.paragraphs.length - 1) {
      setState(() => _playing = false);
      return;
    }
    setState(() => _index += 1);
    _speakCurrent();
  }

  Future<void> _speakCurrent() async {
    await widget.driver.speak(widget.paragraphs[_index]);
  }

  Future<void> _togglePlay() async {
    if (_playing) {
      await widget.driver.stop();
      setState(() => _playing = false);
    } else {
      setState(() => _playing = true);
      await _speakCurrent();
    }
  }

  Future<void> _jump(int index) async {
    index = index.clamp(0, widget.paragraphs.length - 1);
    setState(() => _index = index);
    if (_playing) await _speakCurrent();
  }

  @override
  Widget build(BuildContext context) {
    final cs = WnTheme.of(context).colorScheme;
    final strings = WnTheme.of(context).strings;
    return Column(
      children: [
        // ── Header ────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(WnDimens.screenPadding, 8, 8, 8),
          child: Row(
            children: [
              Icon(Icons.headphones_rounded, size: 18, color: cs.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.title ?? strings.listen,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: cs.textPrimary,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: widget.onExit,
              ),
            ],
          ),
        ),

        // ── Paragraph list with live highlight ────────────────────
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: WnDimens.screenPadding,
            ),
            itemCount: widget.paragraphs.length,
            itemBuilder: (context, i) {
              final current = i == _index;
              return GestureDetector(
                onTap: () => _jump(i),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: current
                        ? cs.primary.withValues(alpha: 0.10)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(WnDimens.radiusMd),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (current) ...[
                        Icon(
                          Icons.volume_up_rounded,
                          size: 16,
                          color: cs.primary,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          widget.paragraphs[i],
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            fontWeight: current
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: current
                                ? cs.textPrimary
                                : cs.textSecondary.withValues(alpha: 0.75),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // ── Transport ─────────────────────────────────────────────
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _jump(_index - 1),
                  icon: const Icon(Icons.skip_previous_rounded),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: _togglePlay,
                  icon: Icon(
                    _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  ),
                  label: Text(
                    '${_index + 1} / ${widget.paragraphs.length}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _jump(_index + 1),
                  icon: const Icon(Icons.skip_next_rounded),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
