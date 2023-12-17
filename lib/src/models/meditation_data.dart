import 'dart:convert';

class MeditationData {
  int durationInSeconds;
  String date;

  MeditationData({
    required this.durationInSeconds,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'durationInSeconds': durationInSeconds,
      'date': date,
    };
  }

  String toJson() {
    return '{"durationInSeconds": $durationInSeconds, "date": "$date"}';
  }

  factory MeditationData.fromJson(String json) {
    final Map<String, dynamic> data = Map<String, dynamic>.from(jsonDecode(json));
    return MeditationData(
      durationInSeconds: data['durationInSeconds'],
      date: data['date'],
    );
  }
}