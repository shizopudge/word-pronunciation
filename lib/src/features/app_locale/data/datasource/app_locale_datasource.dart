import 'package:flutter/material.dart';
import 'package:word_pronunciation/src/core/key_local_storage/key_local_storage.dart';

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
  String get defaultLanguageCode => 'en';

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
