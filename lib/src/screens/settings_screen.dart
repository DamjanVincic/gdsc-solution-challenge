import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../services/quote_service.dart';
import '../services/map_marker_service.dart';

class SettingsScreen extends StatefulWidget {
  final NotificationService notificationService;
  final QuoteService quoteService;
  final MapMarkerService mapMarkerService;

  const SettingsScreen({
    Key? key,
    required this.notificationService,
    required this.quoteService,
    required this.mapMarkerService,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotificationScheduled = false;

  @override
  void initState() {
    super.initState();
    isNotificationScheduled = false;
  }

  void toggleNotification() {
    setState(() {
      if (isNotificationScheduled) {
        widget.notificationService.cancelScheduledNotifications();
      } else {
        widget.notificationService.scheduleNotification();
      }
      isNotificationScheduled = !isNotificationScheduled;
    });
  }

  Future<void> _showQuoteDialog(BuildContext context) async {
    TextEditingController categoryController = TextEditingController();
    TextEditingController titleController = TextEditingController();
    TextEditingController detailsController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Upload a new quote"),
          content: Column(
            children: [
              const SizedBox(height: 16),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: detailsController,
                decoration: const InputDecoration(labelText: 'Details'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                widget.quoteService.uploadQuote(categoryController.text, titleController.text, detailsController.text);
                Navigator.of(context).pop();
              },
              child: const Text("Upload"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMapMarkerDialog(BuildContext context) async {
    TextEditingController mapMarkerLatitudeController = TextEditingController();
    TextEditingController mapMarkerLongitudeController = TextEditingController();
    TextEditingController mapMarkerTitleController = TextEditingController();
    TextEditingController mapMarkerSnippetController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Upload a new map marker"),
          content: Column(
            children: [
              TextField(
                controller: mapMarkerLatitudeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Latitude'),
              ),
              TextField(
                controller: mapMarkerLongitudeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Longitude'),
              ),
              TextField(
                controller: mapMarkerTitleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: mapMarkerSnippetController,
                decoration: const InputDecoration(labelText: 'Snippet'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                double latitude = double.parse(mapMarkerLatitudeController.text);
                double longitude = double.parse(mapMarkerLongitudeController.text);
                widget.mapMarkerService.uploadMapMarker(latitude, longitude, mapMarkerTitleController.text, mapMarkerSnippetController.text);
                Navigator.of(context).pop();
              },
              child: const Text("Upload"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white70,
      ),
      body: Container(
        color: Colors.white38,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Notifications settings: ",
              style: TextStyle(fontSize: 20, color: Colors.black),),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                const Text(
                "Receiving Notifications",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
                const SizedBox(width: 20,),
                Switch(
                value: isNotificationScheduled,
                onChanged: (value) {
                  setState(() {
                    isNotificationScheduled = value;
                    if (isNotificationScheduled) {
                      widget.notificationService.scheduleNotification();
                    } else {
                      widget.notificationService.cancelScheduledNotifications();
                    }
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
                inactiveTrackColor: Colors.red,
                inactiveThumbColor: Colors.redAccent,
                materialTapTargetSize: MaterialTapTargetSize.padded,
              ),],),
              const SizedBox(height: 20,),
              Text("Admin: ",
                style: TextStyle(fontSize: 20, color: Colors.black),),

              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () => _showQuoteDialog(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black87, backgroundColor: Colors.white70,
                  ),
                  child: const Text('Create Quote'),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () => _showMapMarkerDialog(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black87, backgroundColor: Colors.white70,
                  ),
                  child: const Text('Create Map Marker'),
                ),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}