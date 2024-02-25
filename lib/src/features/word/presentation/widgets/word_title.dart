import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/features/word/presentation/word_page.dart';

/// Заголовок на [WordPage]
@immutable
class WordTitle extends StatelessWidget {
  /// Данные
  final String data;

  /// Действие
  final Widget? action;

  /// Создает заголовок на [WordPage]
  const WordTitle(
    this.data, {
    this.action,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    data,
                    style: context.theme.textTheme.headlineSmall?.copyWith(
                      color: context.theme.isDark
                          ? context.theme.colors.white
                          : context.theme.colors.black,
                    ),
                  ),
                ),
                if (action != null) ...[
                  const SizedBox(width: 12),
                  action!,
                ],
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Divider(indent: 24, endIndent: 24),
          ),
        ],
      );
}
