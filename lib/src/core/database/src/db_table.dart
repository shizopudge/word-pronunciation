import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:word_pronunciation/src/core/database/database.dart';

/// Таблица в [IDB]
@immutable
class DBTable extends Equatable {
  /// Название
  final String name;

  /// SQL строка
  final String sqlString;

  /// Создает таблицу в [IDB]
  const DBTable({
    required this.name,
    required this.sqlString,
  });

  @override
  List<Object?> get props => [name, sqlString];
}
