import 'dart:async';

import 'package:flutter/material.dart';

import '../models/novel_book.dart';
import '../theme/novel_color_scheme.dart';
import '../theme/novel_reader_theme.dart';
import '../theme/novel_theme.dart';
import '../tokens/novel_dimens.dart';
import 'novel_reader_settings_sheet.dart';
import 'novel_text_paginator.dart';

/// Full-screen novel reader with scroll & paginated modes, night-friendly
/// paper themes and a settings sheet — the core of any Webnovel-style app.
///
/// ```dart
/// NovelReaderView(
///   chapter: chapter,
///   totalChapters: book.chapters.length,
///   onPrevChapter: ...,
///   onNextChapter: ...,
///   onBack: () => Navigator.pop(context),
/// )
/// ```
class NovelReaderView extends StatefulWidget {
  const NovelReaderView({
    super.key,
    required this.chapter,
    this.totalChapters = 1,
    this.settings = const NovelReaderSettings(),
    this.onSettingsChanged,
    this.onPrevChapter,
    this.onNextChapter,
    this.onBack,
    this.onCatalog,
    this.onProgressChanged,
    this.onBookmark,
    this.initialProgress = 0.0,
    this.paragraphCommentCounts,
    this.onParagraphComments,
  });

  final NovelChapter chapter;
  final int totalChapters;
  final NovelReaderSettings settings;
  final ValueChanged<NovelReaderSettings>? onSettingsChanged;
  final VoidCallback? onPrevChapter;
  final VoidCallback? onNextChapter;
  final VoidCallback? onBack;

  /// Opens the chapter catalog / table of contents. Apps decide how
  /// (bottom sheet, route, etc.).
  final VoidCallback? onCatalog;

  /// Fired with progress (0..1) as the user reads.
  final ValueChanged<double>? onProgressChanged;
  final VoidCallback? onBookmark;

  /// Restore point for scroll mode (0..1).
  final double initialProgress;

  /// Paragraph index → comment count. Renders the numbered comment
  /// bubble after each commented paragraph (scroll mode), mirroring the
  /// official app's paragraph-comment affordance.
  final Map<int, int>? paragraphCommentCounts;

  /// Called when the user taps a commented paragraph. Open the built-in
  /// [NovelParagraphCommentsSheet.show] here, or your own screen.
  final ValueChanged<int>? onParagraphComments;

  @override
  State<NovelReaderView> createState() => _NovelReaderViewState();
}

class _NovelReaderViewState extends State<NovelReaderView> {
  bool _chromeVisible = false;
  Timer? _autoScrollTimer;
  late NovelReaderSettings _settings = widget.settings;
  final ScrollController _scrollController = ScrollController();
  PageController? _pageController;
  List<NovelReaderPage>? _pages;
  double _progress = 0;
  int _pageIndex = 0;
  double? _pendingRestoreProgress;

