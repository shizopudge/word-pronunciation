import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';
import 'package:word_pronunciation/src/features/word/domain/entity/speach_service_status.dart';
import 'package:word_pronunciation/src/features/word/domain/repository/i_word_repository.dart';
import 'package:word_pronunciation/src/features/word/domain/service/speech_service.dart';

part 'word_pronunciation.freezed.dart';

@freezed
class WordPronunciationEvent with _$WordPronunciationEvent {
  const factory WordPronunciationEvent.initialize() =
      _InitializeWordPronunciationEvent;

  const factory WordPronunciationEvent.pronounce() =
      _PronounceWordPronunciationEvent;

  const factory WordPronunciationEvent.stop() = _StopWordPronunciationEvent;

  const factory WordPronunciationEvent.checkResult({
    required final String? expectedWord,
  }) = _CheckResultWordPronunciationEvent;

  @protected
  const factory WordPronunciationEvent.onStatus({
    required final SpeachServiceStatus status,
  }) = _OnStatusWordPronunciationEvent;

  @protected
  const factory WordPronunciationEvent.onError({
    required final String message,
  }) = _OnErrorWordPronunciationEvent;

  @protected
  const factory WordPronunciationEvent.onResult({
    required final String result,
  }) = _OnResultWordPronunciationEvent;
}

@freezed
class WordPronunciationState with _$WordPronunciationState {
  const WordPronunciationState._();

  String? get resultOrNull => map(
        right: (right) => right.result,
        incorrect: (incorrect) => incorrect.result,
        done: (done) => done.result,
        pronunciation: (pronunciation) => pronunciation.result,
        progress: (progress) => progress.result,
        idle: (idle) => null,
        error: (error) => error.result,
      );

  bool get isPreviousStatePronunciation =>
      this is _PronunciationWordPronunciationState;

  bool get isProcessing => maybeMap(
        orElse: () => false,
        right: (_) => true,
        incorrect: (_) => true,
        done: (_) => true,
        pronunciation: (_) => true,
      );

  bool get isRight => maybeMap(
        orElse: () => false,
        right: (_) => true,
      );

  bool get isIncorrect => maybeMap(
        orElse: () => false,
        incorrect: (_) => true,
      );

  bool get isPronouncing => maybeMap(
        orElse: () => false,
        pronunciation: (_) => true,
      );

  bool get isProgress => maybeMap(
        orElse: () => false,
        progress: (_) => true,
      );

  bool get isIdle => maybeMap(
        orElse: () => false,
        idle: (_) => true,
      );

  bool get isError => maybeMap(
        orElse: () => false,
        error: (_) => true,
      );

  const factory WordPronunciationState.right({
    required final String result,
  }) = _RightWordPronunciationState;

  const factory WordPronunciationState.incorrect({
    required final String result,
  }) = _IncorrectWordPronunciationState;

  const factory WordPronunciationState.done({
    required final String result,
  }) = _DoneWordPronunciationState;

  const factory WordPronunciationState.pronunciation({
    required final String result,
  }) = _PronunciationWordPronunciationState;

  const factory WordPronunciationState.progress({
    final String? result,
  }) = _ProgressWordPronunciationState;

  const factory WordPronunciationState.idle() = _IdleWordPronunciationState;

  const factory WordPronunciationState.error({
    required final IErrorHandler errorHandler,
    required final String? result,
  }) = _ErrorWordPronunciationState;
}

