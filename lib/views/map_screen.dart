import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String title;

  const MapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final Marker locationMarker = Marker(
      markerId: const MarkerId('attendance_location'),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(title: title, snippet: '$latitude, $longitude'),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 16,
        ),
        markers: {locationMarker},
      ),
    );
  }
}
