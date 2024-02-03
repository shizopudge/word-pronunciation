import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/features/app_theme/domain/entity/app_theme_mode.dart';

/// {@template app_theme_repository}
/// Репозиторий темы приложения
/// {@endtemplate}
@immutable
abstract interface class IAppThemeRepository {
  /// Записывает режим темы в хранилище
  ///
  /// [themeMode] - режим темы [AppThemeMode]
  Future<void>? writeThemeModeToStorage(AppThemeMode themeMode);

  /// Читает режим темы из хранилища
  AppThemeMode readThemeModeFromStorage();
}
