import 'package:flutter/material.dart';
import '../repository/settings_repository.dart';
import '../services/map_marker_service.dart';
import '../services/notification_service.dart';
import '../services/quote_service.dart';
import 'package:Actualizator/src/services/self_examination_service.dart';
import 'package:Actualizator/main.dart';

class SettingsScreen extends StatefulWidget {
  final NotificationService notificationService;
  final QuoteService quoteService;
  final MapMarkerService mapMarkerService;
  final SettingsRepository settingsRepository;

  const SettingsScreen({
    Key? key,
    required this.notificationService,
    required this.quoteService,
    required this.mapMarkerService,
    required this.settingsRepository
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isQuoteNotificationScheduled = false;
  bool isGratitudeNotificationScheduled = false;

  @override
  void initState() {
    super.initState();
    isQuoteNotificationScheduled = false;
    isGratitudeNotificationScheduled = false;
  }

  void toggleQuoteNotification() {
    setState(() {
      if (isQuoteNotificationScheduled) {
        widget.notificationService.cancelQuoteNotifications();
      } else {
        widget.notificationService.scheduleQuoteNotification();
      }
      isQuoteNotificationScheduled = !isQuoteNotificationScheduled;
    });
  }

  void toggleGratitudeNotification() {
    setState(() {
      if (isGratitudeNotificationScheduled) {
        widget.notificationService.cancelGratitudeNotifications();
      } else {
        widget.notificationService.scheduleGratitudeNotification();
      }
      isGratitudeNotificationScheduled = !isGratitudeNotificationScheduled;
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
            mainAxisSize: MainAxisSize.min,
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
                widget.quoteService.uploadQuote(categoryController.text,
                    titleController.text, detailsController.text);
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
    TextEditingController mapMarkerLongitudeController =
    TextEditingController();
    TextEditingController mapMarkerTitleController = TextEditingController();
    TextEditingController mapMarkerSnippetController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Upload a new map marker"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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
                double latitude =
                double.parse(mapMarkerLatitudeController.text);
                double longitude =
                double.parse(mapMarkerLongitudeController.text);
                widget.mapMarkerService.uploadMapMarker(
                    latitude,
                    longitude,
                    mapMarkerTitleController.text,
                    mapMarkerSnippetController.text);
                Navigator.of(context).pop();
              },
              child: const Text("Upload"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showQuoteTimePicker(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );

    if (selectedTime != null) {
      DateTime selectedDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        selectedTime.hour,
        selectedTime.minute,
      );
      await widget.settingsRepository.saveQuoteDateTime(selectedDateTime);
    }
  }

  Future<void> _showDiaryTimePicker(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );

    if (selectedTime != null) {
      DateTime selectedDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        selectedTime.hour,
        selectedTime.minute,
      );
      await widget.settingsRepository.saveDiaryDateTime(selectedDateTime);
    }
  }

  Future<void> _showNotification(BuildContext context) async {
    SelfExaminationService selfExaminationService = SelfExaminationService();
    List<String> goals = await selfExaminationService.getTodayExaminations();
    for (String goal in goals) {
      await widget.notificationService.showExaminationNotification(goal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text(
                  "Quote Notifications: ",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(width: 20),
                Switch(
                  value: isQuoteNotificationScheduled,
                  onChanged: (value) {
                    toggleQuoteNotification();
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                  inactiveTrackColor: Colors.red,
                  inactiveThumbColor: Colors.redAccent,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _showQuoteTimePicker(context),
              child: const Text('Set quote time'),
            ),
            ElevatedButton(
              onPressed: () => _showQuoteDialog(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
                primary: Colors.white70,
              ),
              child: const Text('Create Quote'),
            ),
            ElevatedButton(
              onPressed: () => _showMapMarkerDialog(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
                primary: Colors.white70,
              ),
              child: const Text('Create Map Marker'),
            ),
            ElevatedButton(
              onPressed: () => _showNotification(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
                primary: Colors.white70,
              ),
              child: const Text('Self Examination Notification'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  "Gratitude notifications: ",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(width: 20),
                Switch(
                  value: isGratitudeNotificationScheduled,
                  onChanged: (value) {
                    toggleGratitudeNotification();
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                  inactiveTrackColor: Colors.red,
                  inactiveThumbColor: Colors.redAccent,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _showDiaryTimePicker(context),
              child: const Text('Set gratitude time'),
            )
          ],
        ),
      ),
    );
  }
}
