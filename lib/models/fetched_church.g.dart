// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetched_church.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchedChurch _$FetchedChurchFromJson(Map<String, dynamic> json) =>
    FetchedChurch(
      name: json['name'] as String?,
      place_id: json['place_id'] as String?,
      vicinity: json['vicinity'] as String?,
      formatted_address: json['formatted_address'] as String?,
      formatted_phone_number: json['formatted_phone_number'] as String?,
      international_phone_number: json['international_phone_number'] as String?,
      icon: json['icon'] as String?,
      icon_background_color: json['icon_background_color'] as String?,
      icon_mask_base_uri: json['icon_mask_base_uri'] as String?,
      geometry: json['geometry'] == null
          ? null
          : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => PlacePhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
      editorial_summary: json['editorial_summary'] == null
          ? null
          : PlaceEditorialSummary.fromJson(
              json['editorial_summary'] as Map<String, dynamic>),
      address_components: (json['address_components'] as List<dynamic>?)
          ?.map((e) => AddressComponent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FetchedChurchToJson(FetchedChurch instance) =>
    <String, dynamic>{
      'name': instance.name,
      'place_id': instance.place_id,
      'vicinity': instance.vicinity,
      'formatted_address': instance.formatted_address,
      'formatted_phone_number': instance.formatted_phone_number,
      'international_phone_number': instance.international_phone_number,
      'icon': instance.icon,
      'icon_background_color': instance.icon_background_color,
      'icon_mask_base_uri': instance.icon_mask_base_uri,
      'geometry': instance.geometry,
      'photos': instance.photos,
      'editorial_summary': instance.editorial_summary,
      'address_components': instance.address_components,
    };

Geometry _$GeometryFromJson(Map<String, dynamic> json) => Geometry(
      location:
          LatLngLiteral.fromJson(json['location'] as Map<String, dynamic>),
      viewport: Bounds.fromJson(json['viewport'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GeometryToJson(Geometry instance) => <String, dynamic>{
      'location': instance.location,
      'viewport': instance.viewport,
    };

LatLngLiteral _$LatLngLiteralFromJson(Map<String, dynamic> json) =>
    LatLngLiteral(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$LatLngLiteralToJson(LatLngLiteral instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };

Bounds _$BoundsFromJson(Map<String, dynamic> json) => Bounds(
      northeast:
          LatLngLiteral.fromJson(json['northeast'] as Map<String, dynamic>),
      southwest:
          LatLngLiteral.fromJson(json['southwest'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BoundsToJson(Bounds instance) => <String, dynamic>{
      'northeast': instance.northeast,
      'southwest': instance.southwest,
    };

PlacePhoto _$PlacePhotoFromJson(Map<String, dynamic> json) => PlacePhoto(
      height: (json['height'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      photo_reference: json['photo_reference'] as String,
    );

Map<String, dynamic> _$PlacePhotoToJson(PlacePhoto instance) =>
    <String, dynamic>{
      'height': instance.height,
      'width': instance.width,
      'photo_reference': instance.photo_reference,
    };

PlaceEditorialSummary _$PlaceEditorialSummaryFromJson(
        Map<String, dynamic> json) =>
    PlaceEditorialSummary(
      language: json['language'] as String?,
      overview: json['overview'] as String?,
    );

Map<String, dynamic> _$PlaceEditorialSummaryToJson(
        PlaceEditorialSummary instance) =>
    <String, dynamic>{
      'language': instance.language,
      'overview': instance.overview,
    };

AddressComponent _$AddressComponentFromJson(Map<String, dynamic> json) =>
    AddressComponent(
      long_name: json['long_name'] as String,
      short_name: json['short_name'] as String,
    );

Map<String, dynamic> _$AddressComponentToJson(AddressComponent instance) =>
    <String, dynamic>{
      'long_name': instance.long_name,
      'short_name': instance.short_name,
    };
