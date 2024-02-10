import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/features/toaster/toaster.dart';

/// {@template toaster_scope}
/// Область видимости тостера
/// {@endtemplate}
@immutable
class ToasterScope extends StatefulWidget {
  /// Дочерний виджет
  final Widget child;

  /// {@macro toaster_scope}
  const ToasterScope({
    required this.child,
    super.key,
  });

  /// Возвращает стейт области видимости тостера, если BuildContext
  /// содержит ToasterScope, иначе выкидывает ошибку [FlutterError]
  static ToasterScopeState of(BuildContext context) {
    _InheritedToaster? scope;

    scope = context.getInheritedWidgetOfExactType<_InheritedToaster>();

    if (scope == null) {
      throw FlutterError(
        'ToasterScopeState was requested with a context that does not include an'
        ' ToasterScopeState.',
      );
    }

    return scope.state;
  }

  @override
  State<ToasterScope> createState() => ToasterScopeState();
}

class ToasterScopeState extends State<ToasterScope> {
  /// Очередь тостов
  late final Queue<ToasterEntry> _queue;

  /// {@macro toaster_state}
  late ToasterState _state;

  /// {@macro toaster_entry}
  ToasterEntry? _currentEntry;

  /// {@template stored_config}
  /// Сохраненный конфиг тостера
  /// {@endtemplate}
  ToasterConfig? _storedConfig;

  /// {@template overlay}
  /// Оверлей
  /// {@endtemplate}
  OverlayState? _overlay;

  @override
  void initState() {
    super.initState();
    _queue = Queue<ToasterEntry>();
    _state = ToasterState.idle;
  }

  @override
  void dispose() {
    _currentEntry?.overlayEntry
      ?..remove()
      ..dispose();
    _overlay?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _InheritedToaster(
        state: this,
        child: widget.child,
      );

  /// Показывает тост
  void showToast(
    BuildContext context, {
    required ToasterConfig config,
  }) {
    _overlay ??= Overlay.of(context);
    final overlayEntry = _createOverlayEntry(config);
    final entry = ToasterEntry(config: config, overlayEntry: overlayEntry);
    if (config.priority == ToasterPriority.common) {
      if (_isCanBeAddedToQueue(entry)) _queue.addLast(entry);
      if (_state != ToasterState.showed) _updateToaster();
    } else if (config.priority == ToasterPriority.high) {
      _queue.addFirst(entry);
      if (_state != ToasterState.showed) _updateToaster();
    } else {
      if (!_isCanBeAddedToQueueForHighPriority(entry)) return;
      _queue.addFirst(entry);
      _storeToasterConfig();
      hideCurrentToaster();
      _updateToaster();
      _restoreToasterEntry();
    }
  }

  /// Очистить очередь тостов
  void clearToasts() {
    _queue.clear();
    hideCurrentToaster();
  }

  /// Исчезновение текущего тоста
  void hideCurrentToaster() {
    _currentEntry?.overlayEntry.remove();
    _currentEntry?.overlayEntry.dispose();
    if (_currentEntry?.isRestored ?? false) _storedConfig = null;
    _currentEntry = null;
    _state = ToasterState.idle;
  }

  /// Восстанавливает запись тостера и помещает ее в начало очереди
  void _restoreToasterEntry() {
    final config = _storedConfig;
    if (config != null) {
      final entry = _createOverlayEntry(config);
      final restoredEntry =
          ToasterEntry.restored(config: config, overlayEntry: entry);
      _queue.addFirst(restoredEntry);
    }
  }

  /// Создает [OverlayEntry]
  OverlayEntry _createOverlayEntry(ToasterConfig config) => OverlayEntry(
        builder: (context) => Toaster(
          config: config,
          onDismiss: _onDismiss,
        ),
      );

  /// Сохраняет текущую конфигурацию контроллера, если [_state] == [ToasterState.showed]
  void _storeToasterConfig() {
    if (_state != ToasterState.showed) return;
    _storedConfig = _currentEntry?.config;
  }

  /// Обновление тоста
  void _updateToaster() {
    if (_queue.isEmpty) return;
    final entry = _queue.removeFirst();
    if (entry == _currentEntry) return;
    if (_currentEntry != null) hideCurrentToaster();
    _overlay?.insert(entry.overlayEntry);
    _currentEntry = entry;
    _state = ToasterState.showed;
  }

  /// Возвращает true, если тостер может быть добавлен в очередь
  ///
  /// ## Условия
  ///
  /// 1. В очереди нет контроллеров равынх передавемому
  /// 2. Длина очереди не больше 3
  /// 3. Текущий контроллер не равен передаваемеому
  bool _isCanBeAddedToQueue(ToasterEntry entry) =>
      _queue.where((element) => element == entry).isEmpty &&
      _queue.length <= 3 &&
      _currentEntry != entry;

  /// Возвращает true, если в очереди нет записей равных передавемой и текущая
  /// запись не равна передаваемой
  bool _isCanBeAddedToQueueForHighPriority(ToasterEntry entry) =>
      _queue.where((element) => element == entry).isEmpty &&
      _currentEntry != entry;

  /// Обработчик на исчезновение тостера
  void _onDismiss() {
    hideCurrentToaster();
    _updateToaster();
  }
}

/// {@template inherited_toaster}
/// Поставщик стейта области видимости тостера
/// {@endtemplate}
@immutable
class _InheritedToaster extends InheritedWidget {
  /// Состояние области видимости тостера
  final ToasterScopeState state;

  /// {@macro inherited_toaster}
  const _InheritedToaster({
    required this.state,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedToaster oldWidget) => false;
}

/// {@template toaster_entry}
/// Запись тостера
/// {@endtemplate}
@immutable
class ToasterEntry extends Equatable {
  /// {@macro toast_config}
  final ToasterConfig config;

  /// Текущее наложение
  final OverlayEntry overlayEntry;

  /// Если true, значит запись был восстановлен
  final bool isRestored;

  /// {@macro toaster_entry}
  const ToasterEntry({
    required this.config,
    required this.overlayEntry,
  }) : isRestored = false;

  /// Конструктор восстановленной записи
  const ToasterEntry.restored({
    required this.config,
    required this.overlayEntry,
  }) : isRestored = true;

  @override
  List<Object?> get props => [config];
}

/// {@template toaster_state}
/// Состояние тостера
/// {@endtemplate}
enum ToasterState {
  /// Ожидание
  idle,

  /// Отображение
  showed;
}
