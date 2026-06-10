import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../data/models/coursesmodel.dart';
import '../../../widgets/commonwidget.dart';
import 'coursesdetailscreen.dart';


// ─── Sample Data ──────────────────────────────────────────────────────────────
final List<CourseModel> allCourses = [
  CourseModel(
    id: 'bvsc',
    shortName: 'BVSc & AH',
    fullName: 'Bachelor of Veterinary Science & Animal Husbandry',
    type: 'Degree',
    duration: '5.5 Years',
    eligibility: 'PCB + NEET',
    feesRange: '₹50K–2L/yr',
    salaryRange: '₹4–8 LPA',
    about:
    'A 5.5-year professional degree covering veterinary medicine, surgery, and animal husbandry. Includes 1 year of mandatory clinical internship. Recognised by the Veterinary Council of India (VCI).',
    iconBgColor: AppColors.primarySurface,
    iconColor: AppColors.primary,
    icon: Icons.medical_services_rounded,
    collegeCount: 42,
    subjects: const [
      SubjectModel(name: 'Veterinary Anatomy & Physiology', year: 'Yr 1–2', icon: Icons.biotech_rounded),
      SubjectModel(name: 'Veterinary Pharmacology',         year: 'Yr 2–3', icon: Icons.medication_rounded),
      SubjectModel(name: 'Animal Husbandry & Production',   year: 'Yr 3–4', icon: Icons.agriculture_rounded),
      SubjectModel(name: 'Veterinary Surgery & Radiology',  year: 'Yr 4–5', icon: Icons.healing_rounded),
    ],
    careers: const [
      CareerModel(label: 'Govt Vet Officer',  icon: Icons.local_hospital_rounded),
      CareerModel(label: 'Research & ICAR',   icon: Icons.science_rounded),
      CareerModel(label: 'Defence Services',  icon: Icons.security_rounded),
      CareerModel(label: 'Private Clinic',    icon: Icons.house_rounded),
    ],
    colleges: const [
      CollegeModel(initials: 'KAU',  name: 'Kerala Agricultural University', location: 'Thrissur, Kerala'),
      CollegeModel(initials: 'MVC',  name: 'Madras Veterinary College',       location: 'Chennai, TN'),
      CollegeModel(initials: 'IVRI', name: 'IVRI Bareilly',                   location: 'Bareilly, UP'),
    ],
  ),
  CourseModel(
    id: 'fisheries',
    shortName: 'Diploma in Fisheries Technology',
    fullName: 'Aquaculture, fish breeding & water quality management',
    type: 'Diploma',
    duration: '2 Years',
    eligibility: '10+2 PCB',
    feesRange: '₹20–50K/yr',
    salaryRange: '₹2.5–5 LPA',
    about:
    'A 2-year diploma focusing on aquaculture methods, fish breeding cycles, water quality monitoring, and post-harvest fish processing. Ideal for coastal and inland fisheries careers.',
    iconBgColor: const Color(0xFFEAF3DE),
    iconColor: const Color(0xFF27500A),
    icon: Icons.set_meal_rounded,
    collegeCount: 18,
    subjects: const [
      SubjectModel(name: 'Aquaculture Principles',    year: 'Yr 1', icon: Icons.water_rounded),
      SubjectModel(name: 'Water Quality Management',  year: 'Yr 1', icon: Icons.opacity_rounded),
      SubjectModel(name: 'Fish Pathology',            year: 'Yr 2', icon: Icons.biotech_rounded),
      SubjectModel(name: 'Post-Harvest Technology',   year: 'Yr 2', icon: Icons.inventory_rounded),
    ],
    careers: const [
      CareerModel(label: 'Fisheries Dept',    icon: Icons.account_balance_rounded),
      CareerModel(label: 'Aquaculture Farms', icon: Icons.water_rounded),
      CareerModel(label: 'Fish Research',     icon: Icons.science_rounded),
      CareerModel(label: 'Processing Units',  icon: Icons.factory_rounded),
    ],
    colleges: const [
      CollegeModel(initials: 'CIFE', name: 'CIFE Mumbai',                    location: 'Mumbai, Maharashtra'),
      CollegeModel(initials: 'KAU',  name: 'Kerala Agricultural University', location: 'Thrissur, Kerala'),
      CollegeModel(initials: 'AAU',  name: 'Assam Agricultural University',  location: 'Jorhat, Assam'),
    ],
  ),
  CourseModel(
    id: 'poultry',
    shortName: 'Diploma in Poultry Production',
    fullName: 'Broiler & layer farm management, biosecurity & feed',
    type: 'Diploma',
    duration: '2 Years',
    eligibility: '10+2 Science',
    feesRange: '₹15–40K/yr',
    salaryRange: '₹2–4 LPA',
    about:
    'A 2-year diploma covering commercial broiler and layer farm operations, feed formulation, biosecurity protocols, disease prevention, and poultry business management.',
    iconBgColor: const Color(0xFFFAEEDA),
    iconColor: const Color(0xFF633806),
    icon: Icons.egg_alt_rounded,
    collegeCount: 24,
    subjects: const [
      SubjectModel(name: 'Poultry Breeds & Housing',  year: 'Yr 1', icon: Icons.home_rounded),
      SubjectModel(name: 'Feed Formulation',           year: 'Yr 1', icon: Icons.grass_rounded),
      SubjectModel(name: 'Biosecurity & Vaccination',  year: 'Yr 2', icon: Icons.shield_rounded),
      SubjectModel(name: 'Farm Business Management',   year: 'Yr 2', icon: Icons.bar_chart_rounded),
    ],
    careers: const [
      CareerModel(label: 'Poultry Farms',   icon: Icons.agriculture_rounded),
      CareerModel(label: 'Feed Companies',  icon: Icons.business_rounded),
      CareerModel(label: 'Hatcheries',      icon: Icons.egg_rounded),
      CareerModel(label: 'Self Employment', icon: Icons.person_rounded),
    ],
    colleges: const [
      CollegeModel(initials: 'ICAR', name: 'ICAR-CARI Izatnagar',        location: 'Bareilly, UP'),
      CollegeModel(initials: 'TAU',  name: 'Tamil Nadu Agri University',  location: 'Coimbatore, TN'),
      CollegeModel(initials: 'KVK',  name: 'KVK Kannur',                  location: 'Kannur, Kerala'),
    ],
  ),
  CourseModel(
    id: 'dairy',
    shortName: 'Diploma in Dairy Technology',
    fullName: 'Milk processing, quality testing & dairy farm management',
    type: 'Diploma',
    duration: '2 Years',
    eligibility: '10+2 Science',
    feesRange: '₹15–35K/yr',
    salaryRange: '₹2–4 LPA',
    about:
    'A 2-year diploma program covering milk processing techniques, quality testing, dairy farm management, and value-added product development like cheese, butter, and yogurt.',
    iconBgColor: const Color(0xFFE6F1FB),
    iconColor: const Color(0xFF0C447C),
    icon: Icons.water_drop_rounded,
    collegeCount: 31,
    subjects: const [
      SubjectModel(name: 'Dairy Chemistry',         year: 'Yr 1', icon: Icons.science_rounded),
      SubjectModel(name: 'Milk Processing',          year: 'Yr 1', icon: Icons.blender_rounded),
      SubjectModel(name: 'Quality Testing Methods',  year: 'Yr 2', icon: Icons.biotech_rounded),
      SubjectModel(name: 'Value-Added Products',     year: 'Yr 2', icon: Icons.inventory_2_rounded),
    ],
    careers: const [
      CareerModel(label: 'Dairy Plants',    icon: Icons.factory_rounded),
      CareerModel(label: 'Quality Control', icon: Icons.verified_rounded),
      CareerModel(label: 'NDDB / Amul',     icon: Icons.business_rounded),
      CareerModel(label: 'Self Employment', icon: Icons.person_rounded),
    ],
    colleges: const [
      CollegeModel(initials: 'NDRI', name: 'NDRI Karnal',                    location: 'Karnal, Haryana'),
      CollegeModel(initials: 'ICAR', name: 'ICAR-NDRI',                      location: 'Bengaluru, KA'),
      CollegeModel(initials: 'KAU',  name: 'Kerala Agricultural University', location: 'Thrissur, Kerala'),
    ],
  ),
  CourseModel(
    id: 'health',
    shortName: 'Diploma in Animal Health',
    fullName: 'Disease management, vaccination & first-level treatment',
    type: 'Diploma',
    duration: '2 Years',
    eligibility: '10+2 Biology',
    feesRange: '₹10–30K/yr',
    salaryRange: '₹1.8–3.5 LPA',
    about:
    'A 2-year diploma for aspiring animal health workers covering basic disease management, vaccination schedules, first-level treatment, and community animal health outreach. Ideal for rural healthcare roles.',
    iconBgColor: const Color(0xFFFBEAF0),
    iconColor: const Color(0xFF72243E),
    icon: Icons.favorite_rounded,
    collegeCount: 15,
    subjects: const [
      SubjectModel(name: 'Animal Disease Basics',    year: 'Yr 1', icon: Icons.coronavirus_rounded),
      SubjectModel(name: 'Vaccination Protocols',     year: 'Yr 1', icon: Icons.vaccines_rounded),
      SubjectModel(name: 'First Aid & Treatment',     year: 'Yr 2', icon: Icons.medical_services_rounded),
      SubjectModel(name: 'Community Health Outreach', year: 'Yr 2', icon: Icons.groups_rounded),
    ],
    careers: const [
      CareerModel(label: 'Livestock Inspector', icon: Icons.search_rounded),
      CareerModel(label: 'Govt Health Worker',  icon: Icons.account_balance_rounded),
      CareerModel(label: 'NGO & Rural Work',    icon: Icons.volunteer_activism_rounded),
      CareerModel(label: 'Private Practice',    icon: Icons.local_hospital_rounded),
    ],
    colleges: const [
      CollegeModel(initials: 'KVASU',   name: 'Kerala Vet & Animal Sci Univ', location: 'Thrissur, Kerala'),
      CollegeModel(initials: 'TANUVAS', name: 'TANUVAS Chennai',              location: 'Chennai, TN'),
      CollegeModel(initials: 'OUAT',    name: 'OUAT Bhubaneswar',             location: 'Bhubaneswar, OD'),
    ],
  ),
];

