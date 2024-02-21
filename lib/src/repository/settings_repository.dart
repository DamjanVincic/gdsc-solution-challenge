import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  Future<void> saveQuoteDateTime(DateTime quoteTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('quote_date_time', quoteTime.toIso8601String());
  }

  Future<DateTime?> getQuoteDateTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? quoteTimeString = prefs.getString('quote_date_time');

    if (quoteTimeString != null) {
      return DateTime.parse(quoteTimeString);
    } else {
      return null; // Return null if no value is found in SharedPreferences
    }
  }

  Future<void> saveDiaryDateTime(DateTime dateTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('gratitude_journal_date_time', dateTime.toIso8601String());
  }

  Future<DateTime?> getDiaryDateTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? dateTimeString = prefs.getString('gratitude_journal_date_time');

    if (dateTimeString != null) {
      return DateTime.parse(dateTimeString);
    } else {
      return null; // Return null if no value is found in SharedPreferences
    }
  }
}