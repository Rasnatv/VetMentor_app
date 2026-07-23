import 'package:flutter/material.dart';
import '../../core/constants/appcolors.dart';
import '../../core/style/dimens.dart';
import '../../core/style/textstyle.dart';
import '../../core/utils/responsive utiliteclass.dart';
import '../../data/models/carrermodel.dart';
import '../../widgets/commonwidget.dart';


/// Detail screen shown when a career card on the roadmap timeline is tapped.
/// Reads everything from the [CareerPath] passed in, so no extra data
/// fetching is needed.
class CareerDetailScreen extends StatelessWidget {
  final CareerPath path;

  const CareerDetailScreen({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: VetAppBar(
        showBack: true,
        title: path.title,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          r.spacing(AppDimens.paddingLG),
          r.spacing(AppDimens.paddingMD),
          r.spacing(AppDimens.paddingLG),
          r.spacing(AppDimens.paddingLG) + 40,
        ),
        children: [
          _HeaderCard(r: r, path: path),
          SizedBox(height: r.spacing(AppDimens.paddingLG)),

          _SectionTitle(r: r, text: 'About this path'),
          SizedBox(height: r.spacing(AppDimens.paddingXS)),
          Text(
            path.description,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: r.fontSize(13.5),
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          SizedBox(height: r.spacing(AppDimens.paddingLG)),

          Row(
            children: [
              Expanded(
                child: _StatCard(
                  r: r,
                  icon: Icons.currency_rupee_rounded,
                  label: 'Salary',
                  value: path.salaryRange,
                  accent: path.accent,
                  accentBg: path.accentBg,
                ),
              ),
              SizedBox(width: r.spacing(AppDimens.paddingSM)),
              Expanded(
                child: _StatCard(
                  r: r,
                  icon: Icons.verified_outlined,
                  label: 'Eligibility',
                  value: path.eligibility,
                  accent: path.accent,
                  accentBg: path.accentBg,
                ),
              ),
            ],
          ),
          SizedBox(height: r.spacing(AppDimens.paddingLG)),

          if (path.highlights.isNotEmpty) ...[
            _SectionTitle(r: r, text: 'Highlights'),
            SizedBox(height: r.spacing(AppDimens.paddingXS)),
            Wrap(
              spacing: r.spacing(8),
              runSpacing: r.spacing(8),
              children: path.highlights
                  .map((h) => _Chip(r: r, text: h, accent: path.accent, accentBg: path.accentBg))
                  .toList(),
            ),
            SizedBox(height: r.spacing(AppDimens.paddingLG)),
          ],

          _SectionTitle(r: r, text: 'How to get there'),
          SizedBox(height: r.spacing(AppDimens.paddingSM)),
          _RoadmapList(r: r, path: path),
          SizedBox(height: r.spacing(AppDimens.paddingLG)),

          if (path.skills.isNotEmpty) ...[
            _SectionTitle(r: r, text: 'Skills to build'),
            SizedBox(height: r.spacing(AppDimens.paddingSM)),
            ...path.skills.map(
                  (s) => Padding(
                padding: EdgeInsets.only(bottom: r.spacing(AppDimens.paddingSM)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        size: r.fontSize(16), color: path.accent),
                    SizedBox(width: r.spacing(8)),
                    Expanded(
                      child: Text(
                        s,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: r.fontSize(13.5),
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final Responsive r;
  final CareerPath path;
  const _HeaderCard({required this.r, required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: r.spacing(52),
            height: r.spacing(52),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: path.accentBg,
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(path.icon, size: r.fontSize(24), color: path.accent),
          ),
          SizedBox(width: r.spacing(AppDimens.paddingSM)),
          Expanded(
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
                SizedBox(height: r.spacing(2)),
                Text(path.subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final Responsive r;
  final String text;
  const _SectionTitle({required this.r, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.titleLarge.copyWith(fontSize: r.fontSize(15)),
    );
  }
}

class _StatCard extends StatelessWidget {
  final Responsive r;
  final IconData icon;
  final String label;
  final String value;
  final Color accent;
  final Color accentBg;

  const _StatCard({
    required this.r,
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    required this.accentBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
      decoration: BoxDecoration(
        color: accentBg,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: r.fontSize(18), color: accent),
          SizedBox(height: r.spacing(6)),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: r.fontSize(10.5),
              fontWeight: FontWeight.w600,
              color: accent,
            ),
          ),
          SizedBox(height: r.spacing(2)),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: r.fontSize(12),
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final Responsive r;
  final String text;
  final Color accent;
  final Color accentBg;
  const _Chip({required this.r, required this.text, required this.accent, required this.accentBg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.spacing(10),
        vertical: r.spacing(6),
      ),
      decoration: BoxDecoration(
        color: accentBg,
        borderRadius: BorderRadius.circular(AppDimens.radiusMD + 6),
        border: Border.all(color: accent.withOpacity(0.25)),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: r.fontSize(11.5),
          fontWeight: FontWeight.w600,
          color: accent,
        ),
      ),
    );
  }
}

class _RoadmapList extends StatelessWidget {
  final Responsive r;
  final CareerPath path;
  const _RoadmapList({required this.r, required this.path});

  @override
  Widget build(BuildContext context) {
    final steps = path.roadmap;
    return Column(
      children: List.generate(steps.length, (index) {
        final isLast = index == steps.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  Container(
                    width: r.spacing(26),
                    height: r.spacing(26),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: path.accentBg,
                      border: Border.all(color: path.accent, width: 1.4),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: r.fontSize(11.5),
                        fontWeight: FontWeight.w700,
                        color: path.accent,
                      ),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(width: 2, color: AppColors.border),
                    ),
                ],
              ),
              SizedBox(width: r.spacing(AppDimens.paddingSM)),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: r.spacing(AppDimens.paddingMD)),
                  child: Text(
                    steps[index],
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: r.fontSize(13),
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
