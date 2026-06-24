import 'package:flutter/material.dart';
import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';
import '../../core/constants/appcolors.dart';
import '../../core/style/dimens.dart';
import '../../core/style/textstyle.dart';
import '../../core/utils/responsive utiliteclass.dart';
import '../../widgets/commonwidget.dart';


class CareerPath {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  const CareerPath({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class CareerData {
  static const List<CareerPath> paths = [
    CareerPath(
      id: '1',
      title: 'Govt Vet Officer / LDO',
      subtitle: 'State PSC · ₹50,000–80,000/mo',
      icon: Icons.account_balance_outlined,
    ),
    CareerPath(
      id: '2',
      title: 'Private Pet Practice',
      subtitle: 'Clinics & Hospitals · ₹40,000–1L/mo',
      icon: Icons.favorite_border_rounded,
    ),
    CareerPath(
      id: '3',
      title: 'Dairy, Poultry & Food Safety',
      subtitle: 'Industry & Pharma · FSSAI roles',
      icon: Icons.factory_outlined,
    ),
    CareerPath(
      id: '4',
      title: 'Wildlife, Zoo & Animal Welfare',
      subtitle: 'NGOs · Conservation organisations',
      icon: Icons.park_outlined,
    ),
    CareerPath(
      id: '5',
      title: 'Research / M.V.Sc / PhD',
      subtitle: 'ICAR, Universities · Stipend + growth',
      icon: Icons.science_outlined,
    ),
    CareerPath(
      id: '6',
      title: 'UPSC IFS / ICAR / State PSC',
      subtitle: 'Civil services · Govt research roles',
      icon: Icons.workspace_premium_outlined,
    ),
    CareerPath(
      id: '7',
      title: 'Startups in Pet Care & Tech',
      subtitle: 'Nutrition, health tech · Equity growth',
      icon: Icons.rocket_launch_outlined,
    ),
    CareerPath(
      id: '8',
      title: 'USA/Canada — NAVLE / ECFVG',
      subtitle: 'International licensing path',
      icon: Icons.public_outlined,
    ),
  ];

}


class CareersScreen extends StatelessWidget {
  const CareersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: VetAppBar(
          showBack: false,
          title: 'Career Roadmap',
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            r.spacing(AppDimens.paddingLG),
            r.spacing(AppDimens.paddingMD),
            r.spacing(AppDimens.paddingLG),
            100,
          ),
          children: [
            // ── Subtitle ────────────────────────────────────────────────
            Text(
              'After B.V.Sc & A.H — what\'s next?',
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: r.fontSize(13),
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: r.spacing(AppDimens.paddingMD)),

            // ── Career cards ─────────────────────────────────────────────
            ...CareerData.paths.map((path) => _CareerCard(
              r: r,
              path: path, onTap: () {  },

              ),
            ),

            SizedBox(height: r.spacing(AppDimens.paddingLG)),

          ],
        ),
      ),
    );
  }
}


class _CareerCard extends StatelessWidget {
  final Responsive r;
  final CareerPath path;
  final VoidCallback onTap;

  const _CareerCard({
    required this.r,
    required this.path,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: r.spacing(AppDimens.paddingSM + 2)),
        padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // icon
            Container(
              width: r.spacing(44),
              height: r.spacing(44),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              ),
              child: Icon(
                path.icon,
                size: r.fontSize(AppDimens.iconSM + 2),
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: r.spacing(AppDimens.paddingMD)),
            // text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    path.title,
                    style:  AppTextStyles.titleLarge,
                  ),
                  SizedBox(height: r.spacing(AppDimens.paddingXS - 2)),
                  Text(
                    path.subtitle,
                     style: AppTextStyles.bodySmall
            ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}


