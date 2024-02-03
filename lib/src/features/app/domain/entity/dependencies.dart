import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/app_connect/app_connect.dart';
import 'package:word_pronunciation/src/core/key_local_storage/key_local_storage.dart';
import 'package:word_pronunciation/src/core/router/router.dart';
import 'package:word_pronunciation/src/features/app/di/core_dependencies_scope.dart';
import 'package:word_pronunciation/src/features/app/di/dependencies_scope.dart';

/// {@template core_dependencies}
/// Основные зависимости приложения
/// {@endtemplate}
abstract interface class CoreDependencies {
  /// Возвращает основные зависимости приложения из [CoreDependenciesScope]
  factory CoreDependencies.of(BuildContext context) =>
      CoreDependenciesScope.of(context);

  /// {@macro key_local_storage}
  abstract final IKeyLocalStorage keyLocalStorage;

  /// Вызывается при удалении зависимостей
  Future<void> dispose();
}

/// {@template mutable_core_dependencies}
/// Мутабельные основные зависимости приложения
/// {@endtemplate}
final class $MutableCoreDependencies implements CoreDependencies {
  @override
  late IKeyLocalStorage keyLocalStorage;

  /// Возвращает иммутабельные основные зависимости приложения
  CoreDependencies freeze() =>
      _$ImmutableCoreDependencies(keyLocalStorage: keyLocalStorage);

  @override
  Future<void> dispose() async {}
}

/// {@template immutable_core_dependencies}
/// Иммутабельные основные зависимости приложения
/// {@endtemplate}
@immutable
final class _$ImmutableCoreDependencies implements CoreDependencies {
  /// {@macro immutable_core_dependencies}
  const _$ImmutableCoreDependencies({
    required this.keyLocalStorage,
  });

  @override
  final IKeyLocalStorage keyLocalStorage;

  @override
  Future<void> dispose() async {}
}

/// {@template dependencies}
/// Зависимости приложения
/// {@endtemplate}
abstract interface class Dependencies implements CoreDependencies {
  /// Возвращает зависимости приложения из [DependenciesScope]
  factory Dependencies.of(BuildContext context) =>
      DependenciesScope.of(context);

  /// {@macro key_local_storage}
  @override
  abstract final IKeyLocalStorage keyLocalStorage;

  /// {@macro app_router}
  abstract final AppRouter router;

  /// {@macro app_connect.dart}
  abstract final IAppConnect appConnect;

  /// Вызывается при удалении зависимостей
  @override
  Future<void> dispose();
}

/// {@template mutable_dependencies}
/// Мутабельные зависимости
/// {@endtemplate}
final class $MutableDependencies implements Dependencies {
  /// {@macro mutable_dependencies}
  $MutableDependencies({
    required this.keyLocalStorage,
  });

  @override
  final IKeyLocalStorage keyLocalStorage;

  @override
  late AppRouter router;

  @override
  late IAppConnect appConnect;

  /// Возвращает иммутабельные зависимости
  Dependencies freeze() => _$ImmutableDependencies(
        keyLocalStorage: keyLocalStorage,
        router: router,
        appConnect: appConnect,
      );

  @override
  Future<void> dispose() async {
    router.dispose();
  }
}

/// {@template immutable_dependencies}
/// Иммутабельные зависимости
/// {@endtemplate}
@immutable
final class _$ImmutableDependencies implements Dependencies {
  /// {@macro immutable_dependencies}
  const _$ImmutableDependencies({
    required this.keyLocalStorage,
    required this.router,
    required this.appConnect,
  });

  @override
  final IKeyLocalStorage keyLocalStorage;

  @override
  final AppRouter router;

  @override
  final IAppConnect appConnect;

  @override
  Future<void> dispose() async {
    router.dispose();
  }
}
