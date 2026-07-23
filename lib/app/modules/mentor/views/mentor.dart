
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../data/models/collegelistmodel.dart';
import '../../../widgets/appsnackbar.dart';
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
    controller = Get.put(MentorController());
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
              // ── Hero banner ───────────────────────────────────────────
              _HeroBanner(r: r),
              SizedBox(height: r.spacing(AppDimens.paddingLG)),

              _SectionLabel(r: r, label: 'Guidance Videos'),
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

  void _showEnquirySheet(BuildContext context, Responsive r,
      EnquiryController enquiryCtrl) {
    final mentorCollege = CollegeModel(
      id: '',
      collegeName: 'VET Admission Mentor',
      district: '',
      state: '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          EnquiryBottomSheet(
            college: mentorCollege,
            onProceed: () {
              Future.microtask(() {
                AppSnackbar.success(
                  'Enquiry submitted! The mentor will get back to you within 24 hours.',
                );
              });
            },
          ),
    );
  }
}

/// ── Hero banner (mirrors the "Need Guidance?" illustration card) ─────────
class _HeroBanner extends StatelessWidget {
  final Responsive r;
  const _HeroBanner({required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.spacing(AppDimens.paddingLG)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primarySurface,
            AppColors.primarySurface.withOpacity(0.55),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Illustration avatar
          Container(
            width: r.spacing(90),
            height: r.spacing(90),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset('assets/images/mentor.png'),
            ),
          ),
          SizedBox(width: r.spacing(AppDimens.paddingMD)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need Guidance?',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontSize: r.fontSize(16),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: r.spacing(4)),
                Text(
                  'Watch short guidance videos and connect with our expert mentors for personalized support on your admission journey.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: r.fontSize(12.5),
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
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

/// ── Featured channel card with a horizontally scrollable guidance-video row ──
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
          // ── Channel info row ─────────────────────────────────────────
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
                        '@vetadmissionmentor · Guidance Videos',
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

          Divider(height: 1, color: AppColors.border),

          // ── Horizontally scrollable guidance-video carousel ──────────
          Padding(
            padding: EdgeInsets.only(top: r.spacing(AppDimens.paddingMD)),
            child: Obx(() {
              final isLoading = controller.isVideosLoading.value;
              final videos = controller.videos;

              if (isLoading) {
                return _VideoCarouselSkeleton(r: r);
              }

              if (videos.isEmpty) {
                return _EmptyVideosState(
                  r: r,
                  onOpenChannel: controller.openYouTubeChannel,
                );
              }

              return SizedBox(
                height: r.spacing(184),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                      horizontal: r.spacing(AppDimens.paddingMD)),
                  itemCount: videos.length,
                  separatorBuilder: (_, __) =>
                      SizedBox(width: r.spacing(AppDimens.paddingSM + 2)),
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return _VideoCardHorizontal(
                      r: r,
                      video: video,
                      index: index,
                      onTap: () => controller.openVideo(video),
                    );
                  },
                ),
              );
            }),
          ),

          SizedBox(height: r.spacing(AppDimens.paddingMD)),

          // ── Visit channel CTA ──────────────────────────────────────────
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
                      'Watch More on YouTube',
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

/// Single horizontally scrolled guidance-video card — thumbnail + play
/// overlay + a real caption (falls back gracefully if the API has no title).
class _VideoCardHorizontal extends StatelessWidget {
  final Responsive r;
  final MentorVideo video;
  final int index;
  final VoidCallback onTap;

  const _VideoCardHorizontal({
    required this.r,
    required this.video,
    required this.index,
    required this.onTap,
  });

