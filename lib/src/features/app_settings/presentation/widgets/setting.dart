import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';

/// Настройка
@immutable
class Setting extends StatelessWidget {
  /// Обработчик нажатия
  final VoidCallback onTap;

  /// Название
  final String name;

  /// Если true, значит настройка включена
  final bool isEnabled;

  /// Если true, значит виджет был построен с помощью конструктора
  /// [_Setting.withCheckbox]
  final bool _isCheckbox;

  /// Создает настройку с чекбоксом
  const Setting.withCheckbox({
    required this.onTap,
    required this.name,
    required this.isEnabled,
    super.key,
  }) : _isCheckbox = true;

  /// Создает настройку с свитчом
  const Setting.withSwitch({
    required this.onTap,
    required this.name,
    required this.isEnabled,
    super.key,
  }) : _isCheckbox = false;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        highlightColor: context.theme.colors.blue.withOpacity(.2),
        splashColor: context.theme.colors.blue.withOpacity(.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: context.theme.isDark
                        ? context.theme.colors.white
                        : context.theme.colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (_isCheckbox) ...[
                Checkbox(
                  value: isEnabled,
                  shape: const CircleBorder(),
                  onChanged: null,
                ),
              ] else ...[
                Switch.adaptive(
                  value: isEnabled,
                  onChanged: null,
                ),
              ],
            ],
          ),
        ),
      );
}
