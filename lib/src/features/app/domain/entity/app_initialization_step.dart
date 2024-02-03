import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Енум с названиями шагов инициализации
enum AppInitializationStep {
  start,
  appRouter,
  appConnect,
  end;

  /// Возвращает локализованное сообщение
  String message(BuildContext context) =>
      switch (this) {
        AppInitializationStep.start =>
          AppLocalizations.of(context)?.appInitializationStart,
        AppInitializationStep.appRouter =>
          AppLocalizations.of(context)?.appInitializationAppRouter,
        AppInitializationStep.appConnect =>
          AppLocalizations.of(context)?.appInitializationAppConnect,
        AppInitializationStep.end =>
          AppLocalizations.of(context)?.appInitializationEnd,
      } ??
      '';
}
