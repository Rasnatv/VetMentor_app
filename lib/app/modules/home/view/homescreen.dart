
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veterinaryapp/app/modules/home/view/search_screen.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../data/models/collegelistmodel.dart';
import '../../../data/models/coursemodel.dart';
import '../../../no internetconnection/no_connection.dart';
import '../../../widgets/collegecard.dart';
import '../../../widgets/commonwidget.dart';
import '../../Colleges/controller/college_controller.dart';
import '../../Colleges/controller/enquirycontroller.dart';
import '../../Colleges/view/Enquiry_form.dart';
import '../../Colleges/view/allcollegelistingscreen.dart';
import '../../Colleges/view/collegedtailscreen.dart';
import '../../courses/view/coursesdetailscreen.dart';
import '../../courses/view/coursesscreen.dart';
import '../../courses/courses_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollegeController _ctrl = Get.put(CollegeController());
  final EnquiryController _enquiryCtrl = Get.put(EnquiryController());
  final CourseController _courseCtrl = Get.put(CourseController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      _ctrl.onSearchChanged(_searchCtrl.text);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Navigation: tap college card ──────────────────────────
  void _openCollegeDetail(CollegeModel college) {
    final bool shouldSkip;

    if (Platform.isIOS) {
      shouldSkip =
          _enquiryCtrl.isAlreadyRegistered || !college.isEnquiryRequired;
    } else {
      shouldSkip = _enquiryCtrl.isAlreadyRegistered;
    }

    if (shouldSkip) {
      _pushDetail(college);
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EnquiryBottomSheet(
        college: college,
        onProceed: () => _pushDetail(college),
      ),
    );
  }

  // UPDATED: Pass only the college ID to the detail screen
  void _pushDetail(CollegeModel college) {
    Get.to(() => const CollegeDetailScreen(), arguments: college.id);
  }

  // ── Navigation: tap course card ───────────────────────────
  void _openCourseDetail(CourseModel course) {
    Get.to(() => CourseDetailScreen(courseId: course.id));
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return NetworkAwareWrapper(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // ── App Bar ──────────────────────────────────
              SliverToBoxAdapter(child: _buildAppBar(r)),

              // ── Search ───────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    r.spacing(AppDimens.paddingLG),
                    r.spacing(AppDimens.paddingLG),
                    r.spacing(AppDimens.paddingLG),
                    0,
                  ),
                  child:
                  GestureDetector(
                    onTap: () => Get.to(() => const SearchScreen()),
                    child: AbsorbPointer(
                      child: AppSearchBar(
                        hintText: 'Search colleges, courses, locations...',
                        controller: _searchCtrl,
                        onChanged: (_) {},
                      ),
                    ),
                  ),
                  // AppSearchBar(
                  //   hintText: 'Search colleges, courses, locations...',
                  //   controller: _searchCtrl,
                  //   onChanged: _ctrl.onSearchChanged,
                  // ),
                ),
              ),

              // ── Hero Banner ──────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    r.spacing(AppDimens.paddingLG),
                    r.spacing(AppDimens.paddingLG),
                    r.spacing(AppDimens.paddingLG),
                    0,
                  ),
                  child: _buildHeroBanner(r),
                ),
              ),

              // ── Recommended Section (Only BVSc Courses) ──────────────
              Obx(() {
                if (_courseCtrl.isLoading.value) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                if (_courseCtrl.hasError.value) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }

                // Filter only BVSc courses
                final bvscCourses = _courseCtrl.courses
                    .where((course) =>
                course.courseName.toLowerCase().contains('bvsc') ||
                    course.courseName.toLowerCase().contains('b.v.sc') ||
                    course.courseName
                        .toLowerCase()
                        .contains('bachelor of veterinary science'))
                    .toList();

                if (bvscCourses.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }

                return SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      r.spacing(AppDimens.paddingLG),
                      r.spacing(AppDimens.paddingXL),
                      r.spacing(AppDimens.paddingLG),
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: 'Recommended For You',
                          actionText: 'View All',
                          onAction: () => Get.to(() => CourseListingScreen()),
                        ),
                        SizedBox(height: r.spacing(AppDimens.paddingMD)),
                        ...bvscCourses.map((course) => Padding(
                          padding: EdgeInsets.only(
                              bottom: r.spacing(AppDimens.paddingMD)),
                          child: _buildCourseCard(course, r),
                        )),
                      ],
                    ),
                  ),
                );
              }),

              // ── Section Header: Top Colleges ─────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    r.spacing(AppDimens.paddingLG),
                    r.spacing(AppDimens.paddingXL),
                    r.spacing(AppDimens.paddingLG),
                    0,
                  ),
                  child: SectionHeader(
                    title: 'Top Veterinary Colleges',
                    actionText: 'View All',
                    onAction: () => Get.to(() => CollegeListScreen()),
                  ),
                ),
              ),

              // ── College List ─────────────────────────────
              Obx(() {
                if (_ctrl.isLoading) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (_ctrl.hasError) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildErrorState(r),
                  );
                }

                final list = _ctrl.filteredColleges.take(5).toList();

                if (list.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        'No colleges found.',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    r.spacing(AppDimens.paddingLG),
                    r.spacing(AppDimens.paddingMD),
                    r.spacing(AppDimens.paddingLG),
                    100,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (ctx, i) {
                        final college = list[i];
                        return Padding(
                          padding: EdgeInsets.only(bottom: r.spacing(AppDimens.paddingMD)),
                          child:
                          CollegeCard(
                            collegeName: college.collegeName,
                            location: college.location,
                            onTap: () => _openCollegeDetail(college),
                          ),
                        );
                      },
                      childCount: list.length,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ── Course Card Widget ────────────────────────────────────
  Widget _buildCourseCard(CourseModel course, Responsive r) {
    return GestureDetector(
      onTap: () => _openCourseDetail(course),
      child: Container(
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
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left side - Icon
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(AppDimens.radiusLG),
                ),
                child: Container(
                  width: r.value(
                    mobile: r.spacing(100),
                    tablet: r.spacing(120),
                  ),
                  color: AppColors.primarySurface,
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: AppColors.primary,
                    size: r.fontSize(AppDimens.avatarMD),
                  ),
                ),
              ),
              // Right side - Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        course.courseName,
                        style: AppTextStyles.titleLarge.copyWith(
                          fontSize: r.fontSize(14),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: r.spacing(AppDimens.paddingSM)),
                    ],
                  ),
                ),
              ),
              // Arrow indicator
              Padding(
                padding: EdgeInsets.only(right: r.spacing(AppDimens.paddingMD)),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                  size: r.fontSize(20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Sub-widgets ───────────────────────────────────────────

  Widget _buildErrorState(Responsive r) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded,
              size: r.fontSize(48), color: AppColors.textSecondary),
          SizedBox(height: r.spacing(AppDimens.paddingMD)),
          Text(_ctrl.errorMessage.value, style: AppTextStyles.bodyMedium),
          SizedBox(height: r.spacing(AppDimens.paddingMD)),
          ElevatedButton.icon(
            onPressed: () => _ctrl.fetchColleges(forceRefresh: true),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(Responsive r) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        r.spacing(AppDimens.paddingLG),
        r.spacing(AppDimens.paddingMD),
        r.spacing(AppDimens.paddingLG),
        0,
      ),
      child: Row(
        children: [
          SizedBox(width: r.spacing(AppDimens.paddingMD)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, Vet Aspirant! 👋',
                  style: AppTextStyles.headlineLarge.copyWith(
                    fontSize: r.fontSize(15),
                  ),
                ),
                Text(
                  'What would you like to explore today?',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: r.fontSize(12),
                  ),
                ),
              ],
            ),
          ),
          // GestureDetector(
          //   onTap: () {},
          //   child: Container(
          //     width: r.spacing(AppDimens.avatarSM),
          //     height: r.spacing(AppDimens.avatarSM),
          //     decoration: BoxDecoration(
          //       color: AppColors.backgroundGrey,
          //       borderRadius: BorderRadius.circular(AppDimens.radiusMD),
          //       border: Border.all(color: AppColors.border),
          //     ),
          //     child: Stack(
          //       children: [
          //         Center(
          //           child: Icon(
          //             Icons.notifications_outlined,
          //             color: AppColors.textPrimary,
          //             size: r.fontSize(AppDimens.iconSM),
          //           ),
          //         ),
          //         Positioned(
          //           top: r.spacing(AppDimens.paddingSM),
          //           right: r.spacing(AppDimens.paddingSM),
          //           child: Container(
          //             width: r.spacing(8),
          //             height: r.spacing(8),
          //             decoration: const BoxDecoration(
          //               color: AppColors.error,
          //               shape: BoxShape.circle,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(Responsive r) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.cardGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: r.spacing(100),
              height: r.spacing(100),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            right: 60,
            child: Container(
              width: r.spacing(80),
              height: r.spacing(80),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(r.spacing(AppDimens.paddingXL)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Build a Better Future\nFor Animals',
                        style: AppTextStyles.displayWhite.copyWith(
                          fontSize: r.fontSize(18),
                        ),
                      ),
                      SizedBox(height: r.spacing(AppDimens.paddingSM)),
                      Text(
                        'Explore top veterinary colleges\nand programs in India.',
                        style: AppTextStyles.bodyWhite.copyWith(
                          color: Colors.white70,
                          fontSize: r.fontSize(12),
                        ),
                      ),
                      SizedBox(height: r.spacing(AppDimens.paddingMD)),
                    ],
                  ),
                ),
                Icon(
                  Icons.pets_rounded,
                  color: Colors.white38,
                  size: r.value(
                    mobile: r.fontSize(AppDimens.avatarXL),
                    tablet: r.fontSize(96),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
