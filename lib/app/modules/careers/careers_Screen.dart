
import 'package:flutter/material.dart';
import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';
import '../../core/constants/appcolors.dart';
import '../../core/style/dimens.dart';
import '../../core/style/textstyle.dart';
import '../../core/utils/responsive utiliteclass.dart';
import '../../data/models/carrermodel.dart';
import '../../widgets/commonwidget.dart';
import 'carrerdetailscreen.dart';

const _blue = Color(0xFF185FA5);
const _blueBg = Color(0xFFE6F1FB);
const _teal = Color(0xFF0F6E56);
const _tealBg = Color(0xFFE1F5EE);
const _purple = Color(0xFF534AB7);
const _purpleBg = Color(0xFFEEEDFE);
const _coral = Color(0xFF993C1D);
const _coralBg = Color(0xFFFAECE7);

const double _kNodeColumnWidth = 52;

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
          showBack: true,
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

            _RootNode(r: r),
            Padding(
              padding: EdgeInsets.only(left: r.spacing(_kNodeColumnWidth / 2 - 1)),
              child: Container(
                width: 2,
                height: r.spacing(20),
                color: AppColors.border,
              ),
            ),

            ...List.generate(paths.length, (index) {
              return _TimelineCareerCard(
                r: r,
                path: paths[index],
                isLast: index == paths.length - 1,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CareerDetailScreen(path: paths[index]),
                    ),
                  );
                },
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Icon(
                            Icons.chevron_right_rounded,
                            size: r.fontSize(18),
                            color: AppColors.textSecondary,
                          ),
                        ],
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