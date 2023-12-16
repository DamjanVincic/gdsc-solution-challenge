import 'dart:convert';

class ExaminationResult {
  int feeling;
  String goals;
  String work;
  DateTime date;

  ExaminationResult({
    required this.feeling,
    required this.goals,
    required this.work,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'feeling': feeling,
      'goals': goals,
      'work': work,
      'date': date.toIso8601String(), // Convert DateTime to a string for storage
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory ExaminationResult.fromJson(String json) {
    final Map<String, dynamic> data = jsonDecode(json);
    return ExaminationResult(
      feeling: data['feeling'],
      goals: data['goals'],
      work: data['work'],
      date: DateTime.parse(data['date']), // Convert string to DateTime
    );
  }
}
