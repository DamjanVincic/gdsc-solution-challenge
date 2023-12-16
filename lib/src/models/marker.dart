class Marker {
  final String id;
  final double latitude;
  final double longitude;
  final String title;
  final String snippet;

  const Marker({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.snippet,
  });

  factory Marker.fromJson(Map<String, dynamic> json) {
    return Marker(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      title: json['title'],
      snippet: json['snippet'],
    );
  }
}