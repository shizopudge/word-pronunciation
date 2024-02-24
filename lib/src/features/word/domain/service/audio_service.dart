import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';
import 'package:word_pronunciation/src/core/logger/logger.dart';
import 'package:word_pronunciation/src/features/word/domain/entity/audio_state.dart';

/// {@template audio_service}
/// Сервис проигрывания аудио
/// {@endtemplate}
@immutable
abstract interface class IAudioService {
  /// Проигрывает аудио из сети
  Future<void> playFromNetwork(String url);

  /// Останавливает проигрывание
  Future<void> stop();

  /// Уничтожает плеер
  Future<void> dispose();

  /// Возвращает стрим состояний плеера
  Stream<AudioState> get playerStateStream;
}

/// {@macro audio_service}
@immutable
class AudioService implements IAudioService {
  /// {@macro audio_service}
  const AudioService();

  /// Плеер
  static final _player = AudioPlayer();

  @override
  Future<void> playFromNetwork(String url) async {
    try {
      final src = AudioSource.uri(Uri.parse(url));
      await _player.setAudioSource(src);
      return _player.play();
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong while playing audio from network. Error: $error',
        error: error,
        stackTrace: stackTrace,
      );
      Error.throwWithStackTrace(
        AudioServiceException(error.toString()),
        stackTrace,
      );
    }
  }

  @override
  Future<void> stop() async {
    try {
      final isPlaying = _player.playing;
      if (isPlaying) return _player.stop();
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong while stopping [AudioService]. Error: $error',
        error: error,
        stackTrace: stackTrace,
      );
      Error.throwWithStackTrace(
        AudioServiceException(error.toString()),
        stackTrace,
      );
    }
  }

  @override
  Future<void> dispose() {
    try {
      return _player.dispose();
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong while disposing [AudioService]. Error: $error',
        error: error,
        stackTrace: stackTrace,
      );
      Error.throwWithStackTrace(
        AudioServiceException(error.toString()),
        stackTrace,
      );
    }
  }

  @override
  Stream<AudioState> get playerStateStream =>
      _player.playerStateStream.map<AudioState>(
        (playerState) => switch (playerState.processingState) {
          ProcessingState.idle => AudioState.idle,
          ProcessingState.loading => AudioState.loading,
          ProcessingState.buffering => AudioState.buffering,
          ProcessingState.ready => AudioState.ready,
          ProcessingState.completed => AudioState.completed,
        },
      );
}
