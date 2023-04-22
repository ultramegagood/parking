/// Конструктор мен json түрлендірулеріне арналған модель
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'car.g.dart';
@JsonSerializable()
class Car {
  final String grnz;
  final String id;
  final String hours;
  final String numberPlace;
  final String price;
  final DateTime purchaseTime;


  Car({required this.id,required this.purchaseTime,required this.grnz,required this.hours, required this.numberPlace,required this.price});


  factory Car.fromJson(Map<String, dynamic> json) =>
      _$CarFromJson(json);

  Map<String, dynamic> toJson() => _$CarToJson(this);

}
