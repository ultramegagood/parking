// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Car _$CarFromJson(Map<String, dynamic> json) => Car(
      id: json['id'] as String,
      purchaseTime: DateTime.parse(json['purchaseTime'] as String),
      grnz: json['grnz'] as String,
      hours: json['hours'] as String,
      numberPlace: json['numberPlace'] as String,
      price: json['price'] as String,
    );

Map<String, dynamic> _$CarToJson(Car instance) => <String, dynamic>{
      'grnz': instance.grnz,
      'id': instance.id,
      'hours': instance.hours,
      'numberPlace': instance.numberPlace,
      'price': instance.price,
      'purchaseTime': instance.purchaseTime.toIso8601String(),
    };
