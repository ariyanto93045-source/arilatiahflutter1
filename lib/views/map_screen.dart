import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String title;

  static const double ppkdLatitude = -6.2114;
  static const double ppkdLongitude = 106.8189;

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
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // Blue marker for the check-in point
    );

    final Marker ppkdMarker = const Marker(
      markerId: MarkerId('ppkd_location'),
      position: LatLng(ppkdLatitude, ppkdLongitude),
      infoWindow: InfoWindow(
        title: "PPKD Jakarta Pusat",
        snippet: "Jl. Karet Pasar Baru Barat V No. 23, Karet Tengsin, Tanah Abang",
      ),
    );

    final Circle ppkdGeofence = Circle(
      circleId: const CircleId('ppkd_radius'),
      center: const LatLng(ppkdLatitude, ppkdLongitude),
      radius: 100, // 100 meters geofence radius
      fillColor: Colors.blue.withOpacity(0.15),
      strokeColor: Colors.blue.shade700,
      strokeWidth: 2,
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
          zoom: 16.5,
        ),
        markers: {locationMarker, ppkdMarker},
        circles: {ppkdGeofence},
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
      ),
    );
  }
}
