import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:word_pronunciation/src/core/key_local_storage/key_local_storage.dart';
import 'package:word_pronunciation/src/core/router/router.dart';
import 'package:word_pronunciation/src/core/theme/theme.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/dependencies.dart';
import 'package:word_pronunciation/src/features/app_theme/di/app_theme_scope.dart';

extension BuildContextX on BuildContext {
  /// Media query
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// {@macro dependencies}
  Dependencies get dependencies => Dependencies.of(this);

  /// {@macro app_router}
  AppRouter get router => Dependencies.of(this).router;

  /// Возвращает тему приложения
  IAppTheme get theme => AppThemeScope.of(this).theme;

  /// Локализация
  AppLocalizations? get localization => AppLocalizations.of(this);

  /// Возвращает stream подключения к интернету
  Stream<bool> get hasConnect =>
      Dependencies.of(this).appConnect.onConnectChanged;

  /// Возвращает состояние подключения к интернету
  Future<bool> get hasConnectRead =>
      Dependencies.of(this).appConnect.hasConnect();

  /// {@macro key_local_storage}
  IKeyLocalStorage get keyLocalStorage => Dependencies.of(this).keyLocalStorage;
}
