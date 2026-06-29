// // import 'package:flutter/material.dart';
// // import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';
// // import '../../core/constants/appcolors.dart';
// // import '../../core/style/dimens.dart';
// // import '../../core/style/textstyle.dart';
// // import '../../core/utils/responsive utiliteclass.dart';
// // import '../../widgets/commonwidget.dart';
// //
// //
// // class CareerPath {
// //   final String id;
// //   final String title;
// //   final String subtitle;
// //   final IconData icon;
// //
// //   const CareerPath({
// //     required this.id,
// //     required this.title,
// //     required this.subtitle,
// //     required this.icon,
// //   });
// // }
// //
// // class CareerData {
// //   static const List<CareerPath> paths = [
// //     CareerPath(
// //       id: '1',
// //       title: 'Govt Vet Officer / LDO',
// //       subtitle: 'State PSC · ₹50,000–80,000/mo',
// //       icon: Icons.account_balance_outlined,
// //     ),
// //     CareerPath(
// //       id: '2',
// //       title: 'Private Pet Practice',
// //       subtitle: 'Clinics & Hospitals · ₹40,000–1L/mo',
// //       icon: Icons.favorite_border_rounded,
// //     ),
// //     CareerPath(
// //       id: '3',
// //       title: 'Dairy, Poultry & Food Safety',
// //       subtitle: 'Industry & Pharma · FSSAI roles',
// //       icon: Icons.factory_outlined,
// //     ),
// //     CareerPath(
// //       id: '4',
// //       title: 'Wildlife, Zoo & Animal Welfare',
// //       subtitle: 'NGOs · Conservation organisations',
// //       icon: Icons.park_outlined,
// //     ),
// //     CareerPath(
// //       id: '5',
// //       title: 'Research / M.V.Sc / PhD',
// //       subtitle: 'ICAR, Universities · Stipend + growth',
// //       icon: Icons.science_outlined,
// //     ),
// //     CareerPath(
// //       id: '6',
// //       title: 'UPSC IFS / ICAR / State PSC',
// //       subtitle: 'Civil services · Govt research roles',
// //       icon: Icons.workspace_premium_outlined,
// //     ),
// //     CareerPath(
// //       id: '7',
// //       title: 'Startups in Pet Care & Tech',
// //       subtitle: 'Nutrition, health tech · Equity growth',
// //       icon: Icons.rocket_launch_outlined,
// //     ),
// //     CareerPath(
// //       id: '8',
// //       title: 'USA/Canada — NAVLE / ECFVG',
// //       subtitle: 'International licensing path',
// //       icon: Icons.public_outlined,
// //     ),
// //   ];
// //
// // }
// //
// //
// // class CareersScreen extends StatelessWidget {
// //   const CareersScreen({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final r = Responsive.of(context);
// //
// //     return NetworkAwareWrapper(
// //       child: Scaffold(
// //         backgroundColor: AppColors.background,
// //         appBar: VetAppBar(
// //           showBack: false,
// //           title: 'Career Roadmap',
// //         ),
// //         body: ListView(
// //           padding: EdgeInsets.fromLTRB(
// //             r.spacing(AppDimens.paddingLG),
// //             r.spacing(AppDimens.paddingMD),
// //             r.spacing(AppDimens.paddingLG),
// //             100,
// //           ),
// //           children: [
// //             // ── Subtitle ────────────────────────────────────────────────
// //             Text(
// //               'After B.V.Sc & A.H — what\'s next?',
// //               style: AppTextStyles.bodyMedium.copyWith(
// //                 fontSize: r.fontSize(13),
// //                 color: AppColors.textSecondary,
// //               ),
// //             ),
// //             SizedBox(height: r.spacing(AppDimens.paddingMD)),
// //
// //             // ── Career cards ─────────────────────────────────────────────
// //             ...CareerData.paths.map((path) => _CareerCard(
// //               r: r,
// //               path: path, onTap: () {  },
// //
// //               ),
// //             ),
// //
// //             SizedBox(height: r.spacing(AppDimens.paddingLG)),
// //
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //
// // class _CareerCard extends StatelessWidget {
// //   final Responsive r;
// //   final CareerPath path;
// //   final VoidCallback onTap;
// //
// //   const _CareerCard({
// //     required this.r,
// //     required this.path,
// //     required this.onTap,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         margin: EdgeInsets.only(bottom: r.spacing(AppDimens.paddingSM + 2)),
// //         padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
// //         decoration: BoxDecoration(
// //           color: AppColors.backgroundWhite,
// //           borderRadius: BorderRadius.circular(AppDimens.radiusLG),
// //           border: Border.all(color: AppColors.border),
// //         ),
// //         child: Row(
// //           children: [
// //             // icon
// //             Container(
// //               width: r.spacing(44),
// //               height: r.spacing(44),
// //               decoration: BoxDecoration(
// //                 color: AppColors.primarySurface,
// //                 borderRadius: BorderRadius.circular(AppDimens.radiusMD),
// //               ),
// //               child: Icon(
// //                 path.icon,
// //                 size: r.fontSize(AppDimens.iconSM + 2),
// //                 color: AppColors.primary,
// //               ),
// //             ),
// //             SizedBox(width: r.spacing(AppDimens.paddingMD)),
// //             // text
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     path.title,
// //                     style:  AppTextStyles.titleLarge,
// //                   ),
// //                   SizedBox(height: r.spacing(AppDimens.paddingXS - 2)),
// //                   Text(
// //                     path.subtitle,
// //                      style: AppTextStyles.bodySmall
// //             ),
// //
// //                 ],
// //               ),
// //             ),
// //
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //

