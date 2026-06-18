// class StateModel {
//   final String id;
//   final String stateName;
//
//   const StateModel({required this.id, required this.stateName});
//
//   factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
//     id:        json['id']?.toString() ?? '',
//     stateName: json['state_name']?.toString() ?? '',
//   );
// }
//
// class StatesResponse {
//   final String status;
//   final String statusCode;
//   final String message;
//   final List<StateModel> data;
//
//   const StatesResponse({
//     required this.status,
//     required this.statusCode,
//     required this.message,
//     required this.data,
//   });
//
//   factory StatesResponse.fromJson(Map<String, dynamic> json) => StatesResponse(
//     status:     json['status']?.toString() ?? '',
//     statusCode: json['status_code']?.toString() ?? '',
//     message:    json['message']?.toString() ?? '',
//     data: (json['data'] as List<dynamic>?)
//         ?.map((e) => StateModel.fromJson(e as Map<String, dynamic>))
//         .toList() ??
//         [],
//   );
//
//   bool get isSuccess => status == '1' && statusCode == '200';
// }
//
// // ─────────────────────────────────────────────────────────────
//
// class ProgramModel {
//   final String id;
//   final String programName;
//
//   const ProgramModel({required this.id, required this.programName});
//
//   factory ProgramModel.fromJson(Map<String, dynamic> json) => ProgramModel(
//     id:          json['id']?.toString() ?? '',
//     programName: json['program_name']?.toString() ?? '',
//   );
// }
//
// class ProgramsResponse {
//   final String status;
//   final String statusCode;
//   final String message;
//   final List<ProgramModel> data;
//
//   const ProgramsResponse({
//     required this.status,
//     required this.statusCode,
//     required this.message,
//     required this.data,
//   });
//
//   factory ProgramsResponse.fromJson(Map<String, dynamic> json) =>
//       ProgramsResponse(
//         status:     json['status']?.toString() ?? '',
//         statusCode: json['status_code']?.toString() ?? '',
//         message:    json['message']?.toString() ?? '',
//         data: (json['data'] as List<dynamic>?)
//             ?.map((e) => ProgramModel.fromJson(e as Map<String, dynamic>))
//             .toList() ??
//             [],
//       );
//
//   bool get isSuccess => status == '1' && statusCode == '200';
// }
//
// // ─────────────────────────────────────────────────────────────
//
// class StudentRegisterRequest {
//   final String firstName;
//   final String lastName;
//   final String gender;
//   final String email;
//   final String phoneNo;
//   final String stateId;
//   final String programId;
//   final String? neetScore;
//
//   const StudentRegisterRequest({
//     required this.firstName,
//     required this.lastName,
//     required this.gender,
//     required this.email,
//     required this.phoneNo,
//     required this.stateId,
//     required this.programId,
//     this.neetScore,
//   });
//
//   Map<String, dynamic> toJson() => {
//     'first_name': firstName,
//     'last_name':  lastName,
//     'gender':     gender,
//     'email':      email,
//     'phone_no':   phoneNo,
//     'state_id':   stateId,
//     'program_id': programId,
//     if (neetScore != null && neetScore!.isNotEmpty) 'net_score': neetScore,
//   };
// }
//
// // ─────────────────────────────────────────────────────────────
//
// class StudentRegisterResponse {
//   final String status;
//   final String statusCode;
//   final String message;
//   final String studentId; // ← real id from data.id in the API response
//
//   const StudentRegisterResponse({
//     required this.status,
//     required this.statusCode,
//     required this.message,
//     required this.studentId,
//   });
//
//   factory StudentRegisterResponse.fromJson(Map<String, dynamic> json) {
//     // API response shape:
//     // { "status":"1", "status_code":"200", "message":"...",
//     //   "data": { "id":"4", "first_name":... } }
//     final data = json['data'];
//     final id   = (data is Map ? data['id']?.toString() : null) ?? '';
//
//     return StudentRegisterResponse(
//       status:     json['status']?.toString() ?? '',
//       statusCode: json['status_code']?.toString() ?? '',
//       message:    json['message']?.toString() ?? '',
//       studentId:  id,
//     );
//   }
//
//   bool get isSuccess => status == '1' && statusCode == '200';
// }
// ─── State / Program models kept for any other usage ────────────────────────
// (StateModel is no longer used in the enquiry form — state is now free text)

class ProgramModel {
  final String id;
  final String programName;

  const ProgramModel({required this.id, required this.programName});

  factory ProgramModel.fromJson(Map<String, dynamic> json) => ProgramModel(
    id: json['id']?.toString() ?? '',
    programName: json['program_name']?.toString() ?? '',
  );
}

class ProgramsResponse {
  final String status;
  final String statusCode;
  final String message;
  final List<ProgramModel> data;

  const ProgramsResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ProgramsResponse.fromJson(Map<String, dynamic> json) =>
      ProgramsResponse(
        status: json['status']?.toString() ?? '',
        statusCode: json['status_code']?.toString() ?? '',
        message: json['message']?.toString() ?? '',
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => ProgramModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
            [],
      );

  bool get isSuccess => status == '1' && statusCode == '200';
}

// ─────────────────────────────────────────────────────────────────────────────

class StudentRegisterRequest {
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String countryCode;
  final String phoneNo;

  // ── New address fields (replaces state_id) ────────────────────────────────
  final String state;
  final String district;
  final String country;
  final String address;
  final String pincode;

  final String programId;

  /// Nullable — not every screen that opens the enquiry form has a
  /// college context (e.g. mentors screen). When null, the key is
  /// omitted from the request body entirely.
  final String? collegeId;
  final String? neetScore;

  const StudentRegisterRequest({
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
    required this.programId,
    this.collegeId,
    this.neetScore,
  });

  Map<String, dynamic> toJson() => {
    'first_name': firstName,
    'last_name': lastName,
    'gender': gender,
    'email': email,
    'country_code': countryCode,
    'phone_no': phoneNo,
    'state': state,
    'district': district,
    'country': country,
    'address': address,
    'pincode': pincode,
    'program_id': programId,
    // ✅ college_id sent only when a college context exists (home screen).
    // Mentor screen and other non-college entry points leave this null
    // so the key is omitted from the JSON body automatically.
    if (collegeId != null && collegeId!.isNotEmpty) 'college_id': collegeId,
    if (neetScore != null && neetScore!.isNotEmpty) 'net_score': neetScore,
  };
}

// ─────────────────────────────────────────────────────────────────────────────

class StudentRegisterResponse {
  final String status;
  final String statusCode;
  final String message;
  final String studentId;

  const StudentRegisterResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.studentId,
  });

  factory StudentRegisterResponse.fromJson(Map<String, dynamic> json) {
    // API response shape:
    // { "status":"1", "status_code":"200", "message":"...",
    //   "data": { "id":"52", "first_name":... } }
    final data = json['data'];
    final id = (data is Map ? data['id']?.toString() : null) ?? '';

    return StudentRegisterResponse(
      status: json['status']?.toString() ?? '',
      statusCode: json['status_code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      studentId: id,
    );
  }

  bool get isSuccess => status == '1' && statusCode == '200';
}