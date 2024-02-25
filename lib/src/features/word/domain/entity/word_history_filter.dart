import 'package:flutter/widgets.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';

enum WordHistoryFilter {
  all,
  pronounced,
  incorrect;

  /// Преобразует [WordHistoryFilter] в текст
  String toText(BuildContext context) => switch (this) {
        WordHistoryFilter.all => context.localization.all,
        WordHistoryFilter.pronounced => context.localization.pronounced,
        WordHistoryFilter.incorrect => context.localization.pronouncedIncorrect,
      };
}
