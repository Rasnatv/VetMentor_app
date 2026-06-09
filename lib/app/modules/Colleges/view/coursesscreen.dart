import 'package:flutter/material.dart';
import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';

import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../data/models/modelclass.dart';
import '../../../widgets/commonwidget.dart';


class CoursesScreen extends StatefulWidget {
  final College college;

  const CoursesScreen({super.key, required this.college});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String _selectedLevel = 'All Courses';

  final _levels = ['All Courses', 'UG Courses', 'PG Courses', 'Diploma'];

  List<Course> get _filteredCourses {
    if (_selectedLevel == 'All Courses') return widget.college.allCourses;
    if (_selectedLevel == 'UG Courses') return widget.college.allCourses.where((c) => c.level == 'UG').toList();
    if (_selectedLevel == 'PG Courses') return widget.college.allCourses.where((c) => c.level == 'PG').toList();
    if (_selectedLevel == 'Diploma') return widget.college.allCourses.where((c) => c.level == 'Diploma').toList();
    return widget.college.allCourses;
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context); // ← get responsive instance

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: VetAppBar(title: 'Courses Offered'),
        body: Column(
          children: [
            // Level Tabs
            Container(
              color: AppColors.backgroundWhite,
              padding: EdgeInsets.symmetric(
                horizontal: r.spacing(AppDimens.paddingLG),
                vertical: r.spacing(AppDimens.paddingMD),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _levels.map((level) {
                    final isSelected = level == _selectedLevel;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedLevel = level),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.only(right: r.spacing(AppDimens.paddingSM)),
                        padding: EdgeInsets.symmetric(
                          horizontal: r.spacing(AppDimens.paddingLG),
                          vertical: r.spacing(AppDimens.paddingSM),
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.backgroundGrey,
                          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                        ),
                        child: Text(
                          level,
                          style: AppTextStyles.titleSmall.copyWith(
                            fontSize: r.fontSize(13),
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Courses List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(
                  r.spacing(AppDimens.paddingLG),
                  r.spacing(AppDimens.paddingMD),
                  r.spacing(AppDimens.paddingLG),
                  100,
                ),
                itemCount: _filteredCourses.length,
                itemBuilder: (ctx, i) {
                  final course = _filteredCourses[i];
                  return _CourseCard(
                    course: course,
                    onApply: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Container(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onApply;

  const _CourseCard({required this.course, required this.onApply});

  static const _levelColors = {
    'UG': Color(0xFF1B5E20),
    'PG': Color(0xFF1565C0),
    'Diploma': Color(0xFF6A1B9A),
    'PhD': Color(0xFFE65100),
  };

  static const _levelIcons = {
    'UG': Icons.school_rounded,
    'PG': Icons.auto_stories_rounded,
    'Diploma': Icons.workspace_premium_rounded,
    'PhD': Icons.psychology_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context); // ← get responsive instance
    final color = _levelColors[course.level] ?? AppColors.primary;
    final icon = _levelIcons[course.level] ?? Icons.school_rounded;
    final isHighlighted = course.level == 'UG';

    return Container(
      margin: EdgeInsets.only(bottom: r.spacing(AppDimens.paddingMD)),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppColors.primarySurface
            : AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(
          color: isHighlighted
              ? AppColors.primary.withOpacity(0.3)
              : AppColors.borderLight,
          width: isHighlighted ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level icon box
            Container(
              width: r.spacing(AppDimens.avatarMD - 4),   // 44 → scaled
              height: r.spacing(AppDimens.avatarMD - 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              ),
              child: Icon(
                icon,
                color: color,
                size: r.fontSize(AppDimens.iconMD),
              ),
            ),
            SizedBox(width: r.spacing(AppDimens.paddingMD)),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          course.name,
                          style: AppTextStyles.titleLarge.copyWith(
                            fontSize: r.fontSize(14),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: r.spacing(AppDimens.paddingSM),
                          vertical: r.spacing(3),
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppDimens.radiusXS + 2),
                        ),
                        child: Text(
                          course.level == 'PhD'
                              ? 'Ph.D.'
                              : '${course.level} Degree',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: color,
                            fontWeight: FontWeight.w600,
                            fontSize: r.fontSize(11),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (course.name != course.fullName) ...[
                    SizedBox(height: r.spacing(2)),
                    Text(
                      course.fullName,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: r.fontSize(12),
                      ),
                      maxLines: 2,
                    ),
                  ],

                  SizedBox(height: r.spacing(AppDimens.paddingSM + 2)),

                  Row(
                    children: [
                      _InfoChip(
                        Icons.schedule_rounded,
                        'Duration: ${course.duration}',
                      ),
                      SizedBox(width: r.spacing(AppDimens.paddingMD)),
                      if (course.intake > 0)
                        _InfoChip(
                          Icons.group_rounded,
                          'Intake: ${course.intake} Seats',
                        ),
                      if (course.intake == 0)
                        _InfoChip(
                          Icons.group_rounded,
                          'Intake: As per ICAR',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context); // ← get responsive instance

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: r.fontSize(AppDimens.iconXS - 2),  // 12 → scaled
          color: AppColors.textSecondary,
        ),
        SizedBox(width: r.spacing(AppDimens.paddingXS)),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: r.fontSize(11),
          ),
        ),
      ],
    );
  }
}