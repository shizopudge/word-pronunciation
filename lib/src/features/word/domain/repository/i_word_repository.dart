import 'package:meta/meta.dart';
import 'package:word_pronunciation/src/features/word/data/model/word.dart';

@immutable
abstract interface class IWordRepository {
  /// Получает слово из сети
  Future<Word?> readWordFromNetwork();
}
