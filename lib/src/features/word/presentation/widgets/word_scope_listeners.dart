import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/features/app_settings/scope/app_settings_scope.dart';
import 'package:word_pronunciation/src/features/toaster/toaster.dart';
import 'package:word_pronunciation/src/features/word/bloc/word.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_audio.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_history.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_history_filter.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_pronunciation.dart';
import 'package:word_pronunciation/src/features/word/domain/entity/word_history_filter.dart';
import 'package:word_pronunciation/src/features/word/scope/word_scope.dart';

/// Слушатели [WordScope]
@immutable
class WordScopeListeners extends StatelessWidget {
  /// Дочерний виджет
  final Widget child;

  /// Создает слушателей [WordScope]
  const WordScopeListeners({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) => MultiBlocListener(
        listeners: [
          // Обрабатывает ошибки в [WordBloc], останавливает воспроизведение
          // аудио и произношение при загрузке в [WordBloc]
          BlocListener<WordBloc, WordState>(
            bloc: WordScope.of(context).wordBloc,
            listenWhen: (previous, current) =>
                current.isError || current.isProgress,
            listener: (context, state) => state.mapOrNull<void>(
              progress: (p) {
                WordScope.of(context)
                    .wordAudioBloc
                    .add(const WordAudioEvent.stop());
                WordScope.of(context)
                    .wordPronunciationBloc
                    .add(const WordPronunciationEvent.stop());
              },
              error: (e) => context.showToaster(
                message: e.errorHandler.toMessage(context),
                type: ToasterType.error,
              ),
            ),
          ),

          // Обрабатывает ошибки при воспроизведении аудио
          BlocListener<WordAudioBloc, WordAudioState>(
            bloc: WordScope.of(context).wordAudioBloc,
            listenWhen: (previous, current) => current.isError,
            listener: (context, state) => state.mapOrNull<void>(
              error: (e) => context.showToaster(
                message: e.errorHandler.toMessage(context),
                type: ToasterType.error,
              ),
            ),
          ),

          // Скрывает результат произношения, проверяет результат произношения,
          // читает историю при правильном/неправильном произношении и
          // обрабатывает ошибки при произношении
          BlocListener<WordPronunciationBloc, WordPronunciationState>(
            bloc: WordScope.of(context).wordPronunciationBloc,
            listener: (context, state) => state.mapOrNull<void>(
              right: (_) => WordScope.of(context).wordHistoryBloc.add(
                    WordHistoryEvent.read(
                      reset: true,
                      filter: WordScope.of(context).wordHistoryFilterBloc.state,
                    ),
                  ),
              incorrect: (_) => WordScope.of(context).wordHistoryBloc.add(
                    WordHistoryEvent.read(
                      reset: true,
                      filter: WordScope.of(context).wordHistoryFilterBloc.state,
                    ),
                  ),
              done: (_) => WordScope.of(context).wordPronunciationBloc.add(
                    WordPronunciationEvent.checkResult(
                      expectedWord:
                          WordScope.of(context).wordBloc.state.word?.data,
                    ),
                  ),
              idle: (_) =>
                  WordScope.of(context).state.hidePronunciationResult(),
              error: (e) => WordScope.of(context)
                  .state
                  .onWordPronunciationBlocError(e.errorHandler),
            ),
          ),

          if (AppSettingsScope.of(context).appSettings.autoNextWord) ...[
            // Получает новое слово при правильном произношении
            BlocListener<WordPronunciationBloc, WordPronunciationState>(
              bloc: WordScope.of(context).wordPronunciationBloc,
              listenWhen: (previous, current) => previous.isRight,
              listener: (context, state) => state.mapOrNull<void>(
                idle: (_) => WordScope.of(context).state.readNextWord(),
              ),
            ),
          ],

          // Показывает результат произношения
          BlocListener<WordPronunciationBloc, WordPronunciationState>(
            bloc: WordScope.of(context).wordPronunciationBloc,
            listenWhen: (previous, current) =>
                !previous.isPreviousStatePronunciation,
            listener: (context, state) => state.mapOrNull<void>(
              pronunciation: (_) {
                WordScope.of(context)
                    .wordAudioBloc
                    .add(const WordAudioEvent.stop());
                WordScope.of(context).state.showPronunciationResult();
              },
            ),
          ),

          // Обрабатывает ошибки в [WordHistoryBloc]
          BlocListener<WordHistoryBloc, WordHistoryState>(
            bloc: WordScope.of(context).wordHistoryBloc,
            listenWhen: (previous, current) => current.isError,
            listener: (context, state) => state.mapOrNull<void>(
              error: (e) => context.showToaster(
                message: e.errorHandler.toMessage(context),
                type: ToasterType.error,
              ),
            ),
          ),

          // Читает историю при изменении фильтра в [WordHistoryFilterBloc]
          BlocListener<WordHistoryFilterBloc, WordHistoryFilter>(
            bloc: WordScope.of(context).wordHistoryFilterBloc,
            listenWhen: (previous, current) => previous != current,
            listener: (context, state) =>
                WordScope.of(context).wordHistoryBloc.add(
                      WordHistoryEvent.read(
                        reset: true,
                        filter: state,
                      ),
                    ),
          ),
        ],
        child: child,
      );
}
