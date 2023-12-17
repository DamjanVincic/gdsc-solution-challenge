import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' hide PermissionStatus;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

import '../services/map_marker_service.dart';

class MapsView extends StatefulWidget {
  const MapsView({super.key, required this.mapMarkerService});

  final MapMarkerService mapMarkerService;

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  String? _mapStyle;
  late GoogleMapController _mapController;
  final LatLng _center = const LatLng(44.813178422472525, 20.461723719360762);
  late Future<Set<Marker>> _markers; // Fetch markers

  late Future<PermissionStatus> _locationPermissionStatus;
  LocationData? _currentLocation;

  Future<PermissionStatus> getPermissionStatus() async {
    if (Platform.isAndroid || Platform.isIOS) {
      // Check if the platform is Android or iOS
      PermissionStatus status = await Permission.location.status;
      if (!status.isGranted) {
        status = await Permission.location.request();
      }
      if (status.isGranted) {
        getCurrentLocation();
      }
      return status;
    } else {
      // If the platform is not Android or iOS, return PermissionStatus.granted
      return PermissionStatus.granted;
    }
  }

  Future<void> getCurrentLocation() async {
    Location location = Location();
    try {
      _currentLocation = await location.getLocation();
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              _currentLocation!.latitude!,
              _currentLocation!.longitude!,
            ),
            zoom: 15.0,
          ),
        ),
      );
    } catch (e) {
      _currentLocation = null;
    }
  }

  @override
  void initState() {
    super.initState();
    _locationPermissionStatus = getPermissionStatus();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    _markers = widget.mapMarkerService.fetchMapMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _locationPermissionStatus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData) {
              final status = snapshot.data!;
              if (status == PermissionStatus.granted) {
                return FutureBuilder(
                  future: _markers,
                  builder: (context, markerSnapshot) {
                    if (markerSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (markerSnapshot.hasData) {
                        return GoogleMap(
                          onMapCreated: (controller) {
                            _mapController = controller;
                            _mapController.setMapStyle(_mapStyle);
                          },
                          initialCameraPosition: CameraPosition(
                            target: _currentLocation != null
                                ? LatLng(_currentLocation!.latitude!,
                                _currentLocation!.longitude!)
                                : _center,
                            zoom: 11.0,
                          ),
                          myLocationEnabled: true,
                          markers: markerSnapshot.data!,
                        );
                      } else if (markerSnapshot.hasError) {
                        return Center(child: Text('Error: ${markerSnapshot.error}'));
                      } else {
                        return const Center(child: Text('Unknown error.'));
                      }
                    }
                  }
                );
              } else {
                return const Center(child: Text('Permission denied'));
              }
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return const Center(child: Text('Unknown error.'));
            }
          }
        });
  }
}
