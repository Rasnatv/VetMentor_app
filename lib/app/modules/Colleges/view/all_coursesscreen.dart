
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../data/models/modelclass.dart';
import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';
import '../../../widgets/commonwidget.dart';
import 'courses_undercollegeslist.dart';

class CourseWithCollege {
  final Course course;
  final College college;
  const CourseWithCollege({required this.course, required this.college});
}

List<CourseWithCollege> buildAllCourses(List<College> colleges) {
  final result = <CourseWithCollege>[];
  for (final college in colleges) {
    for (final course in college.allCourses) {
      result.add(CourseWithCollege(course: course, college: college));
    }
  }
  return result;
}

class AllCoursesScreen extends StatefulWidget {
  final List<CourseWithCollege>? courses;
  const AllCoursesScreen({super.key, this.courses});

  @override
  State<AllCoursesScreen> createState() => _AllCoursesScreenState();
}

class _AllCoursesScreenState extends State<AllCoursesScreen> {
  String _selectedLevel = 'All Courses';
  final _searchController = TextEditingController();
  String _searchQuery = '';

  static const _levels = [
    'All Courses',
    'UG Courses',
    'PG Courses',
    'Diploma',
    'Ph.D'
  ];

  List<CourseWithCollege> get _source => widget.courses ?? _mockCourses;

