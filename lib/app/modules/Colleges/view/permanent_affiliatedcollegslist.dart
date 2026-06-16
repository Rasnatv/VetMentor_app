
import 'dart:io';
import 'package:flutter/material.dart' hide FilterChip;
import 'package:get/get.dart';
import 'package:veterinaryapp/app/widgets/commonwidget.dart' hide EmptyState;
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../data/models/collegelistmodel.dart';
import '../../../widgets/collegecard.dart';
import '../../../widgets/tempory_permanent.dart';
import '../controller/enquirycontroller.dart';        // ← add
import '../controller/filitered_collegescontroller.dart';
import '../view/Enquiry_form.dart';                   // ← add
import '../view/collegedtailscreen.dart';             // ← add

class PermanentAffiliatedScreen extends StatefulWidget {
  const PermanentAffiliatedScreen({super.key});

  @override
  State<PermanentAffiliatedScreen> createState() =>
      _PermanentAffiliatedScreenState();
}

class _PermanentAffiliatedScreenState
    extends State<PermanentAffiliatedScreen> {
  late final FiliteredCollegescontroller c;
  late final EnquiryController _enquiryCtrl;   // ← add

  @override
  void initState() {
    super.initState();
    c = Get.put(FiliteredCollegescontroller(), tag: 'permanent');
    c.init('permanent');
    _enquiryCtrl = Get.find<EnquiryController>(); // ← already put in HomeScreen
  }

  @override
  void dispose() {
    Get.delete<FiliteredCollegescontroller>(tag: 'permanent');
    super.dispose();
  }

  // ── Same enquiry-check logic as HomeScreen ────────────────
  void _openCollegeDetail(Map<String, dynamic> college) {
    final String collegeId   = college['id']?.toString() ?? '';
    final String collegeType = college['type']?.toString() ?? '0';
    final bool isEnquiryRequired = collegeType == '0'; // same as CollegeModel

    if (collegeId.isEmpty) return; // safety guard

    final bool shouldSkip;
    if (Platform.isIOS) {
      shouldSkip = _enquiryCtrl.isAlreadyRegistered || !isEnquiryRequired;
    } else {
      shouldSkip = _enquiryCtrl.isAlreadyRegistered;
    }

    if (shouldSkip) {
      _pushDetail(collegeId);
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EnquiryBottomSheet(
        // EnquiryBottomSheet expects a CollegeModel — build a minimal one
        college: _mapToCollegeModel(college),
        onProceed: () => _pushDetail(collegeId),
      ),
    );
  }

  void _pushDetail(String collegeId) {
    Get.to(() => const CollegeDetailScreen(), arguments: collegeId);
  }

  // ── Helpers ───────────────────────────────────────────────
  // Converts raw map → CollegeModel so EnquiryBottomSheet stays unchanged
  CollegeModel _mapToCollegeModel(Map<String, dynamic> m) => CollegeModel(
    id:          m['id']?.toString() ?? '',
    type:        m['type']?.toString() ?? '0',
    collegeName: m['college_name']?.toString() ?? '',
    district:    m['district']?.toString() ?? '',
    state:       m['state']?.toString() ?? '',
  );

  void _showStateFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StateFilterSheet(
        statesObs: c.states,
        selectedObs: c.selectedState,
        onSelect: (state) {
          c.fetchByState(state);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    const badgeColor = Color(0xFF185FA5);
    const badgeBg    = Color(0xFFE6F1FB);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: VetAppBar(title: 'Permanent Affiliated Colleges'),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.error.value.isNotEmpty) {
          return ErrorView(
            message: c.error.value,
            onRetry: () => c.init('permanent'),
          );
        }
        return Column(children: [
          // ── Affiliation chip ──────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(r.spacing(AppDimens.paddingLG),
                r.spacing(AppDimens.paddingMD), r.spacing(AppDimens.paddingLG), 0),
            child: Row(children: [
              AffiliationChip(
                r: r,
                icon: Icons.verified_outlined,
                label: 'Permanent Affiliated',
                color: badgeColor,
                bg: badgeBg,
              ),
            ]),
          ),

          // ── State filter chip ─────────────────────────────
          Obx(() => c.selectedState.value != 'All States'
              ? Padding(
            padding: EdgeInsets.fromLTRB(r.spacing(AppDimens.paddingLG),
                r.spacing(AppDimens.paddingSM + 2),
                r.spacing(AppDimens.paddingLG), 0),
            child: Row(children: [
              FilterChip(
                r: r,
                label: c.selectedState.value,
                color: badgeColor,
                bg: badgeBg,
                onClear: () => c.clearStateFilter('permanent'),
              ),
            ]),
          )
              : const SizedBox.shrink()),

          // ── Count + State Wise ────────────────────────────
          Obx(() => Padding(
            padding: EdgeInsets.fromLTRB(r.spacing(AppDimens.paddingLG),
                r.spacing(AppDimens.paddingMD), r.spacing(AppDimens.paddingLG), 0),
            child: Row(children: [
              Text(
                '${c.displayedColleges.length} College${c.displayedColleges.length == 1 ? '' : 's'} Found',
                style: AppTextStyles.bodyMedium.copyWith(fontSize: r.fontSize(13)),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _showStateFilter,
                child: Row(children: [
                  Icon(Icons.map_outlined,
                      size: r.fontSize(AppDimens.iconXS + 2), color: badgeColor),
                  SizedBox(width: r.spacing(AppDimens.paddingXS)),
                  Text('State Wise',
                      style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: r.fontSize(13),
                          color: badgeColor)),
                ]),
              ),
            ]),
          )),

          // ── List ─────────────────────────────────────────
          Obx(() {
            if (c.isSearching.value) {
              return const Expanded(
                  child: Center(child: CircularProgressIndicator()));
            }
            if (c.displayedColleges.isEmpty) {
              return const Expanded(
                  child: EmptyState(
                    icon: Icons.school_outlined,
                    title: 'No Colleges Found',
                    subtitle: 'Try adjusting your search or filter',
                  ));
            }
            return Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(r.spacing(AppDimens.paddingLG),
                    r.spacing(AppDimens.paddingMD), r.spacing(AppDimens.paddingLG), 100),
                itemCount: c.displayedColleges.length,
                itemBuilder: (ctx, i) {
                  final college = c.displayedColleges[i] as Map<String, dynamic>;
                  return Padding(
                    padding: EdgeInsets.only(bottom: r.spacing(AppDimens.paddingMD)),
                    child: CollegeCard(
                      collegeName: college['college_name'] ?? '',
                      location: '${college['district'] ?? ''}, ${college['state'] ?? ''}',
                      onTap: () => _openCollegeDetail(college), // ← fixed
                    ),
                  );
                },
              ),
            );
          }),
        ]);
      }),
    );
  }
}
