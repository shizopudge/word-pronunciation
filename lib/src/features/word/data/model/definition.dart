// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'definition.freezed.dart';
part 'definition.g.dart';

@freezed
class Definition with _$Definition {
  const factory Definition({
    /// Определение слова
    @JsonKey(name: 'definition') required final String data,

    /// Пример использования
    @Default('') final String example,
  }) = _Definition;

  /// Generate Class from Map<String, Object?>
  factory Definition.fromJson(Map<String, Object?> json) =>
      _$DefinitionFromJson(json);
}
