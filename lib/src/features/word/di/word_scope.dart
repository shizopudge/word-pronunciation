import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/features/word/bloc/word.dart';
import 'package:word_pronunciation/src/features/word/data/datasource/word_datasource.dart';
import 'package:word_pronunciation/src/features/word/data/repository/word_repository.dart';

/// Область видимости зависимостей модуля word
@immutable
class WordScope extends StatefulWidget {
  /// Дочерний виджет
  final Widget child;

  /// Создает область видимости зависимостей модуля word
  const WordScope({
    required this.child,
    super.key,
  });

  /// Возвращает виджет передающий вниз по дереву зависимости области видмости модуля слова или завершается с [ArgumentError] - Out
  /// of scope
  static InheritedWordScope of(BuildContext context) {
    late final InheritedWordScope? inheritedWordScope;

    inheritedWordScope =
        context.getInheritedWidgetOfExactType<InheritedWordScope>();

    if (inheritedWordScope == null) {
      throw ArgumentError(
        'Out of scope, not found WordScope',
        'out_of_scope',
      );
    }

    return inheritedWordScope;
  }

  @override
  State<WordScope> createState() => _WordScopeState();
}

class _WordScopeState extends State<WordScope> {
  /// {@macro word_bloc}
  late final WordBloc _wordBloc;

  @override
  void initState() {
    super.initState();
    _wordBloc = WordBloc(
      repository: WordRepository(
        datasource: WordDatasource(dioClient: context.dependencies.dioClient),
      ),
    )..add(const WordEvent.read());
  }

  @override
  void dispose() {
    _wordBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => InheritedWordScope(
        wordBloc: _wordBloc,
        child: widget.child,
      );
}

/// Виджет передающий вниз по дереву зависимости области видмости модуля слова
class InheritedWordScope extends InheritedWidget {
  /// {@macro word_bloc}
  final WordBloc wordBloc;

  /// Создает виджет передающий вниз по дереву зависимости области видмости модуля слова
  const InheritedWordScope({
    required this.wordBloc,
    super.key,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedWordScope oldWidget) => false;
}
