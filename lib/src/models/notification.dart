class NotificationItem {
  String category;
  String title;
  String details;

  NotificationItem({required this.category, required this.title, required this.details});

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'text': title,
      'details': details
    };
  }
}