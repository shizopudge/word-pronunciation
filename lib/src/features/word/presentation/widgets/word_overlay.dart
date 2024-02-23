import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_pronunciation.dart';

@immutable
class WordOverlay extends StatelessWidget {
  /// {@macro word_pronunciation_bloc}
  final WordPronunciationBloc wordPronunciationBloc;

  const WordOverlay({
    required this.wordPronunciationBloc,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<WordPronunciationBloc, WordPronunciationState>(
            bloc: wordPronunciationBloc,
            buildWhen: (previous, current) => current.resultOrNull != null,
            builder: (context, state) {
              final result = state.resultOrNull ?? 'word-pronunciation-result';
              return AnimatedSwitcher(
                duration: Durations.medium1,
                child: Text(
                  result,
                  key: ValueKey<String>(result),
                  textAlign: TextAlign.center,
                  style: context.theme.textTheme.headlineSmall?.copyWith(
                    color: context.theme.isDark
                        ? context.theme.colors.white
                        : context.theme.colors.black,
                  ),
                ),
              );
            },
          ),
        ),
      );
}
