import 'package:flutter/material.dart';

import '../tokens/wn_dimens.dart';
import '../theme/wn_theme.dart';

/// Section header with title, optional subtitle and a "See all" action —
/// the standard way novel apps open a content block.
class WnSectionHeader extends StatelessWidget {
  const WnSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onSeeAll,
    this.seeAllLabel,
    this.leading,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;
  final String? seeAllLabel;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final cs = WnTheme.of(context).colorScheme;
    final t = WnTheme.of(context).components.sectionHeader;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: t.horizontalPadding ?? WnDimens.screenPadding,
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: WnDimens.sm),
          ],
          Expanded(
            child: Text(
              title,
              style:
                  t.titleStyle ??
                  TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: cs.textPrimary,
                  ),
            ),
          ),
          if (subtitle != null) ...[
            Text(
              subtitle!,
              style: TextStyle(fontSize: 12, color: cs.textTertiary),
            ),
            const SizedBox(width: WnDimens.sm),
          ],
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    seeAllLabel ?? WnTheme.of(context).strings.seeAll,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: cs.primary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
