import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:json_annotation/json_annotation.dart';

part 'db_church.g.dart';

@JsonSerializable()
class Church {
  Church(
    this.name,
  );

  Church.form(this.name, this.phoneNumber, this.email, this.address, this.regNo, this.location);

  String? id;
  String name;
  String? phoneNumber;
  String? email;
  String? address;
  String? regNo;
  // @JsonKey(fromJson: fromJsonGeoPoint, toJson: toJsonGeoPoint)
  @GeoFirePointConverter()
  GeoFirePoint? location;

  factory Church.fromJson(Map<String, dynamic> json) => _$ChurchFromJson(json);
  Map<String, dynamic> toJson() => _$ChurchToJson(this);

  // static GeoPoint? fromJsonGeoPoint(Map<String, dynamic> geoPoint) {
  //   return GeoPoint(geoPoint["latitude"] ?? 0.0000, geoPoint["longitude"] ?? 0.0000);
  // }

  // static GeoPoint? toJsonGeoPoint(GeoPoint? geoPoint) {
  //   return geoPoint;
  // }
}

// @JsonSerializable()
// class GeoPoint {
//   double latitude;
//   double longitude;

//   GeoPoint(this.latitude, this.longitude);

//   factory GeoPoint.fromJson(Map<String, dynamic> json) => _$GeoPointFromJson(json);
//   Map<String, dynamic> toJson() => _$GeoPointToJson(this);
// }

class GeoFirePointConverter implements JsonConverter<GeoFirePoint, dynamic> {
  const GeoFirePointConverter();

  @override
  GeoFirePoint fromJson(dynamic geoPoint) {
    GeoPoint g = geoPoint['geopoint'];
    return GeoFirePoint(g.latitude, g.longitude);
  }

  @override
  dynamic toJson(GeoFirePoint geoPoint) => geoPoint.data;
}

// class GeoFirePoint {
//   String geohash;
//   GeoPoint geoPoint;

//   GeoFirePoint(this.geoPoint, this.geohash);
// }
