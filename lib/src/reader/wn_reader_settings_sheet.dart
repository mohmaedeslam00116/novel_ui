import 'package:flutter/material.dart';

import '../theme/wn_color_scheme.dart';
import '../theme/wn_theme.dart';
import '../theme/wn_reader_theme.dart';

/// Bottom sheet for tuning the reading experience — mirrors Webnovel's
/// reader settings: font size, line spacing, paper color and page mode.
Future<void> showWnReaderSettingsSheet({
  required BuildContext context,
  required WnReaderSettings settings,
  required ValueChanged<WnReaderSettings> onChanged,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) =>
        _ReaderSettingsSheet(settings: settings, onChanged: onChanged),
  );
}

class _ReaderSettingsSheet extends StatefulWidget {
  const _ReaderSettingsSheet({required this.settings, required this.onChanged});

  final WnReaderSettings settings;
  final ValueChanged<WnReaderSettings> onChanged;

  @override
  State<_ReaderSettingsSheet> createState() => _ReaderSettingsSheetState();
}

class _ReaderSettingsSheetState extends State<_ReaderSettingsSheet> {
  late WnReaderSettings _s = widget.settings;

  void _update(WnReaderSettings s) {
    setState(() => _s = s);
    widget.onChanged(s);
  }

  @override
  Widget build(BuildContext context) {
    final cs = WnTheme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Paper colors ──────────────────────────────────────────
            Row(
              children: [
                for (final paper in WnReaderPaper.values) ...[
                  Expanded(child: Center(child: _paperDot(paper))),
                  if (paper != WnReaderPaper.values.last)
                    const SizedBox(width: 14),
                ],
              ],
            ),
            const SizedBox(height: 20),

            // ── Font size ─────────────────────────────────────────────
            Row(
              children: [
                Text(
                  'A',
                  style: TextStyle(fontSize: 13, color: cs.textSecondary),
                ),
                Expanded(
                  child: Slider(
                    value: _s.fontSize.clamp(12, 32),
                    min: 12,
                    max: 32,
                    divisions: 10,
                    onChanged: (v) => _update(_s.copyWith(fontSize: v)),
                  ),
                ),
                Text(
                  'A',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: cs.textPrimary,
                  ),
                ),
              ],
            ),

            // ── Line height ───────────────────────────────────────────
            Row(
              children: [
                Icon(
                  Icons.format_line_spacing_rounded,
                  size: 18,
                  color: cs.textSecondary,
                ),
                Expanded(
                  child: Slider(
                    value: _s.lineHeight.clamp(1.2, 2.4),
                    min: 1.2,
                    max: 2.4,
                    divisions: 6,
                    label: _s.lineHeight.toStringAsFixed(1),
                    onChanged: (v) => _update(_s.copyWith(lineHeight: v)),
                  ),
                ),
                Text(
                  _s.lineHeight.toStringAsFixed(1),
                  style: TextStyle(fontSize: 13, color: cs.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ── Paragraph gap ─────────────────────────────────────────
            Row(
              children: [
                Icon(
                  Icons.view_agenda_outlined,
                  size: 18,
                  color: cs.textSecondary,
                ),
                Expanded(
                  child: Slider(
                    value: _s.paragraphSpacing.clamp(0, 28),
                    min: 0,
                    max: 28,
                    divisions: 7,
                    label: '${_s.paragraphSpacing.round()}px',
                    onChanged: (v) => _update(_s.copyWith(paragraphSpacing: v)),
                  ),
                ),
                Text(
                  '${_s.paragraphSpacing.round()}px',
                  style: TextStyle(fontSize: 13, color: cs.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ── Auto scroll (SettingAutoScroll) ───────────────────────
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              activeThumbColor: Theme.of(context).colorScheme.primary,
              title: Text(
                'Auto scroll',
                style: TextStyle(fontSize: 13.5, color: cs.textPrimary),
              ),
              secondary: Icon(
                Icons.fast_forward_rounded,
                size: 18,
                color: cs.textSecondary,
              ),
              value: _s.autoScroll,
              onChanged: (v) => _update(_s.copyWith(autoScroll: v)),
            ),
            if (_s.autoScroll)
              Row(
                children: [
                  Icon(Icons.speed_rounded, size: 17, color: cs.textSecondary),
                  Expanded(
                    child: Slider(
                      value: _s.autoScrollSpeed.clamp(20, 200),
                      min: 20,
                      max: 200,
                      divisions: 9,
                      label: '${_s.autoScrollSpeed.round()} px/s',
                      onChanged: (v) =>
                          _update(_s.copyWith(autoScrollSpeed: v)),
                    ),
                  ),
                  SizedBox(
                    width: 58,
                    child: Text(
                      '${_s.autoScrollSpeed.round()} px/s',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 11.5, color: cs.textTertiary),
                    ),
                  ),
                ],
              ),

            // ── Page turn style (SettingFancyWay) ─────────────────────
            if (_s.pageMode)
              SegmentedButton<WnPageFlip>(
                segments: const [
                  ButtonSegment(value: WnPageFlip.slide, label: Text('Slide')),
                  ButtonSegment(value: WnPageFlip.cover, label: Text('Cover')),
                  ButtonSegment(
                    value: WnPageFlip.instant,
                    label: Text('Instant'),
                  ),
                ],
                selected: {_s.pageFlip},
                onSelectionChanged: (set) =>
                    _update(_s.copyWith(pageFlip: set.first)),
              ),
            const SizedBox(height: 14),

            // ── Mode toggles ──────────────────────────────────────────
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: false,
                  icon: Icon(Icons.reorder_rounded),
                  label: Text('Scroll'),
                ),
                ButtonSegment(
                  value: true,
                  icon: Icon(Icons.auto_stories_rounded),
                  label: Text('Page'),
                ),
              ],
              selected: {_s.pageMode},
              onSelectionChanged: (set) =>
                  _update(_s.copyWith(pageMode: set.first)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paperDot(WnReaderPaper paper) {
    final colors = kWnReaderPapers[paper]!;
    final selected = _s.paper == paper;
    final cs = WnTheme.of(context).colorScheme;
    final labels = {
      WnReaderPaper.light: 'White',
      WnReaderPaper.sepia: 'Parchment',
      WnReaderPaper.green: 'Mint',
      WnReaderPaper.gray: 'Gray',
      WnReaderPaper.kraft: 'Kraft',
      WnReaderPaper.night: 'Night',
    };
    return GestureDetector(
      onTap: () => _update(_s.copyWith(paper: paper)),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.paper,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : colors.secondaryText.withValues(alpha: 0.35),
                width: selected ? 3 : 1.5,
              ),
            ),
            child: Center(
              child: Text(
                'Aa',
                style: TextStyle(
                  color: colors.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            labels[paper]!,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : cs.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
