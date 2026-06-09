import 'package:flutter/material.dart';

import '../core/constants/appcolors.dart';
import '../core/style/textstyle.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isOutlined;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;

  final Widget? icon;
  final double borderRadius;

  const AppButton({

    super.key,
    required this.text,
    this.onTap,
    this.isOutlined = false,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 52,
    this.icon,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: isOutlined
          ? OutlinedButton(
        onPressed: isLoading ? null : onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? AppColors.primary,
          side: BorderSide(color: textColor ?? AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        ),
        child: _buildChild(),
      )
          : ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? AppColors.textWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        ),
        child: _buildChild(),
      ),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(color: AppColors.textWhite, strokeWidth: 2.5),
      );
    }
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [icon!, const SizedBox(width: 8), Text(text, style: AppTextStyles.labelLarge)],
      );
    }
    return Text(text, style: AppTextStyles.labelLarge.copyWith(color: isOutlined ? AppColors.primary : AppColors.textWhite));
  }
}

// ─── Search Bar ──────────────────────────────────────────────
class AppSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final bool showFilter;

  const AppSearchBar({
    super.key,
    this.hintText = 'Search...',
    this.controller,
    this.onChanged,
    this.onFilterTap,
    this.showFilter = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTextStyles.bodyMedium,
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textHint, size: 20),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                filled: false,
              ),
            ),
          ),
        ),
        if (showFilter) ...[
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.tune_rounded, color: AppColors.textSecondary, size: 20),
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Tag Badge ───────────────────────────────────────────────
class TagBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isSmall;

  const TagBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.isSmall = true,
  });

  factory TagBadge.icar(String label) => TagBadge(
    label: label,
    backgroundColor: AppColors.badgeICAR,
    textColor: AppColors.badgeIcARText,
  );

  factory TagBadge.public() => TagBadge(
    label: 'Public',
    backgroundColor: AppColors.badgePublic,
    textColor: AppColors.badgePublicText,
  );

  factory TagBadge.state() => TagBadge(
    label: 'State',
    backgroundColor: AppColors.badgeState,
    textColor: AppColors.badgeStateText,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmall ? 7 : 10, vertical: isSmall ? 3 : 5),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.chipGreen,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: textColor ?? AppColors.chipGreenText,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── Section Header ──────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.headlineMedium),
        if (actionText != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionText!,
              style: AppTextStyles.bodyGreen.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }
}

// ─── Stat Card ───────────────────────────────────────────────
class StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const StatItem({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary)),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.labelSmall),
      ],
    );
  }
}

// ─── Shimmer Placeholder ─────────────────────────────────────
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.borderLight,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

// ─── App Divider ─────────────────────────────────────────────
class AppDivider extends StatelessWidget {
  final double height;
  final double indent;
  const AppDivider({super.key, this.height = 1, this.indent = 0});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: height,
      indent: indent,
      endIndent: indent,
      color: AppColors.borderLight,
    );
  }
}

// ─── College Avatar ──────────────────────────────────────────
class CollegeAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double size;

  const CollegeAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: (imageUrl != null && imageUrl!.isNotEmpty)
            ? Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallback(),
        )
            : _fallback(),
      ),
    );
  }

  Widget _fallback() {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'V',
        style: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary),
      ),
    );
  }
}

// ─── Progress Step ───────────────────────────────────────────
class StepIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const StepIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isCompleted = index < currentStep - 1;
        final isActive = index == currentStep - 1;
        return Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCompleted || isActive ? AppColors.primary : AppColors.borderLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                    : Text(
                  '${index + 1}',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: isActive ? Colors.white : AppColors.textHint,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (index < totalSteps - 1)
              Container(
                width: 28,
                height: 2,
                color: isCompleted ? AppColors.primary : AppColors.borderLight,
              ),
          ],
        );
      }),
    );
  }
}

// ─── Empty State ─────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onButton;

  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.search_off_rounded,
    this.buttonText,
    this.onButton,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: AppColors.primary, size: 36),
            ),
            const SizedBox(height: 20),
            Text(title, style: AppTextStyles.headlineMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            if (buttonText != null) ...[
              const SizedBox(height: 24),
              AppButton(text: buttonText!, onTap: onButton, width: 160, height: 44),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Custom App Bar ──────────────────────────────────────────
class VetAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? leading;
  final bool centerTitle;

  const VetAppBar({
    super.key,
    this.title,
    this.actions,
    this.showBack = true,
    this.onBack,
    this.leading,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundWhite,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      leading: showBack
          ? (leading ??
          GestureDetector(
            onTap: onBack ?? () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
            ),
          ))
          : null,
      automaticallyImplyLeading: false,
      title: title != null
          ? Text(title!, style: AppTextStyles.headlineLarge)
          : null,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.borderLight),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}

// ─── Info Row ────────────────────────────────────────────────
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(label, style: AppTextStyles.bodyMedium),
          const Spacer(),
          Text(value, style: AppTextStyles.titleMedium),
        ],
      ),
    );
  }
}