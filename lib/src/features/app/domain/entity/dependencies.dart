import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/app_connect/app_connect.dart';
import 'package:word_pronunciation/src/core/dio/dio.dart';
import 'package:word_pronunciation/src/core/key_local_storage/key_local_storage.dart';
import 'package:word_pronunciation/src/core/router/router.dart';
import 'package:word_pronunciation/src/features/app/di/dependencies_scope.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/core_dependencies.dart';

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
    required this.dioClient,
  });

  @override
  final IKeyLocalStorage keyLocalStorage;

  @override
  final IDioClient dioClient;

  @override
  late AppRouter router;

  @override
  late IAppConnect appConnect;

  /// Возвращает иммутабельные зависимости
  Dependencies freeze() => _$ImmutableDependencies(
        keyLocalStorage: keyLocalStorage,
        dioClient: dioClient,
        router: router,
        appConnect: appConnect,
      );

  @override
  Future<void> dispose() async {
    router.dispose();
    dioClient.close();
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
    required this.dioClient,
    required this.router,
    required this.appConnect,
  });

  @override
  final IKeyLocalStorage keyLocalStorage;

  @override
  final IDioClient dioClient;

  @override
  final AppRouter router;

  @override
  final IAppConnect appConnect;

  @override
  Future<void> dispose() async {
    router.dispose();
    dioClient.close();
  }
}
