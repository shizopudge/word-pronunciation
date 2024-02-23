import 'package:flutter/widgets.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';

/// Енум для сообщений об ошибках
enum ErrorMessage {
  wordWasNotReceived;

  /// Возвращает сообщение
  String toMessage(BuildContext context) => switch (this) {
        ErrorMessage.wordWasNotReceived =>
          context.localization.wordWasNotReceived,
      };
}
