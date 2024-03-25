import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/core_dependencies.dart';
import 'package:word_pronunciation/src/features/app_settings/bloc/app_settings.dart';
import 'package:word_pronunciation/src/features/app_settings/data/datasource/app_settings_local_datasource.dart';
import 'package:word_pronunciation/src/features/app_settings/data/model/app_settings.dart';
import 'package:word_pronunciation/src/features/app_settings/data/repository/app_settings_repository.dart';
import 'package:word_pronunciation/src/features/app_settings/domain/repository/i_app_settings_repository.dart';

/// Область видимости настроек приложения
@immutable
class AppSettingsScope extends StatefulWidget {
  /// Дочерний виджет
  final Widget child;

  /// Создает область видимости настроек приложения
  const AppSettingsScope({
    required this.child,
    super.key,
  });

  /// Возвращает [InheritedAppSettings] или завершается с
  /// [FlutterError] - Out of scope
  static InheritedAppSettings of(
    BuildContext context, {
    bool listen = true,
  }) {
    late final InheritedAppSettings? inheritedAppSettings;

    if (listen) {
      inheritedAppSettings =
          context.dependOnInheritedWidgetOfExactType<InheritedAppSettings>();
    } else {
      inheritedAppSettings =
          context.getInheritedWidgetOfExactType<InheritedAppSettings>();
    }

    if (inheritedAppSettings == null) {
      throw FlutterError('Out of scope, not found InheritedAppSettings');
    }

    return inheritedAppSettings;
  }

  /// Возвращает [InheritedAppSettings] или null
  static InheritedAppSettings? maybeOf(
    BuildContext context, {
    bool listen = true,
  }) {
    late final InheritedAppSettings? inheritedAppSettings;

    if (listen) {
      inheritedAppSettings =
          context.dependOnInheritedWidgetOfExactType<InheritedAppSettings>();
    } else {
      inheritedAppSettings =
          context.getInheritedWidgetOfExactType<InheritedAppSettings>();
    }

    return inheritedAppSettings;
  }

  @override
  State<AppSettingsScope> createState() => _AppSettingsScopeState();
}

class _AppSettingsScopeState extends State<AppSettingsScope> {
  /// {@macro app_settings_local_datasource}
  late final IAppSettingsLocalDatasource _appSettingsLocalDatasource;

  /// {@macro app_settings_repository}
  late final IAppSettingsRepository _appSettingsRepository;

  /// {@macro app_settings_bloc}
  late final AppSettingsBloc _appSettingsBloc;

  @override
  void initState() {
    super.initState();
    _appSettingsLocalDatasource = AppSettingsLocalDatasource(
        localStorage: CoreDependencies.of(context).keyLocalStorage);
    _appSettingsRepository =
        AppSettingsRepository(localDatasource: _appSettingsLocalDatasource);
    _appSettingsBloc = AppSettingsBloc(repository: _appSettingsRepository)
      ..add(const AppSettingsEvent.read());
  }

  @override
  void dispose() {
    _appSettingsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AppSettingsBloc, AppSettingsState>(
        bloc: _appSettingsBloc,
        buildWhen: (previous, current) => current.isIdle,
        builder: (context, state) {
          late final Widget child;

          final appSettings = state.appSettings;

          if (appSettings == null) {
            child = const AppSplash();
          } else {
            child = InheritedAppSettings(
              appSettings: appSettings,
              appSettingsBloc: _appSettingsBloc,
              child: widget.child,
            );
          }

          return AnimatedSwitcher(
            duration: Durations.short3,
            child: child,
          );
        },
      );
}

/// Виджет передающий вниз по дереву [AppSettingsScope]
@immutable
class InheritedAppSettings extends InheritedWidget {
  /// Настройки приложения
  final AppSettings appSettings;

  /// {@macro app_settings_bloc}
  final AppSettingsBloc appSettingsBloc;

  /// Создает виджет передающий вниз по дереву [AppSettingsScope]
  const InheritedAppSettings({
    required this.appSettings,
    required this.appSettingsBloc,
    required super.child,
    super.key,
  });

  @override
  bool updateShouldNotify(covariant InheritedAppSettings oldWidget) =>
      oldWidget.appSettings != appSettings ||
      oldWidget.appSettingsBloc != appSettingsBloc;
}
