import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/core_dependencies.dart';
import 'package:word_pronunciation/src/features/app/domain/repository/i_core_initialization_repository.dart';

part 'core_initialization.freezed.dart';

@freezed
class CoreInitializationEvent with _$CoreInitializationEvent {
  const factory CoreInitializationEvent.initialize() = _InitializeEvent;
}

@freezed
class CoreInitializationState with _$CoreInitializationState {
  const factory CoreInitializationState.progress() =
      _ProgressInitializationState;

  const factory CoreInitializationState.success({
    required final CoreDependencies coreDependencies,
  }) = _SuccessInitializationState;

  const factory CoreInitializationState.error({
    required final IErrorHandler errorHandler,
  }) = _ErrorInitializationState;
}

/// {@template core_initialization_bloc}
/// Блок инициализации основы приложения
/// {@endtemplate}
class CoreInitializationBloc
    extends Bloc<CoreInitializationEvent, CoreInitializationState> {
  final ICoreInitializationRepository _repository;

  /// {@macro core_initialization_bloc}
  CoreInitializationBloc({
    required final ICoreInitializationRepository repository,
  })  : _repository = repository,
        super(const CoreInitializationState.progress()) {
    on<CoreInitializationEvent>(
      (event, emit) => event.map(
        initialize: (event) => _initialize(event, emit),
      ),
    );
  }

  Future<void> _initialize(
    _InitializeEvent event,
    Emitter<CoreInitializationState> emit,
  ) async {
    emit(const CoreInitializationState.progress());
    try {
      final coreDependencies =
          await _repository.initialize().timeout(const Duration(seconds: 90));
      emit(CoreInitializationState.success(coreDependencies: coreDependencies));
    } on Object catch (error) {
      emit(
        CoreInitializationState.error(
          errorHandler: ErrorHandler(error: error),
        ),
      );
      rethrow;
    }
  }
}
