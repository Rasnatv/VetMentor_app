import 'package:flutter/cupertino.dart';

class CourseModel {
  final String id;
  final String shortName;
  final String fullName;
  final String type; // 'Degree' | 'Diploma' | 'Certificate'
  final String duration;
  final String eligibility;
  final String feesRange;
  final String salaryRange;
  final String about;
  final Color iconBgColor;
  final Color iconColor;
  final IconData icon;
  final List<SubjectModel> subjects;
  final List<CareerModel> careers;
  final List<CollegeModel> colleges;
  final int collegeCount;

  const CourseModel({
    required this.id,
    required this.shortName,
    required this.fullName,
    required this.type,
    required this.duration,
    required this.eligibility,
    required this.feesRange,
    required this.salaryRange,
    required this.about,
    required this.iconBgColor,
    required this.iconColor,
    required this.icon,
    required this.subjects,
    required this.careers,
    required this.colleges,
    required this.collegeCount,
  });
}

class SubjectModel {
  final String name;
  final String year;
  final IconData icon;
  const SubjectModel({required this.name, required this.year, required this.icon});
}

class CareerModel {
  final String label;
  final IconData icon;
  const CareerModel({required this.label, required this.icon});
}

class CollegeModel {
  final String initials;
  final String name;
  final String location;
  const CollegeModel({required this.initials, required this.name, required this.location});
}