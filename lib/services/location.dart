// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// Location location = Location();

// late bool _serviceEnabled;
// late PermissionStatus _permissionGranted;
// late LocationData _locationData;

// Future<LatLng> getLocation() async {
//   _serviceEnabled = await location.serviceEnabled();
//   if (!_serviceEnabled) {
//     _serviceEnabled = await location.requestService();
//     if (!_serviceEnabled) {
//       return const LatLng(6.9315, 79.8643);
//     }
//   }

//   _permissionGranted = await location.hasPermission();
//   if (_permissionGranted == PermissionStatus.denied) {
//     _permissionGranted = await location.requestPermission();
//     if (_permissionGranted != PermissionStatus.granted) {
//       return const LatLng(6.9315, 79.8643);
//     }
//   }

//   _locationData = await location.getLocation();

//   return LatLng(_locationData.latitude!, _locationData.longitude!);
// }
