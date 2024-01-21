import 'package:meta/meta.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/dependencies.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/initialization_progress.dart';

@immutable
abstract interface class IAppInitializationRepository {
  /// Инициализирует приложение
  ///
  /// [onProgress] - обработчик на обновление прогресса инициализации
  Future<Dependencies> initialize({
    required final void Function(InitializationProgress initializationProgress)
        onProgress,
  });
}
