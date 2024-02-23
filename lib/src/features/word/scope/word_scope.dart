import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/features/word/bloc/word.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_audio.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_pronunciation.dart';
import 'package:word_pronunciation/src/features/word/data/datasource/word_datasource.dart';
import 'package:word_pronunciation/src/features/word/data/repository/word_repository.dart';
import 'package:word_pronunciation/src/features/word/presentation/widgets/widgets.dart';

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

  /// Возвращает виджет хранящий в себе [WordScope] или завершается с
  /// [FlutterError] - Out of scope
  static InheritedWordScope of(BuildContext context) {
    late final InheritedWordScope? inheritedWordScope;

    inheritedWordScope =
        context.getInheritedWidgetOfExactType<InheritedWordScope>();

    if (inheritedWordScope == null) {
      throw FlutterError('Out of scope, not found WordScope');
    }

    return inheritedWordScope;
  }

  @override
  State<WordScope> createState() => WordScopeState();
}

class WordScopeState extends State<WordScope> {
  /// {@macro word_bloc}
  late final WordBloc _wordBloc;

  /// {@macro word_audio_bloc}
  late final WordAudioBloc _wordAudioBloc;

  /// {@macro word_pronunciation_bloc}
  late final WordPronunciationBloc _wordPronunciationBloc;

  /// {@macro overlay}
  OverlayState? _overlay;

  /// {@template overlay_entry}
  /// Наложение на оверлей
  /// {@endtemplate}
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _wordBloc = WordBloc(
      repository: WordRepository(
        datasource: WordDatasource(dioClient: context.dependencies.dioClient),
      ),
    )..add(const WordEvent.read());
    _wordAudioBloc = WordAudioBloc();
    _wordPronunciationBloc = WordPronunciationBloc()
      ..add(const WordPronunciationEvent.initialize());
  }

  @override
  void dispose() {
    _wordBloc.close();
    _wordAudioBloc.close();
    _wordPronunciationBloc.close();
    _overlayEntry
      ?..remove()
      ..dispose();
    _overlay?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => InheritedWordScope(
        wordBloc: _wordBloc,
        wordAudioBloc: _wordAudioBloc,
        wordPronunciationBloc: _wordPronunciationBloc,
        state: this,
        child: widget.child,
      );

  /// Показывает результат произношения
  void showResult() {
    if (!mounted) return;
    _overlay ??= Overlay.of(context);
    _overlayEntry
      ?..remove()
      ..dispose();
    _overlayEntry = OverlayEntry(
      builder: (context) =>
          WordOverlay(wordPronunciationBloc: _wordPronunciationBloc),
    );
    if (_overlayEntry == null) return;
    _overlay?.insert(_overlayEntry!);
  }

  /// Скрывает результат произношения
  void hideResult() {
    if (!mounted) return;
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }
}

/// Виджет хранящий в себе [WordScope]
class InheritedWordScope extends InheritedWidget {
  /// {@macro word_bloc}
  final WordBloc wordBloc;

  /// {@macro word_audio_bloc}
  final WordAudioBloc wordAudioBloc;

  /// {@macro word_pronunciation_bloc}
  final WordPronunciationBloc wordPronunciationBloc;

  /// Состояние [WordScope]
  final WordScopeState state;

  /// Создает виджет хранящий в себе [WordScope]
  const InheritedWordScope({
    required this.wordBloc,
    required this.wordAudioBloc,
    required this.wordPronunciationBloc,
    required this.state,
    required super.child,
    super.key,
  });

  @override
  bool updateShouldNotify(covariant InheritedWordScope oldWidget) =>
      oldWidget.wordBloc != wordBloc ||
      oldWidget.wordAudioBloc != wordAudioBloc ||
      oldWidget.wordPronunciationBloc != wordPronunciationBloc ||
      oldWidget.state != state;
}
