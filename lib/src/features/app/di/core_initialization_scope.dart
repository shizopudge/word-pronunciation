import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/features/app/bloc/core_initialization.dart';
import 'package:word_pronunciation/src/features/app/data/datasource/core_initialization_datasource.dart';
import 'package:word_pronunciation/src/features/app/data/repository/core_initialization_repository.dart';

/// Область видимости инициализации основы приложения
@immutable
class CoreInitializationScope extends StatefulWidget {
  /// Конструктор дочернего виджета
  final WidgetBuilder builder;

  /// Создает область видимости инициализации основы приложения
  const CoreInitializationScope({
    required this.builder,
    super.key,
  });

  /// Возвращает виджет хранящий в себе [CoreInitializationBloc] или завершается с [ArgumentError] - Out
  /// of scope
  static InheritedAppInitialization of(BuildContext context) {
    final inheritedAppInitialization =
        context.getInheritedWidgetOfExactType<InheritedAppInitialization>();

    if (inheritedAppInitialization == null) {
      throw ArgumentError(
        'Out of scope, not found CoreInitializationScope',
        'out_of_scope',
      );
    }

    return inheritedAppInitialization;
  }

  @override
  State<CoreInitializationScope> createState() =>
      _CoreInitializationScopeState();
}

class _CoreInitializationScopeState extends State<CoreInitializationScope> {
  /// {@macro core_initialization_bloc}
  late final CoreInitializationBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CoreInitializationBloc(
      repository: CoreInitializationRepository(
        datasource: CoreInitializationDatasource(),
      ),
    )..add(const CoreInitializationEvent.initialize());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => InheritedAppInitialization(
        bloc: _bloc,
        child: Builder(builder: widget.builder),
      );
}

/// Виджет хранящий в себе [CoreInitializationBloc]
@immutable
class InheritedAppInitialization extends InheritedWidget {
  /// {@macro core_initialization_bloc}
  final CoreInitializationBloc bloc;

  /// Создает виджет хранящий в себе [CoreInitializationBloc]
  const InheritedAppInitialization({
    required this.bloc,
    required super.child,
    super.key,
  });

  @override
  bool updateShouldNotify(covariant InheritedAppInitialization oldWidget) =>
      oldWidget.bloc != bloc;
}
