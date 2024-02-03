import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/features/app_theme/bloc/app_theme.dart';
import 'package:word_pronunciation/src/features/app_theme/di/app_theme_scope.dart';
import 'package:word_pronunciation/src/features/app_theme/domain/entity/app_theme_mode.dart';

/// Экран с словом
@immutable
@RoutePage<void>()
class WordPage extends StatelessWidget {
  /// Создает экран с словом
  const WordPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: ElevatedButton(
          onPressed: () => AppThemeScope.of(context, listen: false)
              .bloc
              .add(const AppThemeEvent.write(AppThemeMode.dark)),
          child: Text('Set theme mode'),
        ),
      );
}
