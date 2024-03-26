import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/features/app_locale/bloc/app_locale.dart';
import 'package:word_pronunciation/src/features/app_locale/scope/app_locale_scope.dart';
import 'package:word_pronunciation/src/features/app_settings/presentation/widgets/widgets.dart';

/// Настройка локализации
@immutable
class LocaleSetting extends StatelessWidget {
  /// Создает настройку локализации
  const LocaleSetting({
    super.key,
  });

  @override
  Widget build(BuildContext context) => SettingTitle(
        title: context.localization.language,
        child: BlocBuilder<AppLocaleBloc, AppLocaleState>(
          bloc: AppLocaleScope.of(context).bloc,
          buildWhen: (previous, current) => current.isIdle,
          builder: (context, state) {
            late final Widget child;

            final languageCode = state.languageCode;

            if (languageCode == null) {
              child = SizedBox.fromSize(
                size: const Size.fromHeight(200),
                child: const Center(
                  child: PrimaryLoadingIndicator(),
                ),
              );
            } else {
              child = Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Setting.withCheckbox(
                    onTap: () => AppLocaleScope.of(context, listen: false)
                        .bloc
                        .add(const AppLocaleEvent.write('ru')),
                    name: context.localization.russian,
                    isEnabled: languageCode == 'ru',
                  ),
                  Setting.withCheckbox(
                    onTap: () => AppLocaleScope.of(context, listen: false)
                        .bloc
                        .add(const AppLocaleEvent.write('en')),
                    name: context.localization.english,
                    isEnabled: languageCode == 'en',
                  ),
                ],
              );
            }

            return AnimatedSwitcher(
              duration: Durations.short3,
              child: child,
            );
          },
        ),
      );
}
