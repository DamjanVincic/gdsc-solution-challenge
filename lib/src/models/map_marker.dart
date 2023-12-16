class MapMarker {
  final String id;
  final double latitude;
  final double longitude;
  final String title;
  final String snippet;

  const MapMarker({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.snippet,
  });

  factory MapMarker.fromJson(Map<String, dynamic> json) {
    return MapMarker(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      title: json['title'],
      snippet: json['snippet'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'title': title,
      'snippet': snippet,
    };
  }
}