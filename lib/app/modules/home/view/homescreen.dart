//
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../core/constants/appcolors.dart';
// import '../../../core/style/dimens.dart';
// import '../../../core/style/textstyle.dart';
// import '../../../core/utils/responsive utiliteclass.dart';
// import '../../../data/models/collegelistmodel.dart';
// import '../../../data/models/coursemodel.dart';
// import '../../../no internetconnection/no_connection.dart';
// import '../../../widgets/collegecard.dart';
// import '../../../widgets/commonwidget.dart';
// import '../../../widgets/shimmer_widget.dart';
// import '../../Colleges/controller/college_controller.dart';
// import '../../Colleges/controller/enquirycontroller.dart';
// import '../../Colleges/view/Enquiry_form.dart';
// import '../../Colleges/view/allcollegelistingscreen.dart';
// import '../../Colleges/view/collegedtailscreen.dart';
// import '../../courses/view/coursesdetailscreen.dart';
// import '../../courses/view/coursesscreen.dart';
// import '../../courses/controller/courses_controller.dart';
// import 'search_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen>
//     with SingleTickerProviderStateMixin {
//   final CollegeController _ctrl = Get.put(CollegeController());
//   final EnquiryController _enquiryCtrl = Get.put(EnquiryController());
//   final CourseController _courseCtrl = Get.put(CourseController());
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final TextEditingController _searchCtrl = TextEditingController();
//
//   // Fade-in controller for the real content
//   late final AnimationController _fadeCtrl;
//   late final Animation<double> _fadeAnim;
//   bool _contentVisible = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _fadeCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
//
//     _searchCtrl.addListener(() {
//       _ctrl.onSearchChanged(_searchCtrl.text);
//     });
//
//     // ✅ Reset fade when loading starts again (reconnect), fade in when done
//     ever(_ctrl.topCollegesLoading, (bool loading) {
//       if (loading) {
//         _contentVisible = false;
//         _fadeCtrl.reset();
//       } else if (!_contentVisible) {
//         _contentVisible = true;
//         _fadeCtrl.forward();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _searchCtrl.dispose();
//     _fadeCtrl.dispose();
//     super.dispose();
//   }
//
//   // ── Navigation helpers ────────────────────────────────────
//
//   void _openCollegeDetail(CollegeModel college) {
//     final bool shouldSkip = Platform.isIOS
//         ? _enquiryCtrl.isAlreadyRegistered || !college.isEnquiryRequired
//         : _enquiryCtrl.isAlreadyRegistered;
//
//     if (shouldSkip) {
//       _pushDetail(college);
//       return;
//     }
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) =>
//           EnquiryBottomSheet(
//             college: college,
//             onProceed: () => _pushDetail(college),
//           ),
//     );
//   }
//
//   void _pushDetail(CollegeModel college) =>
//       Get.to(
//             () => CollegeDetailScreen(collegeId: college.id),
//         transition: Transition.rightToLeft,
//       );
//
//   void _openCourseDetail(CourseModel course) =>
//       Get.to(() => CourseDetailScreen(courseId: course.id));
//
//   @override
//   Widget build(BuildContext context) {
//     final r = Responsive.of(context);
//
//     return NetworkAwareWrapper(
//       child: Scaffold(
//         key: _scaffoldKey,
//         backgroundColor: AppColors.background,
//         body: Obx(() {
//           final isLoading = _ctrl.topCollegesLoading.value ||
//               _courseCtrl.isLoading.value;
//
//           // ── Shimmer phase ─────────────────────────────────
//           if (isLoading) {
//             return const HomeScreenShimmer();
//           }
//
//           // ── Real content (fades in) ───────────────────────
//           return FadeTransition(
//             opacity: _fadeAnim,
//             child: SafeArea(
//               child: RefreshIndicator(
//                 onRefresh: _onRefresh,
//               child: CustomScrollView(
//                 slivers: [
//                   SliverToBoxAdapter(child: _buildAppBar(r)),
//                   SliverToBoxAdapter(child: _buildSearchBar(r)),
//                   SliverToBoxAdapter(child: _buildHeroBanner(r)),
//                   _buildSavedCollegesSliver(r),
//                   _buildRecommendedSliver(r),
//                   _buildTopCollegesHeader(r),
//                   _buildTopCollegesSliver(r),
//                 ],
//               ),
//             ),
//           ));
//         }),
//       ),
//     );
//   }
//
//
//   Widget _buildSearchBar(Responsive r) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(
//         r.spacing(AppDimens.paddingLG),
//         r.spacing(AppDimens.paddingLG),
//         r.spacing(AppDimens.paddingLG),
//         0,
//       ),
//       child: GestureDetector(
//         onTap: () => Get.to(() => const SearchScreen()),
//         child: AbsorbPointer(
//           child: AppSearchBar(
//             hintText: 'Search colleges, courses, locations...',
//             controller: _searchCtrl,
//             onChanged: (_) {},
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSavedCollegesSliver(Responsive r) {
//     final saved = _ctrl.savedColleges;
//     if (saved.isEmpty)
//       return const SliverToBoxAdapter(child: SizedBox.shrink());
//
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: EdgeInsets.fromLTRB(
//           r.spacing(AppDimens.paddingLG),
//           r.spacing(AppDimens.paddingXL),
//           r.spacing(AppDimens.paddingLG),
//           0,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SectionHeader(
//               title: 'Saved Colleges',
//               actionText: 'View All',
//               onAction: () => Get.to(() => CollegeListScreen()),
//             ),
//             SizedBox(height: r.spacing(AppDimens.paddingMD)),
//             SizedBox(
//               height: r.spacing(110),
//               child: ListView.separated(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: saved.length,
//                 separatorBuilder: (_, __) =>
//                     SizedBox(width: r.spacing(AppDimens.paddingMD)),
//                 itemBuilder: (_, i) => _buildSavedCollegeChip(saved[i], r),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRecommendedSliver(Responsive r) {
//     if (_courseCtrl.hasError.value) {
//       return const SliverToBoxAdapter(child: SizedBox.shrink());
//     }
//
//     final bvscCourses = _courseCtrl.courses
//         .where((c) =>
//     c.courseName.toLowerCase().contains('bvsc') ||
//         c.courseName.toLowerCase().contains('b.v.sc') ||
//         c.courseName.toLowerCase().contains('bachelor of veterinary science'))
//         .toList();
//
//     if (bvscCourses.isEmpty) {
//       return const SliverToBoxAdapter(child: SizedBox.shrink());
//     }
//
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: EdgeInsets.fromLTRB(
//           r.spacing(AppDimens.paddingLG),
//           r.spacing(AppDimens.paddingXL),
//           r.spacing(AppDimens.paddingLG),
//           0,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SectionHeader(
//               title: 'Recommended For You',
//               actionText: 'View All',
//               onAction: () => Get.to(() => CourseListingScreen()),
//             ),
//             SizedBox(height: r.spacing(AppDimens.paddingMD)),
//             ...bvscCourses.map((course) =>
//                 Padding(
//                   padding:
//                   EdgeInsets.only(bottom: r.spacing(AppDimens.paddingMD)),
//                   child: _buildCourseCard(course, r),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTopCollegesHeader(Responsive r) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: EdgeInsets.fromLTRB(
//           r.spacing(AppDimens.paddingLG),
//           r.spacing(AppDimens.paddingXL),
//           r.spacing(AppDimens.paddingLG),
//           0,
//         ),
//         child: SectionHeader(
//           title: 'Top Veterinary Colleges',
//           actionText: 'View All',
//           onAction: () => Get.to(() => CollegeListScreen()),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTopCollegesSliver(Responsive r) {
//     if (_ctrl.topCollegesError.value) {
//       return SliverFillRemaining(
//         hasScrollBody: false,
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(Icons.wifi_off_rounded,
//                   size: r.fontSize(48), color: AppColors.textSecondary),
//               SizedBox(height: r.spacing(AppDimens.paddingMD)),
//               Text('Failed to load colleges',
//                   style: AppTextStyles.bodyMedium),
//               SizedBox(height: r.spacing(AppDimens.paddingMD)),
//               ElevatedButton.icon(
//                 onPressed: _ctrl.fetchTopCollegesFromApi,
//                 icon: const Icon(Icons.refresh),
//                 label: const Text('Retry'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     if (_ctrl.topColleges.isEmpty) {
//       return SliverFillRemaining(
//         hasScrollBody: false,
//         child: Center(
//             child: Text('No colleges found.',
//                 style: AppTextStyles.bodyMedium)),
//       );
//     }
//
//     return SliverPadding(
//       padding: EdgeInsets.fromLTRB(
//         r.spacing(AppDimens.paddingLG),
//         r.spacing(AppDimens.paddingMD),
//         r.spacing(AppDimens.paddingLG),
//         100,
//       ),
//       sliver: SliverList(
//         delegate: SliverChildBuilderDelegate(
//               (ctx, i) {
//             final college = _ctrl.topColleges[i];
//             return Padding(
//               padding:
//               EdgeInsets.only(bottom: r.spacing(AppDimens.paddingMD)),
//               child: CollegeCard(
//                 collegeName: college.collegeName,
//                 location: college.location,
//                 onTap: () => _openCollegeDetail(college),
//               ),
//             );
//           },
//           childCount: _ctrl.topColleges.length,
//         ),
//       ),
//     );
//   }
//
//   // ════════════════════════════════════════════════════════
//   // CARD / WIDGET BUILDERS  (unchanged from original)
//   // ════════════════════════════════════════════════════════
//
//   Widget _buildSavedCollegeChip(CollegeModel college, Responsive r) {
//     return GestureDetector(
//       onTap: () => _openCollegeDetail(college),
//       child: Container(
//         width: r.spacing(160),
//         padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
//         decoration: BoxDecoration(
//           color: AppColors.cardBackground,
//           borderRadius: BorderRadius.circular(AppDimens.radiusLG),
//           border: Border.all(color: AppColors.borderLight),
//           boxShadow: [
//             BoxShadow(
//                 color: AppColors.shadowLight,
//                 blurRadius: 6,
//                 offset: const Offset(0, 2)),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.bookmark_rounded,
//                     color: AppColors.primary, size: r.fontSize(16)),
//                 const Spacer(),
//                 GestureDetector(
//                   onTap: () => _ctrl.toggleSave(college),
//                   child: Icon(Icons.close_rounded,
//                       color: AppColors.textSecondary, size: r.fontSize(16)),
//                 ),
//               ],
//             ),
//             SizedBox(height: r.spacing(AppDimens.paddingSM)),
//             Text(college.collegeName,
//                 style: AppTextStyles.titleLarge
//                     .copyWith(fontSize: r.fontSize(12)),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis),
//             SizedBox(height: r.spacing(4)),
//             Row(
//               children: [
//                 Icon(Icons.location_on_outlined,
//                     size: r.fontSize(11), color: AppColors.textSecondary),
//                 SizedBox(width: r.spacing(2)),
//                 Expanded(
//                   child: Text(college.location,
//                       style: AppTextStyles.bodySmall.copyWith(
//                           fontSize: r.fontSize(10),
//                           color: AppColors.textSecondary),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCourseCard(CourseModel course, Responsive r) {
//     return GestureDetector(
//       onTap: () => _openCourseDetail(course),
//       child: Container(
//         decoration: BoxDecoration(
//           color: AppColors.cardBackground,
//           borderRadius: BorderRadius.circular(AppDimens.radiusLG),
//           border: Border.all(color: AppColors.borderLight),
//           boxShadow: [
//             BoxShadow(
//                 color: AppColors.shadowLight,
//                 blurRadius: 6,
//                 offset: const Offset(0, 2)),
//           ],
//         ),
//         child: IntrinsicHeight(
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.horizontal(
//                     left: Radius.circular(AppDimens.radiusLG)),
//                 child: Container(
//                   width: r.value(
//                       mobile: r.spacing(100), tablet: r.spacing(120)),
//                   color: AppColors.primarySurface,
//                   child: Icon(Icons.menu_book_rounded,
//                       color: AppColors.primary,
//                       size: r.fontSize(AppDimens.avatarMD)),
//                 ),
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(course.courseName,
//                           style: AppTextStyles.titleLarge
//                               .copyWith(fontSize: r.fontSize(14)),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis),
//                       SizedBox(height: r.spacing(AppDimens.paddingSM)),
//                     ],
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding:
//                 EdgeInsets.only(right: r.spacing(AppDimens.paddingMD)),
//                 child: Icon(Icons.chevron_right_rounded,
//                     color: AppColors.textSecondary, size: r.fontSize(20)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAppBar(Responsive r) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(r.spacing(AppDimens.paddingLG),
//           r.spacing(AppDimens.paddingMD), r.spacing(AppDimens.paddingLG), 0),
//       child: Row(
//         children: [
//           SizedBox(width: r.spacing(AppDimens.paddingMD)),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Hello, Vet Aspirant! 👋',
//                     style: AppTextStyles.headlineLarge
//                         .copyWith(fontSize: r.fontSize(15))),
//                 Text('What would you like to explore today?',
//                     style: AppTextStyles.bodyMedium
//                         .copyWith(fontSize: r.fontSize(12))),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeroBanner(Responsive r) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(r.spacing(AppDimens.paddingLG),
//           r.spacing(AppDimens.paddingLG), r.spacing(AppDimens.paddingLG), 0),
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: AppColors.cardGradient,
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(AppDimens.radiusXL),
//         ),
//         child: Stack(
//           children: [
//             Positioned(
//               top: -20,
//               right: -20,
//               child: Container(
//                 width: r.spacing(100),
//                 height: r.spacing(100),
//                 decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.08),
//                     shape: BoxShape.circle),
//               ),
//             ),
//             Positioned(
//               bottom: -30,
//               right: 60,
//               child: Container(
//                 width: r.spacing(80),
//                 height: r.spacing(80),
//                 decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.06),
//                     shape: BoxShape.circle),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(r.spacing(AppDimens.paddingXL)),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text('Build a Better Future\nFor Animals',
//                             style: AppTextStyles.displayWhite
//                                 .copyWith(fontSize: r.fontSize(18))),
//                         SizedBox(height: r.spacing(AppDimens.paddingSM)),
//                         Text(
//                             'Explore top veterinary colleges\nand programs in India.',
//                             style: AppTextStyles.bodyWhite.copyWith(
//                                 color: Colors.white70,
//                                 fontSize: r.fontSize(12))),
//                         SizedBox(height: r.spacing(AppDimens.paddingMD)),
//                       ],
//                     ),
//                   ),
//                   Icon(Icons.pets_rounded,
//                       color: Colors.white38,
//                       size: r.value(
//                           mobile: r.fontSize(AppDimens.avatarXL),
//                           tablet: r.fontSize(96))),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _onRefresh() async {
//     await Future.wait([
//       _ctrl.fetchTopCollegesFromApi(),
//       _courseCtrl.fetchCourses(),
//     ]);
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../data/models/collegelistmodel.dart';
import '../../../data/models/coursemodel.dart';
import '../../../no internetconnection/no_connection.dart';
import '../../../widgets/collegecard.dart';
import '../../../widgets/commonwidget.dart';
import '../../../widgets/shimmer_widget.dart';
import '../../Colleges/controller/college_controller.dart';
import '../../Colleges/controller/enquirycontroller.dart';
import '../../Colleges/view/Enquiry_form.dart';
import '../../Colleges/view/allcollegelistingscreen.dart';
import '../../Colleges/view/collegedtailscreen.dart';
import '../../courses/view/coursesdetailscreen.dart';
import '../../courses/view/coursesscreen.dart';
import '../../courses/controller/courses_controller.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final CollegeController _ctrl = Get.put(CollegeController());
  final EnquiryController _enquiryCtrl = Get.put(EnquiryController());
  final CourseController _courseCtrl = Get.put(CourseController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchCtrl = TextEditingController();

  // Fade-in controller for the real content
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;
  bool _contentVisible = false;

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);

    _searchCtrl.addListener(() {
      _ctrl.onSearchChanged(_searchCtrl.text);
    });

    // ✅ Reset fade when loading starts again (reconnect), fade in when done
    ever(_ctrl.topCollegesLoading, (bool loading) {
      if (loading) {
        _contentVisible = false;
        _fadeCtrl.reset();
      } else if (!_contentVisible) {
        _contentVisible = true;
        _fadeCtrl.forward();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Navigation helpers ────────────────────────────────────

  void _openCollegeDetail(CollegeModel college) {
    // ✅ Single source of truth — all platform + registration + type logic
    // lives inside shouldShowEnquiryForm()
    //
    // Android not registered type=0 → show form
    // Android not registered type=1 → show form
    // iOS     not registered type=0 → show form
    // iOS     not registered type=1 → skip form, go directly to detail
    // Any platform, registered      → skip form, go directly to detail
    if (_enquiryCtrl.shouldShowEnquiryForm(college.type)) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => EnquiryBottomSheet(
          college: college,
          onProceed: () => _pushDetail(college),
        ),
      );
    } else {
      _pushDetail(college);
    }
  }

  void _pushDetail(CollegeModel college) =>
      Get.to(
            () => CollegeDetailScreen(collegeId: college.id),
        transition: Transition.rightToLeft,
      );

  void _openCourseDetail(CourseModel course) =>
      Get.to(() => CourseDetailScreen(courseId: course.id));

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return NetworkAwareWrapper(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.background,
        body: Obx(() {
          final isLoading = _ctrl.topCollegesLoading.value ||
              _courseCtrl.isLoading.value;

          // ── Shimmer phase ─────────────────────────────────
          if (isLoading) {
            return const HomeScreenShimmer();
          }

          // ── Real content (fades in) ───────────────────────
          return FadeTransition(
            opacity: _fadeAnim,
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildAppBar(r)),
                    SliverToBoxAdapter(child: _buildSearchBar(r)),
                    SliverToBoxAdapter(child: _buildHeroBanner(r)),
                    _buildSavedCollegesSliver(r),
                    _buildRecommendedSliver(r),
                    _buildTopCollegesHeader(r),
                    _buildTopCollegesSliver(r),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSearchBar(Responsive r) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        r.spacing(AppDimens.paddingLG),
        r.spacing(AppDimens.paddingLG),
        r.spacing(AppDimens.paddingLG),
        0,
      ),
      child: GestureDetector(
        onTap: () => Get.to(() => const SearchScreen()),
        child: AbsorbPointer(
          child: AppSearchBar(
            hintText: 'Search colleges, courses, locations...',
            controller: _searchCtrl,
            onChanged: (_) {},
          ),
        ),
      ),
    );
  }

  Widget _buildSavedCollegesSliver(Responsive r) {
    final saved = _ctrl.savedColleges;
    if (saved.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

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
              title: 'Saved Colleges',
              actionText: 'View All',
              onAction: () => Get.to(() => CollegeListScreen()),
            ),
            SizedBox(height: r.spacing(AppDimens.paddingMD)),
            SizedBox(
              height: r.spacing(110),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: saved.length,
                separatorBuilder: (_, __) =>
                    SizedBox(width: r.spacing(AppDimens.paddingMD)),
                itemBuilder: (_, i) => _buildSavedCollegeChip(saved[i], r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedSliver(Responsive r) {
    if (_courseCtrl.hasError.value) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final bvscCourses = _courseCtrl.courses
        .where((c) =>
    c.courseName.toLowerCase().contains('bvsc') ||
        c.courseName.toLowerCase().contains('b.v.sc') ||
        c.courseName
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
              padding:
              EdgeInsets.only(bottom: r.spacing(AppDimens.paddingMD)),
              child: _buildCourseCard(course, r),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCollegesHeader(Responsive r) {
    return SliverToBoxAdapter(
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
    );
  }

  Widget _buildTopCollegesSliver(Responsive r) {
    if (_ctrl.topCollegesError.value) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off_rounded,
                  size: r.fontSize(48), color: AppColors.textSecondary),
              SizedBox(height: r.spacing(AppDimens.paddingMD)),
              Text('Failed to load colleges', style: AppTextStyles.bodyMedium),
              SizedBox(height: r.spacing(AppDimens.paddingMD)),
              ElevatedButton.icon(
                onPressed: _ctrl.fetchTopCollegesFromApi,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_ctrl.topColleges.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
            child: Text('No colleges found.', style: AppTextStyles.bodyMedium)),
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
            final college = _ctrl.topColleges[i];
            return Padding(
              padding:
              EdgeInsets.only(bottom: r.spacing(AppDimens.paddingMD)),
              child: CollegeCard(
                collegeName: college.collegeName,
                location: college.location,
                onTap: () => _openCollegeDetail(college),
              ),
            );
          },
          childCount: _ctrl.topColleges.length,
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  // CARD / WIDGET BUILDERS
  // ════════════════════════════════════════════════════════

  Widget _buildSavedCollegeChip(CollegeModel college, Responsive r) {
    return GestureDetector(
      onTap: () => _openCollegeDetail(college),
      child: Container(
        width: r.spacing(160),
        padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.bookmark_rounded,
                    color: AppColors.primary, size: r.fontSize(16)),
                const Spacer(),
                GestureDetector(
                  onTap: () => _ctrl.toggleSave(college),
                  child: Icon(Icons.close_rounded,
                      color: AppColors.textSecondary, size: r.fontSize(16)),
                ),
              ],
            ),
            SizedBox(height: r.spacing(AppDimens.paddingSM)),
            Text(college.collegeName,
                style: AppTextStyles.titleLarge
                    .copyWith(fontSize: r.fontSize(12)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            SizedBox(height: r.spacing(4)),
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: r.fontSize(11), color: AppColors.textSecondary),
                SizedBox(width: r.spacing(2)),
                Expanded(
                  child: Text(college.location,
                      style: AppTextStyles.bodySmall.copyWith(
                          fontSize: r.fontSize(10),
                          color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
                offset: const Offset(0, 2)),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(AppDimens.radiusLG)),
                child: Container(
                  width:
                  r.value(mobile: r.spacing(100), tablet: r.spacing(120)),
                  color: AppColors.primarySurface,
                  child: Icon(Icons.menu_book_rounded,
                      color: AppColors.primary,
                      size: r.fontSize(AppDimens.avatarMD)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(course.courseName,
                          style: AppTextStyles.titleLarge
                              .copyWith(fontSize: r.fontSize(14)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      SizedBox(height: r.spacing(AppDimens.paddingSM)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                EdgeInsets.only(right: r.spacing(AppDimens.paddingMD)),
                child: Icon(Icons.chevron_right_rounded,
                    color: AppColors.textSecondary, size: r.fontSize(20)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(Responsive r) {
    return Padding(
      padding: EdgeInsets.fromLTRB(r.spacing(AppDimens.paddingLG),
          r.spacing(AppDimens.paddingMD), r.spacing(AppDimens.paddingLG), 0),
      child: Row(
        children: [
          SizedBox(width: r.spacing(AppDimens.paddingMD)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello, Vet Aspirant! 👋',
                    style: AppTextStyles.headlineLarge
                        .copyWith(fontSize: r.fontSize(15))),
                Text('What would you like to explore today?',
                    style: AppTextStyles.bodyMedium
                        .copyWith(fontSize: r.fontSize(12))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(Responsive r) {
    return Padding(
      padding: EdgeInsets.fromLTRB(r.spacing(AppDimens.paddingLG),
          r.spacing(AppDimens.paddingLG), r.spacing(AppDimens.paddingLG), 0),
      child: Container(
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
                    shape: BoxShape.circle),
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
                    shape: BoxShape.circle),
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
                        Text('Build a Better Future\nFor Animals',
                            style: AppTextStyles.displayWhite
                                .copyWith(fontSize: r.fontSize(18))),
                        SizedBox(height: r.spacing(AppDimens.paddingSM)),
                        Text(
                            'Explore top veterinary colleges\nand programs in India.',
                            style: AppTextStyles.bodyWhite.copyWith(
                                color: Colors.white70,
                                fontSize: r.fontSize(12))),
                        SizedBox(height: r.spacing(AppDimens.paddingMD)),
                      ],
                    ),
                  ),
                  Icon(Icons.pets_rounded,
                      color: Colors.white38,
                      size: r.value(
                          mobile: r.fontSize(AppDimens.avatarXL),
                          tablet: r.fontSize(96))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      _ctrl.fetchTopCollegesFromApi(),
      _courseCtrl.fetchCourses(),
    ]);
  }
}