class CollegeDetailResponse {
  final String status;
  final String statusCode;
  final String message;
  final CollegeDetailModel? data;

  const CollegeDetailResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory CollegeDetailResponse.fromJson(Map<String, dynamic> json) {
    return CollegeDetailResponse(
      status:     json['status']?.toString() ?? '',
      statusCode: json['status_code']?.toString() ?? '',
      message:    json['message']?.toString() ?? '',
      data: json['data'] != null
          ? CollegeDetailModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  bool get isSuccess => status == '1' && statusCode == '200';
}

class CollegeDetailModel {
  final String id;
  final String collegeName;
  final String street;
  final String district;
  final String state;
  final String pincode;
  final double rating;
  final String? imageUrl;
  final String phone;
  final String email;
  final String website;
  final String about;
  final String years;
  final String faculty;
  final String students;
  final String affiliationType;
  final List<String> facilities;
  final List<String> courses;

  const CollegeDetailModel({
    required this.id,
    required this.collegeName,
    required this.street,
    required this.district,
    required this.state,
    required this.pincode,
    required this.rating,
    this.imageUrl,
    required this.phone,
    required this.email,
    required this.website,
    required this.about,
    required this.years,
    required this.faculty,
    required this.students,
    required this.affiliationType,
    required this.facilities,
    required this.courses,
  });

  factory CollegeDetailModel.fromJson(Map<String, dynamic> json) {
    return CollegeDetailModel(
      id:              json['id']?.toString() ?? '',
      collegeName:     json['college_name']?.toString() ?? '',
      street:          json['street']?.toString() ?? '',
      district:        json['district']?.toString() ?? '',
      state:           json['state']?.toString() ?? '',
      pincode:         json['pincode']?.toString() ?? '',
      rating:          double.tryParse(json['rating']?.toString() ?? '0') ?? 0,
      imageUrl:        json['image']?.toString(),
      phone:           json['phone']?.toString() ?? '',
      email:           json['email']?.toString() ?? '',
      website:         json['website']?.toString() ?? '',
      about:           json['about']?.toString() ?? '',
      years:           json['years']?.toString() ?? '',
      faculty:         json['faculty']?.toString() ?? '',
      students:        json['students']?.toString() ?? '',
      affiliationType: json['affiliation_type']?.toString() ?? '',
      facilities: (json['facilities'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      courses: (json['courses'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }

  String get fullAddress => '$street, $district, $state – $pincode';
}