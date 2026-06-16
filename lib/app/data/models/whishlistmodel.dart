class WishlistCollege {
final int id;
final int studentId;
final int collegeId;
final String collegeName;
final String district;
final String state;

WishlistCollege({
  required this.id,
  required this.studentId,
  required this.collegeId,
  required this.collegeName,
  required this.district,
  required this.state,
});

factory WishlistCollege.fromJson(Map<String, dynamic> json) {
final college = json['college'] as Map<String, dynamic>;
return WishlistCollege(
id: json['id'] as int,
studentId: int.parse(json['student_id'].toString()),
collegeId: int.parse(json['college_id'].toString()),
collegeName: college['college_name'] as String,
district: college['district'] as String,
state: college['state'] as String,
);
}

String get location => '$district, $state';
}
