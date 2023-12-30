// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:the_churche/models/fetched_church.dart';
// import 'package:the_churche/screens/detailed_view.dart';

// import '../screens/churches.dart';

// class PlaceAPI {
//   static Future<Set<Marker>> getChurches(LatLng currentLocation, Function(dynamic church) action) async {

//     return Set<Marker>.from(churches
//         .map((church) => Marker(
//               markerId: MarkerId(church['name']),
//               position: LatLng(church['geometry']['location']['lat'], church['geometry']['location']['lng']),
//               infoWindow: InfoWindow(
//                   onTap: () {
//                     action(church);
//                   },
//                   title: church['name']),
//             ))
//         .toSet());
//     // }
//   }
// }