  /// Pulls the best available caption text off the video model.
  /// Adjust the field names here if your `MentorVideo` model differs.
  String get _caption {
    final dynamic v = video;
    try {
      final title = v.title as String?;
      if (title != null && title.trim().isNotEmpty) return title.trim();
    } catch (_) {}
    try {
      final name = v.videoTitle as String?;
      if (name != null && name.trim().isNotEmpty) return name.trim();
    } catch (_) {}
    return 'Guidance Video ${index + 1}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: r.spacing(160),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              child: Stack(
                children: [
                  SizedBox(
                    width: r.spacing(160),
                    height: r.spacing(96),
                    child: video.thumbnailUrl != null
                        ? Image.network(
                      video.thumbnailUrl!,
                      width: r.spacing(160),
                      height: r.spacing(96),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _MiniThumbFallback(r: r),
                    )
                        : _MiniThumbFallback(r: r),
                  ),
                  // Dark scrim for legibility
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.35),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Play button
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: r.spacing(34),
                        height: r.spacing(34),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF0000),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: r.fontSize(20),
                        ),
                      ),
                    ),
                  ),
                  // "Guidance" tag badge (replaces plain numeric index)
                  Positioned(
                    top: r.spacing(6),
                    left: r.spacing(6),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.spacing(7),
                        vertical: r.spacing(2),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius:
                        BorderRadius.circular(AppDimens.radiusXS),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.school_rounded,
                              size: r.fontSize(9), color: Colors.white),
                          SizedBox(width: r.spacing(3)),
                          Text(
                            'Guidance',
                            style: AppTextStyles.labelSmall.copyWith(
                              fontSize: r.fontSize(9.5),
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: r.spacing(6)),
            // ── Caption (actual video title, falls back to a friendly label) ──
            Text(
              _caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.titleMedium.copyWith(
                fontSize: r.fontSize(12.5),
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
            SizedBox(height: r.spacing(2)),
            Row(
              children: [
                Icon(Icons.play_circle_outline_rounded,
                    size: r.fontSize(11), color: AppColors.textSecondary),
                SizedBox(width: r.spacing(3)),
                Text(
                  'Tap to watch',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: r.fontSize(10.5),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoCarouselSkeleton extends StatelessWidget {
  final Responsive r;
  const _VideoCarouselSkeleton({required this.r});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: r.spacing(184),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: r.spacing(AppDimens.paddingMD)),
        itemCount: 4,
        separatorBuilder: (_, __) => SizedBox(width: r.spacing(AppDimens.paddingSM + 2)),
        itemBuilder: (_, __) => _ShimmerCard(r: r),
      ),
    );
  }
}

class _ShimmerCard extends StatefulWidget {
  final Responsive r;
  const _ShimmerCard({required this.r});

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
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
    final r = widget.r;
    return SizedBox(
      width: r.spacing(160),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedBuilder(
            animation: _opacity,
            builder: (_, __) => Container(
              width: r.spacing(160),
              height: r.spacing(96),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                color: Color.lerp(
                  const Color(0xFF1A1A2E),
                  const Color(0xFF2A2A3E),
                  _opacity.value,
                ),
              ),
            ),
          ),
          SizedBox(height: r.spacing(8)),
          Container(
            width: r.spacing(120),
            height: r.spacing(10),
            color: AppColors.border,
          ),
          SizedBox(height: r.spacing(6)),
          Container(
            width: r.spacing(80),
            height: r.spacing(10),
            color: AppColors.border,
          ),
          SizedBox(height: r.spacing(6)),
          Container(
            width: r.spacing(60),
            height: r.spacing(8),
            color: AppColors.border,
          ),
        ],
      ),
    );
  }
}

class _EmptyVideosState extends StatelessWidget {
  final Responsive r;
  final VoidCallback onOpenChannel;
  const _EmptyVideosState({required this.r, required this.onOpenChannel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: r.spacing(AppDimens.paddingMD),
        vertical: r.spacing(AppDimens.paddingLG),
      ),
      child: Column(
        children: [
          Icon(Icons.videocam_off_rounded,
              size: r.fontSize(28), color: AppColors.textSecondary),
          SizedBox(height: r.spacing(8)),
          Text(
            'No guidance videos available right now',
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: r.fontSize(12),
              color: AppColors.textSecondary,
            ),
          ),
        ],
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
      width: r.spacing(160),
      height: r.spacing(96),
      color: const Color(0xFF1A1A2E),
      child: const Icon(Icons.play_arrow_rounded,
          color: Colors.white38, size: 28),
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

          // ── Number 1 ─────────────────────────────────────────────
          _ContactRow(
            r: r,
            svgAsset: 'assets/images/whatsapp.svg',
            label: 'WhatsApp',
            value: MentorController.mentorWhatsApp,
            iconBg: const Color(0xFFE8F5E9),
            // ✅ no iconColor → SVG keeps its own native WhatsApp colors
            onTap: controller.openWhatsApp,
          ),
          Divider(height: 1, color: AppColors.border),
          _ContactRow(
            r: r,
            svgAsset: 'assets/images/phone.svg',
            label: 'Call',
            value: MentorController.mentorPhone,
            iconBg: AppColors.primarySurface,
            iconColor: AppColors.primary,
            onTap: controller.callMentor,
          ),
          _ContactRow(
            r: r,
            svgAsset: 'assets/images/phone.svg',
            label: 'Call (Alt)',
            value: MentorController.mentorPhone2,
            iconBg: AppColors.primarySurface,
            iconColor: AppColors.primary,
            onTap: controller.callMentor2,
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final Responsive r;
  final IconData? icon;
  final String? svgAsset;
  final String label;
  final String value;
  final Color iconBg;
  final Color? iconColor;
  final VoidCallback onTap;

  const _ContactRow({
    required this.r,
    this.icon,
    this.svgAsset,
    required this.label,
    required this.value,
    required this.iconBg,
    this.iconColor,
    required this.onTap,
  }) : assert(icon != null || svgAsset != null,
  'Provide either icon or svgAsset');

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
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
                child: Center(
                  child: svgAsset != null
                      ? (iconColor != null
                      ? ColorFiltered(
                    colorFilter:
                    ColorFilter.mode(iconColor!, BlendMode.srcIn),
                    child: SvgPicture.asset(
                      svgAsset!,
                      width: r.fontSize(AppDimens.iconXS + 2),
                      height: r.fontSize(AppDimens.iconXS + 2),
                    ),
                  )
                      : SvgPicture.asset(
                    svgAsset!,
                    width: r.fontSize(AppDimens.iconXS + 2),
                    height: r.fontSize(AppDimens.iconXS + 2),
                  ))
                      : Icon(icon,
                      size: r.fontSize(AppDimens.iconXS + 2),
                      color: iconColor),
                ),
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
      ),
    );
  }
}