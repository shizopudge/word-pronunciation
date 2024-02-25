import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';
import 'package:word_pronunciation/src/features/word/domain/entity/audio_state.dart';
import 'package:word_pronunciation/src/features/word/domain/service/audio_service.dart';

part 'word_audio.freezed.dart';

@freezed
class WordAudioEvent with _$WordAudioEvent {
  const factory WordAudioEvent.play({
    required final String audioUrl,
  }) = _PlayWordAudioEvent;

  const factory WordAudioEvent.stop() = _StopWordAudioEvent;

  const factory WordAudioEvent.setIdleState() = _SetIdleStateWordAudioEvent;

  const factory WordAudioEvent.setPlayingState() =
      _SetPlayingStateWordAudioEvent;
}

@freezed
class WordAudioState with _$WordAudioState {
  const WordAudioState._();

  bool get isProgress => maybeMap(
        orElse: () => false,
        progress: (_) => true,
      );

  bool get isPlaying => maybeMap(
        orElse: () => false,
        playing: (_) => true,
      );

  bool get isError => maybeMap(
        orElse: () => false,
        error: (_) => true,
      );

  String? get audioUrlOrNull => map(
        idle: (_) => null,
        progress: (progress) => progress.audioUrl,
        playing: (playing) => playing.audioUrl,
        stopped: (stopped) => stopped.audioUrl,
        error: (error) => error.audioUrl,
      );

  const factory WordAudioState.idle() = _IdleWordAudioState;

  const factory WordAudioState.progress({
    required final String audioUrl,
  }) = _ProgressWordAudioState;

  const factory WordAudioState.playing({
    required final String audioUrl,
  }) = _PlayingWordAudioState;

  const factory WordAudioState.stopped({
    required final String audioUrl,
  }) = _StoppedWordAudioState;

  const factory WordAudioState.error({
    required final IErrorHandler errorHandler,
    final String? audioUrl,
  }) = _ErrorWordAudioState;
}

/// {@template word_audio_bloc}
/// Блок аудио слова
/// {@endtemplate}
class WordAudioBloc extends Bloc<WordAudioEvent, WordAudioState> {
  /// {@macro audio_service}
  final IAudioService _audioService;

  /// Подписка на стрим изменения состояний плеера
  late final StreamSubscription<AudioState> _playerStateStreamSubscription;

  /// {@macro word_audio_bloc}
  WordAudioBloc({required final IAudioService audioService})
      : _audioService = audioService,
        super(const WordAudioState.idle()) {
    _playerStateStreamSubscription = _audioService.playerStateStream.listen(
      (audioState) => switch (audioState) {
        AudioState.ready => add(const WordAudioEvent.setPlayingState()),
        AudioState.completed => add(const WordAudioEvent.setIdleState()),
        _ => null,
      },
    );
    on<WordAudioEvent>(
      (event, emit) => event.map(
        play: (event) => _play(event, emit),
        stop: (event) => _stop(event, emit),
        setIdleState: (_) => _setIdleState(emit),
        setPlayingState: (_) => _setPlayingState(emit),
      ),
    );
  }

  Future<void> _play(
      _PlayWordAudioEvent event, Emitter<WordAudioState> emit) async {
    if (state.isProgress) return;
    final audioUrl = event.audioUrl;
    try {
      emit(WordAudioState.progress(audioUrl: audioUrl));
      if (state.isPlaying) {
        await _audioService.stop().timeout(const Duration(seconds: 15));
      }
      await _audioService
          .playFromNetwork(audioUrl)
          .timeout(const Duration(seconds: 15));
    } on Object catch (error) {
      emit(
        WordAudioState.error(
          errorHandler: ErrorHandler(error: error),
        ),
      );
      rethrow;
    }
  }

  Future<void> _stop(
      _StopWordAudioEvent event, Emitter<WordAudioState> emit) async {
    final audioUrl = state.audioUrlOrNull;
    try {
      if (audioUrl != null) {
        emit(WordAudioState.progress(audioUrl: audioUrl));
      }
      await _audioService.stop().timeout(const Duration(seconds: 15));
      if (audioUrl != null) {
        emit(WordAudioState.stopped(audioUrl: audioUrl));
      }
    } on Object catch (error) {
      emit(
        WordAudioState.error(
          errorHandler: ErrorHandler(error: error),
        ),
      );
      rethrow;
    }
  }

  void _setIdleState(Emitter<WordAudioState> emit) =>
      emit(const WordAudioState.idle());

  void _setPlayingState(Emitter<WordAudioState> emit) {
    final audioUrl = state.audioUrlOrNull;
    if (audioUrl != null) {
      emit(WordAudioState.playing(audioUrl: audioUrl));
    } else {
      emit(const WordAudioState.idle());
    }
  }

  @override
  Future<void> close() async {
    await _playerStateStreamSubscription.cancel();
    return super.close();
  }
}
