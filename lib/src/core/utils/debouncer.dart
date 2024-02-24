import 'dart:async';

import 'package:flutter/foundation.dart';

/// {@template debouncer}
/// The `Debouncer` class provides a mechanism to debounce function calls,
/// ensuring that the function is only invoked after a specified duration of
/// inactivity.
/// {@endtemplate}
class Debouncer {
  Timer? _debounceTimer;

  /// Debounces the provided [callback] function by canceling any existing
  /// timer and scheduling a new timer to invoke the callback after the
  /// specified [duration] of inactivity.
  ///
  /// The [callback] function is invoked only once, even if this method is
  /// called multiple times within the [duration].
  void debounce({
    required Duration duration,
    required VoidCallback onDebounce,
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, onDebounce);
  }

  /// Cancels any pending debounced callbacks.
  ///
  /// If there is an active debounce timer, it will be canceled, and the
  /// debounced callback associated with that timer will not be invoked.
  void cancel() => _debounceTimer?.cancel();
}
