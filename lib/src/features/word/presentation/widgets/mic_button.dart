import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';

/// Кнопка микрофона
@immutable
class MicButton extends StatelessWidget {
  /// Создает кнопку микрофона
  const MicButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        child: IconButton.outlined(
          onPressed: () {},
          tooltip: 'Start pronunciation',
          constraints: BoxConstraints.tight(const Size.square(56)),
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: context.theme.colors.blue,
            elevation: 12,
          ),
          icon: const Icon(
            Icons.mic,
            size: 40,
          ),
        ),
      );
}
