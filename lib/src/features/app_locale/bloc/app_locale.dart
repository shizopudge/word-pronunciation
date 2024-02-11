import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';
import 'package:word_pronunciation/src/features/app_locale/domain/repository/i_app_locale_repository.dart';

part 'app_locale.freezed.dart';

@freezed
class AppLocaleEvent with _$AppLocaleEvent {
  const factory AppLocaleEvent.read() = _ReadAppLocaleEvent;
  const factory AppLocaleEvent.write(String languageCode) =
      _WriteAppLocaleEvent;
}

@freezed
class AppLocaleState with _$AppLocaleState {
  const AppLocaleState._();

  bool get isIdle => maybeMap(
        orElse: () => false,
        idle: (_) => true,
      );

  const factory AppLocaleState.progress({
    String? languageCode,
  }) = _ProgressAppLocaleState;
  const factory AppLocaleState.idle({
    required final String languageCode,
  }) = _IdleAppLocaleState;
  const factory AppLocaleState.error({
    required final IErrorHandler errorHandler,
    String? languageCode,
  }) = _ErrorAppLocaleState;
}

/// {@template app_locale_bloc}
/// Блок локализации приложения
/// {@endtemplate}
class AppLocaleBloc extends Bloc<AppLocaleEvent, AppLocaleState> {
  /// {@macro app_locale_repository}
  final IAppLocaleRepository _repository;

  /// {@macro app_locale_bloc}
  AppLocaleBloc({required IAppLocaleRepository repository})
      : _repository = repository,
        super(const AppLocaleState.progress()) {
    on<AppLocaleEvent>(
      (event, emit) => event.map(
        read: (event) => _read(event, emit),
        write: (event) => _write(event, emit),
      ),
    );
  }

  void _read(_ReadAppLocaleEvent event, Emitter<AppLocaleState> emit) async {
    emit(AppLocaleState.progress(languageCode: state.languageCode));
    try {
      final languageCode = _repository.readLanguageCodeFromStorage();
      emit(AppLocaleState.progress(languageCode: languageCode));
    } on Object catch (error) {
      emit(
        AppLocaleState.error(
          errorHandler: ErrorHandler(error: error),
          languageCode: state.languageCode,
        ),
      );
      rethrow;
    } finally {
      final languageCode = state.languageCode;
      emit(
        AppLocaleState.idle(
          languageCode: languageCode ?? _repository.defaultLanguageCode,
        ),
      );
    }
  }

  Future<void> _write(
      _WriteAppLocaleEvent event, Emitter<AppLocaleState> emit) async {
    final previousLanguageCode = state.languageCode;
    if (previousLanguageCode == event.languageCode) return;
    emit(AppLocaleState.progress(languageCode: event.languageCode));
    try {
      await _repository
          .writeLanguageCodeToStorage(event.languageCode)
          .timeout(const Duration(seconds: 15));
    } on Object catch (error) {
      emit(
        AppLocaleState.error(
          errorHandler: ErrorHandler(error: error),
          languageCode: previousLanguageCode,
        ),
      );
      rethrow;
    } finally {
      final languageCode = state.languageCode;
      emit(
        AppLocaleState.idle(
          languageCode: languageCode ??
              previousLanguageCode ??
              _repository.defaultLanguageCode,
        ),
      );
    }
  }
}
