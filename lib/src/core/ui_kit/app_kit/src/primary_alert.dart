import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';

/// Основной диалог
@immutable
class PrimaryAlert extends StatelessWidget {
  /// Дочерний виджет
  final Widget child;

  /// Заголовок
  final String title;

  /// Создает основной диалог
  const PrimaryAlert._({
    required this.child,
    this.title = '',
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String title = '',
    bool barrierDismissible = true,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
  }) =>
      showDialog<T>(
        context: context,
        builder: (context) => PrimaryAlert._(
          title: title,
          child: child,
        ),
        barrierDismissible: barrierDismissible,
        barrierLabel: barrierLabel,
        useSafeArea: useSafeArea,
        useRootNavigator: useRootNavigator,
        routeSettings: routeSettings,
        anchorPoint: anchorPoint,
      );

  @override
  Widget build(BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: CloseButton(onPressed: Navigator.of(context).pop),
              ),
              if (title.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: context.theme.textTheme.titleLarge?.copyWith(
                      color: context.theme.isDark
                          ? context.theme.colors.white
                          : context.theme.colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              child,
            ],
          ),
        ),
      );
}
