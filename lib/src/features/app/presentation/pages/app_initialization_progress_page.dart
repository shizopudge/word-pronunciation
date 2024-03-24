import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/initialization_progress.dart';

/// Виджет отображающий загрузку приложения
@immutable
class AppInitializationProgressPage extends StatelessWidget {
  /// {@macro initialization_progress}
  final InitializationProgress initializationProgress;

  /// Создает виджет отображающий загрузку приложения
  const AppInitializationProgressPage({
    required this.initializationProgress,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: context.theme.systemUiOverlayStyle
            .copyWith(statusBarColor: Colors.transparent),
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryLoadingIndicator(
                    color: context.theme.isDark
                        ? context.theme.colors.white
                        : context.theme.colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: AnimatedSwitcher(
                      duration: Durations.short2,
                      child: Text(
                        '${initializationProgress.progress} %',
                        key: ValueKey<int>(initializationProgress.progress),
                        textAlign: TextAlign.center,
                        style: context.theme.textTheme.titleMedium
                            ?.copyWith(color: context.theme.colors.grey),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: AnimatedSwitcher(
                      duration: Durations.short2,
                      child: Text(
                        initializationProgress.toMessage(context),
                        key: ValueKey<String>(
                          initializationProgress.toMessage(context),
                        ),
                        textAlign: TextAlign.center,
                        style: context.theme.textTheme.bodyLarge?.copyWith(
                          color: context.theme.colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
