import 'package:hive_flutter/hive_flutter.dart';

part 'user_preference_model.g.dart';

@HiveType(typeId: 3)
class UserPreferenceModel extends HiveObject {
  @HiveField(0)
  String preferredTranslation;

  @HiveField(1)
  String language;

  @HiveField(2)
  bool darkMode;

  @HiveField(3)
  double fontSize;

  @HiveField(4)
  bool notificationsEnabled;

  @HiveField(5)
  bool voiceEnabled;

  @HiveField(6)
  String voiceLanguage;

  @HiveField(7)
  double speechSpeed;

  @HiveField(8)
  bool isPremium;

  UserPreferenceModel({
    required this.preferredTranslation,
    required this.language,
    required this.darkMode,
    required this.fontSize,
    required this.notificationsEnabled,
    required this.voiceEnabled,
    required this.voiceLanguage,
    required this.speechSpeed,
    required this.isPremium,
  });

  // Constructor por defecto
  UserPreferenceModel.defaults()
      : preferredTranslation = 'RVR1960',
        language = 'es_ES',
        darkMode = false,
        fontSize = 16.0,
        notificationsEnabled = true,
        voiceEnabled = false,
        voiceLanguage = 'es-ES',
        speechSpeed = 1.0,
        isPremium = false;
}
