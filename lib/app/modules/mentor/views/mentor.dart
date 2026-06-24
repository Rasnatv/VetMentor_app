
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../data/models/collegelistmodel.dart';
import '../../../widgets/commonwidget.dart';
import '../../Colleges/controller/enquirycontroller.dart';
import '../../Colleges/view/Enquiry_form.dart';
import '../controller/mentor_controller.dart';

class MentorScreen extends StatefulWidget {
  const MentorScreen({super.key});

  @override
  State<MentorScreen> createState() => _MentorScreenState();
}

class _MentorScreenState extends State<MentorScreen> {
  late final MentorController controller;
  late final EnquiryController enquiryCtrl;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MentorController()); // ✅ moved from build
    enquiryCtrl = Get.find<EnquiryController>();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: VetAppBar(showBack: false, title: 'Talk to a Mentor'),
        body: RefreshIndicator(
          onRefresh: controller.fetchVideos,
          color: AppColors.primary,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
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

              // ── Show enquiry button ONLY when NOT registered ──────────
              Obx(() {
                if (enquiryCtrl.isAlreadyRegistered) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: r.spacing(AppDimens.paddingLG)),
                    ElevatedButton.icon(
                      onPressed: () =>
                          _showEnquirySheet(context, r, enquiryCtrl),
                      icon: Icon(
                        Icons.send_outlined,
                        size: r.fontSize(AppDimens.iconXS + 2),
                      ),
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
                        padding: EdgeInsets.symmetric(
                            vertical: r.spacing(AppDimens.paddingMD)),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(AppDimens.radiusMD),
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
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showEnquirySheet(
      BuildContext context, Responsive r, EnquiryController enquiryCtrl) {
    final mentorCollege = CollegeModel(
      id: '',
      type: '0',
      collegeName: 'VET Admission Mentor',
      district: '',
      state: '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EnquiryBottomSheet(
        college: mentorCollege,
        onProceed: () {
          Future.microtask(() {
            Get.snackbar(
              '',
              '',
              titleText: Row(
                children: const [
                  Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Enquiry Submitted!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              messageText: const Text(
                'The mentor will get back to you within 24 hours.',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              backgroundColor: const Color(0xFF2E7D32),
              snackPosition: SnackPosition.TOP,
              margin: const EdgeInsets.all(16),
              borderRadius: 12,
              duration: const Duration(seconds: 3),
              icon: null,
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            );
          });
        },
      ),
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
          // ── Thumbnail ────────────────────────────────────────────────────
          Obx(() {
            final isLoading = controller.isVideosLoading.value;
            final videos = controller.videos;
            final firstVideo = videos.isNotEmpty ? videos.first : null;

            return GestureDetector(
              onTap: firstVideo != null
                  ? () => controller.openVideo(firstVideo)
                  : controller.openYouTubeChannel,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppDimens.radiusLG),
                ),
                child: Stack(
                  children: [
                    // Thumbnail / fallback
                    SizedBox(
                      width: double.infinity,
                      height: r.spacing(180),
                      child: isLoading
                          ? _ThumbnailSkeleton(r: r)
                          : (firstVideo?.thumbnailUrl != null
                          ? Image.network(
                        firstVideo!.thumbnailUrl!,
                        width: double.infinity,
                        height: r.spacing(180),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _ThumbnailFallback(r: r),
                      )
                          : _ThumbnailFallback(r: r)),
                    ),

                    // Dark scrim
                    if (!isLoading)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.45),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // YouTube badge – top left
                    if (!isLoading)
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
                            borderRadius:
                            BorderRadius.circular(AppDimens.radiusXS),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.play_arrow_rounded,
                                  color: Colors.white, size: 12),
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

                    // Centre play button
                    if (!isLoading)
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            width: r.spacing(56),
                            height: r.spacing(56),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF0000),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: r.fontSize(AppDimens.iconMD + 6),
                            ),
                          ),
                        ),
                      ),

                    // Video count badge – bottom right
                    if (!isLoading && controller.videos.length > 1)
                      Positioned(
                        bottom: r.spacing(8),
                        right: r.spacing(10),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: r.spacing(AppDimens.paddingSM),
                            vertical: r.spacing(3),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.65),
                            borderRadius:
                            BorderRadius.circular(AppDimens.radiusXS),
                          ),
                          child: Text(
                            '${controller.videos.length} videos',
                            style: AppTextStyles.labelSmall.copyWith(
                              fontSize: r.fontSize(10),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),

          // ── Channel info row ─────────────────────────────────────────────
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
                        style: AppTextStyles.titleLarge
                            .copyWith(fontSize: r.fontSize(14)),
                      ),
                      SizedBox(height: r.spacing(2)),
                      Text(
                        '@vetadmissionmentor',
                        style: AppTextStyles.bodySmall
                            .copyWith(fontSize: r.fontSize(11)),
                      ),
                    ],
                  ),
                ),
                // Small refresh icon — manual refresh, independent of pull-to-refresh
                Obx(
                      () => controller.isVideosLoading.value
                      ? SizedBox(
                    width: r.spacing(20),
                    height: r.spacing(20),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                      : GestureDetector(
                    onTap: controller.fetchVideos,
                    child: Icon(
                      Icons.refresh_rounded,
                      size: r.fontSize(AppDimens.iconSM),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Video list (when API returns multiple) ───────────────────────
          Obx(() {
            if (controller.videos.length <= 1) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(height: 1, color: AppColors.border),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.spacing(AppDimens.paddingMD),
                    vertical: r.spacing(AppDimens.paddingSM),
                  ),
                  child: Text(
                    'ALL VIDEOS',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: r.fontSize(10),
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                ...controller.videos.asMap().entries.map((entry) {
                  final index = entry.key;
                  final video = entry.value;
                  return _VideoListTile(
                    r: r,
                    video: video,
                    index: index,
                    onTap: () => controller.openVideo(video),
                  );
                }),
                SizedBox(height: r.spacing(AppDimens.paddingSM)),
              ],
            );
          }),

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
                padding: EdgeInsets.symmetric(
                    vertical: r.spacing(AppDimens.paddingSM + 2)),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF0000),
                  borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.open_in_new_rounded,
                        color: Colors.white, size: 16),
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

