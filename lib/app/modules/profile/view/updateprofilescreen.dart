
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veterinaryapp/app/widgets/commonwidget.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../data/models/studentprofilemodel.dart';
import '../../../data/models/studentregistermodel.dart';
import '../../../widgets/fieldwrapper.dart';
import '../controller/profilecontroller.dart';

class UpdateProfileScreen extends StatefulWidget {
  final StudentProfileModel profile;

  const UpdateProfileScreen({super.key, required this.profile});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final ProfileController _ctrl = Get.find<ProfileController>();

  final _formKey       = GlobalKey<FormState>();
  late final TextEditingController _firstCtrl;
  late final TextEditingController _lastCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _neetCtrl;

  String        _gender          = 'Male';
  StateModel?   _selectedState;
  ProgramModel? _selectedProgram;

  @override
  void initState() {
    super.initState();
    _firstCtrl = TextEditingController(text: widget.profile.firstName);
    _lastCtrl  = TextEditingController(text: widget.profile.lastName);
    _emailCtrl = TextEditingController(text: widget.profile.email);
    _phoneCtrl = TextEditingController(text: widget.profile.phoneNo);
    _neetCtrl  = TextEditingController(text: widget.profile.netScore);
    _gender    = widget.profile.gender.isNotEmpty ? widget.profile.gender : 'Male';

    // Pre-select state & program once dropdowns are ready
    WidgetsBinding.instance.addPostFrameCallback((_) => _preselectDropdowns());
  }

