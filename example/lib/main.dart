import 'package:flutter/material.dart';
import 'package:novel_ui/novel_ui.dart';

import 'mock_data.dart';

void main() {
  runApp(const NovelDemoApp());
}

class NovelDemoApp extends StatefulWidget {
  const NovelDemoApp({super.key});

  @override
  State<NovelDemoApp> createState() => _NovelDemoAppState();
}

enum DemoBrand { webnovel, gold, wattpad, goodnovel, royalroad }

class _NovelDemoAppState extends State<NovelDemoApp> {
  ThemeMode _mode = ThemeMode.light;
  bool _arabic = false;
  DemoBrand _brand = DemoBrand.gold;

  /// Screenshot/demo deep links, e.g. `?tab=1&dark=1` or `?screen=reader`.
  late final Uri _launchUri = Uri.base;

  @override
  void initState() {
    super.initState();
    if (_launchUri.queryParameters['dark'] == '1') _mode = ThemeMode.dark;
    final tab = int.tryParse(_launchUri.queryParameters['tab'] ?? '');
    if (tab != null && tab >= 0 && tab <= 2) _initialTab = tab;
    _deepScreen = _launchUri.queryParameters['screen'];
  }

  int _initialTab = 0;
  String? _deepScreen;

  static const _wattpad = NovelColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFFF500A),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFFFD9CA),
    onPrimaryContainer: Color(0xFF602B1C),
    secondary: Color(0xFF5C10FF),
    background: Color(0xFFF6F6F6),
    surface: Colors.white,
    surfaceLow: Color(0xFFF6F6F6),
    textPrimary: Color(0xFF121212),
    textSecondary: Color(0xFF686868),
    textTertiary: Color(0xFFB3B3B3),
    border: Color(0xFFE2E2E2),
    error: Color(0xFFE00000),
    success: Color(0xFF00854E),
  );
  static const _goodNovel = NovelColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFEE3799),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFFFC8CB),
    onPrimaryContainer: Color(0xFF5A1D30),
    secondary: Color(0xFF409EFF),
    background: Color(0xFFF5F7FA),
    surface: Colors.white,
    surfaceLow: Color(0xFFEBEEF5),
    textPrimary: Color(0xFF303133),
    textSecondary: Color(0xFF606266),
    textTertiary: Color(0xFF909399),
    border: Color(0xFFDCDFE6),
    error: Color(0xFFF56C6C),
    success: Color(0xFF67C23A),
  );
  static const _royalRoad = NovelColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1976D2),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFD6E7FA),
    onPrimaryContainer: Color(0xFF0D3C66),
    secondary: Color(0xFF6366F1),
    background: Color(0xFFFAFAFA),
    surface: Colors.white,
    surfaceLow: Color(0xFFEFF3F8),
    textPrimary: Color(0xFF2C393F),
    textSecondary: Color(0xFF5A5A5A),
    textTertiary: Color(0xFFB7B7B7),
    border: Color(0xFFEAEAEA),
    error: Color(0xFFF56C6C),
    success: Color(0xFF67C23A),
  );

  NovelThemeData _brandTheme(Brightness b) {
    final base = b == Brightness.dark
        ? NovelThemeData.dark()
        : NovelThemeData.light();
    if (b == Brightness.light) {
      final cs = switch (_brand) {
        DemoBrand.webnovel => NovelColorScheme.webnovel,
        DemoBrand.gold => NovelColorScheme.light,
        DemoBrand.wattpad => _wattpad,
        DemoBrand.goodnovel => _goodNovel,
        DemoBrand.royalroad => _royalRoad,
      };
      return NovelThemeData(colorScheme: cs, brightness: Brightness.light);
    }
    return base;
  }

  @override
  Widget build(BuildContext context) {
    NovelThemeData themeOf(Brightness b) {
      final base = _brandTheme(b);
      return _arabic ? base.copyWith(strings: NovelStrings.ar()) : base;
    }

    return MaterialApp(
      title: 'WN Design Demo',
      debugShowCheckedModeBanner: false,
      themeMode: _mode,
      theme: themeOf(Brightness.light).toMaterialTheme(),
      darkTheme: themeOf(Brightness.dark).toMaterialTheme(),
      builder: (context, child) => Directionality(
        textDirection: _arabic ? TextDirection.rtl : TextDirection.ltr,
        child: NovelTheme(
          data: themeOf(Theme.of(context).brightness),
          child: child!,
        ),
      ),
      home: HomeShell(
        isDark: _mode == ThemeMode.dark,
        isArabic: _arabic,
        brand: _brand,
        initialTab: _initialTab,
        deepScreen: _deepScreen,
        onBrandChanged: (b) => setState(() => _brand = b),
        onToggleMode: () => setState(
          () => _mode = _mode == ThemeMode.dark
              ? ThemeMode.light
              : ThemeMode.dark,
        ),
        onToggleLanguage: () => setState(() => _arabic = !_arabic),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom navigation shell — Library / Rankings / Gallery
// ─────────────────────────────────────────────────────────────────────────────
class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    required this.isDark,
    required this.onToggleMode,
    required this.isArabic,
    required this.onToggleLanguage,
    required this.brand,
    required this.onBrandChanged,
    this.initialTab = 0,
    this.deepScreen,
  });

  final bool isDark;
  final bool isArabic;
  final DemoBrand brand;
  final ValueChanged<DemoBrand> onBrandChanged;
  final VoidCallback onToggleMode;
  final VoidCallback onToggleLanguage;
  final int initialTab;

  /// `reader` or `detail` — opens that screen once for screenshot runs.
  final String? deepScreen;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late int _tab = widget.initialTab.clamp(0, 2);
  bool _deepOpened = false;

  @override
  Widget build(BuildContext context) {
    // Screenshot deep links: open the requested screen once.
    if (!_deepOpened && widget.deepScreen != null) {
      _deepOpened = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final book = DemoData.books[0];
        if (widget.deepScreen == 'detail') {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => BookDetailScreen(book: book),
            ),
          );
        } else if (widget.deepScreen == 'reader') {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ReaderScreen(book: book, startChapter: 11),
            ),
          );
        }
      });
    }

    final pages = [
      LibraryScreen(
        isArabic: widget.isArabic,
        onToggleLanguage: widget.onToggleLanguage,
        brand: widget.brand,
        onBrandChanged: widget.onBrandChanged,
      ),
      const RankingsScreen(),
      const GalleryScreen(),
    ];
    return Scaffold(
      body: pages[_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: [
          NavigationDestination(
            icon: Icon(
              widget.isDark ? Icons.auto_stories_outlined : Icons.auto_stories,
            ),
            label: 'Library',
          ),
          const NavigationDestination(
            icon: Icon(Icons.leaderboard_outlined),
            label: 'Rankings',
          ),
          const NavigationDestination(
            icon: Icon(Icons.widgets_outlined),
            label: 'Gallery',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Library screen
// ─────────────────────────────────────────────────────────────────────────────
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({
    super.key,
    required this.isArabic,
    required this.onToggleLanguage,
    required this.brand,
    required this.onBrandChanged,
  });

  final bool isArabic;
  final VoidCallback onToggleLanguage;
  final DemoBrand brand;
  final ValueChanged<DemoBrand> onBrandChanged;

  void _pickBrand(BuildContext context) {
    const labels = {
      DemoBrand.gold: 'WN Classic Gold',
      DemoBrand.webnovel: 'Webnovel 2024 (Blue)',
      DemoBrand.wattpad: 'Wattpad Orange',
      DemoBrand.goodnovel: 'GoodNovel Pink',
      DemoBrand.royalroad: 'Royal Road Blue',
    };
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final e in labels.entries)
              ListTile(
                leading: const Icon(Icons.palette_rounded),
                title: Text(e.value),
                trailing: e.key == brand
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () {
                  onBrandChanged(e.key);
                  Navigator.pop(sheetContext);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = NovelTheme.of(context).colorScheme;
    final books = DemoData.books;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NovelHub',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 21,
            color: cs.primary,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            onPressed: () => _pickBrand(context),
          ),
          TextButton(
            onPressed: onToggleLanguage,
            child: Text(
              isArabic ? 'EN' : 'ع',
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
          ),
          IconButton(icon: const Icon(Icons.history_rounded), onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: NovelDimens.screenPadding,
              vertical: 10,
            ),
            child: GestureDetector(
              onTap: () => ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Open search page'))),
              child: const IgnorePointer(
                child: NovelSearchField(
                  hintText: 'Search 2M+ novels',
                  suffixIcons: [
                    Icons.mic_none_rounded,
                    Icons.photo_camera_outlined,
                  ],
                ),
              ),
            ),
          ),

          // Banner carousel (16:9 promo strip)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: NovelDimens.screenPadding,
            ),
            child: NovelBannerCarousel(
              height: 140,
              banners: const [
                NovelBanner(
                  title: 'Power Ranking Season Finale — vote now!',
                  tag: 'EVENT',
                ),
                NovelBanner(
                  title: 'Solo Leveling: new season chapters',
                  tag: 'HOT',
                ),
                NovelBanner(
                  title: 'Read-to-Earn: 30 min = 1 Fast Pass',
                  tag: 'REWARDS',
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Continue reading
          NovelSectionHeader(title: 'Continue Reading', onSeeAll: () {}),
          const SizedBox(height: 10),
          NovelContinueReadingCard(
            book: books[0],
            chapterIndex: 12,
            lastChapterTitle: 'The Wind Rises Over Azure Peak',
            progress: 0.34,
            onTap: () => _openReader(context, books[0], startChapter: 11),
          ),
          const SizedBox(height: 22),

          // Popular grid
          NovelSectionHeader(
            title: 'Popular Right Now',
            subtitle: 'Updated 5m ago',
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: NovelDimens.screenPadding,
            ),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 130,
              mainAxisSpacing: 18,
              crossAxisSpacing: 14,
              childAspectRatio: 0.52,
            ),
            itemCount: books.length,
            itemBuilder: (context, i) => Center(
              child: NovelBookCard(
                book: books[i],
                updateCount: i == 0 ? 12 : null,
                subtitle:
                    '${novelCompactCount(books[i].viewCount)} views · ${books[i].status.name}',
                onTap: () => _openDetail(context, books[i]),
              ),
            ),
          ),
          const SizedBox(height: 22),

          // List section
          NovelSectionHeader(title: 'Editors’ Picks'),
          const SizedBox(height: 6),
          ...List.generate(3, (i) {
            final b = books[(i + 2) % books.length];
            return NovelBookListTile(
              book: b,
              onTap: () => _openDetail(context, b),
            );
          }),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

void _openDetail(BuildContext context, NovelBook book) {
  Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => BookDetailScreen(book: book)));
}

void _openReader(BuildContext context, NovelBook book, {int startChapter = 0}) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => ReaderScreen(book: book, startChapter: startChapter),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Rankings screen
// ─────────────────────────────────────────────────────────────────────────────
class RankingsScreen extends StatelessWidget {
  const RankingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ranked = [...DemoData.books]
      ..sort((a, b) => b.score.compareTo(a.score));
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rankings'),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Power'),
              Tab(text: 'Newcomer'),
              Tab(text: 'Completed'),
            ],
            dividerColor: Colors.transparent,
          ),
        ),
        body: TabBarView(
          children: [
            ListView.separated(
              itemCount: ranked.length,
              separatorBuilder: (_, _) => const Divider(indent: 140),
              itemBuilder: (context, i) => NovelRankListItem(
                rank: i + 1,
                book: ranked[i],
                rankStyle: NovelRankStyle.topThree,
                onTap: () => _openDetail(context, ranked[i]),
              ),
            ),
            ListView.separated(
              itemCount: ranked.length,
              separatorBuilder: (_, _) => const Divider(indent: 140),
              itemBuilder: (context, i) {
                final b = ranked.reversed.toList()[i];
                return NovelRankListItem(
                  rank: i + 1,
                  book: b,
                  onTap: () => _openDetail(context, b),
                );
              },
            ),
            ListView.separated(
              itemCount: ranked.length,
              separatorBuilder: (_, _) => const Divider(indent: 140),
              itemBuilder: (context, i) {
                final b = DemoData.books[i];
                return NovelRankListItem(
                  rank: i + 1,
                  book: b,
                  onTap: () => _openDetail(context, b),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Book detail screen
// ─────────────────────────────────────────────────────────────────────────────
class BookDetailScreen extends StatefulWidget {
  const BookDetailScreen({super.key, required this.book});

  final NovelBook book;

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool _inLibrary = false;
  bool _summaryExpanded = false;

  @override
  Widget build(BuildContext context) {
    final cs = NovelTheme.of(context).colorScheme;
    final book = widget.book;
    final chapters = DemoData.chaptersFor(book);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: const Icon(Icons.share_rounded), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                NovelDimens.screenPadding,
                4,
                NovelDimens.screenPadding,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NovelCoverView(
                        url: book.coverUrl,
                        title: book.title,
                        author: book.author,
                        width: 110,
                      ),
                      const SizedBox(width: NovelDimens.xl),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline_rounded,
                                  size: 15,
                                  color: cs.textTertiary,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    book.author,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: cs.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                if (book.category != null)
                                  NovelTagChip(
                                    book.category!,
                                    dense: true,
                                    selected: true,
                                  ),
                                for (final t in book.tags.skip(1).take(2))
                                  NovelTagChip(t, dense: true),
                              ],
                            ),
                            const SizedBox(height: 10),
                            NovelStatusBadge(book.status, compact: false),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _Stat(
                        value: novelCompactCount(book.viewCount),
                        label: 'Views',
                      ),
                      _Stat(
                        value: novelCompactCount(book.collectionCount),
                        label: 'Collections',
                      ),
                      _Stat(
                        value:
                            '${(book.wordCount / 10000).toStringAsFixed(0)}w',
                        label: 'Words',
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            NovelRatingBar(
                              value: book.score,
                              size: 15,
                              showValueLabel: true,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${novelCompactCount(book.ratingCount)} ratings',
                              style: TextStyle(
                                fontSize: 10.5,
                                color: cs.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Actions row
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: FilledButton.icon(
                          onPressed: () => _openReader(context, book),
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('Read Now'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              setState(() => _inLibrary = !_inLibrary),
                          icon: Icon(_inLibrary ? Icons.check : Icons.add),
                          label: Text(_inLibrary ? 'Added' : 'Library'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      NovelPowerStoneButton(count: 12400),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Synopsis
                  GestureDetector(
                    onTap: () =>
                        setState(() => _summaryExpanded = !_summaryExpanded),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.summary,
                          maxLines: _summaryExpanded ? null : 3,
                          overflow: _summaryExpanded
                              ? null
                              : TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.5,
                            height: 1.6,
                            color: cs.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _summaryExpanded ? 'Collapse' : 'Expand',
                              style: TextStyle(fontSize: 12, color: cs.primary),
                            ),
                            Icon(
                              _summaryExpanded
                                  ? Icons.expand_less_rounded
                                  : Icons.expand_more_rounded,
                              size: 17,
                              color: cs.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Chapter header
                  Container(
                    decoration: BoxDecoration(
                      color: cs.surfaceLow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Catalog · ${chapters.length} chapters',
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.unfold_more_rounded,
                          size: 17,
                          color: cs.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Latest',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: cs.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList.builder(
            itemCount: chapters.length,
            itemBuilder: (context, i) {
              final ch = chapters[i];
              return NovelChapterTile(
                chapter: ch,
                isRead: ch.index <= 3,
                onTap: () async {
                  if (!ch.isLocked) {
                    _openReader(context, book, startChapter: ch.index - 1);
                    return;
                  }
                  await NovelUnlockSheet.show(
                    context: context,
                    chapter: ch,
                    coinBalance: 120,
                  );
                },
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = NovelTheme.of(context).colorScheme;
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: cs.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: cs.textTertiary)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reader screen
// ─────────────────────────────────────────────────────────────────────────────
class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key, required this.book, this.startChapter = 0});

  final NovelBook book;
  final int startChapter;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late final List<NovelChapter> chapters = DemoData.chaptersFor(widget.book);
  late int _index = widget.startChapter.clamp(0, chapters.length - 1);
  double _progress = 0;

  /// Demo paragraph-comment store: chapterKey -> (paragraph -> comments).
  static const _demoCommenters = ['Jerome Bell', 'Luna', 'Aster', 'Rin'];

  Map<int, List<NovelComment>> get _commentsForCurrentChapter => {
    for (final i in [2, 5, 9])
      i: List.generate(
        (i % 3) + 1,
        (k) => NovelComment(
          userName: _demoCommenters[k % _demoCommenters.length],
          content:
              'This line hits different on a re-read. The author planned this from chapter 1!',
          level: 8 + k * 4,
          likes: 40 * (k + 1) + i,
          replyCount: k + 1,
          timeLabel: '${k + 1}h',
        ),
      ),
  };

  @override
  Widget build(BuildContext context) {
    final settings =
        MediaQuery.of(context).platformBrightness == Brightness.dark
        ? const NovelReaderSettings(paper: NovelReaderPaper.night)
        : const NovelReaderSettings(paper: NovelReaderPaper.sepia);
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Saved progress: ${(_progress * 100).toStringAsFixed(0)}%',
              ),
            ),
          );
        }
      },
      child: NovelReaderView(
        chapter: chapters[_index],
        totalChapters: chapters.length,
        settings: settings,
        initialProgress: _progress,
        paragraphCommentCounts: {
          for (final e in _commentsForCurrentChapter.entries)
            e.key: e.value.length,
        },
        onParagraphComments: (i) => NovelParagraphCommentsSheet.show(
          context,
          paragraphIndex: i,
          paragraphText: chapters[_index].paragraphs[i],
          comments: _commentsForCurrentChapter[i] ?? const [],
          onSend: (text) => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Sent: $text'))),
        ),
        onProgressChanged: (p) => _progress = p,
        onPrevChapter: _index > 0
            ? () => setState(() {
                _index--;
                _progress = 0;
              })
            : null,
        onNextChapter: _index < chapters.length - 1
            ? () => setState(() {
                _index++;
                _progress = 0;
              })
            : null,
        onCatalog: () => showModalBottomSheet(
          context: context,
          builder: (ctx) => SafeArea(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: chapters.length,
              itemBuilder: (_, i) => ListTile(
                dense: true,
                selected: i == _index,
                leading: Text(
                  '${chapters[i].index}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                title: Text(
                  chapters[i].title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: chapters[i].isLocked
                    ? const Icon(Icons.lock_outline_rounded, size: 15)
                    : null,
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() {
                    _index = i;
                    _progress = 0;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Component gallery
// ─────────────────────────────────────────────────────────────────────────────
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = NovelTheme.of(context).colorScheme;
    final b = DemoData.books[0];
    final ch = DemoData.chaptersFor(b)[7].copyWith(isLocked: true, coinCost: 8);
    return Scaffold(
      appBar: AppBar(title: const Text('Component Gallery')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          NovelSectionHeader(title: 'Rating bars'),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: NovelRatingBar(value: 4.7, showValueLabel: true),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: NovelRatingBar(value: 3.2, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          NovelSectionHeader(title: 'Tags & badges'),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                NovelTagChip('Eastern Fantasy', selected: true),
                NovelTagChip('Cultivation'),
                NovelTagChip('System'),
                NovelStatusBadge(NovelBookStatus.ongoing, compact: false),
                NovelStatusBadge(NovelBookStatus.completed, compact: false),
                const NovelCoinBadge(amount: 1280),
                const NovelUpdateBadge(count: 12),
                const NovelFansRankBadge(rank: 1),
                const NovelFansRankBadge(rank: 2),
                const NovelFansRankBadge(rank: 3),
                const NovelCornerRibbon('Original'),
                const NovelLevelBadge(level: 15),
              ],
            ),
          ),
          const SizedBox(height: 22),

          NovelSectionHeader(title: 'Search landing (hot + history)'),
          const SizedBox(height: 10),
          NovelSearchSuggestions(
            hotSearches: const [
              'Solo Leveling',
              'Rebirth of the Golden Emperor',
              'Villainess Turns the Hourglass',
              'System',
              'Cultivation',
            ],
            history: const ['cultivation', 'contract marriage', 'dungeon'],
            onHistoryClear: () {},
          ),
          const SizedBox(height: 22),

          NovelSectionHeader(title: 'Power Ranking podium (GoodNovel-style)'),
          const SizedBox(height: 10),
          NovelPowerRankPodium(
            title: 'Power Ranking · Weekly',
            topThree: [DemoData.books[5], DemoData.books[0], DemoData.books[4]],
            onTap: (i) {},
          ),
          const SizedBox(height: 22),

          NovelSectionHeader(title: 'Achievements (RoyalRoad-style)'),
          const SizedBox(height: 10),
          NovelAchievementRow(
            achievements: const [
              NovelAchievement(
                label: '1M words',
                icon: Icons.auto_stories_rounded,
              ),
              NovelAchievement(label: 'Top 100', icon: Icons.emoji_events_rounded),
              NovelAchievement(label: '20K followers', icon: Icons.groups_rounded),
              NovelAchievement(
                label: 'Rising Star',
                icon: Icons.rocket_launch_rounded,
              ),
              NovelAchievement(
                label: 'Locked',
                icon: Icons.workspace_premium_rounded,
                locked: true,
              ),
            ],
          ),
          const SizedBox(height: 22),

          NovelSectionHeader(title: 'Wait-or-pay unlock (Tapas-style)'),
          const SizedBox(height: 6),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(NovelDimens.radiusLg),
              border: Border.all(color: cs.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: NovelWaitOrPayTile(
              chapterTitle: 'Ch.48 · The Hourglass Turns',
              unlockAt: DateTime.now().add(const Duration(hours: 21)),
              coinCost: 2,
            ),
          ),
          const SizedBox(height: 22),

          NovelSectionHeader(title: 'Latest updates feed (ScribbleHub-style)'),
          const SizedBox(height: 6),
          ...DemoData.books
              .take(3)
              .toList()
              .asMap()
              .entries
              .map(
                (e) => NovelLatestUpdateTile(
                  book: e.value,
                  latestChapterTitle: 'Ch.${120 + e.key} · New dawn',
                  timeLabel: '${e.key + 1}h ago',
                ),
              ),
          const SizedBox(height: 22),

          NovelSectionHeader(title: 'Comments (recovered spec)'),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(NovelDimens.radiusLg),
              border: Border.all(color: cs.border),
            ),
            child: Column(
              children: [
                NovelCommentTile(
                  comment: NovelComment(
                    userName: 'Jerome Bell',
                    content:
                        'Your time is limited, so don’t waste it living someone else’s life.',
                    level: 15,
                    likes: 324,
                    replyCount: 12,
                    timeLabel: '2h',
                  ),
                ),
                Divider(indent: 68, color: cs.border),
                NovelCommentTile(
                  comment: NovelComment(
                    userName: 'Luna',
                    content:
                        'This paragraph gave me chills. The foreshadowing!',
                    level: 8,
                    likes: 87,
                    replyCount: 3,
                    timeLabel: '5h',
                    isParagraphComment: true,
                    chapterLabel: 'Ch. 12',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          NovelSectionHeader(title: 'Review axes'),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: NovelReviewAxes(
              overall: 4.71,
              scores: {
                NovelReviewAxis.writingQuality: 4.8,
                NovelReviewAxis.stabilityOfUpdates: 4.5,
                NovelReviewAxis.storyDevelopment: 4.6,
                NovelReviewAxis.characterDesign: 4.9,
                NovelReviewAxis.worldBackground: 4.4,
              },
            ),
          ),
          const SizedBox(height: 22),

          NovelSectionHeader(title: 'Chapters'),
          const SizedBox(height: 6),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(NovelDimens.radiusLg),
              border: Border.all(color: cs.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                NovelChapterTile(
                  chapter: DemoData.chaptersFor(b)[0],
                  isRead: true,
                ),
                Divider(indent: 20, color: cs.border),
                NovelChapterTile(chapter: ch),
              ],
            ),
          ),
          const SizedBox(height: 22),

          NovelSectionHeader(title: 'Buttons & votes'),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton(onPressed: () {}, child: const Text('Read Now')),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('+ Library'),
                ),
                NovelPowerStoneButton(count: 12400),
                NovelPowerStoneButton(count: 99, voted: true),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
