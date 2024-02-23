import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:word_pronunciation/src/core/app_theme/app_theme.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/logger/logger.dart';
import 'package:word_pronunciation/src/features/app/bloc/core_initialization.dart';
import 'package:word_pronunciation/src/features/app/presentation/widgets/widgets.dart';
import 'package:word_pronunciation/src/features/app/scope/scope.dart';

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
        locale: Locale(systemLanguageCode),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: _appTheme.systemUiOverlayStyle
              .copyWith(statusBarColor: Colors.transparent),
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 24) +
                          EdgeInsets.only(top: context.mediaQuery.padding.top),
                      child: Text(
                        errorHandler.toMessage(context),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: _appTheme.colors.grey),
                      ),
                    ),
                  ),
                ),
                RestartButton(onRestart: () => _restart(context)),
              ],
            ),
          ),
        ),
      );

  /// Перезапускает инициализацию основы приложения
  void _restart(BuildContext context) => CoreInitializationScope.of(context)
      .bloc
      .add(const CoreInitializationEvent.initialize());

  /// Код системного языка
  String get systemLanguageCode {
    try {
      return Platform.localeName.split('_').first;
    } on Object catch (error, stackTrace) {
      L.error(
          'Something went wrong while getting platform locale name. Error: $error',
          error: error,
          stackTrace: stackTrace);
      rethrow;
    }
  }
}
