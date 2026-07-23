class NewsModel {
  final String id;
  final String title;
  final String source;

  NewsModel({
    required this.id,
    required this.title,
    required this.source,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      source: json['source']?.toString() ?? '',
    );
  }
}