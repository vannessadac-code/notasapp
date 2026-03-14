import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static const _dbName = 'notes.db';
  static const _dbVersion = 1;
  static const notesTable = 'notes';

  static final AppDatabase instance = AppDatabase._init();

  Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB(_dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $notesTable (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        isPinned INTEGER NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    if (_database == null) {
      return;
    }

    await _database!.close();
    _database = null;
  }
}
