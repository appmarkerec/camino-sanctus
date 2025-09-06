import 'package:hive_flutter/hive_flutter.dart';

part 'verse_model.g.dart';

@HiveType(typeId: 2)
class VerseModel extends HiveObject {
  @HiveField(0)
  String reference;

  @HiveField(1)
  String text;

  @HiveField(2)
  String translation;

  @HiveField(3)
  String book;

  @HiveField(4)
  int chapter;

  @HiveField(5)
  int verse;

  @HiveField(6)
  bool isFavorite;

  @HiveField(7)
  DateTime? lastAccessed;

  VerseModel({
    required this.reference,
    required this.text,
    required this.translation,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.isFavorite,
    this.lastAccessed,
  });

  // Constructor por defecto
  VerseModel.empty()
      : reference = '',
        text = '',
        translation = 'RVR1960',
        book = '',
        chapter = 1,
        verse = 1,
        isFavorite = false;

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
      'text': text,
      'translation': translation,
      'book': book,
      'chapter': chapter,
      'verse': verse,
      'isFavorite': isFavorite,
      'lastAccessed': lastAccessed?.toIso8601String(),
    };
  }

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    return VerseModel(
      reference: json['reference'] ?? '',
      text: json['text'] ?? '',
      translation: json['translation'] ?? 'RVR1960',
      book: json['book'] ?? '',
      chapter: json['chapter'] ?? 1,
      verse: json['verse'] ?? 1,
      isFavorite: json['isFavorite'] ?? false,
      lastAccessed: json['lastAccessed'] != null 
          ? DateTime.parse(json['lastAccessed'])
          : null,
    );
  }

  String get shortReference => '$book $chapter:$verse';
}
