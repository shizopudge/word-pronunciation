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

  /// Purple
  Color get purple;

  /// Grey
  Color get grey;
}

/// {@macro app_colors}
@immutable
class AppColors implements IAppColors {
  @override
  Color get white => Colors.white;

  @override
  Color get black => Colors.black;

  @override
  Color get red => Colors.red;

  @override
  Color get blue => Colors.blue;

  @override
  Color get purple => Colors.purple.shade300;

  @override
  Color get grey => Colors.grey.shade400;
}
