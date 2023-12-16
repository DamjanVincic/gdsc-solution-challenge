import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerService {
  Set<Marker> getMarkers() =>
      {
        const Marker(
          markerId: MarkerId('1'),
          position: LatLng(44.813178422472525, 20.461723719360762),
          infoWindow: InfoWindow(
            title: 'Some Title',
            snippet: 'Some Info',
          ),
        ),
        const Marker(
          markerId: MarkerId('1'),
          position: LatLng(45.813178422472525, 20.461723719360762),
          infoWindow: InfoWindow(
            title: 'Some Title2',
            snippet: 'Some Info2',
          ),
        ),
      };
}