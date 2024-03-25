import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/features/app_settings/bloc/app_settings.dart';
import 'package:word_pronunciation/src/features/app_settings/presentation/widgets/widgets.dart';
import 'package:word_pronunciation/src/features/app_settings/scope/app_settings_scope.dart';

/// Настройка "Автоматически получать следующее слово"
@immutable
class AutoNextWordSetting extends StatelessWidget {
  /// Создает настройку "Автоматически получать следующее слово"
  const AutoNextWordSetting({
    super.key,
  });

  @override
  Widget build(BuildContext context) => SettingTitle(
        title: context.localization.automaticallyReadNextWord,
        child: Setting.withSwitch(
          onTap: () => _onTap(context),
          name: context.localization.automaticallyReadNextWord,
          isEnabled: AppSettingsScope.of(context).appSettings.autoNextWord,
        ),
      );

  /// Обработчик нажатия.
  void _onTap(BuildContext context) {
    final autoNextWord =
        AppSettingsScope.of(context, listen: false).appSettings.autoNextWord;
    AppSettingsScope.of(context, listen: false).appSettingsBloc.add(
          AppSettingsEvent.write(
            AppSettingsScope.of(context)
                .appSettings
                .copyWith(autoNextWord: !autoNextWord),
          ),
        );
  }
}
