// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mass _$MassFromJson(Map<String, dynamic> json) => Mass(
      json['id'] as String?,
      DateTime.parse(json['time'] as String),
      json['churchId'] as String,
      json['title'] as String,
      json['description'] as String?,
    );

Map<String, dynamic> _$MassToJson(Mass instance) => <String, dynamic>{
      'id': instance.id,
      'time': instance.time.toIso8601String(),
      'churchId': instance.churchId,
      'title': instance.title,
      'description': instance.description,
    };
