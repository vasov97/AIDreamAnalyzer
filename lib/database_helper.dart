import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'dream_journal.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE dreams(id INTEGER PRIMARY KEY, title TEXT, content TEXT, date TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> saveDream(String title, String content) async {
    final db = await database;
    final DateTime now = DateTime.now();
    await db.insert(
      'dreams',
      {
        'title': title,
        'content': content,
        'date': now.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> fetchDreams() async {
    final db = await database;
    return await db.query('dreams');
  }
}
