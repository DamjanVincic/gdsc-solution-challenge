import 'package:flutter/material.dart';

class GratitudeJournalItemPopup extends StatefulWidget {
  final DateTime date;
  final String text;
  final bool isEditable;
  final Function(String) onSave;

  const GratitudeJournalItemPopup({
    Key? key,
    required this.date,
    required this.text,
    required this.isEditable,
    required this.onSave,
  }) : super(key: key);

  @override
  _GratitudeJournalItemPopupState createState() => _GratitudeJournalItemPopupState();
}

class _GratitudeJournalItemPopupState extends State<GratitudeJournalItemPopup> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the date with bold text
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 16.0),
              children: [
                const TextSpan(
                  text: 'Date: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: _formatDate(widget.date)),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          // Display the editable text field if today's date is selected
          if (widget.isEditable) ...[
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                labelText: 'Enter text',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 8.0),
          ],
          // Save and close buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the popup without saving changes
                },
                child: const Text("Close"),
              ),
              const SizedBox(width: 8.0),
              if (widget.isEditable) ...[
                ElevatedButton(
                  onPressed: () {
                    // Save changes and close the popup
                    widget.onSave(_textEditingController.text);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Save"),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}