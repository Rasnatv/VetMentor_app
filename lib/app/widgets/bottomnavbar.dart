import 'package:flutter/material.dart';

import '../core/constants/appcolors.dart';
import '../core/style/textstyle.dart';

class VetBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const VetBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.school_outlined, activeIcon: Icons.school_rounded, label: 'Colleges'),
    _NavItem(icon: Icons.work_outline, activeIcon: Icons.work_rounded, label: 'Careers'),
    _NavItem(icon: Icons.support_agent, activeIcon: Icons.support_agent_rounded, label: 'Mentor'),
    _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70+MediaQuery.of(context).padding.bottom,
      decoration: const BoxDecoration(
        color: AppColors.navBackground,
        border: Border(top: BorderSide(color: AppColors.borderLight, width: 1)),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (i) {
            final item = _items[i];
            final isActive = i == currentIndex;
            return GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primarySurface : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isActive ? item.activeIcon : item.icon,
                        color: isActive ? AppColors.navActive : AppColors.navInactive,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.label,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isActive ? AppColors.navActive : AppColors.navInactive,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}