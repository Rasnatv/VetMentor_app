import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../widgets/commonwidget.dart';
import '../controller/mentor_controller.dart';


class MentorScreen extends StatelessWidget {
  const MentorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MentorController());
    final r = Responsive.of(context);

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: VetAppBar(showBack: true, title: 'Talk to a Mentor'),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            r.spacing(AppDimens.paddingLG),
            r.spacing(AppDimens.paddingMD),
            r.spacing(AppDimens.paddingLG),
            100,
          ),
          children: [
            Text(
              'Get personal guidance for your BVSc admission',
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: r.fontSize(13),
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: r.spacing(AppDimens.paddingLG)),

            _SectionLabel(r: r, label: 'Featured Channel'),
            SizedBox(height: r.spacing(AppDimens.paddingSM)),
            _YouTubeChannelCard(r: r, controller: controller),

            SizedBox(height: r.spacing(AppDimens.paddingLG)),

            _SectionLabel(r: r, label: 'Contact the Mentor'),
            SizedBox(height: r.spacing(AppDimens.paddingSM)),
            _ContactCard(r: r, controller: controller),

            SizedBox(height: r.spacing(AppDimens.paddingLG)),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showEnquirySheet(context, r, controller),
                icon: Icon(Icons.send_outlined, size: r.fontSize(AppDimens.iconXS + 2)),
                label: Text(
                  'Send Enquiry',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontSize: r.fontSize(13),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: r.spacing(AppDimens.paddingMD)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                  ),
                ),
              ),
            ),
            SizedBox(height: r.spacing(AppDimens.paddingSM)),
            Center(
              child: Text(
                'Typically responds within 24 hours',
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: r.fontSize(11),
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEnquirySheet(BuildContext context, Responsive r, MentorController controller) {
    controller.resetEnquiry();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EnquiryBottomSheet(r: r, controller: controller),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final Responsive r;
  final String label;
  const _SectionLabel({required this.r, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: AppTextStyles.bodySmall.copyWith(
        fontSize: r.fontSize(11),
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
      ),
    );
  }
}

class _YouTubeChannelCard extends StatelessWidget {
  final Responsive r;
  final MentorController controller;
  const _YouTubeChannelCard({required this.r, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          GestureDetector(
            onTap: controller.openYouTubeChannel,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppDimens.radiusLG),
              ),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: r.spacing(160),
                    color: const Color(0xFF1A1A2E),
                    child: Center(
                      child: Icon(
                        Icons.play_circle_fill_rounded,
                        color: Colors.white.withOpacity(0.12),
                        size: r.fontSize(90),
                      ),
                    ),
                  ),
                  Positioned(
                    top: r.spacing(10),
                    left: r.spacing(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.spacing(AppDimens.paddingSM + 2),
                        vertical: r.spacing(3),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF0000),
                        borderRadius: BorderRadius.circular(AppDimens.radiusXS),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 12),
                          SizedBox(width: r.spacing(3)),
                          Text(
                            'YouTube',
                            style: AppTextStyles.labelSmall.copyWith(
                              fontSize: r.fontSize(10),
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: r.spacing(52),
                        height: r.spacing(52),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF0000),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: r.fontSize(AppDimens.iconMD + 4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Channel info
          Padding(
            padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
            child: Row(
              children: [
                Container(
                  width: r.spacing(40),
                  height: r.spacing(40),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF0000).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow_rounded,
                      color: Color(0xFFFF0000), size: 20),
                ),
                SizedBox(width: r.spacing(AppDimens.paddingMD)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VET Admission Mentor',
                        style: AppTextStyles.titleLarge.copyWith(fontSize: r.fontSize(14)),
                      ),
                      SizedBox(height: r.spacing(2)),
                      Text(
                        '@vetadmissionmentor',
                        style: AppTextStyles.bodySmall.copyWith(fontSize: r.fontSize(11)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Visit channel button
          Padding(
            padding: EdgeInsets.fromLTRB(
              r.spacing(AppDimens.paddingMD),
              0,
              r.spacing(AppDimens.paddingMD),
              r.spacing(AppDimens.paddingMD),
            ),
            child: GestureDetector(
              onTap: controller.openYouTubeChannel,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: r.spacing(AppDimens.paddingSM + 2)),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF0000),
                  borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.open_in_new_rounded, color: Colors.white, size: 16),
                    SizedBox(width: r.spacing(AppDimens.paddingXS)),
                    Text(
                      'Visit YouTube Channel',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: r.fontSize(13),
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final Responsive r;
  final MentorController controller;
  const _ContactCard({required this.r, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
            child: Row(
              children: [
                Container(
                  width: r.spacing(44),
                  height: r.spacing(44),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary.withOpacity(0.25)),
                  ),
                  child: Center(
                    child: Text(
                      'VM',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: r.fontSize(13),
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: r.spacing(AppDimens.paddingMD)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VET Admission Mentor',
                      style: AppTextStyles.titleLarge.copyWith(fontSize: r.fontSize(14)),
                    ),
                    SizedBox(height: r.spacing(2)),
                    Text(
                      'BVSc Admission Consultant · Kerala',
                      style: AppTextStyles.bodySmall.copyWith(fontSize: r.fontSize(11)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.border),
          _ContactRow(
            r: r,
            icon: Icons.chat_outlined,
            label: 'WhatsApp',
            value: '+91 95447 33000',
            iconBg: const Color(0xFFE8F5E9),
            iconColor: const Color(0xFF2E7D32),
            onTap: controller.openWhatsApp,
          ),
          Divider(height: 1, color: AppColors.border),
          _ContactRow(
            r: r,
            icon: Icons.phone_outlined,
            label: 'Call',
            value: '+91 95447 33000',
            iconBg: AppColors.primarySurface,
            iconColor: AppColors.primary,
            onTap: controller.callMentor,
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final Responsive r;
  final IconData icon;
  final String label;
  final String value;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback onTap;

  const _ContactRow({
    required this.r,
    required this.icon,
    required this.label,
    required this.value,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: r.spacing(AppDimens.paddingMD),
          vertical: r.spacing(AppDimens.paddingMD - 2),
        ),
        child: Row(
          children: [
            Container(
              width: r.spacing(36),
              height: r.spacing(36),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              ),
              child: Icon(icon, size: r.fontSize(AppDimens.iconXS + 2), color: iconColor),
            ),
            SizedBox(width: r.spacing(AppDimens.paddingMD)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: r.fontSize(11))),
                  SizedBox(height: r.spacing(1)),
                  Text(value, style: AppTextStyles.titleMedium.copyWith(fontSize: r.fontSize(13))),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: r.fontSize(AppDimens.iconXS), color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _EnquiryBottomSheet extends StatelessWidget {
  final Responsive r;
  final MentorController controller;
  const _EnquiryBottomSheet({required this.r, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.radiusXXL)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: r.spacing(AppDimens.paddingMD)),
                width: r.spacing(40),
                height: r.spacing(4),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(AppDimens.radiusXS),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  r.spacing(AppDimens.paddingXL),
                  r.spacing(AppDimens.paddingLG),
                  r.spacing(AppDimens.paddingXL),
                  r.spacing(AppDimens.paddingSM),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Send Enquiry',
                            style: AppTextStyles.headlineLarge
                                .copyWith(fontSize: r.fontSize(16))),
                        SizedBox(height: r.spacing(2)),
                        Text('To VET Admission Mentor',
                            style: AppTextStyles.bodySmall
                                .copyWith(fontSize: r.fontSize(12))),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.close_rounded,
                          color: AppColors.textSecondary,
                          size: r.fontSize(AppDimens.iconMD)),
                    ),
                  ],
                ),
              ),
              const AppDivider(),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  r.spacing(AppDimens.paddingXL),
                  r.spacing(AppDimens.paddingLG),
                  r.spacing(AppDimens.paddingXL),
                  r.spacing(AppDimens.paddingLG),
                ),
                child: Column(
                  children: [
                    _EnquiryField(
                      r: r,
                      label: 'Your Name',
                      hint: 'Enter your full name',
                      icon: Icons.person_outline_rounded,
                      onChanged: (v) => controller.enquiryName.value = v,
                    ),
                    SizedBox(height: r.spacing(AppDimens.paddingMD)),
                    _EnquiryField(
                      r: r,
                      label: 'Phone Number',
                      hint: '+91 XXXXX XXXXX',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      onChanged: (v) => controller.enquiryPhone.value = v,
                    ),
                    SizedBox(height: r.spacing(AppDimens.paddingMD)),
                    _EnquiryField(
                      r: r,
                      label: 'Message (optional)',
                      hint: 'e.g. I need guidance for BVSc admission with 250 NEET score...',
                      icon: Icons.chat_bubble_outline_rounded,
                      maxLines: 3,
                      onChanged: (v) => controller.enquiryMessage.value = v,
                    ),
                    SizedBox(height: r.spacing(AppDimens.paddingXL)),
                    Obx(
                          () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.submitEnquiry,
                          icon: controller.isLoading.value
                              ? SizedBox(
                            width: r.spacing(16),
                            height: r.spacing(16),
                            child: const CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                              : Icon(Icons.send_outlined,
                              size: r.fontSize(AppDimens.iconXS + 2)),
                          label: Text(
                            controller.isLoading.value ? 'Sending...' : 'Submit Enquiry',
                            style: AppTextStyles.titleMedium.copyWith(
                              fontSize: r.fontSize(13),
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                                vertical: r.spacing(AppDimens.paddingMD)),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(AppDimens.radiusMD),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom +
                    r.spacing(AppDimens.paddingSM),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EnquiryField extends StatelessWidget {
  final Responsive r;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;

  const _EnquiryField({
    required this.r,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.titleMedium.copyWith(fontSize: r.fontSize(13))),
        SizedBox(height: r.spacing(AppDimens.paddingXS + 2)),
        TextField(
          maxLines: maxLines,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: AppTextStyles.bodyMedium
              .copyWith(fontSize: r.fontSize(13), color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
                fontSize: r.fontSize(13), color: AppColors.textSecondary),
            prefixIcon: Icon(icon,
                size: r.fontSize(AppDimens.iconXS + 2),
                color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.backgroundGrey,
            contentPadding: EdgeInsets.symmetric(
              horizontal: r.spacing(AppDimens.paddingMD),
              vertical: r.spacing(AppDimens.paddingMD - 2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}