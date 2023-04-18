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

  @observable
  String grnz = "";
  @observable
  String hour = "";
  @observable
  int price = 0;

  @observable
  DateTime paymentTime = DateTime.now();
  @observable
  ObservableList<Car> cars = ObservableList<Car>();

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

  Future<void> getCars() async {
    final _prefs = await SharedPreferences.getInstance();
    final carsJson = _prefs.getString('cars');
    if (carsJson != null) {
      final List<dynamic> decodedJson = jsonDecode(carsJson);
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
