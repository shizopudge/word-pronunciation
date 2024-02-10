import 'package:meta/meta.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/core_dependencies.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/dependencies.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/initialization_progress.dart';

@immutable
abstract interface class IAppInitializationRepository {
  /// Инициализирует приложение
  ///
  /// [coreDependencies] - основные заивимости приложения
  /// [onProgress] - обработчик на обновление прогресса инициализации
  Future<Dependencies> initialize({
    required final CoreDependencies coreDependencies,
    required final void Function(InitializationProgress initializationProgress)
        onProgress,
  });
}
