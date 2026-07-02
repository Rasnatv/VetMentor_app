
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../data/models/collegelistmodel.dart';
import '../../../no internetconnection/no_connection.dart';
import '../../../widgets/collegecard.dart';
import '../../../widgets/commonwidget.dart';
import '../../Colleges/controller/college_controller.dart';
import '../../Colleges/controller/enquirycontroller.dart';
import '../../Colleges/view/Enquiry_form.dart';
import '../../Colleges/view/collegedtailscreen.dart';
import '../../home/bindings/home_binding.dart';

class CollegeListScreen extends StatefulWidget {
  const CollegeListScreen({super.key});

  @override
  State<CollegeListScreen> createState() => _CollegeListScreenState();
}

class _CollegeListScreenState extends State<CollegeListScreen> {
  final CollegeController _ctrl        = Get.find<CollegeController>();
  final EnquiryController _enquiryCtrl = Get.find<EnquiryController>();

  // ── Navigation ────────────────────────────────────────────
  void _openCollegeDetail(CollegeModel college) {
    // ✅ "type" is a single flag per API call (from CollegeController),
    // NOT a per-college field anymore — CollegeModel no longer has .type.
    final type = _ctrl.collegeType.value;

    _enquiryCtrl.markCollegeType(type); // ✅ store backend type before form submit

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
  void _pushDetail(CollegeModel college) {
    Get.to(
          () => CollegeDetailScreen(collegeId: college.id),
      binding: CollegeDetailBinding(), // ✅
      transition: Transition.rightToLeft,
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: VetAppBar(title: 'All Colleges'),
        body: Obx(() {
          if (_ctrl.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_ctrl.hasError) {
            return _buildErrorState(r);
          }

          final list = _ctrl.filteredColleges.toList();

          if (list.isEmpty) {
            return _buildEmptyState(r);
          }

          return RefreshIndicator(
            onRefresh: () => _ctrl.fetchColleges(forceRefresh: true),
            color: AppColors.primary,
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(
                r.spacing(AppDimens.paddingLG),
                r.spacing(AppDimens.paddingMD),
                r.spacing(AppDimens.paddingLG),
                r.spacing(AppDimens.paddingXL + 20),
              ),
              itemCount: list.length,
              itemBuilder: (ctx, i) {
                final college = list[i];
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: r.spacing(AppDimens.paddingXS)),
                  child: CollegeCard(
                    collegeName: college.collegeName,
                    location: college.location,
                    onTap: () => _openCollegeDetail(college),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  // ── Empty state ───────────────────────────────────────────
  Widget _buildEmptyState(Responsive r) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.school_outlined,
            size: r.fontSize(56),
            color: AppColors.textSecondary.withOpacity(0.4),
          ),
          SizedBox(height: r.spacing(AppDimens.paddingMD)),
          Text(
            'No colleges found',
            style: AppTextStyles.titleLarge.copyWith(
              fontSize: r.fontSize(15),
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: r.spacing(AppDimens.paddingXS)),
          Text(
            'Try a different search or filter',
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: r.fontSize(12),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Error state ───────────────────────────────────────────
  Widget _buildErrorState(Responsive r) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded,
              size: r.fontSize(48), color: AppColors.textSecondary),
          SizedBox(height: r.spacing(AppDimens.paddingMD)),
          Text(
            _ctrl.errorMessage.value,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: r.spacing(AppDimens.paddingMD)),
          ElevatedButton.icon(
            onPressed: () => _ctrl.fetchColleges(forceRefresh: true),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }
}