import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/core/app_theme/app_theme.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/core_dependencies.dart';
import 'package:word_pronunciation/src/features/app_theme/bloc/app_theme.dart';
import 'package:word_pronunciation/src/features/app_theme/data/datasource/app_theme_datasource.dart';
import 'package:word_pronunciation/src/features/app_theme/data/repository/app_theme_repository.dart';
import 'package:word_pronunciation/src/features/app_theme/domain/entity/app_theme_mode.dart';

/// Область видимости темы приложения
@immutable
class AppThemeScope extends StatefulWidget {
  /// Дочерний виджет
  final Widget child;

  /// Создает область видимости темы приложения
  const AppThemeScope({
    required this.child,
    super.key,
  });

  /// Возвращает [InheritedAppTheme] или завершается с [ArgumentError] - Out
  /// of scope
  static InheritedAppTheme of(BuildContext context, {bool listen = true}) {
    late final InheritedAppTheme? inheritedAppTheme;

    if (listen) {
      inheritedAppTheme =
          context.dependOnInheritedWidgetOfExactType<InheritedAppTheme>();
    } else {
      inheritedAppTheme =
          context.getInheritedWidgetOfExactType<InheritedAppTheme>();
    }

    if (inheritedAppTheme == null) {
      throw ArgumentError(
        'Out of scope, not found AppThemeScope',
        'out_of_scope',
      );
    }

    return inheritedAppTheme;
  }

  /// Возвращает [InheritedAppTheme] или null
  static InheritedAppTheme? maybeOf(
    BuildContext context, {
    bool listen = true,
  }) {
    late final InheritedAppTheme? inheritedAppTheme;

    if (listen) {
      inheritedAppTheme =
          context.dependOnInheritedWidgetOfExactType<InheritedAppTheme>();
    } else {
      inheritedAppTheme =
          context.getInheritedWidgetOfExactType<InheritedAppTheme>();
    }

    return inheritedAppTheme;
  }

  @override
  State<AppThemeScope> createState() => AppThemeScopeState();
}

class AppThemeScopeState extends State<AppThemeScope> {
  /// Темная тема приложения
  static final _darkTheme = DarkAppTheme(appColors: AppColors());

  /// Светлая тема приложения
  static final _lightTheme = LightAppTheme(appColors: AppColors());

  /// {@macro app_theme_bloc}
  late final AppThemeBloc _bloc;

  /// Системная тема
  late IAppTheme _themeOfSystem;

  @override
  void initState() {
    super.initState();
    _bloc = AppThemeBloc(
      repository: AppThemeRepository(
        datasource: AppThemeDatasource(
          keyLocalStorage: CoreDependencies.of(context).keyLocalStorage,
        ),
      ),
    )..add(const AppThemeEvent.read());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeOfSystem =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? _darkTheme
            : _lightTheme;
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AppThemeBloc, AppThemeState>(
        bloc: _bloc,
        buildWhen: (previous, current) => current.isIdle,
        builder: (context, state) {
          late final Widget child;

          final appThemeMode = state.appThemeMode;

          if (appThemeMode == null) {
            child = const AppSplash();
          } else {
            child = InheritedAppTheme(
              theme: _theme(appThemeMode),
              bloc: _bloc,
              child: widget.child,
            );
          }

          return AnimatedSwitcher(
            duration: Durations.short3,
            child: child,
          );
        },
      );

  /// Возвращает тему приложения
  IAppTheme _theme(AppThemeMode appThemeMode) => switch (appThemeMode) {
        AppThemeMode.dark => _darkTheme,
        AppThemeMode.light => _lightTheme,
        AppThemeMode.system => _themeOfSystem,
      };
}

/// Виджет хранящий в себе тему приложения и блок темы
@immutable
class InheritedAppTheme extends InheritedWidget {
  /// {@macro app_theme}
  final IAppTheme theme;

  /// {@macro app_theme_bloc}
  final AppThemeBloc bloc;

  /// Создает виджет хранящий в себе тему приложения и блок темы
  const InheritedAppTheme({
    required this.theme,
    required this.bloc,
    required super.child,
    super.key,
  });

  @override
  bool updateShouldNotify(covariant InheritedAppTheme oldWidget) =>
      oldWidget.theme != theme || oldWidget.bloc != bloc;
}
