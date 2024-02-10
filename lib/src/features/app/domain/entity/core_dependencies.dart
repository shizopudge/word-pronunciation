import 'package:flutter/widgets.dart';
import 'package:word_pronunciation/src/core/key_local_storage/key_local_storage.dart';
import 'package:word_pronunciation/src/features/app/di/core_dependencies_scope.dart';

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
