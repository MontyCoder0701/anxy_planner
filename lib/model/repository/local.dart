import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/base.dart';

abstract class LocalRepository<T extends BaseEntity> {
  static late final Database _instance;

  String get key => '';

  toJson(T item) => throw UnimplementedError();

  fromJson(Map<String, dynamic> json) => throw UnimplementedError();

  static Map<int, List<String>> migrationScripts = {
    1: [
      '''CREATE TABLE todo (
        id INTEGER PRIMARY KEY,
        title TEXT,
        forDate DATETIME,
        isComplete BOOLEAN CHECK (isComplete IN (0, 1)),
        todoType TEXT,
        createdAt DATETIME)
      ''',
      '''CREATE TABLE letter (
        id INTEGER PRIMARY KEY,
        subject TEXT,
        content TEXT,
        forDate DATETIME,
        isOpened BOOLEAN CHECK (isOpened IN (0, 1)),
        createdAt DATETIME)
      '''
    ],
  };

  static Future<void> initialize() async {
    final scriptsLength = migrationScripts.length;
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'one_moon.db');
    _instance = await openDatabase(
      path,
      version: scriptsLength,
      onCreate: (Database db, int version) async {
        for (int i = 1; i <= scriptsLength; i++) {
          final scripts = migrationScripts[i];
          if (scripts != null) {
            for (String script in scripts) {
              await db.execute(script);
            }
          }
        }
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        for (int i = oldVersion + 1; i <= newVersion; i++) {
          final scripts = migrationScripts[i];
          if (scripts != null) {
            for (String script in scripts) {
              await db.execute(script);
            }
          }
        }
      },
    );
  }

  Future<T> createOne(T item) async {
    final id = await _instance.insert(
      key,
      toJson(item),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    item.id = id;
    return item;
  }

  Future<T> getOne({required int id}) async {
    final List<Map<String, dynamic>> maps =
        await _instance.query(key, where: 'id = $id');
    return fromJson(maps[0]);
  }

  Future<List<T>> getMany() async {
    final List<Map<String, dynamic>> maps = await _instance.query(key);
    return List.generate(maps.length, (index) => fromJson(maps[index]));
  }

  Future<void> updateOne(T item) async {
    await _instance.update(
      key,
      toJson(item),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteOne(int id) async {
    await _instance.delete(
      key,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteMany(List<int> ids) async {
    final placeholders = List.filled(ids.length, '?').join(', ');
    await _instance.delete(
      key,
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );
  }
}
