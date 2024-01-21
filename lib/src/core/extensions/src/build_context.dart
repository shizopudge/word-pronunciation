import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/router/router.dart';
import 'package:word_pronunciation/src/core/theme/theme.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/dependencies.dart';

extension BuildContextX on BuildContext {
  /// Media query
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// {@macro dependencies}
  Dependencies get dependencies => Dependencies.of(this);

  /// {@macro app_theme}
  IAppTheme get appTheme => Dependencies.of(this).appTheme;

  /// {@macro app_router}
  AppRouter get router => Dependencies.of(this).router;

  /// {@macro app_colors}
  IAppColors get colors => AppColors();

  /// Возвращает тему приложения
  ThemeData get theme => Theme.of(this);

  /// Возвращает stream подключения к интернету
  Stream<bool> get hasConnect =>
      Dependencies.of(this).appConnect.onConnectChanged;

  /// Возвращает состояние подключения к интернету
  Future<bool> get hasConnectRead =>
      Dependencies.of(this).appConnect.hasConnect();
}
