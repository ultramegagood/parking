// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CarStore on _CarStore, Store {
  late final _$carListAtom = Atom(name: '_CarStore.carList', context: context);

  @override
  List<Car> get carList {
    _$carListAtom.reportRead();
    return super.carList;
  }

  @override
  set carList(List<Car> value) {
    _$carListAtom.reportWrite(value, super.carList, () {
      super.carList = value;
    });
  }

  late final _$addCarAsyncAction =
      AsyncAction('_CarStore.addCar', context: context);

  @override
  Future<void> addCar(Car car) {
    return _$addCarAsyncAction.run(() => super.addCar(car));
  }

  late final _$updateCarAsyncAction =
      AsyncAction('_CarStore.updateCar', context: context);

  @override
  Future<void> updateCar(Car updatedCar) {
    return _$updateCarAsyncAction.run(() => super.updateCar(updatedCar));
  }

  late final _$deleteCarAsyncAction =
      AsyncAction('_CarStore.deleteCar', context: context);

  @override
  Future<void> deleteCar(Car car) {
    return _$deleteCarAsyncAction.run(() => super.deleteCar(car));
  }

  late final _$loadCarsAsyncAction =
      AsyncAction('_CarStore.loadCars', context: context);

  @override
  Future<void> loadCars() {
    return _$loadCarsAsyncAction.run(() => super.loadCars());
  }

  @override
  String toString() {
    return '''
carList: ${carList}
    ''';
  }
}
