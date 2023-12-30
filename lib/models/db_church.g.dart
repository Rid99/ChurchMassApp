// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_church.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Church _$ChurchFromJson(Map<String, dynamic> json) => Church(
      json['name'] as String,
    )
      ..id = json['id'] as String?
      ..phoneNumber = json['phoneNumber'] as String?
      ..email = json['email'] as String?
      ..address = json['address'] as String?
      ..regNo = json['regNo'] as String?
      ..location = const GeoFirePointConverter().fromJson(json['location']);

Map<String, dynamic> _$ChurchToJson(Church instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'address': instance.address,
      'regNo': instance.regNo,
      'location': _$JsonConverterToJson<dynamic, GeoFirePoint>(
          instance.location, const GeoFirePointConverter().toJson),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
