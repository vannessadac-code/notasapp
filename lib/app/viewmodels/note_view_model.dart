import 'package:flutter/material.dart';
import 'package:notasapp/app/models/note.dart';
import 'package:notasapp/app/repositories/note_repository.dart';

enum NoteStatus { idle, loading, error, success }

class NoteViewModel extends ChangeNotifier {
  final NoteRepository _repository;

  NoteViewModel(this._repository);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  bool _isSaving = false;
  List<Note> _notes = [];
  NoteStatus _status = NoteStatus.idle;
  String? _errorMessage;
  String _searchQuery = '';
  bool _pinnedOnly = false;

  bool get isSaving => _isSaving;

  GlobalKey<FormState> get formKey => _formKey;

  bool get isLoading => _status == NoteStatus.loading;

  NoteStatus get status => _status;

  String? get errorMessage => _errorMessage;

  String get searchQuery => _searchQuery;

  bool get pinnedOnly => _pinnedOnly;

  void setInitialNote(Note? note) {
    if (note != null) {
      titleController.text = note.title;
      contentController.text = note.content;
    } else {
      titleController.clear();
      contentController.clear();
    }
  }

  List<Note> get notes {
    var result = [..._notes];

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((note) {
        return note.title.toLowerCase().contains(q) ||
            note.content.toLowerCase().contains(q);
      }).toList();
    }

    if (_pinnedOnly) {
      result = result.where((note) => note.isPinned).toList();
    }

    return result;
  }

  Future<void> loadNotes() async {
    _setStatus(NoteStatus.loading);
    try {
      _notes = await _repository.getNotes();
      _sortNotes();
      _setStatus(NoteStatus.success);
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> _addNote({
    required String title,
    required String content,
    bool isPinned = false,
  }) async {
    _setStatus(NoteStatus.loading);
    try {
      final note = Note.create(
        title: title,
        content: content,
        isPinned: isPinned,
      );
      await _repository.addNote(note);
      _notes.add(note);
      _sortNotes();
      _setStatus(NoteStatus.success);
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> _updateNote({
    required String id,
    required String title,
    required String content,
    bool? isPinned,
  }) async {
    _setStatus(NoteStatus.loading);
    try {
      var existing = await _repository.getNote(id);
      if (existing == null) throw StateError('Note $id not found');
      final updated = existing.copyWith(
        title: title,
        content: content,
        updatedAt: DateTime.now(),
        isPinned: isPinned,
      );
      await _repository.updateNote(updated);
      _notes[_notes.indexWhere((note) => note.id == id)] = updated;
      _sortNotes();
      _setStatus(NoteStatus.success);
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> togglePin(String id) async {
    _setStatus(NoteStatus.loading);
    try {
      final existing = await _repository.getNote(id);
      if (existing == null) throw StateError('Note $id not found');
      final updated = existing.copyWith(
        isPinned: !existing.isPinned,
        updatedAt: DateTime.now(),
      );
      await _repository.updateNote(updated);
      _notes[_notes.indexWhere((note) => note.id == id)] = updated;
      _sortNotes();
      _setStatus(NoteStatus.success);
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> deleteNote(String id) async {
    _setStatus(NoteStatus.loading);
    try {
      await _repository.deleteNote(id);
      _notes.removeWhere((note) => note.id == id);
      _setStatus(NoteStatus.success);
    } catch (e) {
      _setError(e.toString());
    }
  }

  void searchNotes(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  set isSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  void setPinnedOnly(bool value) {
    _pinnedOnly = value;
    notifyListeners();
  }

  void _sortNotes() {
    _notes.sort((a, b) {
      final pinOrder = (b.isPinned ? 1 : 0) - (a.isPinned ? 1 : 0);
      if (pinOrder != 0) {
        return pinOrder;
      }

      return b.updatedAt.compareTo(a.updatedAt);
    });
  }

  void _setStatus(NoteStatus status) {
    _status = status;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _setStatus(NoteStatus.error);
    _errorMessage = message;
    notifyListeners();
  }

  String? validTitle(String? value) {
    if (value == null || value.isEmpty) return "El titulo es requerido";
    return null;
  }

  Future<void> saveNote({
    String? id,
    required String title,
    required String content,
  }) async {
    if (id == null) {
      await _addNote(title: title, content: content);
    } else {
      await _updateNote(id: id, title: title, content: content);
    }
    if (_status == NoteStatus.success) {
      _setStatus(NoteStatus.idle);
    }
  }
}
