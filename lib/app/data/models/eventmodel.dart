class EventModel {
  final String id;
  final String title;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final String location;
  final String description;
  final String image;

  EventModel({
    required this.id,
    required this.title,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.location,
    required this.description,
    required this.image,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      startDate: json['start_date']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }
}