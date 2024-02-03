import 'package:word_pronunciation/src/features/app/domain/entity/initialization_progress.dart';

/// {@template app_initialization_exception}
/// Выбрасывается при ошибке в инициализации приложения
/// {@endtemplate}
class AppInitializationException implements Exception {
  /// {@macro initialization_progress}
  final InitializationProgress initializationProgress;

  /// {@macro app_initialization_exception}
  AppInitializationException({required this.initializationProgress});

  @override
  String toString() => 'AppInitializationException: $initializationProgress';
}

/// {@template core_initialization_exception}
/// Выбрасывается при ошибке в инициализации основы приложения
/// {@endtemplate}
class CoreInitializationException implements Exception {}
