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
  /// {@macro animation_controller}
  late final AnimationController _animationController;

  /// {@template scale_aniamtion}
  /// Анимация масштабирования
  /// {@endtemplate}
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      value: 0.0,
      duration: Durations.short3,
      vsync: this,
    );
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.96).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final button = ScaleTransition(
      scale: _scaleAnimation,
      child: ElevatedButton(
        onPressed: _onTap,
        style: widget.style,
        child: AnimatedSize(
          duration: Durations.short2,
          child: AnimatedSwitcher(
            duration: Durations.short3,
            child: widget.isLoading
                ? PrimaryLoadingIndicator(color: context.theme.colors.white)
                : widget.child,
          ),
        ),
      ),
    );

    if (widget.onTap == null) return button;

    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: _animationController.reverse,
      behavior: HitTestBehavior.opaque,
      child: button,
    );
  }

  /// Возвращает обработчик нажатия
  VoidCallback? get _onTap {
    if (widget.isLoading) return () {};
    if (widget.onTap != null) return _handler;
    return null;
  }

  /// Обработчик
  void _handler() {
    _animationController
      ..stop()
      ..reset();
    widget.onTap?.call();
    _animationController.forward().whenComplete(_animationController.reverse);
  }
}
