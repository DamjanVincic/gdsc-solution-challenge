class NotificationItem {
  String category;
  String text;

  NotificationItem({required this.category, required this.text});

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'text': text,
    };
  }
}