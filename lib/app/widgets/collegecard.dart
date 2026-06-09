import 'package:flutter/material.dart';

import '../core/constants/appcolors.dart';
import '../core/style/textstyle.dart';
import '../data/models/modelclass.dart';

import 'commonwidget.dart';

class CollegeCard extends StatelessWidget {
  final College college;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final bool isSaved;

  const CollegeCard({
    super.key,
    required this.college,
    this.onTap,
    this.onSave,
    this.isSaved = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CollegeAvatar(
              name: college.name,
              imageUrl: college.logoUrl,
              size: 52,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          college.name,
                          style: AppTextStyles.titleLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onSave,
                        child: Icon(
                          isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                          color: isSaved ? AppColors.primary : AppColors.textSecondary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textSecondary),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          college.location,
                          style: AppTextStyles.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      ...college.tags.map((tag) => _buildTag(tag)),
                      TagBadge(
                        label: college.established,
                        backgroundColor: AppColors.backgroundGrey,
                        textColor: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String tag) {
    if (tag == 'ICAR') return TagBadge.icar(tag);
    if (tag == 'Public') return TagBadge.public();
    if (tag == 'State') return TagBadge.state();
    return TagBadge(
      label: tag,
      backgroundColor: const Color(0xFFEDE7F6),
      textColor: const Color(0xFF6A1B9A),
    );
  }
}