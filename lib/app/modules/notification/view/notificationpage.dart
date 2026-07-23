// notification_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';
import 'package:veterinaryapp/app/widgets/commonwidget.dart';

import '../../../data/models/notificationmodel.dart';
import '../controller/notificationcontroller.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());

    // Clear the unread dot as soon as the user opens this page.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.markAllAsRead();
    });

    return  NetworkAwareWrapper(child: Scaffold(
      appBar: VetAppBar(title: 'Notifications',),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.notifications.isEmpty) {
          return _ErrorState(
            message: controller.errorMessage.value,
            onRetry: () => controller.fetchNotifications(),
          );
        }

        if (controller.notifications.isEmpty) {
          return const _EmptyState();
        }

        return RefreshIndicator(
          onRefresh: controller.refreshNotifications,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: controller.notifications.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = controller.notifications[index];
              return _NotificationTile(
                item: item,
                onTap: () {
                  controller.markAsRead(item);
                  _handleNotificationTap(item);
                },
              );
            },
          ),
        );
      }),
    ));
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

class _NotificationTile extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback onTap;

  const _NotificationTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: item.isRead ? null : Colors.blue.withOpacity(0.05),
      leading: CircleAvatar(
        backgroundColor: _iconColor(item.type).withOpacity(0.15),
        child: Icon(_iconForType(item.type), color: _iconColor(item.type)),
      ),
      title: Text(
        item.title,
        style: TextStyle(
          fontWeight: item.isRead ? FontWeight.normal : FontWeight.w700,
        ),
      ),
      subtitle: Text(item.message),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(item.createdAt),
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          if (!item.isRead) ...[
            const SizedBox(height: 6),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'new_college':
        return Icons.school;
      default:
        return Icons.notifications;
    }
  }

  Color _iconColor(String type) {
    switch (type) {
      case 'new_college':
        return Colors.blue;
      default:
        return Colors.grey;
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_off_outlined,
              size: 56, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'No notifications yet',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
          const SizedBox(height: 12),
          Text(message, style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}