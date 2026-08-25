import 'package:flutter/material.dart';

import 'dart:ui' show lerpDouble;

/// Per-component theme for [NovelBookCard]/[NovelBookListTile].
///
/// Every field is nullable: widgets resolve
/// `widget.field ?? theme.bookCardTheme.field ?? built-in default`, so any
/// subset can be overridden app-wide.
@immutable
class NovelBookCardTheme extends ThemeExtension<NovelBookCardTheme> {
  const NovelBookCardTheme({
    this.coverWidth,
    this.coverRadius,
    this.titleStyle,
    this.subtitleStyle,
    this.showStatusBadge,
    this.spacing,
  });

  /// Cover width for grid cards.
  final double? coverWidth;
  final double? coverRadius;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool? showStatusBadge;

  /// Gap between cover and text block.
  final double? spacing;

  @override
  NovelBookCardTheme copyWith({
    double? coverWidth,
    double? coverRadius,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    bool? showStatusBadge,
    double? spacing,
  }) {
    return NovelBookCardTheme(
      coverWidth: coverWidth ?? this.coverWidth,
      coverRadius: coverRadius ?? this.coverRadius,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      showStatusBadge: showStatusBadge ?? this.showStatusBadge,
      spacing: spacing ?? this.spacing,
    );
  }

  @override
  NovelBookCardTheme lerp(NovelBookCardTheme? other, double t) {
    if (other == null) return this;
    return NovelBookCardTheme(
      coverWidth: lerpDouble(coverWidth, other.coverWidth, t),
      coverRadius: lerpDouble(coverRadius, other.coverRadius, t),
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      subtitleStyle: TextStyle.lerp(subtitleStyle, other.subtitleStyle, t),
      showStatusBadge: t < 0.5 ? showStatusBadge : other.showStatusBadge,
      spacing: lerpDouble(spacing, other.spacing, t),
    );
  }
}

/// Per-component theme for [NovelChapterTile].
@immutable
class NovelChapterTileTheme extends ThemeExtension<NovelChapterTileTheme> {
  const NovelChapterTileTheme({
    this.horizontalPadding,
    this.verticalPadding,
    this.titleStyle,
    this.readTitleStyle,
    this.metaStyle,
    this.showWordCount,
  });

  final double? horizontalPadding;
  final double? verticalPadding;
  final TextStyle? titleStyle;

  /// Style applied when [NovelChapterTile.isRead] is true.
  final TextStyle? readTitleStyle;
  final TextStyle? metaStyle;
  final bool? showWordCount;

  @override
  NovelChapterTileTheme copyWith({
    double? horizontalPadding,
    double? verticalPadding,
    TextStyle? titleStyle,
    TextStyle? readTitleStyle,
    TextStyle? metaStyle,
    bool? showWordCount,
  }) {
    return NovelChapterTileTheme(
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
      titleStyle: titleStyle ?? this.titleStyle,
      readTitleStyle: readTitleStyle ?? this.readTitleStyle,
      metaStyle: metaStyle ?? this.metaStyle,
      showWordCount: showWordCount ?? this.showWordCount,
    );
  }

  @override
  NovelChapterTileTheme lerp(NovelChapterTileTheme? other, double t) {
    if (other == null) return this;
    return NovelChapterTileTheme(
      horizontalPadding: lerpDouble(
        horizontalPadding,
        other.horizontalPadding,
        t,
      ),
      verticalPadding: lerpDouble(verticalPadding, other.verticalPadding, t),
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      readTitleStyle: TextStyle.lerp(readTitleStyle, other.readTitleStyle, t),
      metaStyle: TextStyle.lerp(metaStyle, other.metaStyle, t),
      showWordCount: t < 0.5 ? showWordCount : other.showWordCount,
    );
  }
}

/// Per-component theme for [NovelCommentTile].
@immutable
class NovelCommentTileTheme extends ThemeExtension<NovelCommentTileTheme> {
  const NovelCommentTileTheme({
    this.avatarSize,
    this.nameStyle,
    this.contentStyle,
    this.metaStyle,
    this.horizontalPadding,
  });

  final double? avatarSize;
  final TextStyle? nameStyle;
  final TextStyle? contentStyle;
  final TextStyle? metaStyle;
  final double? horizontalPadding;

  @override
  NovelCommentTileTheme copyWith({
    double? avatarSize,
    TextStyle? nameStyle,
    TextStyle? contentStyle,
    TextStyle? metaStyle,
    double? horizontalPadding,
  }) {
    return NovelCommentTileTheme(
      avatarSize: avatarSize ?? this.avatarSize,
      nameStyle: nameStyle ?? this.nameStyle,
      contentStyle: contentStyle ?? this.contentStyle,
      metaStyle: metaStyle ?? this.metaStyle,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
    );
  }

  @override
  NovelCommentTileTheme lerp(NovelCommentTileTheme? other, double t) {
    if (other == null) return this;
    return NovelCommentTileTheme(
      avatarSize: lerpDouble(avatarSize, other.avatarSize, t),
      nameStyle: TextStyle.lerp(nameStyle, other.nameStyle, t),
      contentStyle: TextStyle.lerp(contentStyle, other.contentStyle, t),
      metaStyle: TextStyle.lerp(metaStyle, other.metaStyle, t),
      horizontalPadding: lerpDouble(
        horizontalPadding,
        other.horizontalPadding,
        t,
      ),
    );
  }
}

