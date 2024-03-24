import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/features/word/bloc/word.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_history.dart';
import 'package:word_pronunciation/src/features/word/presentation/widgets/widgets.dart';
import 'package:word_pronunciation/src/features/word/scope/word_scope.dart';

/// Экран с словом
@immutable
class WordPage extends StatelessWidget {
  /// Создает экран с словом
  const WordPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: context.theme.systemUiOverlayStyle
            .copyWith(statusBarColor: Colors.transparent),
        child: const WordScope(
          child: _WordView(),
        ),
      );
}

/// [WordPage] view
@immutable
class _WordView extends StatefulWidget {
  /// Создает [WordPage] view
  const _WordView();

  @override
  State<_WordView> createState() => _WordViewState();
}

class _WordViewState extends State<_WordView> {
  /// {@macro scroll_controller}
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: WordAppBar(scrollController: _scrollController),
        body: _WordBody(scrollController: _scrollController),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: const WordFloatingButton(),
      );

  /// Обработчик на скролл
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final bloc = WordScope.of(context).wordHistoryBloc;
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;
    WordScope.of(context).state.showWord = offset > 116;
    WordScope.of(context).state.showUpButton = offset > 250;
    final isBottom = offset >= maxScrollExtent * .95;
    if (isBottom && !bloc.state.isProgress && !bloc.state.isEndOfList) {
      bloc.add(
        WordHistoryEvent.read(
          filter: WordScope.of(context).wordHistoryFilterBloc.state,
        ),
      );
    }
  }
}

/// Тело [_WordView]
@immutable
class _WordBody extends StatelessWidget {
  /// {@macro scroll_controller}
  final ScrollController scrollController;

  /// Создает тело [_WordView]
  const _WordBody({
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) => BlocBuilder<WordBloc, WordState>(
        bloc: WordScope.of(context).wordBloc,
        buildWhen: (previous, current) => !current.isError,
        builder: (context, state) => AnimatedSwitcher(
          duration: Durations.short4,
          child: state.map(
            idle: (i) => WordIdleLayout(
              word: i.word,
              scrollController: scrollController,
            ),
            progress: (p) => const ProgressLayout(),
            error: (e) => WordErrorLayout(
              message: e.errorHandler.toMessage(context),
            ),
          ),
        ),
      );
}
