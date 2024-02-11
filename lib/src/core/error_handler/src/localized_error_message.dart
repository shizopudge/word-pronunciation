import 'package:flutter/widgets.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';

/// Енум для локализованных сообщений об ошибках
enum LocalizedErrorMessage {
  wordWasNotReceived;

  /// Возвращает локализованное сообщение
  String message(BuildContext context) =>
      switch (this) {
        LocalizedErrorMessage.wordWasNotReceived =>
          context.localization?.wordWasNotReceived,
      } ??
      '';
}
