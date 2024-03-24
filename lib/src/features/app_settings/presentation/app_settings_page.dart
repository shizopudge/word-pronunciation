import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/features/app_settings/presentation/widgets/widgets.dart';

/// Экран с настройками приложения
@immutable
class AppSettingsPage extends StatelessWidget {
  /// Создает экран с настройками приложения
  const AppSettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: BluredAppBar(
            backgroundColor: (context.theme.isDark
                    ? context.theme.colors.black
                    : context.theme.colors.white)
                .withOpacity(.2),
            title: Text(
              context.localization.settings,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        body: ScrollFadeBottomMask(
          startsAt: .65,
          builder: (context, scrollController) => CustomScrollView(
            controller: scrollController,
            slivers: [
              // Отступ сверху
              SliverPadding(
                padding: EdgeInsets.only(top: context.mediaQuery.padding.top),
              ),

              // Тема
              const SliverToBoxAdapter(
                child: ThemeSetting(),
              ),

              // Тема
              const SliverToBoxAdapter(
                child: AutoNextWordSetting(),
              ),

              // Отступ снизу
              SliverPadding(
                padding: EdgeInsets.only(
                  bottom: 140 + context.mediaQuery.padding.bottom,
                ),
              ),
            ],
          ),
        ),
      );
}
