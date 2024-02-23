import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/features/word/presentation/word_page.dart';

/// Виджет отображающий error состояние [WordPage]
@immutable
class WordErrorLayout extends StatelessWidget {
  /// Сообщение
  final String message;

  /// Создает виджет отображающий error состояние [WordPage]
  const WordErrorLayout({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: Text(
          message,
          style: context.theme.textTheme.titleMedium?.copyWith(
            color: context.theme.isDark
                ? context.theme.colors.white
                : context.theme.colors.black,
          ),
        ),
      );
}
