// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verse_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VerseModelAdapter extends TypeAdapter<VerseModel> {
  @override
  final int typeId = 2;

  @override
  VerseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VerseModel(
      reference: fields[0] as String,
      text: fields[1] as String,
      translation: fields[2] as String,
      book: fields[3] as String,
      chapter: fields[4] as int,
      verse: fields[5] as int,
      isFavorite: fields[6] as bool,
      lastAccessed: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, VerseModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.reference)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.translation)
      ..writeByte(3)
      ..write(obj.book)
      ..writeByte(4)
      ..write(obj.chapter)
      ..writeByte(5)
      ..write(obj.verse)
      ..writeByte(6)
      ..write(obj.isFavorite)
      ..writeByte(7)
      ..write(obj.lastAccessed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
