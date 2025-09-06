import 'package:get_it/get_it.dart';
import '../services/ai_service.dart';
import '../services/bible_service.dart';
import '../services/voice_service.dart';
import '../services/database_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Registrar servicios como singletons
  locator.registerLazySingleton(() => AIService());
  locator.registerLazySingleton(() => BibleService());
  locator.registerLazySingleton(() => VoiceService());
  locator.registerLazySingleton(() => DatabaseService());
}

