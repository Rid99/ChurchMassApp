import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:the_churche/models/db_church.dart';
import 'package:the_churche/models/fetched_church.dart';
import 'package:http/http.dart' as http;

class Churches {
  static Churches? _instance;

  Churches._internal() {
    _instance = this;
  }

  factory Churches() => _instance ?? Churches._internal();

  List<FetchedChurch>? _churches;
  LatLngLiteral? _location;
  int range = 1000;

  List<FetchedChurch>? get churches => _churches;

  Future<void> getChurches(LatLngLiteral currentLocation) async {
    // if (_location == currentLocation) return;

    _location = currentLocation;
    range = 1000;

    await _getChurches();
    await _getChurchesFromDb();
  }

  Future<void> _getChurches() async {
    Map<String, dynamic>? params = {
      // 'keyword': 'church',
      'location': '${_location!.lat},${_location!.lng}',
      'radius': range.toString(),
      'type': 'church',
      'key': 'AIzaSyBmobQB7cfd7KvpQpPo8vyumWAIz9bBRFI'
    };

    var uri = Uri.https('maps.googleapis.com', '/maps/api/place/nearbysearch/json', params);

    // debugPrint(uri.toString());

    var response = jsonDecode(await http.get(uri).then((res) => res.body));

    if (response['status'] == 'OK') {
      _churches = (response['results'] as List<dynamic>).map((church) => FetchedChurch.fromJson(church as Map<String, dynamic>)).toList();
      return;
    }

    if (range >= 8000) {
      return;
    }

    if (response['status'] == 'ZERO_RESULTS') {
      range *= 2;
      await _getChurches();
      return;
    }
  }

  Future<void> _getChurchesFromDb() async {
    GeoFireCollectionRef geoRef = GeoFlutterFire().collection(collectionRef: FirebaseFirestore.instance.collection('users'));
    var doc = await geoRef.within(center: GeoFirePoint(_location!.lat, _location!.lng), radius: range / 1000, field: 'location', strictMode: true).first;

    for (var element in doc) {
      var x = Church.fromJson(element.data() as Map<String, dynamic>);
      _churches?.add(FetchedChurch(
          name: x.name, place_id: element.id, geometry: Geometry(location: LatLngLiteral(lat: x.location!.latitude, lng: x.location!.longitude))));
    }
  }
}
 
 
 
 
  //  await doc.listen((List<DocumentSnapshot> documentList) {
  //     // print(documentList[1].data());
  //     // doSomething()
  //     for (var element in documentList) {
  //       print('hi');
  //       var x = Church.fromJson(element.data() as Map<String, dynamic>);
  //       print(x.toString());
  //       _churches?.add(FetchedChurch(name: x.name, geometry: Geometry(location: LatLngLiteral(lat: x.location!.latitude, lng: x.location!.longitude))));
  //     }

//       print(_churches.toString());
//     });
//   }
// }
