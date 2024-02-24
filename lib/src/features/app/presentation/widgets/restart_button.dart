import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';

/// Кнопка "Перезагрузить"
@immutable
class RestartButton extends StatelessWidget {
  /// Обработчик на перезагрузку
  final VoidCallback onRestart;

  /// Создает кнопку "Перезагрузить"
  const RestartButton({
    required this.onRestart,
    super.key,
  });

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PrimaryElevatedButton(
            onTap: onRestart,
            child: Text(
              context.localization.restart,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
}
