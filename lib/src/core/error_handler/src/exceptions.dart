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
  /// Сообщение
  final String? message;

  /// {@macro core_initialization_exception}
  const CoreInitializationException(this.message);

  @override
  String toString() => 'CoreInitializationException: $message';
}

/// {@template audio_service_exception}
/// Выбрасывается при ошибке в аудио сервисе
/// {@endtemplate}
class AudioServiceException implements Exception {
  /// Сообщение
  final String? message;

  /// {@macro audio_service_exception}
  const AudioServiceException(this.message);

  @override
  String toString() => 'AudioServiceException: $message';
}

/// {@template speech_service_exception}
/// Выбрасывается при ошибке в сервисе произношения
/// {@endtemplate}
class SpeechServiceException implements Exception {
  /// Сообщение
  final String? message;

  /// {@macro speech_service_exception}
  const SpeechServiceException(this.message);

  @override
  String toString() => 'SpeechServiceException: $message';

  bool get isNoMatch => message == 'error_no_match';

  bool get isSpeechTimeout => message == 'error_speech_timeout';
}

/// {@template speech_service_permission_exception}
/// Выбрасывается при ошибке с разрешениями в сервисе произношения
/// {@endtemplate}
class SpeechServicePermissionException implements Exception {
  /// Сообщение
  final String? message;

  /// {@macro speech_service_permission_exception}
  const SpeechServicePermissionException(this.message);

  @override
  String toString() => 'SpeechServicePermissionException: $message';

  bool get isPermanentlyDenied => message == 'permissions_permanently_denied';
}
