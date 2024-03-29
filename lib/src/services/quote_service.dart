import 'dart:convert';
import 'dart:core';

import '../models/quote.dart';
import 'package:http/http.dart' as http;

class QuoteService {
  final String baseUrl = "https://actualizer-fb7e8-default-rtdb.europe-west1.firebasedatabase.app";
  final String notificationsEndpoint = "/notifications.json";

  void uploadQuote(String category, String text, String details) async {
    Quote notificationItem = Quote(category: category, title: text, details: details);
    final String firebaseUrl = '$baseUrl$notificationsEndpoint';

    try {
      final response = await http.post(
        Uri.parse(firebaseUrl),
        headers: {
          'Content-Type': 'application/json'
        },
        body: json.encode(notificationItem.toMap()),
      );

      if (response.statusCode == 200) {
        print('Notification added successfully.');
      } else {
        print('Failed to add notification. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<List<Quote>> fetchQuotes() async {
    final String firebaseUrl = '$baseUrl$notificationsEndpoint';
    try {
      final response = await http.get(Uri.parse(firebaseUrl));
      if (response.statusCode == 200) {
        List<Quote> items = [];
        final data = List.from(json.decode(response.body).values);
        for (var item in data) {
          items.add(Quote(category: (item['category']), title: item['text'], details: item['details']));
        }
        return items;
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }
}
