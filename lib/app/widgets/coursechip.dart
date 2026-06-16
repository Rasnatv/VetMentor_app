import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../core/constants/appcolors.dart';
import '../core/style/dimens.dart';
import '../core/style/textstyle.dart';
import '../core/utils/responsive utiliteclass.dart';
import '../data/models/coursemodel.dart';
import '../modules/courses/view/coursesscreen.dart';

Widget buildCourseChip(CourseModel course, Responsive r) {
  return GestureDetector(
    onTap: () => Get.to(() => CourseListingScreen()),
    child: Container(
      width: r.spacing(160),
      padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_rounded,
              color: AppColors.primary,
              size: r.fontSize(22)),
          SizedBox(height: r.spacing(6)),
          Text(
            course.courseName,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: r.fontSize(11),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}