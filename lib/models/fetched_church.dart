import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fetched_church.g.dart';

@JsonSerializable()
class FetchedChurch {
  String? name, place_id, vicinity, formatted_address, formatted_phone_number, international_phone_number, icon, icon_background_color, icon_mask_base_uri;
  Geometry? geometry;
  List<PlacePhoto>? photos;
  PlaceEditorialSummary? editorial_summary;
  List<AddressComponent>? address_components;

  FetchedChurch(
      {this.name,
      this.place_id,
      this.vicinity,
      this.formatted_address,
      this.formatted_phone_number,
      this.international_phone_number,
      this.icon,
      this.icon_background_color,
      this.icon_mask_base_uri,
      this.geometry,
      this.photos,
      this.editorial_summary,
      this.address_components});

  factory FetchedChurch.fromJson(Map<String, dynamic> json) => _$FetchedChurchFromJson(json);
  Map<String, dynamic> toJson() => _$FetchedChurchToJson(this);
}

@JsonSerializable()
class Geometry {
  LatLngLiteral location;
  Bounds? viewport;

  Geometry({required this.location, this.viewport});

  factory Geometry.fromJson(Map<String, dynamic> json) => _$GeometryFromJson(json);
  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}

@JsonSerializable()
class LatLngLiteral {
  double lat;
  double lng;

  LatLngLiteral({required this.lat, required this.lng});

  factory LatLngLiteral.fromJson(Map<String, dynamic> json) => _$LatLngLiteralFromJson(json);
  Map<String, dynamic> toJson() => _$LatLngLiteralToJson(this);

  factory LatLngLiteral.fromLatLng(LatLng location) => LatLngLiteral(lat: location.latitude, lng: location.longitude);
  LatLng toLatLng() => LatLng(lat, lng);

  @override
  bool operator ==(Object other) {
    if (other is LatLngLiteral) {
      return (lat == other.lat && lng == other.lng);
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(lat, lng);
}

@JsonSerializable()
class Bounds {
  LatLngLiteral northeast;
  LatLngLiteral southwest;

  Bounds({required this.northeast, required this.southwest});

  factory Bounds.fromJson(Map<String, dynamic> json) => _$BoundsFromJson(json);
  Map<String, dynamic> toJson() => _$BoundsToJson(this);
}

@JsonSerializable()
class PlacePhoto {
  double height;
  double width;
  String photo_reference;

  PlacePhoto({required this.height, required this.width, required this.photo_reference});

  factory PlacePhoto.fromJson(Map<String, dynamic> json) => _$PlacePhotoFromJson(json);
  Map<String, dynamic> toJson() => _$PlacePhotoToJson(this);
}

@JsonSerializable()
class PlaceEditorialSummary {
  String? language;
  String? overview;

  PlaceEditorialSummary({this.language, this.overview});

  factory PlaceEditorialSummary.fromJson(Map<String, dynamic> json) => _$PlaceEditorialSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceEditorialSummaryToJson(this);
}

@JsonSerializable()
class AddressComponent {
  String long_name;
  String short_name;

  AddressComponent({required this.long_name, required this.short_name});

  factory AddressComponent.fromJson(Map<String, dynamic> json) => _$AddressComponentFromJson(json);
  Map<String, dynamic> toJson() => _$AddressComponentToJson(this);
}
