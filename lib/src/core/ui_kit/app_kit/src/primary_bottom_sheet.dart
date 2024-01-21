import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';

/// Основной виджет всплывающего нижнего окна
@immutable
class PrimaryBottomSheet extends StatelessWidget {
  /// Дочерний виджет
  final Widget child;

  /// Заголовок
  final String title;

  /// Цвет драга
  final Color? dragHandleColor;

  /// Цвет заднего фона
  final Color? backgroundColor;

  /// Если true, то задний фон размывается
  final bool blurBackground;

  /// Создает основной виджет всплывающего нижнего окна
  const PrimaryBottomSheet._({
    required this.child,
    required this.title,
    required this.dragHandleColor,
    required this.backgroundColor,
    required this.blurBackground,
  });

  @override
  Widget build(BuildContext context) {
    // Тема нижнего всплывающего окна
    final bottomSheetTheme = context.theme.bottomSheetTheme;

    final bottomSheet = _SheetBody(
      title: title,
      bottomSheetTheme: bottomSheetTheme,
      dragHandleColor: dragHandleColor,
      backgroundColor: backgroundColor,
      child: child,
    );

    if (!blurBackground) return bottomSheet;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: bottomSheet,
    );
  }
}

/// Апп бар шита
@immutable
class _SheetAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Заголовок
  final String title;

  /// Создает апп бар шита
  const _SheetAppBar({
    required this.title,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(
          top: 24,
          left: 16,
          right: 16,
        ),
        child: Text(
          title,
          style: context.theme.textTheme.titleLarge?.copyWith(
            color: context.colors.black,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

/// Тело шита
@immutable
class _SheetBody extends StatelessWidget {
  /// Дочерний виджет
  final Widget child;

  /// Заголовок
  final String title;

  /// Тема нижненего всплывающего окна
  final BottomSheetThemeData bottomSheetTheme;

  /// Цвет драга
  final Color? dragHandleColor;

  /// Цвет заднего фона
  final Color? backgroundColor;

  /// Создает тело шита
  const _SheetBody({
    required this.child,
    required this.title,
    required this.bottomSheetTheme,
    required this.dragHandleColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) => ClipPath(
        clipper: ShapeBorderClipper(
          shape: bottomSheetTheme.shape ??
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
        ),
        child: SafeArea(
          top: false,
          child: Material(
            color: backgroundColor ?? bottomSheetTheme.backgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      height: 5,
                      width: 56,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: dragHandleColor ??
                              bottomSheetTheme.dragHandleColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (title.isNotEmpty) ...[_SheetAppBar(title: title)],
                      Flexible(
                        child: child,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

/// Вызывает появление [PrimaryBottomSheet]
Future<T?> showPrimaryBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  String title = '',
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  bool isScrollControlled = true,
  bool blurBackground = false,
  double elevation = 0.0,
  double maxHeigthFactor = 0.8,
  RouteSettings? settings,
  Color? dragHandleColor,
  Color? backgroundColor,
  Color? modalBarrierColor,
}) async {
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterial(context));
  assert(debugCheckHasMaterialLocalizations(context));
  final modalBottomSheet = ModalBottomSheetRoute<T>(
    builder: (context) => PrimaryBottomSheet._(
      title: title,
      dragHandleColor: dragHandleColor,
      backgroundColor: backgroundColor,
      blurBackground: blurBackground,
      child: builder.call(context),
    ),
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    isDismissible: isDismissible,
    modalBarrierColor:
        modalBarrierColor ?? context.colors.black.withOpacity(.4),
    elevation: elevation,
    enableDrag: enableDrag,
    settings: settings,
    isScrollControlled: isScrollControlled,
    constraints: BoxConstraints(
      maxHeight: context.mediaQuery.size.height * maxHeigthFactor,
    ),
  );
  final result = await Navigator.of(
    context,
    rootNavigator: useRootNavigator,
  ).push<T>(modalBottomSheet);

  return result;
}
