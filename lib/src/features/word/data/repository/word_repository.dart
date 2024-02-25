import 'package:meta/meta.dart';
import 'package:word_pronunciation/src/features/word/data/datasource/word_local_datasource.dart';
import 'package:word_pronunciation/src/features/word/data/datasource/word_remote_datasource.dart';
import 'package:word_pronunciation/src/features/word/data/model/local_word.dart';
import 'package:word_pronunciation/src/features/word/data/model/word.dart';
import 'package:word_pronunciation/src/features/word/domain/entity/word_history_filter.dart';
import 'package:word_pronunciation/src/features/word/domain/repository/i_word_repository.dart';

@immutable
class WordRepository implements IWordRepository {
  final IWordRemoteDatasource _remoteDatasource;
  final IWordLocalDatasource _localDatasource;

  const WordRepository({
    required IWordRemoteDatasource remoteDatasource,
    required IWordLocalDatasource localDatasource,
  })  : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource;

  @override
  Future<Word?> readWordFromNetwork() =>
      _remoteDatasource.readWordFromNetwork();

  @override
  Future<Word> readWordFromNetworkDictionary({
    required final String word,
  }) =>
      _remoteDatasource.readWordFromNetworkDictionary(word: word);

  @override
  Future<Iterable<LocalWord>> readHistoryWordsFromLocal({
    required final int limit,
    required final int offset,
    required final WordHistoryFilter filter,
  }) =>
      _localDatasource.readHistoryWordsFromLocal(
        limit: limit,
        offset: offset,
        filter: filter,
      );

  @override
  Future<int>? writeWordToLocalHistory({
    required final String word,
    required final bool pronounced,
  }) =>
      _localDatasource.writeWordToLocalHistory(
          word: word, pronounced: pronounced);
}
