import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
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
        builder: (context, isHeldDown) => AnimatedScale(
          scale: isHeldDown ? 0.95 : 1.0,
          duration: Durations.short3,
          child: InkWell(
            onTap: _onTap,
            borderRadius: BorderRadius.circular(8),
            child: Ink(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.theme.isDark
                      ? context.theme.colors.white
                      : context.theme.colors.black,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
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

  /// Обработчик нажатия
  Future<void> _onTap() => Future<void>.value();
}