/// {@template word_pronunciation_bloc}
/// Блок произношения слова
/// {@endtemplate}
class WordPronunciationBloc
    extends Bloc<WordPronunciationEvent, WordPronunciationState> {
  final IWordRepository _repository;

  /// {@macro speech_service}
  final ISpeechService _speechService;

  /// Подписка на стрим результатов произношения
  late final StreamSubscription<String> _resultStream;

  /// Подписка на стрим статусов
  late final StreamSubscription<SpeachServiceStatus> _statusStream;

  /// Подписка на стрим ошибок
  late final StreamSubscription<String> _errorStream;

  /// {@macro word_pronunciation_bloc}
  WordPronunciationBloc({
    required final IWordRepository repository,
    required final ISpeechService speechService,
  })  : _speechService = speechService,
        _repository = repository,
        super(const WordPronunciationState.idle()) {
    _resultStream = _speechService.resultStream.listen(
        (result) => add(WordPronunciationEvent.onResult(result: result)));
    _statusStream = _speechService.statusStream.listen(
      (status) => add(WordPronunciationEvent.onStatus(status: status)),
    );
    _errorStream = _speechService.errorStream.listen(
        (message) => add(WordPronunciationEvent.onError(message: message)));
    on<WordPronunciationEvent>(
      (event, emit) => event.map(
        initialize: (event) => _initialize(event, emit),
        pronounce: (event) => _pronounce(event, emit),
        stop: (event) => _stop(event, emit),
        checkResult: (event) => _checkResult(event, emit),
        onStatus: (event) => _onStatus(event, emit),
        onError: (event) => _onError(event, emit),
        onResult: (event) => _onResult(event, emit),
      ),
    );
  }

  Future<void> _initialize(_InitializeWordPronunciationEvent event,
      Emitter<WordPronunciationState> emit) async {
    try {
      emit(const WordPronunciationState.progress());
      final hasPermissions = await _speechService
          .handlePermissions()
          .timeout(const Duration(minutes: 5));
      if (!hasPermissions) return emit(const WordPronunciationState.idle());
      await _speechService.initialize().timeout(const Duration(seconds: 30));
      emit(const WordPronunciationState.idle());
    } on Object catch (error) {
      emit(
        WordPronunciationState.error(
          errorHandler: ErrorHandler(error),
          result: state.resultOrNull,
        ),
      );
      rethrow;
    } finally {
      if (state.isError) emit(const WordPronunciationState.idle());
    }
  }

  Future<void> _pronounce(_PronounceWordPronunciationEvent event,
      Emitter<WordPronunciationState> emit) async {
    try {
      emit(const WordPronunciationState.progress());
      if (!_speechService.isInitialized) {
        final hasPermissions = await _speechService
            .handlePermissions()
            .timeout(const Duration(minutes: 5));
        if (!hasPermissions) return emit(const WordPronunciationState.idle());
        await _speechService.initialize().timeout(const Duration(seconds: 30));
      }
      if (_speechService.isInitialized) {
        await _speechService.pronounce().timeout(const Duration(seconds: 30));
      }
    } on Object catch (error) {
      emit(
        WordPronunciationState.error(
          errorHandler: ErrorHandler(error),
          result: state.resultOrNull,
        ),
      );
      rethrow;
    } finally {
      if (state.isError) emit(const WordPronunciationState.idle());
    }
  }

  Future<void> _stop(_StopWordPronunciationEvent event,
      Emitter<WordPronunciationState> emit) async {
    try {
      if (!_speechService.isInitialized) return;
      emit(WordPronunciationState.progress(result: state.resultOrNull));
      await _speechService.stop().timeout(const Duration(seconds: 15));
      emit(const WordPronunciationState.idle());
    } on Object catch (error) {
      emit(
        WordPronunciationState.error(
          errorHandler: ErrorHandler(error),
          result: state.resultOrNull,
        ),
      );
      rethrow;
    } finally {
      if (state.isError) emit(const WordPronunciationState.idle());
    }
  }

  Future<void> _checkResult(_CheckResultWordPronunciationEvent event,
      Emitter<WordPronunciationState> emit) async {
    final expectedWord = event.expectedWord ?? '';
    final result = state.resultOrNull ?? '';
    if (result.isEmpty || expectedWord.isEmpty) {
      return emit(const WordPronunciationState.idle());
    }
    try {
      final pronounced = result.toLowerCase() == expectedWord.toLowerCase();
      if (pronounced) {
        emit(WordPronunciationState.right(result: result));
      } else {
        emit(WordPronunciationState.incorrect(result: result));
      }
      unawaited(_repository
          .writeWordToLocalHistory(word: expectedWord, pronounced: pronounced)
          ?.timeout(const Duration(seconds: 15)));
    } finally {
      await Future<void>.delayed(const Duration(milliseconds: 1000));
      if (!state.isPronouncing && !state.isProgress) {
        emit(const WordPronunciationState.idle());
      }
    }
  }

  void _onStatus(_OnStatusWordPronunciationEvent event,
      Emitter<WordPronunciationState> emit) {
    final status = event.status;
    final result = state.resultOrNull ?? '';
    if (status == SpeachServiceStatus.listening) {
      return emit(WordPronunciationState.pronunciation(result: result));
    } else if (status == SpeachServiceStatus.done) {
      return emit(WordPronunciationState.done(result: result));
    }
  }

  void _onError(_OnErrorWordPronunciationEvent event,
      Emitter<WordPronunciationState> emit) {
    emit(
      WordPronunciationState.error(
        errorHandler: ErrorHandler(
          SpeechServiceException(event.message),
        ),
        result: state.resultOrNull,
      ),
    );
    if (state.isError) emit(const WordPronunciationState.idle());
  }

  void _onResult(_OnResultWordPronunciationEvent event,
      Emitter<WordPronunciationState> emit) {
    if (event.result == state.resultOrNull) return;
    emit(WordPronunciationState.pronunciation(result: event.result));
  }

  @override
  Future<void> close() async {
    await _resultStream.cancel();
    await _statusStream.cancel();
    await _errorStream.cancel();
    return super.close();
  }
}
