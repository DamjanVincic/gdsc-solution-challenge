import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapsView extends StatefulWidget {
  const MapsView({super.key});

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);

  late Future<PermissionStatus> _locationPermissionStatus;

  Future<PermissionStatus> getPermissionStatus() async {
    PermissionStatus status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
    }
    return status;
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
                  onMapCreated: (controller) => mapController = controller,
                  initialCameraPosition: CameraPosition(
                    target: _center,
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
