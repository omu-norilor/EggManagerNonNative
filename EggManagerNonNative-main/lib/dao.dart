import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'egg.dart';

class EggDatabaseHelper {
  static const String dbName = 'eggs.db';
  static const String tableName = 'eggs';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            species TEXT,
            size TEXT,
            daysToHatch INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertEgg(Egg egg) async {
    final db = await database;
    await db.insert(tableName, egg.toMapNoId());
  }

  Future<List<Egg>> getAllEggs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Egg.fromMap(maps[i]);
    });
  }

  Future<void> updateEgg(Egg egg) async {
    final db = await database;
    await db.update(
      tableName,
      egg.toMap(),
      where: 'id = ?',
      whereArgs: [egg.id],
    );
  }

  Future<void> deleteEgg(int id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}