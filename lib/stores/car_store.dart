/// Singleton әдістерімен жұмыс істеуге арналған дерексіз сынып
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/car.dart';
import '../service_locator.dart';

part 'car_store.g.dart';

class CarStore = _CarStore with _$CarStore;

abstract class _CarStore with Store {
  static const _carListKey = 'carList';

  @observable
  List<Car> carList = [];

  @action
  Future<void> addCar(Car car) async {
    carList.add(car);
    await _saveToPrefs();
  }

  @action
  Future<void> updateCar(Car updatedCar) async {
    final index =
    carList.indexWhere((car) => car.grnz == updatedCar.grnz);
    if (index >= 0) {
      carList[index] = updatedCar;
      await _saveToPrefs();
    }
  }

  @action
  Future<void> deleteCar(Car car) async {
    carList.removeWhere((c) => c.grnz == car.grnz);
    await _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = jsonEncode(carList);
    await prefs.setString(_carListKey, encodedList);
  }

  Future<List<Car>> _loadFromPrefs() async{
    final prefs = await SharedPreferences.getInstance();
    final carListJson = prefs.getString('carList');

    if (carListJson == null) {
      return [];
    }

    final List<dynamic> carJsonList = json.decode(carListJson);

    final List<Car> cars = carJsonList.map((carJson) => Car.fromJson(carJson)).toList();
    carList = cars;
    return cars;

  }


  @action
  Future<void> loadCars() async {
    await _loadFromPrefs();
  }
}