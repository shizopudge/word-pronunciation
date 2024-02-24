import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_pronunciation.dart';
import 'package:word_pronunciation/src/features/word/presentation/widgets/audio_animation.dart';

/// Оверлей с словом
@immutable
class WordOverlay extends StatelessWidget {
  /// {@macro word_pronunciation_bloc}
  final WordPronunciationBloc wordPronunciationBloc;

  /// Создает оверлей с словом
  const WordOverlay({
    required this.wordPronunciationBloc,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: BlocBuilder<WordPronunciationBloc, WordPronunciationState>(
            bloc: wordPronunciationBloc,
            buildWhen: (previous, current) => current.isProcessing,
            builder: (context, state) {
              late final Widget child;
              final word = state.resultOrNull?.toUpperCase();
              final key = state.resultOrNull ?? 'word-pronunciation-result';

              if (word == null || word.isEmpty) {
                child =
                    AudioAnimation(color: context.theme.colors.blue, size: 120);
              } else {
                child = _Word(
                  key: ValueKey<String>(key),
                  data: word,
                  color: _wordColor(context, state: state),
                );
              }

              return AnimatedSwitcher(
                duration: Durations.short4,
                child: child,
              );
            },
          ),
        ),
      );

  /// Цвет слова
  Color _wordColor(
    BuildContext context, {
    required WordPronunciationState state,
  }) {
    if (state.isRight) {
      return context.theme.colors.blue;
    } else if (state.isIncorrect) {
      return context.theme.colors.red;
    } else {
      return context.theme.isDark
          ? context.theme.colors.white
          : context.theme.colors.black;
    }
  }
}

/// Слово
@immutable
class _Word extends StatelessWidget {
  /// Данные
  final String data;

  /// Цвет
  final Color color;

  /// Создает слово
  const _Word({
    required this.data,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Text(
        data,
        textAlign: TextAlign.center,
        style: context.theme.textTheme.headlineLarge?.copyWith(
          color: color,
          fontSize: 36,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: context.theme.colors.black.withOpacity(.04),
              offset: const Offset(0, .5),
            ),
            Shadow(
              color: context.theme.colors.black.withOpacity(.05),
              offset: const Offset(0, 1),
              blurRadius: 1,
            ),
            Shadow(
              color: context.theme.colors.black.withOpacity(.06),
              offset: const Offset(0, 1.5),
              blurRadius: 2,
            ),
          ],
        ),
      );
}
