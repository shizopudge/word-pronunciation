import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';

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

/// Маска с градиентом выцветания нижней части прокручиваемого виджета
@immutable
class ScrollFadeBottomMask extends StatelessWidget {
  /// Начало выцветания
  final double startsAt;

  /// {@macro scroll_controller}
  final ScrollController? _scrollController;

  /// Дочерний виджет
  final Widget? _child;

  /// Конструктор дочернего виджета
  final ScrollableWidgetBuilder? _builder;

  /// Если true, значит использован конструктор
  /// [ScrollFadeBottomMask.withController]
  final bool _withController;

  /// Создает [_ScrollFadeBottomMaskWithMixin]
  const ScrollFadeBottomMask({
    required this.startsAt,
    required ScrollableWidgetBuilder builder,
    super.key,
  })  : _scrollController = null,
        _child = null,
        _builder = builder,
        _withController = false;

  /// Создает [_ScrollFadeBottomMaskWithController]
  const ScrollFadeBottomMask.withController({
    required this.startsAt,
    required ScrollController scrollController,
    required Widget child,
    super.key,
  })  : _builder = null,
        _scrollController = scrollController,
        _child = child,
        _withController = true;

  @override
  Widget build(BuildContext context) {
    if (_withController) {
      return _ScrollFadeBottomMaskWithController(
        startsAt: startsAt,
        scrollController: _scrollController!,
        child: _child!,
      );
    }

    return _ScrollFadeBottomMaskWithMixin(
      startsAt: startsAt,
      builder: _builder!,
    );
  }
}

/// Обертка прокручиваемого виджета с [FadeBottomMask]
@immutable
class _ScrollFadeBottomMaskWithController extends StatefulWidget {
  /// Начало выцветания
  final double startsAt;

  /// {@macro scroll_controller}
  final ScrollController scrollController;

  /// Дочерний виджет
  final Widget child;

  /// Создает обертку прокручиваемого виджета с [FadeBottomMask] и передаваемым
  /// [ScrollController]
  const _ScrollFadeBottomMaskWithController({
    required this.startsAt,
    required this.scrollController,
    required this.child,
  });

  @override
  State<_ScrollFadeBottomMaskWithController> createState() =>
      _ScrollFadeBottomMaskWithControllerState();
}

class _ScrollFadeBottomMaskWithControllerState
    extends State<_ScrollFadeBottomMaskWithController> {
  /// {@template is_fade_mask_enabled_controller}
  /// Если true, значит маска включена
  /// {@endtemplate}
  late final ValueNotifier<bool> _isFadeMaskEnabledController;

  @override
  void initState() {
    super.initState();
    _isFadeMaskEnabledController = ValueNotifier<bool>(false);
    _initialize();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _isFadeMaskEnabledController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _isFadeMaskEnabledController,
        builder: (context, child) => FadeBottomMask(
          startsAt: widget.startsAt,
          isEnabled: _isFadeMaskEnabled,
          child: widget.child,
        ),
      );

  /// Инициализирует
  void _initialize() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_scrollController.hasClients) return;
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        _isFadeMaskEnabledController.value = maxScrollExtent > 0.0;
        _scrollController.addListener(_scrollListener);
      });

  /// Слушатель скролла
  void _scrollListener() {
    if (!_scrollController.hasClients) return;
    final isEndOfScroll =
        _scrollController.position.atEdge && _scrollController.offset > 0.0;
    final isFadeMaskEnabled = !isEndOfScroll;
    if (_isFadeMaskEnabledController.value != isFadeMaskEnabled) {
      _isFadeMaskEnabledController.value = isFadeMaskEnabled;
    }
  }

  /// Возвращает true, если [FadeBottomMask] включена
  bool get _isFadeMaskEnabled => _isFadeMaskEnabledController.value;

  /// Возвращает контроллер скролла
  ScrollController get _scrollController => widget.scrollController;
}

/// Обертка прокручиваемого виджета с [FadeBottomMask] и
/// [ScrollFadeBottomMaskMixin]
@immutable
class _ScrollFadeBottomMaskWithMixin extends StatefulWidget {
  /// Начало выцветания
  final double startsAt;

  /// Конструктор дочернего виджета
  final ScrollableWidgetBuilder builder;

  /// Создает обертку прокручиваемого виджета с [FadeBottomMask] и
  /// [ScrollFadeBottomMaskMixin]
  const _ScrollFadeBottomMaskWithMixin({
    required this.startsAt,
    required this.builder,
  });

  @override
  State<_ScrollFadeBottomMaskWithMixin> createState() =>
      _ScrollFadeBottomMaskWithMixinState();
}

class _ScrollFadeBottomMaskWithMixinState
    extends State<_ScrollFadeBottomMaskWithMixin>
    with ScrollFadeBottomMaskMixin {
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: isFadeMaskEnabledController,
        builder: (context, child) => FadeBottomMask(
          startsAt: widget.startsAt,
          isEnabled: isFadeMaskEnabled,
          child: widget.builder(context, scrollController),
        ),
      );
}
