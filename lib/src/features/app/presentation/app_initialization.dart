import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/features/app/bloc/app_initialization.dart';
import 'package:word_pronunciation/src/features/app/di/app_initialization_scope.dart';
import 'package:word_pronunciation/src/features/app/di/dependencies_scope.dart';
import 'package:word_pronunciation/src/features/app/presentation/app.dart';
import 'package:word_pronunciation/src/features/app/presentation/app_initialization_error_page.dart';
import 'package:word_pronunciation/src/features/app/presentation/app_initialization_progress_page.dart';

/// Виджет инициализации приложения
@immutable
class AppInitialization extends StatelessWidget {
  /// Создает виджет инициализации приложения
  const AppInitialization({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        child: BlocBuilder<AppInitializationBloc, AppInitializationState>(
          bloc: AppInitializationScope.of(context).bloc,
          builder: (context, state) => AnimatedSwitcher(
            duration: Durations.short3,
            child: state.map(
              progress: (p) => AppInitializationProgressPage(
                  initializationProgress: p.initializationProgress),
              error: (e) => AppInitializationErrorPage(message: e.message),
              success: (s) => DependenciesScope(
                dependencies: s.dependencies,
                child: const App(),
              ),
            ),
          ),
        ),
      );
}
