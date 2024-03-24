import 'package:meta/meta.dart';
import 'package:word_pronunciation/src/features/app_settings/data/model/app_settings.dart';

/// Интерфейс репозитория настроек приложения
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
