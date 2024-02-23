// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:word_pronunciation/src/features/word/data/model/definition.dart';

part 'meaning.freezed.dart';
part 'meaning.g.dart';

@freezed
class Meaning with _$Meaning {
  const factory Meaning({
    /// Часть речи значения
    @Default(PartOfSpeech.unknown)
    @JsonKey(name: 'partOfSpeech', unknownEnumValue: PartOfSpeech.unknown)
    final PartOfSpeech partOfSpeech,

    /// Определения
    @Default([]) final List<Definition> definitions,
  }) = _Meaning;

  /// Generate Class from Map<String, Object?>
  factory Meaning.fromJson(Map<String, Object?> json) =>
      _$MeaningFromJson(json);
}

enum PartOfSpeech {
  /// Существительное
  @JsonValue('noun')
  noun,

  /// Глагол
  @JsonValue('verb')
  verb,
  @JsonValue('unknown')
  unknown;
}
