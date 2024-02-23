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

  /// Возвращает [CoreDependencies] или завершается с [FlutterError] - Out
  /// of scope
  static CoreDependencies of(BuildContext context) {
    final inheritedDependencies =
        context.getInheritedWidgetOfExactType<_InheritedCoreDependencies>();

    if (inheritedDependencies == null) {
      throw FlutterError('Out of scope, not found CoreDependenciesScope');
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

/// Виджет хранящий в себе [CoreDependencies]
@immutable
class _InheritedCoreDependencies extends InheritedWidget {
  /// {@macro core_dependencies}
  final CoreDependencies coreDependencies;

  /// Создает виджет хранящий в себе [CoreDependencies]
  const _InheritedCoreDependencies({
    required this.coreDependencies,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant _InheritedCoreDependencies oldWidget) =>
      oldWidget.coreDependencies != coreDependencies;
}
