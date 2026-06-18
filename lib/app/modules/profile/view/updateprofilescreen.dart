import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:veterinaryapp/app/widgets/commonwidget.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../core/utils/validator.dart';
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

  final _formKey = GlobalKey<FormState>();

  // ── Text controllers ──────────────────────────────────────
  late final TextEditingController _firstCtrl;
  late final TextEditingController _lastCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _stateCtrl;
  late final TextEditingController _districtCtrl;
  late final TextEditingController _countryCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _pincodeCtrl;
  late final TextEditingController _neetCtrl;

  // ── Phone ─────────────────────────────────────────────────
  late final PhoneController _phoneCtrl;

  String _gender = 'Male';
  ProgramModel? _selectedProgram;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;

    _firstCtrl    = TextEditingController(text: p.firstName);
    _lastCtrl     = TextEditingController(text: p.lastName);
    _emailCtrl    = TextEditingController(text: p.email);
    _stateCtrl    = TextEditingController(text: p.state);
    _districtCtrl = TextEditingController(text: p.district);
    _countryCtrl  = TextEditingController(text: p.country.isNotEmpty ? p.country : 'India');
    _addressCtrl  = TextEditingController(text: p.address);
    _pincodeCtrl  = TextEditingController(text: p.pincode);
    _neetCtrl     = TextEditingController(text: p.netScore);
    _gender       = p.gender.isNotEmpty ? p.gender : 'Male';

    // Pre-fill phone with existing country code + number
    final dialCode = p.countryCode.isNotEmpty ? p.countryCode : '+91';
    _phoneCtrl = PhoneController(
      initialValue: PhoneNumber.parse('$dialCode${p.phoneNo}'),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _preselectProgram());
  }

  void _preselectProgram() {
    final matched = _ctrl.programs.firstWhereOrNull(
          (p) => p.programName == widget.profile.program,
    );
    if (mounted) setState(() => _selectedProgram = matched);
  }

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _stateCtrl.dispose();
    _districtCtrl.dispose();
    _countryCtrl.dispose();
    _addressCtrl.dispose();
    _pincodeCtrl.dispose();
    _neetCtrl.dispose();
    super.dispose();
  }

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
    counterText: '',
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

    final phone = _phoneCtrl.value;
    final nationalNumber = phone?.nsn ?? '';
    final countryCode = phone?.countryCode != null
        ? '+${phone!.countryCode}'
        : '+91';

    final success = await _ctrl.updateProfile(
      id:          widget.profile.id,
      firstName:   _firstCtrl.text.trim(),
      lastName:    _lastCtrl.text.trim(),
      gender:      _gender,
      email:       _emailCtrl.text.trim(),
      countryCode: countryCode,
      phoneNo:     nationalNumber,
      state:       _stateCtrl.text.trim(),
      district:    _districtCtrl.text.trim(),
      country:     _countryCtrl.text.trim(),
      address:     _addressCtrl.text.trim(),
      pincode:     _pincodeCtrl.text.trim(),
      programId:   _selectedProgram?.id ?? '',
      netScore:    _neetCtrl.text.trim(),
    );

    if (success && mounted) Navigator.pop(context);
  }

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
                size: r.value(
                    mobile: AppDimens.iconXS + 2, tablet: AppDimens.iconSM),
              ),
            ),
          ),
        ),
      ),
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

                  // ══════════════════════════════════════════
                  // SECTION: Personal Information
                  // ══════════════════════════════════════════
                  _SectionLabel(
                    r: r,
                    title: 'Personal Information',
                    icon: Icons.person_outline_rounded,
                  ),
                  SizedBox(height: r.spacing(AppDimens.paddingMD)),

                  // Name row
                  Row(children: [
                    Expanded(
                      child: FieldWrapper(
                        label: 'First Name *',
                        child: TextFormField(
                          controller: _firstCtrl,
                          textCapitalization: TextCapitalization.words,
                          inputFormatters: DValidator.lettersOnly,
                          decoration: _dec('Arjun', r),
                          style: _ts(r),
                          validator: (v) =>
                              DValidator.validateName('First Name', v),
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
                          inputFormatters: DValidator.lettersOnly,
                          decoration: _dec('Kumar', r),
                          style: _ts(r),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: r.spacing(AppDimens.paddingLG - 2)),

                  // Gender
                  FieldWrapper(
                    label: 'Gender *',
                    child: _GenderRow(
                      r: r,
                      selected: _gender,
                      onChanged: (g) => setState(() => _gender = g),
                    ),
                  ),
                  SizedBox(height: r.spacing(AppDimens.paddingLG - 2)),

                  // Email
                  FieldWrapper(
                    label: 'Email Address *',
                    child: TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: DValidator.textWithLimit,
                      decoration: _dec('arjun@email.com', r),
                      style: _ts(r),
                      validator: (v) => DValidator.validateEmail(v),
                    ),
                  ),
                  SizedBox(height: r.spacing(AppDimens.paddingLG - 2)),

                  // Phone
                  FieldWrapper(
                    label: 'Phone Number *',
                    child: PhoneFormField(
                      controller: _phoneCtrl,
                      countryButtonStyle: CountryButtonStyle(
                        showDialCode: true,
                        showFlag: true,
                        flagSize: 20,
                        textStyle: _ts(r).copyWith(fontWeight: FontWeight.w600),
                      ),
                      shouldLimitLengthByCountry: true,
                      keyboardType: TextInputType.phone,
                      style: _ts(r),
                      decoration: _dec('Phone number', r),
                      validator: PhoneValidator.compose([
                        PhoneValidator.required(context,
                            errorText: 'Phone number is required'),
                        PhoneValidator.validMobile(context,
                            errorText: 'Enter a valid mobile number'),
                      ]),
                    ),
                  ),
                  SizedBox(height: r.spacing(AppDimens.paddingXL)),

                  // ══════════════════════════════════════════
                  // SECTION: Location Information
                  // ══════════════════════════════════════════
                  _SectionLabel(
                    r: r,
                    title: 'Location Information',
                    icon: Icons.location_on_outlined,
                  ),
                  SizedBox(height: r.spacing(AppDimens.paddingMD)),

                  // State & District
                  Row(children: [
                    Expanded(
                      child: FieldWrapper(
                        label: 'State *',
                        child: TextFormField(
                          controller: _stateCtrl,
                          textCapitalization: TextCapitalization.words,
                          inputFormatters: DValidator.textWithLimit,
                          decoration: _dec('Kerala', r),
                          style: _ts(r),
                          validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                        ),
                      ),
                    ),
                    SizedBox(width: r.spacing(AppDimens.paddingMD)),
                    Expanded(
                      child: FieldWrapper(
                        label: 'District *',
                        child: TextFormField(
                          controller: _districtCtrl,
                          textCapitalization: TextCapitalization.words,
                          inputFormatters: DValidator.textWithLimit,
                          decoration: _dec('Palakkad', r),
                          style: _ts(r),
                          validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: r.spacing(AppDimens.paddingLG - 2)),

                  // Country & Pincode
                  Row(children: [
                    Expanded(
                      child: FieldWrapper(
                        label: 'Country *',
                        child: TextFormField(
                          controller: _countryCtrl,
                          textCapitalization: TextCapitalization.words,
                          inputFormatters: DValidator.textWithLimit,
                          decoration: _dec('India', r),
                          style: _ts(r),
                          validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                        ),
                      ),
                    ),
                    SizedBox(width: r.spacing(AppDimens.paddingMD)),
                    Expanded(
                      child: FieldWrapper(
                        label: 'Pincode *',
                        child: TextFormField(
                          controller: _pincodeCtrl,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          inputFormatters: DValidator.digitsOnly,
                          decoration: _dec('678001', r),
                          style: _ts(r),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Required';
                            if (v.trim().length < 6) return '6 digits needed';
                            return null;
                          },
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: r.spacing(AppDimens.paddingLG - 2)),

                  // Address
                  FieldWrapper(
                    label: 'Address *',
                    child: TextFormField(
                      controller: _addressCtrl,
                      textCapitalization: TextCapitalization.sentences,
                      maxLength: 200,
                      maxLines: 2,
                      minLines: 2,
                      inputFormatters: DValidator.textWithLimit,
                      decoration: _dec('Near Bus Stand, Main Road', r)
                          .copyWith(alignLabelWithHint: true),
                      style: _ts(r),
                      validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                  ),
                  SizedBox(height: r.spacing(AppDimens.paddingXL)),

                  // ══════════════════════════════════════════
                  // SECTION: Academic Information
                  // ══════════════════════════════════════════
                  _SectionLabel(
                    r: r,
                    title: 'Academic Information',
                    icon: Icons.school_outlined,
                  ),
                  SizedBox(height: r.spacing(AppDimens.paddingMD)),

                  // Program dropdown
                  FieldWrapper(
                    label: 'Program *',
                    child: Obx(() {
                      if (_ctrl.dropdownsLoading.value) {
                        return _loadingField();
                      }
                      if (_ctrl.programs.length == 1) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_selectedProgram != _ctrl.programs.first) {
                            setState(() => _selectedProgram = _ctrl.programs.first);
                          }
                        });
                        return _staticBox(_ctrl.programs.first.programName, r);
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
                        style: _ts(r),
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded,
                            size: 20, color: AppColors.textSecondary),
                        validator: (v) =>
                        v == null ? 'Select a program' : null,
                        items: _ctrl.programs
                            .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(p.programName,
                              style: TextStyle(
                                  fontSize: r.fontSize(13))),
                        ))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedProgram = v),
                      );
                    }),
                  ),
                  SizedBox(height: r.spacing(AppDimens.paddingLG - 2)),

                  // NEET Score
                  FieldWrapper(
                    label: 'NEET Score (optional)',
                    child: TextFormField(
                      controller: _neetCtrl,
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      inputFormatters: DValidator.digitsOnly,
                      decoration: _dec('e.g. 520', r),
                      style: _ts(r),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return null;
                        return DValidator.validateNeetScore(v);
                      },
                    ),
                  ),
                  SizedBox(height: r.spacing(AppDimens.paddingSM + 2)),

                  // Privacy note
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
                  SizedBox(height: r.spacing(AppDimens.paddingLG)),

                  // Submit button
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
                              Icons.check_circle_outline_rounded,
                              size: r.value(
                                  mobile: AppDimens.iconXS + 4,
                                  tablet: AppDimens.iconSM),
                            ),
                            SizedBox(
                                width: r.spacing(AppDimens.paddingSM)),
                            Text(
                              'Save Changes',
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
                  SizedBox(height: r.spacing(AppDimens.paddingSM)),
                ],
              ),
            ),
          ),

          // Full-screen loading overlay
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

  TextStyle _ts(Responsive r) => AppTextStyles.bodySmall.copyWith(
      color: AppColors.textPrimary, fontSize: r.fontSize(13));

  Widget _loadingField() => const SizedBox(
    height: 40,
    child: Center(
      child: SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
      ),
    ),
  );

  Widget _staticBox(String text, Responsive r) => Container(
    width: double.infinity,
    height: 40,
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.symmetric(horizontal: r.spacing(AppDimens.paddingMD)),
    decoration: BoxDecoration(
      color: AppColors.backgroundGrey,
      borderRadius: BorderRadius.circular(AppDimens.inputRadius),
      border: Border.all(color: AppColors.border),
    ),
    child: Text(text,
        style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textPrimary, fontSize: r.fontSize(13))),
  );
}

