import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/features/word/bloc/word.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_pronunciation.dart';
import 'package:word_pronunciation/src/features/word/presentation/widgets/widgets.dart';
import 'package:word_pronunciation/src/features/word/presentation/word_page.dart';
import 'package:word_pronunciation/src/features/word/scope/word_scope.dart';

/// Апп бар [WordPage]
@immutable
class WordAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// {@macro scroll_controller}
  final ScrollController scrollController;

  /// Создает апп бар [WordPage]
  const WordAppBar({
    required this.scrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context) => BlocBuilder<WordBloc, WordState>(
        buildWhen: (previous, current) => current.word != null,
        bloc: WordScope.of(context).wordBloc,
        builder: (context, wordState) =>
            BlocBuilder<WordPronunciationBloc, WordPronunciationState>(
          bloc: WordScope.of(context).wordPronunciationBloc,
          buildWhen: (previous, current) =>
              current.isProcessing || current.isIdle,
          builder: (context, state) => AnimatedBuilder(
            animation: Listenable.merge(
              [
                WordScope.of(context).state.showWordInAppBarController,
                WordScope.of(context).state.showUpButtonController,
              ],
            ),
            builder: (context, child) {
              late final String title;

              final word = wordState.word?.data;
              final showWord = WordScope.of(context).state.showWord;
              final showUpButton = WordScope.of(context).state.showUpButton;

              if (showWord && word != null && word.isNotEmpty) {
                title = word;
              } else {
                title = context.localization.word;
              }

              return PronouncingFilter(
                enabled: state.isProcessing,
                color: context.theme.colors.black.withOpacity(.65),
                child: BluredAppBar(
                  backgroundColor: (context.theme.isDark
                          ? context.theme.colors.black
                          : context.theme.colors.white)
                      .withOpacity(.2),
                  action: _UpButton(
                    onTap: _scrollToTop,
                    show: showUpButton,
                  ),
                  title: AnimatedSwitcher(
                    duration: Durations.short4,
                    layoutBuilder: (currentChild, previousChildren) => Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
                        ...previousChildren,
                        if (currentChild != null) currentChild,
                      ],
                    ),
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      key: Key(title),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

  /// Скроллит экран вверх
  Future<void> _scrollToTop() => scrollController.animateTo(
        0,
        duration: Durations.short4,
        curve: Curves.linear,
      );

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

/// Кнопка "Вверх"
@immutable
class _UpButton extends StatelessWidget {
  /// Обработчик нажатия
  final VoidCallback onTap;

  /// Если true, то кнопка отображена
  final bool show;

  /// Создает кнопку "Вверх"
  const _UpButton({
    required this.onTap,
    required this.show,
  });

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder(
        duration: Durations.short4,
        tween: show
            ? Tween<double>(begin: 0.0, end: 1.0)
            : Tween<double>(begin: 1.0, end: 0.0),
        builder: (context, opacity, child) {
          if (opacity == 0.0) return const SizedBox.shrink();

          return Opacity(
            opacity: opacity,
            child: CupertinoButton(
              onPressed: onTap,
              minSize: 32,
              child: Text(
                context.localization.up,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.theme.textTheme.titleSmall?.copyWith(
                  color: context.theme.colors.blue,
                ),
              ),
            ),
          );
        },
      );
}
