import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/features/word/data/model/local_word.dart';
import 'package:word_pronunciation/src/features/word/scope/word_scope.dart';

/// Плитка списка истории слов
@immutable
class WordHistoryTile extends StatelessWidget {
  /// Слово
  final LocalWord word;

  /// Индекс
  final int index;

  /// Создает плитку списка истории слов
  const WordHistoryTile({
    required this.word,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) => HoldConsumer(
        builder: (context, isHeldDown) => AnimatedScale(
          duration: Durations.short4,
          scale: isHeldDown ? 0.96 : 1.0,
          child: InkWell(
            onTap: () =>
                WordScope.of(context).state.readFromDictionary(word.data),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    '$index.',
                    style: context.theme.textTheme.bodyLarge?.copyWith(
                      color: context.theme.isDark
                          ? context.theme.colors.white
                          : context.theme.colors.black,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        word.data,
                        textAlign: TextAlign.center,
                        style: context.theme.textTheme.bodyLarge?.copyWith(
                          color: context.theme.isDark
                              ? context.theme.colors.white
                              : context.theme.colors.black,
                        ),
                      ),
                    ),
                  ),
                  if (word.pronounced) ...[
                    Icon(
                      Icons.check,
                      size: 20,
                      color: context.theme.colors.blue,
                    ),
                  ] else ...[
                    Icon(
                      Icons.error_outline_rounded,
                      size: 20,
                      color: context.theme.colors.red,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
}
