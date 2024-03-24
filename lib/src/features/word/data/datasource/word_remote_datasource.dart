import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:word_pronunciation/src/core/dio/dio.dart';
import 'package:word_pronunciation/src/core/logger/logger.dart';
import 'package:word_pronunciation/src/features/word/data/model/word.dart';

@immutable
abstract interface class IWordRemoteDatasource {
  /// Получает слово из сети
  Future<Word?> readWordFromNetwork();

  /// Получает слово из интернет словаря
  Future<Word> readWordFromNetworkDictionary({
    required final String word,
  });
}

@immutable
class WordRemoteDatasource implements IWordRemoteDatasource {
  final IDioClient _dioClient;

  const WordRemoteDatasource({
    required IDioClient dioClient,
  }) : _dioClient = dioClient;

  /// Url слова
  static const _wordUrl = 'https://random-word-api.vercel.app/api?';

  /// Url словаря
  static const _dictionaryUrl =
      'https://api.dictionaryapi.dev/api/v2/entries/en';

  @override
  Future<Word?> readWordFromNetwork() async {
    final wordStr = await _readWordStr();
    if (wordStr == null) return null;
    final wordModel = await _readWordModel(wordStr);
    return wordModel?.copyWith(data: wordStr) ?? Word(data: wordStr);
  }

  @override
  Future<Word> readWordFromNetworkDictionary({
    required final String word,
  }) async {
    final wordModel = await _readWordModel(word);
    return wordModel?.copyWith(data: word) ?? Word(data: word);
  }

  /// Получает слово строкой из сети
  Future<String?> _readWordStr() async {
    const queryParameters = <String, Object?>{
      'words': 1,
      'type': 'capitalized'
    };
    final response = await _dioClient.get<List<Object?>>(
      _wordUrl,
      queryParameters: queryParameters,
    );
    final data = response.data;
    if (response.statusCode == 200 && data != null && data.isNotEmpty) {
      final word = data.first;
      if (word is String) return word;
    }
    return null;
  }

  /// Получает модель [Word] из сети
  Future<Word?> _readWordModel(String wordStr) async {
    try {
      final response =
          await _dioClient.get<List<Object?>>('$_dictionaryUrl/$wordStr');
      final data = response.data;
      if (response.statusCode == 200 && data != null && data.isNotEmpty) {
        final wordFromData = data.first;
        if (wordFromData is Map<String, Object?>) {
          return Word.fromJson(wordFromData);
        }
      }
      return null;
    } on DioException catch (error, stackTrace) {
      if (error.response?.statusCode == 404) {
        L.error(
          'The word was not found in the dictionary',
          error: error,
          stackTrace: stackTrace,
        );
        return Word(data: wordStr);
      }
      rethrow;
    }
  }
}
