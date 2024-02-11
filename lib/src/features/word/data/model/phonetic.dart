import 'package:freezed_annotation/freezed_annotation.dart';

part 'phonetic.freezed.dart';
part 'phonetic.g.dart';

@freezed
class Phonetic with _$Phonetic {
  const factory Phonetic({
    @Default('') final String text,
    @Default('') final String audio,
    @Default('') @JsonKey(name: 'license.name') final String licenseName,
  }) = _Phonetic;

  /// Generate Class from Map<String, Object?>
  factory Phonetic.fromJson(Map<String, Object?> json) =>
      _$PhoneticFromJson(json);
}
