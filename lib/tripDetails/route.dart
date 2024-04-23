// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';

// class MapsScreen extends StatefulWidget {
//   @override
//   _MapsScreenState createState() => _MapsScreenState();
// }

// class _MapsScreenState extends State<MapsScreen> {
//   late GoogleMapController controller;
//   final Set<Marker> _markers = {};

//   @override
//   void initState() {
//     super.initState();
//     _addMarkers();
//     _calculateDistance();
//   }

//   void _addMarkers() {
//     // Add markers for the two points on the map
//     _markers.add(
//       Marker(
//         markerId: MarkerId('point1'),
//         position: LatLng(37.7749, -122.4194), // Point 1 coordinates
//         infoWindow: InfoWindow(title: 'Point 1'),
//       ),
//     );

//     _markers.add(
//       Marker(
//         markerId: MarkerId('point2'),
//         position: LatLng(37.7749, -122.4294), // Point 2 coordinates
//         infoWindow: InfoWindow(title: 'Point 2'),
//       ),
//     );
//   }

//   void _calculateDistance() async {
//     // Calculate the distance between two points
//     double distanceInMeters = await Geolocator.distanceBetween(
//       37.7749, -122.4194, // Point 1 coordinates
//       37.7749, -122.4294, // Point 2 coordinates
//     );

//     print('Distance: ${distanceInMeters / 1000} km');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google Maps Example'),
//       ),
//       body: GoogleMap(
//         onMapCreated: (GoogleMapController controller) {
//           controller = controller;
//         },
//         initialCameraPosition: CameraPosition(
//           target: LatLng(37.7749, -122.4194), // Initial map position
//           zoom: 12.0,
//         ),
//         markers: _markers,
//       ),
//     );
//   }
// }


