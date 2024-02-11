import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';

/// Tween для анимации индикатора загрузки
class DelayTween extends Tween<double> {
  /// Создает Tween для анимации индикатора загрузки
  DelayTween({
    super.begin,
    super.end,
    required this.delay,
  });

  final double delay;

  @override
  double lerp(double t) {
    return super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}

/// Primary loading indicator
@immutable
class PrimaryLoadingIndicator extends StatefulWidget {
  /// Размер
  final double size;

  /// Цвет индикатора
  final Color? color;

  /// Создает primary loading indicator
  const PrimaryLoadingIndicator({
    this.size = 32.0,
    this.color,
    super.key,
  });

  @override
  State<PrimaryLoadingIndicator> createState() =>
      _PrimaryLoadingIndicatorState();
}

class _PrimaryLoadingIndicatorState extends State<PrimaryLoadingIndicator>
    with SingleTickerProviderStateMixin {
  /// Количество точек
  static const _itemCount = 12;

  /// {@template animation_controller}
  /// Контроллер анимации
  /// {@endtemplate}
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Durations.extralong4)
          ..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox.fromSize(
        size: Size.square(widget.size),
        child: Stack(
          children: List.generate(
            _itemCount,
            (index) => Positioned.fill(
              left: widget.size * .5,
              top: widget.size * .5,
              child: Transform(
                transform: Matrix4.rotationZ(30.0 * index * 0.0174533),
                child: Align(
                  alignment: Alignment.center,
                  child: FadeTransition(
                    opacity: DelayTween(
                      begin: 0.0,
                      end: 1.0,
                      delay: index / _itemCount,
                    ).animate(_animationController),
                    child: SizedBox.fromSize(
                      size: Size.square(widget.size * 0.15),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: _indicatorColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  /// Цвет инидкатора
  Color? get _indicatorColor =>
      widget.color ??
      (context.themeMaybe?.isDark ?? false
          ? context.themeMaybe?.colors.white
          : context.themeMaybe?.colors.black);
}
