import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';

/// {@template error_base}
/// Обработчик ошибок
/// {@endtemplate}
@immutable
abstract interface class IErrorHandler extends Equatable {
  /// Ошибка
  final Object error;

  /// {@macro error_base}
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
        const (String) => MessageError(error: error as String),

        // Если ошибка типа TimeoutException, тогда возвращает [TimeoutError]
        const (TimeoutException) => TimeoutError(
            context: context,
            error: error as TimeoutException,
          ),

        // Если ошибка типа AppInitializationError, тогда возвращает [AppInitializationError]
        const (AppInitializationException) => AppInitializationError(
            context: context,
            error: error as AppInitializationException,
          ),

        // Если ни одно предыдущее условие не было обработано, то возвращает
        _ => UnknownError(context: context, error: error),
      }
          .message;
}
