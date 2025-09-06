// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preference_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPreferenceModelAdapter extends TypeAdapter<UserPreferenceModel> {
  @override
  final int typeId = 3;

  @override
  UserPreferenceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPreferenceModel(
      preferredTranslation: fields[0] as String,
      language: fields[1] as String,
      darkMode: fields[2] as bool,
      fontSize: fields[3] as double,
      notificationsEnabled: fields[4] as bool,
      voiceEnabled: fields[5] as bool,
      voiceLanguage: fields[6] as String,
      speechSpeed: fields[7] as double,
      isPremium: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserPreferenceModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.preferredTranslation)
      ..writeByte(1)
      ..write(obj.language)
      ..writeByte(2)
      ..write(obj.darkMode)
      ..writeByte(3)
      ..write(obj.fontSize)
      ..writeByte(4)
      ..write(obj.notificationsEnabled)
      ..writeByte(5)
      ..write(obj.voiceEnabled)
      ..writeByte(6)
      ..write(obj.voiceLanguage)
      ..writeByte(7)
      ..write(obj.speechSpeed)
      ..writeByte(8)
      ..write(obj.isPremium);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPreferenceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
