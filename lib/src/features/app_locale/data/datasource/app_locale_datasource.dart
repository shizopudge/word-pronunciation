import 'dart:io';

import 'package:meta/meta.dart';
import 'package:word_pronunciation/src/core/key_local_storage/key_local_storage.dart';
import 'package:word_pronunciation/src/core/logger/logger.dart';

/// {@template app_locale_datasource}
/// Источник данных локализации приложения
/// {@endtemplate}
@immutable
abstract interface class IAppLocaleDatasource {
  /// Записывает код языка в хранилище
  ///
  /// [languageCode] - код языка
  Future<void> writeLanguageCodeToStorage(String languageCode);

  /// Читает код языка из хранилища
  String readLanguageCodeFromStorage();

  /// Возвращает код языка по умолчанию
  String get defaultLanguageCode;
}

/// {@macro app_locale_datasource}
@immutable
class AppLocaleDatasource implements IAppLocaleDatasource {
  /// {@macro key_local_storage}
  final IKeyLocalStorage _keyLocalStorage;

  /// {@macro app_locale_datasource}
  const AppLocaleDatasource({
    required IKeyLocalStorage keyLocalStorage,
  }) : _keyLocalStorage = keyLocalStorage;

  /// Ключ кода языка приложения в [IKeyLocalStorage]
  static const _languageCodeStorageKey = 'languageCode';

  @override
  String get defaultLanguageCode {
    try {
      return Platform.localeName.split('_').first;
    } on Object catch (error, stackTrace) {
      L.error(
          'Something went wrong while getting platform locale name. Error: $error',
          error: error,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  String readLanguageCodeFromStorage() =>
      _keyLocalStorage.read(_languageCodeStorageKey) ?? defaultLanguageCode;

  @override
  Future<void> writeLanguageCodeToStorage(String languageCode) =>
      _keyLocalStorage.write(
        _languageCodeStorageKey,
        languageCode,
      );
}
