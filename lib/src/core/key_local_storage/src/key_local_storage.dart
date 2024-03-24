import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Интерфейс локального key-value хранилища
@immutable
abstract interface class IKeyLocalStorage {
  /// Записывает значение
  Future<void> write(String key, String value);

  /// Получает значение
  String? read(String key);

  /// Возвращает все ключи
  Set<String> readKeys();

  /// Возвращает все ключи
  bool containsKey(String key);

  /// Удаляет значение
  Future<bool> remove(String key);

  /// Очищает хранилище
  Future<bool> clear();
}

/// {@template key_local_storage}
/// Локальное key-value хранилище
/// {@endtemplate}
@immutable
class KeyLocalStorage implements IKeyLocalStorage {
  /// Экземпляр SharedPreferences
  final SharedPreferences _sharedPreferences;

  /// {@macro key_local_storage}
  const KeyLocalStorage({
    required final SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  @override
  Future<void> write(String key, String value) =>
      _sharedPreferences.setString(key, value);

  @override
  String? read(String key) => _sharedPreferences.getString(key);

  @override
  Set<String> readKeys() => _sharedPreferences.getKeys();

  @override
  bool containsKey(String key) => _sharedPreferences.containsKey(key);

  @override
  Future<bool> remove(String key) => _sharedPreferences.remove(key);

  @override
  Future<bool> clear() => _sharedPreferences.clear();
}
