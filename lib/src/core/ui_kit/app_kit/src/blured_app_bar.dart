import 'dart:ui';

import 'package:flutter/material.dart';

/// Апп бар с заблюренным фоном
@immutable
class BluredAppBar extends AppBar {
  /// Заголовок
  final Widget _title;

  /// Цвет фона
  final Color _backgroundColor;

  /// Действие
  final Widget? _action;

  /// Создает апп бар с заблюренным фоном
  BluredAppBar({
    required Widget title,
    required Color backgroundColor,
    Widget? action,
    super.key,
  })  : _title = title,
        _backgroundColor = backgroundColor,
        _action = action;

  @override
  Color? get backgroundColor => _backgroundColor;

  @override
  Widget? get title => _title;

  @override
  List<Widget>? get actions => _action != null ? [_action] : null;

  @override
  Widget? get flexibleSpace => ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: const SizedBox.expand(),
        ),
      );
}
