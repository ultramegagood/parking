# Бет маршрутизатор
беттер арасындағы қосымшалар жолдар арқылы жұмыс істейді және олардың арасында бірдей жұмыс істейді-

```dart
context.go("/auth")
```
```dart
/// маршрутизатор маршруттар мен ішкі маршруттарды орнату үшін go_router пакеті қолданыладыimport 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parking/pages/home.dart';
import 'package:parking/pages/login.dart';
import 'package:parking/pages/payment_page.dart';
import 'package:parking/pages/signup.dart';
import 'package:parking/service_locator.dart';
import 'package:parking/stores/auth_store.dart';
import 'package:shared_preferences/shared_preferences.dart';
///
///маршрутизатор маршруттар мен ішкі маршруттарды орнату үшін go_router пакеті қолданылады
///
final userStore = serviceLocator<UserStore>();

GoRouter routes = GoRouter(
  initialLocation: '/auth',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: "/auth",
      builder: (context, state) =>  LoginPage(),
      redirect: (context, state){
/// егер кэште пайдаланушы бос болмаса (рұқсат етілген) үйге бетке бағыттаңыз
        if(userStore.user != null){
          return "/";
        }
        return null;
      }
    ),

    GoRoute(
      path: "/signup",
      builder: (context, state) => SignUpPage(),
    ),
    GoRoute(path: '/',
      builder: (context, state) => const HomePage(),
      routes: [

        GoRoute(
          path: "payment",
          builder: (context, state) => PaymentPage(),
        ),
      ],
      redirect: (context, state){

егер кэште пайдаланушы бос болса (рұқсат етілмеген) логин бетке қайта бағыттаңыз
        if(userStore.user == null){
          return "/auth";
        }
        return null;
      }
      ,),
  ],
);

```

# Күй менеджері

Экрандарды жаңарту үшін деректер күйі экранды жаңарту әдістерін шақырған кезде біз "mobx" күй менеджерін қолданамыз оны пайдалану оңай және қарапайым.
мысалы, сынып пен әдіс келесідей жарияланады:
```dart
  final userStore = serviceLocator<UserStore>();
  
  ElevatedButton(
                onPressed: () async {
                  try {
                    /// метод шакыру
                   await userStore.signIn().then((value) => context.go("/"));

                  } on FirebaseAuthException catch (e) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Ошибка"),
                            content: Text(e.code),
                          );
                        });
                  }
                },
                child: const Text('Login'),
              ),
```

## Singleton

Жобадан деректерді басқару үшін біз singleton бағдарламалау әдісін қолданамыз онда деректер мен өрістер servicelocator көмегімен жергілікті абстрактілі сыныпқа алынады

```dart
import 'package:buskz/stores/ticket_store.dart';
import 'package:get_it/get_it.dart';

///
/// Бүкіл жоба үшін жалғыз сілтеме нысаны
///
GetIt serviceLocator = GetIt.instance;

///
/// Жоба үшін синглтондарды тіркеу әдісі
///
Future<void> serviceLocatorSetup() async {
  serviceLocator
    ..registerSingleton<CarStore>(CarStore())
    ..registerSingleton<UserStore>(UserStore());
}
```

## Плагиндер мен кітапханалар
```
  cupertino_icons: ^1.0.2
  json_serializable: ^6.6.0
  mobx_codegen: ^2.0.7+3
  mobx: 2.1.1
  flutter_mobx: 2.0.6+4
  flutter_provider:
  mask_text_input_formatter: ^2.4.0
  get_it: ^7.2.0
  build_runner: ^2.3.3
  flutter_svg:
  shared_preferences: ^2.0.17
  logger:
```

## Жобаның жұмыс әдістері
```

/// Singleton әдістерімен жұмыс істеуге арналған дерексіз сынып
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/car.dart';

part 'car_store.g.dart';

class CarStore = _CarStore with _$CarStore;

abstract class _CarStore with Store {
  _CarStore();

/// госномер
  @observable
  String grnz = "";
/// уакыт
  @observable
  String hour = "";

/// Багамы
  @observable
  int price = 0;

  @observable
  DateTime paymentTime = DateTime.now();
/// массив билеттедын
  @observable
  ObservableList<Car> cars = ObservableList<Car>();

/// билеты машинага косу Жане сактау
  @action
  Future<void> addCar() async {
    final newCar = Car(
        grnz: grnz,
        hours: hour,
        paymentTime: paymentTime,
        price: price.toString());
    cars.add(newCar);
    await _saveCars();
  }


  @action
  Future<void> deleteCar(int index) async {
    cars.removeAt(index);
    await _saveCars();
  }

/// билетерды кеш тан алу дане массивка косу (телефон память)
  Future<void> getCars() async {
    final _prefs = await SharedPreferences.getInstance();
    final carsJson = _prefs.getString('cars');
    if (carsJson != null) {
      final List<dynamic> decodedJson = jsonDecode(carsJson);

/// мыкаю Верде конвертация болады
      cars = ObservableList.of(decodedJson
          .map((e) => Car(
              grnz: e['grnz'],
              hours: e['hours'],
              price: e['price'],
              paymentTime: DateTime.parse(e['paymentTime'])))
          .toList().reversed);
    }
  }

  Future<void> _saveCars() async {
    final _prefs = await SharedPreferences.getInstance();
    final carsJson = jsonEncode(cars.map((e) => e.toJson()).toList());
    await _prefs.setString('cars', carsJson);
  }
}

```


## Модельны откызу
```

/// Конструктор мен json түрлендірулеріне арналған модель
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'car.g.dart';

/// код генераторга аннтоация косамыз
@JsonSerializable()
class Car {
  final String grnz;
  final String hours;
  final String price;
  final DateTime paymentTime;

  Car({required this.grnz,required this.hours,required this.paymentTime, required this.price});
/// json-дан конвертация
  factory Car.fromJson(Map<String, dynamic> json) =>
      _$CarFromJson(json);
/// json-га конвертаций

  Map<String, dynamic> toJson() => _$CarToJson(this);

}

```