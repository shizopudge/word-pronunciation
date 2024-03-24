import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';

/// Заголовок настройки
@immutable
class SettingTitle extends StatelessWidget {
  /// Заголовок
  final String title;

  /// Дочерний виджет
  final Widget child;

  /// Создает заголовок настройки
  const SettingTitle({
    required this.title,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              title,
              style: context.theme.textTheme.titleMedium?.copyWith(
                color: context.theme.isDark
                    ? context.theme.colors.white
                    : context.theme.colors.black,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 16),
            child: Divider(indent: 24, endIndent: 24),
          ),
          child,
        ],
      );
}
