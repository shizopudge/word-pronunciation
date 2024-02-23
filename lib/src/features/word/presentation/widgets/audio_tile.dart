import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/resources/recources.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/features/word/bloc/word_audio.dart';
import 'package:word_pronunciation/src/features/word/data/model/phonetic.dart';
import 'package:word_pronunciation/src/features/word/scope/word_scope.dart';

/// Плитка с аудио
@immutable
class AudioTile extends StatelessWidget {
  /// Состояние
  final WordAudioState state;

  /// Фонетика
  final Phonetic phonetic;

  /// Создает плитку с аудио
  const AudioTile({
    required this.state,
    required this.phonetic,
    super.key,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => _onTap(context),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _AudioIcon(
                state: state,
                audioUrl: phonetic.audio,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  phonetic.license?.name ?? context.localization.unknownLicense,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.theme.textTheme.titleSmall?.copyWith(
                    color: context.theme.isDark
                        ? context.theme.colors.white
                        : context.theme.colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  /// Обработчик нажатия
  void _onTap(BuildContext context) {
    final bloc = WordScope.of(context).wordAudioBloc;
    if (state.isPlaying && state.audioUrlOrNull == phonetic.audio) {
      return bloc.add(const WordAudioEvent.stop());
    }
    return bloc.add(WordAudioEvent.play(audioUrl: phonetic.audio));
  }
}

/// Иконка аудио
@immutable
class _AudioIcon extends StatelessWidget {
  /// Состояние
  final WordAudioState state;

  /// Url аудио
  final String audioUrl;

  /// Создает иконку аудио
  const _AudioIcon({
    required this.state,
    required this.audioUrl,
  });

  @override
  Widget build(BuildContext context) {
    final defaultIcon = Icon(
      Icons.audiotrack_rounded,
      size: 32,
      color: context.theme.colors.blue,
    );

    if (audioUrl != state.audioUrlOrNull) return defaultIcon;

    return AnimatedSwitcher(
      duration: Durations.short4,
      child: state.maybeMap(
        orElse: () => defaultIcon,
        progress: (value) =>
            PrimaryLoadingIndicator(color: context.theme.colors.blue),
        playing: (value) => ColorFiltered(
          colorFilter: ColorFilter.mode(
            context.theme.colors.blue,
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
    );
  }
}
