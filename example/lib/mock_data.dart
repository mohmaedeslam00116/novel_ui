import 'package:novel_ui/novel_ui.dart';

/// Deterministic demo dataset so the example always renders identically.
abstract final class DemoData {
  static const books = <NovelBook>[
    NovelBook(
      id: 'b1',
      title: 'Rebirth of the Golden Emperor',
      author: 'Cloud Daoist',
      tags: ['Eastern Fantasy', 'Cultivation', 'Reincarnation'],
      status: NovelBookStatus.ongoing,
      score: 4.7,
      ratingCount: 128400,
      summary:
          'Betrayed at the peak of his power, Qin Yun swallows the Heaven '
          'Devouring Seed and wakes in his fifteen-year-old body. This time, '
          'the heavens will kneel.',
      wordCount: 4820000,
      collectionCount: 912000,
      viewCount: 38200000,
      category: 'Eastern Fantasy',
    ),
    NovelBook(
      id: 'b2',
      title: 'My Wife Is a Cold-Blooded CEO',
      author: 'Paper Lantern',
      tags: ['Urban Romance', 'Contract Marriage', 'Sweet'],
      status: NovelBookStatus.completed,
      score: 4.3,
      ratingCount: 64200,
      summary:
          'A paper marriage, two strangers and one clause neither of them '
          'read carefully enough: "the marriage is valid until genuine '
          'affection is declared."',
      wordCount: 1240000,
      collectionCount: 340000,
      viewCount: 12400000,
      category: 'Urban Romance',
    ),
    NovelBook(
      id: 'b3',
      title: 'The Dungeon Under My Apartment',
      author: 'Neon Sage',
      tags: ['Sci-fi', 'System', 'Slice of Life'],
      status: NovelBookStatus.ongoing,
      score: 4.5,
      ratingCount: 30100,
      summary:
          'Every midnight the basement door opens onto a new floor of an '
          'endless dungeon — and rent is due whether he survives or not.',
      wordCount: 890000,
      collectionCount: 121000,
      viewCount: 5600000,
      category: 'Sci-fi',
    ),
    NovelBook(
      id: 'b4',
      title: 'Sword Saint Retires at Sixteen',
      author: 'Old Bamboo',
      tags: ['Wuxia', 'Comedy', 'Strong Lead'],
      status: NovelBookStatus.hiatus,
      score: 4.1,
      ratingCount: 18700,
      summary:
          'Having conquered every sect on the continent before finishing '
          'puberty, Yan Shu opens a tea house. Trouble finds the teapot.',
      wordCount: 620000,
      collectionCount: 88000,
      viewCount: 3100000,
      category: 'Wuxia',
    ),
    NovelBook(
      id: 'b5',
      title: 'Level Up With Cooking Skills',
      author: 'Simmer King',
      tags: ['Fantasy', 'Cooking', 'Lighthearted'],
      status: NovelBookStatus.ongoing,
      score: 4.6,
      ratingCount: 44100,
      summary:
          'In a world where adventurers grind for experience points, Ruo '
          'discovers that a perfect bowl of noodles grants more EXP than a '
          'dragon slaying.',
      wordCount: 1530000,
      collectionCount: 210000,
      viewCount: 8900000,
      category: 'Fantasy',
    ),
    NovelBook(
      id: 'b6',
      title: 'Villainess Turns the Hourglass',
      author: 'Midnight Quill',
      tags: ['Historical', 'Rebirth', 'Palace Intrigue'],
      status: NovelBookStatus.ongoing,
      score: 4.8,
      ratingCount: 77600,
      summary:
          'Executed as a villainess, Duchess Elena rewinds to her debutante '
          'ball with every secret of the empire — including the ones about '
          'her own executioner.',
      wordCount: 2180000,
      collectionCount: 502000,
      viewCount: 17600000,
      category: 'Historical',
    ),
  ];

  /// Generates a readable chapter list for demo books.
  static List<NovelChapter> chaptersFor(NovelBook book, {int count = 40}) {
    return List.generate(count, (i) {
      final n = i + 1;
      final locked = n > 12 && n % 4 == 0;
      final vip = n > 20 && n % 7 == 0;
      return NovelChapter(
        id: '${book.id}-ch$n',
        index: n,
        title: _chapterTitle(n),
        isLocked: locked,
        isVip: vip,
        coinCost: locked ? 8 : 0,
        wordCount: 1800 + ((n * 137) % 900),
        paragraphs: _chapterBody(book, n),
      );
    });
  }

  static String _chapterTitle(int n) {
    const patterns = [
      'The Wind Rises Over Azure Peak',
      'A Cup of Poisoned Tea',
      'Nine Steps to Breakthrough',
      'The Letter That Never Arrived',
      'Blood on the Snowy Road',
      'An Old Enemy Returns',
      'Whispers in the Ancestral Hall',
      'One Sword, Ten Thousand Regrets',
      'The Banquet of Broken Masks',
      'Beneath the Paper Lantern',
    ];
    return 'Ch.$n · ${patterns[n % patterns.length]}';
  }

  static List<String> _chapterBody(NovelBook book, int chapter) {
    final lines = <String>[];
    lines.add(
      'Chapter $chapter opened quietly, the way all dangerous days do.',
    );
    for (var p = 0; p < 14; p++) {
      lines.add(
        'The morning mist had not yet lifted from ${book.title} when the first '
        'bell rang across the courtyard. ${book.author} would later swear that '
        'everything that followed began with that single, patient sound — but '
        'truthfully it began much earlier, with a promise made under different '
        'skies and a debt that no amount of cultivation could wash clean.',
      );
      if (p == 5) {
        lines.add('');
        lines.add('“You came back,” someone said from the shadows.');
        lines.add('“I never left,” came the answer.');
      }
      lines.add(
        'By noon three letters had arrived, each carrying a seal that had no '
        'right to exist anymore, and by dusk the courtyard was empty except for '
        'one figure practicing the same sword stroke over and over — not for '
        'perfection, but because stopping would mean remembering.',
      );
    }
    lines.add('And somewhere far away, the hourglass turned once more.');
    return lines;
  }
}
