import 'package:shared_preferences/shared_preferences.dart';

import '../models/gratitude_journal_item.dart';

class GratitudeJournalRepository {
  Future<List<GratitudeJournalItem>> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? jsonList = prefs.getStringList('gratitude_journal_entries');
    if (jsonList != null) {
      return jsonList.map((json) => GratitudeJournalItem.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<void> saveData(List<GratitudeJournalItem> items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = items.map((item) => item.toJson()).toList();
    prefs.setStringList('gratitude_journal_entries', jsonList);
  }

  Future<GratitudeJournalItem?> getEntryForDate(DateTime date) async {
    List<GratitudeJournalItem> entries = await loadData();
    for (final entry in entries) {
      if (entry.date.year == date.year &&
          entry.date.month == date.month &&
          entry.date.day == date.day) {
        return entry;
      }
    }
    return null;
  }

  Future<void> addOrUpdateEntry(GratitudeJournalItem newItem) async {
    List<GratitudeJournalItem> entries = await loadData();
    bool entryExists = false;
    for (int i = 0; i < entries.length; i++) {
      if (entries[i].date == newItem.date) {
        entries[i] = newItem; // Update existing entry
        entryExists = true;
        break;
      }
    }
    if (!entryExists) {
      entries.add(newItem); // Add new entry
    }
    await saveData(entries);
  }
}