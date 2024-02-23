import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/extensions/extensions.dart';

/// Делегат заголовка ошибки
@immutable
class ErrorHeaderDelegate extends SliverPersistentHeaderDelegate {
  /// Создает делегат заголовка ошибки
  const ErrorHeaderDelegate();

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) =>
      DecoratedBox(
        decoration: BoxDecoration(
          color: context.theme.data.scaffoldBackgroundColor,
          boxShadow: _boxShadow(
            context,
            shrinkOffset: shrinkOffset,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          child: Text(
            context.localization.error,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: context.theme.textTheme.headlineLarge?.copyWith(
              color: context.theme.colors.grey,
            ),
          ),
        ),
      );

  /// Возвращает тени заголовка, если [shrinkOffset] > 0.0, иначе null
  List<BoxShadow>? _boxShadow(
    BuildContext context, {
    required double shrinkOffset,
  }) =>
      shrinkOffset > 0.0
          ? [
              BoxShadow(
                color: context.theme.colors.black.withOpacity(.025),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
              BoxShadow(
                color: context.theme.colors.black.withOpacity(.04),
                offset: const Offset(0, 1.4),
                blurRadius: 3,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: context.theme.colors.black.withOpacity(.05),
                offset: const Offset(0, 2),
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ]
          : null;

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant ErrorHeaderDelegate oldDelegate) => false;
}
