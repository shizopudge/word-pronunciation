import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/features/word/bloc/word.dart';
import 'package:word_pronunciation/src/features/word/presentation/widgets/widgets.dart';
import 'package:word_pronunciation/src/features/word/scope/word_scope.dart';

/// Экран с словом
@immutable
@RoutePage<void>()
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
class _WordView extends StatelessWidget {
  /// Создает [WordPage] view
  const _WordView();

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: BluredAppBar(
          backgroundColor: (context.theme.isDark
                  ? context.theme.colors.black
                  : context.theme.colors.white)
              .withOpacity(.2),
          title: Text(context.localization.word),
        ),
        body: const _WordBody(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: const WordFloatingButton(),
      );
}

/// Тело [_WordView]
@immutable
class _WordBody extends StatelessWidget {
  /// Создает тело [_WordView]
  const _WordBody();

  @override
  Widget build(BuildContext context) => BlocBuilder<WordBloc, WordState>(
        bloc: WordScope.of(context).wordBloc,
        buildWhen: (previous, current) => !current.isError,
        builder: (context, state) => AnimatedSwitcher(
          duration: Durations.short4,
          child: state.map(
            idle: (i) => WordIdleLayout(word: i.word),
            progress: (p) => const ProgressLayout(),
            error: (e) => WordErrorLayout(
              message: e.errorHandler.toMessage(context),
            ),
          ),
        ),
      );
}
