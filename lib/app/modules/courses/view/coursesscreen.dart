
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veterinaryapp/app/widgets/commonwidget.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../home/bindings/home_binding.dart';
import '../controller/courses_controller.dart';
import 'coursesdetailscreen.dart';

/// Cycle of accent colours used for the course icon badges — gives the
/// list visual rhythm without relying on data the API doesn't provide.
const List<Color> _kCourseAccents = [
  AppColors.primary,
  Color(0xFF2196F3),
  Color(0xFF4CAF50),
  Color(0xFFFF9800),
  Color(0xFF9C27B0),
];

class CourseListingScreen extends StatelessWidget {
  CourseListingScreen({super.key});

  final CourseController _ctrl = Get.find<CourseController>();

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: VetAppBar(title: 'All Courses'),
      body: Obx(() {
        // ── Decide what goes below the banner ───────────────
        Widget content;
        if (_ctrl.isLoading.value) {
          content = const Center(child: CircularProgressIndicator());
        } else if (_ctrl.hasError.value) {
          content = _ErrorState(r: r, onRetry: _ctrl.fetchCourses);
        } else if (_ctrl.courses.isEmpty) {
          content = _EmptyState(r: r);
        } else {
          content = ListView.separated(
            padding: EdgeInsets.fromLTRB(
              r.spacing(AppDimens.paddingLG),
              0,
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
              onTap: () => Get.to(
                    () => CourseDetailScreen(courseId: _ctrl.courses[i].id),
                binding: CourseDetailBinding(), // ✅
              ),
            ),
          );
        }

        // ── Banner stays put; only the content below it swaps ─
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                r.spacing(AppDimens.paddingLG),
                r.spacing(AppDimens.paddingMD),
                r.spacing(AppDimens.paddingLG),
                0,
              ),
              child: _CourseHeroBanner(
                r: r,
                courseCount: _ctrl.courses.length,
              ),
            ),
            SizedBox(height: r.spacing(AppDimens.paddingMD)),
            Expanded(child: content),
          ],
        );
      }),
    );
  }
}

class _CourseHeroBanner extends StatelessWidget {
  final Responsive r;
  final int courseCount;

  const _CourseHeroBanner({required this.r, required this.courseCount});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusLG),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(r.spacing(AppDimens.paddingLG)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.cardGradient,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -r.spacing(20),
              top: -r.spacing(30),
              child: Container(
                width: r.spacing(110),
                height: r.spacing(110),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              right: r.spacing(40),
              bottom: -r.spacing(45),
              child: Container(
                width: r.spacing(70),
                height: r.spacing(70),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(r.spacing(AppDimens.paddingSM + 2)),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: r.fontSize(AppDimens.iconMD),
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: r.spacing(AppDimens.paddingMD)),
                Text(
                  'Veterinary Courses',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: Colors.white,
                    fontSize: r.fontSize(19),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: r.spacing(AppDimens.paddingXS)),
                Text(
                  'Explore programs designed to grow your veterinary career',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.88),
                    fontSize: r.fontSize(12),
                  ),
                ),
                SizedBox(height: r.spacing(AppDimens.paddingMD)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.spacing(AppDimens.paddingSM + 2),
                    vertical: r.spacing(AppDimens.paddingXS),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: r.fontSize(12),
                        color: Colors.white,
                      ),
                      SizedBox(width: r.spacing(6)),
                      Text(
                        courseCount > 0
                            ? '$courseCount courses available'
                            : 'Browse all courses',
                        style: AppTextStyles.labelSmall.copyWith(
                          fontSize: r.fontSize(11),
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseListTile extends StatelessWidget {
  const _CourseListTile({
    required this.course,
    required this.r,
    required this.index,
    required this.onTap,
  });

  final dynamic course; // CourseModel
  final Responsive r;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _kCourseAccents[index % _kCourseAccents.length];

    return GestureDetector(
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
              blurRadius: 10,
              offset: const Offset(0, 4),
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
              alignment: Alignment.center,
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
                      fontSize: r.fontSize(13.5),
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: r.spacing(4)),
                  Row(
                    children: [
                      Icon(Icons.school_outlined,
                          size: r.fontSize(12), color: AppColors.textSecondary),
                      SizedBox(width: r.spacing(3)),
                      Text(
                        'Veterinary program',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: r.fontSize(11),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: r.spacing(AppDimens.paddingSM)),
            Container(
              padding: EdgeInsets.all(r.spacing(6)),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_forward_rounded,
                  color: color, size: r.fontSize(14)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error state ────────────────────────────────────────────
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.r, required this.onRetry});

  final Responsive r;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: r.spacing(AppDimens.paddingXL)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: r.spacing(72),
              height: r.spacing(72),
              decoration: const BoxDecoration(
                color: AppColors.primarySurface,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.wifi_off_rounded,
                  size: r.fontSize(30), color: AppColors.primary),
            ),
            SizedBox(height: r.spacing(AppDimens.paddingMD)),
            Text(
              'Failed to load courses',
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: r.spacing(6)),
            Text(
              'Check your connection and try again',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: r.fontSize(11.5),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: r.spacing(AppDimens.paddingMD)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: r.spacing(20),
                  vertical: r.spacing(12),
                ),
              ),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ─────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.r});

  final Responsive r;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: r.spacing(72),
            height: r.spacing(72),
            decoration: const BoxDecoration(
              color: AppColors.primarySurface,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.menu_book_outlined,
                size: r.fontSize(28), color: AppColors.primary),
          ),
          SizedBox(height: r.spacing(AppDimens.paddingMD)),
          Text(
            'No courses available',
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: r.spacing(6)),
          Text(
            'Check back later for new programs',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: r.fontSize(11.5),
            ),
          ),
        ],
      ),
    );
  }
}