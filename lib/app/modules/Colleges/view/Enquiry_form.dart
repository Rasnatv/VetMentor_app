
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_form_field/phone_form_field.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../core/utils/validator.dart';
import '../../../data/models/collegelistmodel.dart';
import '../../../data/models/studentregistermodel.dart';
import '../controller/enquirycontroller.dart';

class EnquiryBottomSheet extends StatefulWidget {
  final CollegeModel? college;
  final VoidCallback onProceed;

  const EnquiryBottomSheet({
    super.key,
    this.college,
    required this.onProceed,
  });

  @override
  State<EnquiryBottomSheet> createState() => _EnquiryBottomSheetState();
}

class _EnquiryBottomSheetState extends State<EnquiryBottomSheet>
    with SingleTickerProviderStateMixin {
  final EnquiryController _ctrl = Get.find<EnquiryController>();

  // ── Steps ─────────────────────────────────────────────────────────────────
  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();
  int _currentStep = 0;

  // ── Text controllers ──────────────────────────────────────────────────────
  final _firstCtrl    = TextEditingController();
  final _lastCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _stateCtrl    = TextEditingController();
  final _districtCtrl = TextEditingController();
  final _countryCtrl  = TextEditingController(text: 'India');
  final _addressCtrl  = TextEditingController();
  final _pincodeCtrl  = TextEditingController();
  final _neetCtrl     = TextEditingController();

  final PhoneController _phoneCtrl = PhoneController(
    initialValue: PhoneNumber.parse('+91'),
  );

  String _gender = 'Male';
  ProgramModel? _selectedProgram;

  // ── Animation ─────────────────────────────────────────────────────────────
  late final AnimationController _slideCtrl;
  late final Animation<Offset>   _slideAnim;

  @override
  void initState() {
    super.initState();

    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 280));
    _slideAnim =
        Tween<Offset>(begin: const Offset(0.12, 0), end: Offset.zero).animate(
            CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut));
    _slideCtrl.forward();
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
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
    _ctrl.resetForm();
    super.dispose();
  }

  // ── Decoration ────────────────────────────────────────────────────────────
  InputDecoration _dec(String hint, Responsive r) => InputDecoration(
    hintText: hint,
    hintStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textSecondary, fontSize: r.fontSize(12)),
    contentPadding: EdgeInsets.symmetric(
        horizontal: r.spacing(12), vertical: r.spacing(10)),
    filled: true,
    fillColor: AppColors.backgroundGrey,
    counterText: '',
    border:             _ob(AppColors.border),
    enabledBorder:      _ob(AppColors.border),
    focusedBorder:      _ob(AppColors.primary, w: 1.5),
    errorBorder:        _ob(AppColors.error,   w: 1.2),
    focusedErrorBorder: _ob(AppColors.error,   w: 1.5),
    errorStyle: TextStyle(fontSize: r.fontSize(10), height: 1.2),
    isDense: true,
  );

  OutlineInputBorder _ob(Color c, {double w = 1.0}) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppDimens.inputRadius),
    borderSide: BorderSide(color: c, width: w),
  );

  // ── Step navigation ───────────────────────────────────────────────────────
  void _nextStep() {
    if (!_step1Key.currentState!.validate()) return;
    _slideCtrl.reset();
    setState(() => _currentStep = 1);
    _slideCtrl.forward();
  }

  void _prevStep() {
    _slideCtrl.reset();
    setState(() => _currentStep = 0);
    _slideCtrl.forward();
  }

  Future<void> _handleSubmit() async {
    if (!_step2Key.currentState!.validate()) return;

    final phone = _phoneCtrl.value;
    final nationalNumber = phone?.nsn ?? '';
    final countryCode    = phone?.countryCode != null
        ? '+${phone!.countryCode}'
        : '+91';

    final request = StudentRegisterRequest(
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
      collegeId:   widget.college?.id,
      neetScore:   _neetCtrl.text.trim(),
    );

    await _ctrl.submitEnquiry(request);

    if (_ctrl.isFormSuccess && mounted) {
      await Future.delayed(const Duration(milliseconds: 100));
      Navigator.pop(context);
      widget.onProceed();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════════════════════════════════
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
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
        maxWidth: r.value(mobile: double.infinity, tablet: 560, desktop: 640),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          _buildHeader(r),
          _buildStepIndicator(r),
          const Divider(height: 1, color: AppColors.borderLight),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(bottom: bottom),
              child: SlideTransition(
                position: _slideAnim,
                child: _currentStep == 0
                    ? _buildStep1(r)
                    : _buildStep2(r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Handle ────────────────────────────────────────────────────────────────
  Widget _buildHandle() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Container(
      width: 36, height: 4,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader(Responsive r) => Padding(
    padding: EdgeInsets.fromLTRB(
        r.spacing(16), 0, r.spacing(16), r.spacing(10)),
    child: Row(
      children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.edit_note_rounded,
              color: AppColors.primary, size: 22),
        ),
        SizedBox(width: r.spacing(10)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quick Enquiry',
                  style: AppTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: r.fontSize(15))),
              Text(
                widget.college?.collegeName ?? 'Get in touch with us',
                style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: r.fontSize(11)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 30, height: 30,
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.close_rounded,
                color: AppColors.textSecondary, size: 16),
          ),
        ),
      ],
    ),
  );

  // ── Step indicator ────────────────────────────────────────────────────────
  Widget _buildStepIndicator(Responsive r) => Padding(
    padding: EdgeInsets.fromLTRB(
        r.spacing(16), 0, r.spacing(16), r.spacing(10)),
    child: Row(
      children: [
        _stepDot(0, 'Personal', r),
        Expanded(
          child: Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              color: _currentStep >= 1
                  ? AppColors.primary
                  : AppColors.borderLight,
            ),
          ),
        ),
        _stepDot(1, 'Location & Program', r),
      ],
    ),
  );

  Widget _stepDot(int step, String label, Responsive r) {
    final done   = _currentStep > step;
    final active = _currentStep == step;
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 24, height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (done || active)
                ? AppColors.primary
                : AppColors.borderLight,
          ),
          child: Center(
            child: done
                ? const Icon(Icons.check_rounded,
                color: Colors.white, size: 14)
                : Text('${step + 1}',
                style: TextStyle(
                    color: active
                        ? Colors.white
                        : AppColors.textSecondary,
                    fontSize: r.fontSize(11),
                    fontWeight: FontWeight.w600)),
          ),
        ),
        SizedBox(width: r.spacing(5)),
        Text(label,
            style: AppTextStyles.bodySmall.copyWith(
                fontSize: r.fontSize(11),
                color: (done || active)
                    ? AppColors.primary
                    : AppColors.textSecondary,
                fontWeight:
                active ? FontWeight.w600 : FontWeight.normal)),
      ],
    );
  }

  // ── STEP 1: Personal ──────────────────────────────────────────────────────
  Widget _buildStep1(Responsive r) {
    final gap = r.spacing(12);
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
          r.spacing(16), r.spacing(14), r.spacing(16), r.spacing(16)),
      child: Form(
        key: _step1Key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Name
            Row(children: [
              Expanded(
                child: _label('First Name *',
                  TextFormField(
                    controller: _firstCtrl,
                    textCapitalization: TextCapitalization.words,
                    maxLength: DValidator.maxTextLength,
                    inputFormatters: DValidator.lettersOnly,
                    decoration: _dec('Arjun', r),
                    style: _ts(r),
                    validator: (v) => DValidator.validateName('First name', v),
                  ),
                ),
              ),
              SizedBox(width: r.spacing(10)),
              Expanded(
                child: _label('Last Name',
                  TextFormField(
                    controller: _lastCtrl,
                    textCapitalization: TextCapitalization.words,
                    maxLength: DValidator.maxTextLength,
                    inputFormatters: DValidator.lettersOnly,
                    decoration: _dec('Kumar', r),
                    style: _ts(r),
                  ),
                ),
              ),
            ]),
            SizedBox(height: gap),

            // Gender
            _label('Gender *', _genderRow(r)),
            SizedBox(height: gap),

            // Email
            _label('Email *',
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                maxLength: DValidator.maxTextLength,
                inputFormatters: DValidator.textWithLimit,
                decoration: _dec('arjun@email.com', r),
                style: _ts(r),
                validator: (v) => DValidator.validateEmail(v),
              ),
            ),
            SizedBox(height: gap),

            // Phone
            _label('Phone *',
              PhoneFormField(
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
                decoration: InputDecoration(
                  hintText: 'Phone number',
                  hintStyle: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: r.fontSize(12)),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: r.spacing(12), vertical: r.spacing(10)),
                  filled: true,
                  fillColor: AppColors.backgroundGrey,
                  counterText: '',
                  border:             _ob(AppColors.border),
                  enabledBorder:      _ob(AppColors.border),
                  focusedBorder:      _ob(AppColors.primary, w: 1.5),
                  errorBorder:        _ob(AppColors.error,   w: 1.2),
                  focusedErrorBorder: _ob(AppColors.error,   w: 1.5),
                  errorStyle: TextStyle(
                      fontSize: r.fontSize(10), height: 1.2),
                  isDense: true,
                ),
                validator: DValidator.validatePhoneNumber(context),
              ),
            ),
            SizedBox(height: r.spacing(18)),

            // Next
            SizedBox(
              width: double.infinity,
              height: r.value(
                  mobile: AppDimens.buttonHeight,
                  tablet: AppDimens.buttonHeight + 4),
              child: ElevatedButton(
                onPressed: _nextStep,
                style: _btnStyle(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Next',
                        style: AppTextStyles.titleSmall.copyWith(
                            color: Colors.white,
                            fontSize: r.fontSize(14))),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
            SizedBox(height: r.bottomPadding + r.spacing(8)),
          ],
        ),
      ),
    );
  }

  // ── STEP 2: Location + Program + NEET ────────────────────────────────────
  Widget _buildStep2(Responsive r) {
    final gap = r.spacing(12);
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
          r.spacing(16), r.spacing(14), r.spacing(16), r.spacing(16)),
      child: Form(
        key: _step2Key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // State & District
            Row(children: [
              Expanded(
                child: _label('State *',
                  TextFormField(
                    controller: _stateCtrl,
                    textCapitalization: TextCapitalization.words,
                    maxLength: DValidator.maxTextLength,
                    inputFormatters: DValidator.textWithLimit,
                    decoration: _dec('Kerala', r),
                    style: _ts(r),
                    validator: (v) => DValidator.validateRequired(v),
                  ),
                ),
              ),
              SizedBox(width: r.spacing(10)),
              Expanded(
                child: _label('District *',
                  TextFormField(
                    controller: _districtCtrl,
                    textCapitalization: TextCapitalization.words,
                    maxLength: DValidator.maxTextLength,
                    inputFormatters: DValidator.textWithLimit,
                    decoration: _dec('Palakkad', r),
                    style: _ts(r),
                    validator: (v) => DValidator.validateRequired(v),
                  ),
                ),
              ),
            ]),
            SizedBox(height: gap),

            // Country & Pincode
            Row(children: [
              Expanded(
                child: _label('Country *',
                  TextFormField(
                    controller: _countryCtrl,
                    textCapitalization: TextCapitalization.words,
                    maxLength: DValidator.maxTextLength,
                    inputFormatters: DValidator.textWithLimit,
                    decoration: _dec('India', r),
                    style: _ts(r),
                    validator: (v) => DValidator.validateRequired(v),
                  ),
                ),
              ),
              SizedBox(width: r.spacing(10)),
              Expanded(
                child: _label('Pincode *',
                  TextFormField(
                    controller: _pincodeCtrl,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: DValidator.digitsOnly,
                    decoration: _dec('678001', r),
                    style: _ts(r),
                    validator: (v) => DValidator.validatePincode(v),
                  ),
                ),
              ),
            ]),
            SizedBox(height: gap),

            // Address
            _label('Address *',
              TextFormField(
                controller: _addressCtrl,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 200,
                maxLines: 2,
                minLines: 2,
                inputFormatters: DValidator.textWithLimit,
                decoration: _dec('Near Bus Stand, Main Road', r)
                    .copyWith(alignLabelWithHint: true),
                style: _ts(r),
                validator: (v) => DValidator.validateRequired(v),
              ),
            ),
            SizedBox(height: gap),

            // Program — fixed ordering: loading → empty → single → multi
            _label('Program *', Obx(() {
              // 1. Still fetching
              if (_ctrl.dropdownsLoading.value) return _loadingBox();

              // 2. Fetch done but truly empty
              if (_ctrl.programs.isEmpty) {
                return _staticBox('No programs available', r,
                    placeholder: true);
              }

              // 3. Exactly one program — show static box, set value synchronously
              if (_ctrl.programs.length == 1) {
                _selectedProgram ??= _ctrl.programs.first;
                return _staticBox(_ctrl.programs.first.programName, r);
              }

              // 4. Multiple programs — show dropdown
              return DropdownButtonFormField<ProgramModel>(
                value: _selectedProgram,
                hint: Text('Select program',
                    style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: r.fontSize(12))),
                decoration: _dec('', r),
                style: _ts(r),
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    size: 20, color: AppColors.textSecondary),
                validator: (v) =>
                    DValidator.validateDropdown('program', v),
                items: _ctrl.programs
                    .map((p) => DropdownMenuItem(
                  value: p,
                  child: Text(p.programName,
                      style: TextStyle(fontSize: r.fontSize(13))),
                ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedProgram = v),
              );
            })),
            SizedBox(height: gap),

            // NEET
            _label('NEET Score *',
              TextFormField(
                controller: _neetCtrl,
                keyboardType: TextInputType.number,
                maxLength: 3,
                inputFormatters: DValidator.digitsOnly,
                decoration: _dec('520', r),
                style: _ts(r),
                validator: (v) => DValidator.validateNeetScore(v),
              ),
            ),
            SizedBox(height: r.spacing(6)),

            // Privacy
            Row(
              children: [
                const Icon(Icons.lock_outline_rounded,
                    size: 12, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Your information is safe and never shared.',
                    style: AppTextStyles.bodySmall.copyWith(
                        fontSize: r.fontSize(10),
                        color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),

            // API error
            Obx(() {
              if (_ctrl.formError.value.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_ctrl.formError.value,
                    style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.error,
                        fontSize: r.fontSize(12))),
              );
            }),
            SizedBox(height: r.spacing(14)),

            // Back + Submit
            Row(children: [
              SizedBox(
                height: r.value(
                    mobile: AppDimens.buttonHeight,
                    tablet: AppDimens.buttonHeight + 4),
                child: OutlinedButton(
                  onPressed: _prevStep,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(AppDimens.buttonRadius)),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back_rounded,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text('Back',
                          style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: r.fontSize(13))),
                    ],
                  ),
                ),
              ),
              SizedBox(width: r.spacing(10)),
              Expanded(
                child: Obx(() {
                  final loading = _ctrl.isFormLoading;
                  return SizedBox(
                    height: r.value(
                        mobile: AppDimens.buttonHeight,
                        tablet: AppDimens.buttonHeight + 4),
                    child: ElevatedButton(
                      onPressed: loading ? null : _handleSubmit,
                      style: _btnStyle(),
                      child: loading
                          ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.send_rounded,
                              size: 16, color: Colors.white),
                          const SizedBox(width: 6),
                          Text('Submit',
                              style: AppTextStyles.titleSmall.copyWith(
                                  color: Colors.white,
                                  fontSize: r.fontSize(14))),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ]),
            SizedBox(height: r.bottomPadding + r.spacing(8)),
          ],
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  TextStyle _ts(Responsive r) => AppTextStyles.bodySmall
      .copyWith(color: AppColors.textPrimary, fontSize: r.fontSize(13));

  ButtonStyle _btnStyle() => ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.buttonRadius)),
    elevation: 0,
  );

  Widget _label(String label, Widget child) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500)),
      const SizedBox(height: 4),
      child,
    ],
  );

  Widget _genderRow(Responsive r) => Row(
    children: ['Male', 'Female', 'Other'].map((g) {
      final active = _gender == g;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _gender = g),
          child: Container(
            margin: EdgeInsets.only(
                right: g != 'Other' ? r.spacing(8) : 0),
            height: 36,
            decoration: BoxDecoration(
              color: active
                  ? AppColors.primarySurface
                  : AppColors.backgroundGrey,
              borderRadius:
              BorderRadius.circular(AppDimens.inputRadius),
              border: Border.all(
                  color:
                  active ? AppColors.primary : AppColors.border,
                  width: active ? 1.5 : 1),
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
                  size: 15,
                  color: active
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(g,
                    style: AppTextStyles.bodySmall.copyWith(
                        color: active
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: active
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: r.fontSize(12))),
              ],
            ),
          ),
        ),
      );
    }).toList(),
  );

  Widget _loadingBox() => const SizedBox(
    height: 40,
    child: Center(
      child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2)),
    ),
  );

  Widget _staticBox(String text, Responsive r, {bool placeholder = false}) =>
      Container(
        width: double.infinity,
        height: 40,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: r.spacing(12)),
        decoration: BoxDecoration(
          color: AppColors.backgroundGrey,
          borderRadius: BorderRadius.circular(AppDimens.inputRadius),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(text,
            style: AppTextStyles.bodySmall.copyWith(
                color: placeholder
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
                fontSize: r.fontSize(13))),
      );
}