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
  final IErrorBase error;

  /// {@macro error_base}
  const IErrorHandler({
    required this.error,
  });

  /// Переводит ошибку в сообщение
  String message(BuildContext context);

  @override
  List<Object?> get props => [error];
}

@immutable
class ErrorHandler extends IErrorHandler {
  /// {@macro error_base}
  const ErrorHandler({
    required super.error,
  });

  @override
  String message(BuildContext context) {
    // Если ошибка типа String, тогда возвращает [MessageError]
    if (error is String) {
      return MessageError(error: error).message(context);
    }

    // Если ошибка типа TimeoutException, тогда возвращает [TimeoutError]
    if (error is TimeoutException) {
      return TimeoutError(error: error).message(context);
    }

    // Если ошибка типа AppInitializationError, тогда возвращает [AppInitializationError.message]
    if (error is AppInitializationError) {
      return error.message(context);
    }

    // Если ни одно предыдущее условие не было обработано, то возвращает
    // UnknownError
    return UnknownError(error: error).message(context);
  }
}
