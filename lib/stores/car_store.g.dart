// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CarStore on _CarStore, Store {
  late final _$grnzAtom = Atom(name: '_CarStore.grnz', context: context);

  @override
  String get grnz {
    _$grnzAtom.reportRead();
    return super.grnz;
  }

  @override
  set grnz(String value) {
    _$grnzAtom.reportWrite(value, super.grnz, () {
      super.grnz = value;
    });
  }

  late final _$hourAtom = Atom(name: '_CarStore.hour', context: context);

  @override
  String get hour {
    _$hourAtom.reportRead();
    return super.hour;
  }

  @override
  set hour(String value) {
    _$hourAtom.reportWrite(value, super.hour, () {
      super.hour = value;
    });
  }

  late final _$priceAtom = Atom(name: '_CarStore.price', context: context);

  @override
  int get price {
    _$priceAtom.reportRead();
    return super.price;
  }

  @override
  set price(int value) {
    _$priceAtom.reportWrite(value, super.price, () {
      super.price = value;
    });
  }

  late final _$paymentTimeAtom =
      Atom(name: '_CarStore.paymentTime', context: context);

  @override
  DateTime get paymentTime {
    _$paymentTimeAtom.reportRead();
    return super.paymentTime;
  }

  @override
  set paymentTime(DateTime value) {
    _$paymentTimeAtom.reportWrite(value, super.paymentTime, () {
      super.paymentTime = value;
    });
  }

  late final _$carsAtom = Atom(name: '_CarStore.cars', context: context);

  @override
  ObservableList<Car> get cars {
    _$carsAtom.reportRead();
    return super.cars;
  }

  @override
  set cars(ObservableList<Car> value) {
    _$carsAtom.reportWrite(value, super.cars, () {
      super.cars = value;
    });
  }

  late final _$addCarAsyncAction =
      AsyncAction('_CarStore.addCar', context: context);

  @override
  Future<void> addCar() {
    return _$addCarAsyncAction.run(() => super.addCar());
  }

  late final _$deleteCarAsyncAction =
      AsyncAction('_CarStore.deleteCar', context: context);

  @override
  Future<void> deleteCar(int index) {
    return _$deleteCarAsyncAction.run(() => super.deleteCar(index));
  }

  @override
  String toString() {
    return '''
grnz: ${grnz},
hour: ${hour},
price: ${price},
paymentTime: ${paymentTime},
cars: ${cars}
    ''';
  }
}
