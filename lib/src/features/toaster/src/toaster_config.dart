import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// {@template toaster_config}
/// Конфигурация тостера
/// {@endtemplate}
@immutable
class ToasterConfig extends Equatable {
  /// Сообщение
  final String message;

  /// Иконка
  final Widget? icon;

  /// Длительность
  final Duration duration;

  /// {@macro toaster_type}
  final ToasterType type;

  /// Приоритет тостера
  final ToasterPriority priority;

  /// Если true, то отображается иконка
  ///
  /// По умолчанию true
  final bool showIcon;

  /// {@macro toaster_config}
  const ToasterConfig({
    required this.message,
    this.icon,
    this.duration = const Duration(milliseconds: 3000),
    this.type = ToasterType.message,
    this.priority = ToasterPriority.common,
    this.showIcon = true,
  });

  @override
  List<Object?> get props => [
        message,
        icon,
        duration,
        type,
        priority,
        showIcon,
      ];
}

/// {@template toaster_type}
/// Тип тостера
/// {@endtemplate}
enum ToasterType {
  error,
  message,
  warning,
  success;
}

/// Енум приоритета тостера
enum ToasterPriority {
  /// Обычный
  common,

  /// Высокий
  high,

  /// Первый по приоритету
  first;
}
