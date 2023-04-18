/// Конструктор мен json түрлендірулеріне арналған модель
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'car.g.dart';
@JsonSerializable()
class Car {
  final String grnz;
  final String hours;
  final String price;
  final DateTime paymentTime;

  Car({required this.grnz,required this.hours,required this.paymentTime, required this.price});


  factory Car.fromJson(Map<String, dynamic> json) =>
      _$CarFromJson(json);

  Map<String, dynamic> toJson() => _$CarToJson(this);

}
