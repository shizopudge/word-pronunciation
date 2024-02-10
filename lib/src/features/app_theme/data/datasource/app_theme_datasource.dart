import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/key_local_storage/key_local_storage.dart';
import 'package:word_pronunciation/src/features/app_theme/domain/entity/app_theme_mode.dart';

/// {@template app_theme_datasource}
/// Источник данных темы приложения
/// {@endtemplate}
@immutable
abstract interface class IAppThemeDatasource {
  /// Записывает режим темы в хранилище
  ///
  /// [themeMode] - режим темы [AppThemeMode]
  Future<void> writeAppThemeModeToStorage(AppThemeMode themeMode);

  /// Читает режим темы из хранилища
  AppThemeMode readAppThemeModeFromStorage();

  /// Возвращает режим темы приложения по умолчанию
  AppThemeMode get defaultAppThemeMode;
}

/// {@macro app_theme_datasource}
@immutable
class AppThemeDatasource implements IAppThemeDatasource {
  /// {@macro key_local_storage}
  final IKeyLocalStorage _keyLocalStorage;

  /// {@macro app_theme_datasource}
  const AppThemeDatasource({
    required IKeyLocalStorage keyLocalStorage,
  }) : _keyLocalStorage = keyLocalStorage;

  /// Ключ режима темы приложения в [IKeyLocalStorage]
  static const _themeModeStorageKey = 'themeMode';

  @override
  AppThemeMode get defaultAppThemeMode => AppThemeMode.system;

  @override
  AppThemeMode readAppThemeModeFromStorage() =>
      AppThemeMode.fromString(_keyLocalStorage.read(_themeModeStorageKey));

  @override
  Future<void> writeAppThemeModeToStorage(AppThemeMode themeMode) =>
      _keyLocalStorage.write(
        _themeModeStorageKey,
        themeMode.toString(),
      );
}
