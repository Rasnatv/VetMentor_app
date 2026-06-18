class WishlistCollege {
  final String collegeId; // ← String
  final String collegeName;
  final String district;
  final String state;

  WishlistCollege({
    required this.collegeId,
    required this.collegeName,
    required this.district,
    required this.state,
  });

  factory WishlistCollege.fromJson(Map<String, dynamic> json) {
    return WishlistCollege(
      collegeId:   json['college_id'].toString(), // ← no int.parse
      collegeName: json['college_name'] as String,
      district:    json['district'] as String,
      state:       json['state'] as String,
    );
  }

  String get location => '$district, $state';
}