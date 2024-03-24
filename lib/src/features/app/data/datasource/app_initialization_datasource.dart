import 'dart:async';

import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/app_analytics/app_analytics.dart';
import 'package:word_pronunciation/src/core/app_connect/app_connect.dart';
import 'package:word_pronunciation/src/core/database/database.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';
import 'package:word_pronunciation/src/core/logger/logger.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/app_initialization_step.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/core_dependencies.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/dependencies.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/initialization_progress.dart';

/// Тип шага инициализации
typedef _InitializationStep = FutureOr<void> Function(
    $MutableDependencies dependencies);

@immutable
abstract interface class IAppInitializationDatasource {
  /// Инициализирует приложение
  ///
  /// [coreDependencies] - основные заивимости приложения
  /// [onProgress] - обработчик на обновление прогресса инициализации
  Future<Dependencies> initialize({
    required final CoreDependencies coreDependencies,
    required final void Function(InitializationProgress initializationProgress)
        onProgress,
  });
}

@immutable
class AppInitializationDatasource implements IAppInitializationDatasource {
  @override
  Future<Dependencies> initialize({
    required final CoreDependencies coreDependencies,
    required final void Function(InitializationProgress initializationProgress)
        onProgress,
  }) async {
    final stopwatch = Stopwatch()..start();
    final dependencies = await _initializeDependencies(
      coreDependencies: coreDependencies,
      onProgress: onProgress,
    );
    stopwatch.stop();
    L.log('App was initialized in ${stopwatch.elapsed.inSeconds} seconds');
    await AppAnalytics.instance.logEvent(name: 'App was initialized');
    return dependencies;
  }

  Future<Dependencies> _initializeDependencies({
    required final CoreDependencies coreDependencies,
    required final void Function(InitializationProgress initializationProgress)
        onProgress,
  }) async {
    final dependencies = $MutableDependencies(
      keyLocalStorage: coreDependencies.keyLocalStorage,
      dioClient: coreDependencies.dioClient,
    );
    final totalSteps = _initializationSteps.length;
    var currentStep = 0;
    for (final step in _initializationSteps.entries) {
      currentStep++;
      final percent = (currentStep * 100 ~/ totalSteps).clamp(0, 100);
      try {
        onProgress.call(
          InitializationProgress(step: step.key, progress: percent),
        );
        L.log(
            'App initialization | $currentStep/$totalSteps ($percent%) | "${step.key}"');
        await step.value(dependencies);

        /// Добавил ожидание, так как не зря же я верстал экран с загрузкой и
        /// локализировал вывод сообщений по загрузке.
        await Future<void>.delayed(const Duration(milliseconds: 250));
      } on Object catch (error, stackTrace) {
        Error.throwWithStackTrace(
          AppInitializationException(
            initializationProgress:
                InitializationProgress(step: step.key, progress: percent),
          ),
          stackTrace,
        );
      }
    }
    return dependencies.freeze();
  }

  final Map<AppInitializationStep, _InitializationStep> _initializationSteps =
      <AppInitializationStep, _InitializationStep>{
    AppInitializationStep.appConnect: (dependencies) =>
        dependencies.appConnect = const AppConnect(),
    AppInitializationStep.db: (dependencies) async {
      try {
        final db = await DB.instance;
        dependencies.db = db;
      } on Object catch (error, stackTrace) {
        L.error(
          'Something went wrong during DB initialization',
          error: error,
          stackTrace: stackTrace,
        );
        rethrow;
      }
    },
    AppInitializationStep.end: (_) => L.log('App successfully initialized'),
  };
}
