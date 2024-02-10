import 'package:meta/meta.dart';
import 'package:word_pronunciation/src/features/app/data/datasource/core_initialization_datasource.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/core_dependencies.dart';
import 'package:word_pronunciation/src/features/app/domain/repository/i_core_initialization_repository.dart';

@immutable
class CoreInitializationRepository implements ICoreInitializationRepository {
  final ICoreInitializationDatasource _datasource;

  const CoreInitializationRepository({
    required final ICoreInitializationDatasource datasource,
  }) : _datasource = datasource;

  @override
  Future<CoreDependencies> initialize() => _datasource.initialize();
}