import 'package:flutter/material.dart';
import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';
import '../../core/constants/appcolors.dart';
import '../../core/style/dimens.dart';
import '../../core/style/textstyle.dart';
import '../../core/utils/responsive utiliteclass.dart';
import '../../widgets/commonwidget.dart';

// ── Category colors — light tint background + a single mid-tone
// accent for the icon/text. No solid/dark fills anywhere.
const _blue = Color(0xFF185FA5);
const _blueBg = Color(0xFFE6F1FB);
const _teal = Color(0xFF0F6E56);
const _tealBg = Color(0xFFE1F5EE);
const _purple = Color(0xFF534AB7);
const _purpleBg = Color(0xFFEEEDFE);
const _coral = Color(0xFF993C1D);
const _coralBg = Color(0xFFFAECE7);

const double _kNodeColumnWidth = 52;

class CareerPath {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String category;
  final Color accent;
  final Color accentBg;

  const CareerPath({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.category,
    required this.accent,
    required this.accentBg,
  });
}

class CareerData {
  static const List<CareerPath> paths = [
    CareerPath(
      id: '1',
      title: 'Govt Vet Officer / LDO',
      subtitle: 'State PSC · ₹50,000–80,000/mo',
      icon: Icons.account_balance_outlined,
      category: 'Public service',
      accent: _blue,
      accentBg: _blueBg,
    ),
    CareerPath(
      id: '2',
      title: 'Private Pet Practice',
      subtitle: 'Clinics & Hospitals · ₹40,000–1L/mo',
      icon: Icons.favorite_border_rounded,
      category: 'Animal care',
      accent: _teal,
      accentBg: _tealBg,
    ),
    CareerPath(
      id: '3',
      title: 'Dairy, Poultry & Food Safety',
      subtitle: 'Industry & Pharma · FSSAI roles',
      icon: Icons.factory_outlined,
      category: 'Industry & research',
      accent: _purple,
      accentBg: _purpleBg,
    ),
    CareerPath(
      id: '4',
      title: 'Wildlife, Zoo & Animal Welfare',
      subtitle: 'NGOs · Conservation organisations',
      icon: Icons.park_outlined,
      category: 'Animal care',
      accent: _coral,
      accentBg: _coralBg,
    ),
    CareerPath(
      id: '5',
      title: 'Research / M.V.Sc / PhD',
      subtitle: 'ICAR, Universities · Stipend + growth',
      icon: Icons.science_outlined,
      category: 'Industry & research',
        accent: _blue,
        accentBg: _blueBg
    ),
    CareerPath(
      id: '6',
      title: 'UPSC IFS / ICAR / State PSC',
      subtitle: 'Civil services · Govt research roles',
      icon: Icons.workspace_premium_outlined,
      category: 'Public service',
      accent: _teal,
      accentBg: _tealBg,
    ),
    CareerPath(
      id: '7',
      title: 'Startups in Pet Care & Tech',
      subtitle: 'Nutrition, health tech · Equity growth',
      icon: Icons.rocket_launch_outlined,
      category: 'Global & growth',
      accent: _purple,
      accentBg: _purpleBg,
    ),
    CareerPath(
      id: '8',
      title: 'USA/Canada — NAVLE / ECFVG',
      subtitle: 'International licensing path',
      icon: Icons.public_outlined,
      category: 'Global & growth',
      accent: _coral,
      accentBg: _coralBg,
    ),
  ];
}

