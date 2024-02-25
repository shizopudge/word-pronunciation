import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:word_pronunciation/src/core/database/database.dart';

/// {@template db}
/// БД
/// {@endtemplate}
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

/// {@macro db}
class DB implements IDB {
  /// {@macro db}
  DB._();

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
    return DB._();
  }

  /// Таблицы
  static const Iterable<DBTable> _tables = [
    DBTable(
      name: 'words',
      sqlString:
          'CREATE TABLE words (id INTEGER PRIMARY KEY AUTOINCREMENT, data '
          'TEXT NOT NULL UNIQUE, pronounced INTEGER NOT NULL)',
    ),
  ];

  /// Обработчик на создание БД
  static Future<void> _onCreate(Database db, int version) async {
    final tables = _tables.toList();
    for (final table in tables) {
      await db.execute(table.sqlString);
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
    if (result == null) return -1;
    return result;
  }

  @override
  Future<void> dispose() async {
    await _database?.close();
  }
}
