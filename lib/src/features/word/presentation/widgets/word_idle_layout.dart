import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/features/app_settings/presentation/app_settings_page.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_pronunciation.dart';
import 'package:word_pronunciation/src/features/word/data/model/definition.dart';
import 'package:word_pronunciation/src/features/word/data/model/phonetic.dart';
import 'package:word_pronunciation/src/features/word/data/model/word.dart';
import 'package:word_pronunciation/src/features/word/presentation/widgets/widgets.dart';
import 'package:word_pronunciation/src/features/word/presentation/word_page.dart';
import 'package:word_pronunciation/src/features/word/scope/word_scope.dart';

/// Виджет отображающий idle состояние [WordPage]
@immutable
class WordIdleLayout extends StatelessWidget {
  /// Слово
  final Word word;

  /// {@macro scroll_controller}
  final ScrollController scrollController;

  /// Создает виджет отображающий idle состояние [WordPage]
  const WordIdleLayout({
    required this.word,
    required this.scrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<WordPronunciationBloc, WordPronunciationState>(
        bloc: WordScope.of(context).wordPronunciationBloc,
        buildWhen: (previous, current) =>
            current.isProcessing || current.isIdle,
        builder: (context, state) => PronouncingFilter(
          enabled: state.isProcessing,
          child: ScrollFadeBottomMask.withController(
            startsAt: .65,
            scrollController: scrollController,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                // Отступ сверху
                SliverPadding(
                  padding: EdgeInsets.only(top: context.mediaQuery.padding.top),
                ),

                // Карточка слова
                SliverPadding(
                  padding: const EdgeInsets.only(top: 32, left: 32, right: 32),
                  sliver: SliverToBoxAdapter(
                    child: WordCard(word: word),
                  ),
                ),

                // Кнопка "Следующее слово"
                SliverPadding(
                  padding: const EdgeInsets.only(top: 32, left: 44, right: 44),
                  sliver: SliverToBoxAdapter(
                    child: PrimaryElevatedButton(
                      onTap: WordScope.of(context).state.readNextWord,
                      child: Text(
                        context.localization.nextWord,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),

                // Фонетика
                if (phoneticsWithAudio.isNotEmpty) ...[
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 20),
                    sliver: SliverToBoxAdapter(
                      child: PhoneticsListview(
                        phonetics: phoneticsWithAudio,
                      ),
                    ),
                  ),
                ],

                // Определения-существительные
                if (nounDefinitions.isNotEmpty) ...[
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 20),
                    sliver: SliverToBoxAdapter(
                      child: DefinitionsView(
                        title: context.localization.nounDefinitions,
                        definitions: nounDefinitions,
                      ),
                    ),
                  ),
                ],

                // Определения-глаголы
                if (verbDefinitions.isNotEmpty) ...[
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 24),
                    sliver: SliverToBoxAdapter(
                      child: DefinitionsView(
                        title: context.localization.verbDefinitions,
                        definitions: verbDefinitions,
                      ),
                    ),
                  ),
                ],

                // Кнопка "Настройки"
                SliverPadding(
                  padding: const EdgeInsets.only(top: 24, left: 44, right: 44),
                  sliver: SliverToBoxAdapter(
                    child: PrimaryElevatedButton(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AppSettingsPage(),
                        ),
                      ),
                      child: const Text(
                        'Настройки',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),

                // История правильно произнесенных слов
                const SliverPadding(
                  padding: EdgeInsets.only(top: 24),
                  sliver: WordHistoryList(),
                ),

                // Отступ снизу
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: 140 + context.mediaQuery.padding.bottom,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  /// Список фонетики с аудио
  List<Phonetic> get phoneticsWithAudio => word.phoneticsWithAudio.toList();

  /// Определения-существительные
  List<Definition> get nounDefinitions => word.nounDefinitions.toList();

  /// Определения-глаголы
  List<Definition> get verbDefinitions => word.verbDefinitions.toList();
}
