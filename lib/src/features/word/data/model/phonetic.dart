import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:word_pronunciation/src/features/word/data/model/license.dart';

part 'phonetic.freezed.dart';
part 'phonetic.g.dart';

@freezed
class Phonetic with _$Phonetic {
  const factory Phonetic({
    @Default('') final String audio,
    final License? license,
  }) = _Phonetic;

  /// Generate Class from Map<String, Object?>
  factory Phonetic.fromJson(Map<String, Object?> json) =>
      _$PhoneticFromJson(json);
}
