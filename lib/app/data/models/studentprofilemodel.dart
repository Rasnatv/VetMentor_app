class StudentProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String countryCode;
  final String phoneNo;
  final String state;
  final String district;
  final String country;
  final String address;
  final String pincode;
  final String program;
  final String netScore;

  const StudentProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.countryCode,
    required this.phoneNo,
    required this.state,
    required this.district,
    required this.country,
    required this.address,
    required this.pincode,
    required this.program,
    required this.netScore,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) =>
      StudentProfileModel(
        id:          json['id']?.toString() ?? '',
        firstName:   json['first_name']?.toString() ?? '',
        lastName:    json['last_name']?.toString() ?? '',
        gender:      json['gender']?.toString() ?? '',
        email:       json['email']?.toString() ?? '',
        countryCode: json['country_code']?.toString() ?? '+91',
        phoneNo:     json['phone_no']?.toString() ?? '',
        state:       json['state']?.toString() ??
            json['state_name']?.toString() ?? '',
        district:    json['district']?.toString() ?? '',
        country:     json['country']?.toString() ?? '',
        address:     json['address']?.toString() ?? '',
        pincode:     json['pincode']?.toString() ?? '',
        // Handle both "program_name" (fetch/update response) and "program" (legacy)
        program:     json['program_name']?.toString() ??
            json['program']?.toString() ?? '',
        netScore:    json['net_score']?.toString() ?? '',
      );
}

class StudentProfileResponse {
  final String status;
  final String statusCode; // API returns "200" as string
  final String message;
  final StudentProfileModel? data;

  const StudentProfileResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory StudentProfileResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    return StudentProfileResponse(
      status:     json['status']?.toString() ?? '',
      statusCode: json['status_code']?.toString() ?? '',
      message:    json['message']?.toString() ?? '',
      data: raw is Map<String, dynamic>
          ? StudentProfileModel.fromJson(raw)
          : null,
    );
  }

  // status == "1" and status_code == "200" (both are strings in the API)
  bool get isSuccess => status == '1' && statusCode == '200';
}