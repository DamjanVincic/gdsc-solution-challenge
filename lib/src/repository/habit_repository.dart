import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';

class HabitRepository {
  Future<List<Habit>> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? jsonList = prefs.getStringList('habits');
    if (jsonList != null) {
      return jsonList.map((json) => Habit.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<void> saveData(List<Habit> items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = items.map((result) => result.toJson()).toList();
    prefs.setStringList('habits', jsonList);
  }
}