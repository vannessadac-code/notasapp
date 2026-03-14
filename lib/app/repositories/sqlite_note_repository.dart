import 'package:notasapp/app/models/note.dart';
import 'package:notasapp/app/repositories/note_repository.dart';
import 'package:notasapp/core/db.dart';
import 'package:sqflite/sqflite.dart';

class SqliteNoteRepository implements NoteRepository {
  SqliteNoteRepository({AppDatabase? appDatabase})
    : _appDatabase = appDatabase ?? AppDatabase.instance;

  final AppDatabase _appDatabase;
  static const _tableNotes = AppDatabase.notesTable;

  @override
  Future<void> addNote(Note note) async {
    final db = await _appDatabase.database;
    await db.insert(
      _tableNotes,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteNote(String id) async {
    final db = await _appDatabase.database;
    await db.delete(_tableNotes, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<Note?> getNote(String id) async {
    final db = await _appDatabase.database;
    final rows = await db.query(
      _tableNotes,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    return Note.fromMap(rows.first);
  }

  @override
  Future<List<Note>> getNotes() async {
    final db = await _appDatabase.database;
    final rows = await db.query(
      _tableNotes,
      orderBy: 'isPinned DESC, updatedAt DESC',
    );
    return rows.map(Note.fromMap).toList();
  }

  @override
  Future<void> updateNote(Note note) async {
    final db = await _appDatabase.database;
    await db.update(
      _tableNotes,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
