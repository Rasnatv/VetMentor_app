
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../data/models/modelclass.dart';
import '../../../widgets/collegecard.dart';
import '../../../widgets/commonwidget.dart';
import '../../Colleges/view/Enquiry_form.dart';
import '../../Colleges/view/collegedtailscreen.dart';
import '../../Colleges/view/collegescreen.dart';
import '../../courses/view/coursesscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<College> _savedColleges = [];
  final _searchCtrl = TextEditingController();

  void _toggleSave(College college) {
    setState(() {
      if (_savedColleges.any((c) => c.id == college.id)) {
        _savedColleges.removeWhere((c) => c.id == college.id);
      } else {
        _savedColleges.add(college);
      }
    });
  }

  bool _isSaved(College college) => _savedColleges.any((c) => c.id == college.id);

  void _openCollegeDetail(College college) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EnquiryBottomSheet(
        college: college,
        onSubmit: (data) {
          Navigator.pop(context);
          _pushDetail(college);
        },
        onSkip: () {
          Navigator.pop(context);
          _pushDetail(college);
        },
      ),
    );
  }

  void _pushDetail(College college) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CollegeDetailScreen(
          college: college,
          isSaved: _isSaved(college),
          onSave: () => _toggleSave(college),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context); // ← get responsive instance
    final colleges = MockData.colleges;

    return NetworkAwareWrapper(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildAppBar(r)),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    r.spacing(AppDimens.paddingLG),
                    r.spacing(AppDimens.paddingLG),
                    r.spacing(AppDimens.paddingLG),
                    0,
                  ),
                  child: AppSearchBar(
                    hintText: 'Search colleges, courses, locations...',
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ),

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

              SliverToBoxAdapter(
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
                        actionText: 'View All',onAction: ()=>Get.to(CourseListingScreen() ),
                      ),
                      SizedBox(height: r.spacing(AppDimens.paddingMD)),
                      buildRecommendedCard(colleges.first, r),
                    ],
                  ),
                ),
              ),

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
                    onAction: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CollegesScreen()),
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  r.spacing(AppDimens.paddingLG),
                  r.spacing(AppDimens.paddingMD),
                  r.spacing(AppDimens.paddingLG),
                  100,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (ctx, i) {
                      final college = colleges[i];
                      return CollegeCard(
                        college: college,
                        isSaved: _isSaved(college),
                        onSave: () => _toggleSave(college),
                        onTap: () => _openCollegeDetail(college),
                      );
                    },
                    childCount: colleges.length > 4 ? 4 : colleges.length,
                  ),
                ),
              ),
            ],
          ),
        ),
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
          GestureDetector(
            onTap: () {},
            child: Container(
              width: r.spacing(AppDimens.avatarSM),
              height: r.spacing(AppDimens.avatarSM),
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                border: Border.all(color: AppColors.border),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.notifications_outlined,
                      color: AppColors.textPrimary,
                      size: r.fontSize(AppDimens.iconSM),
                    ),
                  ),
                  Positioned(
                    top: r.spacing(AppDimens.paddingSM),
                    right: r.spacing(AppDimens.paddingSM),
                    child: Container(
                      width: r.spacing(8),
                      height: r.spacing(8),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                    mobile: r.fontSize(AppDimens.avatarXL),  // 80 scaled
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

  Widget buildRecommendedCard(College college, Responsive r) {
    return GestureDetector(
      onTap: () => _openCollegeDetail(college),
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
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(AppDimens.radiusLG),
                ),
                child: Container(
                  width: r.value(
                    mobile: r.spacing(110),
                    tablet: r.spacing(140),
                  ),
                  color: AppColors.primarySurface,
                  child: Icon(
                    Icons.school_rounded,
                    color: AppColors.primary,
                    size: r.fontSize(AppDimens.avatarMD), // 48 scaled
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'BVSc & AH Program',
                        style: AppTextStyles.titleLarge.copyWith(
                          fontSize: r.fontSize(14),
                        ),
                      ),
                      SizedBox(height: r.spacing(2)),
                      Text(
                        'Bachelor of Veterinary Science\n& Animal Husbandry',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: r.fontSize(12),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: r.spacing(AppDimens.paddingSM)),
                      Row(
                        children: [
                          Text(
                            'Know More',
                            style: AppTextStyles.bodyGreen.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: r.fontSize(13),
                            ),
                          ),
                          SizedBox(width: r.spacing(AppDimens.paddingXS)),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.primary,
                            size: r.fontSize(AppDimens.iconXS),
                          ),
                        ],
                      ),
                    ],
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
