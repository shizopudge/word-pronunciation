import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';

/// Фильтр накладывающийся на фон во время произношения слова
@immutable
class PronouncingFilter extends StatelessWidget {
  /// Дочерний виджет
  final Widget child;

  /// Если true, то фильтры включены
  final bool enabled;

  /// Цвет фильтра
  final Color? color;

  /// Создает фильтр накладывающийся на фон во время произношения слова
  const PronouncingFilter({
    required this.child,
    required this.enabled,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) => IgnorePointer(
        ignoring: enabled,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            enabled
                ? color ?? context.theme.colors.black.withOpacity(.85)
                : Colors.transparent,
            BlendMode.darken,
          ),
          child: child,
        ),
      );
}
