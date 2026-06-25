// ─────────────────────────────────────────────────────────────
//  AffiliatedCollegeModel  —  matches temporary & permanent APIs
// ─────────────────────────────────────────────────────────────

class AffiliatedCollegeModel {
  final String id;
  final String collegeName;
  final String district;
  final String state;
  final String type; // "0" = permanent-type, "1" = temporary-type

  const AffiliatedCollegeModel({
    required this.id,
    required this.collegeName,
    required this.district,
    required this.state,
    required this.type,
  });

  factory AffiliatedCollegeModel.fromJson(Map<String, dynamic> json) {
    return AffiliatedCollegeModel(
      id:          json['id']?.toString()           ?? '',
      collegeName: json['college_name']?.toString() ?? '',
      district:    json['district']?.toString()     ?? '',
      state:       json['state']?.toString()        ?? '',
      type:        json['type']?.toString()         ?? '0',
    );
  }

  Map<String, dynamic> toJson() => {
    'id':           id,
    'college_name': collegeName,
    'district':     district,
    'state':        state,
    'type':         type,
  };

  /// Human-readable location string shown on cards
  String get location => '$district, $state';

  /// true when the college holds a permanent affiliation
  bool get isPermanent => type == '0';

  @override
  String toString() =>
      'AffiliatedCollegeModel(id: $id, name: $collegeName, '
          'district: $district, state: $state, type: $type)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AffiliatedCollegeModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// ─────────────────────────────────────────────────────────────
//  AffiliatedCollegeListResponse  —  outer API envelope
// ─────────────────────────────────────────────────────────────

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
    final rawList = json['data'];
    final List<AffiliatedCollegeModel> colleges = rawList is List
        ? rawList
        .whereType<Map<String, dynamic>>()
        .map(AffiliatedCollegeModel.fromJson)
        .toList()
        : [];

    return AffiliatedCollegeListResponse(
      status:     json['status']?.toString()      ?? '',
      statusCode: json['status_code']?.toString() ?? '',
      message:    json['message']?.toString()     ?? '',
      data:       colleges,
    );
  }

  bool get isSuccess => status == '1' || statusCode == '200';
}