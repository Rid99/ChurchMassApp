import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  static final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  static Future<LatLng> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(1); //'Location services are disabled.'
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(2); // 'Location permissions are denied'
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(2); // 'Location permissions are permanently denied, we cannot request permissions.'
    }

    return Geolocator.getCurrentPosition().then((value) => LatLng(value.latitude, value.longitude));
  }

  // static Future<LatLng> getLocation() async {
  //   final hasPermission = await _handlePermission();

  //   if (!hasPermission) {
  //     return await getLastKnownPosition();
  //   }

  //   final position = await _geolocatorPlatform.getCurrentPosition();
  //   return LatLng(position.latitude, position.longitude);
  // }

  // static Future<bool> _handlePermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Test if location services are enabled.
  //   serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     _openLocationSettings();
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     return false;
  //   }

  //   permission = await _geolocatorPlatform.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await _geolocatorPlatform.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       _openAppSettings();
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       return false;
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return false;
  //   }

  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   return true;
  // }

  // static Future<LatLng> getLastKnownPosition() async {
  //   final position = await _geolocatorPlatform.getLastKnownPosition();
  //   if (position != null) {
  //     return LatLng(position.latitude, position.longitude);
  //   } else {
  //     return const LatLng(6.9315, 79.8643);
  //     // return const LatLng(7.068259412060787, 79.9059515636504);
  //   }
  // }

  // static void _openAppSettings() async {
  //   final opened = await _geolocatorPlatform.openAppSettings();
  //   String displayValue;

  //   if (opened) {
  //     displayValue = 'Opened Application Settings.';
  //   } else {
  //     displayValue = 'Error opening Application Settings.';
  //   }
  // }

  // static void _openLocationSettings() async {
  //   final opened = await _geolocatorPlatform.openLocationSettings();
  //   String displayValue;

  //   if (opened) {
  //     displayValue = 'Opened Location Settings';
  //   } else {
  //     displayValue = 'Error opening Location Settings';
  //   }
  // }
}
