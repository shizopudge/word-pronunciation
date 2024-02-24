import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Consumer удержания
@immutable
class HoldConsumer extends StatefulWidget {
  /// Если true, то consumer активен
  final bool isEnabled;

  /// Постройщик дочернего виджета
  final Widget Function(BuildContext context, bool isHeldDown) builder;

  /// Слушатель взаимодействий с виджетом
  final ValueChanged<bool>? listener;

  /// Создает consumer удержания
  const HoldConsumer({
    required this.builder,
    this.isEnabled = true,
    this.listener,
    super.key,
  });

  @override
  State<HoldConsumer> createState() => _HoldConsumerState();
}

class _HoldConsumerState extends State<HoldConsumer> {
  /// {@template child_held_down_controller}
  /// Контроллер зажатия дочернего виджета
  /// {@endtemplate}
  late final ValueNotifier<bool> _childHeldDownController;

  @override
  void initState() {
    super.initState();
    _childHeldDownController = ValueNotifier<bool>(false);
    if (widget.listener != null) {
      _childHeldDownController.addListener(_listener);
    }
  }

  @override
  void dispose() {
    if (widget.listener != null) {
      _childHeldDownController.removeListener(_listener);
    }
    _childHeldDownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.isEnabled ? _handleTapDown : null,
        onTapUp: widget.isEnabled ? _handleTapUp : null,
        onTapCancel: widget.isEnabled ? _handleTapCancel : null,
        child: AnimatedBuilder(
          animation: _childHeldDownController,
          builder: (context, _) => widget.builder(context, _isChildHeldDown),
        ),
      );

  /// Слушатель
  void _listener() => widget.listener?.call(_childHeldDownController.value);

  /// Обработчик на зажатие виджета
  void _handleTapDown(TapDownDetails event) => _isChildHeldDown = true;

  /// Обработчик на отжатие виджета
  void _handleTapUp(TapUpDetails event) => _isChildHeldDown = false;

  /// Обработчик на отжатие виджета
  void _handleTapCancel() => _isChildHeldDown = false;

  /// Устанавливает новое значение для контроллера зажатия дочернего виджета
  set _isChildHeldDown(bool newValue) {
    if (_childHeldDownController.value == newValue) return;
    _childHeldDownController.value = newValue;
  }

  /// Возвращает true, если дочерний виджет зажат
  bool get _isChildHeldDown => _childHeldDownController.value;
}
