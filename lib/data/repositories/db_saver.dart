import 'package:calculator/data/models/history_saver.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbSaver implements HistorySaver {
  DbSaver._();

  static final DbSaver _instance = DbSaver._();

  factory DbSaver() => _instance;

  Database? _db;

  openDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'calculator.db');

    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Calculations (id TEXT PRIMARY KEY, expression TEXT, result REAL, date TEXT)');
    });
  }

  @override
  Future<bool> addToHistory(Map<String, Object?> historyItem) async {
    final id = await _db?.insert('Calculations', historyItem);
    return id != null && id > 0;
  }

  @override
  Future<List<Map<String, Object?>>?> getHistory() async {
    return await _db?.query('Calculations');
  }

  @override
  Future<bool> removeFromHistory(String id) async {
    final res =
        await _db?.delete('Calculations', where: 'id = ?', whereArgs: [id]);
    return res != null && res > 0;
  }

  Future<void> close() async {
    _db?.close();
  }
}
