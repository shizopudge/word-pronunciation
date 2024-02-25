import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/features/toaster/toaster.dart';
import 'package:word_pronunciation/src/features/word/bloc/word.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_audio.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_history.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_history_filter.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_pronunciation.dart';
import 'package:word_pronunciation/src/features/word/data/datasource/word_local_datasource.dart';
import 'package:word_pronunciation/src/features/word/data/datasource/word_remote_datasource.dart';
import 'package:word_pronunciation/src/features/word/data/model/definition.dart';
import 'package:word_pronunciation/src/features/word/data/model/phonetic.dart';
import 'package:word_pronunciation/src/features/word/data/repository/word_repository.dart';
import 'package:word_pronunciation/src/features/word/domain/entity/word_history_filter.dart';
import 'package:word_pronunciation/src/features/word/domain/repository/i_word_repository.dart';
import 'package:word_pronunciation/src/features/word/domain/service/audio_service.dart';
import 'package:word_pronunciation/src/features/word/domain/service/speech_service.dart';
import 'package:word_pronunciation/src/features/word/presentation/widgets/widgets.dart';

/// Область видимости зависимостей модуля word
@immutable
class WordScope extends StatefulWidget {
  /// Дочерний виджет
  final Widget child;

  /// Создает область видимости зависимостей модуля word
  const WordScope({
    required this.child,
    super.key,
  });

  /// Возвращает виджет хранящий в себе [WordScope] или завершается с
  /// [FlutterError] - Out of scope
  static InheritedWordScope of(BuildContext context) {
    late final InheritedWordScope? inheritedWordScope;

    inheritedWordScope =
        context.getInheritedWidgetOfExactType<InheritedWordScope>();

    if (inheritedWordScope == null) {
      throw FlutterError('Out of scope, not found WordScope');
    }

    return inheritedWordScope;
  }

  @override
  State<WordScope> createState() => WordScopeState();
}

class WordScopeState extends State<WordScope> with WidgetsBindingObserver {
  /// {@macro word_bloc}
  late final WordBloc _wordBloc;

  /// {@macro word_audio_bloc}
  late final WordAudioBloc _wordAudioBloc;

  /// {@macro word_pronunciation_bloc}
  late final WordPronunciationBloc _wordPronunciationBloc;

  /// {@macro word_history_bloc}
  late final WordHistoryBloc _wordHistoryBloc;

  /// {@macro word_history_filter_bloc}
  late final WordHistoryFilterBloc _wordHistoryFilterBloc;

  /// {@macro speech_service}
  late final ISpeechService _speechService;

  /// {@macro audio_service}
  late final IAudioService _audioService;

  /// Репозиторий
  late final IWordRepository _repository;

  /// {@macro overlay}
  OverlayState? _overlay;

