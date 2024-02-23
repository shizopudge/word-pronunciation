import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';
import 'package:word_pronunciation/src/core/ui_kit/ui_kit.dart';
import 'package:word_pronunciation/src/features/app/bloc/app_initialization.dart';
import 'package:word_pronunciation/src/features/app/presentation/widgets/widgets.dart';
import 'package:word_pronunciation/src/features/app/scope/scope.dart';

/// Виджет отображающий ошибку загрузки приложения
@immutable
class AppInitializationErrorPage extends StatelessWidget {
  /// Сообщение
  final String message;

  /// Создает виджет отображающий ошибку загрузки приложения
  const AppInitializationErrorPage({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: context.theme.systemUiOverlayStyle
            .copyWith(statusBarColor: Colors.transparent),
        child: Scaffold(
          body: SafeArea(
            bottom: false,
            child: ScrollFadeBottomMask(
              startsAt: .65,
              builder: (context, scrollController) => CustomScrollView(
                controller: scrollController,
                slivers: [
                  // Заголовок "Ошибка"
                  const SliverPersistentHeader(
                    delegate: ErrorHeaderDelegate(),
                    pinned: true,
                  ),

                  // Текст ошибки
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.only(
                              bottom: 120, left: 24, right: 24) +
                          EdgeInsets.only(
                              bottom: context.mediaQuery.padding.bottom),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          color: context.theme.colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: RestartButton(
            onRestart: () => _restart(context),
          ),
        ),
      );

  /// Перезапускает инициализацию приложения
  void _restart(BuildContext context) => AppInitializationScope.of(context)
      .bloc
      .add(const AppInitializationEvent.initialize());
}
