import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';

/// Основная elevated кнопка приложения
@immutable
class PrimaryElevatedButton extends StatefulWidget {
  /// Ообработчик нажатия
  final VoidCallback? onTap;

  /// Дочерний виджет
  final Widget child;

  /// Стиль кнопки
  final ButtonStyle? style;

  /// Если true, то вместо [child] отображается индикатор загрузки
  final bool isLoading;

  /// Создает основную elevated кнопку приложения
  const PrimaryElevatedButton({
    required this.onTap,
    required this.child,
    this.style,
    this.isLoading = false,
    super.key,
  });

  @override
  State<PrimaryElevatedButton> createState() => _PrimaryElevatedButtonState();
}

class _PrimaryElevatedButtonState extends State<PrimaryElevatedButton>
    with SingleTickerProviderStateMixin {
  /// {@template scale_animation_controller}
  /// Контроллер анимации масштаба
  /// {@endtemplate}
  late final AnimationController _scaleAnimationController;

  @override
  void initState() {
    super.initState();
    _scaleAnimationController = AnimationController(
      value: 1.0,
      lowerBound: 0.96,
      upperBound: 1.0,
      duration: Durations.short3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _scaleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final button = ScaleTransition(
      scale: _scaleAnimationController,
      child: ElevatedButton(
        onPressed: _onTap,
        style: widget.style,
        child: PrimaryAnimatedSwitcher(
          child: widget.isLoading
              ? PrimaryLoadingIndicator(color: context.theme.colors.white)
              : widget.child,
        ),
      ),
    );

    if (widget.onTap == null) return button;

    return GestureDetector(
      onTapDown: (_) => _scaleAnimationController.reverse(),
      onTapUp: (_) => _scaleAnimationController.forward(),
      onTapCancel: _scaleAnimationController.forward,
      behavior: HitTestBehavior.opaque,
      child: button,
    );
  }

  /// Возвращает обработчик нажатия если он был передан, иначе null
  VoidCallback? get _onTap {
    if (widget.isLoading) return () {};
    if (widget.onTap != null) return _handler;
    return null;
  }

  /// Обработчик нажатия
  void _handler() {
    _scaleAnimationController
      ..stop()
      ..reset();
    widget.onTap?.call();
    _scaleAnimationController
        .reverse()
        .whenComplete(_scaleAnimationController.forward);
  }
}
