import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:word_pronunciation/src/core/resources/recources.dart';

/// Анимация проигрывания аудио
@immutable
class AudioAnimation extends StatelessWidget {
  /// Цвет
  final Color color;

  /// Размер
  final double size;

  /// Создает анимацию проигрывания аудио
  const AudioAnimation({
    required this.color,
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ColorFiltered(
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        child: Lottie.asset(
          Assets.animations.audioPlaying,
          width: size,
          height: size,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.play_arrow_rounded,
            size: size,
            color: color,
          ),
        ),
      );
}
