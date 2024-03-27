import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
            leading: IconButton(
              onPressed: Navigator.of(context).pop,
              style: IconButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: context.theme.isDark
                    ? context.theme.colors.white
                    : context.theme.colors.black,
              ),
              constraints: BoxConstraints.tight(const Size.square(40)),
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 24,
              ),
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

              // Настройка темы
              const SliverPadding(
                padding: EdgeInsets.only(top: 16),
                sliver: SliverToBoxAdapter(
                  child: ThemeSetting(),
                ),
              ),

              // Настройка "Автоматически получать следующее слово"
              const SliverPadding(
                padding: EdgeInsets.only(top: 16),
                sliver: SliverToBoxAdapter(
                  child: AutoNextWordSetting(),
                ),
              ),

              // Настройка локализации
              const SliverPadding(
                padding: EdgeInsets.only(top: 16),
                sliver: SliverToBoxAdapter(
                  child: LocaleSetting(),
                ),
              ),

              // Версия приложения
              SliverToBoxAdapter(
                child: FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    late final Widget child;
                    String? version;
                    String? appName;

                    final hasError = snapshot.hasError;

                    if (hasError) {
                      version = 'unknown';
                      appName = 'Unknown';
                    } else {
                      final data = snapshot.data;

                      if (data == null) {
                        child = const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: PrimaryLoadingIndicator(),
                        );
                      } else {
                        version = data.version;
                        appName = data.appName;
                      }
                    }

                    if (version != null) {
                      child = Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          left: 32,
                          right: 32,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${context.localization.appName}: $appName',
                              textAlign: TextAlign.center,
                              style:
                                  context.theme.textTheme.bodyMedium?.copyWith(
                                color: context.theme.colors.grey,
                              ),
                            ),
                            Text(
                              '${context.localization.version}: $version',
                              textAlign: TextAlign.center,
                              style:
                                  context.theme.textTheme.bodyMedium?.copyWith(
                                color: context.theme.colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return AnimatedSwitcher(
                      duration: Durations.short4,
                      child: child,
                    );
                  },
                ),
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
