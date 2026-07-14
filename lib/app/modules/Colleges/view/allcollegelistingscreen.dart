
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veterinaryapp/app/widgets/appsnackbar.dart';
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
import '../controller/comparecontroller.dart';
import 'comparescreen.dart';

class CollegeListScreen extends StatefulWidget {
  const CollegeListScreen({super.key});

  @override
  State<CollegeListScreen> createState() => _CollegeListScreenState();
}

class _CollegeListScreenState extends State<CollegeListScreen> {
  final CollegeController _ctrl        = Get.find<CollegeController>();
  final EnquiryController _enquiryCtrl = Get.find<EnquiryController>();

  static const int _maxCompare = 2;

  // ── Selection state (always active, no toggle mode) ─────
  final RxSet<String> _selectedIds = <String>{}.obs;

  void _toggleSelect(CollegeModel college) {
    if (_selectedIds.contains(college.id)) {
      _selectedIds.remove(college.id);
    } else {
      if (_selectedIds.length >= _maxCompare) {
        AppSnackbar.warning(
          'You can compare up to $_maxCompare colleges at a time.',
        );
        return;
      }
      _selectedIds.add(college.id);
    }
  }

  // ── Compare button tap ────────────────────────────────────
  // Gate rule (from EnquiryController.shouldShowEnquiryForm — unchanged):
  //   • Already registered            → skip form, go straight to Compare
  //   • Android + not registered      → always show enquiry form first
  //   • iOS + type == '0' + not reg.  → show enquiry form first
  //   • iOS + type == '1' + not reg.  → skip form, go straight to Compare
  void _goToCompare() {
    if (_selectedIds.length < 2) {
      AppSnackbar.warning(
        'Please select 2 colleges to compare.',
      );
      return;
    }

    final type = _ctrl.collegeType.value; // '0' or '1'
    _enquiryCtrl.markCollegeType(type);

    if (_enquiryCtrl.shouldShowEnquiryForm(type)) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => EnquiryBottomSheet(
          college: null,
          onProceed: _pushCompareScreen,
        ),
      );
    } else {
      _pushCompareScreen();
    }
  }

  void _pushCompareScreen() {
    Get.to(
          () => const CompareCollegesScreen(),
      binding: BindingsBuilder(() {
        Get.put(CompareController());
      }),
      arguments: _selectedIds.toList(),
      transition: Transition.rightToLeft,
    );
  }

  // ── Navigation for single college tap (unchanged gate) ───
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

  void _pushDetail(CollegeModel college) {
    Get.to(
          () => CollegeDetailScreen(collegeId: college.id),
      binding: CollegeDetailBinding(),
      transition: Transition.rightToLeft,
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: VetAppBar(title: 'All Colleges'), // no toggle needed anymore
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
                  r.spacing(AppDimens.paddingXL +
                      80), // room for persistent bottom bar
                ),
                itemCount: list.length,
                itemBuilder: (ctx, i) {
                  final college = list[i];
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: r.spacing(AppDimens.paddingXS)),
                    child: Obx(() {
                      final selected = _selectedIds.contains(college.id);
                      return Stack(
                        children: [
                          CollegeCard(
                            collegeName: college.collegeName,
                            location: college.location,
                            onTap: () => _openCollegeDetail(college),
                          ),
                          // ── Compact tick box ──
                          Positioned(
                            top: 35,
                            right: 10,
                            child: GestureDetector(
                              onTap: () => _toggleSelect(college),
                              behavior: HitTestBehavior.opaque,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: selected ? AppColors.primary : Colors
                                      .white,
                                  border: Border.all(
                                    color: selected
                                        ? AppColors.primary
                                        : AppColors.textSecondary.withOpacity(
                                        0.4),
                                    width: 1.5,
                                  ),
                                  boxShadow: selected
                                      ? []
                                      : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: selected
                                    ? const Icon(
                                    Icons.check, size: 13, color: Colors.white)
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  );
                },
              ));
        }),



        // ── Bottom Compare bar, always visible ────────────────
        bottomNavigationBar: Obx(() => SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: r.spacing(AppDimens.paddingLG),
              vertical: r.spacing(AppDimens.paddingSM),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                _selectedIds.length == 2 ? _goToCompare : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                  AppColors.primary.withOpacity(0.4),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(AppDimens.buttonRadius),
                  ),
                ),
                child: Text(
                  'Compare (${_selectedIds.length}/2)',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
          ),
        )),
      ),
    );
  }

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