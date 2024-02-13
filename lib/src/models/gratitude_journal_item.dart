import 'dart:convert';

class GratitudeJournalItem {
  String text;
  DateTime date;

  GratitudeJournalItem({
    required this.text,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'date': date.toIso8601String(), // Convert DateTime to a string for storage
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory GratitudeJournalItem.fromJson(String json) {
    final Map<String, dynamic> data = jsonDecode(json);
    return GratitudeJournalItem(
      text: data['text'],
      date: DateTime.parse(data['date']), // Convert string to DateTime
    );
  }
}