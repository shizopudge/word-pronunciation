import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';
import 'package:word_pronunciation/src/features/app_theme/domain/entity/app_theme_mode.dart';
import 'package:word_pronunciation/src/features/app_theme/domain/repository/i_app_theme_repository.dart';

part 'app_theme.freezed.dart';

@freezed
class AppThemeEvent with _$AppThemeEvent {
  const factory AppThemeEvent.read() = _ReadAppThemeEvent;
  const factory AppThemeEvent.write(AppThemeMode appThemeMode) =
      _WriteAppThemeEvent;
}

@freezed
class AppThemeState with _$AppThemeState {
  const AppThemeState._();

  bool get isError => maybeMap(
        orElse: () => false,
        error: (_) => true,
      );

  bool get isIdle => maybeMap(
        orElse: () => false,
        idle: (_) => true,
      );

  const factory AppThemeState.progress({
    AppThemeMode? appThemeMode,
  }) = _ProgressAppThemeState;
  const factory AppThemeState.idle({
    required final AppThemeMode appThemeMode,
  }) = _IdleAppThemeState;
  const factory AppThemeState.error({
    required final IErrorHandler errorHandler,
    AppThemeMode? appThemeMode,
  }) = _ErrorAppThemeState;
}

/// {@template app_theme_bloc}
/// Блок темы приложения
/// {@endtemplate}
class AppThemeBloc extends Bloc<AppThemeEvent, AppThemeState> {
  /// {@macro app_theme_repository}
  final IAppThemeRepository _repository;

  /// {@macro app_theme_bloc}
  AppThemeBloc({required IAppThemeRepository repository})
      : _repository = repository,
        super(const AppThemeState.progress()) {
    on<AppThemeEvent>(
      (event, emit) => event.map(
        read: (event) => _read(event, emit),
        write: (event) => _write(event, emit),
      ),
    );
  }

  void _read(_ReadAppThemeEvent event, Emitter<AppThemeState> emit) async {
    // TODO(Рустам Курмантаев): Убрать на релизе
    await Future<void>.delayed(const Duration(milliseconds: 500));
    emit(AppThemeState.progress(appThemeMode: state.appThemeMode));
    try {
      final appThemeMode = _repository.readAppThemeModeFromStorage();
      emit(AppThemeState.progress(appThemeMode: appThemeMode));
    } on Object catch (error) {
      emit(
        AppThemeState.error(
          errorHandler: ErrorHandler(error: error),
          appThemeMode: state.appThemeMode,
        ),
      );
      rethrow;
    } finally {
      final appThemeMode = state.appThemeMode;
      emit(
        AppThemeState.idle(
          appThemeMode: appThemeMode ?? _repository.defaultAppThemeMode,
        ),
      );
    }
  }

  Future<void> _write(
      _WriteAppThemeEvent event, Emitter<AppThemeState> emit) async {
    final previousAppThemeMode = state.appThemeMode;
    if (previousAppThemeMode == event.appThemeMode) return;
    emit(AppThemeState.progress(appThemeMode: event.appThemeMode));
    try {
      await _repository
          .writeAppThemeModeToStorage(event.appThemeMode)
          .timeout(const Duration(seconds: 15));
    } on Object catch (error) {
      emit(
        AppThemeState.error(
          errorHandler: ErrorHandler(error: error),
          appThemeMode: previousAppThemeMode,
        ),
      );
      rethrow;
    } finally {
      final appThemeMode = state.appThemeMode;
      emit(
        AppThemeState.idle(
          appThemeMode: appThemeMode ??
              previousAppThemeMode ??
              _repository.defaultAppThemeMode,
        ),
      );
    }
  }
}
