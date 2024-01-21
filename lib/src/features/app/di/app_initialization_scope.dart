import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/features/app/bloc/app_initialization.dart';
import 'package:word_pronunciation/src/features/app/data/datasource/app_initialization_datasource.dart';
import 'package:word_pronunciation/src/features/app/data/repository/app_initialization_repository.dart';

/// Область видимости инициализации приложения
@immutable
class AppInitializationScope extends StatefulWidget {
  /// Дочерний виджет
  final Widget child;

  /// Создает область видимости инициализации приложения
  const AppInitializationScope({
    required this.child,
    super.key,
  });

  /// Возвращает [AppInitializationBloc] или завершается с [ArgumentError] - Out
  /// of scope
  static InheritedAppInitialization of(BuildContext context) {
    final inheritedAppInitialization =
        context.getInheritedWidgetOfExactType<InheritedAppInitialization>();

    if (inheritedAppInitialization == null) {
      throw ArgumentError(
        'Out of scope, not found AppInitializationScope',
        'out_of_scope',
      );
    }

    return inheritedAppInitialization;
  }

  @override
  State<AppInitializationScope> createState() => _AppInitializationScopeState();
}

class _AppInitializationScopeState extends State<AppInitializationScope> {
  /// {@macro app_initialization_bloc}
  late final AppInitializationBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = AppInitializationBloc(
      repository: AppInitializationRepository(
        datasource: AppInitializationDatasource(),
      ),
    )..add(const AppInitializationEvent.initialize());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => InheritedAppInitialization(
        bloc: _bloc,
        child: widget.child,
      );
}

/// Виджет хранящий в себе [AppInitializationBloc]
@immutable
class InheritedAppInitialization extends InheritedWidget {
  /// {@macro dependencies}
  final AppInitializationBloc bloc;

  /// Создает виджет хранящий в себе [AppInitializationBloc]
  const InheritedAppInitialization({
    required this.bloc,
    required super.child,
    super.key,
  });

  @override
  bool updateShouldNotify(InheritedAppInitialization oldWidget) => false;
}
