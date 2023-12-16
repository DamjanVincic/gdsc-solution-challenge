import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../models/map_marker.dart';

class MapMarkerService {
  final String baseUrl = "https://actualizer-fb7e8-default-rtdb.europe-west1.firebasedatabase.app";
  final String notificationsEndpoint = "/markers.json";

  void uploadMapMarker(double latitude, double longitude, String title, String snippet) async {
    MapMarker mapMarker = MapMarker(id: DateTime.now().toString(), latitude: latitude, longitude: latitude, title: title, snippet: snippet);
    final String firebaseUrl = '$baseUrl$notificationsEndpoint';

    try {
      final response = await http.post(
        Uri.parse(firebaseUrl),
        headers: {
          'Content-Type': 'application/json'
        },
        body: json.encode(mapMarker.toMap()),
      );

      if (response.statusCode == 200) {
        print('Marker added successfully.');
      } else {
        print('Failed to add marker. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<Set<Marker>> fetchMapMarkers() async {
    final String firebaseUrl = '$baseUrl$notificationsEndpoint';
    try {
      final response = await http.get(Uri.parse(firebaseUrl));
      if (response.statusCode == 200) {
        Set<Marker> items = {};
        final data = List.from(json.decode(response.body).values);
        for (var item in data) {
          print(item);
          items.add(Marker(
              markerId: MarkerId(item['id']),
              position: LatLng(item['latitude'], item['longitude']),
              infoWindow: InfoWindow(
                title: item['title'],
                snippet: item['snippet']
            )));
        }
        return items;
      } else {
        print('Failed to fetch map markers. Status Code: ${response.statusCode}');
        return {};
      }
    } catch (error) {
      print('Error: $error');
      return {};
    }
  }

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