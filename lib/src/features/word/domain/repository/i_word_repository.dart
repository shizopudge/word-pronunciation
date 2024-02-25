import 'package:meta/meta.dart';
import 'package:word_pronunciation/src/features/word/data/model/local_word.dart';
import 'package:word_pronunciation/src/features/word/data/model/word.dart';
import 'package:word_pronunciation/src/features/word/domain/entity/word_history_filter.dart';

@immutable
abstract interface class IWordRepository {
  /// Получает слово из сети
  Future<Word?> readWordFromNetwork();

  /// Получает слово из интернет словаря
  Future<Word> readWordFromNetworkDictionary({
    required final String word,
  });

  /// Читает слова в истории из локального хранилища
  Future<Iterable<LocalWord>> readHistoryWordsFromLocal({
    required final int limit,
    required final int offset,
    required final WordHistoryFilter filter,
  });

  /// Записывает слово в локальную историю
  Future<int>? writeWordToLocalHistory({
    required final String word,
    required bool pronounced,
  });
}
