
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veterinaryapp/app/modules/home/view/quizscreen.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../data/models/collegelistmodel.dart';
import '../../../data/models/coursemodel.dart';
import '../../../data/models/questionmodel.dart';
import '../../../no internetconnection/no_connection.dart';
import '../../../widgets/collegecard.dart';
import '../../../widgets/commonwidget.dart';
import '../../../widgets/shimmer_widget.dart';
import '../../Colleges/controller/college_controller.dart';
import '../../Colleges/controller/enquirycontroller.dart';
import '../../Colleges/view/Enquiry_form.dart';
import '../../Colleges/view/allcollegelistingscreen.dart';
import '../../Colleges/view/collegedtailscreen.dart';
import '../../Colleges/view/collegescreen.dart';
import '../../Colleges/view/permanent_affiliatedcollegslist.dart';
import '../../Colleges/view/tempoary_affilaiatedcollegelist.dart';
import '../../courses/view/coursesdetailscreen.dart';
import '../../courses/view/coursesscreen.dart';
import '../../courses/controller/courses_controller.dart';
import '../../notification/controller/notificationcontroller.dart';
import '../../notification/view/notificationpage.dart';
import '../bindings/home_binding.dart';
import '../controller/astraaddcontroller.dart';
import '../controller/pushnotification_controller.dart';
import 'bottomaddbanner.dart';
import 'chatbaseScreen.dart';
import 'search_screen.dart';

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
  final PushNotificationController _pushCtrl =
  Get.put(PushNotificationController());
  final NotificationController notificationController =
  Get.put(NotificationController());



  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchCtrl = TextEditingController();

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;
  bool _contentVisible = false;

  bool _hasUnreadNotifications = false;

  @override
  void initState() {
    super.initState();
    _pushCtrl.registerDeviceToken();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOutCubic);

    _searchCtrl.addListener(() {
      _ctrl.onSearchChanged(_searchCtrl.text);
    });

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

  void _pushDetail(CollegeModel college) => Get.to(
        () => CollegeDetailScreen(collegeId: college.id),
    binding: CollegeDetailBinding(),
    transition: Transition.rightToLeft,
  );

  void _openCourseDetail(CourseModel course) => Get.to(
        () => CourseDetailScreen(courseId: course.id),
    binding: CourseDetailBinding(),
  );

  void _startMockTest() {
    Get.to(() => QuizScreen(questions: dummyQuestions));
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return NetworkAwareWrapper(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.background,
        floatingActionButton:  FloatingActionButton(
          onPressed: () {
     Get.to(()=>ChatbaseScreen());
    },
      backgroundColor:AppColors.primary,
      child: const Icon(Icons.smart_toy, color: Colors.white),
    ),
        body: Obx(() {
          final isLoading =
              _ctrl.topCollegesLoading.value || _courseCtrl.isLoading.value;

          if (isLoading) {
            return const HomeScreenShimmer();
          }
          return FadeTransition(
            opacity: _fadeAnim,
            child: SafeArea(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _onRefresh,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    SliverToBoxAdapter(child: _buildAppBar(r)),
                    SliverToBoxAdapter(child: _buildSearchBar(r)),
                    SliverToBoxAdapter(child: _buildHeroBanner(r)),
                    SliverToBoxAdapter(child: _buildMockTestSection(r)),
                    _buildRecommendedSliver(r),
                    SliverToBoxAdapter(child: _buildAffiliationButtons(r)),
                    _buildTopCollegesHeader(r),
                    _buildTopCollegesSliver(r),
                    SliverToBoxAdapter(child: SizedBox(height: r.spacing(32))),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── App bar ────────────────────────────────────────────────
  Widget _buildAppBar(Responsive r) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        r.spacing(AppDimens.paddingLG),
        r.spacing(AppDimens.paddingLG + 8),
        r.spacing(AppDimens.paddingLG),
        r.spacing(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Hello, Vet Aspirant',
                      style: AppTextStyles.headlineLarge.copyWith(
                        fontSize: r.fontSize(23),
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                        letterSpacing: -0.6,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: r.spacing(6)),
                    Text('👋', style: TextStyle(fontSize: r.fontSize(20))),
                  ],
                ),
                SizedBox(height: r.spacing(7)),
                Text(
                  'Find the right path into veterinary science',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: r.fontSize(13.5),
                    height: 1.4,
                    letterSpacing: -0.1,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: r.spacing(AppDimens.paddingMD)),
          Obx(
                () => _NotificationButton(
              hasUnread: notificationController.hasUnread.value,
              onTap: () {
                Get.to(() => const NotificationPage());
              }, r: r,
            ),
          ),
        ],
      ),
    );
  }

  // ── Search bar ─────────────────────────────────────────────
  Widget _buildSearchBar(Responsive r) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        r.spacing(AppDimens.paddingLG),
        r.spacing(AppDimens.paddingLG + 2),
        r.spacing(AppDimens.paddingLG),
        0,
      ),
      child: GestureDetector(
        onTap: () => Get.to(() => const SearchScreen()),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: r.spacing(AppDimens.paddingSM + 2),
            vertical: r.spacing(AppDimens.paddingSM + 2),
          ),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppDimens.radiusXL),
            border: Border.all(color: AppColors.borderLight, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: AppColors.primary.withOpacity(0.05),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(r.spacing(8)),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                ),
                child: Icon(Icons.search_rounded,
                    color: AppColors.primary, size: r.fontSize(18)),
              ),
              SizedBox(width: r.spacing(AppDimens.paddingSM + 4)),
              Expanded(
                child: Text(
                  'Search colleges, courses...',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: r.fontSize(14),
                    letterSpacing: -0.1,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(r.spacing(8)),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Icon(Icons.tune_rounded,
                    color: AppColors.textSecondary, size: r.fontSize(16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Hero banner ────────────────────────────────────────────
  Widget _buildHeroBanner(Responsive r) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        r.spacing(AppDimens.paddingLG),
        r.spacing(24),
        r.spacing(AppDimens.paddingLG),
        0,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.radiusXL + 6),
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withOpacity(0.28),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.radiusXL + 6),
          child: Stack(
            children: [
              Positioned(
                top: -30,
                right: -20,
                child: Container(
                  width: r.spacing(120),
                  height: r.spacing(120),
                  decoration: BoxDecoration(
                    color: AppColors.accentLight.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -40,
                right: r.spacing(40),
                child: Container(
                  width: r.spacing(70),
                  height: r.spacing(70),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height:
                  r.value(mobile: r.spacing(112), tablet: r.spacing(148)),
                  child: Image.asset(
                    'assets/images/vetapp.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomRight,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  r.spacing(AppDimens.paddingLG + 4),
                  r.spacing(AppDimens.paddingLG + 2),
                  r.spacing(AppDimens.paddingLG + 2),
                  r.spacing(AppDimens.paddingMD + 6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.spacing(10),
                        vertical: r.spacing(5),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        'ADMISSIONS OPEN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: r.fontSize(9.5),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    SizedBox(height: r.spacing(12)),
                    SizedBox(
                      width: r.value(
                          mobile: r.spacing(195), tablet: r.spacing(270)),
                      child: Text(
                        'Build a Better\nFuture for Animals',
                        style: AppTextStyles.displayWhite.copyWith(
                          fontSize: r.fontSize(19.5),
                          fontWeight: FontWeight.w900,
                          height: 1.18,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    SizedBox(height: r.spacing(9)),
                    SizedBox(
                      width: r.value(
                          mobile: r.spacing(200), tablet: r.spacing(270)),
                      child: Text(
                        'Discover and compare the best veterinary colleges across India.',
                        style: AppTextStyles.bodyWhite.copyWith(
                          color: Colors.white.withOpacity(0.82),
                          fontSize: r.fontSize(12),
                          height: 1.45,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ),
                    SizedBox(height: r.spacing(AppDimens.paddingMD + 2)),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius:
                        BorderRadius.circular(AppDimens.radiusLG),
                        onTap: () => Get.to(
                              () => CollegeListScreen(),
                          binding: CollegesBinding(),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: r.spacing(17),
                            vertical: r.spacing(11),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(AppDimens.radiusLG),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.14),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Explore Colleges',
                                style: TextStyle(
                                  color: AppColors.primaryDark,
                                  fontWeight: FontWeight.w800,
                                  fontSize: r.fontSize(12.5),
                                  letterSpacing: -0.1,
                                ),
                              ),
                              SizedBox(width: r.spacing(7)),
                              Icon(Icons.arrow_forward_rounded,
                                  color: AppColors.primaryDark,
                                  size: r.fontSize(15)),
                            ],
                          ),
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

  // ── Mock Test banner ──────────────────────────────────────
  Widget _buildMockTestSection(Responsive r) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        r.spacing(AppDimens.paddingLG),
        r.spacing(20),
        r.spacing(AppDimens.paddingLG),
        0,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _startMockTest,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG + 6),
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppDimens.radiusLG + 6),
              border: Border.all(color: AppColors.borderLight),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD + 4)),
            child: Row(
              children: [
                Container(
                  width: r.spacing(56),
                  height: r.spacing(56),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.badgePublicText.withOpacity(0.22),
                        AppColors.badgePublicText.withOpacity(0.08),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                  ),
                  child: Icon(Icons.fact_check_rounded,
                      color: AppColors.badgePublicText, size: r.fontSize(26)),
                ),
                SizedBox(width: r.spacing(AppDimens.paddingMD + 2)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Take a Mock Test',
                        style: AppTextStyles.titleLarge.copyWith(
                          fontSize: r.fontSize(15.5),
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: r.spacing(5)),
                      Text(
                        '15 Questions · Instant Score & Marks',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: r.fontSize(12),
                          height: 1.4,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: r.spacing(AppDimens.paddingSM)),
                Container(
                  padding: EdgeInsets.all(r.spacing(11)),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: r.fontSize(17)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Affiliated colleges — two elegant buttons ─────────────
  Widget _buildAffiliationButtons(Responsive r) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        r.spacing(AppDimens.paddingLG),
        r.spacing(15),
        r.spacing(AppDimens.paddingLG),
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Affiliated Colleges',
            style: AppTextStyles.titleLarge.copyWith(
              fontSize: r.fontSize(17),
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              height: 1.3,
            ),
          ),
          SizedBox(height: r.spacing(4)),
          Text(
            'Browse colleges by affiliation status',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: r.fontSize(12.5),
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: r.spacing(AppDimens.paddingMD + 4)),
          Row(
            children: [
              Expanded(
                child: _AffiliationButton(
                  r: r,
                  label: 'Temporary',
                  subtitle: 'Provisionally affiliated',
                  icon: Icons.hourglass_top_rounded,
                  accent: AppColors.badgeStateText,
                  onTap: () =>
                      Get.to(() => const TemporaryAffiliatedScreen()),
                ),
              ),
              SizedBox(width: r.spacing(AppDimens.paddingMD)),
              Expanded(
                child: _AffiliationButton(
                  r: r,
                  label: 'Permanent',
                  subtitle: 'Fully affiliated',
                  icon: Icons.verified_rounded,
                  accent: AppColors.badgePublicText,
                  onTap: () =>
                      Get.to(() => const PermanentAffiliatedScreen()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Recommended courses ───────────────────────────────────
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
          r.spacing(15),
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
            SizedBox(height: r.spacing(AppDimens.paddingMD + 4)),
            ...bvscCourses.map((course) => Padding(
              padding: EdgeInsets.only(
                  bottom: r.spacing(AppDimens.paddingMD)),
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
          r.spacing(30),
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
              Text('Failed to load colleges',
                  style: AppTextStyles.bodyMedium),
              SizedBox(height: r.spacing(AppDimens.paddingMD)),
              ElevatedButton.icon(
                onPressed: _ctrl.fetchTopCollegesFromApi,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(AppDimens.radiusMD + 4),
                  ),
                ),
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
            child:
            Text('No colleges found.', style: AppTextStyles.bodyMedium)),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        r.spacing(AppDimens.paddingLG),
        r.spacing(AppDimens.paddingMD + 4),
        r.spacing(AppDimens.paddingLG),
        AppDimens.paddingLG,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (ctx, i) {
            final college = _ctrl.topColleges[i];
            return Padding(
              padding: EdgeInsets.only(
                  bottom: r.spacing(AppDimens.paddingSM + 4)),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openCourseDetail(course),
        borderRadius: BorderRadius.circular(AppDimens.radiusLG + 2),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppDimens.radiusLG + 2),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.025),
                  blurRadius: 12,
                  offset: const Offset(0, 5)),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
            child: Row(
              children: [
                Container(
                  width: r.spacing(52),
                  height: r.spacing(52),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.kAccent.withOpacity(0.18),
                        AppColors.kAccent.withOpacity(0.08),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppDimens.radiusMD + 4),
                  ),
                  child: Icon(Icons.menu_book_rounded,
                      color: AppColors.kAccent, size: r.fontSize(24)),
                ),
                SizedBox(width: r.spacing(AppDimens.paddingMD + 2)),
                Expanded(
                  child: Text(
                    course.courseName,
                    style: AppTextStyles.titleLarge.copyWith(
                      fontSize: r.fontSize(14.5),
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.1,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: r.spacing(6)),
                Icon(Icons.chevron_right_rounded,
                    color: AppColors.textSecondary.withOpacity(0.6),
                    size: r.fontSize(22)),
              ],
            ),
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

/// Elegant card button used for the Temporary / Permanent affiliation
/// choices — a soft gradient icon badge, label, subtitle, and a
/// tucked-in arrow chip in the corner.
class _AffiliationButton extends StatelessWidget {
  final Responsive r;
  final String label;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  const _AffiliationButton({
    required this.r,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG + 6),
        child: Ink(
          padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD + 2)),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppDimens.radiusLG + 6),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: r.spacing(46),
                    height: r.spacing(46),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accent.withOpacity(0.20),
                          accent.withOpacity(0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                      BorderRadius.circular(AppDimens.radiusMD + 4),
                    ),
                    child: Icon(icon, color: accent, size: r.fontSize(22)),
                  ),
                  Container(
                    padding: EdgeInsets.all(r.spacing(6)),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_outward_rounded,
                        color: accent, size: r.fontSize(13)),
                  ),
                ],
              ),
              SizedBox(height: r.spacing(AppDimens.paddingMD + 2)),
              Text(
                label,
                style: AppTextStyles.titleLarge.copyWith(
                  fontSize: r.fontSize(15.5),
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: r.spacing(3)),
              Text(
                subtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: r.fontSize(11.5),
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Rounded bell icon button used in the home app bar, with an optional
/// small red dot to indicate unread notifications.
class _NotificationButton extends StatelessWidget {
  final Responsive r;
  final bool hasUnread;
  final VoidCallback onTap;

  const _NotificationButton({
    required this.r,
    required this.hasUnread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = r.spacing(46.0);
    return Material(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        side: BorderSide(color: AppColors.borderLight),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textPrimary,
                size: r.fontSize(22),
              ),
              if (hasUnread)
                Positioned(
                  top: r.spacing(9),
                  right: r.spacing(9),
                  child: Container(
                    width: r.spacing(9),
                    height: r.spacing(9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0483A),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.cardBackground,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
