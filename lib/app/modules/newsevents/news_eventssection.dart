
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';

import '../../core/constants/appcolors.dart';
import '../../core/style/dimens.dart';
import '../../core/style/textstyle.dart';
import '../../core/utils/responsive utiliteclass.dart';
import '../../data/models/eventmodel.dart';
import '../../data/models/newsmodel.dart';
import '../../widgets/commonwidget.dart';
import 'controller/eventcontroller.dart';
import 'controller/newscontroller.dart';
import 'newsdetailscreen.dart';

class NewsEventsScreen extends StatefulWidget {
  const NewsEventsScreen({super.key});

  @override
  State<NewsEventsScreen> createState() => _NewsEventsScreenState();
}

class _NewsEventsScreenState extends State<NewsEventsScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final TabController _tabCtrl;
  final NewsController _newsCtrl = Get.put(NewsController());
  final EventController _eventCtrl = Get.put(EventController());

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // required by AutomaticKeepAliveClientMixin
    final r = Responsive.of(context);

    return NetworkAwareWrapper(child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: VetAppBar(
        title: 'News & Events',
        showBack: false,
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          labelStyle: TextStyle(
            fontSize: r.fontSize(13.5),
            fontWeight: FontWeight.w700,
          ),
          tabs: const [
            Tab(text: 'News'),
            Tab(text: 'Events'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          RefreshIndicator(
            onRefresh: () => _newsCtrl.fetchNews(),
            child: _buildNewsTab(r),
          ),
          RefreshIndicator(
            onRefresh: () => _eventCtrl.fetchEvents(),
            child: _buildEventsTab(r),
          ),
        ],
      ),
    ));
  }
  Widget _buildNewsTab(Responsive r) {
    return Obx(() {
      if (_newsCtrl.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (_newsCtrl.hasError.value) {
        return _errorState(r, 'Failed to load news', _newsCtrl.fetchNews);
      }
      if (_newsCtrl.newsList.isEmpty) {
        return _emptyState(r, 'No news found.');
      }
      return ListView.separated(
        padding: EdgeInsets.all(r.spacing(16)),
        itemCount: _newsCtrl.newsList.length,
        separatorBuilder: (_, __) => SizedBox(height: r.spacing(12)),
        itemBuilder: (ctx, i) => _newsCard(_newsCtrl.newsList[i], r),
      );
    });
  }

  Widget _newsCard(NewsModel news, Responsive r) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Get.to(() => NewsDetailScreen(newsId: news.id));
      },
      child: Container(
        padding: EdgeInsets.all(r.spacing(14)),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(r.spacing(10)),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              ),
              child: Icon(Icons.newspaper_rounded,
                  color: AppColors.primary, size: r.fontSize(20)),
            ),
            SizedBox(width: r.spacing(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: AppTextStyles.titleLarge.copyWith(
                      fontSize: r.fontSize(14.5),
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                  SizedBox(height: r.spacing(6)),
                  Text(
                    news.source,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: r.fontSize(12),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.textSecondary, size: r.fontSize(20)),
          ],
        ),
      ),
    );
  }

  // ── Events tab ──────────────────────────────────────────
  Widget _buildEventsTab(Responsive r) {
    return Obx(() {
      if (_eventCtrl.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (_eventCtrl.hasError.value) {
        return _errorState(r, 'Failed to load events', _eventCtrl.fetchEvents);
      }
      if (_eventCtrl.eventList.isEmpty) {
        return _emptyState(r, 'No events found.');
      }
      return ListView.separated(
        padding: EdgeInsets.all(r.spacing(16)),
        itemCount: _eventCtrl.eventList.length,
        separatorBuilder: (_, __) => SizedBox(height: r.spacing(12)),
        itemBuilder: (ctx, i) => _eventCard(_eventCtrl.eventList[i], r),
      );
    });
  }

  Widget _eventCard(EventModel event, Responsive r) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event.image.isNotEmpty)
            Image.network(
              event.image,
              height: r.spacing(200),
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => SizedBox(
                height: r.spacing(180),
                child: const Icon(Icons.image_not_supported_outlined),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(r.spacing(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontSize: r.fontSize(14.5),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: r.spacing(6)),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: r.fontSize(13), color: AppColors.textSecondary),
                    SizedBox(width: r.spacing(6)),
                    Text(
                      '${event.startDate} → ${event.endDate}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: r.fontSize(11.5),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: r.spacing(4)),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded,
                        size: r.fontSize(13), color: AppColors.textSecondary),
                    SizedBox(width: r.spacing(6)),
                    Expanded(
                      child: Text(
                        event.location,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: r.fontSize(11.5),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: r.spacing(8)),
                Text(
                  event.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: r.fontSize(12),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Shared states ───────────────────────────────────────
  Widget _errorState(Responsive r, String msg, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded,
              size: r.fontSize(48), color: AppColors.textSecondary),
          SizedBox(height: r.spacing(12)),
          Text(msg, style: AppTextStyles.bodyMedium),
          SizedBox(height: r.spacing(12)),
          ElevatedButton.icon(
            onPressed: onRetry,
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

  Widget _emptyState(Responsive r, String msg) {
    return Center(child: Text(msg, style: AppTextStyles.bodyMedium));
  }
}