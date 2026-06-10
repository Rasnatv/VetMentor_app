import 'package:flutter/material.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../data/models/coursesmodel.dart';
import '../../../widgets/commonwidget.dart';

class CourseDetailScreen extends StatelessWidget {
  final CourseModel course;
  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: VetAppBar(
        title: course.shortName,
        actions: [
          Container(
            margin: const EdgeInsets.only(
                right: AppDimens.paddingMD,
                top: AppDimens.paddingSM,
                bottom: AppDimens.paddingSM),
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(AppDimens.radiusSM),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              icon: const Icon(Icons.bookmark_border_rounded,
                  color: AppColors.textPrimary, size: AppDimens.iconSM),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroBanner(),
            Padding(
              padding: const EdgeInsets.all(AppDimens.paddingLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsGrid(),
                  const SizedBox(height: AppDimens.paddingXL),
                  _buildAboutSection(),
                  const SizedBox(height: AppDimens.paddingXL),
                  _buildSubjectsSection(),
                  const SizedBox(height: AppDimens.paddingXL),
                  _buildCareersSection(),
                  const SizedBox(height: AppDimens.paddingXL),
                  _buildCollegesSection(),
                  const SizedBox(height: AppDimens.paddingXXL),
                  _buildApplyCTA(context),
                  const SizedBox(height: AppDimens.paddingXXXL),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Hero Banner (replaces FlexibleSpaceBar content) ──────────────────────────
  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.heroGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppDimens.paddingLG,
        AppDimens.paddingLG,
        AppDimens.paddingLG,
        AppDimens.paddingXL,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course icon box
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(AppDimens.radiusLG - 2),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: Icon(course.icon,
                color: Colors.white, size: AppDimens.iconLG),
          ),
          const SizedBox(width: AppDimens.paddingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.shortName,
                  style:
                  AppTextStyles.displayWhite.copyWith(fontSize: 17),
                ),
                const SizedBox(height: 3),
                Text(
                  course.fullName,
                  style: AppTextStyles.bodyWhite.copyWith(
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppDimens.paddingSM),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    course.duration,
                    course.eligibility,
                    course.type,
                  ]
                      .map((t) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(
                          AppDimens.radiusFull),
                      border: Border.all(
                          color:
                          Colors.white.withOpacity(0.25)),
                    ),
                    child: Text(t,
                        style: AppTextStyles.bodyWhite.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        )),
                  ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats Grid ───────────────────────────────────────────────────────────────
  Widget _buildStatsGrid() {
    final stats = [
      _StatItem(Icons.access_time_rounded,   'Duration',    course.duration),
      _StatItem(Icons.school_rounded,         'Eligibility', course.eligibility),
      _StatItem(Icons.currency_rupee_rounded, 'Avg fees',    course.feesRange),
      _StatItem(Icons.trending_up_rounded,    'Avg salary',  course.salaryRange),
    ];

    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: AppDimens.paddingSM + 2,
      crossAxisSpacing: AppDimens.paddingSM + 2,
      childAspectRatio: 2.4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: stats.map(_buildStatBox).toList(),
    );
  }

  Widget _buildStatBox(_StatItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingMD,
          vertical: AppDimens.paddingSM + 2),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(item.icon,
                  size: AppDimens.iconXS, color: AppColors.iconSecondary),
              const SizedBox(width: 4),
              Text(item.label,
                  style: AppTextStyles.labelSmall
                      .copyWith(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            item.value,
            style: AppTextStyles.titleLarge.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Section Title helper ─────────────────────────────────────────────────────
  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          ),
        ),
        const SizedBox(width: AppDimens.paddingXS + 2),
        Text(
          title.toUpperCase(),
          style: AppTextStyles.labelSmall.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 0.7,
          ),
        ),
      ],
    );
  }

  // ── About Section ────────────────────────────────────────────────────────────
  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('About this course'),
        const SizedBox(height: AppDimens.paddingSM + 2),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimens.paddingMD),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(AppDimens.radiusMD),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            course.about,
            style: AppTextStyles.bodyMedium.copyWith(height: 1.65),
          ),
        ),
      ],
    );
  }

  // ── Subjects Section ─────────────────────────────────────────────────────────
  Widget _buildSubjectsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Core subjects'),
        const SizedBox(height: AppDimens.paddingSM + 2),
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(AppDimens.radiusMD),
            border: Border.all(color: AppColors.border),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: course.subjects.length,
            separatorBuilder: (_, __) =>
                Divider(height: 1, thickness: 0.5, color: AppColors.borderLight),
            itemBuilder: (_, i) {
              final s = course.subjects[i];
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingMD,
                    vertical: AppDimens.paddingMD - 1),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius:
                        BorderRadius.circular(AppDimens.radiusSM),
                      ),
                      child: Icon(s.icon,
                          size: AppDimens.iconXS + 2,
                          color: AppColors.primary),
                    ),
                    const SizedBox(width: AppDimens.paddingMD),
                    Expanded(
                      child: Text(s.name,
                          style: AppTextStyles.titleMedium),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundGrey,
                        borderRadius:
                        BorderRadius.circular(AppDimens.radiusFull),
                      ),
                      child: Text(s.year,
                          style: AppTextStyles.labelSmall.copyWith(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          )),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Career Opportunities ─────────────────────────────────────────────────────
  Widget _buildCareersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Career opportunities'),
        const SizedBox(height: AppDimens.paddingSM + 2),
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: AppDimens.paddingSM + 2,
          crossAxisSpacing: AppDimens.paddingSM + 2,
          childAspectRatio: 3.0,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: course.careers.map((c) {
            return Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingMD,
                  vertical: AppDimens.paddingSM),
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius:
                      BorderRadius.circular(AppDimens.radiusXS + 2),
                    ),
                    child: Icon(c.icon,
                        size: AppDimens.iconXS + 2,
                        color: AppColors.primary),
                  ),
                  const SizedBox(width: AppDimens.paddingSM),
                  Expanded(
                    child: Text(c.label,
                        style: AppTextStyles.titleSmall.copyWith(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Colleges Section ─────────────────────────────────────────────────────────
  Widget _buildCollegesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _sectionTitle('Colleges offering this course')),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text('View all',
                  style: AppTextStyles.titleGreen.copyWith(fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.paddingSM),
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(AppDimens.radiusMD),
            border: Border.all(color: AppColors.border),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: course.colleges.length,
            separatorBuilder: (_, __) =>
                Divider(height: 1, thickness: 0.5, color: AppColors.borderLight),
            itemBuilder: (_, i) {
              final col = course.colleges[i];
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingMD,
                    vertical: AppDimens.paddingMD - 1),
                child: Row(
                  children: [
                    Container(
                      width: AppDimens.avatarMD - 4,
                      height: AppDimens.avatarMD - 4,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: AppColors.cardGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius:
                        BorderRadius.circular(AppDimens.radiusSM + 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        col.initials,
                        style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimens.paddingMD),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(col.name,
                              style: AppTextStyles.titleMedium
                                  .copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded,
                                  size: 11,
                                  color: AppColors.iconSecondary),
                              const SizedBox(width: 3),
                              Text(col.location,
                                  style: AppTextStyles.bodySmall
                                      .copyWith(fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.paddingMD,
                            vertical: AppDimens.paddingXS + 2),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius:
                          BorderRadius.circular(AppDimens.radiusSM),
                          border:
                          Border.all(color: AppColors.accentLight),
                        ),
                        child: Text('Apply',
                            style: AppTextStyles.titleGreen
                                .copyWith(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Apply CTA ────────────────────────────────────────────────────────────────
  Widget _buildApplyCTA(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppDimens.buttonHeight,
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Application started for ${course.shortName}',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: Colors.white),
              ),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(AppDimens.radiusMD)),
              margin: const EdgeInsets.all(AppDimens.paddingLG),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(AppDimens.buttonRadius)),
          elevation: 0,
        ),
        icon: const Icon(Icons.send_rounded, size: AppDimens.iconSM),
        label: Text('Apply for this course',
            style: AppTextStyles.labelLarge),
      ),
    );
  }
}

// ── Internal helper struct ────────────────────────────────────────────────────
class _StatItem {
  final IconData icon;
  final String label;
  final String value;
  const _StatItem(this.icon, this.label, this.value);
}