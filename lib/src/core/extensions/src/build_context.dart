import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:word_pronunciation/src/core/app_theme/app_theme.dart';
import 'package:word_pronunciation/src/core/key_local_storage/key_local_storage.dart';
import 'package:word_pronunciation/src/core/router/router.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/dependencies.dart';
import 'package:word_pronunciation/src/features/app_theme/di/app_theme_scope.dart';
import 'package:word_pronunciation/src/features/toaster/toaster.dart';

extension BuildContextX on BuildContext {
  /// Media query
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// {@macro dependencies}
  Dependencies get dependencies => Dependencies.of(this);

  /// {@macro app_router}
  AppRouter get router => Dependencies.of(this).router;

  /// {@macro key_local_storage}
  IKeyLocalStorage get keyLocalStorage => Dependencies.of(this).keyLocalStorage;

  /// Слушает тему приложения
  IAppTheme get theme => AppThemeScope.of(this).theme;

  /// Возвращает тему приложения
  IAppTheme get themeRead => AppThemeScope.of(this, listen: false).theme;

  /// Слушает тему приложения или null
  IAppTheme? get themeMaybe => AppThemeScope.maybeOf(this)?.theme;

  /// Возвращает тему приложения или null
  IAppTheme? get themeMaybeRead =>
      AppThemeScope.maybeOf(this, listen: false)?.theme;

  /// Локализация
  AppLocalizations? get localization => AppLocalizations.of(this);

  /// Возвращает stream подключения к интернету
  Stream<bool> get hasConnect =>
      Dependencies.of(this).appConnect.onConnectChanged;

  /// Возвращает состояние подключения к интернету
  Future<bool> get hasConnectRead =>
      Dependencies.of(this).appConnect.hasConnect();

  /// Возвращает область видмости тостера
  ToasterScopeState get toaster => ToasterScope.of(this);

  /// Показывает тостер
  void showToaster({
    required String message,
    Widget? icon,
    Duration duration = const Duration(milliseconds: 3000),
    ToasterType type = ToasterType.message,
    ToasterPriority priority = ToasterPriority.common,
  }) =>
      ToasterScope.of(this).showToast(
        this,
        config: ToasterConfig(
          message: message,
          icon: icon,
          duration: duration,
          type: type,
          priority: priority,
        ),
      );
}
