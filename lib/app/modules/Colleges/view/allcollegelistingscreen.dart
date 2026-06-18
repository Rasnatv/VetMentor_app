//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../core/constants/appcolors.dart';
// import '../../../core/style/dimens.dart';
// import '../../../core/style/textstyle.dart';
// import '../../../core/utils/responsive utiliteclass.dart';
// import '../../../data/models/collegelistmodel.dart';
// import '../../../no internetconnection/no_connection.dart';
// import '../../../widgets/collegecard.dart';
// import '../../../widgets/commonwidget.dart';
// import '../../Colleges/controller/college_controller.dart';
// import '../../Colleges/controller/enquirycontroller.dart';
// import '../../Colleges/view/Enquiry_form.dart';
// import '../../Colleges/view/collegedtailscreen.dart';
//
// class CollegeListScreen extends StatefulWidget {
//   const CollegeListScreen({super.key});
//
//   @override
//   State<CollegeListScreen> createState() => _CollegeListScreenState();
// }
//
// class _CollegeListScreenState extends State<CollegeListScreen> {
//   final CollegeController _ctrl       = Get.find<CollegeController>();
//   final EnquiryController _enquiryCtrl = Get.find<EnquiryController>();
//
//   // ── Navigation ────────────────────────────────────────────
//   void _openCollegeDetail(CollegeModel college) {
//     final bool shouldSkip;
//
//     if (Platform.isIOS) {
//       // iOS: skip form if already registered OR college type is '1'
//       shouldSkip =
//           _enquiryCtrl.isAlreadyRegistered || !college.isEnquiryRequired;
//     } else {
//       // Android: skip form only if already registered
//       shouldSkip = _enquiryCtrl.isAlreadyRegistered;
//     }
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
//       builder: (_) => EnquiryBottomSheet(
//         college: college,
//         onProceed: () => _pushDetail(college),
//       ),
//     );
//   }
//
//   void _pushDetail(CollegeModel college) {
//     Get.to(
//           () => CollegeDetailScreen(collegeId: college.id),
//       transition: Transition.rightToLeft,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final r = Responsive.of(context);
//
//     return NetworkAwareWrapper(
//       child: Scaffold(
//         backgroundColor: AppColors.background,
//         appBar: VetAppBar(title: 'All Colleges'),
//         body: Obx(() {
//           if (_ctrl.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (_ctrl.hasError) {
//             return _buildErrorState(r);
//           }
//
//           final list = _ctrl.filteredColleges.toList();
//
//           if (list.isEmpty) {
//             return _buildEmptyState(r);
//           }
//
//           return RefreshIndicator(
//             onRefresh: () => _ctrl.fetchColleges(forceRefresh: true),
//             color: AppColors.primary,
//             child: ListView.builder(
//               padding: EdgeInsets.fromLTRB(
//                 r.spacing(AppDimens.paddingLG),
//                 r.spacing(AppDimens.paddingMD),
//                 r.spacing(AppDimens.paddingLG),
//                 r.spacing(AppDimens.paddingXL + 20),
//               ),
//               itemCount: list.length,
//               itemBuilder: (ctx, i) {
//                 final college = list[i];
//                 return Padding(
//                   padding: EdgeInsets.only(bottom: r.spacing(AppDimens.paddingMD)),
//                   child:
//                   CollegeCard(
//                     collegeName: college.collegeName,
//                     location: college.location,
//                     onTap: () => _openCollegeDetail(college),
//                   ),
//                 );
//               },
//             ),
//           );
//         }),
//       ),
//     );
//   }
//
//   // ── Top bar with back + title + count ─────────────────────
//   Widget _buildTopBar(Responsive r) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(
//         r.spacing(AppDimens.paddingMD),
//         r.spacing(AppDimens.paddingMD),
//         r.spacing(AppDimens.paddingLG),
//         0,
//       ),
//       child: Row(
//         children: [
//           // Back button
//           GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: Container(
//               width: 38,
//               height: 38,
//               decoration: BoxDecoration(
//                 color: AppColors.backgroundGrey,
//                 borderRadius: BorderRadius.circular(AppDimens.radiusMD),
//                 border: Border.all(color: AppColors.border),
//               ),
//               child: Icon(
//                 Icons.arrow_back_ios_new_rounded,
//                 size: r.fontSize(AppDimens.iconXS + 2),
//                 color: AppColors.textPrimary,
//               ),
//             ),
//           ),
//           SizedBox(width: r.spacing(AppDimens.paddingMD)),
//
//           // Title + count
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'All Colleges',
//                   style: AppTextStyles.headlineLarge.copyWith(
//                     fontSize: r.fontSize(17),
//                   ),
//                 ),
//                 Obx(() {
//                   final count = _ctrl.filteredColleges.length;
//                   return Text(
//                     '$count college${count == 1 ? '' : 's'} found',
//                     style: AppTextStyles.bodySmall.copyWith(
//                       fontSize: r.fontSize(11),
//                       color: AppColors.textSecondary,
//                     ),
//                   );
//                 }),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Empty state ───────────────────────────────────────────
//   Widget _buildEmptyState(Responsive r) {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             Icons.school_outlined,
//             size: r.fontSize(56),
//             color: AppColors.textSecondary.withOpacity(0.4),
//           ),
//           SizedBox(height: r.spacing(AppDimens.paddingMD)),
//           Text(
//             'No colleges found',
//             style: AppTextStyles.titleLarge.copyWith(
//               fontSize: r.fontSize(15),
//               color: AppColors.textSecondary,
//             ),
//           ),
//           SizedBox(height: r.spacing(AppDimens.paddingXS)),
//           Text(
//             'Try a different search or filter',
//             style: AppTextStyles.bodySmall.copyWith(
//               fontSize: r.fontSize(12),
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Error state ───────────────────────────────────────────
//   Widget _buildErrorState(Responsive r) {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.wifi_off_rounded,
//               size: r.fontSize(48), color: AppColors.textSecondary),
//           SizedBox(height: r.spacing(AppDimens.paddingMD)),
//           Text(
//             _ctrl.errorMessage.value,
//             style: AppTextStyles.bodyMedium,
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: r.spacing(AppDimens.paddingMD)),
//           ElevatedButton.icon(
//             onPressed: () => _ctrl.fetchColleges(forceRefresh: true),
//             icon: const Icon(Icons.refresh),
//             label: const Text('Retry'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
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

  void _pushDetail(CollegeModel college) {
    Get.to(
          () => CollegeDetailScreen(collegeId: college.id),
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
                      bottom: r.spacing(AppDimens.paddingMD)),
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