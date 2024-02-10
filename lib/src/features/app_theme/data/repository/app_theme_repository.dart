import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/features/app_theme/data/datasource/app_theme_datasource.dart';
import 'package:word_pronunciation/src/features/app_theme/domain/entity/app_theme_mode.dart';
import 'package:word_pronunciation/src/features/app_theme/domain/repository/i_app_theme_repository.dart';

/// {@macro app_theme_repository}
@immutable
class AppThemeRepository implements IAppThemeRepository {
  /// {@macro app_theme_datasource}
  final IAppThemeDatasource _datasource;

  /// {@macro app_theme_repository}
  const AppThemeRepository({
    required IAppThemeDatasource datasource,
  }) : _datasource = datasource;

  @override
  AppThemeMode readAppThemeModeFromStorage() =>
      _datasource.readAppThemeModeFromStorage();

  @override
  Future<void> writeAppThemeModeToStorage(AppThemeMode themeMode) =>
      _datasource.writeAppThemeModeToStorage(themeMode);

  @override
  AppThemeMode get defaultAppThemeMode => _datasource.defaultAppThemeMode;
}
