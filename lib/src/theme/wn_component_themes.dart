import 'package:flutter/material.dart';

import 'dart:ui' show lerpDouble;

/// Per-component theme for [WnBookCard]/[WnBookListTile].
///
/// Every field is nullable: widgets resolve
/// `widget.field ?? theme.bookCardTheme.field ?? built-in default`, so any
/// subset can be overridden app-wide.
@immutable
class WnBookCardTheme extends ThemeExtension<WnBookCardTheme> {
  const WnBookCardTheme({
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
  WnBookCardTheme copyWith({
    double? coverWidth,
    double? coverRadius,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    bool? showStatusBadge,
    double? spacing,
  }) {
    return WnBookCardTheme(
      coverWidth: coverWidth ?? this.coverWidth,
      coverRadius: coverRadius ?? this.coverRadius,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      showStatusBadge: showStatusBadge ?? this.showStatusBadge,
      spacing: spacing ?? this.spacing,
    );
  }

  @override
  WnBookCardTheme lerp(WnBookCardTheme? other, double t) {
    if (other == null) return this;
    return WnBookCardTheme(
      coverWidth: lerpDouble(coverWidth, other.coverWidth, t),
      coverRadius: lerpDouble(coverRadius, other.coverRadius, t),
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      subtitleStyle: TextStyle.lerp(subtitleStyle, other.subtitleStyle, t),
      showStatusBadge: t < 0.5 ? showStatusBadge : other.showStatusBadge,
      spacing: lerpDouble(spacing, other.spacing, t),
    );
  }
}

/// Per-component theme for [WnChapterTile].
@immutable
class WnChapterTileTheme extends ThemeExtension<WnChapterTileTheme> {
  const WnChapterTileTheme({
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

  /// Style applied when [WnChapterTile.isRead] is true.
  final TextStyle? readTitleStyle;
  final TextStyle? metaStyle;
  final bool? showWordCount;

  @override
  WnChapterTileTheme copyWith({
    double? horizontalPadding,
    double? verticalPadding,
    TextStyle? titleStyle,
    TextStyle? readTitleStyle,
    TextStyle? metaStyle,
    bool? showWordCount,
  }) {
    return WnChapterTileTheme(
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
      titleStyle: titleStyle ?? this.titleStyle,
      readTitleStyle: readTitleStyle ?? this.readTitleStyle,
      metaStyle: metaStyle ?? this.metaStyle,
      showWordCount: showWordCount ?? this.showWordCount,
    );
  }

  @override
  WnChapterTileTheme lerp(WnChapterTileTheme? other, double t) {
    if (other == null) return this;
    return WnChapterTileTheme(
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

/// Per-component theme for [WnCommentTile].
@immutable
class WnCommentTileTheme extends ThemeExtension<WnCommentTileTheme> {
  const WnCommentTileTheme({
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
  WnCommentTileTheme copyWith({
    double? avatarSize,
    TextStyle? nameStyle,
    TextStyle? contentStyle,
    TextStyle? metaStyle,
    double? horizontalPadding,
  }) {
    return WnCommentTileTheme(
      avatarSize: avatarSize ?? this.avatarSize,
      nameStyle: nameStyle ?? this.nameStyle,
      contentStyle: contentStyle ?? this.contentStyle,
      metaStyle: metaStyle ?? this.metaStyle,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
    );
  }

  @override
  WnCommentTileTheme lerp(WnCommentTileTheme? other, double t) {
    if (other == null) return this;
    return WnCommentTileTheme(
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

/// Per-component theme for [WnRankListItem].
@immutable
class WnRankListItemTheme extends ThemeExtension<WnRankListItemTheme> {
  const WnRankListItemTheme({
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
  WnRankListItemTheme copyWith({
    double? rankWidth,
    List<Color>? topThreeColors,
    Color? topTenColor,
    Color? plainColor,
    double? coverWidth,
  }) {
    return WnRankListItemTheme(
      rankWidth: rankWidth ?? this.rankWidth,
      topThreeColors: topThreeColors ?? this.topThreeColors,
      topTenColor: topTenColor ?? this.topTenColor,
      plainColor: plainColor ?? this.plainColor,
      coverWidth: coverWidth ?? this.coverWidth,
    );
  }

  @override
  WnRankListItemTheme lerp(WnRankListItemTheme? other, double t) {
    if (other == null) return this;
    return WnRankListItemTheme(
      rankWidth: lerpDouble(rankWidth, other.rankWidth, t),
      topThreeColors: t < 0.5 ? topThreeColors : other.topThreeColors,
      topTenColor: Color.lerp(topTenColor, other.topTenColor, t),
      plainColor: Color.lerp(plainColor, other.plainColor, t),
      coverWidth: lerpDouble(coverWidth, other.coverWidth, t),
    );
  }
}

/// Per-component theme for [WnSectionHeader].
@immutable
class WnSectionHeaderTheme extends ThemeExtension<WnSectionHeaderTheme> {
  const WnSectionHeaderTheme({
    this.titleStyle,
    this.seeAllStyle,
    this.horizontalPadding,
  });

  final TextStyle? titleStyle;
  final TextStyle? seeAllStyle;
  final double? horizontalPadding;

  @override
  WnSectionHeaderTheme copyWith({
    TextStyle? titleStyle,
    TextStyle? seeAllStyle,
    double? horizontalPadding,
  }) {
    return WnSectionHeaderTheme(
      titleStyle: titleStyle ?? this.titleStyle,
      seeAllStyle: seeAllStyle ?? this.seeAllStyle,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
    );
  }

  @override
  WnSectionHeaderTheme lerp(WnSectionHeaderTheme? other, double t) {
    if (other == null) return this;
    return WnSectionHeaderTheme(
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

/// Bundle of all per-component themes carried on [WnThemeData].
@immutable
class WnComponentsTheme {
  const WnComponentsTheme({
    this.bookCard = const WnBookCardTheme(),
    this.chapterTile = const WnChapterTileTheme(),
    this.commentTile = const WnCommentTileTheme(),
    this.rankListItem = const WnRankListItemTheme(),
    this.sectionHeader = const WnSectionHeaderTheme(),
  });

  final WnBookCardTheme bookCard;
  final WnChapterTileTheme chapterTile;
  final WnCommentTileTheme commentTile;
  final WnRankListItemTheme rankListItem;
  final WnSectionHeaderTheme sectionHeader;

  WnComponentsTheme copyWith({
    WnBookCardTheme? bookCard,
    WnChapterTileTheme? chapterTile,
    WnCommentTileTheme? commentTile,
    WnRankListItemTheme? rankListItem,
    WnSectionHeaderTheme? sectionHeader,
  }) {
    return WnComponentsTheme(
      bookCard: bookCard ?? this.bookCard,
      chapterTile: chapterTile ?? this.chapterTile,
      commentTile: commentTile ?? this.commentTile,
      rankListItem: rankListItem ?? this.rankListItem,
      sectionHeader: sectionHeader ?? this.sectionHeader,
    );
  }

  static WnComponentsTheme lerp(
    WnComponentsTheme a,
    WnComponentsTheme b,
    double t,
  ) {
    return WnComponentsTheme(
      bookCard: a.bookCard.lerp(b.bookCard, t),
      chapterTile: a.chapterTile.lerp(b.chapterTile, t),
      commentTile: a.commentTile.lerp(b.commentTile, t),
      rankListItem: a.rankListItem.lerp(b.rankListItem, t),
      sectionHeader: a.sectionHeader.lerp(b.sectionHeader, t),
    );
  }
}
