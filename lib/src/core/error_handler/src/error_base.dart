import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/initialization_progress.dart';

/// {@template error_base}
/// Базовый класс ошибки
/// {@endtemplate}
@immutable
abstract interface class IErrorBase extends Equatable {
  /// Ошибка
  final Object error;

  /// {@macro error_base}
  const IErrorBase({
    required this.error,
  });

  /// Переводит ошибку в сообщение
  String message(BuildContext context);

  @override
  List<Object?> get props => [error];
}

/// {@template message_error}
/// Класс ошибки с сообщением
/// {@endtemplate}
@immutable
class MessageError extends IErrorBase {
  /// {@macro message_error}
  const MessageError({required super.error});

  @override
  String message(BuildContext context) => error.toString();
}

/// {@template timeout_error}
/// Класс ошибки превышения времени ожидания
/// {@endtemplate}
@immutable
class TimeoutError extends IErrorBase {
  /// {@macro timeout_error}
  const TimeoutError({required super.error});

  @override
  String message(BuildContext context) => 'Превышено время ожидания';
}

/// {@template unknown_error}
/// Класс неизвестной ошибки
/// {@endtemplate}
@immutable
class UnknownError extends IErrorBase {
  /// {@macro unknown_error}
  const UnknownError({required super.error});

  @override
  String message(BuildContext context) => 'Произошла неизвестная ошибка';
}

/// {@template app_initialization_error}
/// Класс ошибки инициализации приложения
/// {@endtemplate}
@immutable
class AppInitializationError extends IErrorBase {
  /// {@macro initialization_progress}
  final InitializationProgress initializationProgress;

  /// {@macro app_initialization_error}
  const AppInitializationError({
    required this.initializationProgress,
    required super.error,
  });

  @override
  String message(BuildContext context) =>
      'Произошла ошибка во время инициализации приложения. '
      'Прогресс: $initializationProgress';

  @override
  List<Object?> get props => [
        initializationProgress,
        ...super.props,
      ];
}
