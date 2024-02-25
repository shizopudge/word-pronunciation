import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/app_connect/app_connect.dart';
import 'package:word_pronunciation/src/core/database/database.dart';
import 'package:word_pronunciation/src/core/dio/dio.dart';
import 'package:word_pronunciation/src/core/key_local_storage/key_local_storage.dart';
import 'package:word_pronunciation/src/core/router/router.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/core_dependencies.dart';
import 'package:word_pronunciation/src/features/app/scope/scope.dart';

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

  /// {@macro db}
  abstract final IDB db;

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

  @override
  late IDB db;

  /// Возвращает иммутабельные зависимости
  Dependencies freeze() => _$ImmutableDependencies(
        keyLocalStorage: keyLocalStorage,
        dioClient: dioClient,
        router: router,
        appConnect: appConnect,
        db: db,
      );

  @override
  Future<void> dispose() async {
    router.dispose();
    dioClient.close();
    await db.dispose();
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
    required this.db,
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
  final IDB db;

  @override
  Future<void> dispose() async {
    router.dispose();
    dioClient.close();
    await db.dispose();
  }
}
