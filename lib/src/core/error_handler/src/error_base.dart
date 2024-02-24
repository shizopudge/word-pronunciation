import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';

/// {@template error_base}
/// Базовый класс ошибки
/// {@endtemplate}
@immutable
sealed class IErrorBase {
  /// Ошибка
  final Object? error;

  /// {@macro error_base}
  const IErrorBase({
    required this.error,
  });

  /// Возвращает сообщение об ошибке
  String toMessage(BuildContext context);
}

/// {@template message_error}
/// Класс ошибки с сообщением
/// {@endtemplate}
@immutable
final class MessageError implements IErrorBase {
  @override
  final ErrorMessage error;

  /// {@macro message_error}
  const MessageError({
    required this.error,
  });

  @override
  String toMessage(BuildContext context) => error.toMessage(context);
}

/// {@template timeout_error}
/// Класс ошибки превышения времени ожидания
/// {@endtemplate}
@immutable
final class TimeoutError implements IErrorBase {
  @override
  final TimeoutException error;

  /// {@macro timeout_error}
  const TimeoutError({
    required this.error,
  });

  @override
  String toMessage(BuildContext context) => context.localization.timeoutError;
}

/// {@template app_initialization_error}
/// Класс ошибки инициализации приложения
/// {@endtemplate}
@immutable
final class AppInitializationError implements IErrorBase {
  @override
  final AppInitializationException error;

  /// {@macro app_initialization_error}
  const AppInitializationError({
    required this.error,
  });

  @override
  String toMessage(BuildContext context) => context.localization
      .appInitializationError(error.initializationProgress.toString());
}

/// {@template core_initialization_error}
/// Класс ошибки инициализации основы приложения
/// {@endtemplate}
@immutable
final class CoreInitializationError implements IErrorBase {
  @override
  final CoreInitializationException error;

  /// {@macro core_initialization_error}
  const CoreInitializationError({
    required this.error,
  });

  @override
  String toMessage(BuildContext context) =>
      context.localization.coreInitializationError;
}

/// {@template audio_service_error}
/// Класс ошибки аудио сервиса
/// {@endtemplate}
@immutable
final class AudioServiceError implements IErrorBase {
  @override
  final AudioServiceException error;

  /// {@macro audio_service_error}
  const AudioServiceError({
    required this.error,
  });

  @override
  String toMessage(BuildContext context) =>
      context.localization.audioServiceError;
}

/// {@template speech_service_error}
/// Класс ошибки сервиса произношения
/// {@endtemplate}
@immutable
final class SpeechServiceError implements IErrorBase {
  @override
  final SpeechServiceException error;

  /// {@macro speech_service_error}
  const SpeechServiceError({
    required this.error,
  });

  @override
  String toMessage(BuildContext context) =>
      context.localization.speechServiceError;
}

/// {@template speech_service_permission_error}
/// Класс ошибки разрешений сервиса произношения
/// {@endtemplate}
@immutable
final class SpeechServicePermissionError implements IErrorBase {
  @override
  final SpeechServiceException error;

  /// {@macro speech_service_permission_error}
  const SpeechServicePermissionError({
    required this.error,
  });

  @override
  String toMessage(BuildContext context) =>
      context.localization.speechServicePermissionError;
}

/// {@template network_error}
/// Класс ошибки с сетью
/// {@endtemplate}
@immutable
final class NetworkError implements IErrorBase {
  @override
  final DioException error;

  /// {@macro network_error}
  const NetworkError({
    required this.error,
  });

  @override
  String toMessage(BuildContext context) => switch (error.type) {
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
  @override
  final Object? error;

  /// {@macro unknown_error}
  const UnknownError({
    required this.error,
  });

  @override
  String toMessage(BuildContext context) =>
      context.localization.unknownErrorOccurred;
}
