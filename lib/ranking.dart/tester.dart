import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);

    return Scaffold(
      body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _pGooglePlex,
            zoom: 13,
          ),
         ),
    );
  }
}
