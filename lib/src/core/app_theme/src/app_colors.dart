import 'package:flutter/material.dart';

/// {@template app_colors}
/// Цвета приложения
/// {@endtemplate}
@immutable
abstract interface class IAppColors {
  /// White
  Color get white;

  /// Black
  Color get black;

  /// Red
  Color get red;

  /// Blue
  Color get blue;

  /// Grey
  Color get grey;

  /// Orange
  Color get orange;

  /// Green
  Color get green;
}

/// {@macro app_colors}
@immutable
class AppColors implements IAppColors {
  @override
  Color get white => Colors.white;

  @override
  Color get black => Colors.black;

  @override
  Color get red => Colors.red.shade300;

  @override
  Color get blue => Colors.blue.shade300;

  @override
  Color get grey => Colors.grey.shade400;

  @override
  Color get orange => Colors.orange.shade300;

  @override
  Color get green => Colors.green.shade300;
}
