import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:novel_ui/novel_ui.dart';

/// Light/dark × LTR/RTL scenario matrix used by every golden test.
GoldenTestGroup wnMatrix({
  required Widget Function(NovelThemeData theme) builder,
}) {
  final themes = {'light': NovelThemeData.light(), 'dark': NovelThemeData.dark()};
  return GoldenTestGroup(
    columns: 2,
    children: [
      for (final entry in themes.entries)
        for (final rtl in {false, true})
          GoldenTestScenario(
            name: '${entry.key}${rtl ? '/rtl' : ''}',
            child: SizedBox(
              width: 320,
              child: Directionality(
                textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
                child: NovelTheme(
                  data: entry.value,
                  child: Material(
                    color: entry.value.colorScheme.background,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: builder(entry.value),
                    ),
                  ),
                ),
              ),
            ),
          ),
    ],
  );
}

/// Deterministic demo book for goldens.
const fakeBook = NovelBook(
  id: 'golden',
  title: 'Rebirth of the Golden Emperor',
  author: 'Cloud Daoist',
  score: 4.5,
  tags: ['Eastern Fantasy', 'Cultivation'],
);
