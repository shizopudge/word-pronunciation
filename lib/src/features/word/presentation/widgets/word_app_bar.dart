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
              late final Color appBarBackgroundColor;
              late final String title;

              final isWordProgress = wordState.isProgress;
              final word = wordState.word?.data;
              final isWordPronunciationProcessing = state.isProcessing;
              final showWord = WordScope.of(context).state.showWord;
              final showUpButton =
                  WordScope.of(context).state.showUpButton && !isWordProgress;

              if (isWordPronunciationProcessing) {
                appBarBackgroundColor =
                    context.theme.colors.black.withOpacity(.2);
              } else {
                appBarBackgroundColor = (context.theme.isDark
                        ? context.theme.colors.black
                        : context.theme.colors.white)
                    .withOpacity(.2);
              }

              if (showWord &&
                  word != null &&
                  word.isNotEmpty &&
                  !isWordProgress) {
                title = word;
              } else {
                title = context.localization.word;
              }

              return PronouncingFilter(
                enabled: state.isProcessing,
                color: context.theme.colors.black.withOpacity(.65),
                child: BluredAppBar(
                  backgroundColor: appBarBackgroundColor,
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
class _UpButton extends StatefulWidget {
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
  State<_UpButton> createState() => _UpButtonState();
}

class _UpButtonState extends State<_UpButton>
    with SingleTickerProviderStateMixin {
  /// {@macro animation_controller}
  late final AnimationController _animationController;

  /// Анимация прозрачности
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      value: widget.show ? 1.0 : 0.0,
      vsync: this,
      duration: Durations.short4,
    );
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void didUpdateWidget(covariant _UpButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isWidgetUpdated(oldWidget)) _playAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _opacityAnimation,
        builder: (context, child) {
          final opacity = _opacityAnimation.value;

          if (opacity == 0.0) return const SizedBox.shrink();

          return Opacity(
            opacity: opacity,
            child: child,
          );
        },
        child: CupertinoButton(
          onPressed: widget.onTap,
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

  /// Проигрывает анимацию
  Future<void> _playAnimation() => widget.show
      ? _animationController.forward()
      : _animationController.reverse();

  /// Возвращает true, если виджет изменился
  bool _isWidgetUpdated(covariant _UpButton oldWidget) =>
      oldWidget.show != widget.show;
}