// ─────────────────────────────────────────────────────────────
// Gender Row
// ─────────────────────────────────────────────────────────────
class _GenderRow extends StatelessWidget {
  final Responsive r;
  final String selected;
  final ValueChanged<String> onChanged;
  const _GenderRow({
    required this.r,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ['Male', 'Female', 'Other'].map((g) {
        final active = selected == g;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(g),
            child: Container(
              margin: EdgeInsets.only(
                  right: g != 'Other' ? r.spacing(AppDimens.paddingSM) : 0),
              height: r.value(
                mobile: AppDimens.buttonHeightSM + 2,
                tablet: AppDimens.buttonHeight - 4,
              ),
              decoration: BoxDecoration(
                color: active
                    ? AppColors.primarySurface
                    : AppColors.backgroundGrey,
                borderRadius: BorderRadius.circular(AppDimens.inputRadius),
                border: Border.all(
                  color: active ? AppColors.primary : AppColors.border,
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
                        mobile: AppDimens.iconXS + 1, tablet: AppDimens.iconSM),
                    color: active ? AppColors.primary : AppColors.textSecondary,
                  ),
                  SizedBox(width: r.spacing(AppDimens.paddingXS)),
                  Text(
                    g,
                    style: AppTextStyles.bodySmall.copyWith(
                      color:
                      active ? AppColors.primary : AppColors.textSecondary,
                      fontWeight:
                      active ? FontWeight.w600 : FontWeight.normal,
                      fontSize: r.fontSize(12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Section Label
// ─────────────────────────────────────────────────────────────
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
          size: r.value(
              mobile: AppDimens.iconXS + 2, tablet: AppDimens.iconSM),
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