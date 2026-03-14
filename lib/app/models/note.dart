import 'package:uuid/uuid.dart';

class Note {
  static const String _idKey = 'id';
  static const String _titleKey = 'title';
  static const String _contentKey = 'content';
  static const String _createdAtKey = 'createdAt';
  static const String _updatedAtKey = 'updatedAt';
  static const String _isPinnedKey = 'isPinned';

  String id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  bool isPinned;

  static const Uuid _uuid = Uuid();

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isPinned = false,
  });

  factory Note.create({
    required String title,
    required String content,
    bool isPinned = false,
  }) {
    final now = DateTime.now();
    return Note(
      id: _uuid.v4(),
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
      isPinned: isPinned,
    );
  }

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: _idFromValue(json[_idKey]),
    title: json[_titleKey] as String,
    content: json[_contentKey] as String,
    createdAt: DateTime.parse(json[_createdAtKey] as String),
    updatedAt: DateTime.parse(json[_updatedAtKey] as String),
    isPinned: json[_isPinnedKey] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    _idKey: id,
    _titleKey: title,
    _contentKey: content,
    _createdAtKey: createdAt.toIso8601String(),
    _updatedAtKey: updatedAt.toIso8601String(),
    _isPinnedKey: isPinned,
  };

  factory Note.fromMap(Map<String, dynamic> map) => Note(
    id: _idFromValue(map[_idKey]),
    title: map[_titleKey] as String,
    content: map[_contentKey] as String,
    createdAt: _dateTimeFromMapValue(map[_createdAtKey]),
    updatedAt: _dateTimeFromMapValue(map[_updatedAtKey]),
    isPinned: _boolFromMapValue(map[_isPinnedKey]),
  );

  Map<String, dynamic> toMap() => {
    _idKey: id,
    _titleKey: title,
    _contentKey: content,
    _createdAtKey: createdAt.millisecondsSinceEpoch,
    _updatedAtKey: updatedAt.millisecondsSinceEpoch,
    _isPinnedKey: isPinned ? 1 : 0,
  };

  // copy with
  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPinned,
  }) => Note(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isPinned: isPinned ?? this.isPinned,
  );

  static DateTime _dateTimeFromMapValue(dynamic value) {
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }

    if (value is String) {
      return DateTime.parse(value);
    }

    throw FormatException('Invalid date value: $value');
  }

  static String _idFromValue(dynamic value) {
    if (value is String && value.trim().isNotEmpty) {
      return value;
    }

    if (value is int) {
      return value.toString();
    }

    throw FormatException('Invalid id value: $value');
  }

  static bool _boolFromMapValue(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    if (value is String) {
      return value == '1' || value.toLowerCase() == 'true';
    }

    return false;
  }
}
