class AffiliatedCollegeListResponse {
  final String status;
  final String statusCode;
  final String message;
  final List<AffiliatedCollegeModel> data;

  const AffiliatedCollegeListResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AffiliatedCollegeListResponse.fromJson(Map<String, dynamic> json) {
    return AffiliatedCollegeListResponse(
      status: json['status']?.toString() ?? '',
      statusCode: json['status_code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) =>
          AffiliatedCollegeModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  bool get isSuccess => status == '1' && statusCode == '200';
}

/// Used for /temporary-colleges and /permanent-colleges — these endpoints
/// don't return a `type` field, unlike /college-list (CollegeModel).
class AffiliatedCollegeModel {
  final String id;
  final String collegeName;
  final String district;
  final String state;

  const AffiliatedCollegeModel({
    required this.id,
    required this.collegeName,
    required this.district,
    required this.state,
  });

  factory AffiliatedCollegeModel.fromJson(Map<String, dynamic> json) {
    return AffiliatedCollegeModel(
      id: json['id']?.toString() ?? '',
      collegeName: json['college_name']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'college_name': collegeName,
    'district': district,
    'state': state,
  };

  String get location => '$district, $state';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is AffiliatedCollegeModel && other.id == id);

  @override
  int get hashCode => id.hashCode;
}