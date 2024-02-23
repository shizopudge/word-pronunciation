import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';
import 'package:word_pronunciation/src/core/logger/logger.dart';
import 'package:word_pronunciation/src/features/word/domain/entity/speach_service_status.dart';

/// {@template speech_service}
/// Сервис произношения слов
/// {@endtemplate}
@immutable
abstract interface class ISpeechService {
  /// Инициализирует [ISpeechService]
  Future<void> initialize();

  /// Начинает слушать [ISpeechService]
  Future<void> pronounce();

  /// Останавливает [ISpeechService]
  Future<void> stop();

  /// Уничтожает [ISpeechService]
  Future<void> dispose();

  /// Стрим результатов произношения
  Stream<String> get resultStream;

  /// Стрим статусов
  Stream<SpeachServiceStatus> get statusStream;

  /// Стрим ошибок
  Stream<String> get errorStream;

  /// Возвращает true, если [ISpeechService] инициализирован
  bool get isInitialized;
}

/// {@macro speech_service}
@immutable
class SpeechService implements ISpeechService {
  /// {@macro speech_service}
  const SpeechService();

  /// SpeechToText
  static final _speechToText = SpeechToText();

  /// Стрим контроллер результатов произношения
  static final StreamController<String> _resultStreamController =
      StreamController<String>();

  /// Стрим контроллер статусов
  static final StreamController<SpeachServiceStatus> _statusStreamController =
      StreamController<SpeachServiceStatus>();

  /// Стрим контроллер ошибок
  static final StreamController<String> _errorStreamController =
      StreamController<String>();

  @override
  Future<void> initialize() async {
    // Handling permissions
    try {
      final isAvailable = _speechToText.isAvailable;
      if (isAvailable) return;
      final permissionStatus = await Permission.microphone.status;
      if (!permissionStatus.isGranted) {
        final requestStatus = await Permission.microphone.request();
        if (requestStatus.isPermanentlyDenied) {
          Error.throwWithStackTrace(
            SpeechServicePermissionException(
              FlutterError(
                '[SpeechService] permissions is permanently denied',
              ),
            ),
            StackTrace.current,
          );
        }
        if (requestStatus.isDenied) return;
      }
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong while handling permissions for [SpeechService]. Error: $error',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }

    // Initializing
    try {
      await _speechToText.initialize(onStatus: _onStatus, onError: _onError);
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong while initializing [SpeechService]. Error: $error',
        error: error,
        stackTrace: stackTrace,
      );
      Error.throwWithStackTrace(
        SpeechServiceException(error),
        stackTrace,
      );
    }
  }

  @override
  Future<void> pronounce() {
    try {
      return _speechToText.listen(
        onResult: _onResult,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 15),
        localeId: 'en',
      );
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong while trying to listen to [SpeechService]. Error: $error',
        error: error,
        stackTrace: stackTrace,
      );
      Error.throwWithStackTrace(
        SpeechServiceException(error),
        stackTrace,
      );
    }
  }

  @override
  Future<void> stop() {
    try {
      return _speechToText.stop();
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong while trying to stop [SpeechService]. Error: $error',
        error: error,
        stackTrace: stackTrace,
      );
      Error.throwWithStackTrace(
        SpeechServiceException(error),
        stackTrace,
      );
    }
  }

  @override
  Future<void> dispose() async {
    try {
      await _resultStreamController.close();
      await _statusStreamController.close();
      await _errorStreamController.close();
      await _speechToText.cancel();
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong while disposing [SpeechService]. Error: $error',
        error: error,
        stackTrace: stackTrace,
      );
      Error.throwWithStackTrace(
        SpeechServiceException(error),
        stackTrace,
      );
    }
  }

  /// Слушатель результатов произношения
  void _onResult(SpeechRecognitionResult result) =>
      _resultStreamController.add(result.recognizedWords);

  /// Слушатель ошибок
  void _onError(SpeechRecognitionError error) =>
      _errorStreamController.add(error.errorMsg);

  /// Слушатель статусов
  void _onStatus(String status) =>
      _statusStreamController.add(SpeachServiceStatus.fromString(status));

  @override
  Stream<String> get resultStream => _resultStreamController.stream;

  @override
  Stream<SpeachServiceStatus> get statusStream =>
      _statusStreamController.stream;

  @override
  Stream<String> get errorStream => _errorStreamController.stream;

  @override
  bool get isInitialized => _speechToText.isAvailable;
}
