
class CollegeListResponse {
  final String status;
  final String statusCode;
  final String message;
  final List<CollegeModel> data;

  const CollegeListResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory CollegeListResponse.fromJson(Map<String, dynamic> json) {
    return CollegeListResponse(
      status: json['status']?.toString() ?? '',
      statusCode: json['status_code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
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
  final String type;
  final String collegeName;
  final String district;
  final String state;

  const CollegeModel({
    required this.id,
    required this.type,
    required this.collegeName,
    required this.district,
    required this.state,
  });

  factory CollegeModel.fromJson(Map<String, dynamic> json) {
    return CollegeModel(
      id:          json['id']?.toString() ?? '',
      type:        json['type']?.toString() ?? '0',
      collegeName: json['college_name']?.toString() ?? '',
      district:    json['district']?.toString() ?? '',
      state:       json['state']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id':           id,
    'type':         type,
    'college_name': collegeName,
    'district':     district,
    'state':        state,
  };

  /// Full location string e.g. "Jhajjar, Haryana"
  String get location => '$district, $state';

  /// type '1' = government, type '0' = private
  bool get isGovernment => type == '1';

  /// type '0' = enquiry form required, type '1' = skip enquiry form (iOS only)
  bool get isEnquiryRequired => type == '0';

  CollegeModel copyWith({
    String? id,
    String? type,
    String? collegeName,
    String? district,
    String? state,
  }) {
    return CollegeModel(
      id:          id ?? this.id,
      type:        type ?? this.type,
      collegeName: collegeName ?? this.collegeName,
      district:    district ?? this.district,
      state:       state ?? this.state,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is CollegeModel && other.id == id);

  @override
  int get hashCode => id.hashCode;
}