import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' hide PermissionStatus;
import 'package:permission_handler/permission_handler.dart';

class MapsView extends StatefulWidget {
  const MapsView({super.key});

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  late GoogleMapController _mapController;
  final LatLng _center = const LatLng(44.813178422472525, 20.461723719360762);

  late Future<PermissionStatus> _locationPermissionStatus;
  LocationData? _currentLocation;

  Future<PermissionStatus> getPermissionStatus() async {
    PermissionStatus status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
    }
    if (status.isGranted) {
      getCurrentLocation();
    }
    return status;
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
                return GoogleMap(
                  onMapCreated: (controller) => _mapController = controller,
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation != null
                        ? LatLng(_currentLocation!.latitude!,
                            _currentLocation!.longitude!)
                        : _center,
                    zoom: 11.0,
                  ),
                  myLocationEnabled: true,
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
