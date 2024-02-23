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
  const IErrorHandler({
    required this.error,
  });

  /// Переводит ошибку в сообщение
  String toMessage(BuildContext context);

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
  String toMessage(BuildContext context) {
    final error = this.error;

    late final IErrorBase errorBase;

    if (error is ErrorMessage) {
      errorBase = MessageError(error: error);
    } else if (error is TimeoutException) {
      errorBase = TimeoutError(error: error);
    } else if (error is AppInitializationException) {
      errorBase = AppInitializationError(error: error);
    } else if (error is CoreInitializationException) {
      errorBase = CoreInitializationError(error: error);
    } else if (error is AudioServiceException) {
      errorBase = AudioServiceError(error: error);
    } else if (error is DioException) {
      errorBase = NetworkError(error: error);
    } else {
      errorBase = UnknownError(error: error);
    }

    return errorBase.toMessage(context);
  }
}
