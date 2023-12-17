import 'package:shared_preferences/shared_preferences.dart';

import '../models/habit.dart';
import '../models/meditation_data.dart';

class MeditationDataHandler {
  Future<List<MeditationData>> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? jsonList = prefs.getStringList('meditationData');
    if (jsonList != null) {
      return jsonList.map((json) => MeditationData.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<void> saveData(List<MeditationData> items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = items.map((data) => data.toJson()).toList();
    prefs.setStringList('meditationData', jsonList);
  }
}
