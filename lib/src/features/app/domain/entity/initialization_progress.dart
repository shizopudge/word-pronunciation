import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/app_initialization_step.dart';

/// {@template initialization_progress}
/// Модель прогресса инициализации
/// {@endtemplate}
@immutable
class InitializationProgress extends Equatable {
  /// Сообщение
  final AppInitializationStep step;

  /// Прогресс
  final int progress;

  /// {@macro initialization_progress}
  const InitializationProgress({
    required this.step,
    required this.progress,
  });

  InitializationProgress copyWith({
    AppInitializationStep? step,
    int? progress,
  }) =>
      InitializationProgress(
        step: step ?? this.step,
        progress: progress ?? this.progress,
      );

  /// Начальный прогресс
  static const start =
      InitializationProgress(step: AppInitializationStep.start, progress: 0);

  /// Конечный прогресс
  static const end =
      InitializationProgress(step: AppInitializationStep.end, progress: 100);

  /// Возвращает локализованное сообщение
  String message(BuildContext context) => step.message(context);

  @override
  String toString() => 'AppInitializationStep: $step, Progress: $progress';

  @override
  List<Object?> get props => [
        step,
        progress,
      ];
}
