import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';

/// Экран заместитель приложения
@immutable
class AppPlaceholderPage extends StatelessWidget {
  /// Создает экран заместитель приложения
  const AppPlaceholderPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: SafeArea(
          child: ProgressLayout(),
        ),
      );
}
