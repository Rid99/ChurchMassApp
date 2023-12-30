import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mass.g.dart';

@JsonSerializable()
class Mass {
  // Mass(this.id, this.time, this.churchId, this.title, this.description, this.organizer);
  Mass(this.id, this.time, this.churchId, this.title, this.description);

  String? id;
  DateTime time;
  String churchId;
  String title;
  String? description;
  String? organizer;

  factory Mass.fromJson(Map<String, dynamic> json) => _$MassFromJson(json);
  Map<String, dynamic> toJson() => _$MassToJson(this);

  factory Mass.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    // return Mass(data?['id'], data?['time'], data?['churchId'], data?['title'], data?['description'], data?['organizer']);
    return Mass(data?['id'], data?['time'], data?['churchId'], data?['title'], data?['description']);
  }
}
