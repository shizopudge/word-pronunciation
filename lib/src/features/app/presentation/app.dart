import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:word_pronunciation/src/core/app_analytics/app_analytics.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/features/app/bloc/app_initialization.dart';
import 'package:word_pronunciation/src/features/app/bloc/core_initialization.dart';
import 'package:word_pronunciation/src/features/app/presentation/pages/pages.dart';
import 'package:word_pronunciation/src/features/app/scope/scope.dart';
import 'package:word_pronunciation/src/features/app_connect/presentation/widgets/internet_connection_listener.dart';
import 'package:word_pronunciation/src/features/app_locale/scope/app_locale_scope.dart';
import 'package:word_pronunciation/src/features/app_settings/scope/app_settings_scope.dart';
import 'package:word_pronunciation/src/features/app_theme/scope/app_theme_scope.dart';
import 'package:word_pronunciation/src/features/toaster/src/toaster_scope.dart';
import 'package:word_pronunciation/src/features/word/presentation/word_page.dart';

/// Основой виджет приложения
@immutable
class App extends StatelessWidget {
  /// Создает основой виджет приложения
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) => const _Core(
        child: _ThemeLocaleToasterAndSettings(
          child: _MaterialApp(
            child: _AppInitialization(
              child: InternetConnectionListener(
                child: WordPage(),
              ),
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
          builder: (context, state) => Material(
            color: Colors.white,
            child: AnimatedSwitcher(
              duration: Durations.short2,
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
        ),
      );
}

/// Виджет с темой, локализацией, тостером и настройками приложения
@immutable
class _ThemeLocaleToasterAndSettings extends StatelessWidget {
  /// Дочерний виджет
  final Widget child;

  /// Создает виджет с темой, локализацией, тостером и настройками приложения
  const _ThemeLocaleToasterAndSettings({
    required this.child,
  });

  @override
  Widget build(BuildContext context) => AppThemeScope(
        child: AppLocaleScope(
          child: AppSettingsScope(
            child: ToasterScope(
              child: child,
            ),
          ),
        ),
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
        debugShowCheckedModeBanner: !kReleaseMode,
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
  /// Дочерний виджет
  final Widget child;

  /// Создает виджет с инициализацией приложения
  const _AppInitialization({
    required this.child,
  });

  @override
  Widget build(BuildContext context) => AppInitializationScope(
        builder: (context) =>
            BlocConsumer<AppInitializationBloc, AppInitializationState>(
          listener: (context, state) => state.mapOrNull(
            success: (_) => AppAnalytics.instance.logAppOpen(),
          ),
          listenWhen: (previous, current) => current.isSuccess,
          bloc: AppInitializationScope.of(context).bloc,
          builder: (context, state) => AnimatedSwitcher(
            duration: Durations.short2,
            child: state.map(
              progress: (p) => AppInitializationProgressPage(
                  initializationProgress: p.initializationProgress),
              error: (e) => AppInitializationErrorPage(
                message: e.errorHandler.toMessage(context),
              ),
              success: (s) => DependenciesScope(
                dependencies: s.dependencies,
                child: child,
              ),
            ),
          ),
        ),
      );
}
