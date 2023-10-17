import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper.internal();

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'calculadora_imc.db');
    final database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return database;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE UserMeasurements (
        id INTEGER PRIMARY KEY,
        name TEXT,
        height REAL,
        weight REAL,
        imc REAL,
        date TEXT
      )
    ''');
  }

  Future<int> saveMeasurement(Map<String, dynamic> measurement) async {
    final database = await db;
    return await database!.insert('UserMeasurements', measurement);
  }

  Future<List<Map<String, dynamic>>> getMeasurements() async {
    final database = await db;
    return await database!.query('UserMeasurements');
  }
}
