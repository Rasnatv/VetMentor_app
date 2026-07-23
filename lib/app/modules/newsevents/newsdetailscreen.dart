
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/appcolors.dart';
import '../../core/style/dimens.dart';
import '../../core/style/textstyle.dart';
import '../../core/utils/responsive utiliteclass.dart';
import '../../widgets/commonwidget.dart';
import 'controller/newsdetailcontroller.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newsId;

  const NewsDetailScreen({super.key, required this.newsId});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  late final NewsDetailController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(
      NewsDetailController(),
      tag: widget.newsId, // unique instance per news id
    );
    _ctrl.fetchNewsDetail(widget.newsId);
  }

  @override
  void dispose() {
    Get.delete<NewsDetailController>(tag: widget.newsId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VetAppBar(
        title: 'News Details',
        showBack: true,
      ),
      body: Obx(() {
        if (_ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_ctrl.hasError.value || _ctrl.newsDetail.value == null) {
          return _errorState(r);
        }

        final news = _ctrl.newsDetail.value!;

        return RefreshIndicator(
          onRefresh: () => _ctrl.fetchNewsDetail(widget.newsId),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(r.spacing(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (news.image.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      news.image,
                      height: r.spacing(200),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: r.spacing(200),
                        color: AppColors.backgroundGrey,
                        child: const Icon(Icons.image_not_supported_outlined),
                      ),
                    ),
                  ),
                if (news.image.isNotEmpty) SizedBox(height: r.spacing(16)),

                if (news.category.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: r.spacing(10),
                      vertical: r.spacing(4),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                    ),
                    child: Text(
                      news.category,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: r.fontSize(11.5),
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                SizedBox(height: r.spacing(10)),

                Text(
                  news.title,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontSize: r.fontSize(19),
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: r.spacing(8)),

                if (news.source.isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.newspaper_rounded,
                          size: r.fontSize(14), color: AppColors.textSecondary),
                      SizedBox(width: r.spacing(6)),
                      Expanded(
                        child: Text(
                          news.source,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: r.fontSize(12.5),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),

                if (news.publishedDate.isNotEmpty) ...[
                  SizedBox(height: r.spacing(4)),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          size: r.fontSize(14), color: AppColors.textSecondary),
                      SizedBox(width: r.spacing(6)),
                      Text(
                        news.publishedDate,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: r.fontSize(12.5),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],

                SizedBox(height: r.spacing(16)),
                Divider(color: AppColors.borderLight),
                SizedBox(height: r.spacing(16)),

                Text(
                  news.description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: r.fontSize(14),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _errorState(Responsive r) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded,
              size: r.fontSize(48), color: AppColors.textSecondary),
          SizedBox(height: r.spacing(12)),
          Text('Failed to load news details', style: AppTextStyles.bodyMedium),
          SizedBox(height: r.spacing(12)),
          ElevatedButton.icon(
            onPressed: () => _ctrl.fetchNewsDetail(widget.newsId),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusMD + 4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}