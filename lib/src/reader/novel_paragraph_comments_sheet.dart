import 'package:flutter/material.dart';

import '../theme/novel_theme.dart';
import '../widgets/novel_comment_tile.dart';

/// Built-in bottom sheet for a paragraph's comment thread — the
/// "paragraph-level interaction" surface the official app ships
/// (recovered from its comment module + `flutter_w_comment_reply_page`).
///
/// ```dart
/// NovelReaderView(
///   paragraphCommentCounts: {3: 12, 7: 2},
///   onParagraphComments: (i) => NovelParagraphCommentsSheet.show(
///     context,
///     paragraphIndex: i,
///     paragraphText: chapter.paragraphs[i],
///     comments: repo.commentsFor(chapterId, i),
///     onSend: (text) => repo.post(chapterId, i, text),
///   ),
/// )
/// ```
class NovelParagraphCommentsSheet {
  NovelParagraphCommentsSheet._();

  static Future<void> show(
    BuildContext context, {
    required int paragraphIndex,
    required String paragraphText,
    List<NovelComment> comments = const [],
    ValueChanged<String>? onSend,
    ValueChanged<String>? onLike,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => _ParagraphCommentsSheet(
        paragraphIndex: paragraphIndex,
        paragraphText: paragraphText,
        comments: comments,
        onSend: onSend,
        onLike: onLike,
      ),
    );
  }
}

class _ParagraphCommentsSheet extends StatefulWidget {
  const _ParagraphCommentsSheet({
    required this.paragraphIndex,
    required this.paragraphText,
    required this.comments,
    this.onSend,
    this.onLike,
  });

  final int paragraphIndex;
  final String paragraphText;
  final List<NovelComment> comments;
  final ValueChanged<String>? onSend;
  final ValueChanged<String>? onLike;

  @override
  State<_ParagraphCommentsSheet> createState() =>
      _ParagraphCommentsSheetState();
}

class _ParagraphCommentsSheetState extends State<_ParagraphCommentsSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend?.call(text);
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final cs = NovelTheme.of(context).colorScheme;
    final strings = NovelTheme.of(context).strings;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.62,
        maxChildSize: 0.88,
        builder: (context, scrollController) => Column(
          children: [
            // ── Header ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.format_quote_rounded,
                        size: 18,
                        color: cs.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        strings.paragraphComments,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: cs.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '#${widget.paragraphIndex + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: cs.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cs.surfaceLow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.paragraphText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: cs.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: cs.border),

            // ── Thread ────────────────────────────────────────────
            Expanded(
              child: widget.comments.isEmpty
                  ? Center(
                      child: Text(
                        strings.commentHint,
                        style: TextStyle(fontSize: 13, color: cs.textTertiary),
                      ),
                    )
                  : ListView.separated(
                      controller: scrollController,
                      itemCount: widget.comments.length,
                      separatorBuilder: (_, _) =>
                          Divider(indent: 68, color: cs.border),
                      itemBuilder: (context, i) =>
                          NovelCommentTile(comment: widget.comments[i]),
                    ),
            ),
            Divider(height: 1, color: cs.border),

            // ── Composer ──────────────────────────────────────────
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _submit(),
                        style: TextStyle(fontSize: 14, color: cs.textPrimary),
                        decoration: InputDecoration(
                          hintText: strings.commentHint,
                          hintStyle: TextStyle(
                            fontSize: 13.5,
                            color: cs.textTertiary,
                          ),
                          filled: true,
                          fillColor: cs.surfaceLow,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filled(
                      onPressed: _submit,
                      icon: const Icon(Icons.send_rounded, size: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
