import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:word_pronunciation/src/core/app_theme/app_theme.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/app_kit/app_kit.dart';

/// Сплэш приложения
@immutable
class AppSplash extends StatelessWidget {
  /// Создает сплэш приложения
  const AppSplash({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Тема приложения
    final appTheme =
        context.themeMaybe ?? LightAppTheme(appColors: AppColors());

    // Цвет индикатора
    final indicatorColor =
        appTheme.isDark ? appTheme.colors.white : appTheme.colors.black;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appTheme.systemUiOverlayStyle
          .copyWith(statusBarColor: Colors.transparent),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Material(
          color: appTheme.data.scaffoldBackgroundColor,
          child: ProgressLayout(indicatorColor: indicatorColor),
        ),
      ),
    );
  }
}
