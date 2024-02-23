import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';
import 'package:word_pronunciation/src/features/word/domain/entity/speach_service_status.dart';
import 'package:word_pronunciation/src/features/word/domain/service/speech_service.dart';

part 'word_pronunciation.freezed.dart';

@freezed
class WordPronunciationEvent with _$WordPronunciationEvent {
  const factory WordPronunciationEvent.initialize() =
      _InitializeWordPronunciationEvent;

  const factory WordPronunciationEvent.pronounce() =
      _PronounceWordPronunciationEvent;

  const factory WordPronunciationEvent.stop() = _StopWordPronunciationEvent;

  const factory WordPronunciationEvent.onStatus({
    required final SpeachServiceStatus status,
  }) = _OnStatusWordPronunciationEvent;

  const factory WordPronunciationEvent.onError({
    required final String message,
  }) = _OnErrorWordPronunciationEvent;

  const factory WordPronunciationEvent.onResult({
    required final String result,
  }) = _OnResultWordPronunciationEvent;
}

@freezed
class WordPronunciationState with _$WordPronunciationState {
  const WordPronunciationState._();

  String? get resultOrNull => map(
        pronunciation: (pronunciation) => pronunciation.result,
        progress: (progress) => null,
        idle: (idle) => null,
        error: (error) => error.result,
      );

  bool get isPronouncing => maybeMap(
        orElse: () => false,
        pronunciation: (_) => true,
      );

  bool get isIdle => maybeMap(
        orElse: () => false,
        idle: (_) => true,
      );

  bool get isError => maybeMap(
        orElse: () => false,
        error: (e) => e.result != null,
      );

  bool get isFatalError => maybeMap(
        orElse: () => false,
        error: (e) => e.result == null,
      );

  const factory WordPronunciationState.pronunciation({
    required final String result,
  }) = _PronunciationWordPronunciationState;

  const factory WordPronunciationState.progress({
    required final String? result,
  }) = _ProgressWordPronunciationState;

  const factory WordPronunciationState.idle({
    required final String? result,
  }) = _IdleWordPronunciationState;

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
  /// {@macro speech_service}
  static const SpeechService _speechService = SpeechService();

  /// Подписка на стрим результатов произношения
  late final StreamSubscription<String> _resultStream;

  /// Подписка на стрим статусов
  late final StreamSubscription<SpeachServiceStatus> _statusStream;

  /// Подписка на стрим ошибок
  late final StreamSubscription<String> _errorStream;

  /// {@macro word_pronunciation_bloc}
  WordPronunciationBloc()
      : super(const WordPronunciationState.idle(result: '')) {
    _resultStream = _speechService.resultStream.listen(
        (result) => add(WordPronunciationEvent.onResult(result: result)));
    _statusStream = _speechService.statusStream.listen(
        (status) => add(WordPronunciationEvent.onStatus(status: status)));
    _errorStream = _speechService.errorStream.listen(
        (message) => add(WordPronunciationEvent.onError(message: message)));
    on<WordPronunciationEvent>(
      (event, emit) => event.map(
        initialize: (event) => _initialize(event, emit),
        pronounce: (event) => _pronounce(event, emit),
        stop: (event) => _stop(event, emit),
        onStatus: (event) => _onStatus(event, emit),
        onError: (event) => _onError(event, emit),
        onResult: (event) => _onResult(event, emit),
      ),
    );
  }

  Future<void> _initialize(_InitializeWordPronunciationEvent event,
      Emitter<WordPronunciationState> emit) async {
    try {
      emit(WordPronunciationState.progress(result: state.resultOrNull));
      await _speechService.initialize().timeout(const Duration(minutes: 1));
      emit(WordPronunciationState.idle(result: state.resultOrNull));
    } on Object catch (error) {
      emit(
        WordPronunciationState.error(
          errorHandler: ErrorHandler(error: error),
          result: state.resultOrNull,
        ),
      );
      rethrow;
    }
  }

  Future<void> _pronounce(_PronounceWordPronunciationEvent event,
      Emitter<WordPronunciationState> emit) async {
    try {
      emit(WordPronunciationState.progress(result: state.resultOrNull));
      if (!_speechService.isInitialized) {
        await _speechService.initialize().timeout(const Duration(minutes: 1));
      }
      if (_speechService.isInitialized) {
        await _speechService.pronounce().timeout(const Duration(seconds: 30));
      }
    } on Object catch (error) {
      emit(
        WordPronunciationState.error(
          errorHandler: ErrorHandler(error: error),
          result: state.resultOrNull,
        ),
      );
      rethrow;
    }
  }

  Future<void> _stop(_StopWordPronunciationEvent event,
      Emitter<WordPronunciationState> emit) async {
    try {
      if (!_speechService.isInitialized) return;
      emit(WordPronunciationState.progress(result: state.resultOrNull));
      await _speechService.stop().timeout(const Duration(seconds: 15));
      emit(WordPronunciationState.idle(result: state.resultOrNull));
    } on Object catch (error) {
      emit(
        WordPronunciationState.error(
          errorHandler: ErrorHandler(error: error),
          result: state.resultOrNull,
        ),
      );
      rethrow;
    }
  }

  void _onStatus(_OnStatusWordPronunciationEvent event,
          Emitter<WordPronunciationState> emit) =>
      switch (event.status) {
        SpeachServiceStatus.listening => emit(
            WordPronunciationState.pronunciation(
                result: state.resultOrNull ?? '')),
        _ => Future<void>.delayed(
            const Duration(milliseconds: 1000),
            () => emit(WordPronunciationState.idle(result: state.resultOrNull)),
          ),
      };

  void _onError(_OnErrorWordPronunciationEvent event,
          Emitter<WordPronunciationState> emit) =>
      emit(
        WordPronunciationState.error(
          errorHandler: ErrorHandler(
            error: SpeechServiceException(event.message),
          ),
          result: state.resultOrNull,
        ),
      );

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
    await _speechService.dispose();
    return super.close();
  }
}
