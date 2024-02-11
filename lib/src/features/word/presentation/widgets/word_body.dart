import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/app_kit/app_kit.dart';
import 'package:word_pronunciation/src/features/word/bloc/word.dart';
import 'package:word_pronunciation/src/features/word/di/word_scope.dart';
import 'package:word_pronunciation/src/features/word/presentation/widgets/widgets.dart';

/// Тело [WordView]
@immutable
class WordBody extends StatelessWidget {
  /// Создает тело [WordView]
  const WordBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) => BlocBuilder<WordBloc, WordState>(
        bloc: WordScope.of(context).wordBloc,
        buildWhen: (previous, current) => !current.isError,
        builder: (context, state) => state.map(
          idle: (i) => CustomScrollView(
            slivers: [
              // Карточка слова
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24, left: 32, right: 32),
                  child: WordCard(word: i.word),
                ),
              ),

              if (i.word.nounDefinitions.isNotEmpty) ...[
                // Определения-существительные
                SliverPadding(
                  padding: const EdgeInsets.only(top: 20),
                  sliver: SliverToBoxAdapter(
                    child: DefinitionsView(
                      title: 'Noun Definitions',
                      definitions: i.word.nounDefinitions.toList(),
                    ),
                  ),
                ),
              ],

              if (i.word.verbDefinitions.isNotEmpty) ...[
                // Определения-глаголы
                SliverPadding(
                  padding: const EdgeInsets.only(top: 24),
                  sliver: SliverToBoxAdapter(
                    child: DefinitionsView(
                      title: 'Verb Definitions',
                      definitions: i.word.verbDefinitions.toList(),
                    ),
                  ),
                ),
              ],

              // Отступ снизу
              SliverPadding(
                padding: EdgeInsets.only(
                  bottom: context.mediaQuery.padding.bottom,
                ),
              ),
            ],
          ),
          progress: (p) => const ProgressLayout(),
          error: (e) => Center(
            child: Text(
              e.errorHandler.message(context),
              style: context.theme.textTheme.titleMedium?.copyWith(
                color: context.theme.isDark
                    ? context.theme.colors.white
                    : context.theme.colors.black,
              ),
            ),
          ),
        ),
      );
}
