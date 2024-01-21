import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:word_pronunciation/src/core/logger/logger.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/dependencies.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/initialization_progress.dart';
import 'package:word_pronunciation/src/features/app/domain/repository/i_app_initialization_repository.dart';

part 'app_initialization.freezed.dart';

@freezed
class AppInitializationEvent with _$AppInitializationEvent {
  const factory AppInitializationEvent.initialize() = _InitializeEvent;
}

@freezed
class AppInitializationState with _$AppInitializationState {
  const factory AppInitializationState.progress({
    @Default(InitializationProgress.initial)
    final InitializationProgress initializationProgress,
    final Dependencies? dependencies,
  }) = _ProgressInitializationState;

  const factory AppInitializationState.success({
    required final InitializationProgress initializationProgress,
    required final Dependencies dependencies,
  }) = _SuccessInitializationState;

  const factory AppInitializationState.error({
    required final String message,
    required final InitializationProgress initializationProgress,
    final Dependencies? dependencies,
  }) = _ErrorInitializationState;
}

/// {@template app_initialization_bloc}
/// Блок инициализации приложения
/// {@endtemplate}
class AppInitializationBloc
    extends Bloc<AppInitializationEvent, AppInitializationState> {
  final IAppInitializationRepository _repository;

  /// {@macro app_initialization_bloc}
  AppInitializationBloc({
    required final IAppInitializationRepository repository,
  })  : _repository = repository,
        super(const AppInitializationState.progress()) {
    on<AppInitializationEvent>(
      (event, emit) => event.map(
        initialize: (event) => _initialize(event, emit),
      ),
    );
  }

  Future<void> _initialize(
    _InitializeEvent event,
    Emitter<AppInitializationState> emit,
  ) async {
    emit(const AppInitializationState.progress());
    try {
      final dependencies = await _repository.initialize(
        onProgress: (initializationProgress) => emit(
          AppInitializationState.progress(
            initializationProgress: initializationProgress,
          ),
        ),
      );
      emit(
        AppInitializationState.progress(
          initializationProgress: InitializationProgress.end,
          dependencies: dependencies,
        ),
      );
    } on Object catch (error, stackTrace) {
      final message = 'An error occurred during application initialization. '
          'Progress: ${state.initializationProgress}';
      emit(
        AppInitializationState.error(
          message: message,
          initializationProgress: state.initializationProgress,
        ),
      );
      L.error(
        message,
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    } finally {
      final dependencies = state.dependencies;
      if (dependencies != null) {
        emit(
          AppInitializationState.success(
            initializationProgress: InitializationProgress.end,
            dependencies: dependencies,
          ),
        );
      }
    }
  }
}