  void _preselectDropdowns() {
    // Match by name since the profile returns name strings, not IDs
    final matchedState = _ctrl.states.firstWhereOrNull(
          (s) => s.stateName == widget.profile.state,
    );
    final matchedProgram = _ctrl.programs.firstWhereOrNull(
          (p) => p.programName == widget.profile.program,
    );
    if (mounted) {
      setState(() {
        _selectedState   = matchedState;
        _selectedProgram = matchedProgram;
      });
    }
  }

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _neetCtrl.dispose();
    super.dispose();
  }

  // ── Input decoration (mirrors EnquiryBottomSheet) ─────────
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

  // ── Submit ────────────────────────────────────────────────
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _ctrl.updateProfile(
      id:        widget.profile.id,
      firstName: _firstCtrl.text.trim(),
      lastName:  _lastCtrl.text.trim(),
      gender:    _gender,
      email:     _emailCtrl.text.trim(),
      phoneNo:   _phoneCtrl.text.trim(),
      stateId:   _selectedState?.id ?? '',
      programId: _selectedProgram?.id ?? '',
      netScore:  _neetCtrl.text.trim(),
    );

    if (success && mounted) Navigator.pop(context);
  }

  // ═══════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final r      = Responsive.of(context);
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: VetAppBar(

        title: 'Update Profile',
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.all(r.spacing(AppDimens.paddingSM)),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                borderRadius: BorderRadius.circular(AppDimens.radiusSM),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary,
                size: r.value(mobile: AppDimens.iconXS + 2, tablet: AppDimens.iconSM),
              ),
            ),
          ),
        ),),

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              r.spacing(AppDimens.paddingXL),
              r.spacing(AppDimens.paddingLG),
              r.spacing(AppDimens.paddingXL),
              bottom + r.spacing(AppDimens.paddingXL),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Section header ────────────────────────
                  _SectionLabel(
                    r: r,
                    title: 'Personal Information',
                    icon: Icons.person_outline_rounded,
                  ),
                  SizedBox(height: r.spacing(AppDimens.paddingMD)),

                  // ── Name row ──────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: FieldWrapper(
                          label: 'First Name *',
                          child: TextFormField(
                            controller: _firstCtrl,
                            textCapitalization: TextCapitalization.words,
                            decoration: _dec('Arjun', r),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: r.fontSize(13),
                            ),
                            validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                          ),
                        ),
                      ),
                      SizedBox(width: r.spacing(AppDimens.paddingMD)),
                      Expanded(
                        child: FieldWrapper(
                          label: 'Last Name',
                          child: TextFormField(
                            controller: _lastCtrl,
                            textCapitalization: TextCapitalization.words,
                            decoration: _dec('Kumar', r),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: r.fontSize(13),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: r.spacing(AppDimens.paddingLG - 2)),

                  // ── Gender ────────────────────────────────
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
                                borderRadius: BorderRadius.circular(
                                  AppDimens.inputRadius,
                                ),
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
                                      width:
                                      r.spacing(AppDimens.paddingXS)),
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
                  SizedBox(height: r.spacing(AppDimens.paddingLG - 2)),

                  // ── Email ─────────────────────────────────
                  FieldWrapper(
                    label: 'Email Address *',
                    child: TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _dec('arjun@email.com', r),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: r.fontSize(13),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        if (!RegExp(r'^[\w.+\-]+@[\w\-]+\.[a-zA-Z]+$')
                            .hasMatch(v.trim())) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: r.spacing(AppDimens.paddingLG - 2)),

                  // ── Phone ─────────────────────────────────
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
                            decoration: _dec('98765 43210', r)
                                .copyWith(counterText: ''),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: r.fontSize(13),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty)
                                return 'Required';
                              if (v.trim().length < 10)
                                return 'Enter 10-digit number';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: r.spacing(AppDimens.paddingXL)),

                  // ── Section: Academic ─────────────────────
                  _SectionLabel(
                    r: r,
                    title: 'Academic Information',
                    icon: Icons.school_outlined,
                  ),
                  SizedBox(height: r.spacing(AppDimens.paddingMD)),

                  // ── State dropdown ────────────────────────
                  FieldWrapper(
                    label: 'State *',
                    child: Obx(() {
                      if (_ctrl.dropdownsLoading.value) {
                        return _loadingField(r);
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
                            tablet: AppDimens.iconSM,
                          ),
                          color: AppColors.textSecondary,
                        ),
                        validator: (v) =>
                        v == null ? 'Please select a state' : null,
                        items: _ctrl.states
                            .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.stateName,
                              style: TextStyle(
                                  fontSize: r.fontSize(13))),
                        ))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _selectedState = v),
                      );
                    }),
                  ),
                  SizedBox(height: r.spacing(AppDimens.paddingLG - 2)),

                  // ── Program dropdown ──────────────────────
                  FieldWrapper(
                    label: 'Program Studied *',
                    child: Obx(() {
                      if (_ctrl.dropdownsLoading.value) {
                        return _loadingField(r);
                      }
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
                            tablet: AppDimens.iconSM,
                          ),
                          color: AppColors.textSecondary,
                        ),
                        validator: (v) =>
                        v == null ? 'Please select a program' : null,
                        items: _ctrl.programs
                            .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(p.programName,
                              style: TextStyle(
                                  fontSize: r.fontSize(13))),
                        ))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _selectedProgram = v),
                      );
                    }),
                  ),
                  SizedBox(height: r.spacing(AppDimens.paddingLG - 2)),

                  // ── NEET Score ────────────────────────────
                  FieldWrapper(
                    label: 'NEET Score (optional)',
                    child: TextFormField(
                      controller: _neetCtrl,
                      keyboardType: TextInputType.number,
                      decoration: _dec('e.g. 520', r),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: r.fontSize(13),
                      ),
                    ),
                  ),
                  SizedBox(height: r.spacing(AppDimens.paddingSM + 2)),

                  // ── Privacy note ──────────────────────────
                  Row(
                    children: [
                      Icon(
                        Icons.lock_outline_rounded,
                        size: r.value(
                          mobile: AppDimens.iconXS - 2,
                          tablet: AppDimens.iconXS,
                        ),
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

                  SizedBox(height: r.spacing(AppDimens.paddingLG)),

                  // ── Submit button ─────────────────────────
                  Obx(() {
                    final loading = _ctrl.getIsUpdating;
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
                            borderRadius: BorderRadius.circular(
                              AppDimens.buttonRadius,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: loading
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: r.value(
                                mobile: AppDimens.iconXS + 4,
                                tablet: AppDimens.iconSM,
                              ),
                            ),
                            SizedBox(
                                width: r.spacing(
                                    AppDimens.paddingSM)),
                            Text(
                              'Save Changes',
                              style:
                              AppTextStyles.titleSmall.copyWith(
                                color: Colors.white,
                                fontSize: r.fontSize(14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  SizedBox(height: r.spacing(AppDimens.paddingSM)),
                ],
              ),
            ),
          ),

          // ── Full-screen loading overlay ───────────────────
          Obx(() {
            if (!_ctrl.getIsUpdating) return const SizedBox.shrink();
            return Container(
              color: Colors.black.withOpacity(0.35),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(r.spacing(AppDimens.paddingLG)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(AppDimens.radiusMD),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 3,
                      ),
                      SizedBox(height: r.spacing(AppDimens.paddingMD)),
                      Text(
                        'Saving changes…',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: r.fontSize(13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _loadingField(Responsive r) => SizedBox(
    height: 40,
    child: Center(
      child: SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primary,
        ),
      ),
    ),
  );
}


class _SectionLabel extends StatelessWidget {
  final Responsive r;
  final String title;
  final IconData icon;

  const _SectionLabel({
    required this.r,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.circular(AppDimens.radiusSM),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: r.value(mobile: AppDimens.iconXS + 2, tablet: AppDimens.iconSM),
        ),
      ),
      SizedBox(width: r.spacing(AppDimens.paddingSM)),
      Text(
        title,
        style: AppTextStyles.titleSmall.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: r.fontSize(14),
          color: AppColors.textPrimary,
        ),
      ),
    ],
  );
}