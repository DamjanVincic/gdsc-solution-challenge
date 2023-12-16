import 'package:flutter/material.dart';

import '../models/notification.dart';

class NotificationScreen extends StatelessWidget {
  final NotificationItem notificationItem;

  const NotificationScreen({super.key, required this.notificationItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${notificationItem.category}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Title: ${notificationItem.title}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Details: ${notificationItem.details}',
                style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
