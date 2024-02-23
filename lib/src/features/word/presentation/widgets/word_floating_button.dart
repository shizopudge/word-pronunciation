import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/resources/recources.dart';
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
              return _MicButton(onTap: () => _togglePronunciation(context));
            } else if (state.isFatalError) {
              return _TryAgainButton(
                onTap: () => _tryAgain(context),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      );

  /// Обработчик кнопки "Попробовать снова"
  void _tryAgain(BuildContext context) =>
      WordScope.of(context).wordBloc.add(const WordEvent.read());

  /// Начинает произношение
  void _togglePronunciation(BuildContext context) {
    final bloc = WordScope.of(context).wordPronunciationBloc;
    if (bloc.state.isPronouncing) {
      return bloc.add(const WordPronunciationEvent.stop());
    }
    return bloc.add(const WordPronunciationEvent.pronounce());
  }
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
class _MicButton extends StatelessWidget {
  /// Обрбаотчик нажатия
  final VoidCallback onTap;

  /// Создает кнопку микрофона
  const _MicButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<WordPronunciationBloc, WordPronunciationState>(
        bloc: WordScope.of(context).wordPronunciationBloc,
        builder: (context, state) => TweenAnimationBuilder<double>(
          duration: Durations.short4,
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, scale, child) => ScaleTransition(
            scale: AlwaysStoppedAnimation<double>(scale),
            child: IconButton(
              onPressed: onTap,
              tooltip: context.localization.startPronunciation,
              constraints: BoxConstraints.tight(const Size.square(56)),
              style: IconButton.styleFrom(
                backgroundColor: context.theme.colors.white,
                foregroundColor: context.theme.colors.blue,
                elevation: 12,
              ),
              icon: AnimatedSwitcher(
                duration: Durations.short3,
                child: state.maybeWhen(
                  orElse: () => const Icon(
                    Icons.mic,
                    size: 40,
                  ),
                  pronunciation: (_) => ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      context.theme.colors.red,
                      BlendMode.srcIn,
                    ),
                    child: Lottie.asset(
                      Assets.animations.audioPlaying,
                      width: 32,
                      height: 32,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.play_arrow_rounded,
                        size: 32,
                        color: context.theme.colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
