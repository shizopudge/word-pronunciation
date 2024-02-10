import 'dart:async';

import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';

/// Слушатель подключения к интернету
@immutable
class InternetConnectionListener extends StatefulWidget {
  /// Дочерний виджет
  final Widget child;

  /// Создает слушатель подключения к интернету
  const InternetConnectionListener({
    required this.child,
    super.key,
  });

  @override
  State<InternetConnectionListener> createState() =>
      _InternetConnectionListenerState();
}

class _InternetConnectionListenerState
    extends State<InternetConnectionListener> {
  /// Контроллер состояния подключения к интернету
  late final ValueNotifier<bool> _hasConnectController;

  /// Подписка на изменения состояния подключения к интернету
  late final StreamSubscription<bool> _hasConnectSubscription;

  @override
  void initState() {
    super.initState();
    _hasConnectController = ValueNotifier<bool>(true);
    _hasConnectSubscription = context.hasConnect.listen(_onConnectChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _readHasConnect());
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _hasConnectController,
        builder: (context, child) => Stack(
          children: [
            IgnorePointer(
              ignoring: !_hasConnect,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  _dimColor(context, hasConnect: _hasConnect),
                  BlendMode.darken,
                ),
                child: widget.child,
              ),
            ),
            _NoConnectionBanner(hasConnect: _hasConnect),
          ],
        ),
      );

  /// Обработчик на изменения состояния подключения к интернету
  void _onConnectChanged(bool hasConnect) {
    if (_hasConnectController.value != hasConnect) {
      _hasConnectController.value = hasConnect;
    }
  }

  /// Читает состояние подключения к интернету
  Future<void> _readHasConnect() async {
    final hasConnect = await context.hasConnectRead;
    if (_hasConnectController.value != hasConnect) {
      _hasConnectController.value = hasConnect;
    }
  }

  /// Уничтожает выделенные ресурсы
  Future<void> _dispose() async {
    await _hasConnectSubscription.cancel();
    _hasConnectController.dispose();
  }

  /// Возвращает цвет затемнения
  Color _dimColor(
    BuildContext context, {
    required bool hasConnect,
  }) =>
      !hasConnect
          ? context.theme.colors.black.withOpacity(.2)
          : Colors.transparent;

  /// Возвращает true, если есть подключение к интернету
  bool get _hasConnect => _hasConnectController.value;
}

/// Баннер "Нет подключения"
@immutable
class _NoConnectionBanner extends StatefulWidget {
  /// Если true, значит есть подключение к интернету
  final bool hasConnect;

  /// Создает баннер "Нет подключения"
  const _NoConnectionBanner({
    required this.hasConnect,
  });

  @override
  State<_NoConnectionBanner> createState() => _NoConnectionBannerState();
}

class _NoConnectionBannerState extends State<_NoConnectionBanner>
    with SingleTickerProviderStateMixin {
  /// {@macro aniamtion_controller}
  late final AnimationController _animationController;

  /// Анимация
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Durations.medium1,
    );
    _animation = Tween<Offset>(begin: const Offset(0, -1.0), end: Offset.zero)
        .animate(_animationController);
  }

  @override
  void didUpdateWidget(covariant _NoConnectionBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isWidgetUpdated(oldWidget)) _animate();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SlideTransition(
        position: _animation,
        child: SizedBox(
          width: context.mediaQuery.size.width,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.theme.colors.red,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: context.theme.colors.black.withOpacity(.05),
                  offset: const Offset(0, .25),
                  blurRadius: 1,
                ),
                BoxShadow(
                  color: context.theme.colors.black.withOpacity(.1),
                  offset: const Offset(0, .5),
                  blurRadius: 2,
                ),
                BoxShadow(
                  color: context.theme.colors.black.withOpacity(.15),
                  offset: const Offset(0, .75),
                  blurRadius: 3,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 12,
                  left: 24,
                  right: 24,
                  bottom: 20,
                ),
                child: _NoConnectionBody(),
              ),
            ),
          ),
        ),
      );

  /// Анимирует виджет
  Future<void> _animate() => widget.hasConnect
      ? _animationController.reverse()
      : _animationController.forward();

  /// Возвращает true, если виджет обновился
  bool _isWidgetUpdated(covariant _NoConnectionBanner oldWidget) =>
      oldWidget.hasConnect != widget.hasConnect;
}

/// Тело сообщения о подключении к интернету
@immutable
class _NoConnectionBody extends StatefulWidget {
  /// Создает тело сообщения о подключении к интернету
  const _NoConnectionBody();

  @override
  State<_NoConnectionBody> createState() => _NoConnectionBodyState();
}

class _NoConnectionBodyState extends State<_NoConnectionBody>
    with SingleTickerProviderStateMixin {
  /// {@macro aniamtion_controller}
  late final AnimationController _animationController;

  /// Анимация
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animation = ColorTween(
            begin: context.theme.colors.white, end: context.theme.colors.grey)
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 54,
              color: _animation.value,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                context.localization?.checkInternetConnection ??
                    'Check your internet connection!',
                textAlign: TextAlign.center,
                style: context.theme.textTheme.titleMedium?.copyWith(
                  color: _animation.value,
                ),
              ),
            ),
          ],
        ),
      );
}
