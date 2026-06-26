
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../no internetconnection/no_connection.dart';
import '../../../widgets/appsnackbar.dart';
import '../../../widgets/commonwidget.dart';
import '../../Saved/controller/whishlist_controller.dart';
import '../controller/enquirycontroller.dart';

class CollegeDetailScreen extends StatefulWidget {
  final String collegeId;
  final bool showBookmark;

  const CollegeDetailScreen({
    super.key,
    required this.collegeId,
    this.showBookmark = true,
  });

  @override
  State<CollegeDetailScreen> createState() => _CollegeDetailScreenState();
}

class _CollegeDetailScreenState extends State<CollegeDetailScreen> {
  late final EnquiryController _ctrl;
  late final WishlistController _wishlistCtrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<EnquiryController>();

    if (widget.showBookmark) {
      _wishlistCtrl = Get.isRegistered<WishlistController>()
          ? Get.find<WishlistController>()
          : Get.put(WishlistController());
    }

    _ctrl.fetchCollegeDetail(widget.collegeId);

    if (widget.showBookmark) {
      final studentId = _ctrl.studentId;
      if (studentId > 0) {
        _wishlistCtrl.fetchWishlist(studentId, silent: true);
      }
    }
  }

  // ── Bookmark tap handler ──────────────────────────────────
  Future<void> _onBookmarkTap() async {
    final studentId = _ctrl.studentId;

    if (studentId <= 0) {
      AppSnackbar.warning('Please complete the enquiry form to save colleges.');
      return;
    }

    await _wishlistCtrl.toggleWishlist(studentId, widget.collegeId);

    final isNowWishlisted = _wishlistCtrl.isWishlisted(widget.collegeId);
    if (isNowWishlisted) {
      AppSnackbar.success('College saved to your wishlist.');
    } else {
      AppSnackbar.warning('College removed from your wishlist.');
    }
  }

  Widget _imageFallback() => Container(
    color: AppColors.primarySurface,
    child: const Center(
      child: Icon(Icons.school_rounded, size: 80, color: AppColors.primary),
    ),
  );

  Widget _buildDivider(Responsive r) => Container(
    width: 1,
    height: r.spacing(40),
    color: AppColors.borderLight,
  );

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Obx(() {
          // ── Loading ──────────────────────────────────────
          if (_ctrl.detailLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_ctrl.detailError.value.isNotEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(r.spacing(AppDimens.paddingXL)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline_rounded,
                        size: r.fontSize(48), color: AppColors.error),
                    SizedBox(height: r.spacing(AppDimens.paddingMD)),
                    Text(
                      _ctrl.detailError.value,
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: r.spacing(AppDimens.paddingMD)),
                    ElevatedButton.icon(
                      onPressed: () =>
                          _ctrl.fetchCollegeDetail(widget.collegeId),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final detail = _ctrl.collegeDetail.value;
          if (detail == null) return const SizedBox.shrink();

          // ── Content ──────────────────────────────────────
          return CustomScrollView(
            slivers: [
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

                // ── Bookmark button ───────────────────────
                actions: [
                  if (widget.showBookmark)
                    Obx(() {
                      final isLoading    = _wishlistCtrl.isLoading(widget.collegeId);
                      final isWishlisted = _wishlistCtrl.isWishlisted(widget.collegeId);

                      return Padding(
                        padding: EdgeInsets.only(
                            right: r.spacing(AppDimens.paddingSM)),
                        child: GestureDetector(
                          onTap: isLoading ? null : _onBookmarkTap,
                          child: Container(
                            width: 36,
                            height: 36,
                            margin: EdgeInsets.all(r.spacing(AppDimens.paddingSM)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(AppDimens.radiusMD),
                            ),
                            child: isLoading
                                ? const Padding(
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            )
                                : Icon(
                              isWishlisted
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_border_rounded,
                              size: r.fontSize(AppDimens.iconSM),
                              color: isWishlisted
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }),
                ],

                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      (detail.imageUrl != null && detail.imageUrl!.isNotEmpty)
                          ? Image.network(
                        detail.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imageFallback(),
                      )
                          : _imageFallback(),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Color(0x80000000),
                            ],
                          ),
                        ),
                      ),
                      if (detail.affiliationType.isNotEmpty)
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
                              borderRadius:
                              BorderRadius.circular(AppDimens.radiusSM),
                            ),
                            child: Text(
                              detail.affiliationType,
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

              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── College Header ────────────────────────
                    Padding(
                      padding: EdgeInsets.all(r.spacing(AppDimens.paddingLG)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail.collegeName,
                            style: AppTextStyles.headlineLarge.copyWith(
                              fontSize: r.fontSize(16),
                            ),
                          ),
                          SizedBox(height: r.spacing(AppDimens.paddingXS)),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined,
                                  size: r.fontSize(AppDimens.iconXS),
                                  color: AppColors.textSecondary),
                              SizedBox(width: r.spacing(AppDimens.paddingXS)),
                              Expanded(
                                child: Text(
                                  detail.fullAddress,
                                  style: AppTextStyles.bodySmall.copyWith(
                                      fontSize: r.fontSize(12)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: r.spacing(AppDimens.paddingSM)),
                          Row(
                            children: [
                              Icon(Icons.star_rounded,
                                  size: r.fontSize(14), color: Colors.amber),
                              SizedBox(width: r.spacing(AppDimens.paddingXS)),
                              Text(
                                detail.rating.toStringAsFixed(1),
                                style: AppTextStyles.titleSmall.copyWith(
                                  fontSize: r.fontSize(13),
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ── Stats Row ─────────────────────────────
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: r.spacing(AppDimens.paddingLG)),
                      padding: EdgeInsets.symmetric(
                          vertical: r.spacing(AppDimens.paddingLG)),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundWhite,
                        borderRadius:
                        BorderRadius.circular(AppDimens.radiusLG),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          StatItem(
                            value: '${detail.years}+',
                            label: 'Years',
                            icon: Icons.calendar_today_rounded,
                          ),
                          _buildDivider(r),
                          StatItem(
                            value: detail.faculty,
                            label: 'Faculty',
                            icon: Icons.person_rounded,
                          ),
                          _buildDivider(r),
                          StatItem(
                            value: detail.students,
                            label: 'Students',
                            icon: Icons.groups_rounded,
                          ),
                          _buildDivider(r),
                          StatItem(
                            value: '${detail.courses.length}',
                            label: 'Courses',
                            icon: Icons.menu_book_rounded,
                          ),
                        ],
                      ),
                    ),

                    // ── Contact Info ──────────────────────────
                    _buildSection(
                      r,
                      title: 'Contact Information',
                      child: Column(
                        children: [
                          _buildContactRow(r,
                              icon: Icons.phone_outlined, label: detail.phone),
                          SizedBox(height: r.spacing(AppDimens.paddingSM)),
                          _buildContactRow(r,
                              icon: Icons.email_outlined, label: detail.email),
                          SizedBox(height: r.spacing(AppDimens.paddingSM)),
                          _buildContactRow(r,
                              icon: Icons.language_outlined,
                              label: detail.website,
                              isLink: true),
                        ],
                      ),
                    ),

                    // ── About ─────────────────────────────────
                    if (detail.about.isNotEmpty)
                      _buildSection(
                        r,
                        title: 'About College',
                        child: _ExpandableText(text: detail.about, r: r),
                      ),

                    // ── Courses ───────────────────────────────
                    if (detail.courses.isNotEmpty)
                      _buildSection(
                        r,
                        title: 'Courses Offered',
                        child: Column(
                          children: detail.courses
                              .map((c) => _buildCourseChip(c, r))
                              .toList(),
                        ),
                      ),

                    // ── Facilities ────────────────────────────
                    if (detail.facilities.isNotEmpty)
                      _buildSection(
                        r,
                        title: 'Facilities',
                        child: Wrap(
                          spacing: r.spacing(AppDimens.paddingSM),
                          runSpacing: r.spacing(AppDimens.paddingSM),
                          children: detail.facilities
                              .map((f) => _buildFacilityChip(f, r))
                              .toList(),
                        ),
                      ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSection(Responsive r,
      {required String title, required Widget child}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        r.spacing(AppDimens.paddingLG),
        r.spacing(AppDimens.paddingXL - 2),
        r.spacing(AppDimens.paddingLG),
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTextStyles.headlineMedium
                  .copyWith(fontSize: r.fontSize(15))),
          SizedBox(height: r.spacing(AppDimens.paddingMD)),
          child,
        ],
      ),
    );
  }

  Widget _buildContactRow(Responsive r,
      {required IconData icon, required String label, bool isLink = false}) {
    return Row(
      children: [
        Icon(icon,
            size: r.fontSize(AppDimens.iconXS + 2), color: AppColors.primary),
        SizedBox(width: r.spacing(AppDimens.paddingSM + 2)),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: r.fontSize(13),
              color: isLink ? AppColors.primary : AppColors.textPrimary,
              decoration:
              isLink ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseChip(String course, Responsive r) {
    return Container(
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
            width: r.spacing(AppDimens.avatarMD - 4),
            height: r.spacing(AppDimens.avatarMD - 4),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(AppDimens.radiusMD),
            ),
            child: Icon(Icons.school_rounded,
                color: AppColors.primary,
                size: r.fontSize(AppDimens.iconMD)),
          ),
          SizedBox(width: r.spacing(AppDimens.paddingMD)),
          Expanded(
            child: Text(
              course,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: r.fontSize(13),
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityChip(String facility, Responsive r) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.spacing(AppDimens.paddingMD),
        vertical: r.spacing(AppDimens.paddingSM),
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(AppDimens.radiusSM + 2),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Text(
        facility,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: r.fontSize(12),
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ExpandableText extends StatefulWidget {
  final String text;
  final Responsive r;

  const _ExpandableText({required this.text, required this.r});

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.r;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            widget.text,
            style: AppTextStyles.bodyMedium
                .copyWith(height: 1.6, fontSize: r.fontSize(13)),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          secondChild: Text(
            widget.text,
            style: AppTextStyles.bodyMedium
                .copyWith(height: 1.6, fontSize: r.fontSize(13)),
          ),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: EdgeInsets.only(top: r.spacing(AppDimens.paddingXS + 2)),
            child: Row(
              children: [
                Text(
                  _expanded ? 'Show Less' : 'Read More',
                  style: AppTextStyles.bodyGreen.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: r.fontSize(13),
                  ),
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.primary,
                  size: r.fontSize(AppDimens.iconSM),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}