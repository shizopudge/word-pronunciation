import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';

/// Фильтры накладывающиеся на фон во время произношения слова
@immutable
class PronouncingFilters extends StatelessWidget {
  /// Дочерний виджет
  final Widget child;

  /// Если true, то фильтры включены
  final bool enabled;

  /// Создает фильтры накладывающиеся на фон во время произношения слова
  const PronouncingFilters({
    required this.child,
    required this.enabled,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ImageFiltered(
        enabled: enabled,
        imageFilter: ImageFilter.blur(
          sigmaX: 2,
          sigmaY: 2,
          tileMode: TileMode.decal,
        ),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            enabled
                ? context.theme.colors.black.withOpacity(.75)
                : Colors.transparent,
            BlendMode.darken,
          ),
          child: child,
        ),
      );
}