  @override
  void initState() {
    super.initState();
    if (widget.initialProgress > 0 && !widget.settings.pageMode) {
      _pendingRestoreProgress = widget.initialProgress.clamp(0.0, 1.0);
    }
    _progress = widget.initialProgress.clamp(0.0, 1.0);
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant NovelReaderView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings != widget.settings) {
      _settings = widget.settings;
    }
    if (oldWidget.chapter.id != widget.chapter.id) {
      _pages = null;
      _pageIndex = 0;
      _progress = 0;
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
      _pageController = null;
    } else if (oldWidget.settings != widget.settings) {
      _pages = null; // re-paginate with new typography
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  /// Drives `SettingAutoScroll`: advances the scroll offset at the
  /// configured speed while enabled and in scroll mode.
  void _syncAutoScroll(NovelReaderSettings settings) {
    final shouldRun = settings.autoScroll && !settings.pageMode;
    if (shouldRun && _autoScrollTimer == null) {
      _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
        if (!mounted || !_scrollController.hasClients) return;
        final max = _scrollController.position.maxScrollExtent;
        if (_scrollController.offset >= max) {
          _autoScrollTimer?.cancel();
          _autoScrollTimer = null;
          return;
        }
        _scrollController.jumpTo(
          (_scrollController.offset + widget.settings.autoScrollSpeed * 0.05)
              .clamp(0.0, max),
        );
      });
    } else if (!shouldRun && _autoScrollTimer != null) {
      _autoScrollTimer?.cancel();
      _autoScrollTimer = null;
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients ||
        _scrollController.position.maxScrollExtent <= 0) {
      return;
    }
    final p =
        (_scrollController.offset / _scrollController.position.maxScrollExtent)
            .clamp(0.0, 1.0);
    setState(() => _progress = p);
    widget.onProgressChanged?.call(p);
  }

  void _toggleChrome() => setState(() => _chromeVisible = !_chromeVisible);

  void _applySettings(NovelReaderSettings s) {
    setState(() => _settings = s);
    widget.onSettingsChanged?.call(s);
  }

  void _openCatalogFallback() {
    // No catalog handler supplied — surface a lightweight built-in list.
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        final strings = NovelTheme.maybeOf(sheetContext)?.strings;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '${widget.chapter.index} / ${widget.totalChapters}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                      widget.onPrevChapter?.call();
                    },
                    child: Text(strings?.previous ?? 'Previous'),
                  ),
                  FilledButton(
                    onPressed: widget.onNextChapter == null
                        ? null
                        : () {
                            Navigator.of(sheetContext).pop();
                            widget.onNextChapter!.call();
                          },
                    child: Text(strings?.nextChapter ?? 'Next chapter'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _openSettings() {
    showNovelReaderSettingsSheet(
      context: context,
      settings: _settings,
      onChanged: _applySettings,
    );
  }

  TextStyle get _bodyStyle => TextStyle(
    fontSize: _settings.fontSize,
    height: _settings.lineHeight,
    fontFamily: _settings.fontFamily,
    wordSpacing: 1.2,
  );

  @override
  Widget build(BuildContext context) {
    final colors = kNovelReaderPapers[_settings.paper]!;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _syncAutoScroll(_settings),
    );

    return Scaffold(
      backgroundColor: colors.paper,
      body: Stack(
        children: [
          if (_settings.backImage != null)
            Positioned.fill(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _backImageProvider(),
                  // Legibility scrim (SettingBackImage dim).
                  ColoredBox(
                    color: Colors.black.withValues(
                      alpha: _settings.backImageDim.clamp(0.0, 0.9),
                    ),
                  ),
                ],
              ),
            ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NovelDimens.readerPageInsetH,
              ),
              child: _settings.pageMode
                  ? _buildPages(colors)
                  : _buildScroll(colors),
            ),
          ),
          if (_chromeVisible) ..._chrome(context, colors),
        ],
      ),
    );
  }

  // ── Scroll mode ────────────────────────────────────────────────────────
  Widget _buildScroll(NovelReaderColors colors) {
    final mediaQuery = MediaQuery.of(context);
    final paragraphs = widget.chapter.paragraphs;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pendingRestoreProgress != null &&
          _scrollController.hasClients &&
          _scrollController.position.maxScrollExtent > 0) {
        _scrollController.jumpTo(
          _pendingRestoreProgress! * _scrollController.position.maxScrollExtent,
        );
        _pendingRestoreProgress = null;
      }
    });

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(
        0,
        mediaQuery.padding.top + NovelDimens.readerPageInsetV,
        0,
        mediaQuery.padding.bottom + NovelDimens.readerPageInsetV + 24,
      ),
      itemCount: paragraphs.length + 2,
      itemBuilder: (context, i) {
        if (i == 0) return _chapterHeader(colors);
        if (i == paragraphs.length + 1) return _chapterFooter(colors);
        final pIndex = i - 1;
        final commentCount = widget.paragraphCommentCounts?[pIndex] ?? 0;
        return _ParagraphText(
          text: paragraphs[pIndex],
          style: _bodyStyle.copyWith(color: colors.text),
          spacing: _settings.paragraphSpacing,
          empty: paragraphs[pIndex].trim().isEmpty,
          commentCount: commentCount,
          onComments: commentCount > 0
              ? () => widget.onParagraphComments?.call(pIndex)
              : null,
        );
      },
    );
  }

  Widget _chapterHeader(NovelReaderColors colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 26, top: 8),
      child: Text(
        widget.chapter.title,
        style: TextStyle(
          fontSize: _settings.fontSize + 5,
          fontWeight: FontWeight.w800,
          height: 1.35,
          color: colors.text,
        ),
      ),
    );
  }

  Widget _chapterFooter(NovelReaderColors colors) {
    final strings = NovelTheme.maybeOf(context)?.strings;
    final hasNext = widget.onNextChapter != null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 34),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: widget.onPrevChapter,
              child: Text(strings?.previous ?? 'Previous'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: hasNext ? widget.onNextChapter : null,
              child: Text(strings?.nextChapter ?? 'Next chapter'),
            ),
          ),
        ],
      ),
    );
  }

  // ── Page mode ──────────────────────────────────────────────────────────
  Widget _buildPages(NovelReaderColors colors) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final topInset = MediaQuery.of(context).padding.top;
        final bottomInset = MediaQuery.of(context).padding.bottom;
        final pageHeight = constraints.maxHeight - topInset - bottomInset - 8;
        final pagesKey = Object.hash(
          widget.chapter.id,
          _settings.fontSize,
          _settings.lineHeight,
          _settings.paragraphSpacing,
          _settings.fontFamily,
          constraints.maxWidth.round(),
          pageHeight.round(),
        );
        if (_pages == null || _computedPagesHash != pagesKey) {
          _computedPagesHash = pagesKey;
          _pages = NovelTextPaginator.paginate(
            paragraphs: [widget.chapter.title, ...widget.chapter.paragraphs],
            maxWidth: constraints.maxWidth,
            maxHeight: pageHeight,
            style: _bodyStyle,
            paragraphSpacing: _settings.paragraphSpacing,
          );
          _pageController ??= PageController(
            initialPage: _pageIndex.clamp(0, _pages!.length - 1),
          );
        }
        final pages = _pages!;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: _handlePageTap,
          child: PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            onPageChanged: (i) {
              setState(() {
                _pageIndex = i;
                _progress = pages.length <= 1 ? 1 : i / (pages.length - 1);
              });
              widget.onProgressChanged?.call(_progress);
            },
            itemBuilder: (context, i) {
              return _PageFlipEffect(
                controller: _pageController,
                index: i,
                style: _settings.pageFlip,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: topInset + 4,
                    bottom: bottomInset + 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var s = 0; s < pages[i].segments.length; s++)
                        _ParagraphText(
                          text: pages[i].segments[s].text,
                          style: _bodyStyle.copyWith(color: colors.text),
                          spacing: s == pages[i].segments.length - 1
                              ? 0
                              : _settings.paragraphSpacing,
                          empty: pages[i].segments[s].text.trim().isEmpty,
                        ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          '${i + 1} / ${pages.length}',
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.secondaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  int? _computedPagesHash;

  void _handlePageTap(TapUpDetails details) {
    final width = MediaQuery.of(context).size.width;
    final dx = details.globalPosition.dx;
    if (dx < width * 0.3) {
      _goToRelativePage(-1);
    } else if (dx > width * 0.7) {
      _goToRelativePage(1);
    } else {
      _toggleChrome();
    }
  }

  void _goToRelativePage(int delta) {
    final controller = _pageController;
    final pages = _pages;
    if (controller == null || pages == null || pages.isEmpty) return;
    final target = _pageIndex + delta;
    if (target < 0) {
      widget.onPrevChapter?.call();
    } else if (target >= pages.length) {
      widget.onNextChapter?.call();
    } else if (_settings.pageFlip == NovelPageFlip.instant ||
        MediaQuery.of(context).disableAnimations) {
      controller.jumpToPage(target);
    } else {
      controller.animateToPage(
        target,
        duration: NovelDimens.fast * 2,
        curve: Curves.easeOutCubic,
      );
    }
  }

  // ── Chrome ─────────────────────────────────────────────────────────────
  List<Widget> _chrome(BuildContext context, NovelReaderColors colors) {
    final cs = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final strings = NovelTheme.maybeOf(context)?.strings;
    return [
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          color: colors.paper.withValues(alpha: 0.97),
          padding: EdgeInsets.only(top: mediaQuery.padding.top),
          child: SizedBox(
            height: NovelDimens.appBarHeight,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_rounded, color: colors.text),
                  onPressed: () {
                    if (widget.onBack != null) {
                      widget.onBack!();
                    } else {
                      Navigator.maybeOf(context)?.maybePop();
                    }
                  },
                ),
                Expanded(
                  child: Text(
                    '${widget.chapter.title}  ·  ${widget.chapter.index}/${widget.totalChapters}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: colors.text,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.bookmark_border_rounded, color: colors.text),
                  onPressed: widget.onBookmark,
                ),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          decoration: BoxDecoration(
            color: colors.paper.withValues(alpha: 0.97),
            border: Border(
              top: BorderSide(
                color: colors.secondaryText.withValues(alpha: 0.18),
              ),
            ),
          ),
          padding: EdgeInsets.fromLTRB(
            20,
            10,
            20,
            mediaQuery.padding.bottom + 12,
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      '${(_progress * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: colors.secondaryText,
                      ),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 7,
                          ),
                          activeTrackColor: cs.primary,
                          inactiveTrackColor: colors.controlBackground,
                          thumbColor: cs.primary,
                          overlayColor: Colors.transparent,
                        ),
                        child: Slider(
                          value: _progress,
                          onChanged: (v) {
                            setState(() => _progress = v);
                            if (!_settings.pageMode &&
                                _scrollController.hasClients) {
                              _scrollController.jumpTo(
                                v * _scrollController.position.maxScrollExtent,
                              );
                            } else if (_pageController != null &&
                                (_pages?.isNotEmpty ?? false)) {
                              _pageIndex = v.round().clamp(
                                0,
                                _pages!.length - 1,
                              );
                              _pageController!.jumpToPage(_pageIndex);
                            }
                          },
                        ),
                      ),
                    ),
                    Text(
                      'Ch.${widget.chapter.index}/${widget.totalChapters}',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: colors.secondaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ChromeButton(
                      icon: Icons.menu_book_rounded,
                      label: strings?.catalog ?? 'Catalog',
                      color: colors.text,
                      onTap: widget.onCatalog ?? _openCatalogFallback,
                    ),
                    _ChromeButton(
                      icon: Icons.format_size_rounded,
                      label: strings?.settings ?? 'Settings',
                      color: colors.text,
                      onTap: _openSettings,
                    ),
                    _ChromeButton(
                      icon: _settings.autoScroll
                          ? Icons.pause_rounded
                          : Icons.fast_forward_rounded,
                      label: 'Auto',
                      active: _settings.autoScroll,
                      color: colors.text,
                      onTap: () => _applySettings(
                        _settings.copyWith(autoScroll: !_settings.autoScroll),
                      ),
                    ),
                    _ChromeButton(
                      icon: widget.settings.pageMode
                          ? Icons.auto_stories_rounded
                          : Icons.reorder_rounded,
                      label: widget.settings.pageMode
                          ? (strings?.pageMode ?? 'Page')
                          : (strings?.scrollMode ?? 'Scroll'),
                      color: colors.text,
                      onTap: () => _applySettings(
                        _settings.copyWith(pageMode: !_settings.pageMode),
                      ),
                    ),
                    _ChromeButton(
                      icon: _isNightPaper
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      label: _isNightPaper
                          ? (strings?.day ?? 'Day')
                          : (strings?.night ?? 'Night'),
                      color: colors.text,
                      onTap: () => _applySettings(
                        _settings.copyWith(
                          paper: _isNightPaper
                              ? NovelReaderPaper.sepia
                              : NovelReaderPaper.night,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  /// Resolves [NovelReaderSettings.backImage]: http(s) URLs render from the
  /// network, anything else loads from the asset bundle.
  Widget _backImageProvider() {
    final url = _settings.backImage!;
    final isNetwork = url.startsWith('http://') || url.startsWith('https://');
    final image = isNetwork
        ? Image.network(url, fit: BoxFit.cover)
        : Image.asset(url, fit: BoxFit.cover);
    return image;
  }

  bool get _isNightPaper =>
      _settings.paper == NovelReaderPaper.night ||
      _settings.paper == NovelReaderPaper.gray;
}

class _ParagraphText extends StatelessWidget {
  const _ParagraphText({
    required this.text,
    required this.style,
    required this.spacing,
    required this.empty,
    this.commentCount = 0,
    this.onComments,
  });

  final String text;
  final TextStyle style;
  final double spacing;
  final bool empty;
  final int commentCount;
  final VoidCallback? onComments;

  @override
  Widget build(BuildContext context) {
    if (empty) return SizedBox(height: spacing);
    final cs = NovelTheme.maybeOf(context)?.colorScheme;
    final body = Text(text, style: style);
    if (commentCount <= 0 || onComments == null) {
      return Padding(
        padding: EdgeInsets.only(bottom: spacing),
        child: body,
      );
    }
    return Padding(
      padding: EdgeInsets.only(bottom: spacing),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onComments,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: body),
            const SizedBox(width: 8),
            _CommentBubble(
              count: commentCount,
              color: cs?.primary ?? style.color!,
            ),
          ],
        ),
      ),
    );
  }
}

