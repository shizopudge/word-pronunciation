import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template key_local_storage}
/// Локальное key-value хранилище
/// {@endtemplate}
@immutable
abstract interface class IKeyLocalStorage {
  /// Записывает значение
  Future<void> setValue(String key, String value);

  /// Получает значение
  String? getValue(String key);

  /// Возвращает все ключи
  Set<String> getKeys();

  /// Возвращает все ключи
  bool containsKey(String key);

  /// Удаляет значение
  Future<bool> remove(String key);

  /// Очищает хранилище
  Future<bool> clear();
}

/// {@macro key_local_storage}
@immutable
class KeyLocalStorage implements IKeyLocalStorage {
  /// Экземпляр SharedPreferences
  final SharedPreferences _sharedPreferences;

  /// {@macro key_local_storage}
  const KeyLocalStorage({
    required final SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  @override
  Future<void> setValue(String key, String value) async =>
      _sharedPreferences.setString(key, value);

  @override
  String? getValue(String key) => _sharedPreferences.getString(key);

  @override
  Set<String> getKeys() => _sharedPreferences.getKeys();

  @override
  bool containsKey(String key) => _sharedPreferences.containsKey(key);

  @override
  Future<bool> remove(String key) async => _sharedPreferences.remove(key);

  @override
  Future<bool> clear() async => _sharedPreferences.clear();
}
