import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/features/app/bloc/app_initialization.dart';
import 'package:word_pronunciation/src/features/app/bloc/core_initialization.dart';
import 'package:word_pronunciation/src/features/app/di/app_initialization_scope.dart';
import 'package:word_pronunciation/src/features/app/di/core_dependencies_scope.dart';
import 'package:word_pronunciation/src/features/app/di/core_initialization_scope.dart';
import 'package:word_pronunciation/src/features/app/di/dependencies_scope.dart';
import 'package:word_pronunciation/src/features/app/presentation/pages/pages.dart';
import 'package:word_pronunciation/src/features/app_locale/di/app_locale_scope.dart';
import 'package:word_pronunciation/src/features/app_theme/di/app_theme_scope.dart';

/// Основой виджет приложения
@immutable
class App extends StatelessWidget {
  /// Создает основой виджет приложения
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) => const _Core(
        child: _ThemeAndLocale(
          child: _MaterialApp(
            child: _AppInitialization(
              router: _Router(),
            ),
          ),
        ),
      );
}

/// Виджет с ядром приложения
@immutable
class _Core extends StatelessWidget {
  /// Дочерний виджет
  final Widget child;

  /// Создает виджет с ядром приложения
  const _Core({
    required this.child,
  });

  @override
  Widget build(BuildContext context) => CoreInitializationScope(
        builder: (context) =>
            BlocBuilder<CoreInitializationBloc, CoreInitializationState>(
          bloc: CoreInitializationScope.of(context).bloc,
          builder: (context, state) => AnimatedSwitcher(
            duration: Durations.short3,
            child: state.when(
              progress: AppSplash.new,
              error: (errorHandler) =>
                  CoreInitializationErrorPage(errorHandler: errorHandler),
              success: (coreDependencies) => CoreDependenciesScope(
                coreDependencies: coreDependencies,
                child: child,
              ),
            ),
          ),
        ),
      );
}

/// Виджет с темой и локализацией приложения
@immutable
class _ThemeAndLocale extends StatelessWidget {
  /// Дочерний виджет
  final Widget child;

  /// Создает виджет с темой и локализацией приложения
  const _ThemeAndLocale({
    required this.child,
  });

  @override
  Widget build(BuildContext context) => AppThemeScope(
        child: AppLocaleScope(child: child),
      );
}

/// Виджет [MaterialApp]
@immutable
class _MaterialApp extends StatelessWidget {
  /// Дочерний виджет
  final Widget child;

  /// Создает виджет [MaterialApp]
  const _MaterialApp({
    required this.child,
  });

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: AppThemeScope.of(context).theme.data,
        locale: AppLocaleScope.of(context).locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Material(
          color: context.theme.data.scaffoldBackgroundColor,
          child: child,
        ),
      );
}

/// Виджет с инициализацией приложения
@immutable
class _AppInitialization extends StatelessWidget {
  /// Роутер приложения
  final Widget router;

  /// Создает виджет с инициализацией приложения
  const _AppInitialization({
    required this.router,
  });

  @override
  Widget build(BuildContext context) => AppInitializationScope(
        builder: (context) =>
            BlocBuilder<AppInitializationBloc, AppInitializationState>(
          bloc: AppInitializationScope.of(context).bloc,
          builder: (context, state) => AnimatedSwitcher(
            duration: Durations.short3,
            child: state.map(
              progress: (p) => AppInitializationProgressPage(
                  initializationProgress: p.initializationProgress),
              error: (e) => AppInitializationErrorPage(
                message: e.errorHandler.message(context),
              ),
              success: (s) => DependenciesScope(
                dependencies: s.dependencies,
                child: router,
              ),
            ),
          ),
        ),
      );
}

/// Роутер
@immutable
class _Router extends StatelessWidget {
  /// Создает роутер
  const _Router();

  @override
  Widget build(BuildContext context) => Router<Object>.withConfig(
        restorationScopeId: 'router',
        config: context.dependencies.router.config(
          placeholder: (context) => const AppPlaceholderPage(),
        ),
      );
}
