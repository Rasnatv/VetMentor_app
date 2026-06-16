

class CourseModel {
  final String id;
  final String courseName;

  const CourseModel({
    required this.id,
    required this.courseName,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
    id: json['id'] as String,
    courseName: json['course_name'] as String,
  );
}