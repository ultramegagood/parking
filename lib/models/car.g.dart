// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Car _$CarFromJson(Map<String, dynamic> json) => Car(
      grnz: json['grnz'] as String,
      hours: json['hours'] as String,
      paymentTime: DateTime.parse(json['paymentTime'] as String),
      price: json['price'] as String,
    );

Map<String, dynamic> _$CarToJson(Car instance) => <String, dynamic>{
      'grnz': instance.grnz,
      'hours': instance.hours,
      'price': instance.price,
      'paymentTime': instance.paymentTime.toIso8601String(),
    };
