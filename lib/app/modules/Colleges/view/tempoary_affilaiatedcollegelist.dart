import 'package:flutter/material.dart' hide FilterChip;
import 'package:get/get.dart';
import 'package:veterinaryapp/app/widgets/commonwidget.dart' hide EmptyState;
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../data/models/collegelistmodel.dart';
import '../../../no internetconnection/no_connection.dart';
import '../../../widgets/collegecard.dart';
import '../../../widgets/tempory_permanent.dart';
import '../../home/bindings/home_binding.dart';
import '../controller/enquirycontroller.dart';
import '../controller/filitered_collegescontroller.dart';
import '../view/Enquiry_form.dart';
import '../view/collegedtailscreen.dart';

class TemporaryAffiliatedScreen extends StatefulWidget {
  const TemporaryAffiliatedScreen({super.key});

  @override
  State<TemporaryAffiliatedScreen> createState() =>
      _TemporaryAffiliatedScreenState();
}

class _TemporaryAffiliatedScreenState
    extends State<TemporaryAffiliatedScreen> {
  late final FiliteredCollegescontroller c;
  late final EnquiryController _enquiryCtrl;

  @override
  void initState() {
    super.initState();
    c = Get.put(FiliteredCollegescontroller(), tag: 'temporary');
    c.init('temporary');
    _enquiryCtrl = Get.find<EnquiryController>();
  }

  @override
  void dispose() {
    Get.delete<FiliteredCollegescontroller>(tag: 'temporary');
    super.dispose();
  }

  void _openCollegeDetail(CollegeModel college) {
    if (college.id.isEmpty) return;

    if (_enquiryCtrl.shouldShowEnquiryForm(college.type)) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => EnquiryBottomSheet(
          college: college,
          onProceed: () => _pushDetail(college.id),
        ),
      );
    } else {
      _pushDetail(college.id);
    }
  }

  void _pushDetail(String collegeId) {
    Get.to(
          () => CollegeDetailScreen(collegeId: collegeId),
      binding: CollegeDetailBinding(),
      transition: Transition.rightToLeft,
    );
  }

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
    const badgeColor = Color(0xFF0F6E56);
    const badgeBg    = Color(0xFFE1F5EE);

    return NetworkAwareWrapper(child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: VetAppBar(title: 'Temporary Affiliated Colleges'),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.error.value.isNotEmpty) {
          return ErrorView(
            message: c.error.value,
            onRetry: () => c.init('temporary'),
          );
        }
        return Column(children: [
          // ── Affiliation chip ──────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(
                r.spacing(AppDimens.paddingLG),
                r.spacing(AppDimens.paddingMD),
                r.spacing(AppDimens.paddingLG),
                0),
            child: Row(children: [
              AffiliationChip(
                r: r,
                icon: Icons.access_time_rounded,
                label: 'Temporary Affiliated',
                color: badgeColor,
                bg: badgeBg,
              ),
            ]),
          ),

          Obx(() => c.selectedState.value != 'All States'
              ? Padding(
            padding: EdgeInsets.fromLTRB(
                r.spacing(AppDimens.paddingLG),
                r.spacing(AppDimens.paddingSM + 2),
                r.spacing(AppDimens.paddingLG),
                0),
            child: Row(children: [
              FilterChip(
                r: r,
                label: c.selectedState.value,
                color: badgeColor,
                bg: badgeBg,
                onClear: () => c.clearStateFilter('temporary'),
              ),
            ]),
          )
              : const SizedBox.shrink()),

          // ── Count + State Wise ────────────────────────────
          Obx(() => Padding(
            padding: EdgeInsets.fromLTRB(
                r.spacing(AppDimens.paddingLG),
                r.spacing(AppDimens.paddingMD),
                r.spacing(AppDimens.paddingLG),
                0),
            child: Row(children: [
              Text(
                '${c.displayedColleges.length} '
                    'College${c.displayedColleges.length == 1 ? '' : 's'} Found',
                style: AppTextStyles.bodyMedium
                    .copyWith(fontSize: r.fontSize(13)),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _showStateFilter,
                child: Row(children: [
                  Icon(Icons.map_outlined,
                      size: r.fontSize(AppDimens.iconXS + 2),
                      color: badgeColor),
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

          Obx(() {
            if (c.displayedColleges.isEmpty) {
              return Expanded(
                child: EmptyState(
                  icon: Icons.school_outlined,
                  title: 'No Colleges Found',
                  subtitle: c.emptyMessage.value.isNotEmpty
                      ? c.emptyMessage.value
                      : 'Try adjusting your filter',
                ),
              );
            }
            return Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(
                    r.spacing(AppDimens.paddingLG),
                    r.spacing(AppDimens.paddingMD),
                    r.spacing(AppDimens.paddingLG),
                    100),
                itemCount: c.displayedColleges.length,
                itemBuilder: (ctx, i) {
                  final college = c.displayedColleges[i];
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
        ]);
      }),
    ));
  }
}