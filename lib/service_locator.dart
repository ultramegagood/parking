/// Singleton бүкіл жоба үшін нысан

import 'package:get_it/get_it.dart';
import 'package:parking/stores/auth_store.dart';
import 'package:parking/stores/car_store.dart';

GetIt serviceLocator = GetIt.instance;

///
/// Жоба үшін синглтондарды тіркеу әдісі
///
Future<void> serviceLocatorSetup() async {
  serviceLocator
    ..registerSingleton<CarStore>(CarStore())
    ..registerSingleton<UserStore>(UserStore());
}
