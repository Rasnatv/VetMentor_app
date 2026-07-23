class NewsDetailModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final String source;
  final String publishedDate;
  final String image;

  NewsDetailModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.source,
    required this.publishedDate,
    required this.image,
  });

  factory NewsDetailModel.fromJson(Map<String, dynamic> json) {
    return NewsDetailModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      source: json['source']?.toString() ?? '',
      publishedDate: json['published_date']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }
}