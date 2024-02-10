import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:word_pronunciation/src/core/theme/theme.dart';
import 'package:word_pronunciation/src/core/ui_kit/app_kit/app_kit.dart';

/// Сплэш приложения
@immutable
class AppSplash extends StatelessWidget {
  /// {@macro app_theme}
  final IAppTheme? appTheme;

  /// Создает сплэш приложения
  const AppSplash({
    this.appTheme,
    super.key,
  });

  /// {@macro app_theme}
  IAppTheme get _appTheme => appTheme ?? LightAppTheme(appColors: AppColors());

  /// Возвращает цвет индикатора в зависимости от темы
  Color get _progressIndicatorColor =>
      _appTheme.isDark ? _appTheme.colors.white : _appTheme.colors.black;

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: _appTheme.systemUiOverlayStyle
            .copyWith(statusBarColor: Colors.transparent),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Material(
            color: _appTheme.data.scaffoldBackgroundColor,
            child: SafeArea(
              child: ProgressLayout(indicatorColor: _progressIndicatorColor),
            ),
          ),
        ),
      );
}
