import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  final double lat;
  final double lng;
  final String restaurantName;

  const MapScreen({
    super.key,
    required this.lat,
    required this.lng,
    required this.restaurantName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(restaurantName), backgroundColor: Colors.green),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, lng),
          zoom: 16,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("restaurant"),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: restaurantName),
          ),
        },
      ),
    );
  }
}
