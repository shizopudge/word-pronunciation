import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';

/// Заголовок на [WordPage]
@immutable
class WordTitle extends StatelessWidget {
  /// Данные
  final String data;

  /// Создает заголовок на [WordPage]
  const WordTitle(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              data,
              style: context.theme.textTheme.headlineSmall?.copyWith(
                color: context.theme.isDark
                    ? context.theme.colors.white
                    : context.theme.colors.black,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Divider(indent: 24, endIndent: 24),
          ),
        ],
      );
}
