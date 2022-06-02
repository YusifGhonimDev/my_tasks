import 'dart:async';
import 'package:my_tasks/data/model/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;
  static String? _dbPath;

  static Future<Database?> _getDB() async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  static Future<String?> _getDBPath() async {
    String databasesPath = await getDatabasesPath();
    _dbPath = join(databasesPath, 'tasks.db');
    return _dbPath;
  }

  static Future<Database?> initDB() async {
    _dbPath = await _getDBPath();
    _db = await openDatabase(_dbPath!, version: 1, onCreate: _onCreate);
    return _db;
  }

  static Future<void> _onCreate(Database db, _) async {
    await db.execute('''
      CREATE TABLE tasks(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      isDone INTEGER)
      ''');
  }

  static Future<List<Task>> readData() async {
    _db = await _getDB();
    List<Map> tasks = await _db!.query('tasks');
    return tasks.map((task) => Task.fromMap(task)).toList();
  }

  static Future<int> insertData(Task task) async {
    _db = await _getDB();
    return await _db!.insert('tasks', task.toMap());
  }

  static Future<void> deleteData(int id) async {
    _db = await _getDB();
    await _db!.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> updateData(Task task) async {
    _db = await _getDB();
    await _db!
        .update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }
}