/// Numbered paragraph-comment pill shown after commented paragraphs.
class _CommentBubble extends StatelessWidget {
  const _CommentBubble({required this.count, required this.color});

  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.mode_comment_outlined, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: color,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Applies the configured [NovelPageFlip] turn animation to one page of the
/// reader's PageView. `slide` passes through untouched; `cover` adds a
/// perspective Y-rotation so pages feel like leaves of a book; `instant`
/// also renders untouched (tap navigation jumps instead of animating).
class _PageFlipEffect extends StatelessWidget {
  const _PageFlipEffect({
    required this.controller,
    required this.index,
    required this.style,
    required this.child,
  });

  final PageController? controller;
  final int index;
  final NovelPageFlip style;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (style != NovelPageFlip.cover ||
        controller == null ||
        !controller!.hasClients) {
      return child;
    }
    return AnimatedBuilder(
      animation: controller!,
      builder: (context, _) {
        double delta = (index - (controller!.page ?? index.toDouble())).clamp(
          -1.0,
          1.0,
        );
        // Pages off-screen keep their resting transform.
        final angle = delta * 0.35;
        return Transform(
          alignment: delta > 0 ? Alignment.centerLeft : Alignment.centerRight,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0015)
            ..rotateY(angle),
          child: Opacity(opacity: 1 - delta.abs() * 0.25, child: child),
        );
      },
    );
  }
}

class _ChromeButton extends StatelessWidget {
  const _ChromeButton({
    required this.icon,
    required this.label,
    required this.color,
    this.active = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;

  /// Highlights the button while its mode is on (e.g. auto-scroll).
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = NovelTheme.maybeOf(context)?.colorScheme;
    final accent = active ? cs?.primary ?? color : color;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 21, color: accent),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: active ? FontWeight.w800 : FontWeight.w400,
                color: accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
