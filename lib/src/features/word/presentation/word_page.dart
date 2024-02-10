import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/features/app_locale/bloc/app_locale.dart';
import 'package:word_pronunciation/src/features/app_locale/di/app_locale_scope.dart';
import 'package:word_pronunciation/src/features/app_theme/bloc/app_theme.dart';
import 'package:word_pronunciation/src/features/app_theme/di/app_theme_scope.dart';
import 'package:word_pronunciation/src/features/app_theme/domain/entity/app_theme_mode.dart';
import 'package:word_pronunciation/src/features/toaster/src/toaster_config.dart';

/// Экран с словом
@immutable
@RoutePage<void>()
class WordPage extends StatelessWidget {
  /// Создает экран с словом
  const WordPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => AppThemeScope.of(context, listen: false)
                    .bloc
                    .add(const AppThemeEvent.write(AppThemeMode.dark)),
                child: const Text('Dark'),
              ),
              ElevatedButton(
                onPressed: () => AppThemeScope.of(context, listen: false)
                    .bloc
                    .add(const AppThemeEvent.write(AppThemeMode.light)),
                child: const Text('Light'),
              ),
              ElevatedButton(
                onPressed: () => AppThemeScope.of(context, listen: false)
                    .bloc
                    .add(const AppThemeEvent.write(AppThemeMode.system)),
                child: const Text('System'),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => context.showToaster(
                  message: 'ERROR',
                  priority: ToasterPriority.first,
                  type: ToasterType.error,
                ),
                child: const Text('ERROR'),
              ),
              ElevatedButton(
                onPressed: () => context.showToaster(
                  message: 'SUCCESS',
                  priority: ToasterPriority.first,
                  type: ToasterType.success,
                ),
                child: const Text('SUCCESS'),
              ),
              ElevatedButton(
                onPressed: () => context.showToaster(
                  message: 'MESSAGE',
                  type: ToasterType.message,
                ),
                child: const Text('MESSAGE'),
              ),
              ElevatedButton(
                onPressed: () => context.showToaster(
                  message: 'WARNING',
                  type: ToasterType.warning,
                ),
                child: const Text('WARNING'),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => AppLocaleScope.of(context, listen: false)
                    .bloc
                    .add(const AppLocaleEvent.write('ru')),
                child: const Text('RU'),
              ),
              ElevatedButton(
                onPressed: () => AppLocaleScope.of(context, listen: false)
                    .bloc
                    .add(const AppLocaleEvent.write('en')),
                child: const Text('EN'),
              ),
              const SizedBox(height: 40),
              Text(
                'Localized text: ${context.localization?.localeName}',
                style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: context.theme.isDark
                        ? context.theme.colors.white
                        : context.theme.colors.black),
              ),
            ],
          ),
        ),
      );
}
