import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/features/toaster/toaster.dart';

/// {@template toaster}
/// Тостер
/// {@endtemplate}
@immutable
class Toaster extends StatefulWidget {
  /// {@macro toaster_config}
  final ToasterConfig config;

  /// Обработчик на исчезновение тоста
  final VoidCallback onDismiss;

  /// {@macro toaster}
  const Toaster({
    required this.config,
    required this.onDismiss,
    super.key,
  });

  @override
  State<Toaster> createState() => _ToasterState();
}

class _ToasterState extends State<Toaster> with TickerProviderStateMixin {
  /// {@macro slide_controller}
  late final AnimationController _slideController;

  /// {@macro fade_controller}
  late final AnimationController _fadeController;

  /// {@template scale_controller}
  /// Контроллер масштаба
  /// {@endtemplate}
  late final AnimationController _scaleController;

  /// {@template slide_animation}
  /// Анимация скольжения
  /// {@endtemplate}
  late Animation<Offset> _slideAnimation;

  /// @macro timer}
  late final Timer timer;

  /// {@template per_tick_interval}
  /// Интервал между тиками таймера
  /// {@endtemplate}
  late final Duration _perTickInterval;

  /// {@macro toaster_theme}
  late ToasterTheme? _toasterTheme;

  /// Стиль текста
  TextStyle? _textStyle;

  /// Цвет иконки
  Color? _iconColor;

  /// Цвет фона
  Color? _backgroundColor;

  /// Если true, значит тостер исчез
  bool isDismissed = false;

  @override
  void initState() {
    super.initState();
    // Инициализация контроллеров и анимаций
    _initControllersAndAnimations();
    // Инициализация отложенного исчезновения
    _initDelayedDismiss();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Инициализация темы и стилей тостера
    _initThemeAndStyles();
  }

  @override
  void dispose() {
    timer.cancel();
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Dismissible(
              key: ObjectKey(widget.config),
              direction: DismissDirection.up,
              onDismissed: (_) {
                if (!isDismissed) {
                  isDismissed = true;
                  widget.onDismiss.call();
                }
              },
              child: ScaleTransition(
                scale: _scaleController,
                child: FadeTransition(
                  opacity: _fadeController.view,
                  child: AnimatedBuilder(
                    animation: _slideController,
                    builder: (context, child) => SlideTransition(
                      position: _slideAnimation,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: _toasterTheme?.borderRadius,
                          color: _backgroundColor,
                          boxShadow: _toasterTheme?.boxShadow,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 24),
                          child: Row(
                            children: [
                              if (widget.config.icon != null &&
                                  _iconColor != null &&
                                  widget.config.showIcon) ...[
                                ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    _iconColor ?? Colors.transparent,
                                    BlendMode.srcIn,
                                  ),
                                  child: widget.config.icon,
                                ),
                              ] else if (widget.config.showIcon) ...[
                                Icon(
                                  _defaultIcon,
                                  color: _iconColor,
                                ),
                              ],
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    widget.config.message,
                                    style: _textStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
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

  /// Инициализирует тему и стили тостера
  void _initThemeAndStyles() {
    _toasterTheme = context.theme.data.extensions.values
            .firstWhereOrNull((element) => element is ToasterTheme)
        as ToasterTheme?;
    if (_toasterTheme == null) return;
    _textStyle = switch (_type) {
      ToasterType.success => _toasterTheme?.successMessageStyle,
      ToasterType.warning => _toasterTheme?.warningMessageStyle,
      ToasterType.error => _toasterTheme?.errorMessageStyle,
      ToasterType.message => _toasterTheme?.messageStyle,
    };
    _iconColor = switch (_type) {
      ToasterType.success => _toasterTheme?.successIconColor,
      ToasterType.warning => _toasterTheme?.warningIconColor,
      ToasterType.error => _toasterTheme?.errorIconColor,
      ToasterType.message => _toasterTheme?.messageIconColor,
    };
    _backgroundColor = switch (_type) {
      ToasterType.success => _toasterTheme?.successBackgroundColor,
      ToasterType.warning => _toasterTheme?.warningBackgroundColor,
      ToasterType.error => _toasterTheme?.errorBackgroundColor,
      ToasterType.message => _toasterTheme?.messageBackgroundColor,
    };
  }

  /// Инициализирует контроллеры анимаций и анимации
  void _initControllersAndAnimations() {
    // Инициализация контроллеров и анимаций
    _slideController = AnimationController(
      vsync: this,
      duration: _slideDuration,
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: _fadeDuration,
    );
    _scaleController = AnimationController(
      value: 1.0,
      lowerBound: 0.95,
      upperBound: 1.0,
      duration: _scaleDuration,
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(_slideController);
    // Запуск анимаций
    for (final controller in _primaryControllers) {
      controller.forward();
    }
  }

  /// Инициализирует отложенное исчезновение
  void _initDelayedDismiss() {
    // Инициализация интервала
    _perTickInterval =
        Duration(milliseconds: widget.config.duration.inMilliseconds);
    // Инициализация таймера
    timer = Timer.periodic(_perTickInterval, _onTick);
  }

  /// Обработчик на тик таймера
  void _onTick(Timer timer) {
    if (timer.tick >= 1) {
      timer.cancel();
      _playDismissAnimations();
    }
  }

  /// Проигрывает анимации исчезновения
  Future<void> _playDismissAnimations() async {
    if (isDismissed) return;

    // Начинает уменьшение размера
    _scaleController.reverse();

    // Сброс значения контроллера скольжения на 0.0, после чего запуск с
    // обновленной [_slideAnimation] с [Offset.zero] до [Offset(0, .5)]
    _slideController.reset();
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, .5),
    ).animate(_slideController);
    await _slideController.forward();

    // По завершении анимации скольжения перед исчезновением начинается анимация
    // возвращения масштаба
    _scaleController.forward();

    // Запуск анимации скольжения на стандартный оффсет и обновление
    // длительности
    _slideController.duration =
        Duration(milliseconds: _slideDuration.inMilliseconds ~/ 2);
    await _slideController.reverse();

    // Запуск анимации выцветания в обратном направлении
    _fadeController.reverse();

    // Сброс значения контроллера скольжения на 0.0, после чего запуск с
    // обновленной [_slideAnimation] с [Offset.zero] до [Offset(0, -1)]
    _slideController.reset();
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(_slideController);
    await _slideController.forward();

    // Вызов колбэка на исчезновение тостера, если он еще не исчез
    if (!isDismissed) {
      isDismissed = true;
      widget.onDismiss.call();
    }
  }

  /// Тип тостера
  ToasterType get _type => widget.config.type;

  /// Возвращает иконку по умолчанию
  IconData get _defaultIcon => switch (_type) {
        ToasterType.success => Icons.check_circle,
        ToasterType.warning => Icons.warning_rounded,
        ToasterType.error => Icons.error_rounded,
        ToasterType.message => Icons.info_rounded,
      };

  /// Возвращает основные контроллеры анимаций
  List<AnimationController> get _primaryControllers => [
        _slideController,
        _fadeController,
      ];

  /// {@template slide_duration}
  /// Длительность скольжения
  /// {@endtemplate}
  Duration get _slideDuration => const Duration(milliseconds: 250);

  /// {@template fade_duration}
  /// Длительность выцветания
  /// {@endtemplate}
  Duration get _fadeDuration => const Duration(milliseconds: 200);

  /// {@template pre_dismiss_scale_duration}
  /// Длительность масштабирования перед исчезновением
  /// {@endtemplate}
  Duration get _scaleDuration => const Duration(milliseconds: 100);
}
