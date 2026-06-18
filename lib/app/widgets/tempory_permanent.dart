
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../core/constants/appcolors.dart';
import '../core/style/dimens.dart';
import '../core/style/textstyle.dart';
import '../core/utils/responsive utiliteclass.dart';
import 'commonwidget.dart';
class AffiliationChip extends StatelessWidget {
  final Responsive r;
  final IconData icon;
  final String label;
  final Color color;
  final Color bg;
  const AffiliationChip({required this.r, required this.icon, required this.label, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.spacing(AppDimens.paddingMD), vertical: r.spacing(AppDimens.paddingXS + 2)),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppDimens.radiusFull), border: Border.all(color: color)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: color),
        SizedBox(width: r.spacing(AppDimens.paddingXS)),
        Text(label, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600, fontSize: r.fontSize(12), color: color)),
      ]),
    );
  }
}

// ─── Filter Chip ──────────────────────────────────────────────────────────────
class FilterChip extends StatelessWidget {
  final Responsive r;
  final String label;
  final Color color;
  final Color bg;
  final VoidCallback onClear;
  const FilterChip({required this.r, required this.label, required this.color, required this.bg, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.spacing(AppDimens.paddingMD), vertical: r.spacing(AppDimens.paddingXS + 2)),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppDimens.radiusFull), border: Border.all(color: color)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(label, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600, fontSize: r.fontSize(13), color: color)),
        SizedBox(width: r.spacing(AppDimens.paddingXS + 2)),
        GestureDetector(onTap: onClear, child: Icon(Icons.close_rounded, size: 14, color: color)),
      ]),
    );
  }
}

// ─── College List Card ────────────────────────────────────────────────────────
class CollegeListCard extends StatelessWidget {
  final Responsive r;
  final Map<String, dynamic> college;
  final Color badgeColor;
  final Color badgeBg;
  final String badgeLabel;
  const CollegeListCard({required this.r, required this.college, required this.badgeColor, required this.badgeBg, required this.badgeLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: r.spacing(AppDimens.paddingSM + 2)),
      padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
      decoration: BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.circular(AppDimens.radiusLG), border: Border.all(color: AppColors.border)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: r.spacing(44), height: r.spacing(44),
          decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(AppDimens.radiusMD)),
          child: Icon(Icons.school_outlined, size: r.fontSize(AppDimens.iconMD), color: badgeColor),
        ),
        SizedBox(width: r.spacing(AppDimens.paddingMD)),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(college['college_name'] ?? '', style: AppTextStyles.titleLarge),
          SizedBox(height: r.spacing(AppDimens.paddingXS)),
          Row(children: [
            Icon(Icons.location_on_outlined, size: r.fontSize(12), color: AppColors.textSecondary),
            SizedBox(width: r.spacing(2)),
            Expanded(child: Text('${college['district']}, ${college['state']}', style: AppTextStyles.bodySmall)),
          ]),
          SizedBox(height: r.spacing(AppDimens.paddingXS + 2)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: r.spacing(AppDimens.paddingSM + 2), vertical: r.spacing(AppDimens.paddingXS - 1)),
            decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(AppDimens.radiusFull)),
            child: Text(badgeLabel, style: AppTextStyles.labelSmall.copyWith(fontSize: r.fontSize(10), color: badgeColor, fontWeight: FontWeight.w600)),
          ),
        ])),
        Icon(Icons.arrow_forward_ios_rounded, size: r.fontSize(AppDimens.iconXS), color: AppColors.textSecondary),
      ]),
    );
  }
}

// ─── State Filter Sheet ───────────────────────────────────────────────────────
class StateFilterSheet extends StatelessWidget {
  final RxList<String> statesObs;
  final RxString selectedObs;
  final ValueChanged<String> onSelect;
  const StateFilterSheet({required this.statesObs, required this.selectedObs, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Container(
      decoration: const BoxDecoration(color: AppColors.backgroundWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.radiusXXL))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          margin: EdgeInsets.only(top: r.spacing(AppDimens.paddingMD)),
          width: r.spacing(40), height: r.spacing(4),
          decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(AppDimens.radiusXS)),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(r.spacing(AppDimens.paddingXL), r.spacing(AppDimens.paddingLG), r.spacing(AppDimens.paddingXL), r.spacing(AppDimens.paddingSM)),
          child: Row(children: [
            Text('Filter by State', style: AppTextStyles.headlineLarge.copyWith(fontSize: r.fontSize(16))),
            const Spacer(),
            GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.close_rounded, color: AppColors.textSecondary, size: r.fontSize(AppDimens.iconMD))),
          ]),
        ),
        const AppDivider(),
        Obx(() => ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.55),
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: r.spacing(AppDimens.paddingSM)),
            itemCount: statesObs.length,
            itemBuilder: (ctx, i) {
              final state = statesObs[i];
              final isSel = state == selectedObs.value;
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: r.spacing(AppDimens.paddingXL), vertical: r.spacing(AppDimens.paddingXS)),
                title: Text(state, style: AppTextStyles.titleMedium.copyWith(fontSize: r.fontSize(14), color: isSel ? AppColors.primary : AppColors.textPrimary, fontWeight: isSel ? FontWeight.w600 : FontWeight.w400)),
                trailing: isSel ? Icon(Icons.check_circle_rounded, color: AppColors.primary, size: r.fontSize(AppDimens.iconSM)) : null,
                onTap: () => onSelect(state),
              );
            },
          ),
        )),
        SizedBox(height: MediaQuery.of(context).padding.bottom + r.spacing(AppDimens.paddingLG)),
      ]),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const EmptyState({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 48, color: AppColors.textSecondary),
      const SizedBox(height: 12),
      Text(title, style: AppTextStyles.titleLarge),
      const SizedBox(height: 4),
      Text(subtitle, style: AppTextStyles.bodySmall),
    ]));
  }
}

// ─── Error View ───────────────────────────────────────────────────────────────
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey),
        const SizedBox(height: 16),
        Text(message, textAlign: TextAlign.center, style: AppTextStyles.bodyMedium),
        const SizedBox(height: 16),
        ElevatedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded), label: const Text('Retry')),
      ]),
    ));
  }
}