/// Per-component theme for [NovelRankListItem].
@immutable
class NovelRankListItemTheme extends ThemeExtension<NovelRankListItemTheme> {
  const NovelRankListItemTheme({
    this.rankWidth,
    this.topThreeColors,
    this.topTenColor,
    this.plainColor,
    this.coverWidth,
  });

  final double? rankWidth;

  /// Medal colors for ranks 1/2/3 (default: red/orange/green tiers).
  final List<Color>? topThreeColors;

  /// Color for ranks 4–10.
  final Color? topTenColor;
  final Color? plainColor;
  final double? coverWidth;

  @override
  NovelRankListItemTheme copyWith({
    double? rankWidth,
    List<Color>? topThreeColors,
    Color? topTenColor,
    Color? plainColor,
    double? coverWidth,
  }) {
    return NovelRankListItemTheme(
      rankWidth: rankWidth ?? this.rankWidth,
      topThreeColors: topThreeColors ?? this.topThreeColors,
      topTenColor: topTenColor ?? this.topTenColor,
      plainColor: plainColor ?? this.plainColor,
      coverWidth: coverWidth ?? this.coverWidth,
    );
  }

  @override
  NovelRankListItemTheme lerp(NovelRankListItemTheme? other, double t) {
    if (other == null) return this;
    return NovelRankListItemTheme(
      rankWidth: lerpDouble(rankWidth, other.rankWidth, t),
      topThreeColors: t < 0.5 ? topThreeColors : other.topThreeColors,
      topTenColor: Color.lerp(topTenColor, other.topTenColor, t),
      plainColor: Color.lerp(plainColor, other.plainColor, t),
      coverWidth: lerpDouble(coverWidth, other.coverWidth, t),
    );
  }
}

/// Per-component theme for [NovelSectionHeader].
@immutable
class NovelSectionHeaderTheme extends ThemeExtension<NovelSectionHeaderTheme> {
  const NovelSectionHeaderTheme({
    this.titleStyle,
    this.seeAllStyle,
    this.horizontalPadding,
  });

  final TextStyle? titleStyle;
  final TextStyle? seeAllStyle;
  final double? horizontalPadding;

  @override
  NovelSectionHeaderTheme copyWith({
    TextStyle? titleStyle,
    TextStyle? seeAllStyle,
    double? horizontalPadding,
  }) {
    return NovelSectionHeaderTheme(
      titleStyle: titleStyle ?? this.titleStyle,
      seeAllStyle: seeAllStyle ?? this.seeAllStyle,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
    );
  }

  @override
  NovelSectionHeaderTheme lerp(NovelSectionHeaderTheme? other, double t) {
    if (other == null) return this;
    return NovelSectionHeaderTheme(
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      seeAllStyle: TextStyle.lerp(seeAllStyle, other.seeAllStyle, t),
      horizontalPadding: lerpDouble(
        horizontalPadding,
        other.horizontalPadding,
        t,
      ),
    );
  }
}

/// Bundle of all per-component themes carried on [NovelThemeData].
@immutable
class NovelComponentsTheme {
  const NovelComponentsTheme({
    this.bookCard = const NovelBookCardTheme(),
    this.chapterTile = const NovelChapterTileTheme(),
    this.commentTile = const NovelCommentTileTheme(),
    this.rankListItem = const NovelRankListItemTheme(),
    this.sectionHeader = const NovelSectionHeaderTheme(),
  });

  final NovelBookCardTheme bookCard;
  final NovelChapterTileTheme chapterTile;
  final NovelCommentTileTheme commentTile;
  final NovelRankListItemTheme rankListItem;
  final NovelSectionHeaderTheme sectionHeader;

  NovelComponentsTheme copyWith({
    NovelBookCardTheme? bookCard,
    NovelChapterTileTheme? chapterTile,
    NovelCommentTileTheme? commentTile,
    NovelRankListItemTheme? rankListItem,
    NovelSectionHeaderTheme? sectionHeader,
  }) {
    return NovelComponentsTheme(
      bookCard: bookCard ?? this.bookCard,
      chapterTile: chapterTile ?? this.chapterTile,
      commentTile: commentTile ?? this.commentTile,
      rankListItem: rankListItem ?? this.rankListItem,
      sectionHeader: sectionHeader ?? this.sectionHeader,
    );
  }

  static NovelComponentsTheme lerp(
    NovelComponentsTheme a,
    NovelComponentsTheme b,
    double t,
  ) {
    return NovelComponentsTheme(
      bookCard: a.bookCard.lerp(b.bookCard, t),
      chapterTile: a.chapterTile.lerp(b.chapterTile, t),
      commentTile: a.commentTile.lerp(b.commentTile, t),
      rankListItem: a.rankListItem.lerp(b.rankListItem, t),
      sectionHeader: a.sectionHeader.lerp(b.sectionHeader, t),
    );
  }
}
