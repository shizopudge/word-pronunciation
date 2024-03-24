import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Интерфейс базы данных приложения.
@immutable
abstract interface class IDB {
  /// Записывает элемент в БД
  ///
  /// Возвращает ID записанного элемента
  Future<int>? writeOne({
    required String table,
    required Map<String, Object?> map,
  });

  /// Читает элемент из БД
  Future<T?> readOne<T>({
    required String table,
    required int id,
    required T Function(Map<String, Object?> map) fromDB,
  });

  /// Читает элементы из БД
  Future<Iterable<T>> readMany<T>({
    required String table,
    required T Function(Map<String, Object?> map) fromDB,
    required int limit,
    required int offset,
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
  });

  /// Удаляет элемент из БД
  ///
  /// Возвращает количество удаленных строк
  Future<int> deleteOne({
    required String table,
    required int id,
  });

  /// Закрывает БД
  Future<void> dispose();
}

/// {@template db}
/// БД приложения
/// {@endtemplate}
@immutable
class DB implements IDB {
  /// {@macro db}
  const DB._();

  /// Экземпляр БД
  static Database? _database;

  /// Возвращает экземпляр БД
  static Future<IDB> get instance async {
    if (_database == null) {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, 'word-pronunciation.db');
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    }
    return const DB._();
  }

  /// Таблицы
  static const _tableSqlCreationStrings = [
    'CREATE TABLE words (id INTEGER PRIMARY KEY AUTOINCREMENT, data '
        'TEXT NOT NULL UNIQUE, pronounced INTEGER NOT NULL)',
  ];

  /// Обработчик на создание БД
  static Future<void> _onCreate(Database db, int version) async {
    for (final sqlString in _tableSqlCreationStrings) {
      await db.execute(sqlString);
    }
  }

  @override
  Future<int>? writeOne({
    required String table,
    required Map<String, Object?> map,
  }) =>
      _database?.insert(
        table,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

  @override
  Future<T?> readOne<T>({
    required String table,
    required int id,
    required T Function(Map<String, Object?> map) fromDB,
  }) async {
    final result = await _database?.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result == null) return null;
    return result.map(fromDB).firstOrNull;
  }

  @override
  Future<Iterable<T>> readMany<T>({
    required String table,
    required T Function(Map<String, Object?> map) fromDB,
    required int limit,
    required int offset,
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
  }) async {
    final result = await _database?.query(
      table,
      limit: limit,
      offset: offset,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
    if (result == null) return [];
    return result.map(fromDB);
  }

  @override
  Future<int> deleteOne({
    required String table,
    required Object id,
  }) async {
    final result = await _database?.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result == null) return 0;
    return result;
  }

  @override
  Future<void> dispose() async {
    await _database?.close();
  }
}
