import 'dart:async';

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

  /// Контекст
  final BuildContext context;

  /// {@macro error_base}
  const IErrorBase(
    this.context, {
    required this.error,
  });

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

  @override
  final BuildContext context;

  /// {@macro message_error}
  const MessageError(
    this.context, {
    required this.error,
  });

  @override
  String get message => error;
}

/// {@template localized_message_error}
/// Класс ошибки с локализованным сообщением
/// {@endtemplate}
@immutable
final class LocalizedMessageError implements IErrorBase {
  @override
  final LocalizedErrorMessage error;

  @override
  final BuildContext context;

  /// {@macro localized_message_error}
  const LocalizedMessageError(
    this.context, {
    required this.error,
  });

  @override
  String get message => error.message(context);
}

/// {@template timeout_error}
/// Класс ошибки превышения времени ожидания
/// {@endtemplate}
@immutable
final class TimeoutError implements IErrorBase {
  @override
  final TimeoutException error;

  @override
  final BuildContext context;

  /// {@macro timeout_error}
  const TimeoutError(
    this.context, {
    required this.error,
  });

  @override
  String get message =>
      context.localization?.timeoutError ?? 'Wait time exceeded';
}

/// {@template app_initialization_error}
/// Класс ошибки инициализации приложения
/// {@endtemplate}
@immutable
final class AppInitializationError implements IErrorBase {
  @override
  final AppInitializationException error;

  @override
  final BuildContext context;

  /// {@macro app_initialization_error}
  const AppInitializationError(
    this.context, {
    required this.error,
  });

  @override
  String get message =>
      context.localization
          ?.appInitializationError(error.initializationProgress.toString()) ??
      'An error occurred while creating the application.\n'
          'Progress: ${error.initializationProgress}';
}

/// {@template core_initialization_error}
/// Класс ошибки инициализации основы приложения
/// {@endtemplate}
@immutable
final class CoreInitializationError implements IErrorBase {
  @override
  final CoreInitializationException error;

  @override
  final BuildContext context;

  /// {@macro core_initialization_error}
  const CoreInitializationError(
    this.context, {
    required this.error,
  });

  @override
  String get message =>
      context.localization?.coreInitializationError ??
      'An error occurred while initializing the application core';
}

/// {@template unknown_error}
/// Класс неизвестной ошибки
/// {@endtemplate}
@immutable
final class UnknownError implements IErrorBase {
  @override
  final Object? error;

  @override
  final BuildContext context;

  /// {@macro unknown_error}
  const UnknownError(
    this.context, {
    required this.error,
  });

  @override
  String get message =>
      context.localization?.unknownErrorOccurred ?? 'An unknown error occurred';
}
