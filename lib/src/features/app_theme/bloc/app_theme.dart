import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:word_pronunciation/src/core/logger/logger.dart';
import 'package:word_pronunciation/src/features/app_theme/domain/entity/app_theme_mode.dart';
import 'package:word_pronunciation/src/features/app_theme/domain/repository/i_app_theme_repository.dart';

part 'app_theme.freezed.dart';

@freezed
class AppThemeEvent with _$AppThemeEvent {
  const factory AppThemeEvent.read() = _ReadAppThemeEvent;
  const factory AppThemeEvent.write(AppThemeMode themeMode) =
      _WriteAppThemeEvent;
}

/// {@template app_theme_bloc}
/// Блок темы приложения
/// {@endtemplate}
class AppThemeBloc extends Bloc<AppThemeEvent, AppThemeMode?> {
  /// {@macro app_theme_repository}
  final IAppThemeRepository _repository;

  /// {@macro app_theme_bloc}
  AppThemeBloc({required IAppThemeRepository repository})
      : _repository = repository,
        super(null) {
    on<AppThemeEvent>(
      (event, emit) => event.map(
        read: (event) => _read(event, emit),
        write: (event) => _write(event, emit),
      ),
    );
  }

  void _read(_ReadAppThemeEvent event, Emitter<AppThemeMode?> emit) =>
      emit(_repository.readThemeModeFromStorage());

  Future<void> _write(
      _WriteAppThemeEvent event, Emitter<AppThemeMode?> emit) async {
    emit(event.themeMode);
    try {
      await _repository
          .writeThemeModeToStorage(event.themeMode)
          ?.timeout(const Duration(seconds: 15));
    } on Object catch (error, stackTrace) {
      L.error(
        error.toString(),
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
