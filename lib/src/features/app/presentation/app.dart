import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/features/app/bloc/app_initialization.dart';
import 'package:word_pronunciation/src/features/app/di/app_initialization_scope.dart';
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

  // TODO: refactor
  @override
  Widget build(BuildContext context) => AppThemeScope(
        child: AppLocaleScope(
          child: Builder(
            builder: (context) => MaterialApp(
              theme: AppThemeScope.of(context).theme.data,
              locale: AppLocaleScope.of(context).locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => Material(
                color: context.theme.data.scaffoldBackgroundColor,
                child: AppInitializationScope(
                  builder: (context) => BlocBuilder<AppInitializationBloc,
                      AppInitializationState>(
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
                          child: Builder(
                            builder: (context) => Router<Object>.withConfig(
                              restorationScopeId: 'router',
                              config: context.dependencies.router.config(
                                placeholder: (context) =>
                                    const AppPlaceholderPage(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
