import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';
import 'package:word_pronunciation/src/core/theme/theme.dart';
import 'package:word_pronunciation/src/features/app/bloc/core_initialization.dart';
import 'package:word_pronunciation/src/features/app/di/core_initialization_scope.dart';
import 'package:word_pronunciation/src/features/app/presentation/widgets/widgets.dart';

/// Экран ошибки инициализации ядра приложения
@immutable
class CoreInitializationErrorPage extends StatelessWidget {
  /// {@macro error_handler}
  final IErrorHandler errorHandler;

  /// Создает экран ошибки инициализации ядра приложения
  const CoreInitializationErrorPage({
    required this.errorHandler,
    super.key,
  });

  /// Тема приложения
  static final _appTheme = LightAppTheme(appColors: AppColors());

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: _appTheme.data,
        builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: _appTheme.systemUiOverlayStyle
              .copyWith(statusBarColor: Colors.transparent),
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Text(
                    errorHandler.message(context),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: _appTheme.colors.grey),
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: RestartButton(
              onRestart: () => _restart(context),
            ),
          ),
        ),
      );

  /// Перезапускает инициализацию ядра приложения
  void _restart(BuildContext context) => CoreInitializationScope.of(context)
      .bloc
      .add(const CoreInitializationEvent.initialize());
}
