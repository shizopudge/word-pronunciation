import 'package:meta/meta.dart';
import 'package:word_pronunciation/src/features/app/data/datasource/app_initialization_datasource.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/dependencies.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/initialization_progress.dart';
import 'package:word_pronunciation/src/features/app/domain/repository/i_app_initialization_repository.dart';

@immutable
class AppInitializationRepository implements IAppInitializationRepository {
  final IAppInitializationDatasource _datasource;

  const AppInitializationRepository({
    required final IAppInitializationDatasource datasource,
  }) : _datasource = datasource;

  @override
  Future<Dependencies> initialize({
    required final CoreDependencies coreDependencies,
    required final void Function(InitializationProgress initializationProgress)
        onProgress,
  }) =>
      _datasource.initialize(
          coreDependencies: coreDependencies, onProgress: onProgress);
}
