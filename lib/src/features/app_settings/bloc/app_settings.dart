import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';
import 'package:word_pronunciation/src/features/app_settings/data/model/app_settings.dart';
import 'package:word_pronunciation/src/features/app_settings/domain/repository/i_app_settings_repository.dart';

part 'app_settings.freezed.dart';

@freezed
class AppSettingsEvent with _$AppSettingsEvent {
  const factory AppSettingsEvent.read() = _ReadAppSettingsEvent;

  const factory AppSettingsEvent.write(AppSettings appSettings) =
      _WriteAppSettingsEvent;
}

@freezed
class AppSettingsState with _$AppSettingsState {
  const AppSettingsState._();

  bool get isIdle => maybeMap(
        orElse: () => false,
        idle: (_) => true,
      );

  const factory AppSettingsState.idle({
    required AppSettings appSettings,
  }) = _IdleAppSettingsState;

  const factory AppSettingsState.progress({
    AppSettings? appSettings,
  }) = _ProgressAppSettingsState;

  const factory AppSettingsState.error({
    required IErrorHandler errorHandler,
    AppSettings? appSettings,
  }) = _ErrorAppSettingsState;
}

/// {@template app_settings_bloc}
/// Блок настроек приложения
/// {@endtemplate}
class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  /// {@macro app_settings_repository}
  final IAppSettingsRepository _repository;

  /// {@macro app_settings_bloc}
  AppSettingsBloc({
    required IAppSettingsRepository repository,
  })  : _repository = repository,
        super(const AppSettingsState.progress()) {
    on<AppSettingsEvent>(
      (event, emit) => event.map(
        read: (event) => _read(event, emit),
        write: (event) => _write(event, emit),
      ),
    );
  }

  void _read(_ReadAppSettingsEvent event, Emitter<AppSettingsState> emit) {
    try {
      emit(AppSettingsState.progress(appSettings: state.appSettings));
      final result = _repository.readSettings();
      emit(AppSettingsState.progress(appSettings: result));
    } on Object catch (error) {
      emit(
        AppSettingsState.error(
          appSettings: state.appSettings,
          errorHandler: ErrorHandler(error),
        ),
      );
      rethrow;
    } finally {
      emit(
        AppSettingsState.idle(
          appSettings: state.appSettings ?? _repository.defaultAppSettings,
        ),
      );
    }
  }

  Future<void> _write(
      _WriteAppSettingsEvent event, Emitter<AppSettingsState> emit) async {
    final previousAppSettings = state.appSettings;
    if (previousAppSettings == event.appSettings) return;
    emit(AppSettingsState.progress(appSettings: event.appSettings));
    try {
      await _repository
          .writeSettings(event.appSettings)
          .timeout(const Duration(seconds: 15));
    } on Object catch (error) {
      emit(
        AppSettingsState.error(
          errorHandler: ErrorHandler(error),
          appSettings: previousAppSettings,
        ),
      );
      rethrow;
    } finally {
      final appSettings = state.appSettings;
      emit(
        AppSettingsState.idle(
          appSettings: appSettings ??
              previousAppSettings ??
              _repository.defaultAppSettings,
        ),
      );
    }
  }
}