  /// {@template overlay_entry}
  /// Наложение на оверлей
  /// {@endtemplate}
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _speechService = const SpeechService();
    _audioService = const AudioService();
    _repository = WordRepository(
      remoteDatasource:
          WordRemoteDatasource(dioClient: context.dependencies.dioClient),
      localDatasource: WordLocalDatasource(db: context.dependencies.db),
    );
    _wordBloc = WordBloc(repository: _repository)..add(const WordEvent.read());
    _wordAudioBloc = WordAudioBloc(audioService: _audioService);
    _wordPronunciationBloc = WordPronunciationBloc(
      repository: _repository,
      speechService: _speechService,
    )..add(const WordPronunciationEvent.initialize());
    _wordHistoryFilterBloc = WordHistoryFilterBloc();
    _wordHistoryBloc = WordHistoryBloc(repository: _repository)
      ..add(WordHistoryEvent.read(filter: _wordHistoryFilterBloc.state));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state != AppLifecycleState.resumed && mounted) {
      if (_wordAudioBloc.state.isPlaying || _wordAudioBloc.state.isProgress) {
        _wordAudioBloc.add(const WordAudioEvent.stop());
      }
      if (_wordPronunciationBloc.state.isProcessing ||
          _wordPronunciationBloc.state.isProgress) {
        _wordPronunciationBloc.add(const WordPronunciationEvent.stop());
      }
    }
  }

  @override
  void dispose() {
    _wordBloc.close();
    _wordAudioBloc.close();
    _wordPronunciationBloc.close();
    _wordHistoryBloc.close();
    _wordHistoryFilterBloc.close();
    _overlayEntry
      ?..remove()
      ..dispose();
    _overlay?.dispose();
    _audioService.dispose();
    _speechService.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => InheritedWordScope(
        wordBloc: _wordBloc,
        wordAudioBloc: _wordAudioBloc,
        wordPronunciationBloc: _wordPronunciationBloc,
        wordHistoryBloc: _wordHistoryBloc,
        wordHistoryFilterBloc: _wordHistoryFilterBloc,
        state: this,
        child: _WordScopeListeners(
          child: widget.child,
        ),
      );

  /// Включает/выключает воспроизведение аудио
  void toggleAudio(Phonetic phonetic) {
    final state = _wordAudioBloc.state;
    if (state.isPlaying && state.audioUrlOrNull == phonetic.audio) {
      return _wordAudioBloc.add(const WordAudioEvent.stop());
    }
    return _wordAudioBloc.add(WordAudioEvent.play(audioUrl: phonetic.audio));
  }

  /// Читает следующее слово
  void readNextWord() => _wordBloc.add(const WordEvent.read());

  /// Читает слово из словаря
  void readFromDictionary(String word) =>
      _wordBloc.add(WordEvent.readFromDictionary(word: word));

  /// Обработчик кнопки "Попробовать снова"
  void tryAgain() => _wordBloc.add(const WordEvent.read());

  /// Начинает/останавливает произношение
  void togglePronunciation() {
    if (_wordPronunciationBloc.state.isProcessing) {
      return _wordPronunciationBloc.add(const WordPronunciationEvent.stop());
    }
    return _wordPronunciationBloc.add(const WordPronunciationEvent.pronounce());
  }

  /// Обработчик ошибок в [WordPronunciationBloc]
  void onWordPronunciationBlocError(IErrorHandler errorHandler) {
    final err = errorHandler.error;
    if (err is SpeechServicePermissionException && err.isPermanentlyDenied) {
      return unawaited(_showPronunciationPermissionsAlert());
    } else if (err is SpeechServiceException) {
      late final String message;
      if (err.isNoMatch) {
        message = context.localization.errorNoMatch;
      } else if (err.isSpeechTimeout) {
        message = context.localization.errorSpeechTimeout;
      } else if (err.isNetwork) {
        message = context.localization.errorSpeechNetwork;
      } else {
        message = context.localization.unknownErrorOccurred;
      }
      return context.showToaster(
        message: message,
        type: ToasterType.message,
      );
    }
    return context.showToaster(
      message: errorHandler.toMessage(context),
      type: ToasterType.error,
    );
  }

  /// Показывает результат произношения
  void showPronunciationResult() {
    _overlay ??= Overlay.of(context);
    _overlayEntry
      ?..remove()
      ..dispose();
    _overlayEntry = OverlayEntry(
      builder: (context) =>
          WordOverlay(wordPronunciationBloc: _wordPronunciationBloc),
    );
    if (_overlayEntry == null) return;
    _overlay?.insert(_overlayEntry!);
  }

  /// Скрывает результат произношения
  void hidePronunciationResult() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  /// Показывает [WordHistoryFilterSheet]
  Future<void> showWordHistoryFilterSheet() async {
    final result = await WordHistoryFilterSheet.show(context,
        initialValue: _wordHistoryFilterBloc.state);
    if (result != null && mounted) {
      _wordHistoryFilterBloc.add(WordHistoryFilterEvent.select(filter: result));
    }
  }

  /// Показывает [DefinitionSheet]
  Future<void> showDefinitionSheet(Definition definition) =>
      DefinitionSheet.show(context, definition: definition);

  /// Показывает алерт с сообщением о разрешениях для произношения слов
  Future<void> _showPronunciationPermissionsAlert() async {
    final result = await PermissionsAlert.show(
      context,
      title: context.localization.microphonePermissions,
      description: context.localization.youHaventGivenPermissionToUseMic,
    );
    if (result != null && result && context.mounted) {
      final isCanOpen = await openAppSettings();
      if (!isCanOpen && context.mounted) {
        context.showToaster(
          message: context.localization.cantOpenAppSettings,
          type: ToasterType.error,
        );
      }
    }
  }
}

/// Виджет хранящий в себе [WordScope]
class InheritedWordScope extends InheritedWidget {
  /// {@macro word_bloc}
  final WordBloc wordBloc;

  /// {@macro word_audio_bloc}
  final WordAudioBloc wordAudioBloc;

  /// {@macro word_pronunciation_bloc}
  final WordPronunciationBloc wordPronunciationBloc;

  /// {@macro word_history_bloc}
  final WordHistoryBloc wordHistoryBloc;

  /// {@macro word_history_filter_bloc}
  final WordHistoryFilterBloc wordHistoryFilterBloc;

  /// Состояние [WordScope]
  final WordScopeState state;

  /// Создает виджет хранящий в себе [WordScope]
  const InheritedWordScope({
    required this.wordBloc,
    required this.wordAudioBloc,
    required this.wordPronunciationBloc,
    required this.wordHistoryBloc,
    required this.wordHistoryFilterBloc,
    required this.state,
    required super.child,
    super.key,
  });

  @override
  bool updateShouldNotify(covariant InheritedWordScope oldWidget) =>
      oldWidget.wordBloc != wordBloc ||
      oldWidget.wordAudioBloc != wordAudioBloc ||
      oldWidget.wordPronunciationBloc != wordPronunciationBloc ||
      oldWidget.wordHistoryBloc != wordHistoryBloc ||
      oldWidget.wordHistoryFilterBloc != wordHistoryFilterBloc ||
      oldWidget.state != state;
}

/// Слушатели [WordScope]
@immutable
class _WordScopeListeners extends StatelessWidget {
  /// Дочерний виджет
  final Widget child;

  /// Создает слушателей [WordScope]
  const _WordScopeListeners({
    required this.child,
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

          // Скрывает результат произношения, проверяет результат произношения
          // и обрабатывает ошибки при произношении
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

          // Показывает результат произношения
          BlocListener<WordPronunciationBloc, WordPronunciationState>(
            bloc: WordScope.of(context).wordPronunciationBloc,
            listenWhen: (previous, current) =>
                !previous.isPreviousStatePronunciation,
            listener: (context, state) => state.mapOrNull<void>(
              pronunciation: (_) =>
                  WordScope.of(context).state.showPronunciationResult(),
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
