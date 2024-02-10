import 'package:flutter/material.dart';

/// {@template toaster_theme}
/// Тема тостера
/// {@endtemplate}
class ToasterTheme extends ThemeExtension<ToasterTheme> {
  /// Цвет фона при успехе
  final Color? successBackgroundColor;

  /// Цвет фона предупреждения
  final Color? warningBackgroundColor;

  /// Цвет фона ошибки
  final Color? errorBackgroundColor;

  /// Цвет фона сообщения
  final Color? messageBackgroundColor;

  /// Цвет иконки при успехе
  final Color? successIconColor;

  /// Цвет иконки предупреждения
  final Color? warningIconColor;

  /// Цвет иконки сообщения
  final Color? messageIconColor;

  /// Цвет иконки ошибки
  final Color? errorIconColor;

  /// Стиль текста сообщения
  final TextStyle? messageStyle;

  /// Стиль текста сообщения при успехе
  final TextStyle? successMessageStyle;

  /// Стиль текста сообщения предупреждения
  final TextStyle? warningMessageStyle;

  /// Стиль текста сообщения ошибки
  final TextStyle? errorMessageStyle;

  /// Радиус скругления
  final BorderRadiusGeometry? borderRadius;

  /// Тени
  final List<BoxShadow>? boxShadow;

  /// {@macro toaster_theme}
  const ToasterTheme({
    this.successBackgroundColor,
    this.warningBackgroundColor,
    this.errorBackgroundColor,
    this.messageBackgroundColor,
    this.successIconColor,
    this.warningIconColor,
    this.messageIconColor,
    this.errorIconColor,
    this.messageStyle,
    this.successMessageStyle,
    this.warningMessageStyle,
    this.errorMessageStyle,
    this.borderRadius,
    this.boxShadow,
  });

  @override
  ThemeExtension<ToasterTheme> copyWith({
    Color? successBackgroundColor,
    Color? warningBackgroundColor,
    Color? errorBackgroundColor,
    Color? messageBackgroundColor,
    Color? successIconColor,
    Color? warningIconColor,
    Color? messageIconColor,
    Color? errorIconColor,
    TextStyle? messageStyle,
    TextStyle? successMessageStyle,
    TextStyle? warningMessageStyle,
    TextStyle? errorMessageStyle,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
  }) =>
      ToasterTheme(
        successBackgroundColor:
            successBackgroundColor ?? this.successBackgroundColor,
        warningBackgroundColor:
            warningBackgroundColor ?? this.warningBackgroundColor,
        errorBackgroundColor: errorBackgroundColor ?? this.errorBackgroundColor,
        messageStyle: messageStyle ?? this.messageStyle,
        successMessageStyle: successMessageStyle ?? this.successMessageStyle,
        warningMessageStyle: warningMessageStyle ?? this.warningMessageStyle,
        errorMessageStyle: errorMessageStyle ?? this.errorMessageStyle,
        borderRadius: borderRadius ?? this.borderRadius,
      );

  @override
  ThemeExtension<ToasterTheme> lerp(
    ThemeExtension<ToasterTheme>? other,
    double t,
  ) {
    if (other is! ToasterTheme) return this;

    return ToasterTheme(
      successBackgroundColor: Color.lerp(
        successBackgroundColor,
        other.successBackgroundColor,
        t,
      ),
      warningBackgroundColor: Color.lerp(
        warningBackgroundColor,
        other.warningBackgroundColor,
        t,
      ),
      errorBackgroundColor: Color.lerp(
        errorBackgroundColor,
        other.errorBackgroundColor,
        t,
      ),
      messageBackgroundColor: Color.lerp(
        messageBackgroundColor,
        other.messageBackgroundColor,
        t,
      ),
      successIconColor: Color.lerp(
        successIconColor,
        other.successIconColor,
        t,
      ),
      warningIconColor: Color.lerp(
        warningIconColor,
        other.warningIconColor,
        t,
      ),
      messageIconColor: Color.lerp(
        messageIconColor,
        other.messageIconColor,
        t,
      ),
      errorIconColor: Color.lerp(
        errorIconColor,
        other.errorIconColor,
        t,
      ),
      messageStyle: TextStyle.lerp(messageStyle, other.messageStyle, t),
      successMessageStyle:
          TextStyle.lerp(successMessageStyle, other.successMessageStyle, t),
      warningMessageStyle:
          TextStyle.lerp(warningMessageStyle, other.warningMessageStyle, t),
      errorMessageStyle:
          TextStyle.lerp(errorMessageStyle, other.errorMessageStyle, t),
      borderRadius: BorderRadiusGeometry.lerp(
        borderRadius,
        other.borderRadius,
        t,
      ),
    );
  }
}
