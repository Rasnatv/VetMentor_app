
import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../data/models/collegelistmodel.dart';
import '../../../widgets/collegecard.dart';
import '../../Colleges/view/collegedtailscreen.dart';
import '../../Colleges/view/Enquiry_form.dart';
import '../../Colleges/controller/enquirycontroller.dart';
import '../bindings/home_binding.dart';
import '../controller/searchcontroller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchController  _ctrl        = Get.put(SearchController());
  final EnquiryController _enquiryCtrl = Get.find<EnquiryController>();
  final TextEditingController _textCtrl = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    _textCtrl.addListener(() {
      _ctrl.onQueryChanged(_textCtrl.text);
    });
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _focusNode.dispose();
    _ctrl.clear();
    super.dispose();
  }

  // ✅ /search-colleges has no `type` field at all — CollegeModel and
  // SearchCollegeModel are two separate models from two separate APIs and
  // should NOT be mixed by faking a `type`. CollegeModel no longer carries
  // a `type` field at all; Enquiry_form.dart reads the effective type
  // directly from CollegeController.collegeType.value when submitting.
  CollegeModel _toCollegeModel(SearchCollegeModel s) {
    return CollegeModel(
      id:          s.id.toString(),
      collegeName: s.collegeName,
      district:    s.district,
      state:       s.state,
    );
  }

  // ── Navigation: tap college card ──────────────────────────
  void _openCollegeDetail(SearchCollegeModel searchCollege) {
    final storedType = _enquiryCtrl.registeredCollegeType; // ✅ already stored value

    if (_enquiryCtrl.shouldShowEnquiryForm(storedType)) {
      final college = _toCollegeModel(searchCollege);
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => EnquiryBottomSheet(
          college: college,
          onProceed: () => _pushDetail(searchCollege.id.toString()),
        ),
      );
    } else {
      _pushDetail(searchCollege.id.toString());
    }
  }

  void _pushDetail(String collegeId) {
    Get.to(
          () => CollegeDetailScreen(collegeId: collegeId),
      binding: CollegeDetailBinding(), // ✅ fixed — was CourseDetailBinding()
      transition: Transition.rightToLeft,
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.textPrimary,
          onPressed: () => Get.back(),
        ),
        title: Padding(
          padding: EdgeInsets.only(right: r.spacing(AppDimens.paddingMD)),
          child: _SearchField(
            controller: _textCtrl,
            focusNode: _focusNode,
            onClear: () {
              _textCtrl.clear();
              _ctrl.clear();
            },
          ),
        ),
      ),
      body: Obx(() => _buildBody(r)),
    );
  }

  Widget _buildBody(Responsive r) {
    if (_ctrl.isIdle)    return _buildIdle(r);
    if (_ctrl.isLoading) return _buildLoading(r);
    if (_ctrl.hasError)  return _buildError(r);
    if (_ctrl.isEmpty)   return _buildEmpty(r);
    return _buildResults(r);
  }

  // ── Idle ──────────────────────────────────────────────────
  Widget _buildIdle(Responsive r) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.search_rounded,
          size: r.value(mobile: 56.0, tablet: 72.0),
          color: AppColors.textSecondary.withOpacity(0.35),
        ),
        SizedBox(height: r.spacing(AppDimens.paddingMD)),
        Text(
          'Search colleges',
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: r.fontSize(14),
          ),
        ),
        SizedBox(height: r.spacing(AppDimens.paddingXS)),
        Text(
          'Type at least 2 characters to get results',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: r.fontSize(12),
          ),
        ),
      ],
    ),
  );

  // ── Loading ───────────────────────────────────────────────
  Widget _buildLoading(Responsive r) => const Center(
    child: CircularProgressIndicator(
      color: AppColors.primary,
      strokeWidth: 2,
    ),
  );

  // ── Error ─────────────────────────────────────────────────
  Widget _buildError(Responsive r) => Center(
    child: Padding(
      padding: EdgeInsets.all(r.spacing(AppDimens.paddingXL)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: r.value(mobile: 48.0, tablet: 56.0),
            color: AppColors.textSecondary,
          ),
          SizedBox(height: r.spacing(AppDimens.paddingMD)),
          Text(
            _ctrl.errorMsg.value,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: r.fontSize(12),
            ),
          ),
          SizedBox(height: r.spacing(AppDimens.paddingLG)),
          TextButton.icon(
            onPressed: () => _ctrl.search(_ctrl.query.value),
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Try again'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    ),
  );

  // ── Empty ─────────────────────────────────────────────────
  Widget _buildEmpty(Responsive r) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.search_off_rounded,
          size: r.value(mobile: 48.0, tablet: 56.0),
          color: AppColors.textSecondary.withOpacity(0.4),
        ),
        SizedBox(height: r.spacing(AppDimens.paddingMD)),
        Text(
          'No results found',
          style: AppTextStyles.titleSmall.copyWith(
            fontSize: r.fontSize(14),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: r.spacing(AppDimens.paddingXS)),
        Text(
          'Try a different college name',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: r.fontSize(12),
          ),
        ),
      ],
    ),
  );

  // ── Results ───────────────────────────────────────────────
  Widget _buildResults(Responsive r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            r.spacing(AppDimens.paddingLG),
            r.spacing(AppDimens.paddingMD),
            r.spacing(AppDimens.paddingLG),
            r.spacing(AppDimens.paddingSM),
          ),
          child: Obx(() => Text(
            '${_ctrl.results.length} result${_ctrl.results.length == 1 ? '' : 's'} for "${_ctrl.query.value}"',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: r.fontSize(12),
            ),
          )),
        ),
        const Divider(height: 1, color: AppColors.borderLight),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(
              r.spacing(AppDimens.paddingLG),
              r.spacing(AppDimens.paddingMD),
              r.spacing(AppDimens.paddingLG),
              100,
            ),
            itemCount: _ctrl.results.length,
            separatorBuilder: (_, __) =>
                SizedBox(height: r.spacing(AppDimens.paddingSM)),
            itemBuilder: (_, i) {
              final college = _ctrl.results[i];
              return CollegeCard(
                collegeName: college.collegeName,
                location: '${college.district}, ${college.state}',
                onTap: () => _openCollegeDetail(college),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search colleges...',
          hintStyle: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.textSecondary,
            size: 18,
          ),
          suffixIcon: ValueListenableBuilder(
            valueListenable: controller,
            builder: (_, value, __) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return GestureDetector(
                onTap: onClear,
                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
              );
            },
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
      ),
    );
  }
}