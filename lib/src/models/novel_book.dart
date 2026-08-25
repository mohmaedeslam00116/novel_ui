/// Publication status of a novel.
enum NovelBookStatus {
  /// Still releasing chapters.
  ongoing,

  /// Finished.
  completed,

  /// On hiatus.
  hiatus,
}

/// A single chapter of a novel.
final class NovelChapter {
  const NovelChapter({
    required this.id,
    required this.index,
    required this.title,
    this.isLocked = false,
    this.isVip = false,
    this.coinCost = 0,
    this.wordCount = 0,
    this.paragraphs = const [],
  });

  final String id;

  /// 1-based position inside the book's table of contents.
  final int index;
  final String title;

  /// Whether the chapter requires unlocking before reading.
  final bool isLocked;

  /// VIP chapters are marked with a crown badge.
  final bool isVip;

  /// Cost in coins to unlock, if [isLocked].
  final int coinCost;
  final int wordCount;

  /// Chapter body split into paragraphs. Empty for locked chapters.
  final List<String> paragraphs;

  NovelChapter copyWith({
    String? id,
    int? index,
    String? title,
    bool? isLocked,
    bool? isVip,
    int? coinCost,
    int? wordCount,
    List<String>? paragraphs,
  }) {
    return NovelChapter(
      id: id ?? this.id,
      index: index ?? this.index,
      title: title ?? this.title,
      isLocked: isLocked ?? this.isLocked,
      isVip: isVip ?? this.isVip,
      coinCost: coinCost ?? this.coinCost,
      wordCount: wordCount ?? this.wordCount,
      paragraphs: paragraphs ?? this.paragraphs,
    );
  }
}

/// The core domain object every novel_ui book widget renders.
///
/// Widgets only read display data from it, so you can map your own
/// repository entities onto it freely.
class NovelBook {
  const NovelBook({
    required this.id,
    required this.title,
    required this.author,
    this.coverUrl,
    this.tags = const [],
    this.status = NovelBookStatus.ongoing,
    this.score = 0,
    this.ratingCount = 0,
    this.summary = '',
    this.wordCount = 0,
    this.collectionCount = 0,
    this.viewCount = 0,
    this.lastUpdated,
    this.category,
    this.translationStatus,
  });

  final String id;
  final String title;
  final String author;

  /// Remote cover image. When null, widgets render a deterministic
  /// generated gradient cover derived from [title].
  final String? coverUrl;
  final List<String> tags;
  final NovelBookStatus status;

  /// Rating out of 5.
  final double score;
  final int ratingCount;
  final String summary;
  final int wordCount;
  final int collectionCount;
  final int viewCount;
  final DateTime? lastUpdated;

  /// Genre category shown above the title on detail pages
  /// (e.g. "Eastern Fantasy").
  final String? category;

  /// e.g. "Translated", "Original".
  final String? translationStatus;

  NovelBook copyWith({
    String? id,
    String? title,
    String? author,
    String? coverUrl,
    List<String>? tags,
    NovelBookStatus? status,
    double? score,
    int? ratingCount,
    String? summary,
    int? wordCount,
    int? collectionCount,
    int? viewCount,
    DateTime? lastUpdated,
    String? category,
    String? translationStatus,
  }) {
    return NovelBook(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      coverUrl: coverUrl ?? this.coverUrl,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      score: score ?? this.score,
      ratingCount: ratingCount ?? this.ratingCount,
      summary: summary ?? this.summary,
      wordCount: wordCount ?? this.wordCount,
      collectionCount: collectionCount ?? this.collectionCount,
      viewCount: viewCount ?? this.viewCount,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      category: category ?? this.category,
      translationStatus: translationStatus ?? this.translationStatus,
    );
  }
}
