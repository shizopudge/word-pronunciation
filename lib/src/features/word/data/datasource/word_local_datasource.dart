import 'package:flutter/cupertino.dart';
import 'package:word_pronunciation/src/core/database/database.dart';
import 'package:word_pronunciation/src/features/word/data/model/local_word.dart';
import 'package:word_pronunciation/src/features/word/domain/entity/word_history_filter.dart';

@immutable
abstract interface class IWordLocalDatasource {
  /// Читает слова в истории из локального хранилища
  Future<Iterable<LocalWord>> readHistoryWordsFromLocal({
    required final int limit,
    required final int offset,
    required final WordHistoryFilter filter,
  });

  /// Записывает слово в локальную историю
  Future<int>? writeWordToLocalHistory({
    required final String word,
    required final bool pronounced,
  });
}

@immutable
class WordLocalDatasource implements IWordLocalDatasource {
  final IDB _db;

  const WordLocalDatasource({required IDB db}) : _db = db;

  /// Таблица
  static const String _table = 'words';

  @override
  Future<Iterable<LocalWord>> readHistoryWordsFromLocal({
    required final int limit,
    required final int offset,
    required final WordHistoryFilter filter,
  }) {
    String? where;
    List<int>? whereArgs;

    if (filter != WordHistoryFilter.all) where = 'pronounced = ?';

    if (filter == WordHistoryFilter.pronounced) whereArgs = [1];
    if (filter == WordHistoryFilter.incorrect) whereArgs = [0];

    return _db.readMany<LocalWord>(
      table: _table,
      fromDB: LocalWord.fromDB,
      limit: limit,
      offset: offset,
      where: where,
      whereArgs: whereArgs,
    );
  }

  @override
  Future<int>? writeWordToLocalHistory({
    required String word,
    required bool pronounced,
  }) =>
      _db.writeOne(
        table: _table,
        map: LocalWord.withoutID(data: word, pronounced: pronounced).toDB(),
      );
}
