
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veterinaryapp/app/widgets/commonwidget.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../courses_controller.dart';
import 'coursesdetailscreen.dart'; // ← add this import

class CourseListingScreen extends StatelessWidget {
  CourseListingScreen({super.key});

  final CourseController _ctrl = Get.put(CourseController());

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: VetAppBar(title: 'All Courses'),
      body: Obx(() {
        // ── Loading ──────────────────────────────────────
        if (_ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // ── Error ────────────────────────────────────────
        if (_ctrl.hasError.value) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off_rounded,
                    size: r.fontSize(48), color: AppColors.textSecondary),
                SizedBox(height: r.spacing(AppDimens.paddingMD)),
                Text(
                  'Failed to load courses.',
                  style: AppTextStyles.bodyMedium,
                ),
                SizedBox(height: r.spacing(AppDimens.paddingMD)),
                ElevatedButton.icon(
                  onPressed: _ctrl.fetchCourses,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // ── Empty ────────────────────────────────────────
        if (_ctrl.courses.isEmpty) {
          return Center(
            child: Text('No courses available.', style: AppTextStyles.bodyMedium),
          );
        }

        // ── List ─────────────────────────────────────────
        return ListView.separated(
          padding: EdgeInsets.fromLTRB(
            r.spacing(AppDimens.paddingLG),
            r.spacing(AppDimens.paddingMD),
            r.spacing(AppDimens.paddingLG),
            100,
          ),
          itemCount: _ctrl.courses.length,
          separatorBuilder: (_, __) =>
              SizedBox(height: r.spacing(AppDimens.paddingMD)),
          itemBuilder: (_, i) => _CourseListTile(
            course: _ctrl.courses[i],
            r: r,
            index: i,
            // ↓ navigate to detail on tap
            onTap: () => Get.to(
                  () => CourseDetailScreen(courseId: _ctrl.courses[i].id),
            ),
          ),
        );
      }),
    );
  }
}

// ── Single course tile ────────────────────────────────────
class _CourseListTile extends StatelessWidget {
  const _CourseListTile({
    required this.course,
    required this.r,
    required this.index,
    required this.onTap, // ← added
  });

  final dynamic course; // CourseModel
  final Responsive r;
  final int index;
  final VoidCallback onTap; // ← added

  // Cycle through a few accent colours for visual variety
  static const _iconColors = [
    AppColors.primary,
    Color(0xFF2196F3),
    Color(0xFF4CAF50),
    Color(0xFFFF9800),
    Color(0xFF9C27B0),
  ];

  @override
  Widget build(BuildContext context) {
    final color = _iconColors[index % _iconColors.length];

    return GestureDetector( // ← wrap with GestureDetector
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon badge
            Container(
              width: r.spacing(48),
              height: r.spacing(48),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              ),
              child: Icon(Icons.menu_book_rounded,
                  color: color, size: r.fontSize(22)),
            ),
            SizedBox(width: r.spacing(AppDimens.paddingMD)),
            // Course name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.courseName,
                    style: AppTextStyles.titleLarge.copyWith(
                      fontSize: r.fontSize(13),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: r.spacing(2)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.textSecondary, size: r.fontSize(20)),
          ],
        ),
      ),
    );
  }
}