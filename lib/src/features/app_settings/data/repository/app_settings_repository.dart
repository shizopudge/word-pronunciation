import 'package:meta/meta.dart';
import 'package:word_pronunciation/src/features/app_settings/data/datasource/app_settings_local_datasource.dart';
import 'package:word_pronunciation/src/features/app_settings/data/model/app_settings.dart';
import 'package:word_pronunciation/src/features/app_settings/domain/repository/i_app_settings_repository.dart';

/// {@template app_settings_repository}
/// Репозиторий настроек приложения
/// {@endtemplate}
@immutable
class AppSettingsRepository implements IAppSettingsRepository {
  /// {@macro app_settings_local_datasource}
  final IAppSettingsLocalDatasource _localDatasource;

  /// {@macro app_settings_repository}
  const AppSettingsRepository({
    required IAppSettingsLocalDatasource localDatasource,
  }) : _localDatasource = localDatasource;

  @override
  AppSettings readSettings() => _localDatasource.readSettings();

  @override
  Future<void> writeSettings(AppSettings appSettings) =>
      _localDatasource.writeSettings(appSettings);

  @override
  AppSettings get defaultAppSettings => _localDatasource.defaultAppSettings;
}
