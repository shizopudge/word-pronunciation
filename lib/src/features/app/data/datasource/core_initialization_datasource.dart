import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_pronunciation/firebase_options.dart';
import 'package:word_pronunciation/src/core/analytics/analytics.dart';
import 'package:word_pronunciation/src/core/bloc_observer/bloc_observer.dart';
import 'package:word_pronunciation/src/core/dio/dio.dart';
import 'package:word_pronunciation/src/core/error_handler/error_handler.dart';
import 'package:word_pronunciation/src/core/key_local_storage/key_local_storage.dart';
import 'package:word_pronunciation/src/core/logger/logger.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/core_dependencies.dart';

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
    WidgetsFlutterBinding.ensureInitialized();
    final stopwatch = Stopwatch()..start();
    Bloc.observer = const AppBlocObserver();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _initializeExceptionCatchers();
    await AppAnalytics.instance.setAnalyticsCollectionEnabled();
    final dependencies = await _initializeDependencies();
    stopwatch.stop();
    L.log('Core was initialized in ${stopwatch.elapsed.inSeconds} seconds');
    await AppAnalytics.instance.logEvent(name: 'Core was initialized');
    return dependencies;
  }

  Future<CoreDependencies> _initializeDependencies() async {
    final coreDependencies = $MutableCoreDependencies();
    final totalSteps = _initializationSteps.length;
    var currentStep = 0;
    for (final step in _initializationSteps.entries) {
      currentStep++;
      final percent = (currentStep * 100 ~/ totalSteps).clamp(0, 100);
      try {
        L.log(
            'Core initialization | $currentStep/$totalSteps ($percent%) | "${step.key}"');
        await step.value(coreDependencies);
      } on Object catch (error, stackTrace) {
        Error.throwWithStackTrace(
          CoreInitializationException(),
          stackTrace,
        );
      }
    }
    return coreDependencies.freeze();
  }

  void _initializeExceptionCatchers() {
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      L.error(
        'ROOT ERROR\r\n${Error.safeToString(error)}',
        error: error,
        stackTrace: stackTrace,
      );
      if (kReleaseMode) {
        FirebaseCrashlytics.instance.recordError(
          error,
          stackTrace,
          fatal: true,
        );
      }
      return true;
    };
    final sourceFlutterError = FlutterError.onError;
    FlutterError.onError = (final details) {
      L.error(
        'FLUTTER ERROR\r\n$details',
        error: details.exception,
        stackTrace: details.stack,
      );
      if (kReleaseMode) {
        FirebaseCrashlytics.instance.recordFlutterError(details);
      }
      FlutterError.presentError(details);
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
    'IDioClient': (dependencies) {
      final options = BaseOptions(
        connectTimeout: const Duration(milliseconds: 15000),
        receiveTimeout: const Duration(milliseconds: 15000),
        sendTimeout: const Duration(milliseconds: 15000),
      );
      dependencies.dioClient = DioClient(dio: Dio(options));
    },
    'Core initialization end': (_) => L.log('Core successfully initialized'),
  };
}