// ─── Courses Listing Screen ───────────────────────────────────────────────────
class CourseListingScreen extends StatefulWidget {
  const CourseListingScreen({super.key});

  @override
  State<CourseListingScreen> createState() => _CourseListingScreenState();
}

class _CourseListingScreenState extends State<CourseListingScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _filters = ['All', 'Degree', 'Diploma', 'Certificate'];

  List<CourseModel> get _filteredCourses {
    return allCourses.where((c) {
      final matchesFilter =
          _selectedFilter == 'All' || c.type == _selectedFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          c.shortName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.fullName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: VetAppBar(
        title: 'All Courses',
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
              icon: const Icon(Icons.tune_rounded,
                  color: AppColors.textPrimary, size: AppDimens.iconSM),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(context),
          _buildFilterChips(),
          Expanded(
            child: _filteredCourses.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: EdgeInsets.fromLTRB(
                AppDimens.paddingLG,
                AppDimens.paddingSM,
                AppDimens.paddingLG,
                AppDimens.paddingXXL,
              ),
              itemCount: _filteredCourses.length,
              itemBuilder: (context, index) =>
                  _buildCourseCard(_filteredCourses[index]),
            ),
          ),
        ],
      ),
    );
  }

  // ── Search Bar ───────────────────────────────────────────────────────────────
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      color: AppColors.backgroundWhite,
      padding: const EdgeInsets.fromLTRB(
        AppDimens.paddingLG,
        AppDimens.paddingSM,
        AppDimens.paddingLG,
        AppDimens.paddingMD,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: AppDimens.buttonHeightSM,
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: TextField(
                controller: _searchController,
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search courses…',
                  hintStyle: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textHint, fontSize: 13),
                  prefixIcon: Icon(Icons.search_rounded,
                      color: AppColors.textHint, size: AppDimens.iconSM),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingMD, vertical: 10),
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
            ),
          ),
          const SizedBox(width: AppDimens.paddingSM),
          Container(
            height: AppDimens.buttonHeightSM,
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingMD),
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Icon(Icons.filter_list_rounded,
                    color: AppColors.textSecondary,
                    size: AppDimens.iconXS + 2),
                const SizedBox(width: 4),
                Text('Filter',
                    style:
                    AppTextStyles.bodyMedium.copyWith(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Filter Chips ─────────────────────────────────────────────────────────────
  Widget _buildFilterChips() {
    return Container(
      color: AppColors.backgroundWhite,
      padding: const EdgeInsets.fromLTRB(
        AppDimens.paddingLG,
        AppDimens.paddingSM,
        AppDimens.paddingLG,
        AppDimens.paddingSM,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((f) {
            final isActive = _selectedFilter == f;
            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin:
                const EdgeInsets.only(right: AppDimens.paddingSM),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingMD,
                    vertical: AppDimens.paddingXS + 2),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.chipGreen
                      : AppColors.backgroundWhite,
                  borderRadius:
                  BorderRadius.circular(AppDimens.radiusFull),
                  border: Border.all(
                    color: isActive
                        ? AppColors.primary
                        : AppColors.border,
                    width: isActive ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  f,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 12,
                    fontWeight: isActive
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: isActive
                        ? AppColors.chipGreenText
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── Course Card ──────────────────────────────────────────────────────────────
  Widget _buildCourseCard(CourseModel course) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CourseDetailScreen(course: course)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimens.paddingSM + 2),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left coloured icon panel
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(AppDimens.radiusMD)),
                child: Container(
                  width: 78,
                  color: course.iconBgColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(course.icon,
                          color: course.iconColor,
                          size: AppDimens.iconLG),
                      const SizedBox(height: 6),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: course.iconColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(
                                AppDimens.radiusFull),
                          ),
                          child: Text(
                            course.type,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: course.iconColor,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Right content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimens.paddingMD),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              course.shortName,
                              style: AppTextStyles.titleLarge,
                            ),
                          ),
                          const SizedBox(width: AppDimens.paddingXS),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.chipGreen,
                              borderRadius: BorderRadius.circular(
                                  AppDimens.radiusXS + 2),
                            ),
                            child: Text(
                              course.duration,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.chipGreenText,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        course.fullName,
                        style:
                        AppTextStyles.bodySmall.copyWith(height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppDimens.paddingSM),
                      Row(
                        children: [
                          _pill(Icons.check_circle_outline_rounded,
                              course.eligibility),
                          const SizedBox(width: 6),
                          _pill(Icons.currency_rupee_rounded,
                              course.feesRange),
                        ],
                      ),
                      const SizedBox(height: AppDimens.paddingSM),
                      Row(
                        children: [
                          Icon(Icons.account_balance_rounded,
                              size: 11, color: AppColors.textHint),
                          const SizedBox(width: 3),
                          Text(
                            '${course.collegeCount} colleges',
                            style: AppTextStyles.bodySmall
                                .copyWith(fontSize: 11),
                          ),
                          const Spacer(),
                          Text(
                            'Know more',
                            style: AppTextStyles.titleGreen
                                .copyWith(fontSize: 12),
                          ),
                          const SizedBox(width: 2),
                          const Icon(Icons.arrow_forward_rounded,
                              size: 13, color: AppColors.primary),
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

  Widget _pill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.iconSecondary),
          const SizedBox(width: 3),
          Text(label,
              style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
        ],
      ),
    );
  }

  // ── Empty State ──────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_off_rounded,
                size: 30, color: AppColors.primary),
          ),
          const SizedBox(height: AppDimens.paddingMD),
          Text('No courses found', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          Text('Try a different search or filter',
              style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}