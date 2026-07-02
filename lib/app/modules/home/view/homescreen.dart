
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
import '../bindings/home_binding.dart';
import 'search_screen.dart';

Color _shade(Color base, double lightnessDelta) {
  final hsl = HSLColor.fromColor(base);
  return hsl
      .withLightness((hsl.lightness + lightnessDelta).clamp(0.0, 1.0))
      .toColor();
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final CollegeController _ctrl = Get.find<CollegeController>();
  final EnquiryController _enquiryCtrl = Get.find<EnquiryController>();
  final CourseController _courseCtrl = Get.find<CourseController>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchCtrl = TextEditingController();

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
    final type = _ctrl.collegeType.value;

    _enquiryCtrl.markCollegeType(type);

    if (_enquiryCtrl.shouldShowEnquiryForm(type)) {
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
        binding:  CollegeDetailBinding(), // ✅ add this
        transition: Transition.rightToLeft,
      );

  void _openCourseDetail(CourseModel course) =>
      Get.to(
            () => CourseDetailScreen(courseId: course.id),
        binding: CourseDetailBinding(), // ✅
      );

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

          if (isLoading) {
            return const HomeScreenShimmer();
          }
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

  Widget _buildAppBar(Responsive r) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        r.spacing(AppDimens.paddingLG),
        r.spacing(AppDimens.paddingLG),
        r.spacing(AppDimens.paddingLG),
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, Vet Aspirant 👋',
                  style: AppTextStyles.headlineLarge.copyWith(
                    fontSize: r.fontSize(19),
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: r.spacing(2)),
                Text(
                  'Find the right path into veterinary science',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: r.fontSize(12.5),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: r.spacing(AppDimens.paddingMD)),
        ],
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
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: r.spacing(AppDimens.paddingMD),
            vertical: r.spacing(13),
          ),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppDimens.radiusLG + 4),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded,
                  color: AppColors.textSecondary, size: r.fontSize(20)),
              SizedBox(width: r.spacing(AppDimens.paddingSM)),
              Expanded(
                child: Text(
                  'Search colleges...',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: r.fontSize(13),
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
  Widget _buildHeroBanner(Responsive r) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        r.spacing(AppDimens.paddingLG),
        r.spacing(AppDimens.paddingXL),
        r.spacing(AppDimens.paddingLG),
        0,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_shade(AppColors.primary, -0.08), AppColors.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimens.radiusXL + 4),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.28),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.radiusXL + 4),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -26,
                right: -18,
                child: Container(
                  width: r.spacing(110),
                  height: r.spacing(110),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: 38,
                right: 70,
                child: Container(
                  width: r.spacing(70),
                  height: r.spacing(70),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Vet image — anchored to bottom-right, bleeds to edge
              Positioned(
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: r.value(
                      mobile: r.spacing(150), tablet: r.spacing(200)),
                  child: Image.asset(
                    'assets/images/vetapp.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomRight,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(
                  r.spacing(AppDimens.paddingXL),
                  r.spacing(AppDimens.paddingXL),
                  r.spacing(AppDimens.paddingXL),
                  r.spacing(AppDimens.paddingLG),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: r.value(
                          mobile: r.spacing(190), tablet: r.spacing(260)),
                      child: Text(
                        'Build a Better\nFuture for Animals',
                        style: AppTextStyles.displayWhite.copyWith(
                          fontSize: r.fontSize(19),
                          fontWeight: FontWeight.w800,
                          height: 1.18,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                    SizedBox(height: r.spacing(AppDimens.paddingSM)),
                    SizedBox(
                      width: r.value(
                          mobile: r.spacing(190), tablet: r.spacing(260)),
                      child: Text(
                        'Discover and compare the best veterinary colleges across India.',
                        style: AppTextStyles.bodyWhite.copyWith(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: r.fontSize(12),
                          height: 1.35,
                        ),
                      ),
                    ),
                    SizedBox(height: r.spacing(AppDimens.paddingMD)),
                    GestureDetector(
                      onTap: () => Get.to(
                            () => CollegeListScreen(),
                        binding: CollegesBinding(),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: r.spacing(16),
                          vertical: r.spacing(9),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(AppDimens.radiusLG),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Explore Colleges',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: r.fontSize(12),
                              ),
                            ),
                            SizedBox(width: r.spacing(4)),
                            Icon(Icons.arrow_forward_rounded,
                                color: AppColors.primary,
                                size: r.fontSize(14)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
          onAction: () => Get.to(
                () => CollegeListScreen(),
            binding: CollegesBinding(),
          ),
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
              EdgeInsets.only(bottom: r.spacing(AppDimens.paddingXS)),
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
  Future<void> _onRefresh() async {
    await Future.wait([
      _ctrl.fetchTopCollegesFromApi(),
      _courseCtrl.fetchCourses(),
    ]);
  }
}
