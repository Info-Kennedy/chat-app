import 'package:chatapp/chat/repository/message_repository.dart';
import 'package:chatapp/common/common.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Register PreferencesRepository
  getIt.registerSingleton<PreferencesRepository>(PreferencesRepository(sharedPreferences));

  getIt.registerSingleton<MessageRepository>(MessageRepository());

  // Initialize and configure Sembast DB
  //Register DIO
  getIt.registerSingleton<Dio>(Dio());
}
