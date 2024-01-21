import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';

/// Виджет отображающий загрузку
@immutable
class ProgressLayout extends StatelessWidget {
  /// Цвет индикатора
  final Color? indicatorColor;

  /// Создает виджет отображающий загрузку
  const ProgressLayout({
    this.indicatorColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: PrimaryLoadingIndicator(color: indicatorColor),
      );
}
