/// Model for a single item inside `data.list` of the bottom-ads API response.
class AdBannerModel {
  final String id;
  final String image;
  final String poster;
  final String link;

  AdBannerModel({
    required this.id,
    required this.image,
    required this.poster,
    required this.link,
  });

  factory AdBannerModel.fromJson(Map<String, dynamic> json) {
    return AdBannerModel(
      id: json['id']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      poster: json['poster']?.toString() ?? '',
      link: json['link']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'image': image,
    'poster': poster,
    'link': link,
  };
}

/// Wraps the full API response:
/// {
///   "status": "1",
///   "status_code": "200",
///   "data": { "list": [ ... ] },
///   "message": "success"
/// }
class AdBannerResponse {
  final bool isSuccess;
  final String statusCode;
  final List<AdBannerModel> data;
  final String message;

  AdBannerResponse({
    required this.isSuccess,
    required this.statusCode,
    required this.data,
    required this.message,
  });

  factory AdBannerResponse.fromJson(Map<String, dynamic> json) {
    final rawList =
    (json['data'] as Map<String, dynamic>?)?['list'] as List<dynamic>?;

    final list = (rawList ?? [])
        .map((e) => AdBannerModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return AdBannerResponse(
      isSuccess: json['status']?.toString() == '1',
      statusCode: json['status_code']?.toString() ?? '',
      data: list,
      message: json['message']?.toString() ?? '',
    );
  }
}