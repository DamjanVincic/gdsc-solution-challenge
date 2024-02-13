import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../repository/gratitude_journal_repository.dart';
import '../models/gratitude_journal_item.dart';
import '../components/gratitude_journal_item_popup.dart';

class GratitudeJournalScreen extends StatefulWidget {
  const GratitudeJournalScreen({Key? key}) : super(key: key);

  @override
  _GratitudeJournalScreenState createState() => _GratitudeJournalScreenState();
}

class _GratitudeJournalScreenState extends State<GratitudeJournalScreen> {
  final GratitudeJournalRepository _repository = GratitudeJournalRepository();
  late GratitudeJournalItem _journalItem;

  DateTime _selectedDate = DateTime.now();
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = _selectedDate;
    _firstDay = _focusedDay.subtract(const Duration(days: 365));
    _lastDay = _focusedDay.add(const Duration(days: 365));
    _journalItem = GratitudeJournalItem(date: _selectedDate, text: ''); // Initialize _journalItem
    _loadGratitudeJournalItem();
  }

  void _loadGratitudeJournalItem() async {
    final loadedItem = await _repository.getEntryForDate(_selectedDate);
    setState(() {
      _journalItem = loadedItem ?? GratitudeJournalItem(date: _selectedDate, text: '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gratitude Journal'),
      ),
      body: Column(
        children: [
          _buildCalendar(),
          ElevatedButton(
            onPressed: () {
              _showGratitudeJournalItemPopup(context, _journalItem);
            },
            child: Text(_isTodaySelected(_journalItem.date) ? 'Read / write today\'s entry' : 'Read selected entry'),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: _firstDay,
      lastDay: _lastDay,
      focusedDay: _focusedDay,
      calendarFormat: CalendarFormat.month,
      eventLoader: _getEventsForDay,
      onDaySelected: _onDaySelected,
      selectedDayPredicate: (day) {
        return isSameDay(day, _selectedDate);
      },
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month'
      }
    );
  }

  List<GratitudeJournalItem> _getEventsForDay(DateTime day) {
    return [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
      _focusedDay = focusedDay;
      _loadGratitudeJournalItem();
    });
  }

  Future<void> _showGratitudeJournalItemPopup(BuildContext context, GratitudeJournalItem journalItem) async {
    final updatedItem = await showDialog<GratitudeJournalItem>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Gratitude Journal Entry - ${_formatDate(journalItem.date)}"),
          content: GratitudeJournalItemPopup(
            date: journalItem.date,
            text: journalItem.text,
            isEditable: _isTodaySelected(journalItem.date),
            onSave: (updatedText) {
              setState(() {
                _journalItem.text = updatedText;
              });
              _saveJournalEntry(_journalItem);
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );

    if (updatedItem != null) {
      _journalItem = updatedItem;
      _saveJournalEntry(_journalItem);
    }
  }

  void _saveJournalEntry(GratitudeJournalItem entry) async {
    await _repository.addOrUpdateEntry(entry);
  }

  bool _isTodaySelected(DateTime date) {
    DateTime currentDate = DateTime.now();
    return date.year == currentDate.year && date.month == currentDate.month && date.day == currentDate.day;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
