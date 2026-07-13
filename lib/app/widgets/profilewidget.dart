import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/constants/appcolors.dart';
import '../core/style/dimens.dart';
import '../core/style/textstyle.dart';
import '../core/utils/responsive utiliteclass.dart';
import '../data/models/studentprofilemodel.dart';
const Color _kAccent = Color(0xFF1D9E75);
const Color _kAccentDark = Color(0xFF0F6E56);

class InfoRowData {
  final IconData icon;
  final Color iconColor, iconBg;
  final String label, value;
  final VoidCallback? onTap;
  const InfoRowData({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
    this.onTap,
  });
}

class InfoCard extends StatelessWidget {
  final List<InfoRowData> rows;
  const InfoCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        child: Column(
          children: rows.asMap().entries.map((e) {
            final row = e.value;
            final isLast = e.key == rows.length - 1;
            final content = Padding(
              padding: EdgeInsets.symmetric(
                horizontal: r.spacing(AppDimens.paddingLG),
                vertical: r.spacing(AppDimens.paddingMD + 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: r.spacing(AppDimens.avatarSM),
                    height: r.spacing(AppDimens.avatarSM),
                    decoration: BoxDecoration(
                      color: row.iconBg,
                      borderRadius:
                      BorderRadius.circular(AppDimens.radiusMD - 2),
                    ),
                    child: Icon(row.icon,
                        size: r.fontSize(AppDimens.iconSM),
                        color: row.iconColor),
                  ),
                  SizedBox(width: r.spacing(AppDimens.paddingMD)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(row.label,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: r.fontSize(12),
                              color: AppColors.textSecondary,
                            )),
                        SizedBox(height: r.spacing(2)),
                        Text(row.value,
                            style: AppTextStyles.titleLarge
                                .copyWith(fontSize: r.fontSize(14))),
                      ],
                    ),
                  ),
                  if (row.onTap != null)
                    Icon(Icons.copy_rounded,
                        size: r.fontSize(15),
                        color: AppColors.textSecondary.withOpacity(0.6)),
                ],
              ),
            );
            return Column(
              children: [
                row.onTap != null
                    ? InkWell(onTap: row.onTap, child: content)
                    : content,
                if (!isLast)
                  Divider(
                    height: 1,
                    indent: r.spacing(
                        AppDimens.paddingLG + AppDimens.avatarSM),
                    color: AppColors.borderLight,
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class LocationCard extends StatelessWidget {
  final StudentProfileModel profile;
  const LocationCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    final rows = <InfoRowData>[
      InfoRowData(
        icon: Icons.public_outlined,
        iconColor: const Color(0xFF0F6E56),
        iconBg: const Color(0xFFE1F5EE),
        label: 'Country',
        value: profile.country.isNotEmpty ? profile.country : '—',
      ),
      InfoRowData(
        icon: Icons.map_outlined,
        iconColor: const Color(0xFF993C1D),
        iconBg: const Color(0xFFFAECE7),
        label: 'State',
        value: profile.state.isNotEmpty ? profile.state : '—',
      ),
      InfoRowData(
        icon: Icons.location_city_outlined,
        iconColor: const Color(0xFF534AB7),
        iconBg: const Color(0xFFEEEDFE),
        label: 'District',
        value: profile.district.isNotEmpty ? profile.district : '—',
      ),
      InfoRowData(
        icon: Icons.home_outlined,
        iconColor: const Color(0xFF185FA5),
        iconBg: const Color(0xFFE6F1FB),
        label: 'Address',
        value: profile.address.isNotEmpty ? profile.address : '—',
      ),
      InfoRowData(
        icon: Icons.pin_drop_outlined,
        iconColor: const Color(0xFFBA7517),
        iconBg: const Color(0xFFFAEEDA),
        label: 'Pincode',
        value: profile.pincode.isNotEmpty ? profile.pincode : '—',
      ),
    ];

    // breadcrumb parts
    final breadcrumb = <String>[
      if (profile.country.isNotEmpty) profile.country,
      if (profile.state.isNotEmpty) profile.state,
      if (profile.district.isNotEmpty) profile.district,
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── breadcrumb header ──────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: r.spacing(AppDimens.paddingLG),
                vertical: r.spacing(AppDimens.paddingMD),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FBF6),
                border: Border(
                  bottom: BorderSide(color: AppColors.borderLight),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: r.spacing(32),
                    height: r.spacing(32),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1F5EE),
                      borderRadius:
                      BorderRadius.circular(AppDimens.radiusMD - 2),
                    ),
                    child: const Icon(Icons.location_on_rounded,
                        color: Color(0xFF1D9E75), size: 18),
                  ),
                  SizedBox(width: r.spacing(AppDimens.paddingSM + 2)),
                  Expanded(
                    child: breadcrumb.isEmpty
                        ? Text('Location not set',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: r.fontSize(12),
                          color: AppColors.textSecondary,
                        ))
                        : Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 2,
                      children: [
                        for (int i = 0; i < breadcrumb.length; i++) ...[
                          Text(
                            breadcrumb[i],
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: r.fontSize(12.5),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F6E56),
                            ),
                          ),
                          if (i < breadcrumb.length - 1)
                            Icon(
                              Icons.chevron_right_rounded,
                              size: r.fontSize(14),
                              color: const Color(0xFF0F6E56)
                                  .withOpacity(0.45),
                            ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── rows ──────────────────────────────────────
            ...rows.asMap().entries.map((e) {
              final row = e.value;
              final isLast = e.key == rows.length - 1;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: r.spacing(AppDimens.paddingLG),
                      vertical: r.spacing(AppDimens.paddingMD + 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: r.spacing(AppDimens.avatarSM),
                          height: r.spacing(AppDimens.avatarSM),
                          decoration: BoxDecoration(
                            color: row.iconBg,
                            borderRadius:
                            BorderRadius.circular(AppDimens.radiusMD - 2),
                          ),
                          child: Icon(row.icon,
                              size: r.fontSize(AppDimens.iconSM),
                              color: row.iconColor),
                        ),
                        SizedBox(width: r.spacing(AppDimens.paddingMD)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(row.label,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontSize: r.fontSize(11.5),
                                    color: AppColors.textSecondary,
                                  )),
                              SizedBox(height: r.spacing(2)),
                              Text(row.value,
                                  style: AppTextStyles.titleLarge.copyWith(
                                    fontSize: r.fontSize(14),
                                    height: 1.4,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: r.spacing(
                          AppDimens.paddingLG + AppDimens.avatarSM),
                      color: AppColors.borderLight,
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class NeetCard extends StatelessWidget {
  final String score;
  const NeetCard({required this.score});

  static const double _maxScore = 720;

  double? get _numericScore {
    final cleaned = score.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final hasScore = score.isNotEmpty;
    final numeric = _numericScore;
    final progress =
    numeric == null ? 0.0 : (numeric / _maxScore).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD + 2)),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: r.value(mobile: 64.0, tablet: 76.0),
                  height: r.value(mobile: 64.0, tablet: 76.0),
                  child: CircularProgressIndicator(
                    value: numeric == null ? 0 : progress,
                    strokeWidth: 6,
                    backgroundColor: const Color(0xFFE1F5EE),
                    valueColor: const AlwaysStoppedAnimation(_kAccent),
                  ),
                ),
                Icon(Icons.bar_chart_rounded,
                    color: _kAccent, size: r.fontSize(AppDimens.iconSM)),
              ],
            ),
            SizedBox(width: r.spacing(AppDimens.paddingMD + 2)),
            Expanded(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('NEET Score',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: r.fontSize(12),
                            color: AppColors.textSecondary,
                          )),
                      const SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            hasScore ? score : '—',
                            style: TextStyle(
                              fontSize: r.fontSize(26),
                              fontWeight: FontWeight.w700,
                              color: _kAccent,
                              height: 1.1,
                            ),
                          ),
                          if (numeric != null) ...[
                            SizedBox(width: r.spacing(4)),
                            Text('/ 720',
                                style: TextStyle(
                                  fontSize: r.fontSize(13),
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}