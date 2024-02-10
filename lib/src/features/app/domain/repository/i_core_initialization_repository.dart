import 'package:meta/meta.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/core_dependencies.dart';

@immutable
abstract interface class ICoreInitializationRepository {
  /// Инициализирует основные зависимости приложения
  Future<CoreDependencies> initialize();
}
