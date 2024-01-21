import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

/// Экземпляр логгера
final _logger = Logger();

/// {@template logger}
/// Логгер
/// {@endtemplate}
@immutable
class L {
  /// {@macro logger}
  const L._();

  /// Логирование обычного сообщения
  static void log(
    String message, {
    DateTime? time,
  }) =>
      _logger.d(
        message,
        time: time ?? DateTime.now(),
      );

  /// Логирование ошибки
  static void error(
    String message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logger.e(
        message,
        time: time ?? DateTime.now(),
        error: error,
        stackTrace: stackTrace,
      );

  /// Метод вызывающийся при удалении из дерева навсегда
  static Future<void> dispose() async {
    if (_isClosed) return;
    await _logger.close();
  }

  /// Возвращает true, если логгер закрыт или null
  static bool get _isClosed => _logger.isClosed();
}
