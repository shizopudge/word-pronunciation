import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';

/// Виджет отображающий загрузку
@immutable
class ProgressLayout extends StatelessWidget {
  /// Цвет индикатора
  final Color? indicatorColor;

  /// Если true, значит виджет сливер
  final bool _isSliver;

  /// Создает виджет отображающий загрузку
  const ProgressLayout({
    this.indicatorColor,
    super.key,
  }) : _isSliver = false;

  /// Создает виджет-сливер отображающий загрузку
  const ProgressLayout.sliver({
    this.indicatorColor,
    super.key,
  }) : _isSliver = true;

  @override
  Widget build(BuildContext context) {
    final progressLayout = Center(
      child: PrimaryLoadingIndicator(color: indicatorColor),
    );

    if (_isSliver) {
      SliverFillRemaining(
        hasScrollBody: false,
        child: progressLayout,
      );
    }

    return progressLayout;
  }
}
