import 'package:meta/meta.dart';
import 'package:word_pronunciation/src/features/app_settings/data/model/app_settings.dart';

/// {@template i_app_settings_repository}
/// Интерфейс репозитория настроек приложения
/// {@endtemplate}
@immutable
abstract interface class IAppSettingsRepository {
  /// Получает настройки из локального хранилища
  AppSettings readSettings();

  /// Записывает настройки в локальное хранилище
  ///
  /// [appSettings] - модель данных для хранения настроек [AppSettings]
  Future<void> writeSettings(AppSettings appSettings);

  /// Возвращает растройки приложения по умолчанию
  AppSettings get defaultAppSettings;
}
