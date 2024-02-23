import 'dart:ui';

import 'package:flutter/material.dart';

/// Апп бар с заблюренным фоном
@immutable
class BluredAppBar extends AppBar {
  /// Заголовок
  final Widget _title;

  /// Цвет фона
  final Color _backgroundColor;

  /// Создает апп бар с заблюренным фоном
  BluredAppBar({
    required Widget title,
    required Color backgroundColor,
    super.key,
  })  : _title = title,
        _backgroundColor = backgroundColor;

  @override
  Color? get backgroundColor => _backgroundColor;

  @override
  Widget? get title => _title;

  @override
  Widget? get flexibleSpace => ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: const SizedBox.expand(),
        ),
      );
}
