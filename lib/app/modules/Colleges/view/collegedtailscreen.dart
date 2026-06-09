import 'package:flutter/material.dart';
import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';

import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../data/models/modelclass.dart';
import '../../../widgets/commonwidget.dart';
import 'coursesscreen.dart';

class CollegeDetailScreen extends StatefulWidget {
  final College college;
  final bool isSaved;
  final VoidCallback onSave;

  const CollegeDetailScreen({
    super.key,
    required this.college,
    required this.isSaved,
    required this.onSave,
  });

  @override
  State<CollegeDetailScreen> createState() => _CollegeDetailScreenState();
}

class _CollegeDetailScreenState extends State<CollegeDetailScreen> {
  late bool _isSaved;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.isSaved;
  }

  void _toggleSave() {
    setState(() => _isSaved = !_isSaved);
    widget.onSave();
  }

  void _showApplyDialog() {
    final user = MockData.userProfile;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _UserDetailsDialog(
        user: user,
        college: widget.college,
        onProceed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CoursesScreen(college: widget.college),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context); // ← get responsive instance
    final college = widget.college;

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            // Image App Bar
            SliverAppBar(
              expandedHeight: r.value(mobile: 220.0, tablet: 280.0),
              pinned: true,
              backgroundColor: AppColors.backgroundWhite,
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: EdgeInsets.all(r.spacing(AppDimens.paddingSM)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: r.fontSize(AppDimens.iconSM),
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.all(r.spacing(AppDimens.paddingSM)),
                    padding: EdgeInsets.all(r.spacing(AppDimens.paddingSM)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                    ),
                    child: Icon(
                      Icons.share_outlined,
                      size: r.fontSize(AppDimens.iconSM),
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    (college.imageUrl.isNotEmpty)
                        ? Image.network(
                      college.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _imageFallback(),
                    )
                        : _imageFallback(),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0x80000000)],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: r.spacing(AppDimens.paddingMD),
                      right: r.spacing(AppDimens.paddingMD),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: r.spacing(AppDimens.paddingSM + 2),
                          vertical: r.spacing(AppDimens.paddingXS + 1),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                        ),
                        child: Text(
                          college.tags.isNotEmpty
                              ? college.tags.first
                              : 'Public',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: r.fontSize(11),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // College header
                  Padding(
                    padding: EdgeInsets.all(r.spacing(AppDimens.paddingLG)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CollegeAvatar(
                          name: college.name,
                          imageUrl: college.logoUrl,
                          size: r.spacing(AppDimens.avatarLG), // 56 → scaled
                        ),
                        SizedBox(width: r.spacing(AppDimens.paddingMD)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                college.name,
                                style: AppTextStyles.headlineLarge.copyWith(
                                  fontSize: r.fontSize(15),
                                ),
                              ),
                              SizedBox(height: r.spacing(AppDimens.paddingXS)),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: r.fontSize(AppDimens.iconXS - 1),
                                    color: AppColors.textSecondary,
                                  ),
                                  SizedBox(width: r.spacing(3)),
                                  Text(
                                    college.location,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      fontSize: r.fontSize(12),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: r.spacing(AppDimens.paddingSM)),
                              Wrap(
                                spacing: r.spacing(AppDimens.paddingXS + 2),
                                children: [
                                  ...college.tags.map((t) => TagBadge(
                                    label: t,
                                    backgroundColor: AppColors.primarySurface,
                                    textColor: AppColors.primary,
                                  )),
                                  TagBadge(
                                    label: college.established,
                                    backgroundColor: AppColors.backgroundGrey,
                                    textColor: AppColors.textSecondary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Stats
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: r.spacing(AppDimens.paddingLG),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: r.spacing(AppDimens.paddingLG),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundWhite,
                      borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StatItem(
                          value: '${college.yearsEstablished}+',
                          label: 'Years',
                          icon: Icons.calendar_today_rounded,
                        ),
                        _buildDivider(r),
                        StatItem(
                          value: '${college.facultyCount}+',
                          label: 'Faculty',
                          icon: Icons.person_rounded,
                        ),
                        _buildDivider(r),
                        StatItem(
                          value: '${college.courseCount}+',
                          label: 'Courses',
                          icon: Icons.menu_book_rounded,
                        ),
                        _buildDivider(r),
                        StatItem(
                          value: '${college.studentCount}+',
                          label: 'Students',
                          icon: Icons.groups_rounded,
                        ),
                      ],
                    ),
                  ),

                  // About
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      r.spacing(AppDimens.paddingLG),
                      r.spacing(AppDimens.paddingXL - 2),
                      r.spacing(AppDimens.paddingLG),
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About College',
                          style: AppTextStyles.headlineMedium.copyWith(
                            fontSize: r.fontSize(15),
                          ),
                        ),
                        SizedBox(height: r.spacing(AppDimens.paddingSM)),
                        Text(
                          college.about.isNotEmpty
                              ? college.about
                              : 'This is a premier veterinary institute offering world-class education in veterinary science and animal husbandry.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            height: 1.6,
                            fontSize: r.fontSize(13),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: r.spacing(AppDimens.paddingXS + 2),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Read More',
                                  style: AppTextStyles.bodyGreen.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: r.fontSize(13),
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.primary,
                                  size: r.fontSize(AppDimens.iconSM),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Popular Courses
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      r.spacing(AppDimens.paddingLG),
                      r.spacing(AppDimens.paddingXL - 2),
                      r.spacing(AppDimens.paddingLG),
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: 'Popular Courses',
                          actionText: 'View All',
                          onAction: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CoursesScreen(college: college),
                            ),
                          ),
                        ),
                        SizedBox(height: r.spacing(AppDimens.paddingMD)),
                        ...college.popularCourses
                            .map((c) => _buildCourseItem(c, r)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: AppColors.primarySurface,
      child: const Center(
        child: Icon(Icons.school_rounded, size: 80, color: AppColors.primary),
      ),
    );
  }

  Widget _buildDivider(Responsive r) {
    return Container(
      width: 1,
      height: r.spacing(40),
      color: AppColors.borderLight,
    );
  }

  Widget _buildCourseItem(Course course, Responsive r) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CoursesScreen(college: widget.college),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: r.spacing(AppDimens.paddingSM + 2)),
        padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(AppDimens.radiusMD + 2),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              width: r.spacing(AppDimens.avatarMD - 4),  // 44 → scaled
              height: r.spacing(AppDimens.avatarMD - 4),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              ),
              child: Icon(
                Icons.school_rounded,
                color: AppColors.primary,
                size: r.fontSize(AppDimens.iconMD),
              ),
            ),
            SizedBox(width: r.spacing(AppDimens.paddingMD)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    style: AppTextStyles.titleLarge.copyWith(
                      fontSize: r.fontSize(14),
                    ),
                  ),
                  Text(
                    course.fullName,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: r.fontSize(12),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: r.fontSize(AppDimens.iconMD - 2),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserDetailsDialog extends StatelessWidget {
  final UserProfile user;
  final College college;
  final VoidCallback onProceed;

  const _UserDetailsDialog({
    required this.user,
    required this.college,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context); // ← get responsive instance

    return Dialog(
      backgroundColor: AppColors.backgroundWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusXXL),
      ),
      child: Padding(
        padding: EdgeInsets.all(r.spacing(AppDimens.paddingXXL)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header icon
            Container(
              width: r.spacing(AppDimens.avatarLG),   // 64 → scaled
              height: r.spacing(AppDimens.avatarLG),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(AppDimens.radiusLG),
              ),
              child: Icon(
                Icons.person_rounded,
                color: AppColors.primary,
                size: r.fontSize(AppDimens.iconLG),   // 32 → scaled
              ),
            ),
            SizedBox(height: r.spacing(AppDimens.paddingLG)),
            Text(
              'Your Details',
              style: AppTextStyles.headlineLarge.copyWith(
                fontSize: r.fontSize(16),
              ),
            ),
            SizedBox(height: r.spacing(AppDimens.paddingXS)),
            Text(
              'Please confirm your details before applying',
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: r.fontSize(13),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: r.spacing(AppDimens.paddingXL)),

            // Details
            _DetailRow(icon: Icons.person_outline_rounded,  label: 'Name',          value: user.name),
            const AppDivider(height: 1),
            _DetailRow(icon: Icons.email_outlined,          label: 'Email',         value: user.email),
            const AppDivider(height: 1),
            _DetailRow(icon: Icons.phone_outlined,          label: 'Phone',         value: user.phone),
            const AppDivider(height: 1),
            _DetailRow(icon: Icons.map_outlined,            label: 'State',         value: user.state),
            const AppDivider(height: 1),
            _DetailRow(icon: Icons.school_outlined,         label: 'Qualification', value: user.qualification),

            SizedBox(height: r.spacing(AppDimens.paddingXL)),

            // College chip
            Container(
              padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.school_rounded,
                    color: AppColors.primary,
                    size: r.fontSize(AppDimens.iconSM),
                  ),
                  SizedBox(width: r.spacing(AppDimens.paddingSM)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Applying to',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: r.fontSize(12),
                          ),
                        ),
                        Text(
                          college.name,
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: r.fontSize(13),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: r.spacing(AppDimens.paddingXL)),

            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Cancel',
                    isOutlined: true,
                    height: r.spacing(46),
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(width: r.spacing(AppDimens.paddingMD)),
                Expanded(
                  child: AppButton(
                    text: 'Proceed',
                    height: r.spacing(46),
                    onTap: onProceed,
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context); // ← get responsive instance

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: r.spacing(AppDimens.paddingSM + 2),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: r.fontSize(AppDimens.iconXS + 2),
            color: AppColors.primary,
          ),
          SizedBox(width: r.spacing(AppDimens.paddingSM + 2)),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: r.fontSize(12),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.textPrimary,
              fontSize: r.fontSize(13),
            ),
          ),
        ],
      ),
    );
  }
}