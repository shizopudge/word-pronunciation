import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:word_pronunciation/src/features/word/data/model/definition.dart';
import 'package:word_pronunciation/src/features/word/data/model/meaning.dart';
import 'package:word_pronunciation/src/features/word/data/model/phonetic.dart';

part 'word.freezed.dart';
part 'word.g.dart';

@freezed
class Word with _$Word {
  const Word._();

  const factory Word({
    @JsonKey(name: 'word') required final String data,
    @Default([]) final List<Phonetic> phonetics,
    @Default([]) final List<Meaning> meanings,
  }) = _Word;

  Iterable<Definition> get nounDefinitions sync* {
    final nounMeanings =
        meanings.where((element) => element.partOfSpeech == PartOfSpeech.noun);
    for (final meaning in nounMeanings) {
      for (final definition in meaning.definitions) {
        yield definition;
      }
    }
  }

  Iterable<Definition> get verbDefinitions sync* {
    final verbMeanings =
        meanings.where((element) => element.partOfSpeech == PartOfSpeech.verb);
    for (final meaning in verbMeanings) {
      for (final definition in meaning.definitions) {
        yield definition;
      }
    }
  }

  /// Generate Class from Map<String, Object?>
  factory Word.fromJson(Map<String, Object?> json) => _$WordFromJson(json);
}
