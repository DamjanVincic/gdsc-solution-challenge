import 'dart:core';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/notification.dart';
import '../../firebase_options.dart';

class FirebaseService {
  late DatabaseReference ref;

  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    ref = FirebaseDatabase.instance.ref("notifications");
  }

  Future<void> pushNotification(String category, String text) async {
    // Create an instance of the Item class
    NotificationItem newItem = NotificationItem(category: category, text: text);
    ref.child('notifications').push().set(newItem.toMap());
  }

  Future<void> getNotifications() async {

  }
}
