import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Локальное слово
@immutable
class LocalWord extends Equatable {
  /// Идентификатор
  final int? _id;

  /// Данные
  final String data;

  /// Если true, значит слово было правильно произнесенно
  final bool pronounced;

  /// Создает локальное слово с ID
  const LocalWord.withID({
    required int id,
    required this.data,
    required this.pronounced,
  }) : _id = id;

  /// Создает локальное слово без ID
  const LocalWord.withoutID({
    required this.data,
    required this.pronounced,
  }) : _id = null;

  factory LocalWord.fromDB(Map<String, Object?> map) => LocalWord.withID(
        id: map['id'] as int,
        data: map['data'] as String,
        pronounced: map['pronounced'] as int == 1,
      );

  Map<String, Object?> toDB() => {
        if (_id != null) 'id': _id,
        'data': data,
        'pronounced': pronounced ? 1 : 0,
      };

  @override
  List<Object?> get props => [_id, data, pronounced];
}
