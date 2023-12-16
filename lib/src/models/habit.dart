import 'dart:convert';
import 'dart:collection';

class Habit {
  String name;
  int streakLength = 0;
  SplayTreeSet<String> daysChecked = SplayTreeSet<String>();

  Habit({required this.name});

  void markCompleted(bool isChecked) {
    String currentDate = DateTime.now().toLocal().toString().split(' ')[0];
    bool isAlreadyCompleted = daysChecked.contains(currentDate);

    if (!isAlreadyCompleted && isChecked) {
      daysChecked.add(currentDate);
      updateStreakLength();
    }
  }

  bool isCompleted(String date) {
    return daysChecked.contains(date);
  }

  void updateStreakLength() {
    streakLength = 0;
    int currentStreak = 0;

    String? lastDate;
    for (var date in daysChecked) {
      if (lastDate != null && _isNextDay(lastDate, date)) {
        currentStreak++;
      } else if (lastDate == null || !_isSameDay(lastDate, date)) {
        currentStreak = 1; // Start a new streak if not the same day
      }

      streakLength = streakLength < currentStreak ? currentStreak : streakLength;
      lastDate = date;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'streakLength': streakLength,
      'daysChecked': daysChecked
    };
  }

  String toJson() {
    final jsonString = '{"name": "$name", "streakLength": $streakLength, "daysChecked": ${jsonEncode(daysChecked.toList())}}';
    print('Saving JSON: $jsonString');
    return jsonString;
  }

  factory Habit.fromJson(String json) {
    print('Loading JSON: $json');
    final Map<String, dynamic> data = Map<String, dynamic>.from(jsonDecode(json));
    SplayTreeSet<String> daysChecked = SplayTreeSet<String>.from(data['daysChecked'] ?? []);
    return Habit(
      name: data['name'],
    )
      ..streakLength = data['streakLength'] ?? 0
      ..daysChecked = daysChecked;
  }

  bool _isSameDay(String date1, String date2) {
    DateTime dateTime1 = DateTime.parse(date1);
    DateTime dateTime2 = DateTime.parse(date2);
    return dateTime1.year == dateTime2.year && dateTime1.month == dateTime2.month && dateTime1.day == dateTime2.day;
  }

  bool _isNextDay(String date1, String date2) {
    DateTime dateTime1 = DateTime.parse(date1);
    DateTime dateTime2 = DateTime.parse(date2);
    return dateTime2.isAfter(dateTime1) && !_isSameDay(date1, date2);
  }
}
