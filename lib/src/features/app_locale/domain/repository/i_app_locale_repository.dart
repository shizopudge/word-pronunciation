import 'package:flutter/material.dart';

/// {@template app_locale_repository}
/// Репозиторий локализации приложения
/// {@endtemplate}
@immutable
abstract interface class IAppLocaleRepository {
  /// Записывает код языка в хранилище
  ///
  /// [languageCode] - код языка
  Future<void> writeLanguageCodeToStorage(String languageCode);

  /// Читает код языка из хранилища
  String readLanguageCodeFromStorage();

  /// Возвращает код языка по умолчанию
  String get defaultLanguageCode;
}
