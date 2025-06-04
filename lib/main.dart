import 'package:chatapp/app/app.dart';
import 'package:chatapp/app/app_bloc_observer.dart';
import 'package:chatapp/common/common.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = const AppBlocObserver();
  await setupLocator();

  runApp(
    MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (context) => getIt<PreferencesRepository>())],
      child: const App(),
    ),
  );
}
