import 'package:shared_preferences/shared_preferences.dart';
import '../models/examination_result.dart';

class ExaminationDataHandler {
  Future<List<ExaminationResult>> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? jsonList = prefs.getStringList('examination_results');
    if (jsonList != null) {
      return jsonList.map((json) => ExaminationResult.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<void> saveData(List<ExaminationResult> items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = items.map((result) => result.toJson()).toList();
    prefs.setStringList('examination_results', jsonList);
  }
}