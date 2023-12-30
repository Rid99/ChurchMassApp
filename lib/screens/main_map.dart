import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:the_churche/models/fetched_church.dart';
import 'package:the_churche/states/church_state.dart';

import '../services/geolocator.dart';
import 'detailed_view.dart';

class MainMap extends StatefulWidget {
  const MainMap({super.key});

  @override
  State<MainMap> createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  late GoogleMapController _mapController;
  LatLng? _currentLocation;
  Set<Marker> _markers = {};

  Future<void> fetchChurches() async {
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
      _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: _currentLocation!, zoom: 14.0)));

      await Churches().getChurches(LatLngLiteral.fromLatLng(_currentLocation!));

      _markers = Churches()
              .churches
              ?.map((church) => Marker(
                    markerId: MarkerId(church.name ?? ''),
                    position: church.geometry?.location.toLatLng() ?? const LatLng(0, 0),
                    infoWindow: InfoWindow(onTap: () => _markerTap(church), title: church.name),
                  ))
              .toSet() ??
          {};
      if (mounted) setState(() {});
    }
  }

  void _markerTap(FetchedChurch church) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Details(church)));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomRight, children: [
      GoogleMap(
        myLocationEnabled: true,
        mapToolbarEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(target: _currentLocation ?? const LatLng(6.917928871643926, 79.87302252562894), zoom: 11.0),
        onMapCreated: (controller) async {
          _mapController = controller;
          await fetchChurches();
        },
        markers: _markers,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () async {
            await fetchChurches();
          },
          child: const Icon(Icons.church),
        ),
      )
    ]);
  }
}