  List<CourseWithCollege> get _filtered {
    List<CourseWithCollege> list = _source;
    if (_selectedLevel == 'UG Courses') {
      list = list.where((e) => e.course.level == 'UG').toList();
    } else if (_selectedLevel == 'PG Courses') {
      list = list.where((e) => e.course.level == 'PG').toList();
    } else if (_selectedLevel == 'Diploma') {
      list = list.where((e) => e.course.level == 'Diploma').toList();
    } else if (_selectedLevel == 'Ph.D') {
      list = list.where((e) => e.course.level == 'PhD').toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((e) =>
      e.course.name.toLowerCase().contains(q) ||
          e.course.fullName.toLowerCase().contains(q) ||
          e.college.name.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  // ── Navigate to CollegesListScreen ─────────────────────────────────────────
  void _navigateToColleges(CourseWithCollege courseItem) {
    // Collect ALL colleges that offer this course id
    final colleges = _source
        .where((c) => c.course.id == courseItem.course.id)
        .map((c) => c.college)
        .toList();

    Get.to(
          () => CollegesListScreen(
        course: courseItem.course,
        colleges: colleges,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final filtered = _filtered;

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: VetAppBar(title: 'All Courses'),
        body: Column(
          children: [
            // ── Search bar ─────────────────────────────────────────────────
            Container(
              color: AppColors.backgroundWhite,
              padding: EdgeInsets.fromLTRB(
                r.spacing(AppDimens.paddingLG),
                r.spacing(AppDimens.paddingSM + 2),
                r.spacing(AppDimens.paddingLG),
                0,
              ),
              child: Container(
                height: r.value(mobile: 42.0, tablet: 48.0),
                decoration: BoxDecoration(
                  color: AppColors.backgroundGrey,
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: r.fontSize(14),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search courses or colleges...',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      fontSize: r.fontSize(13),
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: r.value(
                        mobile: AppDimens.iconXS + 6,
                        tablet: AppDimens.iconSM,
                      ),
                      color: AppColors.iconSecondary,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      child: Icon(
                        Icons.close_rounded,
                        size: r.value(
                          mobile: AppDimens.iconXS + 4,
                          tablet: AppDimens.iconSM,
                        ),
                        color: AppColors.iconSecondary,
                      ),
                    )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: r.spacing(11),
                    ),
                    isDense: true,
                  ),
                ),
              ),
            ),

            // ── Level filter tabs ──────────────────────────────────────────
            Container(
              color: AppColors.backgroundWhite,
              padding: EdgeInsets.fromLTRB(
                r.spacing(AppDimens.paddingLG),
                r.spacing(AppDimens.paddingSM + 2),
                r.spacing(AppDimens.paddingLG),
                r.spacing(AppDimens.paddingMD),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _levels.map((level) {
                    final isSelected = level == _selectedLevel;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedLevel = level),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.only(
                          right: r.spacing(AppDimens.paddingSM),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: r.spacing(AppDimens.paddingLG),
                          vertical: r.spacing(AppDimens.paddingXS + 4),
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.backgroundGrey,
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusFull,
                          ),
                        ),
                        child: Text(
                          level,
                          style: AppTextStyles.titleSmall.copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            fontSize: r.fontSize(13),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // ── Course list ────────────────────────────────────────────────
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      r.spacing(AppDimens.paddingLG),
                      0,
                      r.spacing(AppDimens.paddingLG),
                      100,
                    ),
                    sliver: r.isTablet || r.isDesktop
                    // ── tablet/desktop: 2-column grid ──
                        ? SliverGrid(
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: r.isDesktop ? 3 : 2,
                        crossAxisSpacing: r.spacing(AppDimens.paddingMD),
                        mainAxisSpacing: r.spacing(AppDimens.paddingMD),
                        childAspectRatio: r.isDesktop ? 1.6 : 1.45,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (_, i) {
                          final courseItem = filtered[i];
                          return _CourseCard(
                            item: courseItem,
                            onTap: () => _navigateToColleges(courseItem),
                          );
                        },
                        childCount: filtered.length,
                      ),
                    )
                    // ── mobile: list ──
                        : SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (_, i) {
                          final courseItem = filtered[i];
                          return _CourseCard(
                            item: courseItem,
                            onTap: () => _navigateToColleges(courseItem),
                          );
                        },
                        childCount: filtered.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section Header ─────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        r.spacing(AppDimens.paddingLG),
        r.spacing(AppDimens.paddingLG),
        r.spacing(AppDimens.paddingLG),
        r.spacing(AppDimens.paddingSM),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: AppTextStyles.headlineSmall.copyWith(
              fontSize: r.fontSize(16),
            ),
          ),
          const Spacer(),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Row(
                children: [
                  Text(
                    actionLabel!,
                    style: AppTextStyles.bodyGreen.copyWith(
                      fontSize: r.fontSize(13),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: r.value(mobile: 11.0, tablet: 13.0),
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Recommended Card ───────────────────────────────────────────────────────────
class _RecommendedCard extends StatelessWidget {
  final CourseWithCollege item;
  const _RecommendedCard({required this.item});

  static const _levelColors = {
    'UG': Color(0xFF1B5E20),
    'PG': Color(0xFF1565C0),
    'Diploma': Color(0xFF6A1B9A),
    'PhD': Color(0xFFE65100),
  };
  static const _levelIcons = {
    'UG': Icons.school_rounded,
    'PG': Icons.auto_stories_rounded,
    'Diploma': Icons.workspace_premium_rounded,
    'PhD': Icons.psychology_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final color = _levelColors[item.course.level] ?? AppColors.primary;
    final icon = _levelIcons[item.course.level] ?? Icons.school_rounded;

    return Container(
      width: r.value(mobile: 268.0, tablet: 300.0, desktop: 320.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icon panel
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(15),
              ),
              child: Container(
                width: r.value(mobile: 86.0, tablet: 96.0),
                color: color.withOpacity(0.08),
                child: Icon(
                  icon,
                  color: color,
                  size: r.value(
                    mobile: AppDimens.iconLG + 2,
                    tablet: AppDimens.iconXL,
                  ),
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.spacing(AppDimens.paddingSM),
                        vertical: r.spacing(3),
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius:
                        BorderRadius.circular(AppDimens.radiusXS + 2),
                      ),
                      child: Text(
                        item.course.level == 'PhD'
                            ? 'Ph.D.'
                            : '${item.course.level} Degree',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontSize: r.fontSize(11),
                        ),
                      ),
                    ),
                    SizedBox(height: r.spacing(AppDimens.paddingXS + 2)),
                    Text(
                      item.course.name,
                      style: AppTextStyles.titleLarge.copyWith(
                        fontSize: r.fontSize(14),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: r.spacing(2)),
                    Text(
                      item.course.fullName,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: r.fontSize(11),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: r.spacing(AppDimens.paddingXS + 2)),
                    Row(
                      children: [
                        Text(
                          'Know More',
                          style: AppTextStyles.bodyGreen.copyWith(
                            fontSize: r.fontSize(12),
                          ),
                        ),
                        SizedBox(width: r.spacing(AppDimens.paddingXS)),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.primary,
                          size: r.value(mobile: 13.0, tablet: 15.0),
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
    );
  }
}

// ── Course Card ────────────────────────────────────────────────────────────────
class _CourseCard extends StatelessWidget {
  final CourseWithCollege item;
  final VoidCallback onTap; // ← renamed from onApply, whole card is tappable

  const _CourseCard({required this.item, required this.onTap});

  static const _levelColors = {
    'UG': Color(0xFF1B5E20),
    'PG': Color(0xFF1565C0),
    'Diploma': Color(0xFF6A1B9A),
    'PhD': Color(0xFFE65100),
  };
  static const _levelIcons = {
    'UG': Icons.school_rounded,
    'PG': Icons.auto_stories_rounded,
    'Diploma': Icons.workspace_premium_rounded,
    'PhD': Icons.psychology_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final course = item.course;
    final college = item.college;
    final color = _levelColors[course.level] ?? AppColors.primary;
    final icon = _levelIcons[course.level] ?? Icons.school_rounded;
    final isHighlighted = course.level == 'UG';

    final iconBoxSize = r.value(
      mobile: AppDimens.avatarMD,
      tablet: AppDimens.avatarMD + 8,
    );

    // ── Whole card is tappable ──────────────────────────────────────────────
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: r.spacing(AppDimens.paddingMD)),
        decoration: BoxDecoration(
          color: isHighlighted
              ? AppColors.primarySurface
              : AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          border: Border.all(
            color: isHighlighted
                ? AppColors.primary.withOpacity(0.3)
                : AppColors.borderLight,
            width: isHighlighted ? 1.5 : 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(r.spacing(AppDimens.paddingLG - 2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon box
                  Container(
                    width: iconBoxSize,
                    height: iconBoxSize,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: r.value(
                        mobile: AppDimens.iconMD,
                        tablet: AppDimens.iconLG,
                      ),
                    ),
                  ),
                  SizedBox(width: r.spacing(AppDimens.paddingMD)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                course.name,
                                style: AppTextStyles.titleLarge.copyWith(
                                  fontSize: r.fontSize(14),
                                ),
                              ),
                            ),
                            SizedBox(width: r.spacing(AppDimens.paddingXS)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: r.spacing(AppDimens.paddingSM),
                                vertical: r.spacing(3),
                              ),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                  AppDimens.radiusXS + 2,
                                ),
                              ),
                              child: Text(
                                course.level == 'PhD'
                                    ? 'Ph.D.'
                                    : '${course.level} Degree',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: r.fontSize(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (course.name != course.fullName) ...[
                          SizedBox(height: r.spacing(2)),
                          Text(
                            course.fullName,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: r.fontSize(11),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        SizedBox(height: r.spacing(AppDimens.paddingSM)),
                        Wrap(
                          spacing: r.spacing(AppDimens.paddingMD),
                          runSpacing: r.spacing(AppDimens.paddingXS),
                          children: [
                            _InfoChip(
                              Icons.schedule_rounded,
                              'Duration: ${course.duration}',
                              r,
                            ),
                            if (course.intake > 0)
                              _InfoChip(
                                Icons.group_rounded,
                                'Intake: ${course.intake} Seats',
                                r,
                              ),
                            if (course.intake == 0)
                              _InfoChip(
                                Icons.group_rounded,
                                'Intake: As per ICAR',
                                r,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: r.spacing(AppDimens.paddingSM + 2),
                ),
                child: const Divider(height: 1, color: AppColors.borderLight),
              ),

              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: r.value(mobile: 13.0, tablet: 15.0),
                    color: AppColors.iconSecondary,
                  ),
                  SizedBox(width: r.spacing(AppDimens.paddingXS)),
                  Expanded(
                    child: Text(
                      '${college.name} · ${college.location}',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: r.fontSize(11),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // ── View Colleges arrow ──────────────────────────────────
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: r.spacing(AppDimens.paddingMD),
                      vertical: r.spacing(AppDimens.paddingXS + 2),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View Colleges',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: r.fontSize(11),
                          ),
                        ),
                        SizedBox(width: r.spacing(3)),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.primary,
                          size: r.value(mobile: 13.0, tablet: 15.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Info Chip ──────────────────────────────────────────────────────────────────
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Responsive r;

  const _InfoChip(this.icon, this.label, this.r);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: r.value(mobile: 12.0, tablet: 14.0),
          color: AppColors.textSecondary,
        ),
        SizedBox(width: r.spacing(AppDimens.paddingXS)),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: r.fontSize(11),
          ),
        ),
      ],
    );
  }
}

// ── Mock data ──────────────────────────────────────────────────────────────────
final _mockCourses = <CourseWithCollege>[
  CourseWithCollege(
    course: Course(
        id: 'c1',
        name: 'BVSc & AH',
        fullName: 'Bachelor of Veterinary Science & Animal Husbandry',
        duration: '5.5 Years',
        intake: 60,
        level: 'UG'),
    college: College(
        id: '1',
        name: 'IVRI, Bareilly',
        location: 'Bareilly, UP',
        state: 'Uttar Pradesh',
        established: 'Est. 1889',
        tags: [],
        type: 'Public',
        allCourses: [
          Course(
              id: 'c1',
              name: 'BVSc & AH',
              fullName: 'Bachelor of Veterinary Science & Animal Husbandry',
              duration: '5.5 Years',
              intake: 60,
              level: 'UG'),
          Course(
              id: 'c2',
              name: 'MVSc (Animal Nutrition)',
              fullName: 'Master of Veterinary Science in Animal Nutrition',
              duration: '2 Years',
              intake: 15,
              level: 'PG'),
          Course(
              id: 'c5',
              name: 'Ph.D. (Veterinary Sciences)',
              fullName: 'Doctor of Philosophy in Veterinary Sciences',
              duration: '3–5 Years',
              intake: 0,
              level: 'PhD'),
        ]),
  ),
  CourseWithCollege(
    course: Course(
        id: 'c2',
        name: 'MVSc (Animal Nutrition)',
        fullName: 'Master of Veterinary Science in Animal Nutrition',
        duration: '2 Years',
        intake: 15,
        level: 'PG'),
    college: College(
        id: '1',
        name: 'IVRI, Bareilly',
        location: 'Bareilly, UP',
        state: 'Uttar Pradesh',
        established: 'Est. 1889',
        tags: [],
        type: 'Public',
        allCourses: [
          Course(
              id: 'c1',
              name: 'BVSc & AH',
              fullName: 'Bachelor of Veterinary Science & Animal Husbandry',
              duration: '5.5 Years',
              intake: 60,
              level: 'UG'),
          Course(
              id: 'c2',
              name: 'MVSc (Animal Nutrition)',
              fullName: 'Master of Veterinary Science in Animal Nutrition',
              duration: '2 Years',
              intake: 15,
              level: 'PG'),
          Course(
              id: 'c5',
              name: 'Ph.D. (Veterinary Sciences)',
              fullName: 'Doctor of Philosophy in Veterinary Sciences',
              duration: '3–5 Years',
              intake: 0,
              level: 'PhD'),
        ]),
  ),
  CourseWithCollege(
    course: Course(
        id: 'c3',
        name: 'MVSc (Surgery & Radiology)',
        fullName: 'Master of Veterinary Science in Surgery & Radiology',
        duration: '2 Years',
        intake: 12,
        level: 'PG'),
    college: College(
        id: '2',
        name: 'Madras Veterinary College',
        location: 'Chennai, TN',
        state: 'Tamil Nadu',
        established: 'Est. 1903',
        tags: [],
        type: 'Public',
        allCourses: [
          Course(
              id: 'c1',
              name: 'BVSc & AH',
              fullName: 'Bachelor of Veterinary Science & Animal Husbandry',
              duration: '5.5 Years',
              intake: 80,
              level: 'UG'),
          Course(
              id: 'c3',
              name: 'MVSc (Surgery & Radiology)',
              fullName: 'Master of Veterinary Science in Surgery & Radiology',
              duration: '2 Years',
              intake: 12,
              level: 'PG'),
        ]),
  ),
  CourseWithCollege(
    course: Course(
        id: 'c4',
        name: 'MVSc (Reproduction & Obs.)',
        fullName: 'MVSc in Animal Reproduction, Gynaecology & Obstetrics',
        duration: '2 Years',
        intake: 12,
        level: 'PG'),
    college: College(
        id: '3',
        name: 'GADVASU, Ludhiana',
        location: 'Ludhiana, Punjab',
        state: 'Punjab',
        established: 'Est. 2005',
        tags: [],
        type: 'Public',
        allCourses: [
          Course(
              id: 'c4',
              name: 'MVSc (Reproduction & Obs.)',
              fullName:
              'MVSc in Animal Reproduction, Gynaecology & Obstetrics',
              duration: '2 Years',
              intake: 12,
              level: 'PG'),
        ]),
  ),
  CourseWithCollege(
    course: Course(
        id: 'c5',
        name: 'Ph.D. (Veterinary Sciences)',
        fullName: 'Doctor of Philosophy in Veterinary Sciences',
        duration: '3–5 Years',
        intake: 0,
        level: 'PhD'),
    college: College(
        id: '1',
        name: 'IVRI, Bareilly',
        location: 'Bareilly, UP',
        state: 'Uttar Pradesh',
        established: 'Est. 1889',
        tags: [],
        type: 'Public',
        allCourses: [
          Course(
              id: 'c1',
              name: 'BVSc & AH',
              fullName: 'Bachelor of Veterinary Science & Animal Husbandry',
              duration: '5.5 Years',
              intake: 60,
              level: 'UG'),
          Course(
              id: 'c2',
              name: 'MVSc (Animal Nutrition)',
              fullName: 'Master of Veterinary Science in Animal Nutrition',
              duration: '2 Years',
              intake: 15,
              level: 'PG'),
          Course(
              id: 'c5',
              name: 'Ph.D. (Veterinary Sciences)',
              fullName: 'Doctor of Philosophy in Veterinary Sciences',
              duration: '3–5 Years',
              intake: 0,
              level: 'PhD'),
        ]),
  ),
  CourseWithCollege(
    course: Course(
        id: 'c6',
        name: 'Diploma in Animal Husbandry',
        fullName: 'Diploma in Animal Husbandry',
        duration: '2 Years',
        intake: 50,
        level: 'Diploma'),
    college: College(
        id: '6',
        name: 'KVASU, Thrissur',
        location: 'Thrissur, Kerala',
        state: 'Kerala',
        established: 'Est. 2010',
        tags: [],
        type: 'Public',
        allCourses: [
          Course(
              id: 'c6',
              name: 'Diploma in Animal Husbandry',
              fullName: 'Diploma in Animal Husbandry',
              duration: '2 Years',
              intake: 50,
              level: 'Diploma'),
        ]),
  ),
  CourseWithCollege(
    course: Course(
        id: 'c1',
        name: 'BVSc & AH',
        fullName: 'Bachelor of Veterinary Science & Animal Husbandry',
        duration: '5.5 Years',
        intake: 80,
        level: 'UG'),
    college: College(
        id: '2',
        name: 'Madras Veterinary College',
        location: 'Chennai, TN',
        state: 'Tamil Nadu',
        established: 'Est. 1903',
        tags: [],
        type: 'Public',
        allCourses: [
          Course(
              id: 'c1',
              name: 'BVSc & AH',
              fullName: 'Bachelor of Veterinary Science & Animal Husbandry',
              duration: '5.5 Years',
              intake: 80,
              level: 'UG'),
          Course(
              id: 'c3',
              name: 'MVSc (Surgery & Radiology)',
              fullName: 'Master of Veterinary Science in Surgery & Radiology',
              duration: '2 Years',
              intake: 12,
              level: 'PG'),
        ]),
  ),
];