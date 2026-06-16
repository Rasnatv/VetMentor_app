class StudentProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String phoneNo;
  final String state;
  final String program;
  final String netScore;

  const StudentProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.phoneNo,
    required this.state,
    required this.program,
    required this.netScore,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) =>
      StudentProfileModel(
        id:        json['id']?.toString() ?? '',
        firstName: json['first_name']?.toString() ?? '',
        lastName:  json['last_name']?.toString() ?? '',
        gender:    json['gender']?.toString() ?? '',
        email:     json['email']?.toString() ?? '',
        phoneNo:   json['phone_no']?.toString() ?? '',
        // ✅ Handle both "state" (fetch) and "state_name" (update)
        state:     json['state']?.toString() ??
            json['state_name']?.toString() ?? '',
        // ✅ Handle both "program" (fetch) and "program_name" (update)
        program:   json['program']?.toString() ??
            json['program_name']?.toString() ?? '',
        netScore:  json['net_score']?.toString() ?? '',
      );
}

class StudentProfileResponse {
  final String status;
  final int statusCode;
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
      statusCode: json['status_code'] as int? ?? 0,
      message:    json['message']?.toString() ?? '',
      data: raw is Map<String, dynamic>
          ? StudentProfileModel.fromJson(raw)
          : null,
    );
  }

  bool get isSuccess => status == '1' && statusCode == 200;
}