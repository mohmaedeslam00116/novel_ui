import 'package:flutter/material.dart';

/// All user-facing labels used by wn_design widgets.
///
/// Widgets read from `WnTheme.of(context).strings`, so switching language
/// is one line — no codegen, no delegate:
///
/// ```dart
/// WnThemeData.light().copyWith(strings: WnStrings.ar())
/// ```
@immutable
class WnStrings {
  const WnStrings({
    this.seeAll = 'See all',
    this.resume = 'Resume',
    this.ongoing = 'Ongoing',
    this.completed = 'Completed',
    this.hiatus = 'Hiatus',
    this.searchHint = 'Search novels',
    this.expand = 'Expand',
    this.collapse = 'Collapse',
    this.readNow = 'Read Now',
    this.addToLibrary = 'Library',
    this.added = 'Added',
    this.lockedChapter = 'Locked Chapter',
    this.unlock = 'Unlock',
    this.maybeLater = 'Maybe later',
    this.balance = 'Balance',
    this.coins = 'coins',
    this.unlockToRead = 'Unlock to read',
    this.catalog = 'Catalog',
    this.settings = 'Settings',
    this.scrollMode = 'Scroll',
    this.pageMode = 'Page',
    this.day = 'Day',
    this.night = 'Night',
    this.previous = 'Previous',
    this.nextChapter = 'Next chapter',
    this.send = 'Send',
    this.commentHint = 'Say something…',
    this.paragraphComments = 'Paragraph comments',
    this.listen = 'Listen',
    this.white = 'White',
    this.parchment = 'Parchment',
    this.mint = 'Mint',
    this.gray = 'Gray',
    this.kraft = 'Kraft',
    this.views = 'views',
    this.chapters = 'chapters',
    this.words = 'Words',
    this.collections = 'Collections',
    this.ratings = 'ratings',
    this.outOf5 = 'out of 5',
  });

  /// English (default).
  static WnStrings en() => const WnStrings();

  /// Arabic — complete right-to-left preset.
  static WnStrings ar() => const WnStrings(
    seeAll: 'الكل',
    resume: 'متابعة',
    ongoing: 'مستمرة',
    completed: 'مكتملة',
    hiatus: 'متوقفة',
    searchHint: 'ابحث عن رواية',
    expand: 'المزيد',
    collapse: 'إخفاء',
    readNow: 'اقرأ الآن',
    addToLibrary: 'المكتبة',
    added: 'أُضيفت',
    lockedChapter: 'فصل مقفل',
    unlock: 'فتح',
    maybeLater: 'لاحقاً',
    balance: 'الرصيد',
    coins: 'عملة',
    unlockToRead: 'افتح الفصل للقراءة',
    catalog: 'الفهرس',
    settings: 'الإعدادات',
    scrollMode: 'تمرير',
    pageMode: 'صفحات',
    day: 'نهار',
    night: 'ليل',
    previous: 'السابق',
    nextChapter: 'الفصل التالي',
    send: 'إرسال',
    commentHint: 'اكتب تعليقاً…',
    paragraphComments: 'تعليقات الفقرة',
    white: 'أبيض',
    parchment: 'ورقي',
    mint: 'نعناعي',
    gray: 'رمادي',
    kraft: 'كرافت',
    views: 'مشاهدة',
    chapters: 'فصل',
    words: 'كلمة',
    collections: 'مجموعة',
    ratings: 'تقييم',
    outOf5: 'من 5',
  );

  final String seeAll;
  final String resume;
  final String ongoing;
  final String completed;
  final String hiatus;
  final String searchHint;
  final String expand;
  final String collapse;
  final String readNow;
  final String addToLibrary;
  final String added;
  final String lockedChapter;
  final String unlock;
  final String maybeLater;
  final String balance;
  final String coins;
  final String unlockToRead;
  final String catalog;
  final String settings;
  final String scrollMode;
  final String pageMode;
  final String day;
  final String night;
  final String previous;
  final String nextChapter;
  final String send;
  final String commentHint;
  final String paragraphComments;

  /// TTS listening screen title.
  final String listen;
  final String white;
  final String parchment;
  final String mint;
  final String gray;
  final String kraft;
  final String views;
  final String chapters;
  final String words;
  final String collections;
  final String ratings;
  final String outOf5;

  WnStrings copyWith({
    String? seeAll,
    String? resume,
    String? ongoing,
    String? completed,
    String? hiatus,
    String? searchHint,
    String? expand,
    String? collapse,
    String? readNow,
    String? addToLibrary,
    String? added,
    String? lockedChapter,
    String? unlock,
    String? maybeLater,
    String? balance,
    String? coins,
    String? unlockToRead,
    String? catalog,
    String? settings,
    String? scrollMode,
    String? pageMode,
    String? day,
    String? night,
    String? previous,
    String? nextChapter,
    String? send,
    String? commentHint,
    String? paragraphComments,
    String? listen,
    String? white,
    String? parchment,
    String? mint,
    String? gray,
    String? kraft,
    String? views,
    String? chapters,
    String? words,
    String? collections,
    String? ratings,
    String? outOf5,
  }) {
    return WnStrings(
      seeAll: seeAll ?? this.seeAll,
      resume: resume ?? this.resume,
      ongoing: ongoing ?? this.ongoing,
      completed: completed ?? this.completed,
      hiatus: hiatus ?? this.hiatus,
      searchHint: searchHint ?? this.searchHint,
      expand: expand ?? this.expand,
      collapse: collapse ?? this.collapse,
      readNow: readNow ?? this.readNow,
      addToLibrary: addToLibrary ?? this.addToLibrary,
      added: added ?? this.added,
      lockedChapter: lockedChapter ?? this.lockedChapter,
      unlock: unlock ?? this.unlock,
      maybeLater: maybeLater ?? this.maybeLater,
      balance: balance ?? this.balance,
      coins: coins ?? this.coins,
      unlockToRead: unlockToRead ?? this.unlockToRead,
      catalog: catalog ?? this.catalog,
      settings: settings ?? this.settings,
      scrollMode: scrollMode ?? this.scrollMode,
      pageMode: pageMode ?? this.pageMode,
      day: day ?? this.day,
      night: night ?? this.night,
      previous: previous ?? this.previous,
      nextChapter: nextChapter ?? this.nextChapter,
      send: send ?? this.send,
      commentHint: commentHint ?? this.commentHint,
      paragraphComments: paragraphComments ?? this.paragraphComments,
      listen: listen ?? this.listen,
      white: white ?? this.white,
      parchment: parchment ?? this.parchment,
      mint: mint ?? this.mint,
      gray: gray ?? this.gray,
      kraft: kraft ?? this.kraft,
      views: views ?? this.views,
      chapters: chapters ?? this.chapters,
      words: words ?? this.words,
      collections: collections ?? this.collections,
      ratings: ratings ?? this.ratings,
      outOf5: outOf5 ?? this.outOf5,
    );
  }

  static WnStrings lerp(WnStrings a, WnStrings b, double t) => t < 0.5 ? a : b;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WnStrings && runtimeType == other.runtimeType;

  @override
  int get hashCode => Object.hash(
    seeAll,
    resume,
    ongoing,
    completed,
    searchHint,
    unlock,
    catalog,
  );
}
