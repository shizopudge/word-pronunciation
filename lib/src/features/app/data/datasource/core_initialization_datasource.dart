import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_pronunciation/src/core/bloc_observer/bloc_observer.dart';
import 'package:word_pronunciation/src/core/key_local_storage/key_local_storage.dart';
import 'package:word_pronunciation/src/core/logger/logger.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/dependencies.dart';

/// Тип шага инициализации
typedef _InitializationStep = FutureOr<void> Function(
    $MutableCoreDependencies dependencies);

@immutable
abstract interface class ICoreInitializationDatasource {
  /// Инициализирует основные зависимости приложения
  Future<CoreDependencies> initialize();
}

@immutable
class CoreInitializationDatasource implements ICoreInitializationDatasource {
  @override
  Future<CoreDependencies> initialize() async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized()
      ..deferFirstFrame();
    final stopwatch = Stopwatch()..start();
    Bloc.observer = const AppBlocObserver();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _initializeExceptionCatchers();
    final dependencies = await _initializeDependencies();
    stopwatch.stop();
    L.log('Core was initialized in ${stopwatch.elapsed.inSeconds} seconds');
    widgetsBinding.addPostFrameCallback(
      (_) => widgetsBinding.allowFirstFrame(),
    );
    return dependencies;
  }

  Future<CoreDependencies> _initializeDependencies() async {
    final dependencies = $MutableCoreDependencies();
    final totalSteps = _initializationSteps.length;
    var currentStep = 0;
    for (final step in _initializationSteps.entries) {
      currentStep++;
      final percent = (currentStep * 100 ~/ totalSteps).clamp(0, 100);
      L.log(
          'Core initialization | $currentStep/$totalSteps ($percent%) | "${step.key}"');
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

  final Map<String, _InitializationStep> _initializationSteps =
      <String, _InitializationStep>{
    'KeyLocalStorage': (dependencies) async {
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
    'Core initialization end': (_) => L.log('Core successfully initialized'),
  };
}
