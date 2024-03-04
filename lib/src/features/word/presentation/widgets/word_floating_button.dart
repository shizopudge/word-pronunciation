import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/features/word/bloc/word.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_pronunciation.dart';
import 'package:word_pronunciation/src/features/word/presentation/word_page.dart';
import 'package:word_pronunciation/src/features/word/scope/word_scope.dart';

/// Плавающая кнопка на [WordPage]
@immutable
class WordFloatingButton extends StatelessWidget {
  /// Создает плавающую кнопку на [WordPage]
  const WordFloatingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        child: BlocBuilder<WordBloc, WordState>(
          bloc: WordScope.of(context).wordBloc,
          builder: (context, state) {
            if (state.isIdle || state.isError) {
              return _MicButton(
                onTap: WordScope.of(context).state.togglePronunciation,
              );
            } else if (state.isFatalError) {
              return _TryAgainButton(
                onTap: WordScope.of(context).state.tryAgain,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      );
}

/// Кнопка "Попробовать снова"
@immutable
class _TryAgainButton extends StatelessWidget {
  /// Обработчик нажатия
  final VoidCallback onTap;

  /// Создает кнопку "Попробовать снова"
  const _TryAgainButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: TweenAnimationBuilder<double>(
          duration: Durations.short4,
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, scale, child) => ScaleTransition(
            scale: AlwaysStoppedAnimation<double>(scale),
            child: PrimaryElevatedButton(
              onTap: onTap,
              child: Text(
                context.localization.restart,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      );
}

/// Кнопка микрофона
@immutable
class _MicButton extends StatefulWidget {
  /// Обрбаотчик нажатия
  final VoidCallback onTap;

  /// Создает кнопку микрофона
  const _MicButton({
    required this.onTap,
  });

  @override
  State<_MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<_MicButton>
    with SingleTickerProviderStateMixin {
  /// {@macro aniamtion_controller}
  late final AnimationController _animationController;

  /// {@macro animation}
  late final Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _animation = ColorTween(
      begin: context.themeRead.colors.blue,
      end: context.themeRead.colors.red,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<WordPronunciationBloc, WordPronunciationState>(
        bloc: WordScope.of(context).wordPronunciationBloc,
        listenWhen: (previous, current) =>
            current.isProcessing || current.isIdle,
        listener: (context, state) => _listener(state),
        builder: (context, state) => TweenAnimationBuilder<double>(
          duration: Durations.short4,
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, scale, child) => ScaleTransition(
            scale: AlwaysStoppedAnimation<double>(scale),
            child: AvatarGlow(
              glowColor: context.theme.colors.red,
              animate: state.isProcessing,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) => IconButton(
                  onPressed: widget.onTap,
                  tooltip: context.localization.startPronunciation,
                  constraints: BoxConstraints.tight(const Size.square(56)),
                  style: IconButton.styleFrom(
                    backgroundColor: context.theme.isDark
                        ? context.theme.colors.white
                        : context.theme.colors.black,
                    foregroundColor: _animation.value,
                    elevation: 12,
                  ),
                  icon: Icon(
                    Icons.mic,
                    size: 40,
                    color: _animation.value,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  /// Слушатель
  Future<void> _listener(WordPronunciationState state) {
    if (state.isProcessing) return _animationController.repeat(reverse: true);
    return Future<void>.sync(
      () => _animationController
        ..stop()
        ..reset(),
    );
  }
}
