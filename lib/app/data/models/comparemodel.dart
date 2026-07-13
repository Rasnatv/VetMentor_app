// data/models/comparecollegemodel.dart
class CompareCollegeModel {
  final String id;
  final String collegeName;
  final String logo;
  final String location;
  final String phone;
  final String email;
  final String website;
  final String rating;
  final String years;
  final String faculty;
  final String students;
  final String affiliationType;
  final List<String> facilities;
  final List<String> courses;

  CompareCollegeModel({
    required this.id,
    required this.collegeName,
    required this.logo,
    required this.location,
    required this.phone,
    required this.email,
    required this.website,
    required this.rating,
    required this.years,
    required this.faculty,
    required this.students,
    required this.affiliationType,
    required this.facilities,
    required this.courses,
  });

  factory CompareCollegeModel.fromJson(Map<String, dynamic> json) {
    return CompareCollegeModel(
      id: json['id']?.toString() ?? '', // safe either way, backend now sends String
      collegeName: json['college_name'] ?? '',
      logo: json['logo'] ?? '',
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      rating: json['rating']?.toString() ?? '-',
      years: json['years']?.toString() ?? '-',
      faculty: json['faculty']?.toString() ?? '-',
      students: json['students']?.toString() ?? '-',
      affiliationType: json['affiliation_type'] ?? '-',
      facilities: List<String>.from(json['facilities'] ?? []),
      courses: List<String>.from(json['courses'] ?? []),
      // "about" intentionally NOT parsed — not shown on compare screen
    );
  }
}