

class CourseDetailModel {
  final String id;
  final String courseName;
  final String duration;
  final String eligibility;
  final List<String> aboutCourse;

  CourseDetailModel({
    required this.id,
    required this.courseName,
    required this.duration,
    required this.eligibility,
    required this.aboutCourse,
  });

  factory CourseDetailModel.fromJson(Map<String, dynamic> json) {
    return CourseDetailModel(
      id: json['id']?.toString() ?? '',
      courseName: json['course_name'] ?? '',
      duration: json['duration'] ?? '',
      eligibility: json['eligibility'] ?? '',
      aboutCourse: List<String>.from(json['about_course'] ?? []),
    );
  }
}