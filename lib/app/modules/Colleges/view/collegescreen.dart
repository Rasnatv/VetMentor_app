
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:veterinaryapp/app/modules/Colleges/view/permanent_affiliatedcollegslist.dart';
import 'package:veterinaryapp/app/modules/Colleges/view/tempoary_affilaiatedcollegelist.dart';
import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';
import 'package:veterinaryapp/app/widgets/commonwidget.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';

class AffiliationSelectorScreen extends StatelessWidget {
  const AffiliationSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: VetAppBar(title: "Veterinary Colleges", showBack: false),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            r.spacing(AppDimens.paddingLG),
            r.spacing(AppDimens.paddingMD),
            r.spacing(AppDimens.paddingLG),
            r.spacing(AppDimens.paddingLG),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero banner ───────────────────────────────────────
              _HeroBanner(r: r),

              SizedBox(height: r.spacing(AppDimens.paddingLG)),

              Text(
                'Select affiliation type',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: r.fontSize(14),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: r.spacing(AppDimens.paddingMD)),

              // ── Temporary Affiliated Card ────────────────────────
              _AffiliationCard(
                r: r,
                icon: Icons.access_time_rounded,
                title: 'Temporary affiliated',
                subtitle: 'Colleges with provisional recognition',
                badgeLabel: 'Temporary',
                gradientColors: AppColors.cardGradient,
                //gradientColors: const [Color(0xFFFFA726), AppColors.badgeStateText],
                iconColor: AppColors.badgeStateText,
                badgeBgColor: const Color(0xFFE1F5EE),
                badgeTextColor: const Color(0xFF0F6E56),
                onTap: () => Get.to(() => const TemporaryAffiliatedScreen()),
              ),

              SizedBox(height: r.spacing(AppDimens.paddingMD)),

              // ── Permanent Affiliated Card ────────────────────────
              _AffiliationCard(
                r: r,
                icon: Icons.verified_outlined,
                title: 'Permanent affiliated',
                subtitle: 'Colleges with full & permanent recognition',
                badgeLabel: 'Permanent',
                 gradientColors: AppColors.cardGradient,
                //gradientColors: const [Color(0xFF4DA3E0), Color(0xFF185FA5)],
                iconColor: AppColors.iconPrimary,
                badgeBgColor: const Color(0xFFE6F1FB),
               badgeTextColor: const Color(0xFF185FA5),
                onTap: () => Get.to(() => const PermanentAffiliatedScreen()),
              ),

              SizedBox(height: r.spacing(AppDimens.paddingLG)),

              // ── Helper note ───────────────────────────────────────
              _InfoFooter(r: r),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Hero Banner ────────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  final Responsive r;
  const _HeroBanner({required this.r});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusLG),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(r.spacing(AppDimens.paddingLG)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.cardGradient,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Decorative circles for depth
            Positioned(
              right: -r.spacing(20),
              top: -r.spacing(30),
              child: Container(
                width: r.spacing(110),
                height: r.spacing(110),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              right: r.spacing(40),
              bottom: -r.spacing(45),
              child: Container(
                width: r.spacing(70),
                height: r.spacing(70),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(r.spacing(AppDimens.paddingSM + 2)),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                  ),
                  child: Icon(
                    Icons.school_rounded,
                    size: r.fontSize(AppDimens.iconMD),
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: r.spacing(AppDimens.paddingMD)),
                Text(
                  'Veterinary Colleges',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: Colors.white,
                    fontSize: r.fontSize(19),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: r.spacing(AppDimens.paddingXS)),
                Text(
                  'Browse affiliated colleges by recognition status',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.88),
                    fontSize: r.fontSize(12),
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

// ─── Affiliation Card ───────────────────────────────────────────────────────

class _AffiliationCard extends StatelessWidget {
  final Responsive r;
  final IconData icon;
  final String title;
  final String subtitle;
  final String badgeLabel;
  final List<Color> gradientColors;
  final Color iconColor;
  final Color badgeBgColor;
  final Color badgeTextColor;
  final VoidCallback onTap;

  const _AffiliationCard({
    required this.r,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badgeLabel,
    required this.gradientColors,
    required this.iconColor,
    required this.badgeBgColor,
    required this.badgeTextColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusLG),
      child: Material(
        color: AppColors.backgroundWhite,
        child: InkWell(
          onTap: onTap,
          splashColor: iconColor.withOpacity(0.08),
          highlightColor: iconColor.withOpacity(0.04),
          child: Container(
            padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.radiusLG),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowMedium,
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon box with gradient
                Container(
                  width: r.spacing(52),
                  height: r.spacing(52),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors,
                    ),
                    borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                    boxShadow: [
                      BoxShadow(
                        color: iconColor.withOpacity(0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: r.fontSize(AppDimens.iconMD),
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: r.spacing(AppDimens.paddingMD)),

                // Text + badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: r.spacing(AppDimens.paddingXS - 2)),
                      Text(subtitle, style: AppTextStyles.bodySmall),
                      SizedBox(height: r.spacing(AppDimens.paddingXS + 2)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: r.spacing(AppDimens.paddingSM + 2),
                          vertical: r.spacing(AppDimens.paddingXS - 1),
                        ),
                        decoration: BoxDecoration(
                          color: badgeBgColor,
                          borderRadius:
                          BorderRadius.circular(AppDimens.radiusFull),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.circle,
                              size: r.fontSize(6),
                              color: badgeTextColor,
                            ),
                            SizedBox(width: r.spacing(4)),
                            Text(
                              badgeLabel,
                              style: AppTextStyles.labelSmall.copyWith(
                                fontSize: r.fontSize(10),
                                color: badgeTextColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: r.spacing(AppDimens.paddingXS)),

                // Arrow in a soft circular backdrop
                Container(
                  width: r.spacing(32),
                  height: r.spacing(32),
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundGrey,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: r.fontSize(AppDimens.iconXS),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Info Footer ────────────────────────────────────────────────────────────

class _InfoFooter extends StatelessWidget {
  final Responsive r;
  const _InfoFooter({required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: r.fontSize(AppDimens.iconXS + 2),
            color: AppColors.textSecondary,
          ),
          SizedBox(width: r.spacing(AppDimens.paddingSM)),
          Expanded(
            child: Text(
              'Tap a category above to view the full list of colleges under that affiliation type.',
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: r.fontSize(12),
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}