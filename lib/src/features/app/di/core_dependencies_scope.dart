import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/core_dependencies.dart';

/// Область видимости основных зависимостей приложения
@immutable
class CoreDependenciesScope extends StatefulWidget {
  /// {@macro dependencies}
  final CoreDependencies coreDependencies;

  /// Дочерний виджет
  final Widget child;

  /// Создает область видимости основных зависимостей приложения
  const CoreDependenciesScope({
    required this.coreDependencies,
    required this.child,
    super.key,
  });

  /// Возвращает основные зависимости приложения или завершается с [ArgumentError] - Out
  /// of scope
  static CoreDependencies of(BuildContext context) {
    final inheritedDependencies =
        context.getInheritedWidgetOfExactType<_InheritedCoreDependencies>();

    if (inheritedDependencies == null) {
      throw ArgumentError(
        'Out of scope, not found CoreDependenciesScope',
        'out_of_scope',
      );
    }

    return inheritedDependencies.coreDependencies;
  }

  @override
  State<CoreDependenciesScope> createState() => _CoreDependenciesScopeState();
}

class _CoreDependenciesScopeState extends State<CoreDependenciesScope> {
  @override
  void dispose() {
    widget.coreDependencies.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _InheritedCoreDependencies(
        coreDependencies: widget.coreDependencies,
        child: widget.child,
      );
}

/// Виджет хранящий в себе основные зависимости приложения
@immutable
class _InheritedCoreDependencies extends InheritedWidget {
  /// {@macro core_dependencies}
  final CoreDependencies coreDependencies;

  /// Создает виджет хранящий в себе основные зависимости приложения
  const _InheritedCoreDependencies({
    required this.coreDependencies,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant _InheritedCoreDependencies oldWidget) =>
      false;
}
