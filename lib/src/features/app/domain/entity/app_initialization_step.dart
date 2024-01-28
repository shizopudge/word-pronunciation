import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Енум с названиями шагов инициализации
enum AppInitializationStep {
  start,
  keyLocalStorage,
  appRouter,
  appTheme,
  blocObserver,
  appConnect,
  end;

  /// Возвращает локализованное сообщение
  String message(BuildContext context) =>
      switch (this) {
        AppInitializationStep.start =>
          AppLocalizations.of(context)?.appInitializationStart,
        AppInitializationStep.keyLocalStorage =>
          AppLocalizations.of(context)?.appInitializationKeyLocalStorage,
        AppInitializationStep.appRouter =>
          AppLocalizations.of(context)?.appInitializationAppRouter,
        AppInitializationStep.appTheme =>
          AppLocalizations.of(context)?.appInitializationAppTheme,
        AppInitializationStep.blocObserver =>
          AppLocalizations.of(context)?.appInitializationBlocObserver,
        AppInitializationStep.appConnect =>
          AppLocalizations.of(context)?.appInitializationAppConnect,
        AppInitializationStep.end =>
          AppLocalizations.of(context)?.appInitializationEnd,
      } ??
      '';
}
