
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';
import 'package:veterinaryapp/app/widgets/commonwidget.dart';

import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../data/models/notificationmodel.dart';
import '../controller/notificationcontroller.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());
    final r = Responsive.of(context);

    // Clear the unread dot as soon as the user opens this page.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.markAllAsRead();
    });

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: VetAppBar(title: 'Notifications'),
        body: Obx(() {
          if (controller.isLoading.value && controller.notifications.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (controller.errorMessage.value.isNotEmpty &&
              controller.notifications.isEmpty) {
            return _ErrorState(
              r: r,
              message: controller.errorMessage.value,
              onRetry: () => controller.fetchNotifications(),
            );
          }

          if (controller.notifications.isEmpty) {
            return _EmptyState(r: r);
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: controller.refreshNotifications,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              // ✅ bottom padding keeps the last item above the system nav bar
              padding: EdgeInsets.fromLTRB(
                r.spacing(AppDimens.paddingLG),
                r.spacing(AppDimens.paddingMD),
                r.spacing(AppDimens.paddingLG),
                r.spacing(24) + MediaQuery.of(context).padding.bottom,
              ),
              itemCount: controller.notifications.length,
              itemBuilder: (context, index) {
                final item = controller.notifications[index];
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: r.spacing(AppDimens.paddingSM + 4)),
                  child: _NotificationCard(
                    r: r,
                    item: item,
                    onTap: () {
                      controller.markAsRead(item);
                      _handleNotificationTap(item);
                    },
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  void _handleNotificationTap(NotificationItem item) {
    // Route based on notification type. Extend this as you add more types.
    switch (item.type) {
      case 'new_college':
        final collegeId = item.data?.collegeId;
        if (collegeId != null) {
          // Example: Get.toNamed('/college-detail', arguments: collegeId);
        }
        break;
      default:
        break;
    }
  }
}

// ── Notification card ─────────────────────────────────────────
class _NotificationCard extends StatelessWidget {
  final Responsive r;
  final NotificationItem item;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.r,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = _iconColor(item.type);
    final unread = !item.isRead;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG + 2),
        child: Ink(
          padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
          decoration: BoxDecoration(
            color: unread
                ? AppColors.primarySurface.withOpacity(0.55)
                : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppDimens.radiusLG + 2),
            border: Border.all(
              color: unread
                  ? AppColors.primary.withOpacity(0.25)
                  : AppColors.borderLight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.025),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gradient icon badge
              Container(
                width: r.spacing(48),
                height: r.spacing(48),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accent.withOpacity(0.20),
                      accent.withOpacity(0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppDimens.radiusMD + 4),
                ),
                child: Icon(_iconForType(item.type),
                    color: accent, size: r.fontSize(22)),
              ),
              SizedBox(width: r.spacing(AppDimens.paddingMD)),

              // Title + message + time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: AppTextStyles.titleLarge.copyWith(
                              fontSize: r.fontSize(14.5),
                              fontWeight:
                              unread ? FontWeight.w800 : FontWeight.w700,
                              letterSpacing: -0.1,
                              height: 1.3,
                            ),
                          ),
                        ),
                        if (unread) ...[
                          SizedBox(width: r.spacing(8)),
                          Container(
                            margin: EdgeInsets.only(top: r.spacing(5)),
                            width: r.spacing(9),
                            height: r.spacing(9),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0483A),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.cardBackground,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: r.spacing(4)),
                    Text(
                      item.message,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: r.fontSize(12.5),
                        height: 1.4,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: r.spacing(8)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time_rounded,
                            size: r.fontSize(12),
                            color:
                            AppColors.textSecondary.withOpacity(0.7)),
                        SizedBox(width: r.spacing(4)),
                        Text(
                          _formatTime(item.createdAt),
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: r.fontSize(11),
                            color: AppColors.textSecondary.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'new_college':
        return Icons.school_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _iconColor(String type) {
    switch (type) {
      case 'new_college':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

// ── Empty state ───────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final Responsive r;
  const _EmptyState({required this.r});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: r.spacing(84),
            height: r.spacing(84),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications_off_outlined,
                size: r.fontSize(38), color: AppColors.primary),
          ),
          SizedBox(height: r.spacing(AppDimens.paddingMD + 2)),
          Text(
            'No notifications yet',
            style: AppTextStyles.titleLarge.copyWith(
              fontSize: r.fontSize(16),
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: r.spacing(4)),
          Text(
            "We'll let you know when something new arrives",
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: r.fontSize(12.5),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error state ───────────────────────────────────────────────
class _ErrorState extends StatelessWidget {
  final Responsive r;
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.r,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: r.spacing(32)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded,
                size: r.fontSize(48), color: AppColors.textSecondary),
            SizedBox(height: r.spacing(AppDimens.paddingMD)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
            SizedBox(height: r.spacing(AppDimens.paddingMD)),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(AppDimens.radiusMD + 4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}