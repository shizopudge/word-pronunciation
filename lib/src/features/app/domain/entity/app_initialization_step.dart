import 'package:flutter/widgets.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';

/// Енум с названиями шагов инициализации
enum AppInitializationStep {
  start,
  appRouter,
  appConnect,
  db,
  end;

  /// Возвращает локализованное сообщение
  String toMessage(BuildContext context) => switch (this) {
        AppInitializationStep.start =>
          context.localization.appInitializationStart,
        AppInitializationStep.appRouter =>
          context.localization.appInitializationAppRouter,
        AppInitializationStep.appConnect =>
          context.localization.appInitializationAppConnect,
        AppInitializationStep.db => context.localization.appInitializationDB,
        AppInitializationStep.end => context.localization.appInitializationEnd,
      };
}
