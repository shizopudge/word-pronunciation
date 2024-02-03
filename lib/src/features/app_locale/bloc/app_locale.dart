import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_locale.freezed.dart';

@freezed
class AppLocaleEvent with _$AppLocaleEvent {
  const factory AppLocaleEvent.set({
    required Locale locale,
  }) = _SetAppLocaleEvent;
}

/// {@template app_locale_bloc}
/// Блок локализации приложения
/// {@endtemplate}
class AppLocaleBloc extends Bloc<AppLocaleEvent, Locale?> {
  /// {@macro app_theme_bloc}
  AppLocaleBloc() : super(null) {
    on<AppLocaleEvent>(
      (event, emit) => event.map(
        set: (event) => _set(event, emit),
      ),
    );
  }

  void _set(AppLocaleEvent event, Emitter<Locale?> emit) => emit(event.locale);
}
