import 'package:flutter/material.dart';
import '../models/quote.dart';

class QuoteDetailsScreen extends StatelessWidget {
  final Quote notificationItem;
  final Color primaryColor;
  final Color accentColor;

  const QuoteDetailsScreen({
    Key? key,
    required this.notificationItem,
    required this.primaryColor,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purpleAccent.shade100,
          title: Text(
            'Quote Details',
            style: TextStyle(color: accentColor), // Customize text color
          ),
        ),
        body: Container(
          color: Colors.white38,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.purpleAccent.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notificationItem.title,
                        style: TextStyle(
                          fontSize: 20,
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Category: ${notificationItem.category}',
                        style: TextStyle(
                          fontSize: 18,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notificationItem.details,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
