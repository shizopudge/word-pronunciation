import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/core/utils/utils.dart';
import 'package:word_pronunciation/src/features/word/data/model/definition.dart';

@immutable
class DefinitionSheet extends StatelessWidget {
  /// Определение
  final Definition definition;

  /// Шит с определением
  const DefinitionSheet._({
    required this.definition,
  });

  static Future<void> show(
    BuildContext context, {
    required Definition definition,
  }) =>
      showPrimaryBottomSheet<void>(
        context: context,
        title: context.localization.definition,
        builder: (context) => DefinitionSheet._(definition: definition),
      );

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16) +
            EdgeInsets.only(
              bottom: context.mediaQuery.padding.bottom,
            ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => CopyUtil.copy(context, text: definition.data),
              behavior: HitTestBehavior.opaque,
              child: Text(
                definition.data,
                style: context.theme.textTheme.titleMedium?.copyWith(
                  color: context.theme.isDark
                      ? context.theme.colors.white
                      : context.theme.colors.black,
                ),
              ),
            ),
            if (definition.example.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  context.localization.example,
                  style: context.theme.textTheme.titleSmall?.copyWith(
                    color: context.theme.isDark
                        ? context.theme.colors.white
                        : context.theme.colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: GestureDetector(
                  onTap: () => CopyUtil.copy(context, text: definition.example),
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    definition.example,
                    style: context.theme.textTheme.bodyMedium?.copyWith(
                      color: context.theme.isDark
                          ? context.theme.colors.white
                          : context.theme.colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
}
