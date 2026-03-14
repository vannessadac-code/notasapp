import 'package:notasapp/app/models/note.dart';

abstract class NoteRepository {
  Future<List<Note>> getNotes();

  Future<Note?> getNote(String id);

  Future<void> addNote(Note note);

  Future<void> updateNote(Note note);

  Future<void> deleteNote(String id);
}
