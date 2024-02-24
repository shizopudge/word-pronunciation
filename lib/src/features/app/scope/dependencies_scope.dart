import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/features/app/domain/entity/dependencies.dart';

/// Область видимости зависимостей приложения
@immutable
class DependenciesScope extends StatefulWidget {
  /// {@macro dependencies}
  final Dependencies dependencies;

  /// Дочерний виджет
  final Widget child;

  /// Создает область видимости зависимостей приложения
  const DependenciesScope({
    required this.dependencies,
    required this.child,
    super.key,
  });

  /// Возвращает [Dependencies] или завершается с [FlutterError] - Out
  /// of scope
  static Dependencies of(BuildContext context) {
    final inheritedDependencies =
        context.getInheritedWidgetOfExactType<_InheritedDependencies>();

    if (inheritedDependencies == null) {
      throw FlutterError('Out of scope, not found DependenciesScope');
    }

    return inheritedDependencies.dependencies;
  }

  @override
  State<DependenciesScope> createState() => _DependenciesScopeState();
}

class _DependenciesScopeState extends State<DependenciesScope> {
  @override
  void dispose() {
    widget.dependencies.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _InheritedDependencies(
        dependencies: widget.dependencies,
        child: widget.child,
      );
}

/// Виджет хранящий в себе [Dependencies]
@immutable
class _InheritedDependencies extends InheritedWidget {
  /// {@macro dependencies}
  final Dependencies dependencies;

  /// Создает виджет хранящий в себе [Dependencies]
  const _InheritedDependencies({
    required this.dependencies,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant _InheritedDependencies oldWidget) =>
      oldWidget.dependencies != dependencies;
}
