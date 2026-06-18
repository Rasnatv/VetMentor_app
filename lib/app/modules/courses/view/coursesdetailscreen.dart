
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veterinaryapp/app/widgets/commonwidget.dart';

import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../data/models/coursedetailmodel.dart';
import '../../../no internetconnection/no_connection.dart';
import '../../Colleges/controller/course_detailcontroller.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late final CourseDetailController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(CourseDetailController());
    _ctrl.fetchCourseDetail(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: VetAppBar(title: 'Course Details'),
        body: Obx(() {
          if (_ctrl.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (_ctrl.hasError.value) return _buildErrorState(r);
          final course = _ctrl.courseDetail.value;
          if (course == null) return _buildEmptyState(r);
          return _buildContent(r, course);
        }),
      ),
    );
  }

  // ── Main content ──────────────────────────────────────────
  Widget _buildContent(Responsive r, CourseDetailModel course) {
    return RefreshIndicator(
      onRefresh: () => _ctrl.fetchCourseDetail(widget.courseId),
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Banner ──────────────────────────────
            _buildHeroBanner(r, course),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: r.spacing(AppDimens.paddingLG),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: r.spacing(AppDimens.paddingLG)),

                  // ── Duration card ────────────────────
                  _buildInfoCard(
                    r,
                    icon: Icons.schedule_rounded,
                    label: 'Duration',
                    value: course.duration,
                    iconBgColor: const Color(0xFFE8F5E9),
                    iconColor: const Color(0xFF2E7D32),
                  ),

                  SizedBox(height: r.spacing(AppDimens.paddingMD)),

                  // ── Eligibility card ─────────────────
                  _buildInfoCard(
                    r,
                    icon: Icons.verified_rounded,
                    label: 'Eligibility',
                    value: course.eligibility,
                    iconBgColor: const Color(0xFFE3F2FD),
                    iconColor: const Color(0xFF1565C0),
                  ),

                  SizedBox(height: r.spacing(AppDimens.paddingXL)),

                  // ── About section ────────────────────
                  _buildSectionHeader(r, 'About the Course'),

                  SizedBox(height: r.spacing(AppDimens.paddingMD)),

                  ..._buildAboutCourse(r, course.aboutCourse),

                  SizedBox(height: r.spacing(AppDimens.paddingXL + 20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Hero banner ───────────────────────────────────────────
  Widget _buildHeroBanner(Responsive r, CourseDetailModel course) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.78),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        r.spacing(AppDimens.paddingLG),
        r.spacing(AppDimens.paddingXL),
        r.spacing(AppDimens.paddingLG),
        r.spacing(AppDimens.paddingXL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: r.spacing(AppDimens.paddingMD),
              vertical: r.spacing(AppDimens.paddingXS),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(AppDimens.radiusSM),
            ),
            child: Text(
              'COURSE OVERVIEW',
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white,
                fontSize: r.fontSize(9),
                letterSpacing: 1.4,
              ),
            ),
          ),
          SizedBox(height: r.spacing(AppDimens.paddingMD)),
          Text(
            course.courseName,
            style: AppTextStyles.displayWhite.copyWith(
              fontSize: r.fontSize(21),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  // ── Info card — full width, text wraps fully ──────────────
  Widget _buildInfoCard(
      Responsive r, {
        required IconData icon,
        required String label,
        required String value,
        required Color iconBgColor,
        required Color iconColor,
      }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon container
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(AppDimens.radiusSM),
            ),
            child: Icon(
              icon,
              size: r.fontSize(20),
              color: iconColor,
            ),
          ),

          SizedBox(width: r.spacing(AppDimens.paddingMD)),

          // Label + value — expands to fill remaining width
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: r.fontSize(10),
                    color: AppColors.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: r.spacing(AppDimens.paddingXS)),
                Text(
                  value,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: r.fontSize(13),
                    color: AppColors.textPrimary,
                    height: 1.55,
                  ),
                  // No maxLines — text wraps fully
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Section header with accent bar ───────────────────────
  Widget _buildSectionHeader(Responsive r, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: r.fontSize(18),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: r.spacing(AppDimens.paddingMD)),
        Text(
          title,
          style: AppTextStyles.headlineMedium.copyWith(
            fontSize: r.fontSize(15),
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // ── About course paragraphs & bullets ────────────────────
  List<Widget> _buildAboutCourse(Responsive r, List<String> lines) {
    final widgets = <Widget>[];

    for (final line in lines) {
      if (line.trim().isEmpty) continue;

      final isBullet = line.trim().startsWith('•');
      final isHeader = line.trim().endsWith(':-');

      if (isHeader) {
        widgets.add(
          Padding(
            padding: EdgeInsets.only(
              top: r.spacing(AppDimens.paddingLG),
              bottom: r.spacing(AppDimens.paddingXS),
            ),
            child: Text(
              line.trim(),
              style: AppTextStyles.titleLarge.copyWith(
                fontSize: r.fontSize(13),
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      } else if (isBullet) {
        widgets.add(
          Padding(
            padding: EdgeInsets.only(
              bottom: r.spacing(AppDimens.paddingXS + 2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: r.fontSize(5)),
                  child: Container(
                    width: r.fontSize(6),
                    height: r.fontSize(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(width: r.spacing(AppDimens.paddingMD)),
                Expanded(
                  child: Text(
                    line.replaceFirst('•', '').trim(),
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: r.fontSize(13),
                      color: AppColors.textPrimary,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        widgets.add(
          Padding(
            padding: EdgeInsets.only(
              bottom: r.spacing(AppDimens.paddingMD),
            ),
            child: Text(
              line.trim(),
              style: AppTextStyles.bodyLarge.copyWith(
                fontSize: r.fontSize(13),
                color: AppColors.textPrimary,
                height: 1.7,
              ),
            ),
          ),
        );
      }
    }

    return widgets;
  }

  // ── Empty state ───────────────────────────────────────────
  Widget _buildEmptyState(Responsive r) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.menu_book_outlined,
              size: r.fontSize(40),
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
          ),
          SizedBox(height: r.spacing(AppDimens.paddingLG)),
          Text(
            'No Course Details Found',
            style: AppTextStyles.headlineSmall.copyWith(
              fontSize: r.fontSize(15),
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: r.spacing(AppDimens.paddingXS)),
          Text(
            'This course has no information yet.',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: r.fontSize(12),
            ),
          ),
        ],
      ),
    );
  }

  // ── Error state ───────────────────────────────────────────
  Widget _buildErrorState(Responsive r) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(r.spacing(AppDimens.paddingXL)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: r.fontSize(40),
                color: Colors.red.shade400,
              ),
            ),
            SizedBox(height: r.spacing(AppDimens.paddingLG)),
            Text(
              'Something Went Wrong',
              style: AppTextStyles.headlineSmall.copyWith(
                fontSize: r.fontSize(15),
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: r.spacing(AppDimens.paddingXS)),
            Text(
              'Failed to load course details.\nPlease check your connection.',
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: r.fontSize(12),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: r.spacing(AppDimens.paddingXL)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _ctrl.fetchCourseDetail(widget.courseId),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: r.spacing(AppDimens.paddingMD),
                  ),
                  textStyle: AppTextStyles.labelLarge.copyWith(
                    fontSize: r.fontSize(13),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(AppDimens.buttonRadius),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}