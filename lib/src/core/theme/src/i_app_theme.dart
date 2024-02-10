import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:word_pronunciation/src/core/theme/theme.dart';

/// {@template app_theme}
/// Тема приложения
/// {@endtemplate}
@immutable
abstract interface class IAppTheme {
  /// Material Dark Theme Data
  ThemeData get data;

  /// Цвета
  ///
  /// См. также [IAppColors]
  IAppColors get colors;

  /// Тема текста
  TextTheme get textTheme;

  /// Возвращает true, если тема темная
  bool get isDark;

  /// Возвращает стиль системного UI
  SystemUiOverlayStyle get systemUiOverlayStyle;
}
