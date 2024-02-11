import 'package:meta/meta.dart';
import 'package:word_pronunciation/src/features/word/data/datasource/word_datasource.dart';
import 'package:word_pronunciation/src/features/word/data/model/word.dart';
import 'package:word_pronunciation/src/features/word/domain/repository/i_word_repository.dart';

@immutable
class WordRepository implements IWordRepository {
  final IWordDatasource _datasource;

  const WordRepository({
    required IWordDatasource datasource,
  }) : _datasource = datasource;

  @override
  Future<Word?> readWordFromNetwork() => _datasource.readWordFromNetwork();
}
