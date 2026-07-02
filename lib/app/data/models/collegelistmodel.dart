
class CollegeListResponse {
  final String status;
  final String statusCode;
  final String message;
  final String type; // ✅ ONE flag per API call — not per college
  final List<CollegeModel> data;

  const CollegeListResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.type,
    required this.data,
  });

  factory CollegeListResponse.fromJson(Map<String, dynamic> json) {
    return CollegeListResponse(
      status: json['status']?.toString() ?? '',
      statusCode: json['status_code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      type: json['type']?.toString() ?? '0', // ✅ read once, top-level only
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CollegeModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  bool get isSuccess => status == '1' && statusCode == '200';
}

class CollegeModel {
  final String id;
  final String collegeName;
  final String district;
  final String state;
  // ❌ no "type" field here — the API never sends it per-item, and it
  // never differs between colleges within the same response.

  const CollegeModel({
    required this.id,
    required this.collegeName,
    required this.district,
    required this.state,
  });

  factory CollegeModel.fromJson(Map<String, dynamic> json) {
    return CollegeModel(
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

  /// Full location string e.g. "Jhajjar, Haryana"
  String get location => '$district, $state';

  CollegeModel copyWith({
    String? id,
    String? collegeName,
    String? district,
    String? state,
  }) {
    return CollegeModel(
      id: id ?? this.id,
      collegeName: collegeName ?? this.collegeName,
      district: district ?? this.district,
      state: state ?? this.state,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is CollegeModel && other.id == id);

  @override
  int get hashCode => id.hashCode;
}