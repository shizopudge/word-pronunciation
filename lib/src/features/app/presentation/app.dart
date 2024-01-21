import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/features/app/presentation/app_placeholder_page.dart';

/// Основой виджет приложения
@immutable
class App extends StatelessWidget {
  /// Создает основой виджет приложения
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        theme: context.appTheme.data,
        routerConfig: context.dependencies.router.config(
          placeholder: (context) => const AppPlaceholderPage(),
        ),
      );
}
