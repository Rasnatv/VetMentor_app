
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../core/utils/validator.dart';
import '../../../data/models/college_detailmodel.dart';
import '../../../data/models/collegelistmodel.dart';
import '../../../data/models/studentregistermodel.dart';
import '../../../widgets/fieldwrapper.dart';
import '../../profile/controller/profilecontroller.dart';
import '../controller/enquirycontroller.dart';

class EnquiryBottomSheet extends StatefulWidget {
  final CollegeModel college;

  /// Called ONLY after a successful submit — navigates to detail page
  final VoidCallback onProceed;

  const EnquiryBottomSheet({
    super.key,
    required this.college,
    required this.onProceed,
  });

  @override
  State<EnquiryBottomSheet> createState() => _EnquiryBottomSheetState();
}

class _EnquiryBottomSheetState extends State<EnquiryBottomSheet> {
  final EnquiryController _ctrl = Get.find<EnquiryController>();

  final _formKey   = GlobalKey<FormState>();
  final _firstCtrl = TextEditingController();
  final _lastCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _neetCtrl  = TextEditingController();

  String        _gender          = 'Male';
  StateModel?   _selectedState;
  ProgramModel? _selectedProgram;

  @override
  void initState() {
    super.initState();
    // Auto-select program when only one option is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_ctrl.programs.length == 1) {
        setState(() => _selectedProgram = _ctrl.programs.first);
      }
    });
  }

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _neetCtrl.dispose();
    _ctrl.resetForm();
    super.dispose();
  }

  // ── Input decoration ──────────────────────────────────────
  InputDecoration _dec(String hint, Responsive r) => InputDecoration(
    hintText: hint,
    hintStyle: AppTextStyles.bodySmall.copyWith(
      color: AppColors.textSecondary,
      fontSize: r.fontSize(12),
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: r.spacing(AppDimens.paddingMD),
      vertical: r.spacing(AppDimens.paddingSM + 2),
    ),
    filled: true,
    fillColor: AppColors.backgroundGrey,
    counterText: '', // hides the maxLength counter on all fields
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.inputRadius),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.inputRadius),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.inputRadius),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.inputRadius),
      borderSide: const BorderSide(color: AppColors.error, width: 1.2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.inputRadius),
      borderSide: const BorderSide(color: AppColors.error, width: 1.5),
    ),
    errorStyle: TextStyle(fontSize: r.fontSize(10), height: 1),
    isDense: true,
  );

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final request = StudentRegisterRequest(
      firstName: _firstCtrl.text.trim(),
      lastName:  _lastCtrl.text.trim(),
      gender:    _gender,
      email:     _emailCtrl.text.trim(),
      phoneNo:   _phoneCtrl.text.trim(),
      stateId:   _selectedState?.id ?? '',
      programId: _selectedProgram?.id ?? '',
      neetScore: _neetCtrl.text.trim(),
    );

    await _ctrl.submitEnquiry(request);

    if (_ctrl.isFormSuccess && mounted) {
      await Future.delayed(const Duration(milliseconds: 100));
      Get.delete<ProfileController>(force: true);
      Navigator.pop(context);
      widget.onProceed();
    }
  }

  // ═══════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final r      = Responsive.of(context);
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimens.radiusXXL)),
      ),
      padding: EdgeInsets.only(bottom: bottom),
      constraints: BoxConstraints(
        maxWidth:
        r.value(mobile: double.infinity, tablet: 560, desktop: 640),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(r),
          _buildHeader(r),
          const Divider(height: 1, color: AppColors.borderLight),
          Flexible(child: _buildForm(r)),
        ],
      ),
    );
  }

  // ── Drag handle ───────────────────────────────────────────
  Widget _buildHandle(Responsive r) => Padding(
    padding: EdgeInsets.only(
      top:    r.spacing(AppDimens.paddingSM + 2),
      bottom: r.spacing(AppDimens.paddingXS + 2),
    ),
    child: Container(
      width: 38,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(AppDimens.radiusXS),
      ),
    ),
  );

  // ── Header ────────────────────────────────────────────────
  Widget _buildHeader(Responsive r) => Padding(
    padding: EdgeInsets.fromLTRB(
      r.spacing(AppDimens.paddingXL),
      r.spacing(AppDimens.paddingXS + 2),
      r.spacing(AppDimens.paddingXL),
      r.spacing(AppDimens.paddingLG - 2),
    ),
    child: Row(
      children: [
        Container(
          width:  r.value(mobile: AppDimens.avatarMD, tablet: 52.0),
          height: r.value(mobile: AppDimens.avatarMD, tablet: 52.0),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(AppDimens.radiusMD),
          ),
          child: Icon(
            Icons.edit_note_rounded,
            color: AppColors.primary,
            size: r.value(
                mobile: AppDimens.iconMD, tablet: AppDimens.iconLG),
          ),
        ),
        SizedBox(width: r.spacing(AppDimens.paddingMD)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Enquiry',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: r.fontSize(16),
                ),
              ),
              Text(
                widget.college.collegeName,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: r.fontSize(11),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(AppDimens.radiusSM),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(
              Icons.close_rounded,
              color: AppColors.textSecondary,
              size: r.value(
                  mobile: AppDimens.iconXS + 2,
                  tablet: AppDimens.iconSM),
            ),
          ),
        ),
      ],
    ),
  );

  // ── Form ──────────────────────────────────────────────────
  Widget _buildForm(Responsive r) {
    final hGap   = r.spacing(AppDimens.paddingLG - 2);
    final colGap = r.spacing(AppDimens.paddingMD);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        r.spacing(AppDimens.paddingXL),
        r.spacing(AppDimens.paddingLG),
        r.spacing(AppDimens.paddingXL),
        0,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Name row ──────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: FieldWrapper(
                    label: 'First Name *',
                    child: TextFormField(
                      controller: _firstCtrl,
                      textCapitalization: TextCapitalization.words,
                      maxLength: DValidator.maxTextLength,
                      inputFormatters: DValidator.lettersOnly,
                      decoration: _dec('Arjun', r),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: r.fontSize(13),
                      ),
                      validator: (v) =>
                          DValidator.validateName('First name', v),
                    ),
                  ),
                ),
                SizedBox(width: colGap),
                Expanded(
                  child: FieldWrapper(
                    label: 'Last Name',
                    child: TextFormField(
                      controller: _lastCtrl,
                      textCapitalization: TextCapitalization.words,
                      maxLength: DValidator.maxTextLength,
                      inputFormatters: DValidator.lettersOnly,
                      decoration: _dec('Kumar', r),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: r.fontSize(13),
                      ),
                      // Last name is optional — no validator
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: hGap),

            // ── Gender ────────────────────────────────────
            FieldWrapper(
              label: 'Gender *',
              child: Row(
                children: ['Male', 'Female', 'Other'].map((g) {
                  final active = _gender == g;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _gender = g),
                      child: Container(
                        margin: EdgeInsets.only(
                          right: g != 'Other'
                              ? r.spacing(AppDimens.paddingSM)
                              : 0,
                        ),
                        height: r.value(
                          mobile: AppDimens.buttonHeightSM + 2,
                          tablet: AppDimens.buttonHeight - 4,
                        ),
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.primarySurface
                              : AppColors.backgroundGrey,
                          borderRadius:
                          BorderRadius.circular(AppDimens.inputRadius),
                          border: Border.all(
                            color: active
                                ? AppColors.primary
                                : AppColors.border,
                            width: active ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              g == 'Male'
                                  ? Icons.male_rounded
                                  : g == 'Female'
                                  ? Icons.female_rounded
                                  : Icons.transgender_rounded,
                              size: r.value(
                                mobile: AppDimens.iconXS + 1,
                                tablet: AppDimens.iconSM,
                              ),
                              color: active
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                            SizedBox(
                                width: r.spacing(AppDimens.paddingXS)),
                            Text(
                              g,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: active
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                                fontWeight: active
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                fontSize: r.fontSize(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: hGap),

            // ── Email ─────────────────────────────────────
            FieldWrapper(
              label: 'Email Address *',
              child: TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                maxLength: DValidator.maxTextLength,
                inputFormatters: DValidator.textWithLimit,
                decoration: _dec('arjun@email.com', r),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: r.fontSize(13),
                ),
                validator: (v) => DValidator.validateEmail(v),
              ),
            ),
            SizedBox(height: hGap),

            // ── Phone ─────────────────────────────────────
            FieldWrapper(
              label: 'Phone Number *',
              child: Row(
                children: [
                  Container(
                    width:  r.value(mobile: 58.0, tablet: 66.0),
                    height: r.value(
                      mobile: AppDimens.inputHeight - 4,
                      tablet: AppDimens.inputHeight,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGrey,
                      borderRadius:
                      BorderRadius.circular(AppDimens.inputRadius),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      '+91',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        fontSize: r.fontSize(13),
                      ),
                    ),
                  ),
                  SizedBox(width: r.spacing(AppDimens.paddingSM)),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: DValidator.digitsOnly,
                      decoration: _dec('98765 43210', r),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: r.fontSize(13),
                      ),
                      validator: (v) =>
                          DValidator.validatePhoneNumber(v),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: hGap),

            // ── State dropdown ────────────────────────────
            FieldWrapper(
              label: 'State *',
              child: Obx(() {
                if (_ctrl.dropdownsLoading.value) {
                  return const SizedBox(
                    height: 40,
                    child: Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                return DropdownButtonFormField<StateModel>(
                  value: _selectedState,
                  hint: Text(
                    'Select state',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: r.fontSize(12),
                    ),
                  ),
                  decoration: _dec('', r),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: r.fontSize(13),
                  ),
                  isExpanded: true,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: r.value(
                        mobile: AppDimens.iconXS + 4,
                        tablet: AppDimens.iconSM),
                    color: AppColors.textSecondary,
                  ),
                  validator: (v) =>
                      DValidator.validateDropdown('state', v),
                  items: _ctrl.states
                      .map((s) => DropdownMenuItem(
                    value: s,
                    child: Text(s.stateName,
                        style:
                        TextStyle(fontSize: r.fontSize(13))),
                  ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedState = v),
                );
              }),
            ),
            SizedBox(height: hGap),

            // ── Program dropdown (show only if more than 1) ──
            FieldWrapper(
              label: 'Program Studied *',
              child: Obx(() {
                if (_ctrl.dropdownsLoading.value) {
                  return const SizedBox(
                    height: 40,
                    child: Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }

                // If only 1 program, auto-select and show as plain text
                if (_ctrl.programs.length == 1) {
                  // Ensure it's selected for form submission
                  if (_selectedProgram != _ctrl.programs.first) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(
                              () => _selectedProgram = _ctrl.programs.first);
                    });
                  }
                  return Container(
                    width: double.infinity,
                    height: r.value(
                      mobile: AppDimens.inputHeight - 4,
                      tablet: AppDimens.inputHeight,
                    ),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(
                      horizontal: r.spacing(AppDimens.paddingMD),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGrey,
                      borderRadius:
                      BorderRadius.circular(AppDimens.inputRadius),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      _ctrl.programs.first.programName,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: r.fontSize(13),
                      ),
                    ),
                  );
                }

                if (_ctrl.programs.isEmpty) {
                  return Container(
                    width: double.infinity,
                    height: r.value(
                      mobile: AppDimens.inputHeight - 4,
                      tablet: AppDimens.inputHeight,
                    ),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(
                      horizontal: r.spacing(AppDimens.paddingMD),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGrey,
                      borderRadius:
                      BorderRadius.circular(AppDimens.inputRadius),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      'No programs available',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: r.fontSize(13),
                      ),
                    ),
                  );
                }

                // More than 1 program — show dropdown
                return DropdownButtonFormField<ProgramModel>(
                  value: _selectedProgram,
                  hint: Text(
                    'Select program',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: r.fontSize(12),
                    ),
                  ),
                  decoration: _dec('', r),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: r.fontSize(13),
                  ),
                  isExpanded: true,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: r.value(
                        mobile: AppDimens.iconXS + 4,
                        tablet: AppDimens.iconSM),
                    color: AppColors.textSecondary,
                  ),
                  validator: (v) =>
                      DValidator.validateDropdown('program', v),
                  items: _ctrl.programs
                      .map((p) => DropdownMenuItem(
                    value: p,
                    child: Text(p.programName,
                        style:
                        TextStyle(fontSize: r.fontSize(13))),
                  ))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _selectedProgram = v),
                );
              }),
            ),
            SizedBox(height: hGap),

            // ── NEET Score (mandatory) ────────────────────
            FieldWrapper(
              label: 'NEET Score *',
              child: TextFormField(
                controller: _neetCtrl,
                keyboardType: TextInputType.number,
                maxLength: 3,
                inputFormatters: DValidator.digitsOnly,
                decoration: _dec('e.g. 520', r),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: r.fontSize(13),
                ),
                validator: (v) => DValidator.validateNeetScore(v),
              ),
            ),
            SizedBox(height: r.spacing(AppDimens.paddingSM + 2)),

            // ── Privacy note ──────────────────────────────
            Row(
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: r.value(
                      mobile: AppDimens.iconXS - 2,
                      tablet: AppDimens.iconXS),
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: r.spacing(AppDimens.paddingXS + 1)),
                Expanded(
                  child: Text(
                    'Your information is safe and never shared with third parties.',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: r.fontSize(10),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),

            // ── API error message ─────────────────────────
            Obx(() {
              if (_ctrl.formError.value.isEmpty)
                return const SizedBox.shrink();
              return Padding(
                padding:
                EdgeInsets.only(top: r.spacing(AppDimens.paddingSM)),
                child: Text(
                  _ctrl.formError.value,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.error,
                    fontSize: r.fontSize(12),
                  ),
                ),
              );
            }),

            SizedBox(height: r.spacing(AppDimens.paddingLG)),

            // ── Submit button ─────────────────────────────
            Obx(() {
              final loading = _ctrl.isFormLoading;
              return SizedBox(
                width: double.infinity,
                height: r.value(
                  mobile: AppDimens.buttonHeight,
                  tablet: AppDimens.buttonHeight + 4,
                ),
                child: ElevatedButton(
                  onPressed: loading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                    AppColors.primary.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(AppDimens.buttonRadius),
                    ),
                    elevation: 0,
                  ),
                  child: loading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.send_rounded,
                        size: r.value(
                            mobile: AppDimens.iconXS + 4,
                            tablet: AppDimens.iconSM),
                      ),
                      SizedBox(
                          width:
                          r.spacing(AppDimens.paddingSM)),
                      Text(
                        'Submit & View College Details',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: Colors.white,
                          fontSize: r.fontSize(14),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            SizedBox(
                height: r.bottomPadding +
                    r.spacing(AppDimens.paddingSM)),
          ],
        ),
      ),
    );
  }
}