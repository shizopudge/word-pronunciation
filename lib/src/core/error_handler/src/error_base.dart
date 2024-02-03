import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';

/// {@template error_base}
/// Базовый класс ошибки
/// {@endtemplate}
@immutable
sealed class IErrorBase {
  /// Ошибка
  final Object? error;

  /// {@macro error_base}
  const IErrorBase({required this.error});

  /// Возвращает сообщение об ошибке
  String get message;
}

/// {@template message_error}
/// Класс ошибки с сообщением
/// {@endtemplate}
@immutable
final class MessageError implements IErrorBase {
  @override
  final String error;

  /// {@macro message_error}
  const MessageError({required this.error});

  @override
  String get message => error;
}

/// {@template timeout_error}
/// Класс ошибки превышения времени ожидания
/// {@endtemplate}
@immutable
final class TimeoutError implements IErrorBase {
  @override
  final TimeoutException error;

  /// Контекст
  final BuildContext context;

  /// {@macro timeout_error}
  const TimeoutError({
    required this.error,
    required this.context,
  });

  @override
  String get message => 'Превышено время ожидания';
}

/// {@template app_initialization_error}
/// Класс ошибки инициализации приложения
/// {@endtemplate}
@immutable
final class AppInitializationError implements IErrorBase {
  @override
  final AppInitializationException error;

  /// Контекст
  final BuildContext context;

  /// {@macro app_initialization_error}
  const AppInitializationError({
    required this.error,
    required this.context,
  });

  @override
  String get message => 'Произошла ошибка во время инициализации приложения. '
      'Прогресс: ${error.initializationProgress}';
}

/// {@template app_initialization_error}
/// Класс ошибки инициализации приложения
/// {@endtemplate}
@immutable
final class CoreInitializationError implements IErrorBase {
  @override
  final CoreInitializationException error;

  /// Контекст
  final BuildContext context;

  /// {@macro app_initialization_error}
  const CoreInitializationError({
    required this.error,
    required this.context,
  });

  @override
  String get message =>
      'Произошла ошибка во время инициализации основы приложения';
}

/// {@template unknown_error}
/// Класс неизвестной ошибки
/// {@endtemplate}
@immutable
final class UnknownError implements IErrorBase {
  @override
  final Object? error;

  /// Контекст
  final BuildContext context;

  /// {@macro unknown_error}
  const UnknownError({
    required this.error,
    required this.context,
  });

  @override
  String get message => 'Произошла неизвестная ошибка';
}
