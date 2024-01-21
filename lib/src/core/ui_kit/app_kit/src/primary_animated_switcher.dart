import 'package:flutter/material.dart';

/// Виджет анимированно меняющий свой дочерний виджет
@immutable
class PrimaryAnimatedSwitcher extends StatelessWidget {
  /// Дочерний виджет
  final Widget child;

  /// Длительность анимации смены виджетов
  final Duration switchAnimationDuration;

  /// Длительность анимации смены размера, имеет смысл только если
  /// [animateSize] == true
  final Duration sizeAnimationDuration;

  /// Если true, то [AnimatedSwitcher] оборачивается в [AnimatedSize]
  final bool animateSize;

  /// A function that wraps a new [child] with an animation that transitions
  /// the [child] in when the animation runs in the forward direction and out
  /// when the animation runs in the reverse direction. This is only called
  /// when a new [child] is set (not for each build), or when a new
  /// [transitionBuilder] is set. If a new [transitionBuilder] is set, then
  /// the transition is rebuilt for the current child and all previous children
  /// using the new [transitionBuilder]. The function must not return null.
  ///
  /// The default is [AnimatedSwitcher.defaultTransitionBuilder].
  ///
  /// The animation provided to the builder has the [duration] and
  /// [switchInCurve] or [switchOutCurve] applied as provided when the
  /// corresponding [child] was first provided.
  ///
  /// See also:
  ///
  ///  * [AnimatedSwitcherTransitionBuilder] for more information about
  ///    how a transition builder should function.
  final AnimatedSwitcherTransitionBuilder transitionBuilder;

  /// A function that wraps all of the children that are transitioning out, and
  /// the [child] that's transitioning in, with a widget that lays all of them
  /// out. This is called every time this widget is built. The function must not
  /// return null.
  ///
  /// The default is [AnimatedSwitcher.defaultLayoutBuilder].
  ///
  /// See also:
  ///
  ///  * [AnimatedSwitcherLayoutBuilder] for more information about
  ///    how a layout builder should function.
  final AnimatedSwitcherLayoutBuilder layoutBuilder;

  /// Создает виджет анимированно меняющий свой дочерний виджет
  const PrimaryAnimatedSwitcher({
    required this.child,
    this.switchAnimationDuration = Durations.medium1,
    this.sizeAnimationDuration = Durations.short2,
    this.animateSize = true,
    this.transitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
    this.layoutBuilder = AnimatedSwitcher.defaultLayoutBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final animatedSwitcher = AnimatedSwitcher(
      duration: switchAnimationDuration,
      child: child,
    );

    if (!animateSize) return animatedSwitcher;

    return AnimatedSize(
      duration: sizeAnimationDuration,
      child: animatedSwitcher,
    );
  }
}
