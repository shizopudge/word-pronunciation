import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:word_pronunciation/src/core/dio/dio.dart';
import 'package:word_pronunciation/src/core/logger/logger.dart';
import 'package:word_pronunciation/src/features/word/data/model/word.dart';

@immutable
abstract interface class IWordDatasource {
  /// Получает слово из сети
  Future<Word?> readWordFromNetwork();
}

@immutable
class WordDatasource implements IWordDatasource {
  final IDioClient _dioClient;

  const WordDatasource({
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
    if (data != null && data.isNotEmpty) {
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
      if (data != null && data.isNotEmpty) {
        final wordFromData = data.first;
        if (wordFromData is Map<String, Object?>) {
          return Word.fromJson(wordFromData);
        }
      }
      return null;
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        L.error('The word was not found in the dictionary');
        return Word(data: wordStr);
      }
      rethrow;
    }
  }
}
