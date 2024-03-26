import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/core/utils/src/copy_util.dart';
import 'package:word_pronunciation/src/features/word/data/model/word.dart';

/// Карточка с словом
@immutable
class WordCard extends StatelessWidget {
  /// Слово
  final Word word;

  /// Создает карточку с словом
  const WordCard({
    required this.word,
    super.key,
  });

  @override
  Widget build(BuildContext context) => HoldConsumer(
        listener: (isHeldDown) {
          if (isHeldDown) {
            CopyUtil.copy(context, text: word.data);
          }
        },
        builder: (context, isHeldDown) => AnimatedScale(
          scale: isHeldDown ? 0.96 : 1.0,
          duration: Durations.short3,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.5,
                color: context.theme.colors.blue,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                word.data,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: context.theme.textTheme.headlineLarge?.copyWith(
                  color: context.theme.isDark
                      ? context.theme.colors.white
                      : context.theme.colors.black,
                ),
              ),
            ),
          ),
        ),
      );
}
