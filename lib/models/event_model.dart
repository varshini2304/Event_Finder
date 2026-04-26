class Event {
  final String id;
  final String title;
  final String category;
  final String date;
  final String time;
  final String location;
  final String imageUrl;
  final String distance;
  final String description;
  final bool isFavorite;

  const Event({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.imageUrl,
    required this.distance,
    required this.description,
    this.isFavorite = false,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      distance: json['distance']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      isFavorite: json['isFavorite'] == true,
    );
  }

  Event copyWith({
    String? id,
    String? title,
    String? category,
    String? date,
    String? time,
    String? location,
    String? imageUrl,
    String? distance,
    String? description,
    bool? isFavorite,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      distance: distance ?? this.distance,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}