import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/theme/src/app_colors.dart';
import 'package:word_pronunciation/src/core/theme/src/theme.dart';
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

  /// Возвращает тему приложения
  static final ThemeData _theme = AppTheme(appColors: AppColors()).data;

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: _theme,
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark
              .copyWith(statusBarColor: Colors.transparent),
          child: Scaffold(
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PrimaryLoadingIndicator(
                        size: 40,
                        color: context.colors.black.withOpacity(.5),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${initializationProgress.progress} %',
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          style: context.theme.textTheme.titleMedium
                              ?.copyWith(color: context.colors.grey),
                        ),
                      ),
                      Text(
                        initializationProgress.message,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        style: context.theme.textTheme.bodyLarge?.copyWith(
                          color: context.colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
