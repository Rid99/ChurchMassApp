import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/geolocator.dart';

class LocationSelector extends StatefulWidget {
  const LocationSelector(this.onLocationChanged, {this.oldLoc, super.key});

  final ValueChanged<LatLng> onLocationChanged;
  final LatLng? oldLoc;

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  late GoogleMapController _mapController;
  LatLng? _currentLocation;

  Future<void> locate() async {
    await LocationService.getLocation().then((value) {
      _currentLocation = value;
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(error as int == 1
          ? SnackBar(
              content: const Text('Location services are disabled.'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Open Location Settings',
                onPressed: () async {
                  await Geolocator.openLocationSettings();
                },
              ),
            )
          : SnackBar(
              content: const Text('Location permissions are denied'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Open App Settings',
                onPressed: () async {
                  await Geolocator.openAppSettings();
                },
              ),
            ));
      _currentLocation = null;
    });

    if (mounted && _currentLocation != null) {
      _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: _currentLocation!, zoom: 16.0)));
    }
  }

  @override
  void initState() {
    _currentLocation = widget.oldLoc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomRight, children: [
      GoogleMap(
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        },
        myLocationEnabled: true,
        mapToolbarEnabled: false,
        zoomControlsEnabled: false,
        onCameraMove: (position) {
          _currentLocation = position.target;
        },
        onCameraIdle: () {
          widget.onLocationChanged(_currentLocation ?? const LatLng(6.917928871643926, 79.87302252562894));
        },
        initialCameraPosition: CameraPosition(target: _currentLocation ?? const LatLng(6.917928871643926, 79.87302252562894), zoom: 11.0),
        onMapCreated: (controller) async {
          _mapController = controller;
          if (_currentLocation != null) {
            _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: _currentLocation!, zoom: 14.0)));
            return;
          }
          await locate();
        },
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton.filledTonal(
          onPressed: () async {
            await locate();
          },
          tooltip: 'Current Location',
          icon: const Icon(Icons.my_location),
        ),
      ),
      const Align(
        alignment: Alignment(0, -0.05),
        child: Icon(
          Icons.location_pin,
          color: Colors.red,
          size: 40,
        ),
      )
    ]);
  }
}
