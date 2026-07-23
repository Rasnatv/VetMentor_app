// notification_model.dart
//
// Model classes for the /api/notifications response.

class NotificationResponse {
  final bool status;
  final String statusCode;
  final String message;
  final List<NotificationItem> data;

  NotificationResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      // API sends status as a string "true"/"false", handle both bool & string safely.
      status: json['status'].toString().toLowerCase() == 'true',
      statusCode: json['status_code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type;
  final NotificationData? data;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Not part of the API payload — used locally to track read/unread state.
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.data,
    this.createdAt,
    this.updatedAt,
    this.isRead = false,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      data: json['data'] != null
          ? NotificationData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'data': data?.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class NotificationData {
  final String? collegeId;

  NotificationData({this.collegeId});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      collegeId: json['college_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'college_id': collegeId,
    };
  }
}