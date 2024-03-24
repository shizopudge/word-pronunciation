import 'dart:async';

import 'package:dio/dio.dart';
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
  const IErrorHandler(this.error);

  /// Переводит ошибку в сообщение
  String toMessage(BuildContext context);

  @override
  List<Object> get props => [error];
}

@immutable
class ErrorHandler extends IErrorHandler {
  /// {@macro error_base}
  const ErrorHandler(super.error);

  @override
  String toMessage(BuildContext context) {
    final error = this.error;

    late final IErrorBase errorBase;

    if (error is ErrorMessage) {
      errorBase = MessageError(errorMessage: error);
    } else if (error is TimeoutException) {
      errorBase = const TimeoutError();
    } else if (error is AppInitializationException) {
      errorBase = AppInitializationError(exception: error);
    } else if (error is CoreInitializationException) {
      errorBase = const CoreInitializationError();
    } else if (error is AudioServiceException) {
      errorBase = const AudioServiceError();
    } else if (error is SpeechServiceException) {
      errorBase = const SpeechServiceError();
    } else if (error is DioException) {
      errorBase = NetworkError(dioException: error);
    } else {
      errorBase = const UnknownError();
    }

    return errorBase.toMessage(context);
  }
}
