import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:word_pronunciation/src/core/key_local_storage/key_local_storage.dart';
import 'package:word_pronunciation/src/features/app_settings/data/model/app_settings.dart';

/// {@template i_app_settings_local_datasource}
/// Интерфейс локального источника данных настроек приложения
/// {@endtemplate}
@immutable
abstract interface class IAppSettingsLocalDatasource {
  /// Получает настройки из локального хранилища
  AppSettings readSettings();

  /// Записывает настройки в локальное хранилище
  ///
  /// [appSettings] - модель данных для хранения настроек [AppSettings]
  Future<void> writeSettings(AppSettings appSettings);

  /// Возвращает настройки приложения по умолчанию
  AppSettings get defaultAppSettings;
}

/// {@template app_settings_local_datasource}
/// Локальный источник данных настроек приложения
/// {@endtemplate}
@immutable
class AppSettingsLocalDatasource implements IAppSettingsLocalDatasource {
  /// {@macro key_local_storage}
  final IKeyLocalStorage _localStorage;

  /// {@macro app_settings_local_datasource}
  const AppSettingsLocalDatasource({
    required IKeyLocalStorage localStorage,
  }) : _localStorage = localStorage;

  /// Ключ настроек в локальном хранилище
  static const _settingsKey = 'settings';

  /// Настройки приложения по умолчанию
  static const _defaultAppSettings = AppSettings.common;

  @override
  AppSettings readSettings() {
    final result = _localStorage.read(_settingsKey);
    if (result != null) {
      final json = Map<String, Object?>.from(jsonDecode(result));
      return AppSettings.fromJson(json);
    }
    return _defaultAppSettings;
  }

  @override
  Future<void> writeSettings(AppSettings appSettings) => _localStorage.write(
        _settingsKey,
        jsonEncode(appSettings),
      );

  @override
  AppSettings get defaultAppSettings => _defaultAppSettings;
}
