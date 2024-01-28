import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_pronunciation/src/core/app_connect/app_connect.dart';
import 'package:word_pronunciation/src/core/bloc_observer/bloc_observer.dart';
import 'package:word_pronunciation/src/core/key_local_storage/key_local_storage.dart';
import 'package:word_pronunciation/src/core/logger/logger.dart';
import 'package:word_pronunciation/src/core/router/router.dart';
import 'package:word_pronunciation/src/core/theme/theme.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/app_initialization_step.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/dependencies.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/initialization_progress.dart';

/// Тип шага инициализации
typedef _InitializationStep = FutureOr<void> Function(
    $MutableDependencies dependencies);

@immutable
abstract interface class IAppInitializationDatasource {
  /// Инициализирует приложение
  ///
  /// [onProgress] - обработчик на обновление прогресса инициализации
  Future<Dependencies> initialize({
    required final void Function(InitializationProgress initializationProgress)
        onProgress,
  });
}

@immutable
class AppInitializationDatasource implements IAppInitializationDatasource {
  @override
  Future<Dependencies> initialize({
    required final void Function(InitializationProgress initializationProgress)
        onProgress,
  }) async {
    final stopwatch = Stopwatch()..start();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _initializeExceptionCatchers();
    final dependencies = await _initializeDependencies(onProgress: onProgress);
    stopwatch.stop();
    L.log('App was initialized in ${stopwatch.elapsed.inSeconds} seconds');
    return dependencies;
  }

  Future<Dependencies> _initializeDependencies({
    void Function(InitializationProgress initializationProgress)? onProgress,
  }) async {
    final dependencies = $MutableDependencies();
    final totalSteps = _initializationSteps.length;
    var currentStep = 0;
    for (final step in _initializationSteps.entries) {
      currentStep++;
      final percent = (currentStep * 100 ~/ totalSteps).clamp(0, 100);
      onProgress?.call(
        InitializationProgress(step: step.key, progress: percent),
      );
      L.log(
          'Initialization | $currentStep/$totalSteps ($percent%) | "${step.key}"');
      await step.value(dependencies);
    }
    return dependencies.freeze();
  }

  void _initializeExceptionCatchers() {
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      L.error(
        'ROOT ERROR\r\n${Error.safeToString(error)}',
        error: error,
        stackTrace: stackTrace,
      );
      // FirebaseCrashlytics.instance.recordError(
      //   error,
      //   stack,
      //   fatal: true,
      // );
      return true;
    };
    final sourceFlutterError = FlutterError.onError;
    FlutterError.onError = (final details) {
      L.error(
        'FLUTTER ERROR\r\n$details',
        error: details.exception,
        stackTrace: details.stack,
      );
      // FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      // FlutterError.presentError(details);
      sourceFlutterError?.call(details);
    };
  }

  final Map<AppInitializationStep, _InitializationStep> _initializationSteps =
      <AppInitializationStep, _InitializationStep>{
    AppInitializationStep.keyLocalStorage: (dependencies) async {
      try {
        final sharedPreferences = await SharedPreferences.getInstance();
        dependencies.keyLocalStorage =
            KeyLocalStorage(sharedPreferences: sharedPreferences);
      } on Object catch (error, stackTrace) {
        L.error(
          'Something went wrong during KeyLocalStorage initialization',
          error: error,
          stackTrace: stackTrace,
        );
        rethrow;
      }
    },
    AppInitializationStep.appRouter: (dependencies) =>
        dependencies.router = AppRouter(),
    AppInitializationStep.appTheme: (dependencies) =>
        dependencies.appTheme = AppTheme(appColors: AppColors()),
    AppInitializationStep.blocObserver: (dependencies) =>
        Bloc.observer = const AppBlocObserver(),
    AppInitializationStep.appConnect: (dependencies) =>
        dependencies.appConnect = AppConnect(),
    AppInitializationStep.end: (_) => L.log('App successfully initialized'),
  };
}
