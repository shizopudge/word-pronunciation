import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

/// {@template initialization_progress}
/// Модель прогресса инициализации
/// {@endtemplate}
@immutable
class InitializationProgress extends Equatable {
  /// Сообщение
  final String message;

  /// Прогресс
  final int progress;

  /// {@macro initialization_progress}
  const InitializationProgress({
    required this.message,
    required this.progress,
  });

  InitializationProgress copyWith({
    String? message,
    int? progress,
  }) =>
      InitializationProgress(
        message: message ?? this.message,
        progress: progress ?? this.progress,
      );

  /// Начальный прогресс
  static const initial = InitializationProgress(message: '', progress: 0);

  /// Конечный прогресс
  static const end = InitializationProgress(message: '', progress: 100);

  @override
  String toString() {
    if (message.isEmpty) return '$progress%';
    return '$message - $progress%';
  }

  @override
  List<Object?> get props => [
        message,
        progress,
      ];
}
