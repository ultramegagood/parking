/// Синглотон обьект для всего проекта

import 'package:get_it/get_it.dart';
import 'package:parking/stores/auth_store.dart';
import 'package:parking/stores/car_store.dart';

///
/// Синглотон обьект для всего проекта
///
GetIt serviceLocator = GetIt.instance;

///
/// Метод для регистраций синглтонов для проекта
///
Future<void> serviceLocatorSetup() async {
  serviceLocator
    ..registerSingleton<CarStore>(CarStore())
    ..registerSingleton<UserStore>(UserStore());
}
