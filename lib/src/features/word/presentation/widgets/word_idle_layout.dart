import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_history.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_pronunciation.dart';
import 'package:word_pronunciation/src/features/word/data/model/definition.dart';
import 'package:word_pronunciation/src/features/word/data/model/phonetic.dart';
import 'package:word_pronunciation/src/features/word/data/model/word.dart';
import 'package:word_pronunciation/src/features/word/presentation/widgets/widgets.dart';
import 'package:word_pronunciation/src/features/word/presentation/word_page.dart';
import 'package:word_pronunciation/src/features/word/scope/word_scope.dart';

/// Виджет отображающий idle состояние [WordPage]
@immutable
class WordIdleLayout extends StatefulWidget {
  /// Слово
  final Word word;

  /// Создает виджет отображающий idle состояние [WordPage]
  const WordIdleLayout({
    super.key,
    required this.word,
  });

  @override
  State<WordIdleLayout> createState() => _WordIdleLayoutState();
}

class _WordIdleLayoutState extends State<WordIdleLayout> {
  /// {@macro scroll_controller}
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<WordPronunciationBloc, WordPronunciationState>(
        bloc: WordScope.of(context).wordPronunciationBloc,
        buildWhen: (previous, current) =>
            current.isProcessing || current.isIdle,
        builder: (context, state) => IgnorePointer(
          ignoring: state.isProcessing,
          child: PronouncingFilters(
            enabled: state.isProcessing,
            child: ScrollFadeBottomMask.withController(
              startsAt: .65,
              scrollController: _scrollController,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverPadding(
                    padding:
                        EdgeInsets.only(top: context.mediaQuery.padding.top),
                  ),

                  // Карточка слова
                  SliverPadding(
                    padding:
                        const EdgeInsets.only(top: 32, left: 32, right: 32),
                    sliver: SliverToBoxAdapter(
                      child: WordCard(
                        word: widget.word,
                      ),
                    ),
                  ),

                  SliverPadding(
                    padding:
                        const EdgeInsets.only(top: 32, left: 44, right: 44),
                    sliver: SliverToBoxAdapter(
                      child: _ReadNextButton(
                        onTap: WordScope.of(context).state.readNextWord,
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
        ),
      );

  /// Обработчик на скролл
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final bloc = WordScope.of(context).wordHistoryBloc;
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;
    final isBottom = offset >= maxScrollExtent * .95;
    if (isBottom && !bloc.state.isProgress && !bloc.state.isEndOfList) {
      bloc.add(
        WordHistoryEvent.read(
          filter: WordScope.of(context).wordHistoryFilterBloc.state,
        ),
      );
    }
  }

  /// Список фонетики с аудио
  List<Phonetic> get phoneticsWithAudio =>
      widget.word.phoneticsWithAudio.toList();

  /// Определения-существительные
  List<Definition> get nounDefinitions => widget.word.nounDefinitions.toList();

  /// Определения-глаголы
  List<Definition> get verbDefinitions => widget.word.verbDefinitions.toList();
}

/// Кнопка "Следующее слово"
@immutable
class _ReadNextButton extends StatelessWidget {
  /// Обработчик нажатия
  final VoidCallback onTap;

  /// Созадет кнопку "Следующее слово"
  const _ReadNextButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => PrimaryElevatedButton(
        onTap: onTap,
        child: Text(
          context.localization.nextWord,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
}
