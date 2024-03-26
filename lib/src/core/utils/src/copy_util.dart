import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/logger/logger.dart';
import 'package:word_pronunciation/src/features/toaster/toaster.dart';

/// Утилита для копирования текста.
@immutable
abstract final class CopyUtil {
  /// Копирует передаваемый текст.
  static Future<void> copy(
    BuildContext context, {
    required String text,
  }) async {
    try {
      HapticFeedback.lightImpact().ignore();
      await Clipboard.setData(ClipboardData(text: text));
      if (context.mounted) {
        context.showToaster(
          message: 'Successfully copied.',
          type: ToasterType.success,
        );
      }
    } on Object catch (error, stackTrace) {
      L.error(
        'An error occurred during a copy attempt.',
        error: error,
        stackTrace: stackTrace,
      );
      if (context.mounted) {
        context.showToaster(
          message: 'An error occurred during a copy attempt.',
          type: ToasterType.error,
        );
      }
    }
  }
}
