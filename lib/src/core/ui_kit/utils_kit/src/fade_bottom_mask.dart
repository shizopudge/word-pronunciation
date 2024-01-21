import 'package:flutter/material.dart';

/// Маска с градиентом выцветания нижней части виджета
@immutable
class FadeBottomMask extends StatefulWidget {
  /// Дочерний виджет
  final Widget child;

  /// Начало выцветания
  final double startsAt;

  /// Если true, то маска включена, иначе выключена
  final bool isEnabled;

  /// Создает маску с градиентом выцветания нижней части виджета
  const FadeBottomMask({
    required this.child,
    required this.startsAt,
    this.isEnabled = true,
    super.key,
  });

  @override
  State<FadeBottomMask> createState() => _FadeBottomMaskState();
}

class _FadeBottomMaskState extends State<FadeBottomMask>
    with SingleTickerProviderStateMixin {
  /// {@macro animation_controller}
  late final AnimationController _animationController;

  /// {@template animation}
  /// Анимация
  /// {@endtemplate}
  late final Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      value: widget.isEnabled ? 1.0 : 0.0,
      duration: Durations.short4,
    );
    _animation = ColorTween(begin: Colors.transparent, end: Colors.white)
        .animate(_animationController);
  }

  @override
  void didUpdateWidget(covariant FadeBottomMask oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animate(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => ShaderMask(
          shaderCallback: (Rect rect) => LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              _animation.value ?? Colors.transparent,
            ],
            stops: [
              widget.startsAt,
              1.0,
            ],
          ).createShader(rect),
          blendMode: BlendMode.dstOut,
          child: widget.child,
        ),
      );

  /// Анимирует виджет
  void _animate(covariant FadeBottomMask oldWidget) {
    final isEnabledChanged = oldWidget.isEnabled != widget.isEnabled;
    if (!isEnabledChanged) return;
    if (_animationController.isAnimating) _animationController.stop();
    if (widget.isEnabled) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }
}
