import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';

/// {@template error_handler}
/// Обработчик ошибок
/// {@endtemplate}
@immutable
abstract interface class IErrorHandler extends Equatable {
  /// Ошибка
  final Object error;

  /// {@macro error_handler}
  const IErrorHandler({
    required this.error,
  });

  /// Переводит ошибку в сообщение
  String message(BuildContext context);

  @override
  List<Object> get props => [error];
}

@immutable
class ErrorHandler extends IErrorHandler {
  /// {@macro error_base}
  const ErrorHandler({
    required super.error,
  });

  @override
  String message(BuildContext context) => switch (error.runtimeType) {
        // Если ошибка типа String, тогда возвращает [MessageError]
        const (String) => MessageError(context, error: error as String),

        // Если ошибка типа LocalizedErrorMessage, тогда возвращает [LocalizedMessageError]
        const (LocalizedErrorMessage) =>
          LocalizedMessageError(context, error: error as LocalizedErrorMessage),

        // Если ошибка типа TimeoutException, тогда возвращает [TimeoutError]
        const (TimeoutException) => TimeoutError(
            context,
            error: error as TimeoutException,
          ),

        // Если ошибка типа AppInitializationException, тогда возвращает [AppInitializationError]
        const (AppInitializationException) => AppInitializationError(
            context,
            error: error as AppInitializationException,
          ),

        // Если ошибка типа CoreInitializationException, тогда возвращает [CoreInitializationError]
        const (CoreInitializationException) => CoreInitializationError(
            context,
            error: error as CoreInitializationException,
          ),

        // Если ни одно предыдущее условие не было обработано, то возвращает
        _ => UnknownError(context, error: error),
      }
          .message;
}