// ─────────────────────────────────────────────────────────────────────────────
// Thumbnail helpers
// ─────────────────────────────────────────────────────────────────────────────

class _ThumbnailFallback extends StatelessWidget {
  final Responsive r;
  const _ThumbnailFallback({required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: r.spacing(180),
      color: const Color(0xFF1A1A2E),
      child: Center(
        child: Icon(
          Icons.play_circle_fill_rounded,
          color: Colors.white.withOpacity(0.12),
          size: r.fontSize(90),
        ),
      ),
    );
  }
}

class _ThumbnailSkeleton extends StatefulWidget {
  final Responsive r;
  const _ThumbnailSkeleton({required this.r});

  @override
  State<_ThumbnailSkeleton> createState() => _ThumbnailSkeletonState();
}

class _ThumbnailSkeletonState extends State<_ThumbnailSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.3, end: 0.7).animate(_anim);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (_, __) => Container(
        width: double.infinity,
        height: widget.r.spacing(180),
        color: Color.lerp(
          const Color(0xFF1A1A2E),
          const Color(0xFF2A2A3E),
          _opacity.value,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Video list tile
// ─────────────────────────────────────────────────────────────────────────────

class _VideoListTile extends StatelessWidget {
  final Responsive r;
  final MentorVideo video;
  final int index;
  final VoidCallback onTap;
  const _VideoListTile({
    required this.r,
    required this.video,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: r.spacing(AppDimens.paddingMD),
          vertical: r.spacing(AppDimens.paddingXS + 2),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.radiusSM),
              child: video.thumbnailUrl != null
                  ? Image.network(
                video.thumbnailUrl!,
                width: r.spacing(72),
                height: r.spacing(44),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    _MiniThumbFallback(r: r),
              )
                  : _MiniThumbFallback(r: r),
            ),
            SizedBox(width: r.spacing(AppDimens.paddingMD)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Video ${index + 1}',
                    style: AppTextStyles.titleMedium
                        .copyWith(fontSize: r.fontSize(13)),
                  ),
                  SizedBox(height: r.spacing(2)),
                  Text(
                    'Tap to watch',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: r.fontSize(11),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.play_circle_outline_rounded,
              size: r.fontSize(AppDimens.iconSM),
              color: const Color(0xFFFF0000),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniThumbFallback extends StatelessWidget {
  final Responsive r;
  const _MiniThumbFallback({required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: r.spacing(72),
      height: r.spacing(44),
      color: const Color(0xFF1A1A2E),
      child: const Icon(Icons.play_arrow_rounded,
          color: Colors.white38, size: 20),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Contact Card
// ─────────────────────────────────────────────────────────────────────────────

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
                    border: Border.all(
                        color: AppColors.primary.withOpacity(0.25)),
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
                      style: AppTextStyles.titleLarge
                          .copyWith(fontSize: r.fontSize(14)),
                    ),
                    SizedBox(height: r.spacing(2)),
                    Text(
                      'BVSc Admission Consultant · Kerala',
                      style: AppTextStyles.bodySmall
                          .copyWith(fontSize: r.fontSize(11)),
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
              child: Icon(icon,
                  size: r.fontSize(AppDimens.iconXS + 2), color: iconColor),
            ),
            SizedBox(width: r.spacing(AppDimens.paddingMD)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: AppTextStyles.bodySmall
                          .copyWith(fontSize: r.fontSize(11))),
                  SizedBox(height: r.spacing(1)),
                  Text(value,
                      style: AppTextStyles.titleMedium
                          .copyWith(fontSize: r.fontSize(13))),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: r.fontSize(AppDimens.iconXS),
                color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}