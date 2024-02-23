import 'package:flutter/material.dart';

/// Миксин для упрощения использования виджета [FadeBottomMask] со
/// скроллящимися виджетами
mixin ScrollFadeBottomMaskMixin<T extends StatefulWidget> on State<T> {
  /// {@template scroll_controller}
  /// Контроллер скролла
  /// {@endtemplate}
  late final ScrollController scrollController;

  /// {@template is_fade_mask_enabled_controller}
  /// Если true, значит маска включена
  /// {@endtemplate}
  late final ValueNotifier<bool> isFadeMaskEnabledController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    isFadeMaskEnabledController = ValueNotifier<bool>(false);
    _initialize();
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(_scrollListener)
      ..dispose();
    isFadeMaskEnabledController.dispose();
    super.dispose();
  }

  /// Инициализирует миксин
  @protected
  void _initialize() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!scrollController.hasClients) return;
        final maxScrollExtent = scrollController.position.maxScrollExtent;
        isFadeMaskEnabledController.value = maxScrollExtent > 0.0;
        scrollController.addListener(_scrollListener);
      });

  /// Слушатель скролла
  @protected
  void _scrollListener() {
    if (!scrollController.hasClients) return;
    final isEndOfScroll =
        scrollController.position.atEdge && scrollController.offset > 0.0;
    final isFadeMaskEnabled = !isEndOfScroll;
    if (isFadeMaskEnabledController.value != isFadeMaskEnabled) {
      isFadeMaskEnabledController.value = isFadeMaskEnabled;
    }
  }

  /// Возвращает true, если [FadeBottomMask] включена
  bool get isFadeMaskEnabled => isFadeMaskEnabledController.value;
}

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
      duration: Durations.long4,
      reverseDuration: Durations.short3,
    );
    _animation = ColorTween(begin: Colors.transparent, end: Colors.white)
        .animate(_animationController);
  }

  @override
  void didUpdateWidget(covariant FadeBottomMask oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isWidgetUpdated(oldWidget)) _animate();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animation,
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
  Future<void> _animate() {
    if (_animationController.isAnimating) _animationController.stop();
    return widget.isEnabled
        ? _animationController.forward()
        : _animationController.reverse();
  }

  /// Возвращает true, если виджет обновился
  bool _isWidgetUpdated(covariant FadeBottomMask oldWidget) =>
      oldWidget.isEnabled != widget.isEnabled;
}
