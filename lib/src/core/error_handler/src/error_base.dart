import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';

/// {@template error_base}
/// Базовый класс ошибки
/// {@endtemplate}
@immutable
sealed class IErrorBase {
  /// {@macro error_base}
  const IErrorBase();

  /// Возвращает сообщение об ошибке
  String toMessage(BuildContext context);
}

/// {@template message_error}
/// Класс ошибки с сообщением
/// {@endtemplate}
@immutable
final class MessageError implements IErrorBase {
  /// Сообщение об ошибке.
  final ErrorMessage errorMessage;

  /// {@macro message_error}
  const MessageError({
    required this.errorMessage,
  });

  @override
  String toMessage(BuildContext context) => errorMessage.toMessage(context);
}

/// {@template timeout_error}
/// Класс ошибки превышения времени ожидания
/// {@endtemplate}
@immutable
final class TimeoutError implements IErrorBase {
  /// {@macro timeout_error}
  const TimeoutError();

  @override
  String toMessage(BuildContext context) => context.localization.timeoutError;
}

/// {@template app_initialization_error}
/// Класс ошибки инициализации приложения
/// {@endtemplate}
@immutable
final class AppInitializationError implements IErrorBase {
  /// Исключение призошедшее при инициализации приложения
  final AppInitializationException exception;

  /// {@macro app_initialization_error}
  const AppInitializationError({
    required this.exception,
  });

  @override
  String toMessage(BuildContext context) => context.localization
      .appInitializationError(exception.initializationProgress.toString());
}

/// {@template core_initialization_error}
/// Класс ошибки инициализации основы приложения
/// {@endtemplate}
@immutable
final class CoreInitializationError implements IErrorBase {
  /// {@macro core_initialization_error}
  const CoreInitializationError();

  @override
  String toMessage(BuildContext context) =>
      context.localization.coreInitializationError;
}

/// {@template audio_service_error}
/// Класс ошибки аудио сервиса
/// {@endtemplate}
@immutable
final class AudioServiceError implements IErrorBase {
  /// {@macro audio_service_error}
  const AudioServiceError();

  @override
  String toMessage(BuildContext context) =>
      context.localization.audioServiceError;
}

/// {@template speech_service_error}
/// Класс ошибки сервиса произношения
/// {@endtemplate}
@immutable
final class SpeechServiceError implements IErrorBase {
  /// {@macro speech_service_error}
  const SpeechServiceError();

  @override
  String toMessage(BuildContext context) =>
      context.localization.speechServiceError;
}

/// {@template speech_service_permission_error}
/// Класс ошибки разрешений сервиса произношения
/// {@endtemplate}
@immutable
final class SpeechServicePermissionError implements IErrorBase {
  /// {@macro speech_service_permission_error}
  const SpeechServicePermissionError();

  @override
  String toMessage(BuildContext context) =>
      context.localization.speechServicePermissionError;
}

/// {@template network_error}
/// Класс ошибки с сетью
/// {@endtemplate}
@immutable
final class NetworkError implements IErrorBase {
  /// Исключение DIO
  final DioException dioException;

  /// {@macro network_error}
  const NetworkError({
    required this.dioException,
  });

  @override
  String toMessage(BuildContext context) => switch (dioException.type) {
        DioExceptionType.connectionTimeout =>
          context.localization.connectionTimeout,
        DioExceptionType.sendTimeout => context.localization.sendTimeout,
        DioExceptionType.receiveTimeout => context.localization.receiveTimeout,
        DioExceptionType.badCertificate => context.localization.badCertificate,
        DioExceptionType.badResponse => context.localization.badResponse,
        DioExceptionType.cancel => context.localization.requestCancel,
        DioExceptionType.connectionError =>
          context.localization.connectionError,
        DioExceptionType.unknown => context.localization.unknownNetworkError,
      };
}

/// {@template unknown_error}
/// Класс неизвестной ошибки
/// {@endtemplate}
@immutable
final class UnknownError implements IErrorBase {
  /// {@macro unknown_error}
  const UnknownError();

  @override
  String toMessage(BuildContext context) =>
      context.localization.unknownErrorOccurred;
}