class CareersScreen extends StatelessWidget {
  const CareersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final paths = CareerData.paths;

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

            // ── Starting point ─────────────────────────────────────────
            _RootNode(r: r),
            Padding(
              padding: EdgeInsets.only(left: r.spacing(_kNodeColumnWidth / 2 - 1)),
              child: Container(
                width: 2,
                height: r.spacing(20),
                color: AppColors.border,
              ),
            ),

            // ── Career timeline ─────────────────────────────────────────
            ...List.generate(paths.length, (index) {
              return _TimelineCareerCard(
                r: r,
                path: paths[index],
                isLast: index == paths.length - 1,
                onTap: () {},
              );
            }),

            SizedBox(height: r.spacing(AppDimens.paddingLG)),
          ],
        ),
      ),
    );
  }
}


class _RootNode extends StatelessWidget {
  final Responsive r;
  const _RootNode({required this.r});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: r.spacing(AppDimens.paddingMD),
            vertical: r.spacing(AppDimens.paddingSM),
          ),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppDimens.radiusLG + 10),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.school_outlined, size: r.fontSize(16), color: AppColors.primary),
              SizedBox(width: r.spacing(6)),
              Text(
                'B.V.Sc & A.H graduate',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.iconWhite,
                  fontSize: r.fontSize(12.5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineCareerCard extends StatelessWidget {
  final Responsive r;
  final CareerPath path;
  final bool isLast;
  final VoidCallback onTap;

  const _TimelineCareerCard({
    required this.r,
    required this.path,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Spine: connecting line + node ──────────────────────────
          SizedBox(
            width: r.spacing(_kNodeColumnWidth),
            child: Column(
              children: [
                Expanded(
                  child: Container(width: 2, color: AppColors.border),
                ),
                Container(
                  width: r.spacing(40),
                  height: r.spacing(40),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: path.accentBg,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Icon(
                    path.icon,
                    size: r.fontSize(18),
                    color: path.accent,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : AppColors.border,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: r.spacing(AppDimens.paddingSM)),

          // ── Card content ────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: r.spacing(AppDimens.paddingSM)),
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: r.spacing(8),
                          vertical: r.spacing(2),
                        ),
                        decoration: BoxDecoration(
                          color: path.accentBg,
                          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                        ),
                        child: Text(
                          path.category,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: r.fontSize(10.5),
                            fontWeight: FontWeight.w600,
                            color: path.accent,
                          ),
                        ),
                      ),
                      SizedBox(height: r.spacing(AppDimens.paddingXS)),
                      Text(path.title, style: AppTextStyles.titleLarge),
                      SizedBox(height: r.spacing(AppDimens.paddingXS - 2)),
                      Text(path.subtitle, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}