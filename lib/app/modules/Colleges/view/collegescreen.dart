
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

    return NetworkAwareWrapper(child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: VetAppBar(title: "Veterinary Colleges",showBack: false,),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          r.spacing(AppDimens.paddingLG),
          r.spacing(AppDimens.paddingMD),
          r.spacing(AppDimens.paddingLG),
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select affiliation type',
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: r.fontSize(13),
              ),
            ),
            SizedBox(height: r.spacing(AppDimens.paddingMD)),

            // ── Temporary Affiliated Card ──────────────────────────
            _AffiliationCard(
              r: r,
              icon: Icons.access_time_rounded,
              title: 'Temporary affiliated',
              subtitle: 'Colleges with provisional recognition',
              badgeLabel: 'Temporary',
              iconBgColor: const Color(0xFFE1F5EE),
              iconColor: const Color(0xFF0F6E56),
              badgeBgColor: const Color(0xFFE1F5EE),
              badgeTextColor: const Color(0xFF0F6E56),
              onTap: () => Get.to(() => const TemporaryAffiliatedScreen()),
            ),

            SizedBox(height: r.spacing(AppDimens.paddingSM + 2)),

            // ── Permanent Affiliated Card ──────────────────────────
            _AffiliationCard(
              r: r,
              icon: Icons.verified_outlined,
              title: 'Permanent affiliated',
              subtitle: 'Colleges with full & permanent recognition',
              badgeLabel: 'Permanent',
              iconBgColor: const Color(0xFFE6F1FB),
              iconColor: const Color(0xFF185FA5),
              badgeBgColor: const Color(0xFFE6F1FB),
              badgeTextColor: const Color(0xFF185FA5),
              onTap: () => Get.to(() => const PermanentAffiliatedScreen()),
            ),
          ],
        ),
      ),
    ));
  }
}

// ─── Affiliation Card ─────────────────────────────────────────────────────────

class _AffiliationCard extends StatelessWidget {
  final Responsive r;
  final IconData icon;
  final String title;
  final String subtitle;
  final String badgeLabel;
  final Color iconBgColor;
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
    required this.iconBgColor,
    required this.iconColor,
    required this.badgeBgColor,
    required this.badgeTextColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Icon box
            Container(
              width: r.spacing(48),
              height: r.spacing(48),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              ),
              child: Icon(
                icon,
                size: r.fontSize(AppDimens.iconMD),
                color: iconColor,
              ),
            ),
            SizedBox(width: r.spacing(AppDimens.paddingMD)),

            // Text + badge
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.titleLarge),
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
                    child: Text(
                      badgeLabel,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: r.fontSize(10),
                        color: badgeTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: r.spacing(AppDimens.paddingXS)),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: r.fontSize(AppDimens.iconXS),
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
