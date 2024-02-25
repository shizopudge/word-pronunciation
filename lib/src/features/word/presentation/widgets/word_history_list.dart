import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_history.dart';
import 'package:word_pronunciation/src/features/word/data/model/local_word.dart';
import 'package:word_pronunciation/src/features/word/presentation/widgets/widgets.dart';
import 'package:word_pronunciation/src/features/word/scope/word_scope.dart';

/// Список слов в истории
@immutable
class WordHistoryList extends StatelessWidget {
  /// Создает список слов в истории
  const WordHistoryList({
    super.key,
  });

  @override
  Widget build(BuildContext context) => SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: WordTitle(
              context.localization.history,
              action: const _Action(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 24),
            sliver: BlocBuilder<WordHistoryBloc, WordHistoryState>(
              bloc: WordScope.of(context).wordHistoryBloc,
              buildWhen: (previous, current) => !current.isError,
              builder: (context, state) => state.maybeMap(
                orElse: () {
                  if (state.isPrimaryProgress) {
                    return const SliverPadding(
                      padding: EdgeInsets.all(32),
                      sliver: SliverToBoxAdapter(
                        child: ProgressLayout(),
                      ),
                    );
                  }

                  return _ListOrEmptyLayout(
                    words: state.words,
                    isProgress: state.isProgress,
                  );
                },
                error: (e) => const _ErrorLayout(),
              ),
            ),
          ),
        ],
      );
}

/// Действие
@immutable
class _Action extends StatelessWidget {
  /// Создает действие
  const _Action();

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: WordScope.of(context).state.showWordHistoryFilterSheet,
        constraints: BoxConstraints.tight(const Size.square(40)),
        tooltip: context.localization.historyFilter,
        icon: Icon(
          Icons.filter_alt_rounded,
          size: 24,
          color: context.theme.colors.blue,
        ),
      );
}

/// Виджет отображающий список или пустое состояние
@immutable
class _ListOrEmptyLayout extends StatelessWidget {
  /// Слова
  final List<LocalWord> words;

  /// Если true, значит идет загрузка
  final bool isProgress;

  /// Создает виджет отображающий список или пустое состояние
  const _ListOrEmptyLayout({
    required this.words,
    required this.isProgress,
  });

  @override
  Widget build(BuildContext context) {
    late final Widget sliver;

    if (words.isEmpty) {
      sliver = SliverToBoxAdapter(
        child: Text(
          '${context.localization.historyIsEmpty}.',
          textAlign: TextAlign.center,
          style: context.theme.textTheme.bodyMedium
              ?.copyWith(color: context.theme.colors.grey),
        ),
      );
    } else {
      sliver = SliverList.separated(
        itemCount: words.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => WordHistoryTile(
          key: ValueKey<String>('${index + 1}_${words[index].data}'),
          word: words[index],
          index: index + 1,
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverMainAxisGroup(
        slivers: [
          sliver,
          if (isProgress) ...[
            const SliverPadding(
              padding: EdgeInsets.only(top: 20),
              sliver: SliverToBoxAdapter(
                child: ProgressLayout(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Виджет отображающий ошибку загрузки истории
@immutable
class _ErrorLayout extends StatelessWidget {
  /// Создает виджет отображающий ошибку загрузки истории
  const _ErrorLayout();

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 44),
        sliver: SliverToBoxAdapter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.localization.historyFatalError,
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: context.theme.colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: PrimaryElevatedButton(
                  onTap: () => WordScope.of(context).wordHistoryBloc.add(
                        WordHistoryEvent.read(
                          reset: true,
                          filter:
                              WordScope.of(context).wordHistoryFilterBloc.state,
                        ),
                      ),
                  child: Text(
                    context.localization.tryAgain,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
