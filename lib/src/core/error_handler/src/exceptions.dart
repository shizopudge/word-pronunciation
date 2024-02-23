import 'package:word_pronunciation/src/features/app/domain/entity/initialization_progress.dart';

/// {@template app_initialization_exception}
/// Выбрасывается при ошибке в инициализации приложения
/// {@endtemplate}
class AppInitializationException implements Exception {
  /// {@macro initialization_progress}
  final InitializationProgress initializationProgress;

  /// {@macro app_initialization_exception}
  const AppInitializationException({required this.initializationProgress});

  @override
  String toString() => 'AppInitializationException: $initializationProgress';
}

/// {@template core_initialization_exception}
/// Выбрасывается при ошибке в инициализации основы приложения
/// {@endtemplate}
class CoreInitializationException implements Exception {
  /// Исключение
  final Object? exception;

  /// {@macro core_initialization_exception}
  const CoreInitializationException(this.exception);

  @override
  String toString() => 'CoreInitializationException: $exception';
}

/// {@template audio_service_exception}
/// Выбрасывается при ошибке в аудио сервисе
/// {@endtemplate}
class AudioServiceException implements Exception {
  /// Исключение
  final Object? exception;

  /// {@macro audio_service_exception}
  const AudioServiceException(this.exception);

  @override
  String toString() => 'AudioServiceException: $exception';
}

/// {@template speech_service_exception}
/// Выбрасывается при ошибке в сервисе произношения
/// {@endtemplate}
class SpeechServiceException implements Exception {
  /// Исключение
  final Object? exception;

  /// {@macro speech_service_exception}
  const SpeechServiceException(this.exception);

  @override
  String toString() => 'SpeechServiceException: $exception';
}

/// {@template speech_service_permission_exception}
/// Выбрасывается при ошибке с разрешениями в сервисе произношения
/// {@endtemplate}
class SpeechServicePermissionException implements Exception {
  /// Исключение
  final Object? exception;

  /// {@macro speech_service_permission_exception}
  const SpeechServicePermissionException(this.exception);

  @override
  String toString() => 'SpeechServicePermissionException: $exception';
}
