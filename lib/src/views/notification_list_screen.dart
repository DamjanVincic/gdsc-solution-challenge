import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../services/firebase_service.dart';
import 'notification_screen.dart';

class NotificationListScreen extends StatefulWidget {
  final FirebaseService firebaseService;

  const NotificationListScreen({Key? key, required this.firebaseService}) : super(key: key);

  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  late List<NotificationItem> notifications;
  String selectedCategory = 'All'; // Default category is 'All'

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Fetch notifications asynchronously
    notifications = await widget.firebaseService.fetchNotifications();
    // Call setState to rebuild the widget with the new data
    setState(() {});
  }

  List<String> getUniqueCategories() {
    // Get unique categories from the list of notifications
    Set<String> uniqueCategories = notifications.map((item) => item.category).toSet();
    return ['All', ...uniqueCategories.toList()];
  }

  List<NotificationItem> getFilteredNotifications() {
    // Filter notifications based on the selected category
    if (selectedCategory == 'All') {
      return notifications;
    } else {
      return notifications.where((item) => item.category == selectedCategory).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          // DropdownButton for selecting categories
          DropdownButton<String>(
            value: selectedCategory,
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue ?? 'All';
              });
            },
            items: getUniqueCategories().map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: notifications != null
            ? ListView.builder(
          itemCount: getFilteredNotifications().length,
          itemBuilder: (context, index) {
            final notificationItem = getFilteredNotifications()[index];
            return GestureDetector(
              onTap: () {
                // Navigate to NotificationScreen when an item is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationScreen(notificationItem: notificationItem),
                  ),
                );
              },
              child: Card(
                // You can customize the card layout based on your requirements
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category: ${notificationItem.category}', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text('Title: ${notificationItem.title}', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text('Details: ${notificationItem.details}', style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            );
          },
        )
            : Center(
          child: CircularProgressIndicator(), // Show a loading indicator while fetching data
        ),
      ),
    );
  }
}
