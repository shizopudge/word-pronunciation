import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/features/app_settings/presentation/widgets/widgets.dart';
import 'package:word_pronunciation/src/features/app_theme/bloc/app_theme.dart';
import 'package:word_pronunciation/src/features/app_theme/domain/entity/app_theme_mode.dart';
import 'package:word_pronunciation/src/features/app_theme/scope/app_theme_scope.dart';

/// Настройка темы
@immutable
class ThemeSetting extends StatelessWidget {
  /// Создает настройку темы
  const ThemeSetting({
    super.key,
  });

  @override
  Widget build(BuildContext context) => SettingTitle(
        title: 'Тема',
        child: BlocBuilder<AppThemeBloc, AppThemeState>(
          // TODO: Подумать над add(const AppThemeEvent.read())
          bloc: AppThemeScope.of(context).bloc..add(const AppThemeEvent.read()),
          buildWhen: (previous, current) => current.isIdle,
          builder: (context, state) {
            late final Widget child;

            final appThemeMode = state.appThemeMode;

            if (appThemeMode == null) {
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
                    onTap: () => AppThemeScope.of(context)
                        .state
                        .writeAppThemeMode(AppThemeMode.light),
                    name: 'Светлая',
                    isEnabled: appThemeMode == AppThemeMode.light,
                  ),
                  Setting.withCheckbox(
                    onTap: () => AppThemeScope.of(context)
                        .state
                        .writeAppThemeMode(AppThemeMode.dark),
                    name: 'Темная',
                    isEnabled: appThemeMode == AppThemeMode.dark,
                  ),
                  Setting.withCheckbox(
                    onTap: () => AppThemeScope.of(context)
                        .state
                        .writeAppThemeMode(AppThemeMode.system),
                    name: 'Системная',
                    isEnabled: appThemeMode == AppThemeMode.system,
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
